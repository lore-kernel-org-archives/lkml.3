Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbbALJUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:20:05 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25111 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbbALJT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:19:59 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-c4-54b391bc5d64
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-mm@kvack.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, andi@lisas.de,
        Mike Turquette <mturquette@linaro.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/5] mm/util: add kstrdup_const
Date: Mon, 12 Jan 2015 10:18:39 +0100
Message-id: <1421054323-14430-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
References: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xK7p7Jm4OMXi/WsPi1rpzrBZz1q9h
	szhy7Tu7xeV/b1gszja9AbJ2zWGzuLfmP6vF2iN32S2eTrjIZnH+73FWBy6P+Ts/Mnps+jSJ
	3ePOtT1sHidm/GbxWHJTzaNvyypGj8+b5Dw2PXnLFMARxWWTkpqTWZZapG+XwJWxfccFtoIj
	ohULL/xmaWDcJtjFyMkhIWAi8fDaI3YIW0ziwr31bF2MXBxCAksZJY4eXMMC4fQxSbyc9Y4R
	pIpNQFPi7+abbCC2CFDHxzOXmUGKmAVOMEms/9XIBJIQFtCXaJr4nxnEZhFQlZg/eSNYnFfA
	WeLx7/WsEOvkJE4emwxmcwq4SFzc+RasXgio5urB88wTGHkXMDKsYhRNLU0uKE5KzzXUK07M
	LS7NS9dLzs/dxAgJyS87GBcfszrEKMDBqMTDO0Fmc4gQa2JZcWXuIUYJDmYlEV7XMqAQb0pi
	ZVVqUX58UWlOavEhRiYOTqkGRu17d9Is97D6NpdxN/fu6NzXkrzd92qv9Jyj8owrBN/ZbXs7
	VXBBxNWGC4f8Jywsfv7+4STPmHMu9/d+sE693TA5+BXT/rhJ/EYvGEU3zO28+7Rqjc/bZ+//
	vznnbXvh94FDy++2MHbWybFm8lndFTwSfvZO0wuvHYyff7pob3ZfVjdbcL/kQn4lluKMREMt
	5qLiRAB83Zh9JwIAAA==
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
 mm/util.c              | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index 2e22a2e..b11ed1e 100644
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
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
 
diff --git a/mm/util.c b/mm/util.c
index fec39d4..7c62128 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -12,10 +12,30 @@
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
+/**
+ * kfree_const - conditionally free memory
+ * @x: pointer to the memory
+ *
+ * Function calls kfree only if @x is not in .rodata section.
+ */
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
@@ -38,6 +58,24 @@ char *kstrdup(const char *s, gfp_t gfp)
 EXPORT_SYMBOL(kstrdup);
 
 /**
+ * kstrdup_const - conditionally duplicate an existing const string
+ * @s: the string to duplicate
+ * @gfp: the GFP mask used in the kmalloc() call when allocating memory
+ *
+ * Function returns source string if it is in .rodata section otherwise it
+ * fallbacks to kstrdup.
+ * Strings allocated by kstrdup_const should be freed by kfree_const.
+ */
+const char *kstrdup_const(const char *s, gfp_t gfp)
+{
+	if (is_kernel_rodata((unsigned long)s))
+		return s;
+
+	return kstrdup(s, gfp);
+}
+EXPORT_SYMBOL(kstrdup_const);
+
+/**
  * kstrndup - allocate space for and copy an existing string
  * @s: the string to duplicate
  * @max: read at most @max chars from @s
-- 
1.9.1

