Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaKCNDC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:03:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbaKCNCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:02:19 -0500
From: Juergen Gross <jgross@suse.com>
To: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V6 17/18] x86: Enable PAT to use cache mode translation tables
Date: Mon,  3 Nov 2014 14:02:03 +0100
Message-Id: <1415019724-4317-18-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1415019724-4317-1-git-send-email-jgross@suse.com>
References: <1415019724-4317-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the translation tables from cache mode to pgprot values
according to the PAT settings. This enables changing the cache
attributes of a PAT index in just one place without having to change
at the users side.

With this change it is possible to use the same kernel with different
PAT configurations, e.g. supporting Xen.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/pat.h           |  1 +
 arch/x86/include/asm/pgtable_types.h |  4 +++
 arch/x86/mm/init.c                   |  8 ++++++
 arch/x86/mm/mm_internal.h            |  2 ++
 arch/x86/mm/pat.c                    | 50 ++++++++++++++++++++++++++++++++++--
 5 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pat.h b/arch/x86/include/asm/pat.h
index 150407a..91bc4ba 100644
--- a/arch/x86/include/asm/pat.h
+++ b/arch/x86/include/asm/pat.h
@@ -11,6 +11,7 @@ static const int pat_enabled;
 #endif
 
 extern void pat_init(void);
+void pat_init_cache_modes(void);
 
 extern int reserve_memtype(u64 start, u64 end,
 		enum page_cache_mode req_pcm, enum page_cache_mode *ret_pcm);
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 6d5f6d1..af447f9 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -351,6 +351,10 @@ extern uint8_t __pte2cachemode_tbl[8];
 	((((cb) >> (_PAGE_BIT_PAT - 2)) & 4) |		\
 	 (((cb) >> (_PAGE_BIT_PCD - 1)) & 2) |		\
 	 (((cb) >> _PAGE_BIT_PWT) & 1))
+#define __cm_idx2pte(i)					\
+	((((i) & 4) << (_PAGE_BIT_PAT - 2)) |		\
+	 (((i) & 2) << (_PAGE_BIT_PCD - 1)) |		\
+	 (((i) & 1) << _PAGE_BIT_PWT))
 
 static inline unsigned long cachemode2protval(enum page_cache_mode pcm)
 {
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index a9776ba..82b41d5 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -716,3 +716,11 @@ void __init zone_sizes_init(void)
 	free_area_init_nodes(max_zone_pfns);
 }
 
+void update_cache_mode_entry(unsigned entry, enum page_cache_mode cache)
+{
+	/* entry 0 MUST be WB (hardwired to speed up translations) */
+	BUG_ON(!entry && cache != _PAGE_CACHE_MODE_WB);
+
+	__cachemode2pte_tbl[cache] = __cm_idx2pte(entry);
+	__pte2cachemode_tbl[entry] = cache;
+}
diff --git a/arch/x86/mm/mm_internal.h b/arch/x86/mm/mm_internal.h
index 6b563a1..62474ba 100644
--- a/arch/x86/mm/mm_internal.h
+++ b/arch/x86/mm/mm_internal.h
@@ -16,4 +16,6 @@ void zone_sizes_init(void);
 
 extern int after_bootmem;
 
+void update_cache_mode_entry(unsigned entry, enum page_cache_mode cache);
+
 #endif	/* __X86_MM_INTERNAL_H */
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index ef75f3f..4c60127 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -31,6 +31,7 @@
 #include <asm/io.h>
 
 #include "pat_internal.h"
+#include "mm_internal.h"
 
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_enabled = 1;
@@ -75,6 +76,52 @@ enum {
 	PAT_UC_MINUS = 7,	/* UC, but can be overriden by MTRR */
 };
 
+#define CM(c) (_PAGE_CACHE_MODE_ ## c)
+
+static enum page_cache_mode pat_get_cache_mode(unsigned pat_val, char *msg)
+{
+	enum page_cache_mode cache;
+	char *cache_mode;
+
+	switch (pat_val) {
+	case PAT_UC:       cache = CM(UC);       cache_mode = "UC  "; break;
+	case PAT_WC:       cache = CM(WC);       cache_mode = "WC  "; break;
+	case PAT_WT:       cache = CM(WT);       cache_mode = "WT  "; break;
+	case PAT_WP:       cache = CM(WP);       cache_mode = "WP  "; break;
+	case PAT_WB:       cache = CM(WB);       cache_mode = "WB  "; break;
+	case PAT_UC_MINUS: cache = CM(UC_MINUS); cache_mode = "UC- "; break;
+	default:           cache = CM(WB);       cache_mode = "WB  "; break;
+	}
+
+	memcpy(msg, cache_mode, 4);
+
+	return cache;
+}
+
+#undef CM
+
+/*
+ * Update the cache mode to pgprot translation tables according to PAT
+ * configuration.
+ * Using lower indices is preferred, so we start with highest index.
+ */
+void pat_init_cache_modes(void)
+{
+	int i;
+	enum page_cache_mode cache;
+	char pat_msg[33];
+	u64 pat;
+
+	rdmsrl(MSR_IA32_CR_PAT, pat);
+	pat_msg[32] = 0;
+	for (i = 7; i >= 0; i--) {
+		cache = pat_get_cache_mode((pat >> (i * 8)) & 7,
+					   pat_msg + 4 * i);
+		update_cache_mode_entry(i, cache);
+	}
+	pr_info("PAT configuration [0-7]: %s\n", pat_msg);
+}
+
 #define PAT(x, y)	((u64)PAT_ ## y << ((x)*8))
 
 void pat_init(void)
@@ -124,8 +171,7 @@ void pat_init(void)
 	wrmsrl(MSR_IA32_CR_PAT, pat);
 
 	if (boot_cpu)
-		printk(KERN_INFO "x86 PAT enabled: cpu %d, old 0x%Lx, new 0x%Lx\n",
-		       smp_processor_id(), boot_pat_state, pat);
+		pat_init_cache_modes();
 }
 
 #undef PAT
-- 
1.8.4.5

