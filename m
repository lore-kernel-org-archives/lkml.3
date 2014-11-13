Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944AbaKMTqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:46:10 -0500
Received: from service87.mimecast.com ([91.220.42.44]:54107 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146AbaKMTqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:46:08 -0500
Message-ID: <54650A79.1020408@arm.com>
Date: Thu, 13 Nov 2014 19:46:01 +0000
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
        Alexander Gordeev <agordeev@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch V1 6/6] PCI, MSI: Provide mechanism to alloc/free MSI/MSIX
 interrupt from irqdomain
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com> <1415879029-20098-8-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1415879029-20098-8-git-send-email-jiang.liu@linux.intel.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 13 Nov 2014 19:46:02.0726 (UTC) FILETIME=[74C60060:01CFFF7A]
X-MC-Unique: 114111319460301601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiang,

On 13/11/14 11:43, Jiang Liu wrote:
> Provide mechanism to directly alloc/free MSI/MSIX interrupt from
> irqdomain, which will be used to replace arch_setup_msi_irq()/
> arch_setup_msi_irqs()/arch_teardown_msi_irq()/arch_teardown_msi_irqs().
> 
> To kill weak functions, this patch introduce a new weak function
> arch_get_pci_msi_domain(), which is to retrieve the MSI irqdomain
> for a PCI device. This weak function could be killed once we get
> a common way to associate MSI domain with PCI device.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/pci/msi.c   |   60 +++++++++++++++++++++++++++++++++++++++++++++++----
>  include/linux/msi.h |    3 +++
>  2 files changed, 59 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 0319c21dd208..6f8a2f93187a 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -27,8 +27,41 @@ static int pci_msi_enable = 1;
>  
>  #define msix_table_size(flags)	((flags & PCI_MSIX_FLAGS_QSIZE) + 1)
>  
> -/* Arch hooks */
> +#ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
> +static struct irq_domain *pci_msi_default_domain;
> +
> +struct irq_domain * __weak arch_get_pci_msi_domain(struct pci_dev *dev)
> +{
> +	return pci_msi_default_domain;
> +}
> +
> +static int pci_msi_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> +{
> +	struct irq_domain *domain;
>  
> +	domain = arch_get_pci_msi_domain(dev);
> +	if (domain)
> +		return pci_msi_domain_alloc_irqs(domain, type, dev);
> +
> +	return arch_setup_msi_irqs(dev, nvec, type);
> +}
> +
> +static void pci_msi_teardown_msi_irqs(struct pci_dev *dev)
> +{
> +	struct irq_domain *domain;
> +
> +	domain = arch_get_pci_msi_domain(dev);
> +	if (domain)
> +		pci_msi_domain_free_irqs(domain, dev);
> +	else
> +		arch_teardown_msi_irqs(dev);
> +}
> +#else
> +#define pci_msi_setup_msi_irqs		arch_setup_msi_irqs
> +#define pci_msi_teardown_msi_irqs	arch_teardown_msi_irqs
> +#endif
> +
> +/* Arch hooks */
>  int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
>  {
>  	struct msi_chip *chip = dev->bus->msi;
> @@ -329,7 +362,7 @@ static void free_msi_irqs(struct pci_dev *dev)
>  			for (i = 0; i < entry->nvec_used; i++)
>  				BUG_ON(irq_has_action(entry->irq + i));
>  
> -	arch_teardown_msi_irqs(dev);
> +	pci_msi_teardown_msi_irqs(dev);
>  
>  	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
>  		if (entry->msi_attrib.is_msix) {
> @@ -581,7 +614,7 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
>  	list_add_tail(&entry->list, &dev->msi_list);
>  
>  	/* Configure MSI capability structure */
> -	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
> +	ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
>  	if (ret) {
>  		msi_mask_irq(entry, mask, ~mask);
>  		free_msi_irqs(dev);
> @@ -696,7 +729,7 @@ static int msix_capability_init(struct pci_dev *dev,
>  	if (ret)
>  		return ret;
>  
> -	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
> +	ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
>  	if (ret)
>  		goto out_avail;
>  
> @@ -1183,4 +1216,23 @@ void pci_msi_domain_free_irqs(struct irq_domain *domain, struct pci_dev *dev)
>  {
>  	msi_domain_free_irqs(domain, &dev->dev);
>  }
> +
> +struct irq_domain *pci_msi_create_default_irq_domain(struct device_node *node,
> +		 struct msi_domain_info *info, struct irq_domain *parent)
> +{
> +	struct irq_domain *domain;
> +	static DEFINE_MUTEX(pci_msi_domain_lock);
> +
> +	mutex_lock(&pci_msi_domain_lock);
> +	if (pci_msi_default_domain) {
> +		pr_err("PCI: default irq domain for PCI MSI has already been created.\n");
> +		domain = NULL;
> +	} else {
> +		domain = msi_create_irq_domain(node, info, parent);

Surely this needs to be a call to pci_msi_create_irq_domain().
Otherwise, not much is working on the PCI side...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

