Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaKSICk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:02:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:52065 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbaKSICj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:02:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,415,1413270000"; 
   d="scan'208";a="639535363"
Message-ID: <546C4E99.2030502@linux.intel.com>
Date: Wed, 19 Nov 2014 16:02:33 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback irq_chip.irq_write_msi_msg
References: <20141112133941.647950773@linutronix.de> <20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com> <alpine.DEB.2.11.1411181103360.3909@nanos> <546B4A91.6080004@huawei.com> <546B4D0D.9050601@linux.intel.com> <546B4F18.5060705@huawei.com> <546B51BA.6070806@linux.intel.com> <546B5635.6020806@huawei.com> <alpine.DEB.2.11.1411181526220.3909@nanos> <546C3F55.3090301@huawei.com>
In-Reply-To: <546C3F55.3090301@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/19 14:57, Yun Wu (Abel) wrote:
> On 2014/11/18 22:32, Thomas Gleixner wrote:
> 
>> On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:
>>
>> Can you please trim the messages when you're replying?
>>
>>> The above you described is absolutely right, but not the things I want
>>> to know. :)
>>> Take GICv3 ITS for example, it deals with both PCI and non PCI message
>>> interrupts. IIUC, several irq_chips need to be implemented in the ITS
>>> driver (i.e. pci_msi_chip, A_msi_chip and B_msi_chip). What should we
>>> do to the ITS driver if new MSI-capable devices come out?
>>
>> You seem to miss the stacking here
>>
>> PCI-MSI	->
>> A-MSI	->   ITS  -> GIC
>> B-MSI	->
>>
>> So each of the device types has its own MSI controller. Each of them
>> will have their own callbacks and are backed by the underlying ITS/GIC
>> implementation.
> 
> Yes, this hits the key point. Once a new device type becomes available,
> we need to add pieces of code outside the new device's driver to make
> it work, which in my opinion is due to lack of core infrastructure.
> More specifically, the core infrastructure needs to support mechanism
> of MSI, not the various types of devices.
It depends on the implementation details whether we need to change ITS
to support new devices. One possible way to avoid changing ITS to
support new devices is:
1) ITS only allocates and manages interrupt translation tables and pass
   some type of identifier back to MSI controller drivers.
2) Each MSI controller driver implements its own compose_msi_msg()
   and write_msi_msg() according to hardware specifications.
By this way, there is no need to change ITS to support new types of
MSI controllers.

On x86 systems, interrupt remapping is optional and we also want to hide
implementation details, so we chose another solution:
1) interrupt remapping driver allocates and manages remapping resources,
   it also implements different compose_msi_msg() to support different
   MSI controllers.
2) MSI controller implement write_msi_msg(), it also implements
   compose_msi_msg() if interrupt remapping is disabled.
By this way, we do need to change interrupt remapping driver(ITS on ARM)
to support new type of MSI controllers.

So it totally depends on how you implement the hierarchy irqdomain,
there are no limitations from the framework side.

For the proposal to add some type of ops structure into struct msi_desc,
actually I have a serial of patches to support device specific
mask/unmask/write/compose/startup/shutdown operations by adding
msi_desc.chip_ops. But there's no actual users of those interfaces
currently and we don't want to over-engineering, so I abandoned
that patch set. I may rework on it  when enabling generic MSI
support later.
Regards!
Gerry
> 
>>
>> And that's the only sensible solution.
>>
> 
> It's sensible, but not perfect.
> What I suggested is to add a generic layer:
> 
> PCI-MSI	->
> A-MSI	-> (generic layer) -> ITS -> GICR
> B-MSI	->
> 
> The PCI/A/B/... passes its hardware properties to the generic layer which
> gets configurations ready by calling ITS's domain/chip callbacks. When
> a new device type arrives, the only thing need to do is to implement the
> driver of that device, with nothing to do with the generic layer or ITS.
> 
> Thanks,
> 	Abel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
