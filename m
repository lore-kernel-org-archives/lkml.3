Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbaHEDjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 23:39:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:34534 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbaHEDXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 23:23:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,802,1400050800"; 
   d="scan'208";a="583451077"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        x86@kernel.org, Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Bugfix 1/2] x86, irq, PCI: Keep IRQ assignment for PCI devices during suspend/hibernation
Date: Tue,  5 Aug 2014 11:26:17 +0800
Message-Id: <1407209178-18644-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407209178-18644-1-git-send-email-jiang.liu@linux.intel.com>
References: <1407209178-18644-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Hi Borislav,
	Could you please help to review the patch again since I have
made changes against the previous version?
Regards!
Gerry
---
 arch/x86/pci/intel_mid_pci.c |    2 +-
 arch/x86/pci/irq.c           |    3 ++-
 drivers/acpi/pci_irq.c       |    4 ++++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index 09fece368592..3865116c51fb 100644
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
index 748cfe8ab322..bc1a2c341891 100644
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
index 6ba463ceccc6..c96887d5289e 100644
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
-- 
1.7.10.4

