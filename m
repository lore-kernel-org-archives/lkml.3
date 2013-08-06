Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3HFFVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:21:41 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:7134 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3HFFVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:21:39 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Jim Hull <jim.hull@hp.com>,
        Karel Zak <kzak@redhat.com>, Peter Jones <pjones@redhat.com>,
        Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 5/8] partitions/efi: account for pmbr size in lba
Date: Mon,  5 Aug 2013 22:21:13 -0700
Message-Id: <1375766476-4204-6-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
References: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The partition that has the 0xEE (GPT protective), must
have the size in lba field set to the lesser of the size
of the disk minus one or 0xFFFFFFFF for larger disks.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 block/partitions/efi.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 4bf8165..ab6cd08 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -166,6 +166,7 @@ invalid:
 /**
  * is_pmbr_valid(): test Protective MBR for validity
  * @mbr: pointer to a legacy mbr structure
+ * @total_sectors: amount of sectors in the device
  *
  * Description: Checks for a valid protective or hybrid
  * master boot record (MBR). The validity of a pMBR depends
@@ -180,9 +181,9 @@ invalid:
  * Returns 0 upon invalid MBR, or GPT_MBR_PROTECTIVE or
  * GPT_MBR_HYBRID depending on the device layout.
  */
-static int is_pmbr_valid(legacy_mbr *mbr)
+static int is_pmbr_valid(legacy_mbr *mbr, sector_t total_sectors)
 {
-	int i, ret = 0; /* invalid by default */
+	int i, part = 0, ret = 0; /* invalid by default */
 
 	if (!mbr || le16_to_cpu(mbr->signature) != MSDOS_MBR_SIGNATURE)
 		goto done;
@@ -190,6 +191,7 @@ static int is_pmbr_valid(legacy_mbr *mbr)
 	for (i = 0; i < 4; i++) {
 		ret = pmbr_part_valid(&mbr->partition_record[i]);
 		if (ret == GPT_MBR_PROTECTIVE) {
+			part = i;
 			/*
 			 * Ok, we at least know that there's a protective MBR,
 			 * now check if there are other partition types for
@@ -206,6 +208,18 @@ check_hybrid:
 		if ((mbr->partition_record[i].os_type != EFI_PMBR_OSTYPE_EFI_GPT) &&
 		    (mbr->partition_record[i].os_type != 0x00))
 			ret = GPT_MBR_HYBRID;
+
+	/*
+	 * Protective MBRs take up the lesser of the whole disk
+	 * or 2 TiB (32bit LBA), ignoring the rest of the disk.
+	 *
+	 * Hybrid MBRs do not necessarily comply with this.
+	 */
+	if (ret == GPT_MBR_PROTECTIVE) {
+		if (le32_to_cpu(mbr->partition_record[part].size_in_lba) !=
+		    min((uint32_t) total_sectors - 1, 0xFFFFFFFF))
+			ret = 0;
+	}
 done:
 	return ret;
 }
@@ -567,6 +581,7 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
 	gpt_header *pgpt = NULL, *agpt = NULL;
 	gpt_entry *pptes = NULL, *aptes = NULL;
 	legacy_mbr *legacymbr;
+	sector_t total_sectors = i_size_read(state->bdev->bd_inode) >> 9;
 	u64 lastlba;
 
 	if (!ptes)
@@ -580,7 +595,7 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
 			goto fail;
 
 		read_lba(state, 0, (u8 *) legacymbr, sizeof (*legacymbr));
-		good_pmbr = is_pmbr_valid(legacymbr);
+		good_pmbr = is_pmbr_valid(legacymbr, total_sectors);
 		kfree(legacymbr);
 
 		if (!good_pmbr)
-- 
1.7.11.7

