Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab3GLBj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 21:39:26 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:29376 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab3GLBjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 21:39:24 -0400
Message-ID: <51DF5DFC.3090107@huawei.com>
Date: Fri, 12 Jul 2013 09:38:04 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Don Dutile <ddutile@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Rafael <rjw@sisk.pl>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>
Subject: Re: [PATCH -v2 1/3] PCI: introduce PCIe Device Serial Number Capability
 support
References: <1373535825-49972-1-git-send-email-wangyijing@huawei.com> <1373535825-49972-2-git-send-email-wangyijing@huawei.com> <51DE8032.4040808@redhat.com>
In-Reply-To: <51DE8032.4040808@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,
   Thanks for your review and comments very much!

>> +    dev->sn = pci_device_serial_number(dev);
>> +
> Finally, 'the comment below':
> I know you were following Bjorn's suggestion, which I thought
> was an improvement, but why not do above assignment in pci_device_serial_number() ?

I don't do assignment in pci_device_serial_number() because pci_device_serial_number()
is an EXPORT_SYMBOL, and will be used to get dsn for non-scaned device, for example:

1. we have pcie device in slot before suspend.
2. we removed the device during suspend.
3. we reinserted a new device during suspend.
4. we should check the device change during resume, so we
try to use pcie device serial number to identify changes.
But the pci_dev structure maybe the old stale data. So
I prefer to get dsn by return.

what about this:

static void pci_init_capabilities(struct pci_dev *dev)
    ........
    pci_dsn_init(dev);
    ..........


void pci_dsn_init(dev)
{
    dev->sn = pci_device_serial_number(dev);
}



> See above....
> - Don
> 
>>       /* Vital Product Data */
>>       pci_vpd_pci22_init(dev);
>>
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 0fd1f15..10d190b 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -342,6 +342,7 @@ struct pci_dev {
>>       struct list_head msi_list;
>>       struct kset *msi_kset;
>>   #endif
>> +    u64 sn;        /* device serieal number, 0 if not support */
>>       struct pci_vpd *vpd;
>>   #ifdef CONFIG_PCI_ATS
>>       union {
>> @@ -995,6 +996,8 @@ ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
>>   ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void *buf);
>>   int pci_vpd_truncate(struct pci_dev *dev, size_t size);
>>
>> +u64 pci_device_serial_number(struct pci_dev *dev);
>> +
>>   /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
>>   resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx);
>>   void pci_bus_assign_resources(const struct pci_bus *bus);
> 
> 
> .
> 


-- 
Thanks!
Yijing

