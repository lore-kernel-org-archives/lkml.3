Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaKSBov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 20:44:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43635 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbaKSBoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 20:44:46 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Vrabel <david.vrabel@citrix.com>, Wang Nan <wangnan0@huawei.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/4] x86, 64bit: remove highmap for not needed ranges
Date: Tue, 18 Nov 2014 17:44:16 -0800
Message-Id: <1416361456-11060-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1416361456-11060-1-git-send-email-yinghai@kernel.org>
References: <1416361456-11060-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add cleanup_highmap_late to remove highmap for initmem, around rodata, and
[_brk_end, all_end).

Kernel Layout:

[    0.000000]   .text: [0x01000000-0x0200df88]
[    0.000000] .rodata: [0x02200000-0x02a1dfff]
[    0.000000]   .data: [0x02c00000-0x02e510ff]
[    0.000000]   .init: [0x02e53000-0x03213fff]
[    0.000000]    .bss: [0x03222000-0x0437cfff]
[    0.000000]    .brk: [0x0437d000-0x043a2fff]

Actually used brk:
[    0.270365] memblock_reserve: [0x0000000437d000-0x00000004383fff] flags 0x0 BRK

Before patch:
---[ High Kernel Mapping ]---
---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000          16M                           pmd
0xffffffff81000000-0xffffffff82000000          16M     ro         PSE GLB x  pmd
0xffffffff82000000-0xffffffff82011000          68K     ro             GLB x  pte
0xffffffff82011000-0xffffffff82200000        1980K     RW             GLB x  pte
0xffffffff82200000-0xffffffff82a00000           8M     ro         PSE GLB NX pmd
0xffffffff82a00000-0xffffffff82a1e000         120K     ro             GLB NX pte
0xffffffff82a1e000-0xffffffff82c00000        1928K     RW             GLB NX pte
0xffffffff82c00000-0xffffffff82e00000           2M     RW         PSE GLB NX pmd
0xffffffff82e00000-0xffffffff83000000           2M     RW             GLB NX pte
0xffffffff83000000-0xffffffff83200000           2M     RW         PSE GLB NX pmd
0xffffffff83200000-0xffffffff83400000           2M     RW             GLB NX pte
0xffffffff83400000-0xffffffff84400000          16M     RW         PSE GLB NX pmd
0xffffffff84400000-0xffffffffa0000000         444M                           pmd

After patch:
---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000          16M                           pmd
0xffffffff81000000-0xffffffff82000000          16M     ro         PSE GLB x  pmd
0xffffffff82000000-0xffffffff82012000          72K     ro             GLB x  pte
0xffffffff82012000-0xffffffff82200000        1976K                           pte
0xffffffff82200000-0xffffffff82a00000           8M     ro         PSE GLB NX pmd
0xffffffff82a00000-0xffffffff82a1e000         120K     ro             GLB NX pte
0xffffffff82a1e000-0xffffffff82c00000        1928K                           pte
0xffffffff82c00000-0xffffffff82e00000           2M     RW         PSE GLB NX pmd
0xffffffff82e00000-0xffffffff82e53000         332K     RW             GLB NX pte
0xffffffff82e53000-0xffffffff83000000        1716K                           pte
0xffffffff83000000-0xffffffff83200000           2M                           pmd
0xffffffff83200000-0xffffffff83214000          80K                           pte
0xffffffff83214000-0xffffffff83400000        1968K     RW             GLB NX pte
0xffffffff83400000-0xffffffff84200000          14M     RW         PSE GLB NX pmd
0xffffffff84200000-0xffffffff84384000        1552K     RW             GLB NX pte
0xffffffff84384000-0xffffffff84400000         496K                           pte
0xffffffff84400000-0xffffffffa0000000         444M                           pmd

So remove some range before rodata with RW+x.

-v4: adapt it to all_end change.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_64.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -1101,6 +1101,61 @@ void __init mem_init(void)
 }
 
 #ifdef CONFIG_DEBUG_RODATA
+static void remove_highmap_2m(unsigned long addr)
+{
+	pgd_t *pgd = pgd_offset_k(addr);
+	pud_t *pud = (pud_t *)pgd_page_vaddr(*pgd) + pud_index(addr);
+	pmd_t *pmd = (pmd_t *)pud_page_vaddr(*pud) + pmd_index(addr);
+
+	set_pmd(pmd, __pmd(0));
+}
+
+static void remove_highmap_2m_partial(unsigned long addr, unsigned long end)
+{
+	int i;
+	pgd_t *pgd = pgd_offset_k(addr);
+	pud_t *pud = (pud_t *)pgd_page_vaddr(*pgd) + pud_index(addr);
+	pmd_t *pmd = (pmd_t *)pud_page_vaddr(*pud) + pmd_index(addr);
+	pte_t *pte = (pte_t *)pmd_page_vaddr(*pmd) + pte_index(addr);
+
+	for (i = pte_index(addr); i < pte_index(end - 1) + 1; i++, pte++)
+		set_pte(pte, __pte(0));
+}
+
+static void cleanup_highmap_late(unsigned long start, unsigned long end)
+{
+	unsigned long addr;
+	unsigned long start_2m_aligned = roundup(start, PMD_SIZE);
+	unsigned long end_2m_aligned = rounddown(end, PMD_SIZE);
+
+	start = PFN_ALIGN(start);
+	end &= PAGE_MASK;
+
+	if (start >= end)
+		return;
+
+	if (start < start_2m_aligned) {
+		unsigned long tmp = min(start_2m_aligned, end);
+
+		set_memory_4k(start, (tmp - start) >> PAGE_SHIFT);
+		remove_highmap_2m_partial(start, tmp);
+	}
+
+	for (addr = start_2m_aligned; addr < end_2m_aligned; addr += PMD_SIZE)
+		remove_highmap_2m(addr);
+
+	if (start <= end_2m_aligned && end_2m_aligned < end) {
+		set_memory_4k(end_2m_aligned,
+				(end - end_2m_aligned) >> PAGE_SHIFT);
+		remove_highmap_2m_partial(end_2m_aligned, end);
+	}
+
+	subtract_range(pfn_highmapped, NR_RANGE,
+			__pa_symbol(start) >> PAGE_SHIFT,
+			__pa_symbol(end) >> PAGE_SHIFT);
+	nr_pfn_highmapped = clean_sort_range(pfn_highmapped, NR_RANGE);
+}
+
 const int rodata_test_data = 0xC3;
 EXPORT_SYMBOL_GPL(rodata_test_data);
 
@@ -1149,6 +1204,7 @@ void mark_rodata_ro(void)
 	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
 	unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
 	unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
+	unsigned long data_start = PFN_ALIGN(&_sdata);
 	unsigned long all_end;
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
@@ -1172,6 +1228,12 @@ void mark_rodata_ro(void)
 	all_end = roundup(_brk_end, PMD_SIZE);
 	set_memory_nx(rodata_start, (all_end - rodata_start) >> PAGE_SHIFT);
 
+	cleanup_highmap_late(text_end, rodata_start);
+	cleanup_highmap_late(rodata_end, data_start);
+	cleanup_highmap_late(PFN_ALIGN(_brk_end), all_end);
+	cleanup_highmap_late((unsigned long)(&__init_begin),
+				(unsigned long)(&__init_end));
+
 	rodata_test();
 
 #ifdef CONFIG_CPA_DEBUG
