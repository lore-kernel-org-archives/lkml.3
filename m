Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaKEOy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:54:59 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62159 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbaKEOyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:54:38 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-10-545a3a2cea37
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: akpm@linux-foundation.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] lib: add kasan test module
Date: Wed, 05 Nov 2014 17:54:01 +0300
Message-id: <1415199241-5121-12-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xq7o6VlEhBiubrS22/XrEZvF770xW
	iznr17BZHLn2nd3i+rc3jBafXj5gtNhyvYnJ4vnDh+wWEx62sVtM2yhusbK7mc1i+7O3TBYr
	Ox+wWlzeNYfN4t6a/6wWi4/cZrZ492wys8XVVQfZLX5seMzqIOwxf+dHRo+ds+6yeyzYVOqx
	eM9LJo9NqzrZPDZ9msTu0fX2CpPHiRm/WTyeXJnO5PHx6S0Wj/f7rrJ59G1ZxejxeZOcx4mW
	L6wBfFFcNimpOZllqUX6dglcGVvPf2ctOGNWcWjlV/YGxkadLkZODgkBE4n1Le/YIGwxiQv3
	1gPZXBxCAksZJQ4taWOFcPqYJJau2cQMUsUmoCfxb9Z2sA4RAVmJqX/Ps4DYzAKtrBKntiaB
	2MIC2hKH51xgB7FZBFQlrk/fygpi8wq4Sfz+u5Opi5EDaJucxNZ13iBhTqDwkf5FLBC7Ghkl
	Pt/qZJnAyLuAkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkiUfNnBuPiY1SFGAQ5GJR5e
	j6bIECHWxLLiytxDjBIczEoivE3aUSFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGJlPcjA5N/5O
	YLz2bVffrQnHfFLK2ZJafj1s3Xfm7oWYwzoTdJnkn2awLTmX+2S6wbs9gSqZLtO1jokYm8ZI
	5J/8sIDjaqCW8aH+7R92TD08x5iXa+UEc88He7ct5b+YE7Jq23XBNCHGbkvj3tW3i4+8i1xo
	KlVjskstrDxlww6jqqDXugccFyqxFGckGmoxFxUnAgBLT5xZcAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a test module doing various nasty things like
out of bounds accesses, use after free. It is useful for testing
kernel debugging features like kernel address sanitizer.

It mostly concentrates on testing of slab allocator, but we
might want to add more different stuff here in future (like
stack/global variables out of bounds accesses and so on).

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 lib/Kconfig.kasan |   8 ++
 lib/Makefile      |   1 +
 lib/test_kasan.c  | 254 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 263 insertions(+)
 create mode 100644 lib/test_kasan.c

diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
index 1fa4fe8..8548646 100644
--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -43,4 +43,12 @@ config KASAN_INLINE
 
 endchoice
 
+config TEST_KASAN
+	tristate "Module for testing kasan for bug detection"
+	depends on m && KASAN
+	help
+	  This is a test module doing various nasty things like
+	  out of bounds accesses, use after free. It is useful for testing
+	  kernel debugging features like kernel address sanitizer.
+
 endif
diff --git a/lib/Makefile b/lib/Makefile
index 84000ec..b387570 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_TEST_LKM) += test_module.o
 obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
 obj-$(CONFIG_TEST_BPF) += test_bpf.o
 obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
+obj-$(CONFIG_TEST_KASAN) += test_kasan.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff --git a/lib/test_kasan.c b/lib/test_kasan.c
new file mode 100644
index 0000000..896dee5
--- /dev/null
+++ b/lib/test_kasan.c
@@ -0,0 +1,254 @@
+/*
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ * Author: Andrey Ryabinin <a.ryabinin@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#define pr_fmt(fmt) "kasan test: %s " fmt, __func__
+
+#include <linux/kernel.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/module.h>
+
+static noinline void __init kmalloc_oob_right(void)
+{
+	char *ptr;
+	size_t size = 123;
+
+	pr_info("out-of-bounds to right\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	ptr[size] = 'x';
+	kfree(ptr);
+}
+
+static noinline void __init kmalloc_oob_left(void)
+{
+	char *ptr;
+	size_t size = 15;
+
+	pr_info("out-of-bounds to left\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	*ptr = *(ptr - 1);
+	kfree(ptr);
+}
+
+static noinline void __init kmalloc_node_oob_right(void)
+{
+	char *ptr;
+	size_t size = 4096;
+
+	pr_info("kmalloc_node(): out-of-bounds to right\n");
+	ptr = kmalloc_node(size, GFP_KERNEL, 0);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	ptr[size] = 0;
+	kfree(ptr);
+}
+
+static noinline void __init kmalloc_large_oob_rigth(void)
+{
+	char *ptr;
+	size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
+
+	pr_info("kmalloc large allocation: out-of-bounds to right\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	ptr[size] = 0;
+	kfree(ptr);
+}
+
+static noinline void __init kmalloc_oob_krealloc_more(void)
+{
+	char *ptr1, *ptr2;
+	size_t size1 = 17;
+	size_t size2 = 19;
+
+	pr_info("out-of-bounds after krealloc more\n");
+	ptr1 = kmalloc(size1, GFP_KERNEL);
+	ptr2 = krealloc(ptr1, size2, GFP_KERNEL);
+	if (!ptr1 || !ptr2) {
+		pr_err("Allocation failed\n");
+		kfree(ptr1);
+		return;
+	}
+
+	ptr2[size2] = 'x';
+	kfree(ptr2);
+}
+
+static noinline void __init kmalloc_oob_krealloc_less(void)
+{
+	char *ptr1, *ptr2;
+	size_t size1 = 17;
+	size_t size2 = 15;
+
+	pr_info("out-of-bounds after krealloc less\n");
+	ptr1 = kmalloc(size1, GFP_KERNEL);
+	ptr2 = krealloc(ptr1, size2, GFP_KERNEL);
+	if (!ptr1 || !ptr2) {
+		pr_err("Allocation failed\n");
+		kfree(ptr1);
+		return;
+	}
+	ptr2[size1] = 'x';
+	kfree(ptr2);
+}
+
+static noinline void __init kmalloc_oob_16(void)
+{
+	struct {
+		u64 words[2];
+	} *ptr1, *ptr2;
+
+	pr_info("kmalloc out-of-bounds for 16-bytes access\n");
+	ptr1 = kmalloc(sizeof(*ptr1) - 3, GFP_KERNEL);
+	ptr2 = kmalloc(sizeof(*ptr2), GFP_KERNEL);
+	if (!ptr1 || !ptr2) {
+		pr_err("Allocation failed\n");
+		kfree(ptr1);
+		kfree(ptr2);
+		return;
+	}
+	*ptr1 = *ptr2;
+	kfree(ptr1);
+	kfree(ptr2);
+}
+
+static noinline void __init kmalloc_oob_in_memset(void)
+{
+	char *ptr;
+	size_t size = 666;
+
+	pr_info("out-of-bounds in memset\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	memset(ptr, 0, size+5);
+	kfree(ptr);
+}
+
+static noinline void __init kmalloc_uaf(void)
+{
+	char *ptr;
+	size_t size = 10;
+
+	pr_info("use-after-free\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	kfree(ptr);
+	*(ptr + 8) = 'x';
+}
+
+static noinline void __init kmalloc_uaf_memset(void)
+{
+	char *ptr;
+	size_t size = 33;
+
+	pr_info("use-after-free in memset\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	kfree(ptr);
+	memset(ptr, 0, size);
+}
+
+static noinline void __init kmalloc_uaf2(void)
+{
+	char *ptr1, *ptr2;
+	size_t size = 43;
+
+	pr_info("use-after-free after another kmalloc\n");
+	ptr1 = kmalloc(size, GFP_KERNEL);
+	if (!ptr1) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	kfree(ptr1);
+	ptr2 = kmalloc(size, GFP_KERNEL);
+	if (!ptr2) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	ptr1[40] = 'x';
+	kfree(ptr2);
+}
+
+static noinline void __init kmem_cache_oob(void)
+{
+	char *p;
+	size_t size = 200;
+	struct kmem_cache *cache = kmem_cache_create("test_cache",
+						size, 0,
+						0, NULL);
+	if (!cache) {
+		pr_err("Cache allocation failed\n");
+		return;
+	}
+	pr_info("out-of-bounds in kmem_cache_alloc\n");
+	p = kmem_cache_alloc(cache, GFP_KERNEL);
+	if (!p) {
+		pr_err("Allocation failed\n");
+		kmem_cache_destroy(cache);
+		return;
+	}
+
+	*p = p[size];
+	kmem_cache_free(cache, p);
+	kmem_cache_destroy(cache);
+}
+
+int __init kmalloc_tests_init(void)
+{
+	kmalloc_oob_right();
+	kmalloc_oob_left();
+	kmalloc_node_oob_right();
+	kmalloc_large_oob_rigth();
+	kmalloc_oob_krealloc_more();
+	kmalloc_oob_krealloc_less();
+	kmalloc_oob_16();
+	kmalloc_oob_in_memset();
+	kmalloc_uaf();
+	kmalloc_uaf_memset();
+	kmalloc_uaf2();
+	kmem_cache_oob();
+	return -EAGAIN;
+}
+
+module_init(kmalloc_tests_init);
+MODULE_LICENSE("GPL");
-- 
2.1.3

