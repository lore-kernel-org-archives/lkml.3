Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbaLBUTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:19:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24551 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199AbaLBUTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:19:09 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: david.vrabel@citrix.com, konrad.wilk@oracle.com,
        stefano.stabellini@eu.citrix.com
Cc: jun.nakajima@intel.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, boris.ostrovsky@oracle.com
Subject: [PATCH v4 1/2] xen/pci: Defer initialization of MSI ops on HVM guests until after x2APIC has been set up
Date: Tue,  2 Dec 2014 15:19:12 -0500
Message-Id: <1417551553-22234-2-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417551553-22234-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1417551553-22234-1-git-send-email-boris.ostrovsky@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the hardware supports APIC virtualization we may decide not to use pirqs
and instead use APIC/x2APIC directly, meaning that we don't want to set
x86_msi.setup_msi_irqs and x86_msi.teardown_msi_irq to Xen-specific routines.
However, x2APIC is not set up by the time pci_xen_hvm_init() is called so we
need to postpone setting these ops until later, when we know which APIC mode
is used.

(Note that currently x2APIC is never initialized on HVM guests. This may
change in the future)

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/pci/xen.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 093f5f4..1370716 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -431,6 +431,14 @@ int __init pci_xen_init(void)
 	return 0;
 }
 
+#ifdef CONFIG_PCI_MSI
+void __init xen_msi_init(void)
+{
+	x86_msi.setup_msi_irqs = xen_hvm_setup_msi_irqs;
+	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
+}
+#endif
+
 int __init pci_xen_hvm_init(void)
 {
 	if (!xen_have_vector_callback || !xen_feature(XENFEAT_hvm_pirqs))
@@ -445,8 +453,11 @@ int __init pci_xen_hvm_init(void)
 #endif
 
 #ifdef CONFIG_PCI_MSI
-	x86_msi.setup_msi_irqs = xen_hvm_setup_msi_irqs;
-	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
+	/*
+	 * We need to wait until after x2apic is initialized
+	 * before we can set MSI IRQ ops.
+	 */
+	x86_platform.apic_post_init = xen_msi_init;
 #endif
 	return 0;
 }
-- 
1.8.1.4

