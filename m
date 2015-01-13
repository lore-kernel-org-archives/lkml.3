Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbbAMHkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 02:40:09 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:57036 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbbAMHkI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 13 Jan 2015 02:40:08 -0500
Message-Id: <54B4D9E502000078000541CE@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 13 Jan 2015 07:40:05 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] xen/x86: properly retrieve NMI reason
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the native code here can't work properly, as the hypervisor would
normally have cleared the two reason bits by the time Dom0 gets to see
the NMI (if passed to it at all). There's a shared info field for this,
and there's an existing hook to use - just fit the two together. This
is particularly relevant so that NMIs intended to be handled by APEI /
GHES actually make it to the respective handler.

Note that the hook can (and should) be used irrespective of whether
being in Dom0, as accessing port 0x61 in a DomU would be even worse,
while the shared info field would just hold zero all the time. Note
further that hardware NMI handling for PVH doesn't currently work
anyway due to missing code in the hypervisor (but it is expected to
work the native rather than the PV way).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
v2: Use DEFINE_GUEST_HANDLE_STRUCT() instead of the canonical header's
    DEFINE_XEN_GUEST_HANDLE() and drop unwanted typedef. Extend commit
    message.
---
 arch/x86/xen/enlighten.c    |   22 ++++++++++++++++++
 include/xen/interface/nmi.h |   51 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 1 deletion(-)

--- 3.19-rc4/arch/x86/xen/enlighten.c
+++ 3.19-rc4-xen-x86-NMI-reason/arch/x86/xen/enlighten.c
@@ -40,6 +40,7 @@
 #include <xen/interface/physdev.h>
 #include <xen/interface/vcpu.h>
 #include <xen/interface/memory.h>
+#include <xen/interface/nmi.h>
 #include <xen/interface/xen-mca.h>
 #include <xen/features.h>
 #include <xen/page.h>
@@ -66,6 +67,7 @@
 #include <asm/reboot.h>
 #include <asm/stackprotector.h>
 #include <asm/hypervisor.h>
+#include <asm/mach_traps.h>
 #include <asm/mwait.h>
 #include <asm/pci_x86.h>
 #include <asm/pat.h>
@@ -1351,6 +1353,21 @@ static const struct machine_ops xen_mach
 	.emergency_restart = xen_emergency_restart,
 };
 
+static unsigned char xen_get_nmi_reason(void)
+{
+	unsigned char reason = 0;
+
+	/* Construct a value which looks like it came from port 0x61. */
+	if (test_bit(_XEN_NMIREASON_io_error,
+		     &HYPERVISOR_shared_info->arch.nmi_reason))
+		reason |= NMI_REASON_IOCHK;
+	if (test_bit(_XEN_NMIREASON_pci_serr,
+		     &HYPERVISOR_shared_info->arch.nmi_reason))
+		reason |= NMI_REASON_SERR;
+
+	return reason;
+}
+
 static void __init xen_boot_params_init_edd(void)
 {
 #if IS_ENABLED(CONFIG_EDD)
@@ -1535,9 +1552,12 @@ asmlinkage __visible void __init xen_sta
 	pv_info = xen_info;
 	pv_init_ops = xen_init_ops;
 	pv_apic_ops = xen_apic_ops;
-	if (!xen_pvh_domain())
+	if (!xen_pvh_domain()) {
 		pv_cpu_ops = xen_cpu_ops;
 
+		x86_platform.get_nmi_reason = xen_get_nmi_reason;
+	}
+
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		x86_init.resources.memory_setup = xen_auto_xlated_memory_setup;
 	else
--- 3.19-rc4/include/xen/interface/nmi.h
+++ 3.19-rc4-xen-x86-NMI-reason/include/xen/interface/nmi.h
@@ -0,0 +1,51 @@
+/******************************************************************************
+ * nmi.h
+ * 
+ * NMI callback registration and reason codes.
+ * 
+ * Copyright (c) 2005, Keir Fraser <keir@xensource.com>
+ */
+
+#ifndef __XEN_PUBLIC_NMI_H__
+#define __XEN_PUBLIC_NMI_H__
+
+#include <xen/interface/xen.h>
+
+/*
+ * NMI reason codes:
+ * Currently these are x86-specific, stored in arch_shared_info.nmi_reason.
+ */
+ /* I/O-check error reported via ISA port 0x61, bit 6. */
+#define _XEN_NMIREASON_io_error     0
+#define XEN_NMIREASON_io_error      (1UL << _XEN_NMIREASON_io_error)
+ /* PCI SERR reported via ISA port 0x61, bit 7. */
+#define _XEN_NMIREASON_pci_serr     1
+#define XEN_NMIREASON_pci_serr      (1UL << _XEN_NMIREASON_pci_serr)
+ /* Unknown hardware-generated NMI. */
+#define _XEN_NMIREASON_unknown      2
+#define XEN_NMIREASON_unknown       (1UL << _XEN_NMIREASON_unknown)
+
+/*
+ * long nmi_op(unsigned int cmd, void *arg)
+ * NB. All ops return zero on success, else a negative error code.
+ */
+
+/*
+ * Register NMI callback for this (calling) VCPU. Currently this only makes
+ * sense for domain 0, vcpu 0. All other callers will be returned EINVAL.
+ * arg == pointer to xennmi_callback structure.
+ */
+#define XENNMI_register_callback   0
+struct xennmi_callback {
+    unsigned long handler_address;
+    unsigned long pad;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xennmi_callback);
+
+/*
+ * Deregister NMI callback for this (calling) VCPU.
+ * arg == NULL.
+ */
+#define XENNMI_unregister_callback 1
+
+#endif /* __XEN_PUBLIC_NMI_H__ */


