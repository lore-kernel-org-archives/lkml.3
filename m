Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaKDWTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:19:33 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:10342 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbaKDWS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:18:57 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, luto@amacapital.net, hmh@hmh.eng.br,
        yigal@plexistor.com, konrad.wilk@oracle.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v5 8/8] x86, mm: Add set_memory_wt() for WT
Date: Tue,  4 Nov 2014 15:04:38 -0700
Message-Id: <1415138678-22958-9-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415138678-22958-1-git-send-email-toshi.kani@hp.com>
References: <1415138678-22958-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds set_memory_wt(), set_memory_array_wt() and
set_pages_array_wt() for setting specified range(s) of the
regular memory to WT.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 Documentation/x86/pat.txt         |    9 ++++--
 arch/x86/include/asm/cacheflush.h |    6 +++-
 arch/x86/mm/pageattr.c            |   58 +++++++++++++++++++++++++++++++++----
 3 files changed, 63 insertions(+), 10 deletions(-)

diff --git a/Documentation/x86/pat.txt b/Documentation/x86/pat.txt
index be7b8c2..bf4339c 100644
--- a/Documentation/x86/pat.txt
+++ b/Documentation/x86/pat.txt
@@ -46,6 +46,9 @@ set_memory_uc          |    UC-   |    --      |       --         |
 set_memory_wc          |    WC    |    --      |       --         |
  set_memory_wb         |          |            |                  |
                        |          |            |                  |
+set_memory_wt          |    WT    |    --      |       --         |
+ set_memory_wb         |          |            |                  |
+                       |          |            |                  |
 pci sysfs resource     |    --    |    --      |       UC-        |
                        |          |            |                  |
 pci sysfs resource_wc  |    --    |    --      |       WC         |
@@ -117,8 +120,8 @@ can be more restrictive, in case of any existing aliasing for that address.
 For example: If there is an existing uncached mapping, a new ioremap_wc can
 return uncached mapping in place of write-combine requested.
 
-set_memory_[uc|wc] and set_memory_wb should be used in pairs, where driver will
-first make a region uc or wc and switch it back to wb after use.
+set_memory_[uc|wc|wt] and set_memory_wb should be used in pairs, where driver
+will first make a region uc, wc or wt and switch it back to wb after use.
 
 Over time writes to /proc/mtrr will be deprecated in favor of using PAT based
 interfaces. Users writing to /proc/mtrr are suggested to use above interfaces.
@@ -126,7 +129,7 @@ interfaces. Users writing to /proc/mtrr are suggested to use above interfaces.
 Drivers should use ioremap_[uc|wc] to access PCI BARs with [uc|wc] access
 types.
 
-Drivers should use set_memory_[uc|wc] to set access type for RAM ranges.
+Drivers should use set_memory_[uc|wc|wt] to set access type for RAM ranges.
 
 
 PAT debugging
diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 47c8e32..b6f7457 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -8,7 +8,7 @@
 /*
  * The set_memory_* API can be used to change various attributes of a virtual
  * address range. The attributes include:
- * Cachability   : UnCached, WriteCombining, WriteBack
+ * Cachability   : UnCached, WriteCombining, WriteThrough, WriteBack
  * Executability : eXeutable, NoteXecutable
  * Read/Write    : ReadOnly, ReadWrite
  * Presence      : NotPresent
@@ -35,9 +35,11 @@
 
 int _set_memory_uc(unsigned long addr, int numpages);
 int _set_memory_wc(unsigned long addr, int numpages);
+int _set_memory_wt(unsigned long addr, int numpages);
 int _set_memory_wb(unsigned long addr, int numpages);
 int set_memory_uc(unsigned long addr, int numpages);
 int set_memory_wc(unsigned long addr, int numpages);
+int set_memory_wt(unsigned long addr, int numpages);
 int set_memory_wb(unsigned long addr, int numpages);
 int set_memory_x(unsigned long addr, int numpages);
 int set_memory_nx(unsigned long addr, int numpages);
@@ -48,10 +50,12 @@ int set_memory_4k(unsigned long addr, int numpages);
 
 int set_memory_array_uc(unsigned long *addr, int addrinarray);
 int set_memory_array_wc(unsigned long *addr, int addrinarray);
+int set_memory_array_wt(unsigned long *addr, int addrinarray);
 int set_memory_array_wb(unsigned long *addr, int addrinarray);
 
 int set_pages_array_uc(struct page **pages, int addrinarray);
 int set_pages_array_wc(struct page **pages, int addrinarray);
+int set_pages_array_wt(struct page **pages, int addrinarray);
 int set_pages_array_wb(struct page **pages, int addrinarray);
 
 /*
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 114d0b3..c98dcdb 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1484,12 +1484,10 @@ EXPORT_SYMBOL(set_memory_uc);
 static int _set_memory_array(unsigned long *addr, int addrinarray,
 		enum page_cache_mode new_type)
 {
+	enum page_cache_mode set_type;
 	int i, j;
 	int ret;
 
-	/*
-	 * for now UC MINUS. see comments in ioremap_nocache()
-	 */
 	for (i = 0; i < addrinarray; i++) {
 		ret = reserve_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE,
 					new_type, NULL);
@@ -1497,9 +1495,12 @@ static int _set_memory_array(unsigned long *addr, int addrinarray,
 			goto out_free;
 	}
 
+	/* If WC, set to UC- first and then WC */
+	set_type = (new_type == _PAGE_CACHE_MODE_WC) ?
+				_PAGE_CACHE_MODE_UC_MINUS : new_type;
+
 	ret = change_page_attr_set(addr, addrinarray,
-				   cachemode2pgprot(_PAGE_CACHE_MODE_UC_MINUS),
-				   1);
+				   cachemode2pgprot(set_type), 1);
 
 	if (!ret && new_type == _PAGE_CACHE_MODE_WC)
 		ret = change_page_attr_set_clr(addr, addrinarray,
@@ -1531,6 +1532,12 @@ int set_memory_array_wc(unsigned long *addr, int addrinarray)
 }
 EXPORT_SYMBOL(set_memory_array_wc);
 
+int set_memory_array_wt(unsigned long *addr, int addrinarray)
+{
+	return _set_memory_array(addr, addrinarray, _PAGE_CACHE_MODE_WT);
+}
+EXPORT_SYMBOL(set_memory_array_wt);
+
 int _set_memory_wc(unsigned long addr, int numpages)
 {
 	int ret;
@@ -1571,6 +1578,34 @@ out_err:
 }
 EXPORT_SYMBOL(set_memory_wc);
 
+int _set_memory_wt(unsigned long addr, int numpages)
+{
+	return change_page_attr_set(&addr, numpages,
+				    cachemode2pgprot(_PAGE_CACHE_MODE_WT), 0);
+}
+
+int set_memory_wt(unsigned long addr, int numpages)
+{
+	int ret;
+
+	ret = reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
+			      _PAGE_CACHE_MODE_WT, NULL);
+	if (ret)
+		goto out_err;
+
+	ret = _set_memory_wt(addr, numpages);
+	if (ret)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
+out_err:
+	return ret;
+}
+EXPORT_SYMBOL(set_memory_wt);
+
 int _set_memory_wb(unsigned long addr, int numpages)
 {
 	/* WB cache mode is hard wired to all cache attribute bits being 0 */
@@ -1663,6 +1698,7 @@ static int _set_pages_array(struct page **pages, int addrinarray,
 {
 	unsigned long start;
 	unsigned long end;
+	enum page_cache_mode set_type;
 	int i;
 	int free_idx;
 	int ret;
@@ -1676,8 +1712,12 @@ static int _set_pages_array(struct page **pages, int addrinarray,
 			goto err_out;
 	}
 
+	/* If WC, set to UC- first and then WC */
+	set_type = (new_type == _PAGE_CACHE_MODE_WC) ?
+				_PAGE_CACHE_MODE_UC_MINUS : new_type;
+
 	ret = cpa_set_pages_array(pages, addrinarray,
-			cachemode2pgprot(_PAGE_CACHE_MODE_UC_MINUS));
+				  cachemode2pgprot(set_type));
 	if (!ret && new_type == _PAGE_CACHE_MODE_WC)
 		ret = change_page_attr_set_clr(NULL, addrinarray,
 					       cachemode2pgprot(
@@ -1711,6 +1751,12 @@ int set_pages_array_wc(struct page **pages, int addrinarray)
 }
 EXPORT_SYMBOL(set_pages_array_wc);
 
+int set_pages_array_wt(struct page **pages, int addrinarray)
+{
+	return _set_pages_array(pages, addrinarray, _PAGE_CACHE_MODE_WT);
+}
+EXPORT_SYMBOL(set_pages_array_wt);
+
 int set_pages_wb(struct page *page, int numpages)
 {
 	unsigned long addr = (unsigned long)page_address(page);
