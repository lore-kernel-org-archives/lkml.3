Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901Ab3ECXA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 19:00:58 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:58395 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763763Ab3ECXAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 19:00:54 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org
Subject: [PATCH 1/7] x86: Add mtrr_{add,del}_wc_if_needed
Date: Fri,  3 May 2013 16:00:29 -0700
Message-Id: <e4281b0d2c36d94a1e8b98d73ec7cc29f6161e43.1367621039.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <cover.1367621038.git.luto@amacapital.net>
References: <cover.1367621038.git.luto@amacapital.net>
In-Reply-To: <cover.1367621038.git.luto@amacapital.net>
References: <cover.1367621038.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These MTRR helpers add a WC MTRR if PAT is disabled.  Modern drivers should
be using ioremap_wc, etc. to get WC memory; the MTRR is just a fallback
if the system doesn't have PAT.  So, rather than allocating an unnecessary
MTRR even on PAT systems and having error handling spread out and handled
differently by different drivers, consolidate it all and don't waste the
MTRR on PAT-supporting systems.  (Follow-up changes will update drivers.)

This should be a simple change, a bit of a clean-up, and it will flush
out any drivers that actually depend on the MTRR for write combining.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/mtrr.h     | 21 ++++++++++++++++
 arch/x86/kernel/cpu/mtrr/main.c | 53 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index e235582..cc96c72 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -45,6 +45,18 @@ extern void mtrr_aps_init(void);
 extern void mtrr_bp_restore(void);
 extern int mtrr_trim_uncached_memory(unsigned long end_pfn);
 extern int amd_special_default_mtrr(void);
+
+/*
+ * These are for drivers (mostly video) that want to add WC MTRRs as a
+ * fallback if PAT is unavailable.  There is no need to check for errors.
+ *
+ * The handles used by the _if_needed functions are *not* MTRR indices.
+ * mtrr_del_wc_if_needed(0) and mtrr_del_wc_if_needed(-1) are
+ * guaranteed to have no effect.
+ */
+extern int __must_check mtrr_add_wc_if_needed(unsigned long base,
+					      unsigned long size);
+extern void mtrr_del_wc_if_needed(int handle);
 #  else
 static inline u8 mtrr_type_lookup(u64 addr, u64 end)
 {
@@ -86,6 +98,15 @@ static inline void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi)
 #define set_mtrr_aps_delayed_init() do {} while (0)
 #define mtrr_aps_init() do {} while (0)
 #define mtrr_bp_restore() do {} while (0)
+
+static inline int __must_check mtrr_add_wc_if_needed(unsigned long base,
+						     unsigned long size)
+{
+	return -ENODEV;
+}
+static inline void mtrr_del_wc_if_needed(int handle)
+{
+}
 #  endif
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 726bf96..6370238 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -51,6 +51,7 @@
 #include <asm/e820.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
+#include <asm/pat.h>
 
 #include "mtrr.h"
 
@@ -524,6 +525,58 @@ int mtrr_del(int reg, unsigned long base, unsigned long size)
 }
 EXPORT_SYMBOL(mtrr_del);
 
+/**
+ * mtrr_add_wc_if_needed - add a WC MTRR and handle errors if PAT is unavailable
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
+int mtrr_add_wc_if_needed(unsigned long base, unsigned long size)
+{
+	int ret;
+
+	if (pat_enabled) {
+		/*
+		 * Don't bother -- we don't need the MTRR.  Return an error
+		 * so that no one gets confused.
+		 */
+		return -EBUSY;  /* The error doesn't matter. */
+	}
+
+	ret = mtrr_add(base, size, MTRR_TYPE_WRCOMB, true);
+	if (ret < 0) {
+	  pr_warn("Failed to add WC MTRR for [%p-%p]; performance will suffer.",
+		  (void *)base, (void *)(base + size - 1));
+		return ret;
+	}
+	return ret + 1000;
+}
+EXPORT_SYMBOL(mtrr_add_wc_if_needed);
+
+/*
+ * mtrr_del_wc_if_needed - undoes mtrr_add_wc_if_needed
+ * @handle: Return value from mtrr_add_wc_if_needed
+ *
+ * This cleans up after mtrr_add_wc_if_needed.
+ *
+ * The API guarantees that mtrr_del_wc_if_needed(-1) and
+ * mtrr_del_wc_if_needed(0) do nothing.
+ */
+extern void mtrr_del_wc_if_needed(int handle)
+{
+	if (handle >= 1) {
+		WARN_ON(handle < 1000);
+		mtrr_del(handle - 1000, 0, 0);
+	}
+}
+EXPORT_SYMBOL(mtrr_del_wc_if_needed);
+
 /*
  * HACK ALERT!
  * These should be called implicitly, but we can't yet until all the initcall
-- 
1.8.1.4

