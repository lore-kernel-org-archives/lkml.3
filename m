Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaL2OuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:50:25 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29909 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaL2OuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:50:07 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-d1-54a16a1d91a8
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-mm@kvack.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/4] mm/util: add kstrdup_const
Date: Mon, 29 Dec 2014 15:48:27 +0100
Message-id: <1419864510-24834-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1419864510-24834-1-git-send-email-a.hajda@samsung.com>
References: <1419864510-24834-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFJMWRmVeSWpSXmKPExsVy+t/xq7qyWQtDDE7vsrS4te4cq8XlXXPY
	LO6t+c9qsfbIXXYHFo9Nnyaxe/RtWcXo8XmTXABzFJdNSmpOZllqkb5dAldG+9s3zAX9ghWX
	n8xhbWD8ztvFyMkhIWAisfPgHlYIW0ziwr31bF2MXBxCAksZJf7OWwqWEBLoY5L4t6EexGYT
	0JT4u/kmG4gtAtTw8cxl5i5GDg5mgRKJW2fFQMLCAsYSO/Z+YQGxWQRUJa6dmQ82hlfAWeLx
	9jaoXXISJ49NZgVp5RRwkfjbFQexyVni55Ip7BMYeRcwMqxiFE0tTS4oTkrPNdIrTswtLs1L
	10vOz93ECAmPrzsYlx6zOsQowMGoxMObcGJBiBBrYllxZe4hRgkOZiURXmnLhSFCvCmJlVWp
	RfnxRaU5qcWHGJk4OKUaGGfwsrbuemd66KzU8ov8557LFSxI+hf9rvOu7I9DrYwzTs30DLl6
	UlBX9cCMtUcPHT2d5fItZ3HAlOhtks0NT2KbJ/pc+lm+wO23rdEim75DP71Pz5m5U17pvZGM
	mnpiRDLbdwmhiqwFuVknZ/pv+fqFPfzrsu+XpVT+c6f7tvTPdJDYYPP4zDklluKMREMt5qLi
	RACfynzb7QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds alternative version of kstrdup which returns pointer
to constant char array. The function checks if input string is in
persistent and read-only memory section, if yes it returns the input string,
otherwise it fallbacks to kstrdup.
kstrdup_const is accompanied by kfree_const performing conditional memory
deallocation of the string.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 include/linux/string.h |  3 +++
 mm/util.c              | 22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index a0c6fd5..c9cd44e 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -115,7 +115,10 @@ extern void * memchr(const void *,int,__kernel_size_t);
 #endif
 void *memchr_inv(const void *s, int c, size_t n);
 
+extern void kfree_const(const void *x);
+
 extern char *kstrdup(const char *s, gfp_t gfp);
+extern const char *kstrdup_const(const char *s, gfp_t gfp);
 extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
 extern char *kstrimdup(const char *s, gfp_t gfp);
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
diff --git a/mm/util.c b/mm/util.c
index d25558b..7fc0094 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -13,10 +13,24 @@
 #include <linux/hugetlb.h>
 #include <linux/vmalloc.h>
 
+#include <asm/sections.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
 
+static inline int is_kernel_rodata(unsigned long addr)
+{
+	return addr >= (unsigned long)__start_rodata &&
+		addr < (unsigned long)__end_rodata;
+}
+
+void kfree_const(const void *x)
+{
+	if (!is_kernel_rodata((unsigned long)x))
+		kfree(x);
+}
+EXPORT_SYMBOL(kfree_const);
+
 /**
  * kstrdup - allocate space for and copy an existing string
  * @s: the string to duplicate
@@ -38,6 +52,14 @@ char *kstrdup(const char *s, gfp_t gfp)
 }
 EXPORT_SYMBOL(kstrdup);
 
+const char *kstrdup_const(const char *s, gfp_t gfp)
+{
+	if (is_kernel_rodata((unsigned long)s))
+		return s;
+
+	return kstrdup(s, gfp);
+}
+
 /**
  * kstrndup - allocate space for and copy an existing string
  * @s: the string to duplicate
-- 
1.9.1

