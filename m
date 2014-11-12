Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaKLNrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:47:48 -0500
Received: from service87.mimecast.com ([91.220.42.44]:38237 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaKLNrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:47:45 -0500
Message-ID: <546364FA.7010806@arm.com>
Date: Wed, 12 Nov 2014 13:47:38 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC Part4 v1 00/17] Refine support of non-PCI-compliant Message
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 12 Nov 2014 13:47:39.0630 (UTC) FILETIME=[398430E0:01CFFE7F]
X-MC-Unique: 114111213474205601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiang,

On 09/11/14 15:10, Jiang Liu wrote:
> Some interrupt controllers, such as DMAR/HPET/HT_IRQ, work almost in
> the same as PCI MSI interrupt controller. And there some devices make
> use of PCI MSI mechanism for non-PCI devices on ARm/ARM64 platforms.
> 
> So this patches tries to split PCI MSI code into PCI dependent part
> and PCI independent part. The PCI independent part will be used to
> support other PCI MSI like interrupt controllers.
> 
> Patch 1-9 are clean ups for previous hierarchy irqdomain patchset
> and preparation for coming PCI MSI code reorganization.
> Patch 10-15 split PCI MSI code and implement common mechanism to support
> other MSI alike interrupt contollers.
> Patch 16-17 converts HT_IRQ to use the common MSI support mechanism.

[...]

I used this patch series (or rather the v2 in your git tree) to rework the GICv3 ITS patch series. So far, the API seems cleaner (fewer global functions, increased flexibility), at the expense of a bit more complexity.

One thing is still missing though: the way the MSI stacked domain works at the moment prevents the use of the msi_chip infrastructure (you need to override arch_setup_msi_irqs, which in turn prevents the use of msi_chips using setup_irq/teardown_irq callbacks. On arm/arm64, most MSI controllers are using the latter, while it is likely that the newer ones will be using the stacked domains.

My solution to this is to slightly extend the msi_chip framework so that we can hock into the MSI domain framework on a per-msi-chip basis (see patch below). With this in place, I can completely get rid of any arm64-specific code (the msi_chip framework becomes good enough for us):

>From 5e9157ee7879953f89652d6ad9f296fc0ce6cb87 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Wed, 12 Nov 2014 10:32:46 +0000
Subject: [PATCH v2 02/14] PCI/MSI: Allow an msi_chip to be associated to an
 irq domain

The new MSI stacked domain has the interesting effect that it is
quite hard to use if the architecture doesn't provide its own
arch_setup_msi_irqs() function to override the default.

This inhibates the msi_chip infrastructure introduced in
0cbdcfcf427b (PCI: Introduce new MSI chip infrastructure), as it is
not possible to use it as an indirection between the core MSI code
and the MSI driver (useful when having multiple MSI controllers that
do not share the same requirements). The setup_irq and teardown_irq
are rendered useless, as their role is now taken over by the alloc/free
functions in the irq domain code.

This patch introduces two optionnal fields to the msi_chip structure:
- a pointer to an irq domain, describing the MSI domain associated
  with this msi_chip. To be populated with msi_create_irq_domain.
- a domain_alloc_irqs() callback that has the same purpose as
  arch_setup_msi_irqs(), with the above domain as an additional
  parameter.

If both of these fields are non-NULL, then domain_alloc_irqs() is
called, bypassing the setup_irq callback. This allows the MSI driver
to use the domain stacking feature without mandating core support in
the architecture.

Tested on arm64 with the GICv3 ITS.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/pci/msi.c   | 9 ++++++++-
 include/linux/msi.h | 5 +++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 6c38306..baefc21 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -63,8 +63,15 @@ int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 
 	/*
 	 * If an architecture wants to support multiple MSI, it needs to
-	 * override arch_setup_msi_irqs()
+	 * override arch_setup_msi_irqs(), or provide a way out on a per
+	 * domain basis.
 	 */
+#ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
+	struct msi_chip *chip = dev->bus->msi;
+
+	if (chip->domain && chip->domain_alloc_irqs)
+		return chip->domain_alloc_irqs(chip->domain, dev, nvec, type);
+#endif
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
 		return 1;
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 0789a4d..7170eea 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -110,7 +110,12 @@ struct msi_chip {
 	struct device *dev;
 	struct device_node *of_node;
 	struct list_head list;
+#ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
+	struct irq_domain *domain;
 
+	int (*domain_alloc_irqs)(struct irq_domain *domain,
+				 struct pci_dev *pdev, int nvec, int type);
+#endif
 	int (*setup_irq)(struct msi_chip *chip, struct pci_dev *dev,
 			 struct msi_desc *desc);
 	void (*teardown_irq)(struct msi_chip *chip, unsigned int irq);
-- 
2.0.4

Thoughts? I'll post the full patch series later today.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

