Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbaFUVUz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:20:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36288 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758088AbaFUVUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:20:52 -0400
Date: Sat, 21 Jun 2014 14:17:51 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-8a3e533df17f821a4d25dd2969d2f90d7c168b46@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-41-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-41-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq, SFI:
  Release IOAPIC pin when PCI device is disabled
Git-Commit-ID: 8a3e533df17f821a4d25dd2969d2f90d7c168b46
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

Commit-ID:  8a3e533df17f821a4d25dd2969d2f90d7c168b46
Gitweb:     http://git.kernel.org/tip/8a3e533df17f821a4d25dd2969d2f90d7c168b46
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:20:09 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:44 +0200

x86, irq, SFI: Release IOAPIC pin when PCI device is disabled

Release IOAPIC pin associated with PCI device when the PCI device
is disabled.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1402302011-23642-41-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/pci/intel_mid_pci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index 337d165..09fece3 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -227,6 +227,12 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 	return 0;
 }
 
+static void intel_mid_pci_irq_disable(struct pci_dev *dev)
+{
+	if (dev->irq > 0)
+		mp_unmap_irq(dev->irq);
+}
+
 struct pci_ops intel_mid_pci_ops = {
 	.read = pci_read,
 	.write = pci_write,
@@ -243,6 +249,7 @@ int __init intel_mid_pci_init(void)
 	pr_info("Intel MID platform detected, using MID PCI ops\n");
 	pci_mmcfg_late_init();
 	pcibios_enable_irq = intel_mid_pci_irq_enable;
+	pcibios_disable_irq = intel_mid_pci_irq_disable;
 	pci_root_ops = intel_mid_pci_ops;
 	pci_soc_mode = 1;
 	/* Continue with standard init */
