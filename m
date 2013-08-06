Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab3HFF3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:29:36 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:46920 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3HFF2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:28:48 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Jim Hull <jim.hull@hp.com>,
        Karel Zak <kzak@redhat.com>, Peter Jones <pjones@redhat.com>,
        Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 4/8] partitions/efi: detect hybrid MBRs
Date: Mon,  5 Aug 2013 22:21:12 -0700
Message-Id: <1375766476-4204-5-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
References: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the biggest problems with GPT is compatibility with older,
non-GPT systems. The problem is addressed by creating hybrid mbrs,
an extension, or variant, of the traditional protective mbr. This
contains, apart from the 0xEE partition, up three additional
primary partitions that point to the same space marked by up to
three GPT partitions. The result is that legacy OSs can see the
three required MBR partitions and at the same time ignore the
GPT-aware partitions that protect the GPT structures.

While hybrid MBRs are hacks, workarounds and simply not part of the
GPT standard, they do exist and we have no way around them. For instance,
by default, OSX creates a hybrid scheme when using multi-OS booting.

In order for Linux to properly discover protective MBRs, it must be
made aware of devices that have hybrid MBRs. No functionality is
changed by this patch, just a debug message informing the user of the
MBR scheme that is being used.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 block/partitions/efi.c | 72 +++++++++++++++++++++++++++++++++++---------------
 block/partitions/efi.h |  3 +++
 2 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 331cd1c..4bf8165 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -158,7 +158,7 @@ static inline int pmbr_part_valid(gpt_record *part)
         if (le32_to_cpu(part->starting_lba) != GPT_PRIMARY_PARTITION_TABLE_LBA)
                 goto invalid;
 
-	return 1;
+	return GPT_MBR_PROTECTIVE;
 invalid:
 	return 0;
 }
@@ -167,21 +167,47 @@ invalid:
  * is_pmbr_valid(): test Protective MBR for validity
  * @mbr: pointer to a legacy mbr structure
  *
- * Description: Returns 1 if PMBR is valid, 0 otherwise.
- * Validity depends on two things:
+ * Description: Checks for a valid protective or hybrid
+ * master boot record (MBR). The validity of a pMBR depends
+ * on all of the following properties:
  *  1) MSDOS signature is in the last two bytes of the MBR
  *  2) One partition of type 0xEE is found
+ *
+ * In addition, a hybrid MBR will have up to three additional
+ * primary partitions, which point to the same space that's
+ * marked out by up to three GPT partitions.
+ *
+ * Returns 0 upon invalid MBR, or GPT_MBR_PROTECTIVE or
+ * GPT_MBR_HYBRID depending on the device layout.
  */
-static int
-is_pmbr_valid(legacy_mbr *mbr)
+static int is_pmbr_valid(legacy_mbr *mbr)
 {
-	int i;
+	int i, ret = 0; /* invalid by default */
+
 	if (!mbr || le16_to_cpu(mbr->signature) != MSDOS_MBR_SIGNATURE)
-                return 0;
+		goto done;
+
+	for (i = 0; i < 4; i++) {
+		ret = pmbr_part_valid(&mbr->partition_record[i]);
+		if (ret == GPT_MBR_PROTECTIVE) {
+			/*
+			 * Ok, we at least know that there's a protective MBR,
+			 * now check if there are other partition types for
+			 * hybrid MBR.
+			 */
+			goto check_hybrid;
+		}
+	}
+
+	if (ret != GPT_MBR_PROTECTIVE)
+		goto done;
+check_hybrid:
 	for (i = 0; i < 4; i++)
-		if (pmbr_part_valid(&mbr->partition_record[i]))
-                        return 1;
-	return 0;
+		if ((mbr->partition_record[i].os_type != EFI_PMBR_OSTYPE_EFI_GPT) &&
+		    (mbr->partition_record[i].os_type != 0x00))
+			ret = GPT_MBR_HYBRID;
+done:
+	return ret;
 }
 
 /**
@@ -548,17 +574,21 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
 
 	lastlba = last_lba(state->bdev);
         if (!force_gpt) {
-                /* This will be added to the EFI Spec. per Intel after v1.02. */
-                legacymbr = kzalloc(sizeof (*legacymbr), GFP_KERNEL);
-                if (legacymbr) {
-                        read_lba(state, 0, (u8 *) legacymbr,
-				 sizeof (*legacymbr));
-                        good_pmbr = is_pmbr_valid(legacymbr);
-                        kfree(legacymbr);
-                }
-                if (!good_pmbr)
-                        goto fail;
-        }
+		/* This will be added to the EFI Spec. per Intel after v1.02. */
+		legacymbr = kzalloc(sizeof (*legacymbr), GFP_KERNEL);
+		if (!legacymbr)
+			goto fail;
+
+		read_lba(state, 0, (u8 *) legacymbr, sizeof (*legacymbr));
+		good_pmbr = is_pmbr_valid(legacymbr);
+		kfree(legacymbr);
+
+		if (!good_pmbr)
+			goto fail;
+
+		pr_debug("Device has a %s MBR\n",
+			 good_pmbr == GPT_MBR_PROTECTIVE ? "protective" : "hybrid");
+	}
 
 	good_pgpt = is_gpt_valid(state, GPT_PRIMARY_PARTITION_TABLE_LBA,
 				 &pgpt, &pptes);
diff --git a/block/partitions/efi.h b/block/partitions/efi.h
index 46cf1a4..e9741de 100644
--- a/block/partitions/efi.h
+++ b/block/partitions/efi.h
@@ -37,6 +37,9 @@
 #define EFI_PMBR_OSTYPE_EFI 0xEF
 #define EFI_PMBR_OSTYPE_EFI_GPT 0xEE
 
+#define GPT_MBR_PROTECTIVE  1
+#define GPT_MBR_HYBRID      2
+
 #define GPT_HEADER_SIGNATURE 0x5452415020494645ULL
 #define GPT_HEADER_REVISION_V1 0x00010000
 #define GPT_PRIMARY_PARTITION_TABLE_LBA 1
-- 
1.7.11.7

