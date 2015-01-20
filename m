Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbbATCSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:18:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:50004 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbbATCSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:18:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,431,1418112000"; 
   d="scan'208";a="514609245"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Lv Zheng <lv.zheng@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: [Bugfix 3/3] xen/irq: Override ACPI IRQ management callback __acpi_unregister_gsi
Date: Tue, 20 Jan 2015 10:21:07 +0800
Message-Id: <1421720467-7709-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421720467-7709-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421720467-7709-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen overrides __acpi_register_gsi and leaves __acpi_unregister_gsi as is.
That means, an IRQ allocated by acpi_register_gsi_xen_hvm() or
acpi_register_gsi_xen() will be freed by acpi_unregister_gsi_ioapic(),
which may cause undesired effects. So override __acpi_unregister_gsi to
NULL for safety.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
---
 arch/x86/include/asm/acpi.h |    1 +
 arch/x86/pci/xen.c          |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 0ab4f9fd2687..3a45668f6dc3 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -50,6 +50,7 @@ void acpi_pic_sci_set_trigger(unsigned int, u16);
 
 extern int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
 				  int trigger, int polarity);
+extern void (*__acpi_unregister_gsi)(u32 gsi);
 
 static inline void disable_acpi(void)
 {
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 6e5e89c3c644..9098d880c476 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -458,6 +458,7 @@ int __init pci_xen_hvm_init(void)
 	 * just how GSIs get registered.
 	 */
 	__acpi_register_gsi = acpi_register_gsi_xen_hvm;
+	__acpi_unregister_gsi = NULL;
 #endif
 
 #ifdef CONFIG_PCI_MSI
@@ -482,6 +483,7 @@ int __init pci_xen_initial_domain(void)
 	pci_msi_ignore_mask = 1;
 #endif
 	__acpi_register_gsi = acpi_register_gsi_xen;
+	__acpi_unregister_gsi = NULL;
 	/* Pre-allocate legacy irqs */
 	for (irq = 0; irq < nr_legacy_irqs(); irq++) {
 		int trigger, polarity;
-- 
1.7.10.4

