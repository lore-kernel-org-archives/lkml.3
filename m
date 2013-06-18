Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab3FRQWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:22:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933265Ab3FRQSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:00 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 30/48] x86: Fix adjust_range_size_mask calling position
Date: Tue, 18 Jun 2013 09:17:56 -0700
Message-Id: <20130618161730.256025232@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 7de3d66b1387ddf5a37d9689e5eb8510fb75c765 upstream.

Commit

    8d57470d x86, mm: setup page table in top-down

causes a kernel panic while setting mem=2G.

     [mem 0x00000000-0x000fffff] page 4k
     [mem 0x7fe00000-0x7fffffff] page 1G
     [mem 0x7c000000-0x7fdfffff] page 1G
     [mem 0x00100000-0x001fffff] page 4k
     [mem 0x00200000-0x7bffffff] page 2M

for last entry is not what we want, we should have
     [mem 0x00200000-0x3fffffff] page 2M
     [mem 0x40000000-0x7bffffff] page 1G

Actually we merge the continuous ranges with same page size too early.
in this case, before merging we have
     [mem 0x00200000-0x3fffffff] page 2M
     [mem 0x40000000-0x7bffffff] page 2M
after merging them, will get
     [mem 0x00200000-0x7bffffff] page 2M
even we can use 1G page to map
     [mem 0x40000000-0x7bffffff]

that will cause problem, because we already map
     [mem 0x7fe00000-0x7fffffff] page 1G
     [mem 0x7c000000-0x7fdfffff] page 1G
with 1G page, aka [0x40000000-0x7fffffff] is mapped with 1G page already.
During phys_pud_init() for [0x40000000-0x7bffffff], it will not
reuse existing that pud page, and allocate new one then try to use
2M page to map it instead, as page_size_mask does not include
PG_LEVEL_1G. At end will have [7c000000-0x7fffffff] not mapped, loop
in phys_pmd_init stop mapping at 0x7bffffff.

That is right behavoir, it maps exact range with exact page size that
we ask, and we should explicitly call it to map [7c000000-0x7fffffff]
before or after mapping 0x40000000-0x7bffffff.
Anyway we need to make sure ranges' page_size_mask correct and consistent
after split_mem_range for each range.

Fix that by calling adjust_range_size_mask before merging range
with same page size.

-v2: update change log.
-v3: add more explanation why [7c000000-0x7fffffff] is not mapped, and
    it causes panic.

Bisected-by: "Xie, ChanglongX" <changlongx.xie@intel.com>
Bisected-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Reported-and-tested-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1370015587-20835-1-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
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


