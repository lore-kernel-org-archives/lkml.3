Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab3E1X27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:28:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31954 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227Ab3E1X26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:28:58 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86: Fix adjust_range_size_mask calling position
Date: Tue, 28 May 2013 16:28:26 -0700
Message-Id: <1369783706-27327-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <CAE9FiQXr4S0P5P5JdegRyozSX4OCJ6+6MMybmAaMPCzfqe6yWg@mail.gmail.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8d57470d cause a kernel panic while setting mem=2G.
     [mem 0x00000000-0x000fffff] page 4k
     [mem 0x7fe00000-0x7fffffff] page 1G
     [mem 0x7c000000-0x7fdfffff] page 1G
     [mem 0x00100000-0x001fffff] page 4k
     [mem 0x00200000-0x7bffffff] page 2M

but for last entry we should have
     [mem 0x00200000-0x3fffffff] page 2M
     [mem 0x40000000-0x7bffffff] page 1G

Actually there is bug about calling sequence for
adjust_range_page_size_mask(). Merge first will make
adjust to 1g for second partial 1g range fail.

Fix that by calling adjust_range_size_mask before merging mem_range
with same page size.

We need this one for v3.9 stable.

Bisected-by: "Xie, ChanglongX" <changlongx.xie@intel.com>
Bisected-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Reported-and-tested-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/init.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init.c
+++ linux-2.6/arch/x86/mm/init.c
@@ -277,6 +277,9 @@ static int __meminit split_mem_range(str
 	end_pfn = limit_pfn;
 	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 
+	if (!after_bootmem)
+		adjust_range_page_size_mask(mr, nr_range);
+
 	/* try to merge same page size and continuous */
 	for (i = 0; nr_range > 1 && i < nr_range - 1; i++) {
 		unsigned long old_start;
@@ -291,9 +294,6 @@ static int __meminit split_mem_range(str
 		nr_range--;
 	}
 
-	if (!after_bootmem)
-		adjust_range_page_size_mask(mr, nr_range);
-
 	for (i = 0; i < nr_range; i++)
 		printk(KERN_DEBUG " [mem %#010lx-%#010lx] page %s\n",
 				mr[i].start, mr[i].end - 1,
