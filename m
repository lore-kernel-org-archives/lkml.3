Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaKQV2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:28:21 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:55615 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaKQV2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:28:19 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411172138191.3909@nanos>
References: <1414396127-30023-1-git-send-email-wangyijing@huawei.com>
 <20141112042359.GK28161@google.com> <20141117025914.GC4280@google.com>
 <alpine.DEB.2.11.1411171035270.3909@nanos> <CAErSpo46d0OJbO6tuDUXb2q7+00BUuHzJdsCr+aOhY4we+zn=w@mail.gmail.com>
 <alpine.DEB.2.11.1411172138191.3909@nanos>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 17 Nov 2014 14:27:57 -0700
Message-ID: <CAErSpo7hH=v15w2UgG3mWc_B=YQNA-ZXj_VO_9dHZ3oFrk_yjw@mail.gmail.com>
Subject: Re: [PATCH 00/10] Save MSI chip in pci_sys_data
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 2:02 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 17 Nov 2014, Bjorn Helgaas wrote:
>> On Mon, Nov 17, 2014 at 2:38 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > The simplest way to dead with it is that I pull in pci/msi (assuming
>> > that it contains only the above) and base the rest of it on top, so I
>> > can deal with the resulting conflicts. So you still can keep that in
>> > your pile and no matter who sends the pull request first everything
>> > will just fall in place.
>>
>> In addition to the ("Save MSI chip in pci_sys_data") series, my
>> pci/msi branch contains these:
>>
>>   f83386942702 s390/MSI: Use __msi_mask_irq() instead of default_msi_mask_irq()
>>   03f56e42d03e Revert "PCI: Add x86_msi.msi_mask_irq() and msix_mask_irq()"
>>   38737d82f9f0 PCI/MSI: Add pci_msi_ignore_mask to prevent writes to
>> MSI/MSI-X Mask Bits
>>
>> but I don't think it will hurt if you pull in those as well.
>
> They are blessed by you, so I don't worry :)
>
>> The bigger problem might be the first patch of the "Save MSI chip in
>> pci_sys_data", which renames "struct msi_chip" to "struct
>> msi_controller".  I asked Yijing to do that because I didn't think
>> "_chip" really conveyed any information.  I didn't know we were going
>> to have quite this many MSI-related patches to fix up.
>
> Not a big deal at all. I pulled your branch and fixed up the pending
> mess on top of it. Not a really big deal.
>
>> So I'll just leave my pci/msi branch as-is for now.  If the rename is
>> too painful, let me know and I'll drop the branch and we can rework
>> the rest of the "Save MSI chip in pci_sys_data" series to match.
>
> No, not a problem at all. If I can carry your branch and it is
> immutable then I think we are fine.
>
> The changes we have stashed on top of this which touch linux/msi.h and
> pci/msi.c are at the end of this mail. But most of this is
> selfcontained and wont hurt anything which does not enable the
> required config options. The diffstat is:
>
>  drivers/pci/msi.c   |  334 +++++++++++++++++++++++++++++++++++++++++-----------
>  include/linux/msi.h |  158 +++++++++++++++++++++++-
>  2 files changed, 422 insertions(+), 70 deletions(-)
>
> Looks large, but it provides common infrastructure which allows ARM64
> to implement MSI support w/o any of the gazillion weak arch
> callbacks. Jiangs x86 work distangles the convoluted mess we have with
> irq remapping etc. and we can have non PCI based MSI interrupts as a
> bonus.
>
> So I'm pretty happy with the outcome now. The stacked irqdomains
> really worked out well so far. I don't think that the pci/msi.c side
> will see much updates on that in the next weeks. Though based on that
> we'll try to get rid of the whole weak arch_xxx in the long run, but
> that's a different issue and nothing we need to worry about now.
>
> I'm going to push out the current state of affairs soon and will ask
> all involved folks to have a look on that. If I don't hear someone
> crying murder I'm going to make the branch immutable and push it into
> next so that ARM and x86 can follow up with their stuff which depends
> on that whole endavour.
>
> If you have updates to your pci/msi stuff before the merge window then
> please let me know, so we can coordinate on the procedure.

Super.  Thank you very much for taking care of this; it's a big weight
off my mind.

You can add my Acked-by to these patches if you want it.  I would
suggest a minor comment expansion here, just because the code *looks
like* it's setting up something to match a hardware device:

> +/**
> + * pci_msi_domain_calc_hwirq - Generate a unique ID for an MSI source
> + * @dev:       Pointer to the PCI device
> + * @desc:      Pointer to the msi descriptor
> + *
> + * The ID number is only used within the irqdomain.

Maybe include something like:

  This "irq_hw_number_t" is an opaque identifier used only by the
irqdomain code.
  It does not correspond to any hardware implementation or register encoding.

Bjorn
