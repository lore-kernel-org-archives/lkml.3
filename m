Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbbATKu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:50:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56003 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbbATKuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:50:21 -0500
Date: Tue, 20 Jan 2015 02:50:02 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-8abb850a03a3a8b11a0e92949e5b99d9cc178e35@git.kernel.org>
Cc: bhelgaas@google.com, tglx@linutronix.de, tony.luck@intel.com,
        lv.zheng@intel.com, linux@eikelenboom.it, hpa@zytor.com,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com,
        konrad.wilk@oracle.com, mingo@kernel.org, jiang.liu@linux.intel.com,
        graeme.gregory@linaro.org
Reply-To: mingo@kernel.org, graeme.gregory@linaro.org,
        jiang.liu@linux.intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, david.vrabel@citrix.com, tglx@linutronix.de,
        lv.zheng@intel.com, tony.luck@intel.com, linux@eikelenboom.it,
        bhelgaas@google.com
In-Reply-To: <1421720467-7709-4-git-send-email-jiang.liu@linux.intel.com>
References: <1421720467-7709-4-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/xen:
  Override ACPI IRQ management callback __acpi_unregister_gsi
Git-Commit-ID: 8abb850a03a3a8b11a0e92949e5b99d9cc178e35
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8abb850a03a3a8b11a0e92949e5b99d9cc178e35
Gitweb:     http://git.kernel.org/tip/8abb850a03a3a8b11a0e92949e5b99d9cc178e35
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 20 Jan 2015 10:21:07 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 20 Jan 2015 11:44:41 +0100

x86/xen: Override ACPI IRQ management callback __acpi_unregister_gsi

Xen overrides __acpi_register_gsi and leaves __acpi_unregister_gsi as is.
That means, an IRQ allocated by acpi_register_gsi_xen_hvm() or
acpi_register_gsi_xen() will be freed by acpi_unregister_gsi_ioapic(),
which may cause undesired effects. So override __acpi_unregister_gsi to
NULL for safety.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Tony Luck <tony.luck@intel.com>
Cc: xen-devel@lists.xenproject.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>
Cc: Lv Zheng <lv.zheng@intel.com>
Link: http://lkml.kernel.org/r/1421720467-7709-4-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/acpi.h | 1 +
 arch/x86/pci/xen.c          | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 0ab4f9f..3a45668 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -50,6 +50,7 @@ void acpi_pic_sci_set_trigger(unsigned int, u16);
 
 extern int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
 				  int trigger, int polarity);
+extern void (*__acpi_unregister_gsi)(u32 gsi);
 
 static inline void disable_acpi(void)
 {
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 6e5e89c..9098d88 100644
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
