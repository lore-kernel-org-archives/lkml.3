Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab3HWTJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:09:00 -0400
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:40408 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756346Ab3HWTI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:08:59 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2013 15:08:59 EDT
Message-ID: <00000140ac8e693e-c2132f75-384b-493a-9dd3-9d0d5f7e8174-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Fri, 23 Aug 2013 19:02:28 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv 06/16] staging: Convert __get_cpu_var uses
References: <20130823190135.726207430@linux.com>
X-SES-Outgoing: 2013.08.23-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/staging/zcache/ramster/ramster.c
===================================================================
--- linux.orig/drivers/staging/zcache/ramster/ramster.c	2013-08-22 14:14:40.400841754 -0500
+++ linux/drivers/staging/zcache/ramster/ramster.c	2013-08-22 14:15:51.000000000 -0500
@@ -82,7 +82,7 @@ static struct flushlist_node *ramster_fl
 	struct flushlist_node *flnode = NULL;
 	struct ramster_preload *kp;
 
-	kp = &__get_cpu_var(ramster_preloads);
+	kp = this_cpu_ptr(&ramster_preloads);
 	flnode = kp->flnode;
 	BUG_ON(flnode == NULL);
 	kp->flnode = NULL;
@@ -109,7 +109,7 @@ int ramster_do_preload_flnode(struct tme
 	BUG_ON(!irqs_disabled());
 	if (unlikely(ramster_flnode_cache == NULL))
 		BUG();
-	kp = &__get_cpu_var(ramster_preloads);
+	kp = this_cpu_ptr(&ramster_preloads);
 	flnode = kmem_cache_alloc(ramster_flnode_cache, GFP_ATOMIC);
 	if (unlikely(flnode == NULL) && kp->flnode == NULL)
 		BUG();  /* FIXME handle more gracefully, but how??? */
@@ -478,8 +478,8 @@ int ramster_remotify_pageframe(bool eph)
 	struct tmem_handle th[2];
 	unsigned int zsize[2];
 
-	tmpmem[0] = __get_cpu_var(ramster_remoteputmem1);
-	tmpmem[1] = __get_cpu_var(ramster_remoteputmem2);
+	tmpmem[0] = __this_cpu_read(ramster_remoteputmem1);
+	tmpmem[1] = __this_cpu_read(ramster_remoteputmem2);
 	local_bh_disable();
 	zbuds = zbud_make_zombie_lru(&th[0], &tmpmem[0], &zsize[0], eph);
 	/* now OK to release lock set in caller */
Index: linux/drivers/staging/zcache/zcache-main.c
===================================================================
--- linux.orig/drivers/staging/zcache/zcache-main.c	2013-08-22 14:14:40.400841754 -0500
+++ linux/drivers/staging/zcache/zcache-main.c	2013-08-22 14:15:51.000000000 -0500
@@ -250,7 +250,7 @@ static struct tmem_objnode *zcache_objno
 	struct zcache_preload *kp;
 	int i;
 
-	kp = &__get_cpu_var(zcache_preloads);
+	kp = this_cpu_ptr(&zcache_preloads);
 	for (i = 0; i < ARRAY_SIZE(kp->objnodes); i++) {
 		objnode = kp->objnodes[i];
 		if (objnode != NULL) {
@@ -275,7 +275,7 @@ static struct tmem_obj *zcache_obj_alloc
 	struct tmem_obj *obj = NULL;
 	struct zcache_preload *kp;
 
-	kp = &__get_cpu_var(zcache_preloads);
+	kp = this_cpu_ptr(&zcache_preloads);
 	obj = kp->obj;
 	BUG_ON(obj == NULL);
 	kp->obj = NULL;
@@ -531,7 +531,7 @@ void *zcache_pampd_create(char *data, un
 	/* pre-allocate per-cpu metadata */
 	BUG_ON(zcache_objnode_cache == NULL);
 	BUG_ON(zcache_obj_cache == NULL);
-	kp = &__get_cpu_var(zcache_preloads);
+	kp = this_cpu_ptr(&zcache_preloads);
 	for (i = 0; i < ARRAY_SIZE(kp->objnodes); i++) {
 		objnode = kp->objnodes[i];
 		if (objnode == NULL) {
@@ -761,7 +761,7 @@ static DEFINE_PER_CPU(unsigned char *, z
 static void zcache_compress(struct page *from, void **out_va, unsigned *out_len)
 {
 	int ret;
-	unsigned char *dmem = __get_cpu_var(zcache_dstmem);
+	unsigned char *dmem = __this_cpu_read(zcache_dstmem);
 	char *from_va;
 
 	BUG_ON(!irqs_disabled());
Index: linux/drivers/staging/zsmalloc/zsmalloc-main.c
===================================================================
--- linux.orig/drivers/staging/zsmalloc/zsmalloc-main.c	2013-08-22 14:14:29.000000000 -0500
+++ linux/drivers/staging/zsmalloc/zsmalloc-main.c	2013-08-22 14:15:51.000000000 -0500
@@ -1028,7 +1028,7 @@ void zs_unmap_object(struct zs_pool *poo
 	class = &pool->size_class[class_idx];
 	off = obj_idx_to_offset(page, obj_idx, class->size);
 
-	area = &__get_cpu_var(zs_map_area);
+	area = this_cpu_ptr(&zs_map_area);
 	if (off + class->size <= PAGE_SIZE)
 		kunmap_atomic(area->vm_addr);
 	else {

