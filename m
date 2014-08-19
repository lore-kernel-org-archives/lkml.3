Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaHSN0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 09:26:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbaHSNZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 09:25:59 -0400
From: jgross@suse.com
To: stefan.bader@canonical.com, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, ville.syrjala@linux.intel.com, hpa@zytor.com,
        x86@kernel.org
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH RFC 2/3] x86: Enable PAT to use cache mode translation tables
Date: Tue, 19 Aug 2014 15:25:44 +0200
Message-Id: <1408454745-32358-3-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1408454745-32358-1-git-send-email-jgross@suse.com>
References: <1408454745-32358-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

Update the translation tables from cache mode to pgprot values according to
the PAT settings. This enables changing the cache attributes of a PAT index in
just one place without having to change at the users side.

With this change it is possible to use the same kernel with different PAT
configurations, e.g. supporting Xen.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/pat.h           |  1 +
 arch/x86/include/asm/pgtable_types.h |  4 +++
 arch/x86/mm/init.c                   |  8 +++++
 arch/x86/mm/pat.c                    | 57 +++++++++++++++++++++++++++++++++++-
 include/linux/mm.h                   |  1 +
 5 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pat.h b/arch/x86/include/asm/pat.h
index 65b497b..a7816e1 100644
--- a/arch/x86/include/asm/pat.h
+++ b/arch/x86/include/asm/pat.h
@@ -11,6 +11,7 @@ static const int pat_enabled;
 #endif
 
 extern void pat_init(void);
+void pat_init_cache_modes(u64 pat);
 
 extern int reserve_memtype(u64 start, u64 end,
 		enum page_cache_mode req_pct, enum page_cache_mode *ret_pct);
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 7685b34..45c720e 100644
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
 
 static inline unsigned long protval_cachemode(enum page_cache_mode pct)
 {
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 0500124..d2ebe70 100644
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
index 0ba0d79..ac8a5d4 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -75,6 +75,55 @@ enum {
 	PAT_UC_MINUS = 7,	/* UC, but can be overriden by MTRR */
 };
 
+/*
+ * Update the cache mode to pgprot translation tables according to PAT
+ * configuration.
+ * Using lower indices is preferred, so we start with highest index.
+ */
+void pat_init_cache_modes(u64 pat)
+{
+	int i;
+	enum page_cache_mode cache;
+	char pat_msg[33];
+	char *cache_mode;
+
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
@@ -118,8 +167,14 @@ void pat_init(void)
 	      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, UC);
 
 	/* Boot CPU check */
-	if (!boot_pat_state)
+	if (!boot_pat_state) {
 		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
+		/*
+		 * Init cache mode tables before writing MSR to give Xen a
+		 * chance to correct the changes when doing the write.
+		 */
+		pat_init_cache_modes(pat);
+	}
 
 	wrmsrl(MSR_IA32_CR_PAT, pat);
 
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

