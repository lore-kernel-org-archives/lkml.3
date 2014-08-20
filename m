Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaHTGaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:30:03 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:2636 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHTGaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:30:00 -0400
Message-ID: <53F44022.6030706@huawei.com>
Date: Wed, 20 Aug 2014 14:28:50 +0800
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
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com> <c6d34fe1bbe9457ea8cff7dcd97902b8@DM2PR03MB317.namprd03.prod.outlook.com> <53DEF80C.1010608@huawei.com> <8a2b4e237f2d4c7e95ef72867658b53a@BLUPR03MB566.namprd03.prod.outlook.com>
In-Reply-To: <8a2b4e237f2d4c7e95ef72867658b53a@BLUPR03MB566.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The key difference between PCI device and Non-PCI MSI is the interfaces to
>> access hardware MSI registers.
>> for instance, currently, msi_chip->setup_irq() to setup MSI irq and configure
>> the MSI address/data registers, so we need to provide device specific
>> write_msi_msg() interface, then when we call msi_chip->setup_irq(), the device
>> MSI registers can be configured appropriately.
> 
> What if we can register/override the setup_irq() from bus-driver (not sure, but may be device-driver itself). Example PCI bus-driver will provide setup_irq() (or the part of setup_irq which set address and data in h/w) by PCI bus, which configure address/data in h/w as per PCI standard. 
> 
> We in Freescale will be using MSI for the devices behind a new-bus (which is not PCI based), We have a separate bus driver for same. And this new bus driver register/provide its own address/data write function which is based on that specific bus protocol.

Hi Bharat, I'm glad to know your MSI device working mode.
Provide the private MSI setup functions in bus-driver layer can't apply to all Non-PCI MSI devices,
because we can not guarantee Non-PCI MSI devices are always on a bus. The existing HPET, DMAR device both
have no bus bind. I'm working on a new MSI setup framework, as you mentioned before, in device-driver model.

I abstracted a new virtual device (called struct msi_dev), this msi_dev will manage all MSI info, and a new bus
named msi_bus, also introduced a new driver msi_driver, msi_bus is responsible for binding msi_dev and msi_driver.
All MSI devices will be classified into different MSI device types, like MSI_TYPE_PCI, MSI_TYPE_HPET, MSI_TYPE_DMAR, etc..

Each MSI type device should provide a private struct msi_driver. msi_driver should contain the type specific
MSI ops functions to help setup and enable MSI device, request MSI irq.

I almost finish the first draft, and will post out next week in plan :)


Thanks!
Yijing.

> 
> Thanks
> -Bharat
> 
>>
>> My patchset is just a RFC draft, I will update it later, all we want to do is
>> make kernel support Non-PCI MSI devices.
>>
>> Thanks!
>> Yijing.
>>
>>
>>>
>>> Thanks
>>> Arnab
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-kernel" in the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
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
> 
> .
> 


-- 
Thanks!
Yijing

