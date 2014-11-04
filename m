Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbaKDWSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:18:48 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:53333 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaKDWSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:18:46 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, luto@amacapital.net, hmh@hmh.eng.br,
        yigal@plexistor.com, konrad.wilk@oracle.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v5 2/8] x86, mm, pat, asm: Move [get|set]_page_memtype() to pat.c
Date: Tue,  4 Nov 2014 15:04:32 -0700
Message-Id: <1415138678-22958-3-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415138678-22958-1-git-send-email-toshi.kani@hp.com>
References: <1415138678-22958-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[set|get]_page_memtype() are used by PAT and implemented under
CONFIG_X86_PAT only.  set_page_memtype() only handles three
memory types, WB, WC and UC-, due to a limitation in the page flags.

This patch moves [set|get]_page_memtype() to pat.c.  This keeps
them as PAT-internal functions and manages the limitation checked
by the caller properly.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/cacheflush.h |   69 -------------------------------------
 arch/x86/mm/pat.c                 |   58 +++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 69 deletions(-)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 157644b..47c8e32 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -5,75 +5,6 @@
 #include <asm-generic/cacheflush.h>
 #include <asm/special_insns.h>
 
-#ifdef CONFIG_X86_PAT
-/*
- * X86 PAT uses page flags WC and Uncached together to keep track of
- * memory type of pages that have backing page struct. X86 PAT supports 3
- * different memory types, _PAGE_CACHE_MODE_WB, _PAGE_CACHE_MODE_WC and
- * _PAGE_CACHE_MODE_UC_MINUS and fourth state where page's memory type has not
- * been changed from its default (value of -1 used to denote this).
- * Note we do not support _PAGE_CACHE_MODE_UC here.
- */
-
-#define _PGMT_DEFAULT		0
-#define _PGMT_WC		(1UL << PG_arch_1)
-#define _PGMT_UC_MINUS		(1UL << PG_uncached)
-#define _PGMT_WB		(1UL << PG_uncached | 1UL << PG_arch_1)
-#define _PGMT_MASK		(1UL << PG_uncached | 1UL << PG_arch_1)
-#define _PGMT_CLEAR_MASK	(~_PGMT_MASK)
-
-static inline enum page_cache_mode get_page_memtype(struct page *pg)
-{
-	unsigned long pg_flags = pg->flags & _PGMT_MASK;
-
-	if (pg_flags == _PGMT_DEFAULT)
-		return -1;
-	else if (pg_flags == _PGMT_WC)
-		return _PAGE_CACHE_MODE_WC;
-	else if (pg_flags == _PGMT_UC_MINUS)
-		return _PAGE_CACHE_MODE_UC_MINUS;
-	else
-		return _PAGE_CACHE_MODE_WB;
-}
-
-static inline void set_page_memtype(struct page *pg,
-				    enum page_cache_mode memtype)
-{
-	unsigned long memtype_flags;
-	unsigned long old_flags;
-	unsigned long new_flags;
-
-	switch (memtype) {
-	case _PAGE_CACHE_MODE_WC:
-		memtype_flags = _PGMT_WC;
-		break;
-	case _PAGE_CACHE_MODE_UC_MINUS:
-		memtype_flags = _PGMT_UC_MINUS;
-		break;
-	case _PAGE_CACHE_MODE_WB:
-		memtype_flags = _PGMT_WB;
-		break;
-	default:
-		memtype_flags = _PGMT_DEFAULT;
-		break;
-	}
-
-	do {
-		old_flags = pg->flags;
-		new_flags = (old_flags & _PGMT_CLEAR_MASK) | memtype_flags;
-	} while (cmpxchg(&pg->flags, old_flags, new_flags) != old_flags);
-}
-#else
-static inline enum page_cache_mode get_page_memtype(struct page *pg)
-{
-	return -1;
-}
-static inline void set_page_memtype(struct page *pg,
-				    enum page_cache_mode memtype)
-{
-}
-#endif
-
 /*
  * The set_memory_* API can be used to change various attributes of a virtual
  * address range. The attributes include:
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index f43ab47..91c01b9 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/rbtree.h>
+#include <linux/page-flags.h>
 
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
@@ -290,6 +291,63 @@ static int pat_pagerange_is_ram(resource_size_t start, resource_size_t end)
 }
 
 /*
+ * X86 PAT uses page flags WC and Uncached together to keep track of
+ * memory type of pages that have backing page struct. X86 PAT supports 3
+ * different memory types, _PAGE_CACHE_MODE_WB, _PAGE_CACHE_MODE_WC and
+ * _PAGE_CACHE_MODE_UC_MINUS and fourth state where page's memory type has not
+ * been changed from its default (value of -1 used to denote this).
+ * Note we do not support _PAGE_CACHE_MODE_UC here.
+ */
+#define _PGMT_DEFAULT		0
+#define _PGMT_WC		(1UL << PG_arch_1)
+#define _PGMT_UC_MINUS		(1UL << PG_uncached)
+#define _PGMT_WB		(1UL << PG_uncached | 1UL << PG_arch_1)
+#define _PGMT_MASK		(1UL << PG_uncached | 1UL << PG_arch_1)
+#define _PGMT_CLEAR_MASK	(~_PGMT_MASK)
+
+static inline enum page_cache_mode get_page_memtype(struct page *pg)
+{
+	unsigned long pg_flags = pg->flags & _PGMT_MASK;
+
+	if (pg_flags == _PGMT_DEFAULT)
+		return -1;
+	else if (pg_flags == _PGMT_WC)
+		return _PAGE_CACHE_MODE_WC;
+	else if (pg_flags == _PGMT_UC_MINUS)
+		return _PAGE_CACHE_MODE_UC_MINUS;
+	else
+		return _PAGE_CACHE_MODE_WB;
+}
+
+static inline void set_page_memtype(struct page *pg,
+				    enum page_cache_mode memtype)
+{
+	unsigned long memtype_flags;
+	unsigned long old_flags;
+	unsigned long new_flags;
+
+	switch (memtype) {
+	case _PAGE_CACHE_MODE_WC:
+		memtype_flags = _PGMT_WC;
+		break;
+	case _PAGE_CACHE_MODE_UC_MINUS:
+		memtype_flags = _PGMT_UC_MINUS;
+		break;
+	case _PAGE_CACHE_MODE_WB:
+		memtype_flags = _PGMT_WB;
+		break;
+	default:
+		memtype_flags = _PGMT_DEFAULT;
+		break;
+	}
+
+	do {
+		old_flags = pg->flags;
+		new_flags = (old_flags & _PGMT_CLEAR_MASK) | memtype_flags;
+	} while (cmpxchg(&pg->flags, old_flags, new_flags) != old_flags);
+}
+
+/*
  * For RAM pages, we use page flags to mark the pages with appropriate type.
  * Here we do two pass:
  * - Find the memtype of all the pages in the range, look for any conflicts
