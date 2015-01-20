Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbbATCSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:18:37 -0500
Received: from mga03.intel.com ([134.134.136.65]:52772 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbbATCS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:18:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,431,1418112000"; 
   d="scan'208";a="514609206"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Bugfix 2/3] xen/irq, ACPI: Fix regression in xen PCI passthrough caused by cffe0a2b5a34
Date: Tue, 20 Jan 2015 10:21:06 +0800
Message-Id: <1421720467-7709-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421720467-7709-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421720467-7709-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen pciback driver assumes that pci_dev->irq won't change after calling
pci_disable_device(). But commit cffe0a2b5a34c95a4dadc9ec7132690a5b0f6687
("x86, irq: Keep balance of IOAPIC pin reference count") frees irq
resources and resets pci_dev->irq to zero when pci_disable_device() is
called.

So this is a hotfix for 3.19 to avoid resetting pci_dev->irq, and
another proper fix will be prepared for next merging window.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
---
 drivers/acpi/pci_irq.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 5277a0ee5704..b1def411c0b8 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -512,7 +512,6 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
 	dev_dbg(&dev->dev, "PCI INT %c disabled\n", pin_name(pin));
 	if (gsi >= 0) {
 		acpi_unregister_gsi(gsi);
-		dev->irq = 0;
 		dev->irq_managed = 0;
 	}
 }
-- 
1.7.10.4

