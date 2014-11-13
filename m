Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbaKMLxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:53:49 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64867 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932329AbaKMLxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:53:47 -0500
Message-ID: <54649B9A.20605@arm.com>
Date: Thu, 13 Nov 2014 11:52:58 +0000
From: Andre Przywara <andre.przywara@arm.com>
Organization: ARM Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
CC: Antonios Motakis <a.motakis@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        ARM PORT <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/4] ARM: KVM: on unhandled IO mem abort, route the
 call to the KVM MMIO bus
References: <1394726249-1547-1-git-send-email-a.motakis@virtualopensystems.com> <1394726249-1547-2-git-send-email-a.motakis@virtualopensystems.com> <20140328190913.GJ25519@cbox> <CADDJ2=Opx2d5ex0hWSXYJjs6uLifR9wZVsahUHzZ7zytSj7ZSg@mail.gmail.com> <20141110162736.GA16054@cbox> <CADDJ2=PTM0fJ0RFfWdVQ1-471xqaJmj0vP1f5-pf57xOV5jgig@mail.gmail.com> <20141113112012.GO19598@cbox> <546497E4.8040100@arm.com>
In-Reply-To: <546497E4.8040100@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikolay,

On 13/11/14 11:37, Marc Zyngier wrote:
> [fixing Andre's email address]
> 
> On 13/11/14 11:20, Christoffer Dall wrote:
>> On Thu, Nov 13, 2014 at 12:45:42PM +0200, Nikolay Nikolaev wrote:
>>
>> [...]
>>
>>>>>
>>>>> Going through the vgic_handle_mmio we see that it will require large
>>>>> refactoring:
>>>>>  - there are 15 MMIO ranges for the vgic now - each should be
>>>>> registered as a separate device
>>>>>  - the handler of each range should be split into read and write
>>>>>  - all handlers take 'struct kvm_exit_mmio', and pass it to
>>>>> 'vgic_reg_access', 'mmio_data_read' and 'mmio_data_read'
>>>>>
>>>>> To sum up - if we do this refactoring of vgic's MMIO handling +
>>>>> kvm_io_bus_ API getting 'vcpu" argument we'll get a 'much' cleaner
>>>>> vgic code and as a bonus we'll get 'ioeventfd' capabilities.
>>>>>
>>>>> We have 3 questions:
>>>>>  - is the kvm_io_bus_ getting 'vcpu' argument acceptable for the other
>>>>> architectures too?
>>>>>  - is this huge vgic MMIO handling redesign acceptable/desired (it
>>>>> touches a lot of code)?
>>>>>  - is there a way that ioeventfd is accepted leaving vgic.c in it's
>>>>> current state?
>>>>>
>>>> Not sure how the latter question is relevant to this, but check with
>>>> Andre who recently looked at this as well and decided that for GICv3 the
>>>> only sane thing was to remove that comment for the gic.
>>> @Andre - what's your experience with the GICv3 and MMIO handling,
>>> anything specific?
>>>>
>>>> I don't recall the details of what you were trying to accomplish here
>>>> (it's been 8 months or so) but the surely the vgic handling code should
>>>> *somehow* be integrated into the handle_kernel_mmio (like Paolo
>>>> suggested), unless you come back and tell me that that would involve a
>>>> complete rewrite of the vgic code.
>>> I'm experimenting now - it's not exactly rewrite of whole vgic code,
>>> but it will touch a lot of it  - all MMIO access handlers and the
>>> supporting functions.
>>> We're ready to spend the effort. My question is  - is this acceptable?
>>>
>> I certainly appreciate the offer to do this work, but it's hard to say
>> at this point if it is worth it.
>>
>> What I was trying to say above is that Andre looked at this, and came to
>> the conclusion that it is not worth it.
>>
>> Marc, what are your thoughts?
> 
> Same here, I rely on Andre's view that it was not very useful. Now, it
> would be good to see a mock-up of the patches and find out:

Seconded, can you send a pointer to the VGIC rework patches mentioned?

> - if it is a major improvement for the general quality of the code
> - if that allow us to *delete* a lot of code (if it is just churn, I'm
> not really interested)
> - if it helps or hinders further developments that are currently in the
> pipeline
> 
> Andre, can you please share your findings? I don't remember the
> specifics of the discussion we had a few months ago...

1) Given the date in the reply I sense that your patches are from March
this year or earlier. So this is based on VGIC code from March, which
predates Marc's vgic_dyn changes that just went in 3.18-rc1? His patches
introduced another member to struct mmio_range to check validity of
accesses with a reduced number of SPIs supported (.bits_per_irq).
So is this covered in your rework?

2)
>>>  - there are 15 MMIO ranges for the vgic now - each should be

Well, the GICv3 emulation adds 41 new ranges. Not sure if this still fits.

>>> registered as a separate device

I found this fact a show-stopper when looking at this a month ago.
Somehow it feels wrong to register a bunch of pseudo-devices. I could go
with registering a small number of regions (one distributor, two
redistributor regions for instance), but not handling every single of
the 41 + 15 register "groups" as a device.

Also I wasn't sure if we had to expose some of the vGIC structures to
the other KVM code layers.

But I am open to any suggestions (as long as they go in _after_ my
vGICv3 series ;-)  - so looking forward to some repo to see how it looks
like.

Cheers,
Andre.
