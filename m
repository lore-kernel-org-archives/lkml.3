Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbaAAEih (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 23:38:37 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19648 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaAAEhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 23:37:05 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v12 18/18] xen/pvh: Support ParaVirtualized Hardware extensions (v2).
Date: Tue, 31 Dec 2013 23:35:45 -0500
Message-Id: <1388550945-25499-19-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

PVH allows PV linux guest to utilize hardware extended capabilities,
such as running MMU updates in a HVM container.

The Xen side defines PVH as (from docs/misc/pvh-readme.txt,
with modifications):

"* the guest uses auto translate:
 - p2m is managed by Xen
 - pagetables are owned by the guest
 - mmu_update hypercall not available
* it uses event callback and not vlapic emulation,
* IDT is native, so set_trap_table hcall is also N/A for a PVH guest.

For a full list of hcalls supported for PVH, see pvh_hypercall64_table
in arch/x86/hvm/hvm.c in xen.  From the ABI prespective, it's mostly a
PV guest with auto translate, although it does use hvm_op for setting
callback vector."

Use .ascii and .asciz to define xen feature string. Note, the PVH
string must be in a single line (not multiple lines with \) to keep the
assembler from putting null char after each string before \.
This patch allows it to be configured and enabled.

Lastly remove some of the scaffolding.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/Kconfig       | 8 ++++++++
 arch/x86/xen/grant-table.c | 2 +-
 arch/x86/xen/xen-head.S    | 8 +++++++-
 include/xen/xen.h          | 4 +---
 4 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 1a3c765..161cc34 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -51,3 +51,11 @@ config XEN_DEBUG_FS
 	  Enable statistics output and various tuning options in debugfs.
 	  Enabling this option may incur a significant performance overhead.
 
+config XEN_PVH
+	bool "Support for running as a PVH guest"
+	depends on X86_64 && XEN && XEN_PVHVM
+	default n
+	help
+	   This option enables support for running as a PVH guest (PV guest
+	   using hardware extensions) under a suitably capable hypervisor.
+	   If unsure, say N.
diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
index 040e064..42635e9 100644
--- a/arch/x86/xen/grant-table.c
+++ b/arch/x86/xen/grant-table.c
@@ -125,7 +125,7 @@ void arch_gnttab_unmap(void *shared, unsigned long nr_gframes)
 	apply_to_page_range(&init_mm, (unsigned long)shared,
 			    PAGE_SIZE * nr_gframes, unmap_pte_fn, NULL);
 }
-#ifdef CONFIG_XEN_PVHVM
+#ifdef CONFIG_XEN_PVH
 #include <xen/balloon.h>
 #include <linux/slab.h>
 static int __init xlated_setup_gnttab_pages(void)
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 7faed58..56f42c0 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -13,6 +13,12 @@
 #include <xen/interface/elfnote.h>
 #include <asm/xen/interface.h>
 
+#ifdef CONFIG_XEN_PVH
+#define PVH_FEATURES_STR  "|writable_descriptor_tables|auto_translated_physmap|supervisor_mode_kernel|hvm_callback_vector"
+#else
+#define PVH_FEATURES_STR  ""
+#endif
+
 	__INIT
 ENTRY(startup_xen)
 	cld
@@ -95,7 +101,7 @@ NEXT_HYPERCALL(arch_6)
 #endif
 	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          _ASM_PTR startup_xen)
 	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, _ASM_PTR hypercall_page)
-	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
+	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .ascii "!writable_page_tables|pae_pgdir_above_4gb"; .asciz PVH_FEATURES_STR)
 	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
 	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
 	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
diff --git a/include/xen/xen.h b/include/xen/xen.h
index c4ab644..0c0e3ef 100644
--- a/include/xen/xen.h
+++ b/include/xen/xen.h
@@ -29,9 +29,7 @@ extern enum xen_domain_type xen_domain_type;
 #define xen_initial_domain()	(0)
 #endif	/* CONFIG_XEN_DOM0 */
 
-#ifdef CONFIG_XEN_PVHVM
-/* Temporarily under XEN_PVHVM, but will be under CONFIG_XEN_PVH */
-
+#ifdef CONFIG_XEN_PVH
 /* This functionality exists only for x86. The XEN_PVHVM support exists
  * only in x86 world - hence on ARM it will be always disabled.
  * N.B. ARM guests are neither PV nor HVM nor PVHVM.
-- 
1.8.3.1

