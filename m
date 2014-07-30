Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaG3Jem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:34:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:30915 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbaG3Jek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:34:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,763,1400050800"; 
   d="scan'208";a="577587230"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
Subject: [PATCH] x86, irq: Keep IRQ assignment for PCI devices during suspend/hibernation
Date: Wed, 30 Jul 2014 17:37:13 +0800
Message-Id: <1406713034-3387-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <alpine.DEB.2.10.1407282255120.23352@nanos>
References: <alpine.DEB.2.10.1407282255120.23352@nanos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function pci_disable_device() may be called for PCI devices during
suspend/hibernation, which in turn may release IRQ assigned to PCI
interrupt. Later when pci_enable_device() is called during resume,
a different IRQ may be assigned and thus break the driver.
So keep IRQ assignment for PCI devices during suspend/hibernation.
We check pci_dev.dev.power.is_prepared to detect that pci_disable_device()
and pci_enable_device() is called during suspend/hibernation.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Hi Borislav,
	I can't reproduce the issue with my test machine. So could you
please help to test this patch?
Regards!
Gerry
---
 arch/x86/pci/common.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 059a76c29739..417de4c92e8f 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -662,14 +662,15 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	if ((err = pci_enable_resources(dev, mask)) < 0)
 		return err;
 
-	if (!pci_dev_msi_enabled(dev))
+	if (!pci_dev_msi_enabled(dev) && !dev->dev.pm.is_prepared)
 		return pcibios_enable_irq(dev);
 	return 0;
 }
 
 void pcibios_disable_device (struct pci_dev *dev)
 {
-	if (!pci_dev_msi_enabled(dev) && pcibios_disable_irq)
+	if (!pci_dev_msi_enabled(dev) && pcibios_disable_irq &&
+	    !dev->dev.pm.is_prepared)
 		pcibios_disable_irq(dev);
 }
 
-- 
1.7.10.4

