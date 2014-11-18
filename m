Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbaKRROY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:14:24 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60514 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbaKRROW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:14:22 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: "Yun Wu \(Abel\)" <wuyun.wu@huawei.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "grant.likely\@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback irq_chip.irq_write_msi_msg
In-Reply-To: <546B5BAA.9090905@huawei.com> (Yun Wu's message of "Tue, 18 Nov
	2014 14:46:02 +0000")
Organization: ARM Ltd
References: <20141112133941.647950773@linutronix.de>
	<20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com>
	<alpine.DEB.2.11.1411181103360.3909@nanos>
	<546B4A91.6080004@huawei.com> <546B4D0D.9050601@linux.intel.com>
	<546B4F18.5060705@huawei.com> <546B51BA.6070806@linux.intel.com>
	<546B5635.6020806@huawei.com> <546B57E4.9040804@linux.intel.com>
	<546B5BAA.9090905@huawei.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
Date: Tue, 18 Nov 2014 17:14:03 +0000
Message-ID: <87a93oe8is.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18 2014 at  2:46:02 pm GMT, "Yun Wu (Abel)" <wuyun.wu@huawei.com> wrote:
> On 2014/11/18 22:29, Jiang Liu wrote:
>
>> 
>> 
>> On 2014/11/18 22:22, Yun Wu (Abel) wrote:
>>> On 2014/11/18 22:03, Jiang Liu wrote:
>>>
>>>> On 2014/11/18 21:52, Yun Wu (Abel) wrote:
>>>>> On 2014/11/18 21:43, Jiang Liu wrote:
>>>>>
>>>>>> On 2014/11/18 21:33, Yun Wu (Abel) wrote:
>>>>>>> On 2014/11/18 18:19, Thomas Gleixner wrote:
>>>>>>>
>>>>>>>> On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:
>>>>>>>>> On 2014/11/12 21:43, Thomas Gleixner wrote:
>>>>>>>>>>  struct irq_chip {
>>>>>>>>>> @@ -359,6 +360,7 @@ struct irq_chip {
>>>>>>>>>>  	void		(*irq_release_resources)(struct irq_data *data);
>>>>>>>>>>  
>>>>>>>>>>  	void		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
>>>>>>>>>> +	void		(*irq_write_msi_msg)(struct irq_data *data, struct msi_msg *msg);
>>>>>>>>>
>>>>>>>>> Hmm... It's really weird.
>>>>>>>>> I don't think it's the interrupt controllers' responsibility
>>>>>>>>> to write messages
>>>>>>>>> for all the endpoint devices since the methods of configuring
>>>>>>>>> message registers
>>>>>>>>> may different between these devices. And theoretically, the
>>>>>>>>> endpoint devices
>>>>>>>>> themselves should take the responsibility to configure their
>>>>>>>>> message registers.
>>>>>>>>> To say the least, the write_msg callback here still need to
>>>>>>>>> call some certain
>>>>>>>>> interfaces provided by the corresponding device.
>>>>>>>>>
>>>>>>>>> There would be lots of ARM new devices capable of sending message
>>>>>>>>> based interrupts to interrupt controllers, does all the drivers of
>>>>>>>>> the devices need to expose a write_msg callback to interrupt
>>>>>>>>> controllers?
>>>>>>>>
>>>>>>>> Well, writing the message _IS_ part of the interrupt controller.
>>>>>>>>
>>>>>>>> So in order to enable non PCI based MSI we want to have generic
>>>>>>>> infrastructure with minimal per device/device class callbacks and of
>>>>>>>> course you need to provide that callback for your special device.
>>>>>>>>
>>>>>>>> We already have non PCI based MSI controllers in x86 today and we need
>>>>>>>> to handle the whole stuff with tons of copied coded extra for each of
>>>>>>>> those. So consolidating it into common infrastructure allows us to get
>>>>>>>> rid of the pointless copied code and reduce the per device effort to
>>>>>>>> the relevant hardware specific callbacks. irq_write_msi_msg being one
>>>>>>>> of those.
>>>>>>>>
>>>>>>>
>>>>>>> At least, we have the same goal.
>>>>>>> I will illustrate my thoughts by an example.
>>>>>>> The current code is something like:
>>>>>>>
>>>>>>> Device A
>>>>>>> ========
>>>>>>> void A_write_msg() { ... }
>>>>>>>
>>>>>>> Group B
>>>>>>> (a group of devices behave same on writing messages, i.e. PCI)
>>>>>>> =======
>>>>>>> void B_write_msg() { ... }
>>>>>>>
>>>>>>> Controller
>>>>>>> ==========
>>>>>>> irq_chip.irq_write_msi_msg () {
>>>>>>> 	if (A)
>>>>>>> 		A_write_msg();
>>>>>>> 	if (B)
>>>>>>> 		B_write_msg();
>>>>>>> }
>>>>>>>
>>>>>>> It's horrible when new devices come out, since we need to modify the
>>>>>>> controller part for each new device.
>>>>>>> What I suggested is:
>>>>>>>
>>>>>>> MSI Core
>>>>>>> ========
>>>>>>> struct msi_ops { .write_msg, };
>>>>>>> struct msi_desc { .msi_ops, };
>>>>>>>
>>>>>>> write_msg() {
>>>>>>> 	X = get_dev();
>>>>>>> 	irq_chip.compose_msg(X);	// IRQ chips' responsibility
>>>>>>> 	X_msi_ops.write_msg();		// nothing to do with IRQ chips
>>>>>>> }
>>>>>>>
>>>>>>> Device A
>>>>>>> ========
>>>>>>> void A_write_msg() { ... }
>>>>>>> A_msi_ops.write_msg = A_write_msg;
>>>>>>>
>>>>>>> Group B
>>>>>>> =======
>>>>>>> void B_write_msg() { ... }
>>>>>>> B_msi_ops.write_msg = B_write_msg;
>>>>>>>
>>>>>>> Please correct me if I misunderstood anything.
>>>>>> Hi Yun,
>>>>>> 	We provide an irq_chip for each type of interrupt controller
>>>>>> instead of devices. For the example mentioned above, if device A
>>>>>> and Group B has different interrupt controllers, we just need to
>>>>>> implement irq_chip_A and irq_chip_B and set irq_chip.irq_write_msi_msg()
>>>>>> to suitable callbacks.
>>>>>> 	The framework already achieves what you you want:)
>>>>>
>>>>> What if device A and group B have the same interrupt controller?
>>>> Device doesn't care about interrupt controllers, it just cares about
>>>> interrupts used by itself. It's the interrupt source (controller)
>>>> enumerators' responsibility to discover interrupt source, associate
>>>> methods to control the interrupt source and assign irq numbers for
>>>> interrupt sources.
>>>
>>> Yes, indeed.
>>>
>>>> There are two ways to associate irq numbers with device:
>>>> 1) arch code/bus drivers statically assigns irq number for devices
>>>>    when creating device objects, such as PCI legacy interrupt
>>>>    (INTA-INTD), IOAPIC interrupts.
>>>
>>> And OF interfaces.
>>>
>>>> 2) device drivers ask interrupt source enumerators to dynamically
>>>>    create irq numbers, such pci_enable_msix_range() and friends.
>>>> So device driver definitely doesn't need to known about irq_chip
>>>> methods to control interrupt sources.
>>>>
>>>
>>> The above you described is absolutely right, but not the things I want
>>> to know. :)
>>> Take GICv3 ITS for example, it deals with both PCI and non PCI message
>>> interrupts. IIUC, several irq_chips need to be implemented in the ITS
>>> driver (i.e. pci_msi_chip, A_msi_chip and B_msi_chip). What should we
>>> do to the ITS driver if new MSI-capable devices come out?
>> Marc has posted a patchset to enable ITS based on the hierarchy
>> irqdomain framework, please refer to "[PATCH 00/15] arm64: PCI/MSI:
>> GICv3 ITS support (stacked domain edition)" at
>> https://lkml.org/lkml/2014/11/11/620
>> 
>
> IIUC, Marc's patch now only supports PCI MSI/MSI-X...

Indeed, and the current solution makes is relatively easy to plug in
non-PCI MSI. Just don't plug the ITS into the *PCI* MSI framework when
you encounter such a thing.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
