Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3LQVkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 16:40:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49356 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3LQVke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 16:40:34 -0500
Date: Tue, 17 Dec 2013 16:39:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, george.dunlap@eu.citrix.com,
        ian.jackson@eu.citrix.com, mukesh.rathor@oracle.com, tim@xen.org,
        jbeulich@suse.com, david.vrabel@citrix.com
Subject: Re: [PATCH V10 04/14] xen/pvh: bootup and setup (E820) related
 changes.
Message-ID: <20131217213918.GB32553@phenom.dumpdata.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
 <1386900621-27528-5-git-send-email-konrad.wilk@oracle.com>
 <52AB4A0E.5010606@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AB4A0E.5010606@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 12:55:26PM -0500, Boris Ostrovsky wrote:
> On 12/12/2013 09:10 PM, Konrad Rzeszutek Wilk wrote:
> >From: Mukesh Rathor <mukesh.rathor@oracle.com>
> >
> >In the bootup code for PVH we can trap cpuid via vmexit, so don't
> >need to use emulated prefix call. We also check for vector callback
> >early on, as it is a required feature. PVH also runs at default kernel
> >IOPL.
> >
> >In setup.c which deals with E820, in xen_add_extra_mem() we can skip
> >updating P2M as it's managed by Xen. PVH maps the entire IO space,
> >but only RAM pages need to be repopulated.
> >
> >Finally, pure PV settings are moved to a separate function that are
> >only called for pure PV, ie, pv with pvmmu.
> >
> >Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> >Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >[ ijc -- rebase onto xen PVonHVM: use E820_Reserved area for
> >          shared_info ]
> >[v2: Rebase on v3.9-rc1 with MMIO/Kexec reverted]
> >
> >Conflicts:
> >	arch/x86/xen/setup.c
> >[due to "xen: Support 64-bit PV guest receiving NMIs"]
> >---
> >  arch/x86/xen/enlighten.c |   77 ++++++++++++++++++++++++++++++++++-----------
> >  arch/x86/xen/setup.c     |   63 ++++++++++++++++++++++++++++++-------
> >  2 files changed, 109 insertions(+), 31 deletions(-)
> >
> >diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> >index fa6ade7..500508d 100644
> >--- a/arch/x86/xen/enlighten.c
> >+++ b/arch/x86/xen/enlighten.c
> >@@ -46,6 +46,7 @@
> >  #include <xen/hvm.h>
> >  #include <xen/hvc-console.h>
> >  #include <xen/acpi.h>
> >+#include <xen/features.h>
> >  #include <asm/paravirt.h>
> >  #include <asm/apic.h>
> >@@ -129,6 +130,9 @@ RESERVE_BRK(shared_info_page_brk, PAGE_SIZE);
> >  __read_mostly int xen_have_vector_callback;
> >  EXPORT_SYMBOL_GPL(xen_have_vector_callback);
> >+#define xen_pvh_domain() (xen_pv_domain() && \
> >+			  xen_feature(XENFEAT_auto_translated_physmap) && \
> >+			  xen_have_vector_callback)
> 
> Can this be used in earlier patches instead of checking for
> XENFEAT_auto_translated_physmap, when it's clear that we actually
> mean PVH?

As I posted the patches I realized we could actually just remove this
check and piggyback on xen_feature(XENFEAT_auto_translated_physmap).

But then I wasn't sure as I think you can do pure PV with auto-translate
on (so it uses shadow paging). But I think that code is bitrotten.

> 
> >  /*
> >   * Point at some empty memory to start with. We map the real shared_info
> >   * page as soon as fixmap is up and running.
> >@@ -262,8 +266,9 @@ static void __init xen_banner(void)
> >  	struct xen_extraversion extra;
> >  	HYPERVISOR_xen_version(XENVER_extraversion, &extra);
> >-	printk(KERN_INFO "Booting paravirtualized kernel on %s\n",
> >-	       pv_info.name);
> >+	pr_info("Booting paravirtualized kernel %son %s\n",
> >+		xen_feature(XENFEAT_auto_translated_physmap) ?
> 
> ... and here as well (and possibly elsewhere).
> 
> >+			"with PVH extensions " : "", pv_info.name);
> >  	printk(KERN_INFO "Xen version: %d.%d%s%s\n",
> >  	       version >> 16, version & 0xffff, extra.extraversion,
> >  	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "");
> >@@ -331,12 +336,15 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
> >  		break;
> >  	}
> >-	asm(XEN_EMULATE_PREFIX "cpuid"
> >-		: "=a" (*ax),
> >-		  "=b" (*bx),
> >-		  "=c" (*cx),
> >-		  "=d" (*dx)
> >-		: "0" (*ax), "2" (*cx));
> >+	if (xen_pvh_domain())
> >+		native_cpuid(ax, bx, cx, dx);
> >+	else
> >+		asm(XEN_EMULATE_PREFIX "cpuid"
> >+			: "=a" (*ax),
> >+			"=b" (*bx),
> >+			"=c" (*cx),
> >+			"=d" (*dx)
> >+			: "0" (*ax), "2" (*cx));
> >  	*bx &= maskebx;
> >  	*cx &= maskecx;
> >@@ -1125,6 +1133,10 @@ void xen_setup_shared_info(void)
> >  		HYPERVISOR_shared_info =
> >  			(struct shared_info *)__va(xen_start_info->shared_info);
> >+	/* PVH TBD/FIXME: vcpu info placement in phase 2 */
> >+	if (xen_pvh_domain())
> >+		return;
> >+
> >  #ifndef CONFIG_SMP
> >  	/* In UP this is as good a place as any to set up shared info */
> >  	xen_setup_vcpu_info_placement();
> >@@ -1410,6 +1422,11 @@ static void __init xen_boot_params_init_edd(void)
> >   */
> >  static void __init xen_setup_stackprotector(void)
> >  {
> >+	/* PVH TBD/FIXME: investigate setup_stack_canary_segment */
> 
> setup_stack_canary_segment() is for 32-bit only and since PVH (which
> I assume is what this 'if' is about) is a 64-bit only binary this
> call is a nop.

<nods>
> 
> >+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> >+		switch_to_new_gdt(0);
> >+		return;
> >+	}
> >  	pv_cpu_ops.write_gdt_entry = xen_write_gdt_entry_boot;
> >  	pv_cpu_ops.load_gdt = xen_load_gdt_boot;
> >@@ -1420,6 +1437,19 @@ static void __init xen_setup_stackprotector(void)
> >  	pv_cpu_ops.load_gdt = xen_load_gdt;
> >  }
> >+static void __init xen_pvh_early_guest_init(void)
> >+{
> >+	if (xen_feature(XENFEAT_hvm_callback_vector))
> >+		xen_have_vector_callback = 1;
> >+
> >+#ifdef CONFIG_X86_32
> >+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> >+		xen_raw_printk("ERROR: 32bit PVH guests are not supported\n");
> >+		BUG();
> >+	}
> >+#endif
> >+}
> >+
> >  /* First C function to be called on Xen boot */
> >  asmlinkage void __init xen_start_kernel(void)
> >  {
> >@@ -1431,13 +1461,18 @@ asmlinkage void __init xen_start_kernel(void)
> >  	xen_domain_type = XEN_PV_DOMAIN;
> >+	xen_setup_features();
> >+	xen_pvh_early_guest_init();
> >  	xen_setup_machphys_mapping();
> >  	/* Install Xen paravirt ops */
> >  	pv_info = xen_info;
> >  	pv_init_ops = xen_init_ops;
> >-	pv_cpu_ops = xen_cpu_ops;
> >  	pv_apic_ops = xen_apic_ops;
> >+	if (xen_pvh_domain())
> >+		pv_cpu_ops.cpuid = xen_cpuid;
> >+	else
> >+		pv_cpu_ops = xen_cpu_ops;
> >  	x86_init.resources.memory_setup = xen_memory_setup;
> >  	x86_init.oem.arch_setup = xen_arch_setup;
> >@@ -1469,8 +1504,6 @@ asmlinkage void __init xen_start_kernel(void)
> >  	/* Work out if we support NX */
> >  	x86_configure_nx();
> >-	xen_setup_features();
> >-
> >  	/* Get mfn list */
> >  	if (!xen_feature(XENFEAT_auto_translated_physmap))
> >  		xen_build_dynamic_phys_to_machine();
> >@@ -1548,14 +1581,18 @@ asmlinkage void __init xen_start_kernel(void)
> >  	/* set the limit of our address space */
> >  	xen_reserve_top();
> >-	/* We used to do this in xen_arch_setup, but that is too late on AMD
> >-	 * were early_cpu_init (run before ->arch_setup()) calls early_amd_init
> >-	 * which pokes 0xcf8 port.
> >-	 */
> >-	set_iopl.iopl = 1;
> >-	rc = HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl);
> >-	if (rc != 0)
> >-		xen_raw_printk("physdev_op failed %d\n", rc);
> >+	/* PVH: runs at default kernel iopl of 0 */
> >+	if (!xen_pvh_domain()) {
> >+		/*
> >+		 * We used to do this in xen_arch_setup, but that is too late
> >+		 * on AMD were early_cpu_init (run before ->arch_setup()) calls
> >+		 * early_amd_init which pokes 0xcf8 port.
> >+		 */
> >+		set_iopl.iopl = 1;
> >+		rc = HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl);
> >+		if (rc != 0)
> >+			xen_raw_printk("physdev_op failed %d\n", rc);
> >+	}
> >  #ifdef CONFIG_X86_32
> >  	/* set up basic CPUID stuff */
> >@@ -1625,6 +1662,8 @@ asmlinkage void __init xen_start_kernel(void)
> >  }
> >  void __ref xen_hvm_init_shared_info(void)
> >+/* Use a pfn in RAM, may move to MMIO before kexec.
> >+ * This function also called for PVH dom0 */
> >  {
> >  	int cpu;
> >  	struct xen_add_to_physmap xatp;
> >diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> >index 68c054f..e3dcd8c 100644
> >--- a/arch/x86/xen/setup.c
> >+++ b/arch/x86/xen/setup.c
> >@@ -27,6 +27,7 @@
> >  #include <xen/interface/memory.h>
> >  #include <xen/interface/physdev.h>
> >  #include <xen/features.h>
> >+#include "mmu.h"
> >  #include "xen-ops.h"
> >  #include "vdso.h"
> >@@ -81,6 +82,9 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
> >  	memblock_reserve(start, size);
> >+	if (xen_feature(XENFEAT_auto_translated_physmap))
> >+		return;
> >+
> >  	xen_max_p2m_pfn = PFN_DOWN(start + size);
> >  	for (pfn = PFN_DOWN(start); pfn < xen_max_p2m_pfn; pfn++) {
> >  		unsigned long mfn = pfn_to_mfn(pfn);
> >@@ -103,6 +107,7 @@ static unsigned long __init xen_do_chunk(unsigned long start,
> >  		.domid        = DOMID_SELF
> >  	};
> >  	unsigned long len = 0;
> >+	int xlated_phys = xen_feature(XENFEAT_auto_translated_physmap);
> 
> This is inconsistent with other uses of
> xen_feature(XENFEAT_auto_translated_physmap), so far xen_feature()
> has always been used.

.. I think sprinkling those 'xen_pvh_domain' in arch/x86 is OK, but not
in the drivers/xen (as those are also used by ARM).

But perhaps we should just use 'if (xen_feature(XENFEAT..)'. Hmm.
> 
> >  	unsigned long pfn;
> >  	int ret;
> >@@ -116,7 +121,7 @@ static unsigned long __init xen_do_chunk(unsigned long start,
> >  				continue;
> >  			frame = mfn;
> >  		} else {
> >-			if (mfn != INVALID_P2M_ENTRY)
> >+			if (!xlated_phys && mfn != INVALID_P2M_ENTRY)
> >  				continue;
> >  			frame = pfn;
> >  		}
> >@@ -239,6 +244,27 @@ static void __init xen_set_identity_and_release_chunk(
> >  	*identity += set_phys_range_identity(start_pfn, end_pfn);
> >  }
> >+/* For PVH, the pfns [0..MAX] are mapped to mfn's in the EPT/NPT. The mfns
> >+ * are released as part of this 1:1 mapping hypercall back to the dom heap.
> >+ * Also, we map the entire IO space, ie, beyond max_pfn_mapped.
> >+ */
> >+static void __init xen_pvh_identity_map_chunk(unsigned long start_pfn,
> >+		unsigned long end_pfn, unsigned long *released,
> >+		unsigned long *identity, unsigned long max_pfn)
> >+{
> >+	unsigned long pfn;
> >+	int numpfns = 1, add_mapping = 1;
> 
> No need for these two variables;

Code gone.
> 
> >+
> >+	for (pfn = start_pfn; pfn < end_pfn; pfn++)
> >+		xen_set_clr_mmio_pvh_pte(pfn, pfn, numpfns, add_mapping);
> >+
> >+	if (start_pfn <= max_pfn) {
> >+		unsigned long end = min(max_pfn_mapped, end_pfn);
> >+		*released += end - start_pfn;
> >+	}
> >+	*identity += end_pfn - start_pfn;
> >+}
> >+
> >  static unsigned long __init xen_set_identity_and_release(
> >  	const struct e820entry *list, size_t map_size, unsigned long nr_pages)
> >  {
> >@@ -247,6 +273,7 @@ static unsigned long __init xen_set_identity_and_release(
> >  	unsigned long identity = 0;
> >  	const struct e820entry *entry;
> >  	int i;
> >+	int xlated_phys = xen_feature(XENFEAT_auto_translated_physmap);
> 
> Again xlated_phys.

Ripped out.
> 
> 
> -boris
> 
> >  	/*
> >  	 * Combine non-RAM regions and gaps until a RAM region (or the
> >@@ -268,11 +295,17 @@ static unsigned long __init xen_set_identity_and_release(
> >  			if (entry->type == E820_RAM)
> >  				end_pfn = PFN_UP(entry->addr);
> >-			if (start_pfn < end_pfn)
> >-				xen_set_identity_and_release_chunk(
> >-					start_pfn, end_pfn, nr_pages,
> >-					&released, &identity);
> >-
> >+			if (start_pfn < end_pfn) {
> >+				if (xlated_phys) {
> >+					xen_pvh_identity_map_chunk(start_pfn,
> >+						end_pfn, &released, &identity,
> >+						nr_pages);
> >+				} else {
> >+					xen_set_identity_and_release_chunk(
> >+						start_pfn, end_pfn, nr_pages,
> >+						&released, &identity);
> >+				}
> >+			}
> >  			start = end;
> >  		}
> >  	}
> >@@ -563,16 +596,13 @@ void xen_enable_nmi(void)
> >  		BUG();
> >  #endif
> >  }
> >-void __init xen_arch_setup(void)
> >+void __init xen_pvmmu_arch_setup(void)
> >  {
> >-	xen_panic_handler_init();
> >-
> >  	HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_4gb_segments);
> >  	HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_writable_pagetables);
> >-	if (!xen_feature(XENFEAT_auto_translated_physmap))
> >-		HYPERVISOR_vm_assist(VMASST_CMD_enable,
> >-				     VMASST_TYPE_pae_extended_cr3);
> >+	HYPERVISOR_vm_assist(VMASST_CMD_enable,
> >+			     VMASST_TYPE_pae_extended_cr3);
> >  	if (register_callback(CALLBACKTYPE_event, xen_hypervisor_callback) ||
> >  	    register_callback(CALLBACKTYPE_failsafe, xen_failsafe_callback))
> >@@ -581,6 +611,15 @@ void __init xen_arch_setup(void)
> >  	xen_enable_sysenter();
> >  	xen_enable_syscall();
> >  	xen_enable_nmi();
> >+}
> >+
> >+/* This function not called for HVM domain */
> >+void __init xen_arch_setup(void)
> >+{
> >+	xen_panic_handler_init();
> >+
> >+	if (!xen_feature(XENFEAT_auto_translated_physmap))
> >+		xen_pvmmu_arch_setup();
> >  #ifdef CONFIG_ACPI
> >  	if (!(xen_start_info->flags & SIF_INITDOMAIN)) {
> >  		printk(KERN_INFO "ACPI in unprivileged domain disabled\n");
> 
