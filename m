Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbaHAQFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:05:32 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:14085 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754615AbaHAQF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:05:27 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        "jason\@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan\@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/4 V3] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
In-Reply-To: <53DBB562.5020003@amd.com> (Suravee Suthikulanit's message of
	"Fri, 1 Aug 2014 16:42:26 +0100")
Organization: ARM Ltd
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
	<1404947104-21345-4-git-send-email-suravee.suthikulpanit@amd.com>
	<87zjfqj3mc.fsf@approximate.cambridge.arm.com>
	<53DBB562.5020003@amd.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Fri, 01 Aug 2014 17:05:14 +0100
Message-ID: <87silggpqd.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01 2014 at  4:42:26 pm BST, Suravee Suthikulanit <suravee.suthikulpanit@amd.com> wrote:
> On 7/30/2014 9:57 AM, Marc Zyngier wrote:
>> On Thu, Jul 10 2014 at 12:05:03 am BST, "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com> wrote:
>>
>> Hi Suravee,
>>
>>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>>
>  >> ......
>  >>
>>> -  first region is the GIC distributor register base and size. The 2nd region is
>>> -  the GIC cpu interface register base and size.
>>> +- reg : Specifies base physical address(s) and size of the GIC register frames.
>>> +
>>> +  Region | Description
>>> +  Index  |
>>> +  -------------------------------------------------------------------
>>> +     0   | GIC distributor register base and size
>>> +     1   | GIC cpu interface register base and size
>>> +     2   | VGIC interface control register base and size (Optional)
>>> +     3   | VGIC CPU interface register base and size (Optional)
>>> +     4   | GICv2m MSI interface register base and size (Optional)
>>
>> Given that the v2m block is somehow bolted on the side of a standard
>> GICv2, I'd rather see it as a subnode of the main GIC.
>>
>> Then you could directly call into the v2m layer to initialize it,
>> instead of the odd "reverse probing" you're using here...
>
> [Suravee] IIUC, you don't think we should introduce the "gic-400-v2m" 
> compatible ID. Instead, you want to see something like:
>
>      gic @ 0x00f00000 {
>          .....
>          v2m {
>              msi-controller;
>              reg = < .... >; /* v2m reg frame */
>          }
>      }
>
> If so, I can change this.

Yes, something like that indeed.

>
>
>>> +
>>> +static int __init
>>> +gicv2m_msi_init(struct device_node *node, struct v2m_data *v2m)
>>> +{
>>> +       unsigned int val;
>>> +
>>> +       if (of_address_to_resource(node, GIC_OF_MSIV2M_RANGE_INDEX,
>>> +                                  &v2m->res)) {
>>> +               pr_err("GICv2m: Failed locate GICv2m MSI register frame\n");
>>> +               return -EINVAL;
>>> +       }
>>> +
>>> +       v2m->base = of_iomap(node, GIC_OF_MSIV2M_RANGE_INDEX);
>>> +       if (!v2m->base) {
>>> +               pr_err("GICv2m: Failed to map GIC MSI registers\n");
>>> +               return -EINVAL;
>>> +       }
>>> +
>>> +       val = readl_relaxed(v2m->base + V2M_MSI_TYPER);
>>> +       if (!val) {
>>> +               pr_warn("GICv2m: Failed to read V2M_MSI_TYPER register\n");
>>> +               return -EINVAL;
>>> +       }
>>> +
>>> +       v2m->spi_start = (val >> V2M_MSI_TYPER_BASE_SHIFT) &
>>> +                               V2M_MSI_TYPER_BASE_MASK;
>>> +       v2m->nr_spis = val & V2M_MSI_TYPER_NUM_MASK;
>>> +       if ((v2m->spi_start < V2M_MIN_SPI) || (v2m->nr_spis >= V2M_MAX_SPI)) {
>>> +                       pr_err("GICv2m: Invalid MSI_TYPER (%#x)\n", val);
>>> +                       return -EINVAL;
>>> +       }
>>> +
>>> +       v2m->bm = kzalloc(sizeof(long) * BITS_TO_LONGS(v2m->nr_spis),
>>> +                         GFP_KERNEL);
>>> +       if (!v2m->bm) {
>>> +               pr_err("GICv2m: Failed to allocate MSI bitmap\n");
>>> +               return -ENOMEM;
>>> +       }
>>> +
>>> +       spin_lock_init(&v2m->msi_cnt_lock);
>>> +
>>> +       pr_info("GICv2m: SPI range [%d:%d]\n",
>>> +               v2m->spi_start, (v2m->spi_start + v2m->nr_spis));
>>> +
>>> +       return 0;
>>> +}
>>
>> This function is assuming that you will only see one single MSI frame
>> here. Is there any chance that there would be more than one in a system?
>>
>
> [Suravee] If I would imagine such SOC, where there are multiple MSI 
> frames (hence multiple msi-controllers), can we currently support this 
> with the current msichip interface?  Currently, each PCI RC connects to 
> an "interrupt-parrent", which is also an MSI controller. We would need 
> to have a way for PCI RC to specify which of the msichips within an 
> interrupt-controller it wants to use.

Not necessarly multiple MSI controllers. As far as I can see, a v2m MSI
frame describes a range of SPIs, and I can perfectly imagine a system
where someone would have a number of these, each capable of generating a
number of SPIs. It becomes interesting when you have non-contiguous SPI
ranges... ;-)

> Currently, I am not aware if there is a GIC w/ multiple MSI frames. 
> Could you check if there is such product for ARM GICs?

I can, but it is unlikely I'll be able to find about what people outside
of ARM are doing. They usually only get in touch when they've screwed
something up.. ;-)

Anyway, maybe we just don't need to address this at this point in
time. Adding a comment to that effect would probably be enough, and give
a hint to anyone building such a configuration.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
