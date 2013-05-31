Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab3EaUnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:43:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33078 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3EaUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:43:35 -0400
Date: Fri, 31 May 2013 13:42:53 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-7de3d66b1387ddf5a37d9689e5eb8510fb75c765@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        changlongx.xie@intel.com, yinghai@kernel.org,
        yuanhan.liu@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, changlongx.xie@intel.com,
        yuanhan.liu@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1370015587-20835-1-git-send-email-yinghai@kernel.org>
References: <1370015587-20835-1-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix adjust_range_size_mask calling position
Git-Commit-ID: 7de3d66b1387ddf5a37d9689e5eb8510fb75c765
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7de3d66b1387ddf5a37d9689e5eb8510fb75c765
Gitweb:     http://git.kernel.org/tip/7de3d66b1387ddf5a37d9689e5eb8510fb75c765
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 31 May 2013 08:53:07 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 31 May 2013 13:21:32 -0700

x86: Fix adjust_range_size_mask calling position

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
Cc: <stable@vger.kernel.org> v3.9
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index eaac174..1f34e92 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -277,6 +277,9 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	end_pfn = limit_pfn;
 	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 
+	if (!after_bootmem)
+		adjust_range_page_size_mask(mr, nr_range);
+
 	/* try to merge same page size and continuous */
 	for (i = 0; nr_range > 1 && i < nr_range - 1; i++) {
 		unsigned long old_start;
@@ -291,9 +294,6 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 		nr_range--;
 	}
 
-	if (!after_bootmem)
-		adjust_range_page_size_mask(mr, nr_range);
-
 	for (i = 0; i < nr_range; i++)
 		printk(KERN_DEBUG " [mem %#010lx-%#010lx] page %s\n",
 				mr[i].start, mr[i].end - 1,
