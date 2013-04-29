Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab3D2VqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:46:16 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49906 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092Ab3D2VqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:46:13 -0400
X-Nat-Received: from [202.181.97.72]:64121 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1367271962.16938
To: cl@linux.com
Cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com>
	<517E8758.9040803@parallels.com>
	<0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com>
	<201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp>
	<0000013e56e9304a-1042a95a-d4dd-43c5-8b8a-c670f50ac54e-000000@email.amazonses.com>
In-Reply-To: <0000013e56e9304a-1042a95a-d4dd-43c5-8b8a-c670f50ac54e-000000@email.amazonses.com>
Message-Id: <201304300645.FCE37285.tVHJLSOMQFOFFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 30 Apr 2013 06:45:59 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 29042013 #9857820, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Ok so the maximum allocation is 11+12=23 which is 8M. KMALLOC_MAX_SIZE
> amd KMALLOC_SHIFT_HIGH are wrong.
> 
> Take the -1 off the constants under #ifdef CONFIG_SLAB in

Current diff is:

---------- patch start ----------
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 0c62175..889d6ef 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -189,8 +189,8 @@ struct kmem_cache {
  * to do various tricks to work around compiler limitations in order to
  * ensure proper constant folding.
  */
-#define KMALLOC_SHIFT_HIGH	((MAX_ORDER + PAGE_SHIFT - 1) <= 25 ? \
-				(MAX_ORDER + PAGE_SHIFT - 1) : 25)
+#define KMALLOC_SHIFT_HIGH	((MAX_ORDER + PAGE_SHIFT) <= 26 ? \
+				(MAX_ORDER + PAGE_SHIFT) : 26)
 #define KMALLOC_SHIFT_MAX	KMALLOC_SHIFT_HIGH
 #ifndef KMALLOC_SHIFT_LOW
 #define KMALLOC_SHIFT_LOW	5
@@ -221,9 +221,9 @@ struct kmem_cache {
 #define KMALLOC_MIN_SIZE (1 << KMALLOC_SHIFT_LOW)
 #endif
 
-extern struct kmem_cache *kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];
+extern struct kmem_cache *kmalloc_caches[KMALLOC_SHIFT_HIGH];
 #ifdef CONFIG_ZONE_DMA
-extern struct kmem_cache *kmalloc_dma_caches[KMALLOC_SHIFT_HIGH + 1];
+extern struct kmem_cache *kmalloc_dma_caches[KMALLOC_SHIFT_HIGH];
 #endif
 
 /*
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 113ec08..be1446a 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -126,6 +126,9 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 		if (!size)
 			return ZERO_SIZE_PTR;
 
+		if (size > KMALLOC_MAX_SIZE)
+			goto not_found;
+
 		i = kmalloc_index(size);
 
 #ifdef CONFIG_ZONE_DMA
@@ -139,6 +142,7 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 
 		return ret;
 	}
+not_found:
 	return __kmalloc(size, flags);
 }
 
@@ -172,8 +176,10 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 		if (!size)
 			return ZERO_SIZE_PTR;
 
-		i = kmalloc_index(size);
+		if (size > KMALLOC_MAX_SIZE)
+			goto not_found;
 
+		i = kmalloc_index(size);
 #ifdef CONFIG_ZONE_DMA
 		if (flags & GFP_DMA)
 			cachep = kmalloc_dma_caches[i];
@@ -183,6 +189,7 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 
 		return kmem_cache_alloc_node_trace(cachep, flags, node, size);
 	}
+not_found:
 	return __kmalloc_node(size, flags, node);
 }
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 2f0e7d5..083e7c7 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -319,11 +319,11 @@ struct kmem_cache *__init create_kmalloc_cache(const char *name, size_t size,
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
 
---------- patch end ----------

Current testcases are:

---------- testcases start ----------
	volatile unsigned int size;
	void *ptr;
	ptr = kmalloc(0, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 0, ptr);
	kfree(ptr);
	ptr = kmalloc(1, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 1, ptr);
	kfree(ptr);
	ptr = kmalloc(2, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 2, ptr);
	kfree(ptr);
	ptr = kmalloc(4, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 4, ptr);
	kfree(ptr);
	ptr = kmalloc(8, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 8, ptr);
	kfree(ptr);
	ptr = kmalloc(16, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 16, ptr);
	kfree(ptr);
	ptr = kmalloc(32, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 32, ptr);
	kfree(ptr);
	ptr = kmalloc(64, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 64, ptr);
	kfree(ptr);
	ptr = kmalloc(128, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 128, ptr);
	kfree(ptr);
	ptr = kmalloc(256, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 256, ptr);
	kfree(ptr);
	ptr = kmalloc(512, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 512, ptr);
	kfree(ptr);
	ptr = kmalloc(1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(2 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 2 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(4 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 4 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(8 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 8 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(16 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 16 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(32 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 32 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(64 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 64 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(128 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 128 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(256 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 256 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(512 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 512 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(1024 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 1024 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(2 * 1024 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 2 * 1024 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(4 * 1024 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 4 * 1024 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(8 * 1024 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 8 * 1024 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(16 * 1024 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 16 * 1024 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(32 * 1024 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 32 * 1024 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(64 * 1024 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 64 * 1024 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(128 * 1024 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 128 * 1024 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(256 * 1024 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 256 * 1024 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(512 * 1024 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 512 * 1024 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(1024 * 1024 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 1024 * 1024 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(2 * 1024 * 1024 * 1024, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 2 * 1024 * 1024 * 1024, ptr);
	kfree(ptr);
	ptr = kmalloc(2 * 1024 * 1024 * 1024 + 1, GFP_KERNEL);
	printk("kmalloc(%u)=%p\n", 2 * 1024 * 1024 * 1024 + 1, ptr);
	kfree(ptr);
	for (size = 0; size; size <<= 1) {
		ptr = kmalloc(size, GFP_KERNEL);
		printk("kmalloc(%u)=%p\n", size, ptr);
		kfree(ptr);
		if (!size)
			size = 1;
	}
	for (size = 1; size; size <<= 1) {
		ptr = kmalloc(size + 1, GFP_KERNEL);
		printk("kmalloc(%u)=%p\n", size + 1, ptr);
		kfree(ptr);
	}
---------- testcases end ----------

The testcases still trigger BUG() at 32M:

---------- dmesg start ----------
(...snipped...)
kmalloc(2097152)=dde00000
kmalloc(4194304)=d9c00000
------------[ cut here ]------------
WARNING: at mm/page_alloc.c:2410 __alloc_pages_nodemask+0x179/0x650()
(...snipped...)
---[ end trace c08f36179e2d8ff2 ]---
SLAB: Unable to allocate memory on node 0 (gfp=0xd0)
  cache: kmalloc-8388608, object size: 8388608, order: 11
  node 0: slabs: 0/0, objs: 0/0, free: 0
kmalloc(8388608)=  (null)
kmalloc(16777216)=  (null)
------------[ cut here ]------------
Kernel BUG at c10b9c9b [verbose debug info unavailable]
invalid opcode: 0000 [#1] SMP
(...snipped...)
---------- dmesg end ----------

This means that redirecting to !__builtin_constant_p(size) case does not help.
