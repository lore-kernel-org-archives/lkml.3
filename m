Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab3JNLl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:41:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:40284 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036Ab3JNLlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:41:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,492,1378882800"; 
   d="scan'208";a="416479917"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Davidlohr Bueso <davidlohr@hp.com>, Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Karel Zak <kzak@redhat.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2 for 3.12-rc6] Revert "partitions/efi: account for pmbr size in lba"
Date: Mon, 14 Oct 2013 14:41:49 +0300
Message-Id: <1381750909-20082-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381750909-20082-1-git-send-email-dedekind1@gmail.com>
References: <1381750909-20082-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This reverts commit 27a7c642174eaec627f6a3a254035bf8abd02c5e.

This patch breaks existing systems, for example, Tizen IVI images do not boot
the way they have always been booted because of this patch.

Here is the (pretty standard) use-case:

1. We create a 4GiB image with GPT partition. At this point the protective MBR
   partition contains correct 'size_in_lba'.
2. We dd this image to an 8GiB USB stick and try to boot off this USB stick.

Expected outcome:
  The kernel complains that the alternate GPT header is not at the end of the
  disk, but accepts/parses it anyway and the system boots.

With this patch:
  The kernel just does not recognize the partition table and the system fails
  to boot.

Ther root-cause is the size check introduced in the commit which is being
reverted. That commit does not explain which problem it solves, so I guess this
is more about "hardening" the GPT parser, which does not sound like a good
reason for breaking existing setups, so I think it is best to just revert this
change.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Tested-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 block/partitions/efi.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 1a5ec9a..f5716b8 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -169,7 +169,6 @@ invalid:
 /**
  * is_pmbr_valid(): test Protective MBR for validity
  * @mbr: pointer to a legacy mbr structure
- * @total_sectors: amount of sectors in the device
  *
  * Description: Checks for a valid protective or hybrid
  * master boot record (MBR). The validity of a pMBR depends
@@ -184,9 +183,9 @@ invalid:
  * Returns 0 upon invalid MBR, or GPT_MBR_PROTECTIVE or
  * GPT_MBR_HYBRID depending on the device layout.
  */
-static int is_pmbr_valid(legacy_mbr *mbr, sector_t total_sectors)
+static int is_pmbr_valid(legacy_mbr *mbr)
 {
-	int i, part = 0, ret = 0; /* invalid by default */
+	int i, ret = 0; /* invalid by default */
 
 	if (!mbr || le16_to_cpu(mbr->signature) != MSDOS_MBR_SIGNATURE)
 		goto done;
@@ -194,7 +193,6 @@ static int is_pmbr_valid(legacy_mbr *mbr, sector_t total_sectors)
 	for (i = 0; i < 4; i++) {
 		ret = pmbr_part_valid(&mbr->partition_record[i]);
 		if (ret == GPT_MBR_PROTECTIVE) {
-			part = i;
 			/*
 			 * Ok, we at least know that there's a protective MBR,
 			 * now check if there are other partition types for
@@ -212,18 +210,6 @@ check_hybrid:
 			EFI_PMBR_OSTYPE_EFI_GPT) &&
 		    (mbr->partition_record[i].os_type != 0x00))
 			ret = GPT_MBR_HYBRID;
-
-	/*
-	 * Protective MBRs take up the lesser of the whole disk
-	 * or 2 TiB (32bit LBA), ignoring the rest of the disk.
-	 *
-	 * Hybrid MBRs do not necessarily comply with this.
-	 */
-	if (ret == GPT_MBR_PROTECTIVE) {
-		if (le32_to_cpu(mbr->partition_record[part].size_in_lba) !=
-		    min((uint32_t) total_sectors - 1, 0xFFFFFFFF))
-			ret = 0;
-	}
 done:
 	return ret;
 }
@@ -582,7 +568,6 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
 	gpt_header *pgpt = NULL, *agpt = NULL;
 	gpt_entry *pptes = NULL, *aptes = NULL;
 	legacy_mbr *legacymbr;
-	sector_t total_sectors = i_size_read(state->bdev->bd_inode) >> 9;
 	u64 lastlba;
 
 	if (!ptes)
@@ -596,7 +581,7 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
 			goto fail;
 
 		read_lba(state, 0, (u8 *)legacymbr, sizeof(*legacymbr));
-		good_pmbr = is_pmbr_valid(legacymbr, total_sectors);
+		good_pmbr = is_pmbr_valid(legacymbr);
 		kfree(legacymbr);
 
 		if (!good_pmbr)
-- 
1.8.1.4

