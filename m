Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaACUbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:31:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22015 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaACUaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:30:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        david.vrabel@citrix.com
Cc: hpa@zytor.com, Mukesh Rathor <mukesh.rathor@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v13 19/19] xen/pvh: Support ParaVirtualized Hardware extensions (v3).
Date: Fri,  3 Jan 2014 14:38:36 -0500
Message-Id: <1388777916-1328-20-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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

We also use introduce the 'XEN_ELFNOTE_SUPPORTED_FEATURES' ELF note to
tell the hypervisor that 'hvm_callback_vector' is what the kernel
needs. We can not put it in 'XEN_ELFNOTE_FEATURES' as older hypervisor
parse fields they don't understand as errors and refuse to load
the kernel. This work-around fixes the problem.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/Kconfig            |  2 +-
 arch/x86/xen/xen-head.S         | 25 ++++++++++++++++++++++++-
 include/xen/interface/elfnote.h | 13 +++++++++++++
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index e7d0590..d88bfd6 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -53,6 +53,6 @@ config XEN_DEBUG_FS
 
 config XEN_PVH
 	bool "Support for running as a PVH guest"
-	depends on X86_64 && XEN && BROKEN
+	depends on X86_64 && XEN
 	select XEN_PVHVM
 	def_bool n
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 7faed58..485b695 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -11,8 +11,28 @@
 #include <asm/page_types.h>
 
 #include <xen/interface/elfnote.h>
+#include <xen/interface/features.h>
 #include <asm/xen/interface.h>
 
+#ifdef CONFIG_XEN_PVH
+#define PVH_FEATURES_STR  "|writable_descriptor_tables|auto_translated_physmap|supervisor_mode_kernel"
+/* Note the lack of 'hvm_callback_vector'. Older hypervisor will
+ * balk at this being part of XEN_ELFNOTE_FEATURES, so we put it in
+ * XEN_ELFNOTE_SUPPORTED_FEATURES which older hypervisors will ignore.
+ */
+#define PVH_FEATURES ((1 << XENFEAT_writable_page_tables) | \
+		      (1 << XENFEAT_auto_translated_physmap) | \
+		      (1 << XENFEAT_supervisor_mode_kernel) | \
+		      (1 << XENFEAT_hvm_callback_vector))
+/* The XENFEAT_writable_page_tables is not stricly neccessary as we set that
+ * up regardless whether this CONFIG option is enabled or not, but it
+ * clarifies what the right flags need to be.
+ */
+#else
+#define PVH_FEATURES_STR  ""
+#define PVH_FEATURES (0)
+#endif
+
 	__INIT
 ENTRY(startup_xen)
 	cld
@@ -95,7 +115,10 @@ NEXT_HYPERCALL(arch_6)
 #endif
 	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          _ASM_PTR startup_xen)
 	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, _ASM_PTR hypercall_page)
-	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
+	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .ascii "!writable_page_tables|pae_pgdir_above_4gb"; .asciz PVH_FEATURES_STR)
+	ELFNOTE(Xen, XEN_ELFNOTE_SUPPORTED_FEATURES, .long (PVH_FEATURES) |
+						(1 << XENFEAT_writable_page_tables) |
+						(1 << XENFEAT_dom0))
 	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
 	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
 	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
diff --git a/include/xen/interface/elfnote.h b/include/xen/interface/elfnote.h
index 0360b15..6f4eae3 100644
--- a/include/xen/interface/elfnote.h
+++ b/include/xen/interface/elfnote.h
@@ -140,6 +140,19 @@
  */
 #define XEN_ELFNOTE_SUSPEND_CANCEL 14
 
+/*
+ * The features supported by this kernel (numeric).
+ *
+ * Other than XEN_ELFNOTE_FEATURES on pre-4.2 Xen, this note allows a
+ * kernel to specify support for features that older hypervisors don't
+ * know about. The set of features 4.2 and newer hypervisors will
+ * consider supported by the kernel is the combination of the sets
+ * specified through this and the string note.
+ *
+ * LEGACY: FEATURES
+ */
+#define XEN_ELFNOTE_SUPPORTED_FEATURES 17
+
 #endif /* __XEN_PUBLIC_ELFNOTE_H__ */
 
 /*
-- 
1.8.3.1

