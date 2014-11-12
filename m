Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaKLQxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:53:18 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:45046 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbaKLQxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:53:16 -0500
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Nov 2014 11:53:16 EST
X-Spam-Flag: NO
X-Spam-Score: -4.399
From: Khalid Aziz <khalid.aziz@oracle.com>
To: davem@davemloft.net, bob.picco@oracle.com, sam@ravnborg.org,
        mgorman@suse.de, riel@redhat.com, tkhai@yandex.ru,
        allen.pais@oracle.com, sfr@canb.auug.org.au,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org
Cc: Khalid Aziz <khalid.aziz@oracle.com>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sparc64: Resolve conflict between sparc v9 and M7 on usage of bit 9 of TTE
Date: Wed, 12 Nov 2014 09:45:41 -0700
Message-Id: <1415810741-25131-1-git-send-email-khalid.aziz@oracle.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparc64: Resolve conflict between sparc v9 and M7 on usage of bit 9 of TTE

Bit 9 of TTE is CV (Cacheable in V-cache) on sparc v9 processor while
the same bit 9 is MCDE (Memory Corruption Detection Enable) on M7
processor. This creates a conflicting usage of the same bit. Kernel
sets TTE.cv bit on all pages for sun4v architecture which works well
for sparc v9, but sets memory corruption detection bit on M7 processor
which is not the intent. This patch adds code to determine if kernel
is running on M7 processor and takes steps to not enable memory
corruption detection in TTE erroneously.

Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
---

Bits 63:60 of VA hold the version tag when MCD is enabled. Version tag
values of 0x0 and 0xf are reserved values and are ignored for detecting
MCD error. This makes it ok for kernel to run with TTE.mcde=1 for now
and we could possibly avoid making changes to vmemmap_populate(),
kern_large_tte() and sun4v_linear_pte_xor_finalize(). On the other
hand, if processor designers choose to change this behavior in future,
this could cause nasty breakage in the kernel. It is also not right to
set a bit in TTE when the actual function of that bit is different from
the intent of the code. In any case, I am ok with removing changes to
kernel TTE setup functions if these changes cause concern.

 arch/sparc/include/asm/pgtable_64.h | 22 ++++++++-
 arch/sparc/include/asm/trap_block.h |  2 +
 arch/sparc/kernel/entry.h           |  2 +
 arch/sparc/kernel/setup_64.c        | 27 +++++++++++
 arch/sparc/kernel/vmlinux.lds.S     |  5 ++
 arch/sparc/mm/init_64.c             | 93 ++++++++++++++++++++++++++++++-------
 6 files changed, 133 insertions(+), 18 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index bfeb626..0f37720 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -310,12 +310,26 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t prot)
 	"	sllx		%1, 32, %1\n"
 	"	or		%0, %1, %0\n"
 	"	.previous\n"
+	"	.section	.sun_m7_2insn_patch, \"ax\"\n"
+	"	.word		661b\n"
+	"	sethi		%%uhi(%4), %1\n"
+	"	sethi		%%hi(%4), %0\n"
+	"	.word		662b\n"
+	"	or		%1, %%ulo(%4), %1\n"
+	"	or		%0, %%lo(%4), %0\n"
+	"	.word		663b\n"
+	"	sllx		%1, 32, %1\n"
+	"	or		%0, %1, %0\n"
+	"	.previous\n"
 	: "=r" (mask), "=r" (tmp)
 	: "i" (_PAGE_PADDR_4U | _PAGE_MODIFIED_4U | _PAGE_ACCESSED_4U |
 	       _PAGE_CP_4U | _PAGE_CV_4U | _PAGE_E_4U |
 	       _PAGE_SPECIAL | _PAGE_PMD_HUGE | _PAGE_SZALL_4U),
 	  "i" (_PAGE_PADDR_4V | _PAGE_MODIFIED_4V | _PAGE_ACCESSED_4V |
 	       _PAGE_CP_4V | _PAGE_CV_4V | _PAGE_E_4V |
+	       _PAGE_SPECIAL | _PAGE_PMD_HUGE | _PAGE_SZALL_4V),
+	  "i" (_PAGE_PADDR_4V | _PAGE_MODIFIED_4V | _PAGE_ACCESSED_4V |
+	       _PAGE_CP_4V | _PAGE_E_4V |
 	       _PAGE_SPECIAL | _PAGE_PMD_HUGE | _PAGE_SZALL_4V));
 
 	return __pte((pte_val(pte) & mask) | (pgprot_val(prot) & ~mask));
@@ -360,9 +374,15 @@ static inline pgprot_t pgprot_noncached(pgprot_t prot)
 	"	andn		%0, %4, %0\n"
 	"	or		%0, %5, %0\n"
 	"	.previous\n"
+	"	.section	.sun_m7_2insn_patch, \"ax\"\n"
+	"	.word		661b\n"
+	"	andn		%0, %6, %0\n"
+	"	or		%0, %5, %0\n"
+	"	.previous\n"
 	: "=r" (val)
 	: "0" (val), "i" (_PAGE_CP_4U | _PAGE_CV_4U), "i" (_PAGE_E_4U),
-	             "i" (_PAGE_CP_4V | _PAGE_CV_4V), "i" (_PAGE_E_4V));
+			"i" (_PAGE_CP_4V | _PAGE_CV_4V), "i" (_PAGE_E_4V),
+			"i" (_PAGE_CP_4V));
 
 	return __pgprot(val);
 }
diff --git a/arch/sparc/include/asm/trap_block.h b/arch/sparc/include/asm/trap_block.h
index 6fd4436..ec9c04d 100644
--- a/arch/sparc/include/asm/trap_block.h
+++ b/arch/sparc/include/asm/trap_block.h
@@ -79,6 +79,8 @@ struct sun4v_2insn_patch_entry {
 };
 extern struct sun4v_2insn_patch_entry __sun4v_2insn_patch,
 	__sun4v_2insn_patch_end;
+extern struct sun4v_2insn_patch_entry __sun_m7_2insn_patch,
+	__sun_m7_2insn_patch_end;
 
 
 #endif /* !(__ASSEMBLY__) */
diff --git a/arch/sparc/kernel/entry.h b/arch/sparc/kernel/entry.h
index 88d322b..9e10fe8 100644
--- a/arch/sparc/kernel/entry.h
+++ b/arch/sparc/kernel/entry.h
@@ -69,6 +69,8 @@ void sun4v_patch_1insn_range(struct sun4v_1insn_patch_entry *,
 			     struct sun4v_1insn_patch_entry *);
 void sun4v_patch_2insn_range(struct sun4v_2insn_patch_entry *,
 			     struct sun4v_2insn_patch_entry *);
+void sun_m7_patch_2insn_range(struct sun4v_2insn_patch_entry *,
+			     struct sun4v_2insn_patch_entry *);
 extern unsigned int dcache_parity_tl1_occurred;
 extern unsigned int icache_parity_tl1_occurred;
 
diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index c38d19f..606e3f9 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -255,6 +255,30 @@ void sun4v_patch_2insn_range(struct sun4v_2insn_patch_entry *start,
 	}
 }
 
+void sun_m7_patch_2insn_range(struct sun4v_2insn_patch_entry *start,
+			     struct sun4v_2insn_patch_entry *end)
+{
+	while (start < end) {
+		unsigned long addr = start->addr;
+
+		*(unsigned int *) (addr +  0) = start->insns[0];
+		/* We are updating an instruction. Make sure it is
+		 * written out
+		 */
+		wmb();
+		__asm__ __volatile__("flush	%0" : : "r" (addr +  0));
+
+		*(unsigned int *) (addr +  4) = start->insns[1];
+		/* We are updating an instruction. Make sure it is
+		 * written out
+		 */
+		wmb();
+		__asm__ __volatile__("flush	%0" : : "r" (addr +  4));
+
+		start++;
+	}
+}
+
 static void __init sun4v_patch(void)
 {
 	extern void sun4v_hvapi_init(void);
@@ -267,6 +291,9 @@ static void __init sun4v_patch(void)
 
 	sun4v_patch_2insn_range(&__sun4v_2insn_patch,
 				&__sun4v_2insn_patch_end);
+	if (sun4v_chip_type == SUN4V_CHIP_SPARC_M7)
+		sun_m7_patch_2insn_range(&__sun_m7_2insn_patch,
+				&__sun_m7_2insn_patch_end);
 
 	sun4v_hvapi_init();
 }
diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index 0924305..f1a2f68 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -138,6 +138,11 @@ SECTIONS
 		*(.pause_3insn_patch)
 		__pause_3insn_patch_end = .;
 	}
+	.sun_m7_2insn_patch : {
+		__sun_m7_2insn_patch = .;
+		*(.sun_m7_2insn_patch)
+		__sun_m7_2insn_patch_end = .;
+	}
 	PERCPU_SECTION(SMP_CACHE_BYTES)
 
 	. = ALIGN(PAGE_SIZE);
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 2d91c62..706aeab8 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1909,11 +1909,24 @@ static void __init sun4u_linear_pte_xor_finalize(void)
 
 static void __init sun4v_linear_pte_xor_finalize(void)
 {
+	unsigned long pagecv_flag;
+
+	/* Bit 9 of TTE is no longer CV bit on M7 processor and it instead
+	 * enables MCD error. Do not set bit 9 on M7 processor.
+	 */
+	switch (sun4v_chip_type) {
+	case SUN4V_CHIP_SPARC_M7:
+		pagecv_flag = 0x00;
+		break;
+	default:
+		pagecv_flag = _PAGE_CV_4V;
+		break;
+	}
 #ifndef CONFIG_DEBUG_PAGEALLOC
 	if (cpu_pgsz_mask & HV_PGSZ_MASK_256MB) {
 		kern_linear_pte_xor[1] = (_PAGE_VALID | _PAGE_SZ256MB_4V) ^
 			PAGE_OFFSET;
-		kern_linear_pte_xor[1] |= (_PAGE_CP_4V | _PAGE_CV_4V |
+		kern_linear_pte_xor[1] |= (_PAGE_CP_4V | pagecv_flag |
 					   _PAGE_P_4V | _PAGE_W_4V);
 	} else {
 		kern_linear_pte_xor[1] = kern_linear_pte_xor[0];
@@ -1922,7 +1935,7 @@ static void __init sun4v_linear_pte_xor_finalize(void)
 	if (cpu_pgsz_mask & HV_PGSZ_MASK_2GB) {
 		kern_linear_pte_xor[2] = (_PAGE_VALID | _PAGE_SZ2GB_4V) ^
 			PAGE_OFFSET;
-		kern_linear_pte_xor[2] |= (_PAGE_CP_4V | _PAGE_CV_4V |
+		kern_linear_pte_xor[2] |= (_PAGE_CP_4V | pagecv_flag |
 					   _PAGE_P_4V | _PAGE_W_4V);
 	} else {
 		kern_linear_pte_xor[2] = kern_linear_pte_xor[1];
@@ -1931,7 +1944,7 @@ static void __init sun4v_linear_pte_xor_finalize(void)
 	if (cpu_pgsz_mask & HV_PGSZ_MASK_16GB) {
 		kern_linear_pte_xor[3] = (_PAGE_VALID | _PAGE_SZ16GB_4V) ^
 			PAGE_OFFSET;
-		kern_linear_pte_xor[3] |= (_PAGE_CP_4V | _PAGE_CV_4V |
+		kern_linear_pte_xor[3] |= (_PAGE_CP_4V | pagecv_flag |
 					   _PAGE_P_4V | _PAGE_W_4V);
 	} else {
 		kern_linear_pte_xor[3] = kern_linear_pte_xor[2];
@@ -2310,10 +2323,22 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
 	pte_base = (_PAGE_VALID | _PAGE_SZ4MB_4U |
 		    _PAGE_CP_4U | _PAGE_CV_4U |
 		    _PAGE_P_4U | _PAGE_W_4U);
+	/* Bit 9 of TTE has been redefined to be MCD error detection
+	 * enable bit on M7 processor. Make sure we do not turn this
+	 * bit on erroneously on M7
+	 */
 	if (tlb_type == hypervisor)
-		pte_base = (_PAGE_VALID | _PAGE_SZ4MB_4V |
-			    _PAGE_CP_4V | _PAGE_CV_4V |
-			    _PAGE_P_4V | _PAGE_W_4V);
+		switch (sun4v_chip_type) {
+		case SUN4V_CHIP_SPARC_M7:
+			pte_base = (_PAGE_VALID | _PAGE_SZ4MB_4V |
+				_PAGE_CP_4V | _PAGE_P_4V | _PAGE_W_4V);
+			break;
+		default:
+			pte_base = (_PAGE_VALID | _PAGE_SZ4MB_4V |
+				_PAGE_CP_4V | _PAGE_CV_4V |
+				_PAGE_P_4V | _PAGE_W_4V);
+			break;
+		}
 
 	pte_base |= _PAGE_PMD_HUGE;
 
@@ -2446,18 +2471,35 @@ static void __init sun4u_pgprot_init(void)
 static void __init sun4v_pgprot_init(void)
 {
 	unsigned long page_none, page_shared, page_copy, page_readonly;
-	unsigned long page_exec_bit;
+	unsigned long page_exec_bit, page_cache4v_flag;
 	int i;
 
+	/* TTE.cv bit on sparc v9 occupies the same position as TTE.mcde
+	 * bit on M7 processor. This is a conflicting usage of the same
+	 * bit. Enabling TTE.cv on M7 would turn on Memory Corruption
+	 * Detection error on all pages and this will lead to problems
+	 * later. Kernel does not run with MCD enabled and hence rest
+	 * of the required steps to fully configure memory corruption
+	 * detection are not taken. We need to ensure TTE.mcde is not
+	 * set on M7 processor
+	 */
+	switch (sun4v_chip_type) {
+	case SUN4V_CHIP_SPARC_M7:
+		page_cache4v_flag = _PAGE_CP_4V;
+		break;
+	default:
+		page_cache4v_flag = _PAGE_CACHE_4V;
+		break;
+	}
 	PAGE_KERNEL = __pgprot (_PAGE_PRESENT_4V | _PAGE_VALID |
-				_PAGE_CACHE_4V | _PAGE_P_4V |
+				page_cache4v_flag | _PAGE_P_4V |
 				__ACCESS_BITS_4V | __DIRTY_BITS_4V |
 				_PAGE_EXEC_4V);
 	PAGE_KERNEL_LOCKED = PAGE_KERNEL;
 
 	_PAGE_IE = _PAGE_IE_4V;
 	_PAGE_E = _PAGE_E_4V;
-	_PAGE_CACHE = _PAGE_CACHE_4V;
+	_PAGE_CACHE = page_cache4v_flag;
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	kern_linear_pte_xor[0] = _PAGE_VALID ^ PAGE_OFFSET;
@@ -2465,8 +2507,16 @@ static void __init sun4v_pgprot_init(void)
 	kern_linear_pte_xor[0] = (_PAGE_VALID | _PAGE_SZ4MB_4V) ^
 		PAGE_OFFSET;
 #endif
-	kern_linear_pte_xor[0] |= (_PAGE_CP_4V | _PAGE_CV_4V |
+	switch (sun4v_chip_type) {
+	case SUN4V_CHIP_SPARC_M7:
+		kern_linear_pte_xor[0] |= (_PAGE_CP_4V | _PAGE_P_4V |
+				   _PAGE_W_4V);
+		break;
+	default:
+		kern_linear_pte_xor[0] |= (_PAGE_CP_4V | _PAGE_CV_4V |
 				   _PAGE_P_4V | _PAGE_W_4V);
+		break;
+	}
 
 	for (i = 1; i < 4; i++)
 		kern_linear_pte_xor[i] = kern_linear_pte_xor[0];
@@ -2479,12 +2529,12 @@ static void __init sun4v_pgprot_init(void)
 			     _PAGE_SZ4MB_4V | _PAGE_SZ512K_4V |
 			     _PAGE_SZ64K_4V | _PAGE_SZ8K_4V);
 
-	page_none = _PAGE_PRESENT_4V | _PAGE_ACCESSED_4V | _PAGE_CACHE_4V;
-	page_shared = (_PAGE_VALID | _PAGE_PRESENT_4V | _PAGE_CACHE_4V |
+	page_none = _PAGE_PRESENT_4V | _PAGE_ACCESSED_4V | page_cache4v_flag;
+	page_shared = (_PAGE_VALID | _PAGE_PRESENT_4V | page_cache4v_flag |
 		       __ACCESS_BITS_4V | _PAGE_WRITE_4V | _PAGE_EXEC_4V);
-	page_copy   = (_PAGE_VALID | _PAGE_PRESENT_4V | _PAGE_CACHE_4V |
+	page_copy   = (_PAGE_VALID | _PAGE_PRESENT_4V | page_cache4v_flag |
 		       __ACCESS_BITS_4V | _PAGE_EXEC_4V);
-	page_readonly = (_PAGE_VALID | _PAGE_PRESENT_4V | _PAGE_CACHE_4V |
+	page_readonly = (_PAGE_VALID | _PAGE_PRESENT_4V | page_cache4v_flag |
 			 __ACCESS_BITS_4V | _PAGE_EXEC_4V);
 
 	page_exec_bit = _PAGE_EXEC_4V;
@@ -2541,9 +2591,18 @@ static unsigned long kern_large_tte(unsigned long paddr)
 	       _PAGE_CP_4U | _PAGE_CV_4U | _PAGE_P_4U |
 	       _PAGE_EXEC_4U | _PAGE_L_4U | _PAGE_W_4U);
 	if (tlb_type == hypervisor)
-		val = (_PAGE_VALID | _PAGE_SZ4MB_4V |
-		       _PAGE_CP_4V | _PAGE_CV_4V | _PAGE_P_4V |
-		       _PAGE_EXEC_4V | _PAGE_W_4V);
+		switch (sun4v_chip_type) {
+		case SUN4V_CHIP_SPARC_M7:
+			val = (_PAGE_VALID | _PAGE_SZ4MB_4V |
+			       _PAGE_CP_4V | _PAGE_P_4V |
+			       _PAGE_EXEC_4V | _PAGE_W_4V);
+			break;
+		default:
+			val = (_PAGE_VALID | _PAGE_SZ4MB_4V |
+			       _PAGE_CP_4V | _PAGE_CV_4V | _PAGE_P_4V |
+			       _PAGE_EXEC_4V | _PAGE_W_4V);
+			break;
+		}
 
 	return val | paddr;
 }
-- 
1.9.1

