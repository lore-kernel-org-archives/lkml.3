Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaLJJ1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:27:22 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:36201 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaLJJ1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:27:20 -0500
Message-ID: <548811C2.6060408@huawei.com>
Date: Wed, 10 Dec 2014 17:26:26 +0800
From: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        "Yijing Wang" <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback irq_chip.irq_write_msi_msg
References: <20141112133941.647950773@linutronix.de> <20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com> <alpine.DEB.2.11.1411181103360.3909@nanos> <546B4A91.6080004@huawei.com> <546B4D0D.9050601@linux.intel.com> <546B4F18.5060705@huawei.com> <546B51BA.6070806@linux.intel.com> <546B5635.6020806@huawei.com> <alpine.DEB.2.11.1411181526220.3909@nanos> <546C3F55.3090301@huawei.com> <87ioibczrj.fsf@approximate.cambridge.arm.com>
In-Reply-To: <87ioibczrj.fsf@approximate.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/19 17:20, Marc Zyngier wrote:

> On Wed, Nov 19 2014 at  6:57:25 am GMT, "Yun Wu (Abel)" <wuyun.wu@huawei.com> wrote:
>> On 2014/11/18 22:32, Thomas Gleixner wrote:
>>
>>> On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:
>>>
>>> Can you please trim the messages when you're replying?
>>>
>>>> The above you described is absolutely right, but not the things I want
>>>> to know. :)
>>>> Take GICv3 ITS for example, it deals with both PCI and non PCI message
>>>> interrupts. IIUC, several irq_chips need to be implemented in the ITS
>>>> driver (i.e. pci_msi_chip, A_msi_chip and B_msi_chip). What should we
>>>> do to the ITS driver if new MSI-capable devices come out?
>>>
>>> You seem to miss the stacking here
>>>
>>> PCI-MSI	->
>>> A-MSI	->   ITS  -> GIC
>>> B-MSI	->
>>>
>>> So each of the device types has its own MSI controller. Each of them
>>> will have their own callbacks and are backed by the underlying ITS/GIC
>>> implementation.
>>
>> Yes, this hits the key point. Once a new device type becomes available,
>> we need to add pieces of code outside the new device's driver to make
>> it work, which in my opinion is due to lack of core infrastructure.
>> More specifically, the core infrastructure needs to support mechanism
>> of MSI, not the various types of devices.
>>
>>>
>>> And that's the only sensible solution.
>>>
>>
>> It's sensible, but not perfect.
>> What I suggested is to add a generic layer:
>>
>> PCI-MSI	->
>> A-MSI	-> (generic layer) -> ITS -> GICR
>> B-MSI	->
>>
>> The PCI/A/B/... passes its hardware properties to the generic layer which
>> gets configurations ready by calling ITS's domain/chip callbacks. When
>> a new device type arrives, the only thing need to do is to implement the
>> driver of that device, with nothing to do with the generic layer or ITS.
> 
> I really don't get your "generic layer" story. To me, it looks like a
> glorified set of function pointers. And that's exactly what stacked
> domains are giving you:
> 
> A-MSI -> ITS -> GIC
> 
> This "A-MSI" is responsible for:
> - implementing the "prepare" callback, which allocates the ITT
> - implementing the "irq_compose_msi_msg"
> 
> Hardly anything to change in the ITS driver, and I can probably make it
> so that you don't even have to write a single line of code in the ITS
> driver.
> 
> If the generic MSI layer we now have is not enough for you, then please
> submit detailed use cases.
> 

Hi Marc,

As I said, I never thought Gerry's patch don't work, I am just trying to
make it better. :)

As to the "generic layer" story, please check the following URL:
https://lkml.org/lkml/2014/12/10/93

Thanks,
	Abel

