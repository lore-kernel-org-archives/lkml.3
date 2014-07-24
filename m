Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934555AbaGXTvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:51:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934311AbaGXTvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:51:21 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Chen Yucong <slaoub@gmail.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH 1/2] hwpoison: fix hugetlbfs/thp precheck in hwpoison_user_mappings()
Date: Thu, 24 Jul 2014 15:50:52 -0400
Message-Id: <1406231453-27928-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent fix from Chen Yucong (commit 0bc1f8b0682c "hwpoison: fix the handling
path of the victimized page frame that belong to non-LRU") rejects going
into unmapping operation for hugetlbfs/thp pages, which results in failing
error containing on such pages. This patch fixes it.

With this patch, hwpoison functional tests in mce-test testsuite pass.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/memory-failure.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git mmotm-2014-07-22-15-58.orig/mm/memory-failure.c mmotm-2014-07-22-15-58/mm/memory-failure.c
index e3e2f007946e..f465b98d0209 100644
--- mmotm-2014-07-22-15-58.orig/mm/memory-failure.c
+++ mmotm-2014-07-22-15-58/mm/memory-failure.c
@@ -895,7 +895,13 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	struct page *hpage = *hpagep;
 	struct page *ppage;
 
-	if (PageReserved(p) || PageSlab(p) || !PageLRU(p))
+	/*
+	 * Here we are interested only in user-mapped pages, so skip any
+	 * other types of pages.
+	 */
+	if (PageReserved(p) || PageSlab(p))
+		return SWAP_SUCCESS;
+	if (!(PageLRU(hpage) || PageHuge(p)))
 		return SWAP_SUCCESS;
 
 	/*
-- 
1.9.3

