Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaE0IL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:11:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:39674 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbaE0ILW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:11:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,917,1392192000"; 
   d="scan'208";a="538018655"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch V3 27/37] x86, irq, mpparse: use common irqdomain map interface to program IOAPIC pins
Date: Tue, 27 May 2014 16:08:02 +0800
Message-Id: <1401178092-1228-28-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com>
References: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refine mpparse to use common irqdomain map interface to program IOAPIC pins,
so we can unify the callsite to progam IOAPIC pins.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/mpparse.c |    4 +++-
 arch/x86/pci/irq.c        |    2 --
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index b9823bea332a..55acf55b41e7 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -113,7 +113,9 @@ static void __init MP_bus_info(struct mpc_bus *m)
 		pr_warn("Unknown bustype %s - ignoring\n", str);
 }
 
-static struct irq_domain_ops mp_ioapic_irqdomain_ops;
+static struct irq_domain_ops mp_ioapic_irqdomain_ops = {
+	.map = mp_irqdomain_map,
+};
 
 static struct irq_domain *mp_ioapic_create_irqdomain(int ioapic, void *arg)
 {
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 84112f55dd7a..e4200e5e775e 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -1227,8 +1227,6 @@ static int pirq_enable_irq(struct pci_dev *dev)
 			}
 			dev = temp_dev;
 			if (irq >= 0) {
-				io_apic_set_pci_routing(&dev->dev, irq,
-							 &irq_attr);
 				dev->irq = irq;
 				dev_info(&dev->dev, "PCI->APIC IRQ transform: "
 					 "INT %c -> IRQ %d\n", 'A' + pin - 1, irq);
-- 
1.7.10.4

