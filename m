Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3LMCOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:14:03 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:47511 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3LMCKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:10:35 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        george.dunlap@eu.citrix.com, ian.jackson@eu.citrix.com,
        mukesh.rathor@oracle.com, tim@xen.org, jbeulich@suse.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH V10 01/14] xen/pvh: Support ParaVirtualized Hardware extensions.
Date: Thu, 12 Dec 2013 21:10:08 -0500
Message-Id: <1386900621-27528-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

PVH allows PV linux guest to utilize hardware extended capabilities, such
as running MMU updates in a HVM container.

This patch allows it to be configured and enabled. Also, basic header file
changes to add new subcalls to physmap hypercall.

Lastly, mfn_to_local_pfn must return mfn for paging mode translate
(since we let the hypervisor - or CPU - do them for us).

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/page.h |    3 +++
 arch/x86/xen/Kconfig            |   10 ++++++++++
 arch/x86/xen/xen-head.S         |   11 ++++++++++-
 include/xen/interface/memory.h  |    5 ++++-
 include/xen/interface/physdev.h |   10 ++++++++++
 5 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index b913915..65194f7 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -168,6 +168,9 @@ static inline xpaddr_t machine_to_phys(xmaddr_t machine)
 static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
 {
 	unsigned long pfn = mfn_to_pfn(mfn);
+
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return mfn;
 	if (get_phys_to_machine(pfn) != mfn)
 		return -1; /* force !pfn_valid() */
 	return pfn;
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 1a3c765..4d890c3 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -51,3 +51,13 @@ config XEN_DEBUG_FS
 	  Enable statistics output and various tuning options in debugfs.
 	  Enabling this option may incur a significant performance overhead.
 
+config XEN_X86_PVH
+	bool "Support for running as a PVH guest (EXPERIMENTAL)"
+	depends on X86_64 && XEN && EXPERIMENTAL
+	default n
+	help
+	   This option enables support for running as a PVH guest (PV guest
+	   using hardware extensions) under a suitably capable hypervisor.
+	   This option is EXPERIMENTAL because the hypervisor interfaces
+	   which it uses is not yet considered stable therefore backwards and
+	   forwards compatibility is not yet guaranteed.  If unsure, say N.
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 7faed58..1a6bca1 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -13,6 +13,15 @@
 #include <xen/interface/elfnote.h>
 #include <asm/xen/interface.h>
 
+#ifdef CONFIG_XEN_X86_PVH
+#define FEATURES_PVH "|writable_descriptor_tables" \
+		     "|auto_translated_physmap" \
+		     "|supervisor_mode_kernel" \
+		     "|hvm_callback_vector"
+#else
+#define FEATURES_PVH /* Not supported */
+#endif
+
 	__INIT
 ENTRY(startup_xen)
 	cld
@@ -95,7 +104,7 @@ NEXT_HYPERCALL(arch_6)
 #endif
 	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          _ASM_PTR startup_xen)
 	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, _ASM_PTR hypercall_page)
-	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
+	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb"FEATURES_PVH)
 	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
 	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
 	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index 2ecfe4f..a122164 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -175,7 +175,10 @@ struct xen_add_to_physmap {
     uint16_t    size;
 
     /* Source mapping space. */
-    unsigned int space;
+    uint16_t space;
+    domid_t foreign_domid;         /* IFF XENMAPSPACE_gmfn_foreign */
+
+#define XENMAPIDX_grant_table_status 0x80000000
 
     /* Index into source mapping space. */
     xen_ulong_t idx;
diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
index 42721d1..19d30ad 100644
--- a/include/xen/interface/physdev.h
+++ b/include/xen/interface/physdev.h
@@ -291,6 +291,16 @@ struct physdev_dbgp_op {
     } u;
 };
 
+#define PHYSDEVOP_map_iomem        30
+struct physdev_map_iomem {
+    /* IN */
+    uint64_t first_gfn;
+    uint64_t first_mfn;
+    uint32_t nr_mfns;
+    uint32_t add_mapping; /* 1 == add mapping;  0 == unmap */
+
+};
+
 /*
  * Notify that some PIRQ-bound event channels have been unmasked.
  * ** This command is obsolete since interface version 0x00030202 and is **
-- 
1.7.7.6

