Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab3JNLly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:41:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:40284 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab3JNLlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:41:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,492,1378882800"; 
   d="scan'208";a="416479906"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Davidlohr Bueso <davidlohr@hp.com>, Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Karel Zak <kzak@redhat.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2 for 3.12-rc6] Revert "partitions/efi: loosen check fot pmbr size in lba"
Date: Mon, 14 Oct 2013 14:41:48 +0300
Message-Id: <1381750909-20082-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This reverts commit 6b02fa59a7cf34c548eedee657b07ea6c54d3894.

This commit is fixing a commit which is going to be reverted. So revert this
one too since it becomes unneeded.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 block/partitions/efi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 1eb09ee..1a5ec9a 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -186,7 +186,6 @@ invalid:
  */
 static int is_pmbr_valid(legacy_mbr *mbr, sector_t total_sectors)
 {
-	uint32_t sz = 0;
 	int i, part = 0, ret = 0; /* invalid by default */
 
 	if (!mbr || le16_to_cpu(mbr->signature) != MSDOS_MBR_SIGNATURE)
@@ -217,15 +216,12 @@ check_hybrid:
 	/*
 	 * Protective MBRs take up the lesser of the whole disk
 	 * or 2 TiB (32bit LBA), ignoring the rest of the disk.
-	 * Some partitioning programs, nonetheless, choose to set
-	 * the size to the maximum 32-bit limitation, disregarding
-	 * the disk size.
 	 *
 	 * Hybrid MBRs do not necessarily comply with this.
 	 */
 	if (ret == GPT_MBR_PROTECTIVE) {
-		sz = le32_to_cpu(mbr->partition_record[part].size_in_lba);
-		if (sz != (uint32_t) total_sectors - 1 && sz != 0xFFFFFFFF)
+		if (le32_to_cpu(mbr->partition_record[part].size_in_lba) !=
+		    min((uint32_t) total_sectors - 1, 0xFFFFFFFF))
 			ret = 0;
 	}
 done:
-- 
1.8.1.4

