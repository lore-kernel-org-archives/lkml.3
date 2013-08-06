Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab3HFF2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:28:49 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:46862 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3HFF2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:28:47 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Aug 2013 01:28:47 EDT
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Jim Hull <jim.hull@hp.com>,
        Karel Zak <kzak@redhat.com>, Peter Jones <pjones@redhat.com>,
        Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 3/8] partitions/efi: do not require gpt partition to begin at sector 1
Date: Mon,  5 Aug 2013 22:21:11 -0700
Message-Id: <1375766476-4204-4-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
References: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When detecting a valid protective MBR, the Linux kernel isn't picky about
the partition (1-4) the 0xEE is at, but, unlike other operating systems,
it does require it to begin at the second sector (sector 1). This check, apart
from it not being enforced by UEFI, and causing Linux to potentially fail to detect
any *valid* partitions on the disk, can present problems when dealing with hybrid
MBRs[1].

For compatibility reasons, if the first partition is hybridized, the 0xEE
partition must be small enough to ensure that it only protects the GPT data
structures - as opposed to the the whole disk in a protective MBR.
This problem is very well described by Rod Smith[1]: where MBR-only partitioning
programs (such as older versions of fdisk) can see some of the disk space as
unallocated, thus loosing the purpose of the 0xEE partition's protection of GPT
data structures.

By dropping this check, this patch enables Linux to be more flexible when probing
for GPT disklabels.

[1] http://www.rodsbooks.com/gdisk/hybrid.html#reactions

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 block/partitions/efi.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 6a997b1..331cd1c 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -158,12 +158,9 @@ static inline int pmbr_part_valid(gpt_record *part)
         if (le32_to_cpu(part->starting_lba) != GPT_PRIMARY_PARTITION_TABLE_LBA)
                 goto invalid;
 
-        if (le32_to_cpu(part->start_sector) != 1UL)
-                goto invalid;
-
-        return 1;
+	return 1;
 invalid:
-        return 0;
+	return 0;
 }
 
 /**
-- 
1.7.11.7

