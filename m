Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbaGILLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:11:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52164 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbaGILK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:28 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-af-53bd231e108b
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 21/21] lib: add kmalloc_bug_test module
Date: Wed, 09 Jul 2014 15:01:18 +0400
Message-id: <1404903678-8257-22-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJMWRmVeSWpSXmKPExsVy+t/xy7pyynuDDVoX8Fls+/WIzeLyrjls
	DkwefVtWMXp83iQXwBTFZZOSmpNZllqkb5fAlfF0WXXBfpOKaV8/szQwztDqYuTkkBAwkeid
	v5QFwhaTuHBvPVsXIxeHkMBSRokLR/axQDh9TBLv7u5gB6liE9CT+DdrOxuILSKgILG59xkr
	iM0soCOx8VorE4gtLOAocW3dH2YQm0VAVeLwx5lg9bwCbhK3X26D2qYgsWz5TLBeTqB4T88C
	sF4hAVeJ1Z+3MU5g5F3AyLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyQIvuxgXHzM6hCj
	AAejEg+vRu3uYCHWxLLiytxDjBIczEoivLaie4OFeFMSK6tSi/Lji0pzUosPMTJxcEo1MBqs
	s8o31j6XKb+45sZ01TjNJyaXlpxJ2/Q/s8qX/RvDbtbTUte5KuQmn5UV5bNcomq7o3tCVFFx
	p0vX91+Ob0xXcTK/3HXn6uLb7FPuP6y/Xpv1+BWr9F7PY36NBf1eDrlruw0CoxfPSShlnyB2
	7FP2M/UvzQVP/n26mmt9rnvzDF7WkzNUDZVYijMSDbWYi4oTAU2wIr7gAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a test module doing varios nasty things like
out of bounds accesses, use after free. It is usefull for testing
kernel debugging features like kernel address sanitizer.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 lib/Kconfig.debug       |   8 ++
 lib/Makefile            |   1 +
 lib/test_kmalloc_bugs.c | 254 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 263 insertions(+)
 create mode 100644 lib/test_kmalloc_bugs.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 67a4dfc..64fd9e6 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -609,6 +609,14 @@ config DEBUG_STACKOVERFLOW
 
 	  If in doubt, say "N".
 
+config KMALLOC_BUG_TEST
+	tristate "Module for testing bugs detection in sl[auo]b"
+	default n
+	help
+	  This is a test module doing varios nasty things like
+	  out of bounds accesses, use after free. It is usefull for testing
+	  kernel debugging features like kernel address sanitizer.
+
 source "lib/Kconfig.kmemcheck"
 
 source "lib/Kconfig.kasan"
diff --git a/lib/Makefile b/lib/Makefile
index e48067c..af68259 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 obj-$(CONFIG_TEST_MODULE) += test_module.o
 obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
 obj-$(CONFIG_TEST_BPF) += test_bpf.o
+obj-$(CONFIG_KMALLOC_BUG_TEST) += test_kmalloc_bugs.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff --git a/lib/test_kmalloc_bugs.c b/lib/test_kmalloc_bugs.c
new file mode 100644
index 0000000..04cd11b
--- /dev/null
+++ b/lib/test_kmalloc_bugs.c
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
+#define pr_fmt(fmt) "kmalloc bug test: " fmt
+
+#include <linux/kernel.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/module.h>
+
+void __init kmalloc_oob_rigth(void)
+{
+	char *ptr;
+	size_t size = 123;
+
+	pr_info("out-of-bounds to right\n");
+	ptr = kmalloc(size , GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	ptr[size] = 'x';
+	kfree(ptr);
+}
+
+void __init kmalloc_oob_left(void)
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
+void __init kmalloc_node_oob_right(void)
+{
+	char *ptr;
+	size_t size = 4096;
+
+	pr_info("kmalloc_node(): out-of-bounds to right\n");
+	ptr = kmalloc_node(size , GFP_KERNEL, 0);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	ptr[size] = 0;
+	kfree(ptr);
+}
+
+void __init kmalloc_large_oob_rigth(void)
+{
+	char *ptr;
+	size_t size = PAGE_SIZE*3 - 10;
+
+	pr_info("kmalloc large allocation: out-of-bounds to right\n");
+	ptr = kmalloc(size , GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	ptr[size] = 0;
+	kfree(ptr);
+}
+
+void __init kmalloc_oob_krealloc_more(void)
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
+void __init kmalloc_oob_krealloc_less(void)
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
+void __init kmalloc_oob_16(void)
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
+void __init kmalloc_oob_in_memset(void)
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
+void __init kmalloc_uaf(void)
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
+	*ptr = 'x';
+}
+
+void __init kmalloc_uaf_memset(void)
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
+void __init kmalloc_uaf2(void)
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
+	ptr1[0] = 'x';
+	kfree(ptr2);
+}
+
+void __init kmem_cache_oob(void)
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
+	kmalloc_oob_rigth();
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
+	return 0;
+}
+
+module_init(kmalloc_tests_init);
+MODULE_LICENSE("GPL");
-- 
1.8.5.5

