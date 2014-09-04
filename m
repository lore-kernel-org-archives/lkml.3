Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbaIDMmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 08:42:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbaIDMjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 08:39:10 -0400
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, jbeulich@suse.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 2/3] xen: eliminate scalability issues from initrd handling
Date: Thu,  4 Sep 2014 14:38:45 +0200
Message-Id: <1409834326-29287-3-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409834326-29287-1-git-send-email-jgross@suse.com>
References: <1409834326-29287-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Size restrictions native kernels wouldn't have resulted from the initrd
getting mapped into the initial mapping. The kernel doesn't really need
the initrd to be mapped, so use infrastructure available in Xen to avoid
the mapping and hence the restriction.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/enlighten.c | 15 +++++++++++++--
 arch/x86/xen/xen-head.S  |  3 +++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c0cb11f..c8e4e6a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1519,6 +1519,7 @@ static void __init xen_pvh_early_guest_init(void)
 asmlinkage __visible void __init xen_start_kernel(void)
 {
 	struct physdev_set_iopl set_iopl;
+	unsigned long initrd_start = 0;
 	int rc;
 
 	if (!xen_start_info)
@@ -1667,10 +1668,20 @@ asmlinkage __visible void __init xen_start_kernel(void)
 	new_cpu_data.x86_capability[0] = cpuid_edx(1);
 #endif
 
+	if (xen_start_info->mod_start)
+		initrd_start = __pa(xen_start_info->mod_start);
+#ifdef CONFIG_BLK_DEV_INITRD
+#ifdef CONFIG_X86_32
+	BUG_ON(xen_start_info->flags & SIF_MOD_START_PFN);
+#else
+	if (xen_start_info->flags & SIF_MOD_START_PFN)
+		initrd_start = PFN_PHYS(xen_start_info->mod_start);
+#endif
+#endif
+
 	/* Poke various useful things into boot_params */
 	boot_params.hdr.type_of_loader = (9 << 4) | 0;
-	boot_params.hdr.ramdisk_image = xen_start_info->mod_start
-		? __pa(xen_start_info->mod_start) : 0;
+	boot_params.hdr.ramdisk_image = initrd_start;
 	boot_params.hdr.ramdisk_size = xen_start_info->mod_len;
 	boot_params.hdr.cmd_line_ptr = __pa(xen_start_info->cmd_line);
 
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 485b695..a458fd7 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -124,6 +124,9 @@ NEXT_HYPERCALL(arch_6)
 	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
 		.quad _PAGE_PRESENT; .quad _PAGE_PRESENT)
 	ELFNOTE(Xen, XEN_ELFNOTE_SUSPEND_CANCEL, .long 1)
+#ifdef CONFIG_X86_64
+	ELFNOTE(Xen, XEN_ELFNOTE_MOD_START_PFN,  .long 1)
+#endif
 	ELFNOTE(Xen, XEN_ELFNOTE_HV_START_LOW,   _ASM_PTR __HYPERVISOR_VIRT_START)
 	ELFNOTE(Xen, XEN_ELFNOTE_PADDR_OFFSET,   _ASM_PTR 0)
 
-- 
1.8.4.5

