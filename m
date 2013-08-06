Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab3HFF2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:28:52 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:46905 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab3HFF2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:28:48 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Jim Hull <jim.hull@hp.com>,
        Karel Zak <kzak@redhat.com>, Peter Jones <pjones@redhat.com>,
        Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 2/8] partitions/efi: check pmbr record's starting lba
Date: Mon,  5 Aug 2013 22:21:10 -0700
Message-Id: <1375766476-4204-3-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
References: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per the UEFI Specs 2.4, June 2013, the starting lba of the partition
that has the EFI GPT (0xEE) must be set to 0x00000001 - this is obviously
the LBA of the GPT Partition Header.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 block/partitions/efi.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 3ebd3d8..6a997b1 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -151,9 +151,18 @@ static u64 last_lba(struct block_device *bdev)
 
 static inline int pmbr_part_valid(gpt_record *part)
 {
-        if (part->os_type == EFI_PMBR_OSTYPE_EFI_GPT &&
-            le32_to_cpu(part->start_sector) == 1UL)
-                return 1;
+        if (part->os_type != EFI_PMBR_OSTYPE_EFI_GPT)
+                goto invalid;
+
+        /* set to 0x00000001 (i.e., the LBA of the GPT Partition Header) */
+        if (le32_to_cpu(part->starting_lba) != GPT_PRIMARY_PARTITION_TABLE_LBA)
+                goto invalid;
+
+        if (le32_to_cpu(part->start_sector) != 1UL)
+                goto invalid;
+
+        return 1;
+invalid:
         return 0;
 }
 
-- 
1.7.11.7

