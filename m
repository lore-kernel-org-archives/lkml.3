Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbaGaAae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:30:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:22679 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbaGaAac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:30:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,768,1400050800"; 
   d="scan'208";a="551585295"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, linux-pci@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, irq: Keep IRQ assignment for PCI devices during suspend/hibernation
Date: Thu, 31 Jul 2014 08:33:26 +0800
Message-Id: <1406766807-5745-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140730175836.GC10213@pd.tnic>
References: <20140730175836.GC10213@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function pci_disable_device() may be called for PCI devices during
suspend/hibernation, which in turn may release IRQ assigned for PCI
interrupt. Later when pci_enable_device() is called during resume,
a different IRQ may be assigned and thus break the driver.
So keep IRQ assignment for PCI devices during suspend/hibernation.
We check pci_dev.dev.power.is_prepared to detect that pci_disable_device()
and pci_enable_device() is called during suspend/hibernation.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Hi Borilav,
	Sorry for the incovenience, something is wrong when synchronizing
the patch.  I have found that "pm" should be "power" when building and
testing this patch on my test machine. And I have also fixed it on my
development machine, but forgot to do "stg refresh" before "git format-patch",
so caused the inconvenience.
Regards!
Gerry
---
 arch/x86/pci/common.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 059a76c29739..9115e7ae564b 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -662,14 +662,15 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	if ((err = pci_enable_resources(dev, mask)) < 0)
 		return err;
 
-	if (!pci_dev_msi_enabled(dev))
+	if (!pci_dev_msi_enabled(dev) && !dev->dev.power.is_prepared)
 		return pcibios_enable_irq(dev);
 	return 0;
 }
 
 void pcibios_disable_device (struct pci_dev *dev)
 {
-	if (!pci_dev_msi_enabled(dev) && pcibios_disable_irq)
+	if (!pci_dev_msi_enabled(dev) && pcibios_disable_irq &&
+	    !dev->dev.power.is_prepared)
 		pcibios_disable_irq(dev);
 }
 
-- 
1.7.10.4

