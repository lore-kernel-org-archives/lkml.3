Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab3D3P27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:28:59 -0400
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:56091 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932354Ab3D3P24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:28:56 -0400
X-Greylist: delayed 762 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2013 11:28:56 EDT
Date: Tue, 30 Apr 2013 15:16:12 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Fix off by one error in slab.h
In-Reply-To: <201304300645.FCE37285.tVHJLSOMQFOFFO@I-love.SAKURA.ne.jp>
Message-ID: <0000013e5b83ec27-03a11e6a-157a-40ac-a65d-0281ee0d40fe-000000@email.amazonses.com>
References: <CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com> <517E8758.9040803@parallels.com> <0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com> <201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp>
 <0000013e56e9304a-1042a95a-d4dd-43c5-8b8a-c670f50ac54e-000000@email.amazonses.com> <201304300645.FCE37285.tVHJLSOMQFOFFO@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.30-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Fix off by one error in slab.h

We ran into some strange issues as a result of an off by one isse in slab.h

The root of the issue is the treatment of KMALLOC_SHIFT_HIGH that is confusing.

Make KMALLOC_SHIFT_HIGH the first unsupported size instead of the last supported.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/slab.h
===================================================================
--- linux.orig/include/linux/slab.h	2013-04-30 09:54:23.636533564 -0500
+++ linux/include/linux/slab.h	2013-04-30 10:10:35.676932866 -0500
@@ -176,8 +176,8 @@ struct kmem_cache {
  * to do various tricks to work around compiler limitations in order to
  * ensure proper constant folding.
  */
-#define KMALLOC_SHIFT_HIGH	((MAX_ORDER + PAGE_SHIFT - 1) <= 25 ? \
-				(MAX_ORDER + PAGE_SHIFT - 1) : 25)
+#define KMALLOC_SHIFT_HIGH	((MAX_ORDER + PAGE_SHIFT) <= 26 ? \
+				(MAX_ORDER + PAGE_SHIFT) : 26)
 #define KMALLOC_SHIFT_MAX	KMALLOC_SHIFT_HIGH
 #define KMALLOC_SHIFT_LOW	5
 #else
@@ -185,7 +185,7 @@ struct kmem_cache {
  * SLUB allocates up to order 2 pages directly and otherwise
  * passes the request to the page allocator.
  */
-#define KMALLOC_SHIFT_HIGH	(PAGE_SHIFT + 1)
+#define KMALLOC_SHIFT_HIGH	(PAGE_SHIFT + 2)
 #define KMALLOC_SHIFT_MAX	(MAX_ORDER + PAGE_SHIFT)
 #define KMALLOC_SHIFT_LOW	3
 #endif
@@ -193,7 +193,7 @@ struct kmem_cache {
 /* Maximum allocatable size */
 #define KMALLOC_MAX_SIZE	(1UL << KMALLOC_SHIFT_MAX)
 /* Maximum size for which we actually use a slab cache */
-#define KMALLOC_MAX_CACHE_SIZE	(1UL << KMALLOC_SHIFT_HIGH)
+#define KMALLOC_MAX_CACHE_SIZE	((1UL << (KMALLOC_SHIFT_HIGH -1)))
 /* Maximum order allocatable via the slab allocagtor */
 #define KMALLOC_MAX_ORDER	(KMALLOC_SHIFT_MAX - PAGE_SHIFT)

@@ -206,9 +206,9 @@ struct kmem_cache {
 #define KMALLOC_MIN_SIZE (1 << KMALLOC_SHIFT_LOW)
 #endif

-extern struct kmem_cache *kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];
+extern struct kmem_cache *kmalloc_caches[KMALLOC_SHIFT_HIGH];
 #ifdef CONFIG_ZONE_DMA
-extern struct kmem_cache *kmalloc_dma_caches[KMALLOC_SHIFT_HIGH + 1];
+extern struct kmem_cache *kmalloc_dma_caches[KMALLOC_SHIFT_HIGH];
 #endif

 /*
Index: linux/mm/slab_common.c
===================================================================
--- linux.orig/mm/slab_common.c	2013-04-30 09:54:23.636533564 -0500
+++ linux/mm/slab_common.c	2013-04-30 09:54:53.693039252 -0500
@@ -319,11 +319,11 @@ struct kmem_cache *__init create_kmalloc
 	return s;
 }

-struct kmem_cache *kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];
+struct kmem_cache *kmalloc_caches[KMALLOC_SHIFT_HIGH];
 EXPORT_SYMBOL(kmalloc_caches);

 #ifdef CONFIG_ZONE_DMA
-struct kmem_cache *kmalloc_dma_caches[KMALLOC_SHIFT_HIGH + 1];
+struct kmem_cache *kmalloc_dma_caches[KMALLOC_SHIFT_HIGH];
 EXPORT_SYMBOL(kmalloc_dma_caches);
 #endif

@@ -446,7 +446,7 @@ void __init create_kmalloc_caches(unsign
 	if (KMALLOC_MIN_SIZE <= 64 && !kmalloc_caches[2])
 		kmalloc_caches[2] = create_kmalloc_cache(NULL, 192, flags);

-	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++)
+	for (i = KMALLOC_SHIFT_LOW; i < KMALLOC_SHIFT_HIGH; i++)
 		if (!kmalloc_caches[i])
 			kmalloc_caches[i] = create_kmalloc_cache(NULL,
 							1 << i, flags);
@@ -454,7 +454,7 @@ void __init create_kmalloc_caches(unsign
 	/* Kmalloc array is now usable */
 	slab_state = UP;

-	for (i = 0; i <= KMALLOC_SHIFT_HIGH; i++) {
+	for (i = 0; i < KMALLOC_SHIFT_HIGH; i++) {
 		struct kmem_cache *s = kmalloc_caches[i];
 		char *n;

@@ -467,7 +467,7 @@ void __init create_kmalloc_caches(unsign
 	}

 #ifdef CONFIG_ZONE_DMA
-	for (i = 0; i <= KMALLOC_SHIFT_HIGH; i++) {
+	for (i = 0; i < KMALLOC_SHIFT_HIGH; i++) {
 		struct kmem_cache *s = kmalloc_caches[i];

 		if (s) {
