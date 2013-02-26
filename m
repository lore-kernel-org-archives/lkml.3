Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab3BZMKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 07:10:52 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:35367 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab3BZMKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 07:10:50 -0500
Date: Tue, 26 Feb 2013 13:10:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20130226121045.GA15026@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: a8aed3e0752b4beb2e37cbed6df69faae88268da x86/mm/pageattr: Prevent PSE and GLOABL leftovers to confuse pmd/pte_present and pmd_huge

 Thanks,

	Ingo

------------------>
Andrea Arcangeli (2):
      Revert "x86, mm: Make spurious_fault check explicitly check explicitly check the PRESENT bit"
      x86/mm/pageattr: Prevent PSE and GLOABL leftovers to confuse pmd/pte_present and pmd_huge

Mathias Krause (1):
      x86/apic: Fix parsing of the 'lapic' cmdline option

Matt Fleming (1):
      x86, efi: Make "noefi" really disable EFI runtime serivces

Wen Congyang (1):
      x86/mm/numa: Don't check if node is NUMA_NO_NODE


 arch/x86/kernel/apic/apic.c |  2 +-
 arch/x86/mm/fault.c         |  8 +-------
 arch/x86/mm/numa.c          |  3 +--
 arch/x86/mm/pageattr.c      | 50 ++++++++++++++++++++++++++++++++++++++++++---
 arch/x86/platform/efi/efi.c |  5 +++--
 5 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a5b4dce..904611b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -131,7 +131,7 @@ static int __init parse_lapic(char *arg)
 {
 	if (config_enabled(CONFIG_X86_32) && !arg)
 		force_enable_local_apic = 1;
-	else if (!strncmp(arg, "notscdeadline", 13))
+	else if (arg && !strncmp(arg, "notscdeadline", 13))
 		setup_clear_cpu_cap(X86_FEATURE_TSC_DEADLINE_TIMER);
 	return 0;
 }
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index fb674fd..2b97525 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -939,14 +939,8 @@ spurious_fault(unsigned long error_code, unsigned long address)
 	if (pmd_large(*pmd))
 		return spurious_fault_check(error_code, (pte_t *) pmd);
 
-	/*
-	 * Note: don't use pte_present() here, since it returns true
-	 * if the _PAGE_PROTNONE bit is set.  However, this aliases the
-	 * _PAGE_GLOBAL bit, which for kernel pages give false positives
-	 * when CONFIG_DEBUG_PAGEALLOC is used.
-	 */
 	pte = pte_offset_kernel(pmd, address);
-	if (!(pte_flags(*pte) & _PAGE_PRESENT))
+	if (!pte_present(*pte))
 		return 0;
 
 	ret = spurious_fault_check(error_code, pte);
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 2d125be..21d02f0 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -97,8 +97,7 @@ void __cpuinit numa_set_node(int cpu, int node)
 #endif
 	per_cpu(x86_cpu_to_node_map, cpu) = node;
 
-	if (node != NUMA_NO_NODE)
-		set_cpu_numa_node(cpu, node);
+	set_cpu_numa_node(cpu, node);
 }
 
 void __cpuinit numa_clear_node(int cpu)
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index a718e0d..2713be4 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -445,6 +445,19 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	pgprot_val(req_prot) |= pgprot_val(cpa->mask_set);
 
 	/*
+	 * Set the PSE and GLOBAL flags only if the PRESENT flag is
+	 * set otherwise pmd_present/pmd_huge will return true even on
+	 * a non present pmd. The canon_pgprot will clear _PAGE_GLOBAL
+	 * for the ancient hardware that doesn't support it.
+	 */
+	if (pgprot_val(new_prot) & _PAGE_PRESENT)
+		pgprot_val(new_prot) |= _PAGE_PSE | _PAGE_GLOBAL;
+	else
+		pgprot_val(new_prot) &= ~(_PAGE_PSE | _PAGE_GLOBAL);
+
+	new_prot = canon_pgprot(new_prot);
+
+	/*
 	 * old_pte points to the large page base address. So we need
 	 * to add the offset of the virtual address:
 	 */
@@ -489,7 +502,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 		 * The address is aligned and the number of pages
 		 * covers the full page.
 		 */
-		new_pte = pfn_pte(pte_pfn(old_pte), canon_pgprot(new_prot));
+		new_pte = pfn_pte(pte_pfn(old_pte), new_prot);
 		__set_pmd_pte(kpte, address, new_pte);
 		cpa->flags |= CPA_FLUSHTLB;
 		do_split = 0;
@@ -540,16 +553,35 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 #ifdef CONFIG_X86_64
 	if (level == PG_LEVEL_1G) {
 		pfninc = PMD_PAGE_SIZE >> PAGE_SHIFT;
-		pgprot_val(ref_prot) |= _PAGE_PSE;
+		/*
+		 * Set the PSE flags only if the PRESENT flag is set
+		 * otherwise pmd_present/pmd_huge will return true
+		 * even on a non present pmd.
+		 */
+		if (pgprot_val(ref_prot) & _PAGE_PRESENT)
+			pgprot_val(ref_prot) |= _PAGE_PSE;
+		else
+			pgprot_val(ref_prot) &= ~_PAGE_PSE;
 	}
 #endif
 
 	/*
+	 * Set the GLOBAL flags only if the PRESENT flag is set
+	 * otherwise pmd/pte_present will return true even on a non
+	 * present pmd/pte. The canon_pgprot will clear _PAGE_GLOBAL
+	 * for the ancient hardware that doesn't support it.
+	 */
+	if (pgprot_val(ref_prot) & _PAGE_PRESENT)
+		pgprot_val(ref_prot) |= _PAGE_GLOBAL;
+	else
+		pgprot_val(ref_prot) &= ~_PAGE_GLOBAL;
+
+	/*
 	 * Get the target pfn from the original entry:
 	 */
 	pfn = pte_pfn(*kpte);
 	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
-		set_pte(&pbase[i], pfn_pte(pfn, ref_prot));
+		set_pte(&pbase[i], pfn_pte(pfn, canon_pgprot(ref_prot)));
 
 	if (address >= (unsigned long)__va(0) &&
 		address < (unsigned long)__va(max_low_pfn_mapped << PAGE_SHIFT))
@@ -660,6 +692,18 @@ repeat:
 		new_prot = static_protections(new_prot, address, pfn);
 
 		/*
+		 * Set the GLOBAL flags only if the PRESENT flag is
+		 * set otherwise pte_present will return true even on
+		 * a non present pte. The canon_pgprot will clear
+		 * _PAGE_GLOBAL for the ancient hardware that doesn't
+		 * support it.
+		 */
+		if (pgprot_val(new_prot) & _PAGE_PRESENT)
+			pgprot_val(new_prot) |= _PAGE_GLOBAL;
+		else
+			pgprot_val(new_prot) &= ~_PAGE_GLOBAL;
+
+		/*
 		 * We need to keep the pfn from the existing PTE,
 		 * after all we're only going to change it's attributes
 		 * not the memory it points to
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 928bf83..e2cd38f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -85,9 +85,10 @@ int efi_enabled(int facility)
 }
 EXPORT_SYMBOL(efi_enabled);
 
+static bool disable_runtime = false;
 static int __init setup_noefi(char *arg)
 {
-	clear_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
+	disable_runtime = true;
 	return 0;
 }
 early_param("noefi", setup_noefi);
@@ -734,7 +735,7 @@ void __init efi_init(void)
 	if (!efi_is_native())
 		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
 	else {
-		if (efi_runtime_init())
+		if (disable_runtime || efi_runtime_init())
 			return;
 		set_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
 	}
