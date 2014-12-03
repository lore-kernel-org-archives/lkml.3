Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaLCB6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:58:18 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:59334 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaLCB6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:58:13 -0500
Subject: [PATCH v3 1/3] MIPS: mips_flush_cache_range is added
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
To: <linux-mips@linux-mips.org>, <Zubair.Kakakhel@imgtec.com>,
        <geert+renesas@glider.be>, <david.daney@cavium.com>,
        <peterz@infradead.org>, <paul.gortmaker@windriver.com>,
        <davidlohr@hp.com>, <macro@linux-mips.org>, <chenhc@lemote.com>,
        <cl@linux.com>, <mingo@kernel.org>, <richard@nod.at>,
        <zajec5@gmail.com>, <james.hogan@imgtec.com>, <keescook@chromium.org>,
        <tj@kernel.org>, <alex@alex-smith.me.uk>, <pbonzini@redhat.com>,
        <blogic@openwrt.org>, <paul.burton@imgtec.com>,
        <qais.yousef@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <ralf@linux-mips.org>, <markos.chandras@imgtec.com>,
        <dengcheng.zhu@imgtec.com>, <manuel.lauss@gmail.com>,
        <lars.persson@axis.com>
Date: Tue, 2 Dec 2014 17:58:07 -0800
Message-ID: <20141203015807.13886.11049.stgit@linux-yegoshin>
In-Reply-To: <20141203015537.13886.50830.stgit@linux-yegoshin>
References: <20141203015537.13886.50830.stgit@linux-yegoshin>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New function mips_flush_cache_range() is added.
It flushes D-cache on kernel VA and I-cache on user VA.
It is significant in case of cache aliasing systems.
It can be used to flush a short sequence of newly written code
to user space and especially usefull in ptrace() and dsemul().
Today a full page is flushed by flush_cache_page in ptrace().

Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
---
 arch/mips/include/asm/cacheflush.h |    3 +++
 arch/mips/mm/c-octeon.c            |    8 +++++++
 arch/mips/mm/c-r3k.c               |    8 +++++++
 arch/mips/mm/c-r4k.c               |   43 ++++++++++++++++++++++++++++++++++++
 arch/mips/mm/c-tx39.c              |    9 ++++++++
 arch/mips/mm/cache.c               |    4 +++
 6 files changed, 75 insertions(+)

diff --git a/arch/mips/include/asm/cacheflush.h b/arch/mips/include/asm/cacheflush.h
index e08381a37f8b..83052417c262 100644
--- a/arch/mips/include/asm/cacheflush.h
+++ b/arch/mips/include/asm/cacheflush.h
@@ -94,6 +94,9 @@ extern void (*flush_cache_sigtramp)(unsigned long addr);
 extern void (*flush_icache_all)(void);
 extern void (*local_flush_data_cache_page)(void * addr);
 extern void (*flush_data_cache_page)(unsigned long addr);
+extern void (*mips_flush_data_cache_range)(struct vm_area_struct *vma,
+	unsigned long vaddr, struct page *page, unsigned long addr,
+	unsigned long size);
 
 /*
  * This flag is used to indicate that the page pointed to by a pte
diff --git a/arch/mips/mm/c-octeon.c b/arch/mips/mm/c-octeon.c
index 05b1d7cf9514..38349d177570 100644
--- a/arch/mips/mm/c-octeon.c
+++ b/arch/mips/mm/c-octeon.c
@@ -178,6 +178,13 @@ static void octeon_flush_kernel_vmap_range(unsigned long vaddr, int size)
 	BUG();
 }
 
+static void octeon_flush_data_cache_range(struct vm_area_struct *vma,
+       unsigned long vaddr, struct page *page, unsigned long addr,
+       unsigned long size)
+{
+	octeon_flush_cache_page(vma, addr, page_to_pfn(page));
+}
+
 /**
  * Probe Octeon's caches
  *
@@ -292,6 +299,7 @@ void octeon_cache_init(void)
 	flush_cache_sigtramp		= octeon_flush_cache_sigtramp;
 	flush_icache_all		= octeon_flush_icache_all;
 	flush_data_cache_page		= octeon_flush_data_cache_page;
+	mips_flush_data_cache_range     = octeon_flush_data_cache_range;
 	flush_icache_range		= octeon_flush_icache_range;
 	local_flush_icache_range	= local_octeon_flush_icache_range;
 
diff --git a/arch/mips/mm/c-r3k.c b/arch/mips/mm/c-r3k.c
index 135ec313c1f6..93b481046619 100644
--- a/arch/mips/mm/c-r3k.c
+++ b/arch/mips/mm/c-r3k.c
@@ -273,6 +273,13 @@ static void r3k_flush_data_cache_page(unsigned long addr)
 {
 }
 
+static void r3k_mips_flush_data_cache_range(struct vm_area_struct *vma,
+	unsigned long vaddr, struct page *page, unsigned long addr,
+	unsigned long size)
+{
+	r3k_flush_cache_page(vma, addr, page_to_pfn(page));
+}
+
 static void r3k_flush_cache_sigtramp(unsigned long addr)
 {
 	unsigned long flags;
@@ -322,6 +329,7 @@ void r3k_cache_init(void)
 	__flush_cache_all = r3k___flush_cache_all;
 	flush_cache_mm = r3k_flush_cache_mm;
 	flush_cache_range = r3k_flush_cache_range;
+	mips_flush_data_cache_range = r3k_mips_flush_data_cache_range;
 	flush_cache_page = r3k_flush_cache_page;
 	flush_icache_range = r3k_flush_icache_range;
 	local_flush_icache_range = r3k_flush_icache_range;
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index fbcd8674ff1d..becea85ddbb9 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -636,6 +636,48 @@ static void r4k_flush_data_cache_page(unsigned long addr)
 		r4k_on_each_cpu(local_r4k_flush_data_cache_page, (void *) addr);
 }
 
+struct mips_flush_data_cache_range_args {
+	struct vm_area_struct *vma;
+	unsigned long vaddr;
+	unsigned long start;
+	unsigned long len;
+};
+
+static inline void local_r4k_mips_flush_data_cache_range(void *args)
+{
+	struct mips_flush_data_cache_range_args *f_args = args;
+	unsigned long vaddr = f_args->vaddr;
+	unsigned long start = f_args->start;
+	unsigned long len = f_args->len;
+	struct vm_area_struct * vma = f_args->vma;
+
+	blast_dcache_range(start, start + len);
+
+	if ((vma->vm_flags & VM_EXEC) && !cpu_has_ic_fills_f_dc) {
+			wmb();
+
+		/* vma is given for exec check only, mmap is current,
+		   so - no non-current vma page flush, just user or kernel */
+		protected_blast_icache_range(vaddr, vaddr + len);
+	}
+}
+
+/* flush dirty kernel data and a corresponding user instructions (if needed).
+   used in copy_to_user_page() */
+static void r4k_mips_flush_data_cache_range(struct vm_area_struct *vma,
+	unsigned long vaddr, struct page *page, unsigned long start,
+	unsigned long len)
+{
+	struct mips_flush_data_cache_range_args args;
+
+	args.vma = vma;
+	args.vaddr = vaddr;
+	args.start = start;
+	args.len = len;
+
+	r4k_on_each_cpu(local_r4k_mips_flush_data_cache_range, (void *)&args);
+}
+
 struct flush_icache_range_args {
 	unsigned long start;
 	unsigned long end;
@@ -1656,6 +1698,7 @@ void r4k_cache_init(void)
 	flush_icache_all	= r4k_flush_icache_all;
 	local_flush_data_cache_page	= local_r4k_flush_data_cache_page;
 	flush_data_cache_page	= r4k_flush_data_cache_page;
+	mips_flush_data_cache_range = r4k_mips_flush_data_cache_range;
 	flush_icache_range	= r4k_flush_icache_range;
 	local_flush_icache_range	= local_r4k_flush_icache_range;
 
diff --git a/arch/mips/mm/c-tx39.c b/arch/mips/mm/c-tx39.c
index 8d909dbbf37f..9316e92ba08c 100644
--- a/arch/mips/mm/c-tx39.c
+++ b/arch/mips/mm/c-tx39.c
@@ -230,6 +230,13 @@ static void tx39_flush_data_cache_page(unsigned long addr)
 	tx39_blast_dcache_page(addr);
 }
 
+static void local_flush_data_cache_range(struct vm_area_struct *vma,
+       unsigned long vaddr, struct page *page, unsigned long addr,
+       unsigned long size)
+{
+	flush_cache_page(vma, addr, page_to_pfn(page));
+}
+
 static void tx39_flush_icache_range(unsigned long start, unsigned long end)
 {
 	if (end - start > dcache_size)
@@ -371,6 +378,7 @@ void tx39_cache_init(void)
 
 		flush_cache_sigtramp	= (void *) tx39h_flush_icache_all;
 		local_flush_data_cache_page	= (void *) tx39h_flush_icache_all;
+		mips_flush_data_cache_range     = (void *) local_flush_data_cache_range;
 		flush_data_cache_page	= (void *) tx39h_flush_icache_all;
 
 		_dma_cache_wback_inv	= tx39h_dma_cache_wback_inv;
@@ -402,6 +410,7 @@ void tx39_cache_init(void)
 
 		flush_cache_sigtramp = tx39_flush_cache_sigtramp;
 		local_flush_data_cache_page = local_tx39_flush_data_cache_page;
+		mips_flush_data_cache_range     = (void *) local_flush_data_cache_range;
 		flush_data_cache_page = tx39_flush_data_cache_page;
 
 		_dma_cache_wback_inv = tx39_dma_cache_wback_inv;
diff --git a/arch/mips/mm/cache.c b/arch/mips/mm/cache.c
index 7e3ea7766822..b7bdd01eee63 100644
--- a/arch/mips/mm/cache.c
+++ b/arch/mips/mm/cache.c
@@ -44,10 +44,14 @@ void (*__invalidate_kernel_vmap_range)(unsigned long vaddr, int size);
 void (*flush_cache_sigtramp)(unsigned long addr);
 void (*local_flush_data_cache_page)(void * addr);
 void (*flush_data_cache_page)(unsigned long addr);
+void (*mips_flush_data_cache_range)(struct vm_area_struct *vma,
+      unsigned long vaddr, struct page *page, unsigned long addr,
+      unsigned long size);
 void (*flush_icache_all)(void);
 
 EXPORT_SYMBOL_GPL(local_flush_data_cache_page);
 EXPORT_SYMBOL(flush_data_cache_page);
+EXPORT_SYMBOL(mips_flush_data_cache_range);
 EXPORT_SYMBOL(flush_icache_all);
 
 #if defined(CONFIG_DMA_NONCOHERENT) || defined(CONFIG_DMA_MAYBE_COHERENT)

