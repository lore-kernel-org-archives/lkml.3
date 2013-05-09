Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3EITqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:46:55 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:50919 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3EITqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:46:51 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC/PATCH v2 1/8] Add arch_phys_wc_{add,del} to manipulate WC MTRRs if needed
Date: Thu,  9 May 2013 12:46:20 -0700
Message-Id: <97346b603822ffd8ab446316fc08fbf7686c9d50.1368128020.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <cover.1368128020.git.luto@amacapital.net>
References: <cover.1368128020.git.luto@amacapital.net>
In-Reply-To: <cover.1368128020.git.luto@amacapital.net>
References: <cover.1368128020.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several drivers currently use mtrr_add through various #ifdef guards
and/or drm wrappers.  The vast majority of them want to add WC MTRRs
on x86 systems and don't actually need the MTRR if PAT (i.e.
ioremap_wc, etc) are working.

arch_phys_wc_add and arch_phys_wc_del are new functions, available
on all architectures and configurations, that add WC MTRRs on x86 if
needed (and handle errors) and do nothing at all otherwise.  They're
also easier to use than mtrr_add and mtrr_del, so the call sites can
be simplified.

As an added benefit, this will avoid wasting MTRRs and possibly
warning pointlessly on PAT-supporting systems.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/io.h       |  7 ++++++
 arch/x86/include/asm/mtrr.h     |  5 ++++-
 arch/x86/kernel/cpu/mtrr/main.c | 48 +++++++++++++++++++++++++++++++++++++++++
 include/linux/io.h              | 25 +++++++++++++++++++++
 4 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index d8e8eef..34f69cb 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -345,4 +345,11 @@ extern bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
 
 #define IO_SPACE_LIMIT 0xffff
 
+#ifdef CONFIG_MTRR
+extern int __must_check arch_phys_wc_add(unsigned long base,
+					 unsigned long size);
+extern void arch_phys_wc_del(int handle);
+#define arch_phys_wc_add arch_phys_wc_add
+#endif
+
 #endif /* _ASM_X86_IO_H */
diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index e235582..10d0fba 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -26,7 +26,10 @@
 #include <uapi/asm/mtrr.h>
 
 
-/*  The following functions are for use by other drivers  */
+/*
+ * The following functions are for use by other drivers that cannot use
+ * arch_phys_wc_add and arch_phys_wc_del.
+ */
 # ifdef CONFIG_MTRR
 extern u8 mtrr_type_lookup(u64 addr, u64 end);
 extern void mtrr_save_fixed_ranges(void *);
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 726bf96..23bd49a 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -51,6 +51,7 @@
 #include <asm/e820.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
+#include <asm/pat.h>
 
 #include "mtrr.h"
 
@@ -524,6 +525,53 @@ int mtrr_del(int reg, unsigned long base, unsigned long size)
 }
 EXPORT_SYMBOL(mtrr_del);
 
+/**
+ * arch_phys_wc_add - add a WC MTRR and handle errors if PAT is unavailable
+ * @base: Physical base address
+ * @size: Size of region
+ *
+ * If PAT is available, this does nothing.  If PAT is unavailable, it
+ * attempts to add a WC MTRR covering size bytes starting at base and
+ * logs an error if this fails.
+ *
+ * Drivers must store the return value to pass to mtrr_del_wc_if_needed,
+ * but drivers should not try to interpret that return value.
+ */
+int arch_phys_wc_add(unsigned long base, unsigned long size)
+{
+	int ret;
+
+	if (pat_enabled)
+		return 0;  /* Success!  (We don't need to do anything.) */
+
+	ret = mtrr_add(base, size, MTRR_TYPE_WRCOMB, true);
+	if (ret < 0) {
+		pr_warn("Failed to add WC MTRR for [%p-%p]; performance may suffer.",
+			(void *)base, (void *)(base + size - 1));
+		return ret;
+	}
+	return ret + 1000;
+}
+EXPORT_SYMBOL(arch_phys_wc_add);
+
+/*
+ * arch_phys_wc_del - undoes arch_phys_wc_add
+ * @handle: Return value from arch_phys_wc_add
+ *
+ * This cleans up after mtrr_add_wc_if_needed.
+ *
+ * The API guarantees that mtrr_del_wc_if_needed(error code) and
+ * mtrr_del_wc_if_needed(0) do nothing.
+ */
+extern void arch_phys_wc_del(int handle)
+{
+	if (handle >= 1) {
+		WARN_ON(handle < 1000);
+		mtrr_del(handle - 1000, 0, 0);
+	}
+}
+EXPORT_SYMBOL(arch_phys_wc_del);
+
 /*
  * HACK ALERT!
  * These should be called implicitly, but we can't yet until all the initcall
diff --git a/include/linux/io.h b/include/linux/io.h
index 069e407..f4f42fa 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -76,4 +76,29 @@ void devm_ioremap_release(struct device *dev, void *res);
 #define arch_has_dev_port()     (1)
 #endif
 
+/*
+ * Some systems (x86 without PAT) have a somewhat reliable way to mark a
+ * physical address range such that uncached mappings will actually
+ * end up write-combining.  This facility should be used in conjunction
+ * with pgprot_writecombine, ioremap-wc, or set_memory_wc, since it has
+ * no effect if the per-page mechanisms are functional.
+ * (On x86 without PAT, these functions manipulate MTRRs.)
+ *
+ * arch_phys_del_wc(0) or arch_phys_del_wc(any error code) is guaranteed
+ * to have no effect.
+ */
+#ifndef arch_phys_wc_add
+static inline int __must_check arch_phys_wc_add(unsigned long base,
+						unsigned long size)
+{
+	return 0;  /* It worked (i.e. did nothing). */
+}
+
+static inline void arch_phys_wc_del(int handle)
+{
+}
+
+#define arch_phys_wc_add arch_phys_wc_add
+#endif
+
 #endif /* _LINUX_IO_H */
-- 
1.8.1.4

