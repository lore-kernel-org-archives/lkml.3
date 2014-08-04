Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaHDDEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 23:04:15 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:27875 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaHDDEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 23:04:11 -0400
Message-ID: <53DEF80C.1010608@huawei.com>
Date: Mon, 4 Aug 2014 11:03:40 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "arnab.basu@freescale.com" <arnab.basu@freescale.com>
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
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com> <c6d34fe1bbe9457ea8cff7dcd97902b8@DM2PR03MB317.namprd03.prod.outlook.com>
In-Reply-To: <c6d34fe1bbe9457ea8cff7dcd97902b8@DM2PR03MB317.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.53DEF820.000F,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 0933722c5f04936e103810e26ab3ed3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> MSI was introduced in PCI Spec 2.2. Currently, kernel MSI driver codes
>> are bonding with PCI device. Because MSI has a lot advantages in design.
>> More and more non-PCI devices want to use MSI as their default interrupt.
>> The existing MSI device include HPET. HPET driver provide its own MSI
>> code to initialize and process MSI interrupts. In the latest GIC v3 spec,
>> legacy device can deliver MSI by the help of a relay device named
>> consolidator.
>> Consolidator can translate the legacy interrupts connected to it to
>> MSI/MSI-X. And new non-PCI device will be designed to support MSI in
>> future. So make the MSI driver code be generic will help the non-PCI
>> device use MSI more simply.
> 
> As per my understanding the GICv3 provides a service that will convert writes to a specified address to IRQs delivered to the core and as you mention above MSIs are part of the PCI spec. So I can see a strong case for non-PCI devices to want MSI like functionality without being fully compliant with the requirements of the MSI spec.

In GICv3, MBI is named for the service, but there is no more detailed information about it, only we can know is MBI is analogous to MSI,
MBI devices must have address/data registers, but other registers like enable/mask/ctrl are not mandatory requirement.
I don't know whether the MBI spec will be release, but anyway I think MSI refactoring is make sense, there are some existing Non-PCI MSI device like hpet, dmar.
For simplicity, let name MSI and MBI to MSI temporarily.
> 
> My question is do we necessarily want to rework so much of the PCI-MSI layer to support non PCI devices? Or will it be sufficient to create a framework to allow non PCI devices to hook up with a device that can convert their writes to an IRQ to the core.
> 
> As I understand it, the msi_chip is (almost) such a framework. The only problem being that it makes some PCI specific assumptions (such as PCI specific writes from within msi_chip functions). Won't it be sufficient to make the msi_chip framework generic enough to be used by non-PCI devices and let each bus/device manage any additional requirements (such as configuration flow, bit definitions etc) that it places on message based interrupts?

msi_chip framework is important to support that, but I think maybe it's not enough, msi_chip is only responsible for IRQ allocation, teardown, etc..

The key difference between PCI device and Non-PCI MSI is the interfaces to access hardware MSI registers.
for instance, currently, msi_chip->setup_irq() to setup MSI irq and configure the MSI address/data registers, so we need to provide device specific write_msi_msg() interface,
then when we call msi_chip->setup_irq(), the device MSI registers can be configured appropriately.

My patchset is just a RFC draft, I will update it later, all we want to do is make kernel support Non-PCI MSI devices.

Thanks!
Yijing.


> 
> Thanks
> Arnab
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

