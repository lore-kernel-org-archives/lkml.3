Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaKSJVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:21:02 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33004 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbaKSJU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:20:57 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: "Yun Wu \(Abel\)" <wuyun.wu@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "grant.likely\@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback irq_chip.irq_write_msi_msg
In-Reply-To: <546C3F55.3090301@huawei.com> (Yun Wu's message of "Wed, 19 Nov
	2014 06:57:25 +0000")
Organization: ARM Ltd
References: <20141112133941.647950773@linutronix.de>
	<20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com>
	<alpine.DEB.2.11.1411181103360.3909@nanos>
	<546B4A91.6080004@huawei.com> <546B4D0D.9050601@linux.intel.com>
	<546B4F18.5060705@huawei.com> <546B51BA.6070806@linux.intel.com>
	<546B5635.6020806@huawei.com>
	<alpine.DEB.2.11.1411181526220.3909@nanos>
	<546C3F55.3090301@huawei.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
Date: Wed, 19 Nov 2014 09:20:48 +0000
Message-ID: <87ioibczrj.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19 2014 at  6:57:25 am GMT, "Yun Wu (Abel)" <wuyun.wu@huawei.com> wrote:
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

I really don't get your "generic layer" story. To me, it looks like a
glorified set of function pointers. And that's exactly what stacked
domains are giving you:

A-MSI -> ITS -> GIC

This "A-MSI" is responsible for:
- implementing the "prepare" callback, which allocates the ITT
- implementing the "irq_compose_msi_msg"

Hardly anything to change in the ITS driver, and I can probably make it
so that you don't even have to write a single line of code in the ITS
driver.

If the generic MSI layer we now have is not enough for you, then please
submit detailed use cases.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
