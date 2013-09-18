Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182Ab3IRAjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 20:39:09 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:44710 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3IRAjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 20:39:08 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 1/4] mm/hwpoison: fix traverse hugetlbfs page to avoid printk flood
Date: Wed, 18 Sep 2013 08:38:54 +0800
Message-Id: <1379464737-23592-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091800-2000-0000-0000-00000DC43C61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

madvise_hwpoison won't check if the page is small page or huge page and traverse
in small page granularity against the range unconditional, which result in a printk
flood "MCE xxx: already hardware poisoned" if the page is huge page. This patch fix
it by increase compound_order(compound_head(page)) for huge page iterator.

Testcase:

#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <errno.h>

#define PAGES_TO_TEST 3
#define PAGE_SIZE	4096 * 512

int main(void)
{
	char *mem;
	int i;

	mem = mmap(NULL, PAGES_TO_TEST * PAGE_SIZE,
			PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, 0, 0);

	if (madvise(mem, PAGES_TO_TEST * PAGE_SIZE, MADV_HWPOISON) == -1)
		return -1;

	munmap(mem, PAGES_TO_TEST * PAGE_SIZE);

	return 0;
}

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/madvise.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 6975bc8..539eeb9 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -343,10 +343,11 @@ static long madvise_remove(struct vm_area_struct *vma,
  */
 static int madvise_hwpoison(int bhv, unsigned long start, unsigned long end)
 {
+	struct page *p;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	for (; start < end; start += PAGE_SIZE) {
-		struct page *p;
+	for (; start < end; start += PAGE_SIZE <<
+				compound_order(compound_head(p))) {
 		int ret;
 
 		ret = get_user_pages_fast(start, 1, 0, &p);
-- 
1.7.5.4

