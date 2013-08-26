Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3HZUue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:50:34 -0400
Received: from a9-66.smtp-out.amazonses.com ([54.240.9.66]:38087 "EHLO
	a9-66.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431Ab3HZUub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:50:31 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 16:50:31 EDT
Message-ID: <00000140bc5f0a95-665825f4-3305-475f-baaf-bc47b0078688-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 26 Aug 2013 20:44:40 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv v2 15/31] zcache/zsmalloc: Replace __get_cpu_var uses
References: <20130826204351.725357339@linux.com>
X-SES-Outgoing: 2013.08.26-54.240.9.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__get_cpu_var() is used for multiple purposes in the kernel source. One of them is
address calculation via the form &__get_cpu_var(x). This calculates the address for
the instance of the percpu variable of the current processor based on an offset.

Others usage cases are for storing and retrieving data from the current processors percpu area.
__get_cpu_var() can be used as an lvalue when writing data or on the right side of an assignment.

__get_cpu_var() is defined as :


#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))



__get_cpu_var() always only does a address determination. However, store and retrieve operations
could use a segment prefix (or global register on other platforms) to avoid the address calculation.

this_cpu_write() and this_cpu_read() can directly take an offset into a percpu area and use
optimized assembly code to read and write per cpu variables.


This patch converts __get_cpu_var into either and explicit address calculation using this_cpu_ptr()
or into a use of this_cpu operations that use the offset. Thereby address calcualtions are avoided
and less registers are used when code is generated.

At the end of the patchset all uses of __get_cpu_var have been removed so the macro is removed too.

The patchset includes passes over all arches as well. Once these operations are used throughout then
specialized macros can be defined in non -x86 arches as well in order to optimize per cpu access by
f.e. using a global register that may be set to the per cpu base.




Transformations done to __get_cpu_var()


1. Determine the address of the percpu instance of the current processor.

	DEFINE_PER_CPU(int, y);
	int *x = &__get_cpu_var(y);

    Converts to

	int *x = this_cpu_ptr(&y);


2. Same as #1 but this time an array structure is involved.

	DEFINE_PER_CPU(int, y[20]);
	int *x = __get_cpu_var(y);

    Converts to

	int *x = this_cpu_ptr(y);


3. Retrieve the content of the current processors instance of a per cpu variable.

	DEFINE_PER_CPU(int, u);
	int x = __get_cpu_var(y)

   Converts to

	int x = __this_cpu_read(y);


4. Retrieve the content of a percpu struct

	DEFINE_PER_CPU(struct mystruct, y);
	struct mystruct x = __get_cpu_var(y);

   Converts to

	memcpy(this_cpu_ptr(&y), x, sizeof(x));


5. Assignment to a per cpu variable

	DEFINE_PER_CPU(int, y)
	__get_cpu_var(y) = x;

   Converts to

	this_cpu_write(y, x);


6. Increment/Decrement etc of a per cpu variable

	DEFINE_PER_CPU(int, y);
	__get_cpu_var(y)++

   Converts to

	this_cpu_inc(y)



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

