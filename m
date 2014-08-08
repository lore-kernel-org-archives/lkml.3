Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbaHHJV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:21:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45141 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaHHJVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:21:53 -0400
Date: Fri, 8 Aug 2014 02:19:53 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-3eec595235c17a74094daa1e02d1b0af2e9a7125@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, lenb@kernel.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, benh@kernel.crashing.org, bhelgaas@google.com,
        rjw@rjwysocki.net, bp@suse.de
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, lenb@kernel.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, benh@kernel.crashing.org, bhelgaas@google.com,
        rjw@rjwysocki.net, bp@suse.de
In-Reply-To: <1407478071-29399-1-git-send-email-jiang.liu@linux.intel.com>
References: <1407478071-29399-1-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq, PCI:
  Keep IRQ assignment for PCI devices during suspend/hibernation
Git-Commit-ID: 3eec595235c17a74094daa1e02d1b0af2e9a7125
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

Commit-ID:  3eec595235c17a74094daa1e02d1b0af2e9a7125
Gitweb:     http://git.kernel.org/tip/3eec595235c17a74094daa1e02d1b0af2e9a7125
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Fri, 8 Aug 2014 14:07:51 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 8 Aug 2014 11:14:45 +0200

x86, irq, PCI: Keep IRQ assignment for PCI devices during suspend/hibernation

Now IOAPIC driver dynamically allocates IRQ numbers for IOAPIC pins.
We need to keep IRQ assignment for PCI devices during suspend/hibernation,
otherwise it may cause failure of suspend/hibernation due to:
1) Device driver calls pci_enable_device() to allocate an IRQ number
   and register interrupt handler on the returned IRQ.
2) Device driver's suspend callback calls pci_disable_device() and
   release assigned IRQ in turn.
3) Device driver's resume callback calls pci_enable_device() to
   allocate IRQ number again. A different IRQ number may be assigned
   by IOAPIC driver this time.
4) Now the hardware delivers interrupt to the new IRQ but interrupt
   handler is still registered against the old IRQ, so it breaks
   suspend/hibernation.

To fix this issue, we keep IRQ assignment during suspend/hibernation.
Flag pci_dev.dev.power.is_prepared is used to detect that
pci_disable_device() is called during suspend/hibernation.

Reported-and-Tested-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Len Brown <lenb@kernel.org>
Link: http://lkml.kernel.org/r/1407478071-29399-1-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/pci/intel_mid_pci.c | 2 +-
 arch/x86/pci/irq.c           | 3 ++-
 drivers/acpi/pci_irq.c       | 4 ++++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index 09fece3..3865116 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -229,7 +229,7 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 
 static void intel_mid_pci_irq_disable(struct pci_dev *dev)
 {
-	if (dev->irq > 0)
+	if (!dev->dev.power.is_prepared && dev->irq > 0)
 		mp_unmap_irq(dev->irq);
 }
 
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 748cfe8..bc1a2c3 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -1256,7 +1256,8 @@ static int pirq_enable_irq(struct pci_dev *dev)
 
 static void pirq_disable_irq(struct pci_dev *dev)
 {
-	if (io_apic_assign_pci_irqs && dev->irq) {
+	if (io_apic_assign_pci_irqs && !dev->dev.power.is_prepared &&
+	    dev->irq) {
 		mp_unmap_irq(dev->irq);
 		dev->irq = 0;
 	}
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 6ba463c..c96887d 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -481,6 +481,10 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
 	if (!pin)
 		return;
 
+	/* Keep IOAPIC pin configuration when suspending */
+	if (dev->dev.power.is_prepared)
+		return;
+
 	entry = acpi_pci_irq_lookup(dev, pin);
 	if (!entry)
 		return;
