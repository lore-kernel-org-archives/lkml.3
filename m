Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbbAZXaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:30:15 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:54949 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410AbbAZXaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:30:06 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, arnd@arndb.de, linux-mm@kvack.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 6/7] x86, mm: Support huge I/O mappings on x86
Date: Mon, 26 Jan 2015 16:13:28 -0700
Message-Id: <1422314009-31667-7-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
References: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement huge I/O mapping capability interfaces on x86.

Also define IOREMAP_MAX_ORDER to the size of PUD or PMD on x86.
When IOREMAP_MAX_ORDER is not defined on x86, it will be defined
to the default value in <linux/vmalloc.h>.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/include/asm/page_types.h |    8 ++++++++
 arch/x86/mm/ioremap.c             |   16 ++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index f97fbe3..debbfff 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -38,6 +38,14 @@
 
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 
+#ifdef CONFIG_HUGE_IOMAP
+#ifdef CONFIG_X86_64
+#define IOREMAP_MAX_ORDER       (PUD_SHIFT)
+#elif defined(PMD_SHIFT)
+#define IOREMAP_MAX_ORDER       (PMD_SHIFT)
+#endif
+#endif  /* CONFIG_HUGE_IOMAP */
+
 #ifdef CONFIG_X86_64
 #include <asm/page_64_types.h>
 #else
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index fdf617c..ef32bec 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -326,6 +326,22 @@ void iounmap(volatile void __iomem *addr)
 }
 EXPORT_SYMBOL(iounmap);
 
+#ifdef CONFIG_HUGE_IOMAP
+int arch_ioremap_pud_supported(void)
+{
+#ifdef CONFIG_X86_64
+	return cpu_has_gbpages;
+#else
+	return 0;
+#endif
+}
+
+int arch_ioremap_pmd_supported(void)
+{
+	return cpu_has_pse;
+}
+#endif	/* CONFIG_HUGE_IOMAP */
+
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
