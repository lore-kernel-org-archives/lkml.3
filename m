Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671AbaGOTrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:47:31 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:38540 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933346AbaGOTph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:45:37 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de, konrad.wilk@oracle.com,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stefan.bader@canonical.com, luto@amacapital.net, airlied@gmail.com,
        bp@alien8.de, Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 5/11] x86, mm: Add set_memory[_array]_wt() for setting WT
Date: Tue, 15 Jul 2014 13:34:38 -0600
Message-Id: <1405452884-25688-6-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces set_memory_wt() and set_memory_array_wt()
for setting a given range of the memory attribute to WT.

Note that reserve_memtype() only supports tracking of WT for
non-RAM ranges at this point.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/include/asm/cacheflush.h |    6 ++++-
 arch/x86/mm/pageattr.c            |   43 +++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index c80a3a1..050504b 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -69,7 +69,7 @@ static inline void set_page_memtype(struct page *pg, unsigned long memtype) { }
 /*
  * The set_memory_* API can be used to change various attributes of a virtual
  * address range. The attributes include:
- * Cachability   : UnCached, WriteCombining, WriteBack
+ * Cachability   : UnCached, WriteCombining, WriteThrough, WriteBack
  * Executability : eXeutable, NoteXecutable
  * Read/Write    : ReadOnly, ReadWrite
  * Presence      : NotPresent
@@ -96,9 +96,11 @@ static inline void set_page_memtype(struct page *pg, unsigned long memtype) { }
 
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
@@ -109,10 +111,12 @@ int set_memory_4k(unsigned long addr, int numpages);
 
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
index ae242a7..a2a1e70 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1562,6 +1562,43 @@ out_err:
 }
 EXPORT_SYMBOL(set_memory_wc);
 
+int set_memory_array_wt(unsigned long *addr, int addrinarray)
+{
+	return _set_memory_array(addr, addrinarray, _PAGE_CACHE_WT);
+}
+EXPORT_SYMBOL(set_memory_array_wt);
+
+int _set_memory_wt(unsigned long addr, int numpages)
+{
+	return change_page_attr_set(&addr, numpages,
+				    __pgprot(_PAGE_CACHE_WT), 0);
+}
+
+int set_memory_wt(unsigned long addr, int numpages)
+{
+	int ret;
+
+	if (!pat_enabled)
+		return set_memory_uc(addr, numpages);
+
+	ret = reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
+		_PAGE_CACHE_WT, NULL);
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
 	return change_page_attr_clear(&addr, numpages,
@@ -1699,6 +1736,12 @@ int set_pages_array_wc(struct page **pages, int addrinarray)
 }
 EXPORT_SYMBOL(set_pages_array_wc);
 
+int set_pages_array_wt(struct page **pages, int addrinarray)
+{
+	return _set_pages_array(pages, addrinarray, _PAGE_CACHE_WT);
+}
+EXPORT_SYMBOL(set_pages_array_wt);
+
 int set_pages_wb(struct page *page, int numpages)
 {
 	unsigned long addr = (unsigned long)page_address(page);
