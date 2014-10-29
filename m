Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaJ2E5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 00:57:21 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60684 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaJ2E5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 00:57:19 -0400
X-Original-SENDERIP: 10.186.123.76
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <545073AB.5060502@lge.com>
Date: Wed, 29 Oct 2014 13:57:15 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, john.stultz@linaro.org, rebecca@android.com,
        lauraa@codeaurora.org, dan.carpenter@oracle.com,
        Minchan Kim <minchan@kernel.org>,
        =?EUC-KR?B?J7Howdi89ic=?= <iamjoonsoo.kim@lge.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com, gioh.kim@lge.com
Subject: [RFC] stating: ion: use hot page first in pool
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I found that ion insert freed-page at the tail of list
and extract at the head.

I think it is good for cache to use the most recently used page
but these pages in pool are not cached memory.
So I'm not sure using hot page is better or not in this case.

What do you think about using hot page first?

-------------------------- 8< -----------------------------

>From 14c8455cc80628e56a27ace9603d29e5056835b5 Mon Sep 17 00:00:00 2001
From: Gioh Kim <gioh.kim@lge.com>
Date: Wed, 29 Oct 2014 13:44:28 +0900
Subject: [PATCH] staging: ion: use hot-page first

A page near the head is hot for cache.
This patch makes pool use hot page first.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 drivers/staging/android/ion/ion_page_pool.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index 5864f3d..3d6ac4f 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -45,10 +45,10 @@ static int ion_page_pool_add(struct ion_page_pool *pool, struct page *page)
 {
        mutex_lock(&pool->mutex);
        if (PageHighMem(page)) {
-               list_add_tail(&page->lru, &pool->high_items);
+               list_add(&page->lru, &pool->high_items);
                pool->high_count++;
        } else {
-               list_add_tail(&page->lru, &pool->low_items);
+               list_add(&page->lru, &pool->low_items);
                pool->low_count++;
        }
        mutex_unlock(&pool->mutex);
--
1.7.9.5

