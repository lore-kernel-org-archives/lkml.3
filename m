Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbaKTKHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:07:43 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:34820 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140AbaKTKHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:07:39 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        "hc.yen\@mediatek.com" <hc.yen@mediatek.com>,
        "srv_heupstream\@mediatek.com" <srv_heupstream@mediatek.com>,
        "yh.chen\@mediatek.com" <yh.chen@mediatek.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely\@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh+dt@kernel.org>,
        "nathan.chung\@mediatek.com" <nathan.chung@mediatek.com>,
        "yingjoe.chen\@gmail.com" <yingjoe.chen@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "eddie.huang\@mediatek.com" <eddie.huang@mediatek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "lin ux- arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 1/4] irqchip: gic: Support hierarchy irq domain.
In-Reply-To: <546D6D62.4030005@linux.intel.com> (Jiang Liu's message of "Thu,
	20 Nov 2014 04:26:10 +0000")
Organization: ARM Ltd
References: <1416406451-4578-1-git-send-email-yingjoe.chen@mediatek.com>
	<1416406451-4578-2-git-send-email-yingjoe.chen@mediatek.com>
	<87h9xvaz2p.fsf@approximate.cambridge.arm.com>
	<546D6D62.4030005@linux.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
Date: Thu, 20 Nov 2014 10:07:21 +0000
Message-ID: <87wq6q9odi.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20 2014 at  4:26:10 am GMT, Jiang Liu <jiang.liu@linux.intel.com> wrote:

Hi Jiang,

> On 2014/11/20 1:18, Marc Zyngier wrote:
>> Hi Yingjoe,
>> 
>> On Wed, Nov 19 2014 at 2:14:08 pm GMT, Yingjoe Chen
>> <yingjoe.chen@mediatek.com> wrote:
>>> +
>>> +static const struct irq_domain_ops gic_irq_domain_hierarchy_ops = {
>>> +	.xlate = gic_irq_domain_xlate,
>>> +	.alloc = gic_irq_domain_alloc,
>>> +	.free = irq_domain_free_irqs_top,
>> 
>> I'm convinced that irq_domain_free_irqs_top is the wrong function to
>> call here, because you're calling it from the bottom, not the top-level
>> (it has no parent).
>> 
>> I cannot verify this with your code as I don't a working platform with
>> GICv2m, but if I enable something similar on GICv3, it dies a very
>> painful way:
>> 
>> Unable to handle kernel NULL pointer dereference at virtual address 00000018
>> pgd = ffffffc03d059000
>> [00000018] *pgd=0000000081356003, *pud=0000000081356003, *pmd=0000000000000000
>> Internal error: Oops: 96000006 [#1] SMP
>> Modules linked in:
>> CPU: 4 PID: 1052 Comm: sh Not tainted 3.18.0-rc4+ #3311
>> task: ffffffc03e320000 ti: ffffffc001390000 task.ti: ffffffc001390000
>> PC is at irq_domain_free_irqs_recursive+0x1c/0x80
>> LR is at irq_domain_free_irqs_common+0x88/0x9c
>> pc : [<ffffffc0000ed790>] lr : [<ffffffc0000ede20>] pstate: 60000145
>> [...]
>> [<ffffffc0000ed790>] irq_domain_free_irqs_recursive+0x1c/0x80
>> [<ffffffc0000ede1c>] irq_domain_free_irqs_common+0x84/0x9c
>> [<ffffffc0000ede98>] irq_domain_free_irqs_top+0x64/0x7c  <-- gic_domain.free()
>> [<ffffffc0000ed798>] irq_domain_free_irqs_recursive+0x24/0x80
>> [<ffffffc0000ee468>] irq_domain_free_irqs_parent+0x14/0x20
>> [<ffffffc0003500b8>] its_irq_domain_free+0xc8/0x250
>> [<ffffffc0000ed798>] irq_domain_free_irqs_recursive+0x24/0x80
>> [<ffffffc0000ede1c>] irq_domain_free_irqs_common+0x84/0x9c
>> [<ffffffc0000ede98>] irq_domain_free_irqs_top+0x64/0x7c
>> [<ffffffc0000ef518>] msi_domain_free+0x70/0x88
>> [<ffffffc0000ed798>] irq_domain_free_irqs_recursive+0x24/0x80
>> [<ffffffc0000ee3ac>] irq_domain_free_irqs+0x108/0x17c
>> [<ffffffc0000efb68>] msi_domain_free_irqs+0x28/0x4c
>> [<ffffffc000369cac>] free_msi_irqs+0xb4/0x1c0
>> [<ffffffc00036adec>] pci_disable_msix+0x3c/0x4c
>> [...]
>> 
>> and I cannot see how this could work on the standard GIC either.
>> 
>> Thomas, Jiang: could you please confirm or infirm my suspicions? My
>> understanding is that irq_domain_free_irqs_top can only be called from
>> the top-level domain.
> Hi Marc,
> 	It indicates that irq_domain_free_irqs_top() is not a good name.
> We have:
> 1) irq_domain_set_hwirq_and_chip() to set irq_chip and chip_data
> 2) irq_domain_set_info() to set irq_chip, chip_data, flow_handler and
>    handler_data;
> 3) irq_domain_reset_irq_data() resets irq_chip and chip_data.
> 4) irq_domain_free_irqs_common() resets irq_chip, chip_data and calls
>    parent domain's domain_ops.free() callback.
> 5) irq_domain_free_irqs_top() resets irq_chip, chip_data, flow handler,
>    handler_data and call parent domain's domain_ops.free() callback.

Yes, and this "call parent domain's free callback" is where the problem
lies. Here, it is called from the innermost domain, with no parent.

> So there two possible improvements here:
> 1) Rename irq_domain_free_irqs_top() with better name, any suggestions?
>    It's named as is because it's always called by the outer-most
>    irqdomains on x86.
> 2) Change irq_domain_free_irqs_common() and irq_domain_free_irqs_top()
>    to call parent domain's domain_ops.free() callback only if parent
>    exists. By this way, they could be used for inner-most irqdomains.
> If OK, I will respin a version 4 patch set based on tip/irq/irqdomain.
> Thoughts?

Checking the parent is probably a safe solution (this is not a hot path
anyway). I don't care much about the name though, and I the only thing I
can think of is irq_domain_free_irqs_reset_flow, which looks so bad it's
not even funny. I'll let the matter rest in your capable hands! ;-)

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
