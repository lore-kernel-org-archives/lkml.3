Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaHTH4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:56:43 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:38636 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaHTH4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:56:40 -0400
Message-ID: <53F45482.4020505@huawei.com>
Date: Wed, 20 Aug 2014 15:55:46 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>,
        "arnab.basu@freescale.com" <arnab.basu@freescale.com>
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
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com> <c6d34fe1bbe9457ea8cff7dcd97902b8@DM2PR03MB317.namprd03.prod.outlook.com> <53DEF80C.1010608@huawei.com> <8a2b4e237f2d4c7e95ef72867658b53a@BLUPR03MB566.namprd03.prod.outlook.com> <53F44022.6030706@huawei.com> <c3b2bd89ef3d462cb302f6ede56a0d44@BLUPR03MB566.namprd03.prod.outlook.com>
In-Reply-To: <c3b2bd89ef3d462cb302f6ede56a0d44@BLUPR03MB566.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020207.53F45492.00AA,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 0933722c5f04936e103810e26ab3ed3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> We in Freescale will be using MSI for the devices behind a new-bus (which is
>> not PCI based), We have a separate bus driver for same. And this new bus driver
>> register/provide its own address/data write function which is based on that
>> specific bus protocol.
>>
>> Hi Bharat, I'm glad to know your MSI device working mode.
>> Provide the private MSI setup functions in bus-driver layer can't apply to all
>> Non-PCI MSI devices, because we can not guarantee Non-PCI MSI devices are always
>> on a bus. The existing HPET, DMAR device both have no bus bind.
> 
> Yes, that's why I was not sure of bus-driver or device-driver model.
> 
>> I'm working on a
>> new MSI setup framework, as you mentioned before, in device-driver model.
>>
>> I abstracted a new virtual device (called struct msi_dev), this msi_dev will
>> manage all MSI info,
> 
> Will this "struct msi_dev" will be part of "struct device"?

struct msi_dev contains the struct device

piece code:

struct msi_dev {
    u8 type;
    u8 enabled;
    u8 nvec;
    u8 nvec_retry;
    char *id;
    void __iomem *base;
    struct msix_entry *entries;
    struct list_head msi_list;
    struct device dev;
    void *msi_data;
    struct msi_driver *driver;
    const struct attribute_group **irq_groups;
};


struct msi_driver {
    const char *name;
    char *id;
    void (*msi_set_enable)(struct msi_dev *dev, int enable);
    int (*msi_setup_entry)(struct msi_dev *dev, struct msi_desc *entry);
    int (*msix_setup_entries)(struct msi_dev *dev, struct msi_desc *entry, int index);
    u32 (*msi_mask_irq)(struct msi_desc *desc, u32 mask, u32 flag);
    u32 (*msix_mask_irq)(struct msi_desc *desc, u32 flag);
    void (*msi_read_message)(struct msi_desc *desc, struct msi_msg *msg);
    void (*msi_write_message)(struct msi_desc *desc, struct msi_msg *msg);
    void (*msi_set_legacy_irq)(struct msi_dev *dev, int enable);
    struct device_driver driver;
};

Thanks!
Yijing.

> 
>> and a new bus named msi_bus, also introduced a new driver
>> msi_driver, msi_bus is responsible for binding msi_dev and msi_driver.
>> All MSI devices will be classified into different MSI device types, like
>> MSI_TYPE_PCI, MSI_TYPE_HPET, MSI_TYPE_DMAR, etc..
>>
>> Each MSI type device should provide a private struct msi_driver. msi_driver
>> should contain the type specific MSI ops functions to help setup and enable MSI
>> device, request MSI irq.
>>
>> I almost finish the first draft, and will post out next week in plan :)
> 
> Will be looking forward to next version.
> 
> Thanks
> -Bharat
> 
>>
>>
>> Thanks!
>> Yijing.
>>
>>>
>>> Thanks
>>> -Bharat
>>>
>>>>
>>>> My patchset is just a RFC draft, I will update it later, all we want
>>>> to do is make kernel support Non-PCI MSI devices.
>>>>
>>>> Thanks!
>>>> Yijing.
>>>>
>>>>
>>>>>
>>>>> Thanks
>>>>> Arnab
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-kernel" in the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>>
>>>>> .
>>>>>
>>>>
>>>>
>>>> --
>>>> Thanks!
>>>> Yijing
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-pci"
>>>> in the body of a message to majordomo@vger.kernel.org More majordomo
>>>> info at http://vger.kernel.org/majordomo-info.html
>>>
>>> .
>>>
>>
>>
>> --
>> Thanks!
>> Yijing
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in the body
>> of a message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
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

