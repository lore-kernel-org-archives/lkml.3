Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbaCUSrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 14:47:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46372 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaCUSra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 14:47:30 -0400
Message-ID: <532C8941.4090104@codeaurora.org>
Date: Fri, 21 Mar 2014 11:47:29 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Circular locking dependency - DRM/CMA/MM/hotplug/...
References: <20140211183543.GK26684@n2100.arm.linux.org.uk> <52FB9602.1000805@samsung.com> <20140212163317.GQ26684@n2100.arm.linux.org.uk> <53036D51.2070502@samsung.com> <xa1t8ut8wc2f.fsf@mina86.com>
In-Reply-To: <xa1t8ut8wc2f.fsf@mina86.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/2014 9:44 AM, Michal Nazarewicz wrote:
>> On 2014-02-12 17:33, Russell King - ARM Linux wrote:
>>> What if we did these changes:
>>>
>>> struct page *dma_alloc_from_contiguous(struct device *dev, int count,
>>>                                         unsigned int align)
>>> {
>>> ...
>>>          mutex_lock(&cma_mutex);
>>> ...
>>>          for (;;) {
>>>                  pageno = bitmap_find_next_zero_area(cma->bitmap, cma->count,
>>>                                                      start, count, mask);
>>>                  if (pageno >= cma->count)
>>>                          break;
>>>
>>>                  pfn = cma->base_pfn + pageno;
>>> +               bitmap_set(cma->bitmap, pageno, count);
>>> +               mutex_unlock(&cma_mutex);
>>>                  ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA);
>>> +               mutex_lock(&cma_mutex);
>>>                  if (ret == 0) {
>>> -                       bitmap_set(cma->bitmap, pageno, count);
>>>                          page = pfn_to_page(pfn);
>>>                          break;
>>> -               } else if (ret != -EBUSY) {
>>> +		}
>>> +		bitmap_clear(cma->bitmap, pageno, count);
>>> +		if (ret != -EBUSY) {
>>>                          break;
>>>                  }
>>> ...
>>>          mutex_unlock(&cma_mutex);
>>>          pr_debug("%s(): returned %p\n", __func__, page);
>>>          return page;
>>> }
> 
> Like Marek said, this will fail if two concurrent calls to
> alloc_contig_range are made such that they operate on the same pageblock
> (which is possible as the allocated regions do not need to be pageblock
> aligned).
> 
> Another mutex could be added just for this one call, but as I understand
> this would not solve the problem.
> 
>>> bool dma_release_from_contiguous(struct device *dev, struct page *pages,
>>>                                   int count)
>>> {
>>> ...
>>> +       free_contig_range(pfn, count);
>>>          mutex_lock(&cma_mutex);
>>>          bitmap_clear(cma->bitmap, pfn - cma->base_pfn, count);
>>> -       free_contig_range(pfn, count);
>>>          mutex_unlock(&cma_mutex);
>>> ...
>>> }
> 
> This *should* be fine.  Didn't test it.
> 

I managed to hit a different deadlock that had a similar root cause.
I also managed to independently come up with a similar solution. This
has been tested somewhat but not in wide distribution.

Thanks,
Laura

----- 8< ------
>From 2aa000fbd4189d967c45c4f1ac5aee812ed83082 Mon Sep 17 00:00:00 2001
From: Laura Abbott <lauraa@codeaurora.org>
Date: Tue, 25 Feb 2014 11:01:19 -0800
Subject: [PATCH] cma: Remove potential deadlock situation

CMA locking is currently very coarse. The cma_mutex protects both
the bitmap and avoids concurrency with alloc_contig_range. There
are several situations which may result in a deadlock on the CMA
mutex currently, mostly involving AB/BA situations with alloc and
free. Fix this issue by protecting the bitmap with a mutex per CMA
region and use the existing mutex for protecting against concurrency
with alloc_contig_range.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 drivers/base/dma-contiguous.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 165c2c2..dfb48ef 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -37,6 +37,7 @@ struct cma {
 	unsigned long	base_pfn;
 	unsigned long	count;
 	unsigned long	*bitmap;
+	struct mutex	lock;
 };
 
 struct cma *dma_contiguous_default_area;
@@ -161,6 +162,7 @@ static int __init cma_activate_area(struct cma *cma)
 		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
 	} while (--i);
 
+	mutex_init(&cma->lock);
 	return 0;
 }
 
@@ -261,6 +263,13 @@ err:
 	return ret;
 }
 
+static void clear_cma_bitmap(struct cma *cma, unsigned long pfn, int count)
+{
+	mutex_lock(&cma->lock);
+	bitmap_clear(cma->bitmap, pfn - cma->base_pfn, count);
+	mutex_unlock(&cma->lock);
+}
+
 /**
  * dma_alloc_from_contiguous() - allocate pages from contiguous area
  * @dev:   Pointer to device for which the allocation is performed.
@@ -294,30 +303,41 @@ struct page *dma_alloc_from_contiguous(struct device *dev, int count,
 
 	mask = (1 << align) - 1;
 
-	mutex_lock(&cma_mutex);
 
 	for (;;) {
+		mutex_lock(&cma->lock);
 		pageno = bitmap_find_next_zero_area(cma->bitmap, cma->count,
 						    start, count, mask);
-		if (pageno >= cma->count)
+		if (pageno >= cma->count) {
+			mutex_unlock(&cma_mutex);
 			break;
+		}
+		bitmap_set(cma->bitmap, pageno, count);
+		/*
+		 * It's safe to drop the lock here. We've marked this region for
+		 * our exclusive use. If the migration fails we will take the
+		 * lock again and unmark it.
+		 */
+		mutex_unlock(&cma->lock);
 
 		pfn = cma->base_pfn + pageno;
+		mutex_lock(&cma_mutex);
 		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA);
+		mutex_unlock(&cma_mutex);
 		if (ret == 0) {
-			bitmap_set(cma->bitmap, pageno, count);
 			page = pfn_to_page(pfn);
 			break;
 		} else if (ret != -EBUSY) {
+			clear_cma_bitmap(cma, pfn, count);
 			break;
 		}
+		clear_cma_bitmap(cma, pfn, count);
 		pr_debug("%s(): memory range at %p is busy, retrying\n",
 			 __func__, pfn_to_page(pfn));
 		/* try again with a bit different memory target */
 		start = pageno + mask + 1;
 	}
 
-	mutex_unlock(&cma_mutex);
 	pr_debug("%s(): returned %p\n", __func__, page);
 	return page;
 }
@@ -350,10 +370,8 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 
 	VM_BUG_ON(pfn + count > cma->base_pfn + cma->count);
 
-	mutex_lock(&cma_mutex);
-	bitmap_clear(cma->bitmap, pfn - cma->base_pfn, count);
 	free_contig_range(pfn, count);
-	mutex_unlock(&cma_mutex);
+	clear_cma_bitmap(cma, pfn, count);
 
 	return true;
 }
-- 
Code Aurora Forum chooses to take this file under the GPL v 2 license only.
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
