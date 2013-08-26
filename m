Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab3HZIql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:46:41 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:57760 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab3HZIqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:46:39 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 8/10] mm/hwpoison: fix memory failure still hold reference count after unpoison empty zero page 
Date: Mon, 26 Aug 2013 16:46:12 +0800
Message-Id: <1377506774-5377-8-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377506774-5377-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1377506774-5377-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082608-5140-0000-0000-000003BA1DD8
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
This patch fix it by decrease page reference count for empty zero page which has 
already been unpoisoned and page count > 1.

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

Before patch:

[  139.197474] MCE: Software-unpoisoned page 0x19d0
[  139.197479] pfn 0x19d0, page count = 2 after unpoison memory
[  150.478130] MCE: Page was already unpoisoned 0x19d0
[  150.478135] pfn 0x19d0, page count = 2 after unpoison memory
[  151.548288] MCE: Page was already unpoisoned 0x19d0
[  151.548292] pfn 0x19d0, page count = 2 after unpoison memory

After patch:

[  116.022122] MCE: Software-unpoisoned page 0x19d0
[  116.022127] pfn 0x19d0, page count = 2 after unpoison memory
[  117.256163] MCE: Page was already unpoisoned 0x19d0
[  117.256167] pfn 0x19d0, page count = 1 after unpoison memory
[  117.917772] MCE: Page was already unpoisoned 0x19d0
[  117.917777] pfn 0x19d0, page count = 1 after unpoison memory

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/memory-failure.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ca714ac..fb687fd 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1335,6 +1335,8 @@ int unpoison_memory(unsigned long pfn)
 	page = compound_head(p);
 
 	if (!PageHWPoison(p)) {
+		if (pfn == my_zero_pfn(0) && page_count(p) > 1)
+			put_page(p);
 		pr_info("MCE: Page was already unpoisoned %#lx\n", pfn);
 		return 0;
 	}
-- 
1.8.1.2

