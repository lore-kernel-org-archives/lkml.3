Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbaFQF1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:27:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:34991 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165AbaFQF1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:27:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,492,1400050800"; 
   d="scan'208";a="549015175"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC Patch V2 07/16] x86, irq, ACPI: protect acpi_pci_irq_enable() from reentrance
Date: Tue, 17 Jun 2014 13:29:46 +0800
Message-Id: <1402982995-13747-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function acpi_pci_irq_enable() may be called twice for each PCI device
present at boot time as below:
1) pci_acpi_init()
	--> acpi_pci_irq_enable()
2) pci_enable_device()
	--> pcibios_enable_device()
		--> acpi_pci_irq_enable()

So protect acpi_pci_irq_enable() from reentrance to correctly manage
IOAPIC pin reference count.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/pci_irq.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 6ba463ceccc6..9d2ebd5fd9aa 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -413,6 +413,9 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 		return 0;
 	}
 
+	if (dev->irq > 0)
+		return 0;
+
 	entry = acpi_pci_irq_lookup(dev, pin);
 	if (!entry) {
 		/*
@@ -498,6 +501,8 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
 	 */
 
 	dev_dbg(&dev->dev, "PCI INT %c disabled\n", pin_name(pin));
-	if (gsi >= 0 && dev->irq > 0)
+	if (gsi >= 0 && dev->irq > 0) {
 		acpi_unregister_gsi(gsi);
+		dev->irq = 0;
+	}
 }
-- 
1.7.10.4

