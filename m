Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbaKUQTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:19:01 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61348 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177AbaKUQTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:19:00 -0500
From: Mahendran Ganesh <opensource.ganesh@gmail.com>
To: minchan@kernel.org, ngupta@vflare.org, ddstreet@ieee.org,
        sergey.senozhatsky@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mahendran Ganesh <opensource.ganesh@gmail.com>
Subject: [PATCH] mm/zsmalloc: support max obj with length of PAGE_SIZE
Date: Sat, 22 Nov 2014 00:18:39 +0800
Message-Id: <1416586719-10125-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-21 18:32 GMT+08:00 Minchan Kim <minchan@kernel.org>:
> On Fri, Nov 21, 2014 at 06:48:49AM +0000, Minchan Kim wrote:
>> On Fri, Nov 21, 2014 at 01:33:26PM +0800, Ganesh Mahendran wrote:
>> > Hello
>> >
>> > 2014-11-21 11:54 GMT+08:00 Minchan Kim <minchan@kernel.org>:
>> > > On Thu, Nov 20, 2014 at 09:21:56PM +0800, Mahendran Ganesh wrote:
>> > >> ZS_SIZE_CLASSES is calc by:
>> > >>   ((ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) / ZS_SIZE_CLASS_DELTA + 1)
>> > >>
>> > >> So when i is in [0, ZS_SIZE_CLASSES - 1), the size:
>> > >>   size = ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA
>> > >> will not be greater than ZS_MAX_ALLOC_SIZE
>> > >>
>> > >> This patch removes the unnecessary check.
>> > >
>> > > It depends on ZS_MIN_ALLOC_SIZE.
>> > > For example, we would change min to 8 but MAX is still 4096.
>> > > ZS_SIZE_CLASSES is (4096 - 8) / 16 + 1 = 256 so 8 + 255 * 16 = 4088,
>> > > which exceeds the max.
>> > Here, 4088 is less than MAX(4096).
>> >
>> > ZS_SIZE_CLASSES = (MAX - MIN) / Delta + 1
>> > So, I think the value of
>> >     MIN + (ZS_SIZE_CLASSES - 1) * Delta =
>> >     MIN + ((MAX - MIN) / Delta) * Delta =
>> >     MAX
>> > will not exceed the MAX
>>
>> You're right. It was complext math for me.
>> I should go back to elementary school.
>>
>> Thanks!
>>
>> Acked-by: Minchan Kim <minchan@kernel.org>
>
> I catch a nasty cold but above my poor math makes me think more.
> ZS_SIZE_CLASSES is broken. In above my example, current code cannot
> allocate 4096 size class so we should correct ZS_SIZE_CLASSES
> at first.
>
> zs_size_classes = zs_max - zs_min / delta + 1;
> if ((zs_max - zs_min) % delta)
>         zs_size_classes += 1;
>
> Then, we need to code piece you removed.
> As well, we need to fix below.
>
> - area->vm_buf = (char *)__get_free_page(GFP_KERNEL);
> + area->vm_buf = kmalloc(ZS_MAX_ALLOC_SIZE);
>
> Hope I am sane in this time :(

how about something like this?

In zsmalloc, if ZS_MIN_ALLOC_SIZE is less than ZS_SIZE_CLASS_DELTA.
Max obj size (ZS_MIN_ALLOC_SIZE + ZS_SIZE_CLASSES * ZS_SIZE_CLASS_DELTA)
will be less than ZS_MAX_ALLOC_SIZE(page size).
And in zs_malloc(), we thought we can put an obj(len == PAGE_SIZE)
into zsmalloc. But actually we can not. This will make user confused.

This patch takes Minchan Kim's suggestion.
    https://lkml.org/lkml/2014/11/21/172

When (ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) % ZS_SIZE_CLASS_DELTA) != 0,
we add increase sz_size_class by 1 to make the size of max obj equal to
ZS_MAX_ALLOC_SIZE(PAGE_SIZE).

Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
---
 mm/zsmalloc.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 810eda1..bcea72d 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -155,8 +155,6 @@
  *  (reason above)
  */
 #define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> 8)
-#define ZS_SIZE_CLASSES		((ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) / \
-					ZS_SIZE_CLASS_DELTA + 1)
 
 /*
  * We do not maintain any list for completely empty or full pages
@@ -214,7 +212,8 @@ struct link_free {
 };
 
 struct zs_pool {
-	struct size_class *size_class[ZS_SIZE_CLASSES];
+	struct size_class **size_class;
+	int nr_size_classes;
 
 	gfp_t flags;	/* allocation flags used when growing pool */
 	atomic_long_t pages_allocated;
@@ -956,17 +955,28 @@ struct zs_pool *zs_create_pool(gfp_t flags)
 {
 	int i, ovhd_size;
 	struct zs_pool *pool;
+	int nr;
 
 	ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);
 	pool = kzalloc(ovhd_size, GFP_KERNEL);
 	if (!pool)
 		return NULL;
 
+	nr = (ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) / ZS_SIZE_CLASS_DELTA + 1;
+	if ((ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) % ZS_SIZE_CLASS_DELTA)
+		nr += 1;
+
+	pool->size_class = kcalloc(nr, sizeof(struct size_class *),
+			GFP_KERNEL);
+	if (!pool->size_class)
+		goto err;
+	pool->nr_size_classes = nr;
+
 	/*
 	 * Iterate reversly, because, size of size_class that we want to use
 	 * for merging should be larger or equal to current size.
 	 */
-	for (i = ZS_SIZE_CLASSES - 1; i >= 0; i--) {
+	for (i = pool->nr_size_classes - 1; i >= 0; i--) {
 		int size;
 		int pages_per_zspage;
 		struct size_class *class;
@@ -1020,7 +1030,7 @@ void zs_destroy_pool(struct zs_pool *pool)
 {
 	int i;
 
-	for (i = 0; i < ZS_SIZE_CLASSES; i++) {
+	for (i = 0; i < pool->nr_size_classes; i++) {
 		int fg;
 		struct size_class *class = pool->size_class[i];
 
@@ -1038,6 +1048,8 @@ void zs_destroy_pool(struct zs_pool *pool)
 		}
 		kfree(class);
 	}
+
+	kfree(pool->size_class);
 	kfree(pool);
 }
 EXPORT_SYMBOL_GPL(zs_destroy_pool);
-- 
1.7.9.5

