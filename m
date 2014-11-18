Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaKRNdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:33:35 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:38693 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbaKRNde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:33:34 -0500
Message-ID: <546B4A91.6080004@huawei.com>
Date: Tue, 18 Nov 2014 21:33:05 +0800
From: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback irq_chip.irq_write_msi_msg
References: <20141112133941.647950773@linutronix.de> <20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com> <alpine.DEB.2.11.1411181103360.3909@nanos>
In-Reply-To: <alpine.DEB.2.11.1411181103360.3909@nanos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 18:19, Thomas Gleixner wrote:

> On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:
>> On 2014/11/12 21:43, Thomas Gleixner wrote:
>>>  struct irq_chip {
>>> @@ -359,6 +360,7 @@ struct irq_chip {
>>>  	void		(*irq_release_resources)(struct irq_data *data);
>>>  
>>>  	void		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
>>> +	void		(*irq_write_msi_msg)(struct irq_data *data, struct msi_msg *msg);
>>
>> Hmm... It's really weird.
>> I don't think it's the interrupt controllers' responsibility to write messages
>> for all the endpoint devices since the methods of configuring message registers
>> may different between these devices. And theoretically, the endpoint devices
>> themselves should take the responsibility to configure their message registers.
>> To say the least, the write_msg callback here still need to call some certain
>> interfaces provided by the corresponding device.
>>
>> There would be lots of ARM new devices capable of sending message
>> based interrupts to interrupt controllers, does all the drivers of
>> the devices need to expose a write_msg callback to interrupt
>> controllers?
> 
> Well, writing the message _IS_ part of the interrupt controller.
> 
> So in order to enable non PCI based MSI we want to have generic
> infrastructure with minimal per device/device class callbacks and of
> course you need to provide that callback for your special device.
> 
> We already have non PCI based MSI controllers in x86 today and we need
> to handle the whole stuff with tons of copied coded extra for each of
> those. So consolidating it into common infrastructure allows us to get
> rid of the pointless copied code and reduce the per device effort to
> the relevant hardware specific callbacks. irq_write_msi_msg being one
> of those.
> 

At least, we have the same goal.
I will illustrate my thoughts by an example.
The current code is something like:

Device A
========
void A_write_msg() { ... }

Group B
(a group of devices behave same on writing messages, i.e. PCI)
=======
void B_write_msg() { ... }

Controller
==========
irq_chip.irq_write_msi_msg () {
	if (A)
		A_write_msg();
	if (B)
		B_write_msg();
}

It's horrible when new devices come out, since we need to modify the
controller part for each new device.
What I suggested is:

MSI Core
========
struct msi_ops { .write_msg, };
struct msi_desc { .msi_ops, };

write_msg() {
	X = get_dev();
	irq_chip.compose_msg(X);	// IRQ chips' responsibility
	X_msi_ops.write_msg();		// nothing to do with IRQ chips
}

Device A
========
void A_write_msg() { ... }
A_msi_ops.write_msg = A_write_msg;

Group B
=======
void B_write_msg() { ... }
B_msi_ops.write_msg = B_write_msg;

Please correct me if I misunderstood anything.

Thanks,
	Abel

