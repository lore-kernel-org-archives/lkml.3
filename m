Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab3BSIJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:09:23 -0500
Received: from ozlabs.org ([203.10.76.45]:56812 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144Ab3BSICo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Cc: sjur.brandeland@stericsson.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 4/5] tools/virtio: separate headers more.
Date: Tue, 19 Feb 2013 08:59:31 +1030
Message-Id: <1361226573-12481-5-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361226573-12481-1-git-send-email-rusty@rustcorp.com.au>
References: <1361226573-12481-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes them a bit more like the kernel headers, so we can include more
real kernel headers in our tests.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 tools/virtio/asm/barrier.h              |   14 +++
 tools/virtio/linux/bug.h                |   10 ++
 tools/virtio/linux/err.h                |   26 +++++
 tools/virtio/linux/export.h             |    5 +
 tools/virtio/linux/irqreturn.h          |    1 +
 tools/virtio/linux/kernel.h             |  113 ++++++++++++++++++++
 tools/virtio/linux/module.h             |    1 +
 tools/virtio/linux/printk.h             |    4 +
 tools/virtio/linux/ratelimit.h          |    4 +
 tools/virtio/linux/scatterlist.h        |  173 +++++++++++++++++++++++++++++++
 tools/virtio/linux/types.h              |   28 +++++
 tools/virtio/linux/uaccess.h            |   37 +++++++
 tools/virtio/linux/uio.h                |    1 +
 tools/virtio/linux/virtio.h             |  152 +--------------------------
 tools/virtio/linux/virtio_config.h      |    6 ++
 tools/virtio/linux/virtio_ring.h        |    1 +
 tools/virtio/linux/vringh.h             |    1 +
 tools/virtio/uapi/linux/uio.h           |    1 +
 tools/virtio/uapi/linux/virtio_config.h |    1 +
 tools/virtio/uapi/linux/virtio_ring.h   |    4 +
 tools/virtio/virtio_test.c              |    4 +
 21 files changed, 438 insertions(+), 149 deletions(-)
 create mode 100644 tools/virtio/asm/barrier.h
 create mode 100644 tools/virtio/linux/bug.h
 create mode 100644 tools/virtio/linux/err.h
 create mode 100644 tools/virtio/linux/export.h
 create mode 100644 tools/virtio/linux/irqreturn.h
 create mode 100644 tools/virtio/linux/kernel.h
 create mode 100644 tools/virtio/linux/printk.h
 create mode 100644 tools/virtio/linux/ratelimit.h
 create mode 100644 tools/virtio/linux/scatterlist.h
 create mode 100644 tools/virtio/linux/types.h
 create mode 100644 tools/virtio/linux/uaccess.h
 create mode 100644 tools/virtio/linux/uio.h
 create mode 100644 tools/virtio/linux/virtio_config.h
 create mode 100644 tools/virtio/linux/virtio_ring.h
 create mode 100644 tools/virtio/linux/vringh.h
 create mode 100644 tools/virtio/uapi/linux/uio.h
 create mode 100644 tools/virtio/uapi/linux/virtio_config.h
 create mode 100644 tools/virtio/uapi/linux/virtio_ring.h

diff --git a/tools/virtio/asm/barrier.h b/tools/virtio/asm/barrier.h
new file mode 100644
index 0000000..aff61e1
--- /dev/null
+++ b/tools/virtio/asm/barrier.h
@@ -0,0 +1,14 @@
+#if defined(__i386__) || defined(__x86_64__)
+#define barrier() asm volatile("" ::: "memory")
+#define mb() __sync_synchronize()
+
+#define smp_mb()	mb()
+# define smp_rmb()	barrier()
+# define smp_wmb()	barrier()
+/* Weak barriers should be used. If not - it's a bug */
+# define rmb()	abort()
+# define wmb()	abort()
+#else
+#error Please fill in barrier macros
+#endif
+
diff --git a/tools/virtio/linux/bug.h b/tools/virtio/linux/bug.h
new file mode 100644
index 0000000..fb94f07
--- /dev/null
+++ b/tools/virtio/linux/bug.h
@@ -0,0 +1,10 @@
+#ifndef BUG_H
+#define BUG_H
+
+#define BUG_ON(__BUG_ON_cond) assert(!(__BUG_ON_cond))
+
+#define BUILD_BUG_ON(x)
+
+#define BUG() abort()
+
+#endif /* BUG_H */
diff --git a/tools/virtio/linux/err.h b/tools/virtio/linux/err.h
new file mode 100644
index 0000000..e32eff8
--- /dev/null
+++ b/tools/virtio/linux/err.h
@@ -0,0 +1,26 @@
+#ifndef ERR_H
+#define ERR_H
+#define MAX_ERRNO	4095
+
+#define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
+
+static inline void * __must_check ERR_PTR(long error)
+{
+	return (void *) error;
+}
+
+static inline long __must_check PTR_ERR(const void *ptr)
+{
+	return (long) ptr;
+}
+
+static inline long __must_check IS_ERR(const void *ptr)
+{
+	return IS_ERR_VALUE((unsigned long)ptr);
+}
+
+static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
+{
+	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
+}
+#endif /* ERR_H */
diff --git a/tools/virtio/linux/export.h b/tools/virtio/linux/export.h
new file mode 100644
index 0000000..7311d32
--- /dev/null
+++ b/tools/virtio/linux/export.h
@@ -0,0 +1,5 @@
+#define EXPORT_SYMBOL(sym)
+#define EXPORT_SYMBOL_GPL(sym)
+#define EXPORT_SYMBOL_GPL_FUTURE(sym)
+#define EXPORT_UNUSED_SYMBOL(sym)
+#define EXPORT_UNUSED_SYMBOL_GPL(sym)
diff --git a/tools/virtio/linux/irqreturn.h b/tools/virtio/linux/irqreturn.h
new file mode 100644
index 0000000..a3c4e7b
--- /dev/null
+++ b/tools/virtio/linux/irqreturn.h
@@ -0,0 +1 @@
+#include "../../../include/linux/irqreturn.h"
diff --git a/tools/virtio/linux/kernel.h b/tools/virtio/linux/kernel.h
new file mode 100644
index 0000000..bc5f1c8
--- /dev/null
+++ b/tools/virtio/linux/kernel.h
@@ -0,0 +1,113 @@
+#ifndef KERNEL_H
+#define KERNEL_H
+#include <stdbool.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <string.h>
+#include <assert.h>
+#include <stdarg.h>
+
+#include <linux/types.h>
+#include <linux/printk.h>
+#include <linux/bug.h>
+#include <errno.h>
+#include <unistd.h>
+#include <asm/barrier.h>
+
+#define CONFIG_SMP
+
+#define PAGE_SIZE getpagesize()
+#define PAGE_MASK (~(PAGE_SIZE-1))
+
+typedef unsigned long long dma_addr_t;
+typedef size_t __kernel_size_t;
+
+struct page {
+	unsigned long long dummy;
+};
+
+/* Physical == Virtual */
+#define virt_to_phys(p) ((unsigned long)p)
+#define phys_to_virt(a) ((void *)(unsigned long)(a))
+/* Page address: Virtual / 4K */
+#define page_to_phys(p) ((dma_addr_t)(unsigned long)(p))
+#define virt_to_page(p) ((struct page *)((unsigned long)p & PAGE_MASK))
+
+#define offset_in_page(p) (((unsigned long)p) % PAGE_SIZE)
+
+#define __printf(a,b) __attribute__((format(printf,a,b)))
+
+typedef enum {
+	GFP_KERNEL,
+	GFP_ATOMIC,
+} gfp_t;
+
+#define __GFP_HIGHMEM 0
+#define __GFP_HIGH 0
+
+#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
+
+extern void *__kmalloc_fake, *__kfree_ignore_start, *__kfree_ignore_end;
+static inline void *kmalloc(size_t s, gfp_t gfp)
+{
+	if (__kmalloc_fake)
+		return __kmalloc_fake;
+	return malloc(s);
+}
+
+static inline void kfree(void *p)
+{
+	if (p >= __kfree_ignore_start && p < __kfree_ignore_end)
+		return;
+	free(p);
+}
+
+static inline void *krealloc(void *p, size_t s, gfp_t gfp)
+{
+	return realloc(p, s);
+}
+
+
+static inline unsigned long __get_free_page(gfp_t gfp)
+{
+	void *p;
+
+	posix_memalign(&p, PAGE_SIZE, PAGE_SIZE);
+	return (unsigned long)p;
+}
+
+static inline void free_page(unsigned long addr)
+{
+	free((void *)addr);
+}
+
+#define container_of(ptr, type, member) ({			\
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+	(type *)( (char *)__mptr - offsetof(type,member) );})
+
+#define uninitialized_var(x) x = x
+
+# ifndef likely
+#  define likely(x)	(__builtin_expect(!!(x), 1))
+# endif
+# ifndef unlikely
+#  define unlikely(x)	(__builtin_expect(!!(x), 0))
+# endif
+
+#define pr_err(format, ...) fprintf (stderr, format, ## __VA_ARGS__)
+#ifdef DEBUG
+#define pr_debug(format, ...) fprintf (stderr, format, ## __VA_ARGS__)
+#else
+#define pr_debug(format, ...) do {} while (0)
+#endif
+#define dev_err(dev, format, ...) fprintf (stderr, format, ## __VA_ARGS__)
+#define dev_warn(dev, format, ...) fprintf (stderr, format, ## __VA_ARGS__)
+
+#define min(x, y) ({				\
+	typeof(x) _min1 = (x);			\
+	typeof(y) _min2 = (y);			\
+	(void) (&_min1 == &_min2);		\
+	_min1 < _min2 ? _min1 : _min2; })
+
+#endif /* KERNEL_H */
diff --git a/tools/virtio/linux/module.h b/tools/virtio/linux/module.h
index e69de29..3039a7e 100644
--- a/tools/virtio/linux/module.h
+++ b/tools/virtio/linux/module.h
@@ -0,0 +1 @@
+#include <linux/export.h>
diff --git a/tools/virtio/linux/printk.h b/tools/virtio/linux/printk.h
new file mode 100644
index 0000000..9f2423b
--- /dev/null
+++ b/tools/virtio/linux/printk.h
@@ -0,0 +1,4 @@
+#include "../../../include/linux/kern_levels.h"
+
+#define printk printf
+#define vprintk vprintf
diff --git a/tools/virtio/linux/ratelimit.h b/tools/virtio/linux/ratelimit.h
new file mode 100644
index 0000000..dcce172
--- /dev/null
+++ b/tools/virtio/linux/ratelimit.h
@@ -0,0 +1,4 @@
+#define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)	int name = 0
+
+#define __ratelimit(x) (*(x))
+
diff --git a/tools/virtio/linux/scatterlist.h b/tools/virtio/linux/scatterlist.h
new file mode 100644
index 0000000..b2cf7d0
--- /dev/null
+++ b/tools/virtio/linux/scatterlist.h
@@ -0,0 +1,173 @@
+#ifndef SCATTERLIST_H
+#define SCATTERLIST_H
+#include <linux/kernel.h>
+
+struct scatterlist {
+	unsigned long	page_link;
+	unsigned int	offset;
+	unsigned int	length;
+	dma_addr_t	dma_address;
+};
+
+/* Scatterlist helpers, stolen from linux/scatterlist.h */
+#define sg_is_chain(sg)		((sg)->page_link & 0x01)
+#define sg_is_last(sg)		((sg)->page_link & 0x02)
+#define sg_chain_ptr(sg)	\
+	((struct scatterlist *) ((sg)->page_link & ~0x03))
+
+/**
+ * sg_assign_page - Assign a given page to an SG entry
+ * @sg:		    SG entry
+ * @page:	    The page
+ *
+ * Description:
+ *   Assign page to sg entry. Also see sg_set_page(), the most commonly used
+ *   variant.
+ *
+ **/
+static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
+{
+	unsigned long page_link = sg->page_link & 0x3;
+
+	/*
+	 * In order for the low bit stealing approach to work, pages
+	 * must be aligned at a 32-bit boundary as a minimum.
+	 */
+	BUG_ON((unsigned long) page & 0x03);
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+	BUG_ON(sg_is_chain(sg));
+#endif
+	sg->page_link = page_link | (unsigned long) page;
+}
+
+/**
+ * sg_set_page - Set sg entry to point at given page
+ * @sg:		 SG entry
+ * @page:	 The page
+ * @len:	 Length of data
+ * @offset:	 Offset into page
+ *
+ * Description:
+ *   Use this function to set an sg entry pointing at a page, never assign
+ *   the page directly. We encode sg table information in the lower bits
+ *   of the page pointer. See sg_page() for looking up the page belonging
+ *   to an sg entry.
+ *
+ **/
+static inline void sg_set_page(struct scatterlist *sg, struct page *page,
+			       unsigned int len, unsigned int offset)
+{
+	sg_assign_page(sg, page);
+	sg->offset = offset;
+	sg->length = len;
+}
+
+static inline struct page *sg_page(struct scatterlist *sg)
+{
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+	BUG_ON(sg_is_chain(sg));
+#endif
+	return (struct page *)((sg)->page_link & ~0x3);
+}
+
+/*
+ * Loop over each sg element, following the pointer to a new list if necessary
+ */
+#define for_each_sg(sglist, sg, nr, __i)	\
+	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
+
+/**
+ * sg_chain - Chain two sglists together
+ * @prv:	First scatterlist
+ * @prv_nents:	Number of entries in prv
+ * @sgl:	Second scatterlist
+ *
+ * Description:
+ *   Links @prv@ and @sgl@ together, to form a longer scatterlist.
+ *
+ **/
+static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
+			    struct scatterlist *sgl)
+{
+	/*
+	 * offset and length are unused for chain entry.  Clear them.
+	 */
+	prv[prv_nents - 1].offset = 0;
+	prv[prv_nents - 1].length = 0;
+
+	/*
+	 * Set lowest bit to indicate a link pointer, and make sure to clear
+	 * the termination bit if it happens to be set.
+	 */
+	prv[prv_nents - 1].page_link = ((unsigned long) sgl | 0x01) & ~0x02;
+}
+
+/**
+ * sg_mark_end - Mark the end of the scatterlist
+ * @sg:		 SG entryScatterlist
+ *
+ * Description:
+ *   Marks the passed in sg entry as the termination point for the sg
+ *   table. A call to sg_next() on this entry will return NULL.
+ *
+ **/
+static inline void sg_mark_end(struct scatterlist *sg)
+{
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+#endif
+	/*
+	 * Set termination bit, clear potential chain bit
+	 */
+	sg->page_link |= 0x02;
+	sg->page_link &= ~0x01;
+}
+
+static inline struct scatterlist *sg_next(struct scatterlist *sg)
+{
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+#endif
+	if (sg_is_last(sg))
+		return NULL;
+
+	sg++;
+	if (unlikely(sg_is_chain(sg)))
+		sg = sg_chain_ptr(sg);
+
+	return sg;
+}
+
+static inline void sg_init_table(struct scatterlist *sgl, unsigned int nents)
+{
+	memset(sgl, 0, sizeof(*sgl) * nents);
+#ifdef CONFIG_DEBUG_SG
+	{
+		unsigned int i;
+		for (i = 0; i < nents; i++)
+			sgl[i].sg_magic = SG_MAGIC;
+	}
+#endif
+	sg_mark_end(&sgl[nents - 1]);
+}
+
+static inline dma_addr_t sg_phys(struct scatterlist *sg)
+{
+	return page_to_phys(sg_page(sg)) + sg->offset;
+}
+
+static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
+			      unsigned int buflen)
+{
+	sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
+}
+
+static inline void sg_init_one(struct scatterlist *sg,
+			       const void *buf, unsigned int buflen)
+{
+	sg_init_table(sg, 1);
+	sg_set_buf(sg, buf, buflen);
+}
+#endif /* SCATTERLIST_H */
diff --git a/tools/virtio/linux/types.h b/tools/virtio/linux/types.h
new file mode 100644
index 0000000..f8ebb9a
--- /dev/null
+++ b/tools/virtio/linux/types.h
@@ -0,0 +1,28 @@
+#ifndef TYPES_H
+#define TYPES_H
+#include <stdint.h>
+
+#define __force
+#define __user
+#define __must_check
+#define __cold
+
+typedef uint64_t u64;
+typedef int64_t s64;
+typedef uint32_t u32;
+typedef int32_t s32;
+typedef uint16_t u16;
+typedef int16_t s16;
+typedef uint8_t u8;
+typedef int8_t s8;
+
+typedef uint64_t __u64;
+typedef int64_t __s64;
+typedef uint32_t __u32;
+typedef int32_t __s32;
+typedef uint16_t __u16;
+typedef int16_t __s16;
+typedef uint8_t __u8;
+typedef int8_t __s8;
+
+#endif /* TYPES_H */
diff --git a/tools/virtio/linux/uaccess.h b/tools/virtio/linux/uaccess.h
new file mode 100644
index 0000000..5874786
--- /dev/null
+++ b/tools/virtio/linux/uaccess.h
@@ -0,0 +1,37 @@
+#ifndef UACCESS_H
+#define UACCESS_H
+extern void *__user_addr_min, *__user_addr_max;
+
+#define get_user(dst, uptr) get_user_func(&(dst), (uptr), sizeof(*uptr))
+#define put_user(val, uptr) put_user_func(&(val), (uptr), sizeof(*uptr))
+
+static inline int get_user_func(void *dst, void *src, size_t size)
+{
+	assert(src >= __user_addr_min && src + size <= __user_addr_max);
+	memcpy(dst, src, size);
+	return 0;
+}
+
+static inline int put_user_func(void *val, void *dst, size_t size)
+{
+	assert(dst >= __user_addr_min && dst + size <= __user_addr_max);
+	memcpy(dst, val, size);
+	return 0;
+}
+
+static inline int copy_from_user(void *to, const void __user *from,
+				 unsigned long n)
+{
+	assert(from >= __user_addr_min && from + n <= __user_addr_max);
+	memcpy(to, from, n);
+	return 0;
+}
+
+static inline int copy_to_user(void __user *to, const void *from,
+			       unsigned long n)
+{
+	assert(to >= __user_addr_min && to + n <= __user_addr_max);
+	memcpy(to, from, n);
+	return 0;
+}
+#endif /* UACCESS_H */
diff --git a/tools/virtio/linux/uio.h b/tools/virtio/linux/uio.h
new file mode 100644
index 0000000..ecbdf92
--- /dev/null
+++ b/tools/virtio/linux/uio.h
@@ -0,0 +1 @@
+#include "../../../include/linux/uio.h"
diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
index ccfc901..61f313b 100644
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -1,131 +1,7 @@
 #ifndef LINUX_VIRTIO_H
 #define LINUX_VIRTIO_H
-
-#include <stdbool.h>
-#include <stdlib.h>
-#include <stddef.h>
-#include <stdio.h>
-#include <string.h>
-#include <assert.h>
-
-#include <linux/types.h>
-#include <errno.h>
-
-typedef unsigned long long dma_addr_t;
-
-struct scatterlist {
-	unsigned long	page_link;
-	unsigned int	offset;
-	unsigned int	length;
-	dma_addr_t	dma_address;
-};
-
-struct page {
-	unsigned long long dummy;
-};
-
-#define BUG_ON(__BUG_ON_cond) assert(!(__BUG_ON_cond))
-
-/* Physical == Virtual */
-#define virt_to_phys(p) ((unsigned long)p)
-#define phys_to_virt(a) ((void *)(unsigned long)(a))
-/* Page address: Virtual / 4K */
-#define virt_to_page(p) ((struct page*)((virt_to_phys(p) / 4096) * \
-					sizeof(struct page)))
-#define offset_in_page(p) (((unsigned long)p) % 4096)
-#define sg_phys(sg) ((sg->page_link & ~0x3) / sizeof(struct page) * 4096 + \
-		     sg->offset)
-static inline void sg_mark_end(struct scatterlist *sg)
-{
-	/*
-	 * Set termination bit, clear potential chain bit
-	 */
-	sg->page_link |= 0x02;
-	sg->page_link &= ~0x01;
-}
-static inline void sg_init_table(struct scatterlist *sgl, unsigned int nents)
-{
-	memset(sgl, 0, sizeof(*sgl) * nents);
-	sg_mark_end(&sgl[nents - 1]);
-}
-static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
-{
-	unsigned long page_link = sg->page_link & 0x3;
-
-	/*
-	 * In order for the low bit stealing approach to work, pages
-	 * must be aligned at a 32-bit boundary as a minimum.
-	 */
-	BUG_ON((unsigned long) page & 0x03);
-	sg->page_link = page_link | (unsigned long) page;
-}
-
-static inline void sg_set_page(struct scatterlist *sg, struct page *page,
-			       unsigned int len, unsigned int offset)
-{
-	sg_assign_page(sg, page);
-	sg->offset = offset;
-	sg->length = len;
-}
-
-static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
-			      unsigned int buflen)
-{
-	sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
-}
-
-static inline void sg_init_one(struct scatterlist *sg, const void *buf, unsigned int buflen)
-{
-	sg_init_table(sg, 1);
-	sg_set_buf(sg, buf, buflen);
-}
-
-typedef __u16 u16;
-
-typedef enum {
-	GFP_KERNEL,
-	GFP_ATOMIC,
-} gfp_t;
-
-#define __GFP_HIGHMEM 0
-#define __GFP_HIGH 0
-
-typedef enum {
-	IRQ_NONE,
-	IRQ_HANDLED
-} irqreturn_t;
-
-static inline void *kmalloc(size_t s, gfp_t gfp)
-{
-	return malloc(s);
-}
-
-static inline void kfree(void *p)
-{
-	free(p);
-}
-
-#define container_of(ptr, type, member) ({			\
-	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-	(type *)( (char *)__mptr - offsetof(type,member) );})
-
-#define uninitialized_var(x) x = x
-
-# ifndef likely
-#  define likely(x)	(__builtin_expect(!!(x), 1))
-# endif
-# ifndef unlikely
-#  define unlikely(x)	(__builtin_expect(!!(x), 0))
-# endif
-
-#define pr_err(format, ...) fprintf (stderr, format, ## __VA_ARGS__)
-#ifdef DEBUG
-#define pr_debug(format, ...) fprintf (stderr, format, ## __VA_ARGS__)
-#else
-#define pr_debug(format, ...) do {} while (0)
-#endif
-#define dev_err(dev, format, ...) fprintf (stderr, format, ## __VA_ARGS__)
-#define dev_warn(dev, format, ...) fprintf (stderr, format, ## __VA_ARGS__)
+#include <linux/scatterlist.h>
+#include <linux/kernel.h>
 
 /* TODO: empty stubs for now. Broken but enough for virtio_ring.c */
 #define list_add_tail(a, b) do {} while (0)
@@ -135,6 +11,7 @@ static inline void kfree(void *p)
 #define BITS_PER_BYTE		8
 #define BITS_PER_LONG (sizeof(long) * BITS_PER_BYTE)
 #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
+
 /* TODO: Not atomic as it should be:
  * we don't use this for anything important. */
 static inline void clear_bit(int nr, volatile unsigned long *addr)
@@ -149,10 +26,6 @@ static inline int test_bit(int nr, const volatile unsigned long *addr)
 {
         return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
 }
-
-/* The only feature we care to support */
-#define virtio_has_feature(dev, feature) \
-	test_bit((feature), (dev)->features)
 /* end of stubs */
 
 struct virtio_device {
@@ -172,28 +45,9 @@ struct virtqueue {
 	void *priv;
 };
 
-#define EXPORT_SYMBOL_GPL(__EXPORT_SYMBOL_GPL_name) \
-	void __EXPORT_SYMBOL_GPL##__EXPORT_SYMBOL_GPL_name() { \
-}
 #define MODULE_LICENSE(__MODULE_LICENSE_value) \
 	const char *__MODULE_LICENSE_name = __MODULE_LICENSE_value
 
-#define CONFIG_SMP
-
-#if defined(__i386__) || defined(__x86_64__)
-#define barrier() asm volatile("" ::: "memory")
-#define mb() __sync_synchronize()
-
-#define smp_mb()	mb()
-# define smp_rmb()	barrier()
-# define smp_wmb()	barrier()
-/* Weak barriers should be used. If not - it's a bug */
-# define rmb()	abort()
-# define wmb()	abort()
-#else
-#error Please fill in barrier macros
-#endif
-
 /* Interfaces exported by virtio_ring. */
 int virtqueue_add_buf(struct virtqueue *vq,
 		      struct scatterlist sg[],
diff --git a/tools/virtio/linux/virtio_config.h b/tools/virtio/linux/virtio_config.h
new file mode 100644
index 0000000..5049967
--- /dev/null
+++ b/tools/virtio/linux/virtio_config.h
@@ -0,0 +1,6 @@
+#define VIRTIO_TRANSPORT_F_START	28
+#define VIRTIO_TRANSPORT_F_END		32
+
+#define virtio_has_feature(dev, feature) \
+	test_bit((feature), (dev)->features)
+
diff --git a/tools/virtio/linux/virtio_ring.h b/tools/virtio/linux/virtio_ring.h
new file mode 100644
index 0000000..8949c4e
--- /dev/null
+++ b/tools/virtio/linux/virtio_ring.h
@@ -0,0 +1 @@
+#include "../../../include/linux/virtio_ring.h"
diff --git a/tools/virtio/linux/vringh.h b/tools/virtio/linux/vringh.h
new file mode 100644
index 0000000..9348957
--- /dev/null
+++ b/tools/virtio/linux/vringh.h
@@ -0,0 +1 @@
+#include "../../../include/linux/vringh.h"
diff --git a/tools/virtio/uapi/linux/uio.h b/tools/virtio/uapi/linux/uio.h
new file mode 100644
index 0000000..7230e90
--- /dev/null
+++ b/tools/virtio/uapi/linux/uio.h
@@ -0,0 +1 @@
+#include <sys/uio.h>
diff --git a/tools/virtio/uapi/linux/virtio_config.h b/tools/virtio/uapi/linux/virtio_config.h
new file mode 100644
index 0000000..4c86675
--- /dev/null
+++ b/tools/virtio/uapi/linux/virtio_config.h
@@ -0,0 +1 @@
+#include "../../../../include/uapi/linux/virtio_config.h"
diff --git a/tools/virtio/uapi/linux/virtio_ring.h b/tools/virtio/uapi/linux/virtio_ring.h
new file mode 100644
index 0000000..4d99c78
--- /dev/null
+++ b/tools/virtio/uapi/linux/virtio_ring.h
@@ -0,0 +1,4 @@
+#ifndef VIRTIO_RING_H
+#define VIRTIO_RING_H
+#include "../../../../include/uapi/linux/virtio_ring.h"
+#endif /* VIRTIO_RING_H */
diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index a07142c..c613f25 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -10,11 +10,15 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <fcntl.h>
+#include <stdbool.h>
 #include <linux/vhost.h>
 #include <linux/virtio.h>
 #include <linux/virtio_ring.h>
 #include "../../drivers/vhost/test.h"
 
+/* Unused */
+void *__kmalloc_fake, *__kfree_ignore_start, *__kfree_ignore_end;
+
 struct vq_info {
 	int kick;
 	int call;
-- 
1.7.10.4

