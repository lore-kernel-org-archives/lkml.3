Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbbAZXba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:31:30 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:57116 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbbAZXaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:30:00 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, arnd@arndb.de, linux-mm@kvack.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 2/7] lib: Add huge I/O map capability interfaces
Date: Mon, 26 Jan 2015 16:13:24 -0700
Message-Id: <1422314009-31667-3-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
References: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ioremap_pud_enabled() and ioremap_pmd_enabled(), which
return 1 when I/O mappings of pud/pmd are enabled on the kernel.

ioremap_huge_init() calls arch_ioremap_pud_supported() and
arch_ioremap_pmd_supported() to initialize the capabilities.

A new kernel option "nohgiomap" is also added, so that user can
disable the huge I/O map capabilities if necessary.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 include/linux/io.h                  |    5 ++++
 lib/ioremap.c                       |   44 +++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 176d4fe..e3de01c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2304,6 +2304,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			register save and restore. The kernel will only save
 			legacy floating-point registers on task switch.
 
+	nohgiomap	[KNL,x86] Disable huge I/O mappings.
+
 	noxsave		[BUGS=X86] Disables x86 extended register state save
 			and restore using xsave. The kernel will fallback to
 			enabling legacy floating-point and sse state.
diff --git a/include/linux/io.h b/include/linux/io.h
index fa02e55..8f5c8af 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -38,6 +38,11 @@ static inline int ioremap_page_range(unsigned long addr, unsigned long end,
 }
 #endif
 
+#ifdef CONFIG_HUGE_IOMAP
+int arch_ioremap_pud_supported(void);
+int arch_ioremap_pmd_supported(void);
+#endif
+
 /*
  * Managed iomap interface
  */
diff --git a/lib/ioremap.c b/lib/ioremap.c
index 0c9216c..0a1ecb6 100644
--- a/lib/ioremap.c
+++ b/lib/ioremap.c
@@ -13,6 +13,44 @@
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
+#ifdef CONFIG_HUGE_IOMAP
+int __read_mostly ioremap_pud_capable;
+int __read_mostly ioremap_pmd_capable;
+int __read_mostly ioremap_huge_disabled;
+
+static int __init set_nohgiomap(char *str)
+{
+	ioremap_huge_disabled = 1;
+	return 0;
+}
+early_param("nohgiomap", set_nohgiomap);
+
+static inline void ioremap_huge_init(void)
+{
+	if (!ioremap_huge_disabled) {
+		if (arch_ioremap_pud_supported())
+			ioremap_pud_capable = 1;
+		if (arch_ioremap_pmd_supported())
+			ioremap_pmd_capable = 1;
+	}
+}
+
+static inline int ioremap_pud_enabled(void)
+{
+	return ioremap_pud_capable;
+}
+
+static inline int ioremap_pmd_enabled(void)
+{
+	return ioremap_pmd_capable;
+}
+
+#else	/* !CONFIG_HUGE_IOMAP */
+static inline void ioremap_huge_init(void) { }
+static inline int ioremap_pud_enabled(void) { return 0; }
+static inline int ioremap_pmd_enabled(void) { return 0; }
+#endif	/* CONFIG_HUGE_IOMAP */
+
 static int ioremap_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
@@ -74,6 +112,12 @@ int ioremap_page_range(unsigned long addr,
 	unsigned long start;
 	unsigned long next;
 	int err;
+	static int ioremap_huge_init_done;
+
+	if (!ioremap_huge_init_done) {
+		ioremap_huge_init_done = 1;
+		ioremap_huge_init();
+	}
 
 	BUG_ON(addr >= end);
 
