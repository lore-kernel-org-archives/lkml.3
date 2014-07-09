Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbaGILgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:36:51 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26878 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557AbaGILgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:36:41 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-ee-53bd294639e0
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH RESEND -next 13/21] mm: slub: add allocation size field to
 struct kmem_cache
Date: Wed, 09 Jul 2014 15:30:07 +0400
Message-id: <1404905415-9046-14-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xy7pumnuDDWbflrfY9usRm8XvvTNZ
	LeasX8Nmcf3bG0aLCQ/b2C1WdjezWWx/9pbJYmXnA1aLTY+vsVr82bWDyeLyrjlsFvfW/Ge1
	uH2Z1+LSgQVMFi37LjBZtH3+x2qxb+V5IGvJRiaLxUduM1u8ezaZ2WLzpqnMFj82PGZ1EPNo
	ae5h89g56y67x4JNpR6bVnWyeWz6NIndo+vtFSaPd+fOsXucmPGbxePJlelMHpuX1Ht8fHqL
	xeP9vqtsHn1bVjF6nFlwhN3j8ya5AP4oLpuU1JzMstQifbsEroy3XduYCl6JVhy+U9/AeF2w
	i5GTQ0LARGL/vlZmCFtM4sK99WxdjFwcQgJLGSW29/5mhnD6mCR2H/vDDlLFJqAn8W/WdjYQ
	W0RAQWJz7zNWkCJmgWY2ifaOD6wgCWGBJIn/B+YxgtgsAqoSUxr/gcV5Bdwkju5bxAaxTkFi
	2fKZYHFOoPiE6deAtnEAbXOVmLBCbQIj7wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsY
	IZH0ZQfj4mNWhxgFOBiVeHg1ancHC7EmlhVX5h5ilOBgVhLhtRXdGyzEm5JYWZValB9fVJqT
	WnyIkYmDU6qBMX2Txv4fNVeXbshW1VEpXrrqQMmTJ0/jMl7HvZ8RbBBzVWOZTc6t9z8THOLy
	BLd9/ruNQ/rmjGfv9Wz+myuqbTnFcjX43sFXDJZ/9sg/5FoREDTBpzP3pIKJ3qELJdl/qu7U
	Xaj5FTA7xV0jVn5nlNKjz/cXmTauX3BdyCpDS1z2vNJtA25WEyWW4oxEQy3mouJEAHXjEdKC	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When caller creates new kmem_cache, requested size of kmem_cache
will be stored in alloc_size. Later alloc_size will be used by
kerenel address sanitizer to mark alloc_size of slab object as
accessible and the rest of its size as redzone.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/slub_def.h |  5 +++++
 mm/slab.h                | 10 ++++++++++
 mm/slab_common.c         |  2 ++
 mm/slub.c                |  1 +
 4 files changed, 18 insertions(+)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index d82abd4..b8b8154 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -68,6 +68,11 @@ struct kmem_cache {
 	int object_size;	/* The size of an object without meta data */
 	int offset;		/* Free pointer offset. */
 	int cpu_partial;	/* Number of per cpu partial objects to keep around */
+
+#ifdef CONFIG_KASAN
+	int alloc_size;		/* actual allocation size kmem_cache_create */
+#endif
+
 	struct kmem_cache_order_objects oo;
 
 	/* Allocation and freeing of slabs */
diff --git a/mm/slab.h b/mm/slab.h
index 912af7f..cb2e776 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -260,6 +260,16 @@ static inline void memcg_uncharge_slab(struct kmem_cache *s, int order)
 }
 #endif
 
+#ifdef CONFIG_KASAN
+static inline void kasan_set_alloc_size(struct kmem_cache *s, size_t size)
+{
+	s->alloc_size = size;
+}
+#else
+static inline void kasan_set_alloc_size(struct kmem_cache *s, size_t size) { }
+#endif
+
+
 static inline struct kmem_cache *virt_to_cache(const void *obj)
 {
 	struct page *page = virt_to_head_page(obj);
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 8df59b09..f5b52f0 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -147,6 +147,7 @@ do_kmem_cache_create(char *name, size_t object_size, size_t size, size_t align,
 	s->name = name;
 	s->object_size = object_size;
 	s->size = size;
+	kasan_set_alloc_size(s, object_size);
 	s->align = align;
 	s->ctor = ctor;
 
@@ -409,6 +410,7 @@ void __init create_boot_cache(struct kmem_cache *s, const char *name, size_t siz
 
 	s->name = name;
 	s->size = s->object_size = size;
+	kasan_set_alloc_size(s, size);
 	s->align = calculate_alignment(flags, ARCH_KMALLOC_MINALIGN, size);
 	err = __kmem_cache_create(s, flags);
 
diff --git a/mm/slub.c b/mm/slub.c
index 3bdd9ac..6ddedf9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3724,6 +3724,7 @@ __kmem_cache_alias(const char *name, size_t size, size_t align,
 		 * the complete object on kzalloc.
 		 */
 		s->object_size = max(s->object_size, (int)size);
+		kasan_set_alloc_size(s, max(s->alloc_size, (int)size));
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
 
 		for_each_memcg_cache_index(i) {
-- 
1.8.5.5

