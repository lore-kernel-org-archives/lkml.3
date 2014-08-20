Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaHTGge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:36:34 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:14504 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaHTGgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:36:32 -0400
Message-ID: <53F44178.7070409@huawei.com>
Date: Wed, 20 Aug 2014 14:34:32 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Paul.Mundt@huawei.com" <Paul.Mundt@huawei.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "arnab.basu@freescale.com" <arnab.basu@freescale.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [RFC PATCH 09/11] PCI/MSI: refactor PCI MSI driver
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com> <1406344128-27055-10-git-send-email-wangyijing@huawei.com> <5fe08f65ec1d40a98ca28389b7e37572@BLUPR03MB566.namprd03.prod.outlook.com>
In-Reply-To: <5fe08f65ec1d40a98ca28389b7e37572@BLUPR03MB566.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -1025,21 +1059,52 @@ int pci_msi_enabled(void)
>>  }
>>  EXPORT_SYMBOL(pci_msi_enabled);
>>
>> -void pci_msi_init_pci_dev(struct pci_dev *dev)
>> +static struct msi_ops pci_msi = {
>> +	.msi_set_enable = msi_set_enable,
>> +	.msi_setup_entry = msi_setup_entry,
>> +	.msix_setup_entries = msix_setup_entries,
>> +	.msi_mask_irq = default_msi_mask_irq,
>> +	.msix_mask_irq = default_msix_mask_irq,
>> +	.msi_read_message = __read_msi_msg,
>> +	.msi_write_message = __write_msi_msg,
>> +	.msi_set_intx =  pci_intx_for_msi,
>> +};
> 
> Ahh, want to be sure I am understanding this correctly. So if I have a non-pci driver "xyz" which wants to use separate ops then I need to have a all these functions in that driver. Something like driver/xyz/msi.c

Yes, because different MSI device has different MSI hardware registers, so every MSI type should provide its own msi_ops, or its own msi_driver in my new proposal.


> 
> Thanks
> -Bharat
> 
>> +
>> +struct msi_irqs *alloc_msi_irqs(void *data, struct msi_ops *ops)
>>  {
>> -	INIT_LIST_HEAD(&dev->msi_list);
>> +	struct msi_irqs *msi;
>> +
>> +	msi = kzalloc(sizeof(struct msi_irqs), GFP_KERNEL);
>> +	if (!msi)
>> +		return NULL;
>>
>> +	INIT_LIST_HEAD(&msi->msi_list);
>> +	msi->data = data;
>> +	msi->ops = ops;
>> +	return msi;
>> +}
>> +
>> +void pci_msi_init_pci_dev(struct pci_dev *dev)
>> +{
>>  	/* Disable the msi hardware to avoid screaming interrupts
>>  	 * during boot.  This is the power on reset default so
>>  	 * usually this should be a noop.
>>  	 */
>>  	dev->msi_cap = pci_find_capability(dev, PCI_CAP_ID_MSI);
>> -	if (dev->msi_cap)
>> -		msi_set_enable(dev, 0);
>> -
>>  	dev->msix_cap = pci_find_capability(dev, PCI_CAP_ID_MSIX);
>> -	if (dev->msix_cap)
>> -		msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
>> +
>> +	if (dev->msi_cap || dev->msix_cap) {
>> +		dev->msi = alloc_msi_irqs(dev, &pci_msi);
>> +		if (!dev->msi)
>> +			return;
>> +
>> +		dev->msi->node = dev_to_node(&dev->dev);
>> +		if (dev->msi_cap)
>> +			msi_set_enable(dev->msi, 0, MSI_TYPE);
>> +
>> +		if (dev->msix_cap)
>> +			msi_set_enable(dev->msi, 0, MSIX_TYPE);
>> +	}
>>  }
>>
>>  /**
>> @@ -1060,13 +1125,13 @@ int pci_enable_msi_range(struct pci_dev *dev, int
>> minvec, int maxvec)
>>  	int rc;
>>  	struct msi_desc *entry;
>>
>> -	if (dev->current_state != PCI_D0)
>> +	if (dev->current_state != PCI_D0 || !dev->msi)
>>  		return -EINVAL;
>>
>> -	WARN_ON(!!dev->msi_enabled);
>> +	WARN_ON(!!pci_dev_msi_enabled(dev, MSI_TYPE));
>>
>>  	/* Check whether driver already requested MSI-X irqs */
>> -	if (dev->msix_enabled) {
>> +	if (pci_dev_msi_enabled(dev, MSIX_TYPE)) {
>>  		dev_info(&dev->dev,
>>  			 "can't enable MSI (MSI-X already enabled)\n");
>>  		return -EINVAL;
>> @@ -1095,7 +1160,7 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec,
>> int maxvec)
>>  	} while (rc);
>>
>>  	do {
>> -		rc = msi_capability_init(dev, nvec);
>> +		rc = msi_capability_init(dev->msi, nvec);
>>  		if (rc < 0) {
>>  			return rc;
>>  		} else if (rc > 0) {
>> @@ -1107,14 +1172,14 @@ int pci_enable_msi_range(struct pci_dev *dev, int
>> minvec, int maxvec)
>>
>>  	rc = populate_msi_sysfs(dev);
>>  	if (rc) {
>> -		msi_set_enable(dev, 0);
>> -		pci_intx_for_msi(dev, 1);
>> -		dev->msi_enabled = 0;
>> -		free_msi_irqs(dev);
>> +		msi_set_enable(dev->msi, 0, MSI_TYPE);
>> +		pci_intx_for_msi(dev->msi, 1);
>> +		dev->msi->msi_enabled = 0;
>> +		free_msi_irqs(dev->msi);
>>  		return rc;
>>  	}
>>
>> -	entry = list_entry(dev->msi_list.next, struct msi_desc, list);
>> +	entry = list_entry(dev->msi->msi_list.next, struct msi_desc, list);
>>  	dev->irq = entry->irq;
>>  	return nvec;
>>  }
>> @@ -1158,3 +1223,5 @@ int pci_enable_msix_range(struct pci_dev *dev, struct
>> msix_entry *entries,
>>  	return nvec;
>>  }
>>  EXPORT_SYMBOL(pci_enable_msix_range);
>> +
>> +
>> diff --git a/include/linux/msi.h b/include/linux/msi.h
>> index 5a672d3..fc8f3e8 100644
>> --- a/include/linux/msi.h
>> +++ b/include/linux/msi.h
>> @@ -83,15 +83,15 @@ struct msi_desc {
>>   * implemented as weak symbols so that they /can/ be overriden by
>>   * architecture specific code if needed.
>>   */
>> -int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc);
>> +int arch_setup_msi_irq(struct msi_irqs *msi, struct msi_desc *desc);
>>  void arch_teardown_msi_irq(unsigned int irq);
>> -int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
>> -void arch_teardown_msi_irqs(struct pci_dev *dev);
>> -int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
>> -void arch_restore_msi_irqs(struct pci_dev *dev);
>> +int arch_setup_msi_irqs(struct msi_irqs *msi, int nvec, int type);
>> +void arch_teardown_msi_irqs(struct msi_irqs *msi);
>> +int arch_msi_check_device(struct msi_irqs *msi, int nvec, int type);
>> +void arch_restore_msi_irqs(struct msi_irqs *msi);
>>
>> -void default_teardown_msi_irqs(struct pci_dev *dev);
>> -void default_restore_msi_irqs(struct pci_dev *dev);
>> +void default_teardown_msi_irqs(struct msi_irqs *msi);
>> +void default_restore_msi_irqs(struct msi_irqs *msi);
>>  u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
>>  u32 default_msix_mask_irq(struct msi_desc *desc, u32 flag);
>>
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index c7bca1c..d7126fc 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -334,8 +334,6 @@ struct pci_dev {
>>  	unsigned int	block_cfg_access:1;	/* config space access is blocked */
>>  	unsigned int	broken_parity_status:1;	/* Device generates false positive
>> parity */
>>  	unsigned int	irq_reroute_variant:2;	/* device needs IRQ rerouting
>> variant */
>> -	unsigned int	msi_enabled:1;
>> -	unsigned int	msix_enabled:1;
>>  	unsigned int	ari_enabled:1;	/* ARI forwarding */
>>  	unsigned int	is_managed:1;
>>  	unsigned int    needs_freset:1; /* Dev requires fundamental reset */
>> @@ -358,7 +356,7 @@ struct pci_dev {
>>  	struct bin_attribute *res_attr[DEVICE_COUNT_RESOURCE]; /* sysfs file for
>> resources */
>>  	struct bin_attribute *res_attr_wc[DEVICE_COUNT_RESOURCE]; /* sysfs file
>> for WC mapping of resources */
>>  #ifdef CONFIG_PCI_MSI
>> -	struct list_head msi_list;
>> +	struct msi_irqs *msi;
>>  	const struct attribute_group **msi_irq_groups;
>>  #endif
>>  	struct pci_vpd *vpd;
>> @@ -510,11 +508,14 @@ static inline struct pci_dev *pci_upstream_bridge(struct
>> pci_dev *dev)
>>  static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev, int type)
>>  {
>>  	bool enabled = 0;
>> +
>> +	if (!pci_dev->msi)
>> +		return false;
>>
>>  	if (type & MSI_TYPE)
>> -		enabled |= pci_dev->msi_enabled;
>> +		enabled |= pci_dev->msi->msi_enabled;
>>  	if (type & MSIX_TYPE)
>> -		enabled |= pci_dev->msix_enabled;
>> +		enabled |= pci_dev->msi->msix_enabled;
>>
>>  	return enabled;
>>  }
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 


-- 
Thanks!
Yijing

