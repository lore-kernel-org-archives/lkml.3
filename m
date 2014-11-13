Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934305AbaKMVAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:00:25 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35992 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933526AbaKMVAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:00:24 -0500
Message-ID: <54651BE2.9080008@arm.com>
Date: Thu, 13 Nov 2014 21:00:18 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch V1 0/6] Refine generic/PCI MSI irqodmian interfaces
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 13 Nov 2014 21:00:20.0008 (UTC) FILETIME=[D5854280:01CFFF84]
X-MC-Unique: 114111321002101201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/11/14 11:43, Jiang Liu wrote:
> This patch set is based on tip/irq/irqdomain and tries to refine
> interfaces to support irqdomain for generic MSI and PCI MSI.
> 
> Patch 1 is just minor fixes for tip/irq/irqdomain.
> 
> Patch 2 introduces some helpers to hide struct msi_desc implementation
> details, so later we could move msi_list from struct pci_dev into
> struct device to enable generic MSI support.
> 
> Patch 3 introduces msi_domain_{alloc|free}_irqs() which generalize
> pci_msi_domain_alloc_irqs() to support generic MSI.
> 
> Patch 4 introduces default data structures and callback implementations
> to support msi_domain_alloc_irqs(), so reduce burden on generic MSI
> users.
> 
> Patch 5 converts PCI MSI to use generic MSI interfaces, and also
> implement default callbacks for PCI MSI.
> 
> Patch 6 introduces a mechanism to replace arch_setup_msi_irq()/
> arch_setup_msi_irqs()/arch_teardown_msi_irq()/arch_teardown_msi_irqs().
> 
> With this patch set applied, the generic MSI and PCI MSI interfaces
> are much easier to use. For extreme case, you only need to define
> a "struct msi_domain_info" and don't need to implement any callbacks,
> just using the default callbacks is OK:)
> 
> This patch set is also a preparation for:
> 1) Kill all weak functions in drivers/pci/msi.c
> 2) Implement support for non-PCI-compliant MSI device

I've rebased (once more!) the GICv3 ITS driver on top of this, and this
is definitely a major improvement. This is basically the first version
I can use without having to hack into the core code (apart from the
couple of nits I've mentioned earlier).

Now, Thomas' idea of putting the irq_domain close to the bus is very
appealing, and I've tweaked an earlier patch in order to do this:

>From f73c2df2f1e66fd13902b2c6bb5773df6538b7df Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Wed, 12 Nov 2014 10:32:46 +0000
Subject: [PATCH] PCI/MSI: Allow an msi_chip to be associated to an irq domain

With the new stacked irq domains, it becomes pretty tempting
to allocate an MSI domain per PCI bus, which would remove
the requirement of either relying on arch-specific code, or
a default PCI MSI domain.

By allowing the msi_chip structure to carry a pointer to
an irq_domain, we can easily use this in pci_msi_setup_msi_irqs.
The existing code can still be used as a fallback if the MSI driver
does not populate the domain field.

Tested on arm64 with the GICv3 ITS driver.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/pci/msi.c   | 9 +++++++--
 include/linux/msi.h | 3 +++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 9947fb4..1752537 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -86,9 +86,14 @@ int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 
 static int pci_msi_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
-	struct irq_domain *domain;
+	struct irq_domain *domain = NULL;
 
-	domain = arch_get_pci_msi_domain(dev);
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+	if (dev->bus->msi)
+		domain = dev->bus->msi->domain;
+#endif
+	if (!domain)
+		domain = arch_get_pci_msi_domain(dev);
 	if (domain)
 		return pci_msi_domain_alloc_irqs(domain, type, dev);
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 9b2e73e..2325950 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -89,6 +89,9 @@ struct msi_chip {
 	struct device *dev;
 	struct device_node *of_node;
 	struct list_head list;
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+	struct irq_domain *domain;
+#endif
 
 	int (*setup_irq)(struct msi_chip *chip, struct pci_dev *dev,
 			 struct msi_desc *desc);
-- 
2.0.4

Thoughts?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

