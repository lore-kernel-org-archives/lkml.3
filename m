Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbaHZGRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:17:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757241AbaHZGQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:16:28 -0400
From: Juergen Gross <jgross@suse.com>
To: stefan.bader@canonical.com, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, ville.syrjala@linux.intel.com, hpa@zytor.com,
        x86@kernel.org
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 2/3] x86: Enable PAT to use cache mode translation tables
Date: Tue, 26 Aug 2014 08:16:22 +0200
Message-Id: <1409033783-12136-3-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409033783-12136-1-git-send-email-jgross@suse.com>
References: <1409033783-12136-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the translation tables from cache mode to pgprot values according to
the PAT settings. This enables changing the cache attributes of a PAT index in
just one place without having to change at the users side.

With this change it is possible to use the same kernel with different PAT
configurations, e.g. supporting Xen.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/pat.h           |  1 +
 arch/x86/include/asm/pgtable_types.h |  4 +++
 arch/x86/mm/init.c                   |  8 ++++++
 arch/x86/mm/pat.c                    | 54 ++++++++++++++++++++++++++++++++++--
 include/linux/mm.h                   |  1 +
 5 files changed, 66 insertions(+), 2 deletions(-)

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
index 0d38511..bd2f50f 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -338,6 +338,10 @@ extern uint8_t __pte2cachemode_tbl[8];
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
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index ef75f3f..feb4d30 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -75,6 +75,57 @@ enum {
 	PAT_UC_MINUS = 7,	/* UC, but can be overriden by MTRR */
 };
 
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
+	char *cache_mode;
+	u64 pat;
+
+	rdmsrl(MSR_IA32_CR_PAT, pat);
+	pat_msg[32] = 0;
+	for (i = 7; i >= 0; i--) {
+		switch ((pat >> (i * 8)) & 7) {
+		case PAT_UC:
+			cache = _PAGE_CACHE_MODE_UC;
+			cache_mode = "UC  ";
+			break;
+		case PAT_WC:
+			cache = _PAGE_CACHE_MODE_WC;
+			cache_mode = "WC  ";
+			break;
+		case PAT_WT:
+			cache = _PAGE_CACHE_MODE_WT;
+			cache_mode = "WT  ";
+			break;
+		case PAT_WP:
+			cache = _PAGE_CACHE_MODE_WP;
+			cache_mode = "WP  ";
+			break;
+		case PAT_WB:
+			cache = _PAGE_CACHE_MODE_WB;
+			cache_mode = "WB  ";
+			break;
+		case PAT_UC_MINUS:
+			cache = _PAGE_CACHE_MODE_UC_MINUS;
+			cache_mode = "UC- ";
+			break;
+		default:
+			cache = _PAGE_CACHE_MODE_WB;
+			cache_mode = "WB  ";
+		}
+		update_cache_mode_entry(i, cache);
+		memcpy(pat_msg + 4 * i, cache_mode, 4);
+	}
+	pr_info("PAT configuration [0-7]: %s\n", pat_msg);
+}
+
 #define PAT(x, y)	((u64)PAT_ ## y << ((x)*8))
 
 void pat_init(void)
@@ -124,8 +175,7 @@ void pat_init(void)
 	wrmsrl(MSR_IA32_CR_PAT, pat);
 
 	if (boot_cpu)
-		printk(KERN_INFO "x86 PAT enabled: cpu %d, old 0x%Lx, new 0x%Lx\n",
-		       smp_processor_id(), boot_pat_state, pat);
+		pat_init_cache_modes();
 }
 
 #undef PAT
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8981cc8..d7bf551 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1574,6 +1574,7 @@ extern void free_area_init(unsigned long * zones_size);
 extern void free_area_init_node(int nid, unsigned long * zones_size,
 		unsigned long zone_start_pfn, unsigned long *zholes_size);
 extern void free_initmem(void);
+extern void update_cache_mode_entry(unsigned entry, enum page_cache_mode cache);
 
 /*
  * Free reserved pages within range [PAGE_ALIGN(start), end & PAGE_MASK)
-- 
1.8.4.5

