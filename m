Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab3KHDlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 22:41:46 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:63116 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab3KHDlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 22:41:44 -0500
Message-ID: <527C5D36.7050206@huawei.com>
Date: Fri, 8 Nov 2013 11:40:38 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Joerg Roedel <joro@8bytes.org>, <linux-pci@vger.kernel.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>,
        "Dan Williams" <dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        "Hanjun Guo" <guohanjun@huawei.com>
Subject: Re: [PATCH 1/1] IOMMU: Save pci device id instead of pci_dev* pointer
 for DMAR devices
References: <1383639898-48776-1-git-send-email-wangyijing@huawei.com> <1383639898-48776-2-git-send-email-wangyijing@huawei.com> <20131107180713.GA2955@google.com>
In-Reply-To: <20131107180713.GA2955@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Bjorn,
   Thanks for your review and comments very much!

>> +		list_for_each_entry(dmar_dev, head, list)
>> +		    if (dmar_dev->segment == pci_domain_nr(dev->bus)
>> +			    && dmar_dev->bus == dev->bus->number
>> +			    && dmar_dev->devfn == dev->devfn)
>> +			return 1;
>> +		
>>  		/* Check our parent */
>>  		dev = dev->bus->self;
> 
> You didn't change this, but it looks like this may have the same problem
> we've been talking about here:
> 
> http://lkml.kernel.org/r/20131105232903.3790.8738.stgit@bhelgaas-glaptop.roam.corp.google.com
> 
> Namely, if "dev" is a VF on a virtual bus, "dev->bus->self == NULL", so
> we won't search for any of the bridges leading to the VF.  I proposed a
> pci_upstream_bridge() interface that could be used like this:
> 
> 	/* Check our parent */
> 	dev = pci_upstream_bridge(dev);
>

It looks good to me, because pci_upstream_bridge() is still in your next branch, I think maybe
I can split this changes in a separate patch after 3.13-rc1.


>>  static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
>>  {
>>  	struct dmar_drhd_unit *drhd = NULL;
>> -	int i;
>> +	struct dmar_device *dmar_dev;
>> +	struct pci_dev *pdev;
>>  
>>  	for_each_drhd_unit(drhd) {
>>  		if (drhd->ignored)
>> @@ -658,16 +659,22 @@ static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
>>  		if (segment != drhd->segment)
>>  			continue;
>>  
>> -		for (i = 0; i < drhd->devices_cnt; i++) {
>> -			if (drhd->devices[i] &&
>> -			    drhd->devices[i]->bus->number == bus &&
>> -			    drhd->devices[i]->devfn == devfn)
>> -				return drhd->iommu;
>> -			if (drhd->devices[i] &&
>> -			    drhd->devices[i]->subordinate &&
>> -			    drhd->devices[i]->subordinate->number <= bus &&
>> -			    drhd->devices[i]->subordinate->busn_res.end >= bus)
>> -				return drhd->iommu;
>> +		list_for_each_entry(dmar_dev, &drhd->head, list) {
>> +		    if (dmar_dev->bus == bus && 
>> +			    dmar_dev->devfn == devfn)
>> +			return drhd->iommu;
>> +
>> +		    pdev = pci_get_domain_bus_and_slot(dmar_dev->segment, 
>> +			    dmar_dev->bus, dmar_dev->devfn);
>> +		    if (pdev->subordinate && 
>> +			    pdev->subordinate->number <= bus &&
>> +			    pdev->subordinate->busn_res.end >= bus) {
>> +			pci_dev_put(pdev);
>> +			return drhd->iommu;
> 
> I don't know the details of how device_to_iommu() is used, but this
> style (acquire ref to pci_dev, match it to some other object, drop
> pci_dev ref, return object) makes me nervous.  How do we know the
> caller isn't depending on pci_dev to remain attached to the object?
> What happens if the pci_dev disappears when we do the pci_dev_put()
> here?

Hmmm, this is the thing I am most worried about. If we just only use
(pci_dev *) poninter in drhd->devices array as a identification. Change
(pci_dev *) pointer instead of pci device id segment:bus:devfn is safe.
Or, this is a wrong way to fix this issue. I don't know IOMMU driver much now,
so IOMMU guys any comments on this issue is welcome.

If this is not safe, what about we both save pci device id and (pci_dev *) pointer
in drhd. So we can put pci_dev ref and set pci_dev * = NULL during device removed by bus notify, and
update (pci_dev *)pointer during device add.

like this:
struct dmar_device {
    struct list_head list;
    u16 segment;
    u8 bus;
    u8 devfn;
    struct pci_dev *dev;
};

>>  	for_each_drhd_unit(drhd) {
>> -		int i;
>>  		if (drhd->ignored || drhd->include_all)
>>  			continue;
>>  
>> -		for (i = 0; i < drhd->devices_cnt; i++)
>> -			if (drhd->devices[i] &&
>> -			    !IS_GFX_DEVICE(drhd->devices[i]))
>> +		list_for_each_entry(dmar_dev, &drhd->head, list) {
>> +			pdev = pci_get_domain_bus_and_slot(dmar_dev->segment,
>> +				dmar_dev->bus, dmar_dev->devfn);
>> +			if (!IS_GFX_DEVICE(pdev)) {
>> +				pci_dev_put(pdev);
>>  				break;
>> +			}
>> +			pci_dev_put(pdev);
>> +		}
>>  
>> -		if (i < drhd->devices_cnt)
>> +		if (!IS_GFX_DEVICE(pdev))
> 
> I think this is clearly wrong.  You acquire a pdev reference, drop the
> reference, then look at pdev again after dropping the reference.  But
> as soon as you do the pci_dev_put(), you have to assume pdev is no
> longer valid.
>

You are right, should move pci_dev_put() after if (!IS_GFX_DEVICE(pdev)).



>>  
>> +struct dmar_device {
>> +	struct list_head list;
>> +	u8 segment;
> 
> I think this should be u16.  I didn't chase down how you're using it,
> but Table 8.3 in the Intel VT-d spec shows Segment Number in a DRHD
> structure as 16 bits.

Yes, it's my mistake, thanks!

> 
>> +	u8 bus;
>> +	u8 devfn;
>> +};
>> +
>>  struct intel_iommu;
>>  #ifdef CONFIG_DMAR_TABLE
>>  extern struct acpi_table_header *dmar_tbl;
>> @@ -39,8 +46,7 @@ struct dmar_drhd_unit {
>>  	struct list_head list;		/* list of drhd units	*/
>>  	struct  acpi_dmar_header *hdr;	/* ACPI header		*/
>>  	u64	reg_base_addr;		/* register base address*/
>> -	struct	pci_dev **devices; 	/* target device array	*/
>> -	int	devices_cnt;		/* target device count	*/
>> +	struct list_head head;	/* target devices' list */
> 
> s/devices'/device/ (also below).  This is not a contraction or a
> possessive construct, so no apostrophe is needed.
> 
>>  	u16	segment;		/* PCI domain		*/
>>  	u8	ignored:1; 		/* ignore drhd		*/
>>  	u8	include_all:1;
>> @@ -139,8 +145,7 @@ struct dmar_rmrr_unit {
>>  	struct acpi_dmar_header *hdr;	/* ACPI header		*/
>>  	u64	base_address;		/* reserved base address*/
>>  	u64	end_address;		/* reserved end address */
>> -	struct pci_dev **devices;	/* target devices */
>> -	int	devices_cnt;		/* target device count */
>> +	struct list_head head;	/* target devices' list */
>>  };
>>  
>>  #define for_each_rmrr_units(rmrr) \
>> @@ -149,16 +154,15 @@ struct dmar_rmrr_unit {
>>  struct dmar_atsr_unit {
>>  	struct list_head list;		/* list of ATSR units */
>>  	struct acpi_dmar_header *hdr;	/* ACPI header */
>> -	struct pci_dev **devices;	/* target devices */
>> -	int devices_cnt;		/* target device count */
>>  	u8 include_all:1;		/* include all ports */
>> +	struct list_head head;	/* target devices' list */
>>  };
>>  
>>  int dmar_parse_rmrr_atsr_dev(void);
>>  extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
>>  extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
>> -extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
>> -				struct pci_dev ***devices, u16 segment);
>> +extern int dmar_parse_dev_scope(void *start, void *end, u16 segment, 
>> +				struct list_head *head);
>>  extern int intel_iommu_init(void);
>>  #else /* !CONFIG_INTEL_IOMMU: */
>>  static inline int intel_iommu_init(void) { return -ENODEV; }
>> -- 
>> 1.7.1
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> .
> 


-- 
Thanks!
Yijing

