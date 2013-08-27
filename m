Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3H0BbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:31:22 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:50633 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3H0BbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:31:21 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Tony Luck <tony.luck@intel.com>,
        gong.chen@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 1/3] mm/hwpoison: fix memory failure still hold reference count after unpoison empty zero page
Date: Tue, 27 Aug 2013 09:30:52 +0800
Message-Id: <1377567054-32442-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082701-5490-0000-0000-0000040BE2E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

madvise hwpoison inject will poison the read-only empty zero page if there is 
no write access before poison. Empty zero page reference count will be increased 
for hwpoison, subsequent poison zero page will return directly since page has
already been set PG_hwpoison, however, page reference count is still increased 
by get_user_pages_fast. The unpoison process will unpoison the empty zero page 
and decrease the reference count successfully for the fist time, however, 
subsequent unpoison empty zero page will return directly since page has already 
been unpoisoned and without decrease the page reference count of empty zero page.
This patch fix it by make madvise_hwpoison() put a page and return immediately
(without calling memory_failure() or soft_offline_page()) when the page is already 
hwpoisoned.

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
#define PAGE_SIZE	4096

int main(void)
{
	char *mem;
	int i;

	mem = mmap(NULL, PAGES_TO_TEST * PAGE_SIZE,
			PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);

	if (madvise(mem, PAGES_TO_TEST * PAGE_SIZE, MADV_HWPOISON) == -1)
		return -1;
	
	munmap(mem, PAGES_TO_TEST * PAGE_SIZE);

	return 0;
}

Add printk to dump page reference count:

[   93.075959] Injecting memory failure for page 0x19d0 at 0xb77d8000
[   93.076207] MCE 0x19d0: non LRU page recovery: Ignored
[   93.076209] pfn 0x19d0, page count = 1 after memory failure
[   93.076220] Injecting memory failure for page 0x19d0 at 0xb77d9000
[   93.076221] MCE 0x19d0: already hardware poisoned
[   93.076222] pfn 0x19d0, page count = 2 after memory failure
[   93.076224] Injecting memory failure for page 0x19d0 at 0xb77da000
[   93.076224] MCE 0x19d0: already hardware poisoned
[   93.076225] pfn 0x19d0, page count = 3 after memory failure

Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/madvise.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 212f5f1..0956ae9 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -352,6 +352,10 @@ static int madvise_hwpoison(int bhv, unsigned long start, unsigned long end)
 		int ret = get_user_pages_fast(start, 1, 0, &p);
 		if (ret != 1)
 			return ret;
+		if (PageHWPoison(p)) {
+			put_page(p);
+			continue;
+		}
 		if (bhv == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining page %#lx at %#lx\n",
 				page_to_pfn(p), start);
-- 
1.8.1.2

