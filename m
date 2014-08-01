Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbaHAT3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 15:29:54 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:37335 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbaHAT3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 15:29:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+47YtqWwOkxYDzaEOG-+oouvpXvmGaX+Wh3wQ+BNAx_w@mail.gmail.com>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
 <1405976886-27807-2-git-send-email-computersforpeace@gmail.com>
 <CAL_Jsq+Nbk7m9KXhG+Chdpvurp75RrvhFR2oE_LGxV444GSe9Q@mail.gmail.com>
 <20140731022320.GM3711@ld-irv-0074> <CAL_Jsq+47YtqWwOkxYDzaEOG-+oouvpXvmGaX+Wh3wQ+BNAx_w@mail.gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 1 Aug 2014 12:29:11 -0700
Message-ID: <CAGVrzcaEV81BW+a--QgQSHiLb6UQDFsP3cqQxGwV206MRx4gXw@mail.gmail.com>
Subject: Re: [PATCH v8 01/11] ARM: brcmstb: add infrastructure for ARM-based
 Broadcom STB SoCs
To: Rob Herring <robherring2@gmail.com>
Cc: Brian Norris <computersforpeace@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2014-08-01 7:33 GMT-07:00 Rob Herring <robherring2@gmail.com>:
> On Wed, Jul 30, 2014 at 9:23 PM, Brian Norris
> <computersforpeace@gmail.com> wrote:
>> Hi Rob,
>>
>> I appreciate your comments, but where were many of these 5 months ago on
>> the first 7 revisions? :)
>
> Sorry, but that is the nature of upstreaming. But given some of the
> issues, it is obvious the reviews were not sufficient.
>
>> On a practical note: v9 is already queued for 3.17. Should I send
>> patches for the 3.17 cycle (or later) to fixup some of these issues? Or
>> would you recommend pulling the patches out of Matt Porter's tree now,
>> and reintroducing for 3.18? (I would be much happier with the first.)
>
> Things can always be un-queued. I guess that's Matt's and arm-soc's decision.

Does that mean we should get all those patches un-queued, because that
specific patch adding SMP support that needs to be reworked, or does
that mean that if we drop this specific patch we are good with the
remainder of the patch series?

>
>>> > +static const char *brcmstb_match[] __initconst = {
>>> > +       "brcm,bcm7445",
>>> > +       "brcm,brcmstb",
>>> > +       NULL
>>> > +};
>>> > +
>>> > +DT_MACHINE_START(BRCMSTB, "Broadcom STB (Flattened Device Tree)")
>>> > +       .dt_compat      = brcmstb_match,
>>> > +MACHINE_END
>>>
>>> Do you plan to add more here? Otherwise you don't need this file.
>>
>> Probably eventually, but not yet (there's out-of-tree stuff that hasn't
>> been integrated); should we drop the file until it's needed?
>
> I would say yes if you re-spin the patches.
>
>>> > +ENTRY(brcmstb_secondary_startup)
>>> > +        /*
>>> > +         * Ensure CPU is in a sane state by disabling all IRQs and switching
>>> > +         * into SVC mode.
>>> > +         */
>>> > +        setmode        PSR_I_BIT | PSR_F_BIT | SVC_MODE, r0
>>> > +
>>> > +        bl      v7_invalidate_l1
>>>
>>> This should be in your boot code. That is part of the documented entry
>>> requirements.
>>
>> By "documented" are you referring to the ARM TRM? Wouldn't any "boot
>> code" requirements only apply to CPU0? Linux prepares the non-boot CPUs
>> for SMP, as you see here.
>>
>>> Also, if you are coming straight from reset, there is
>>> other setup probably missing.
>>
>> Like what?
>
> Errata work-arounds, performance bits, etc. I don't recall exactly
> which ones are per core vs. global. I assume this is an A9, but cores
> with virt extensions would also need to drop to non-secure mode.

This is a Brahma B15 CPU, maybe we should have mentioned that again in
this specific patch. The only ARM erratum we are affected (as of
today) is 798181, and it requires a one-time initialization.

>
> Also, your entry (and many of the custom entry points) would not work
> for big endian kernels. You may not care, but there's really no reason
> why it should not work.

I don't think we want to support big-endian kernels at all, although I
can't see a good way to enforce that restriction.

>
>>> > +       per_cpu(per_cpu_sw_state, cpu) = val;
>>> > +       dmb();
>>> > +       sync_cache_w(SHIFT_PERCPU_PTR(&per_cpu_sw_state, per_cpu_offset(cpu)));
>>> > +       dsb_sev();
>>>
>>> Barriers need to be documented why they are needed.
>>
>> (NB: I see approximately 3 total existing cases where there is a comment
>> near a dsb()/dsb_sev().)
>>
>> This was actually adapted from the mcpm code, and
>
> Why? Blindly copying other implementations seems to be a common issue here...
>
>> (1) I think the dmb() is in the wrong place (it should be the first
>>     thing in this function);
>> (2) the SEV is unnecessary (we don't use WFE; just a cache-invalidated
>>     polling loop); and
>> (3) the DSB is also unnecessary, since sync_cache_w() handles its own
>>     barriers.
>>
>> Plus, we should probably add some comments to describe what's going on
>> here. (Follow-up patch?)
>
> I'm not sure you need the state variable at all. You appear to be able
> to fully control power on and off of the cores, so you should not need
> any spin loops or synchronization.
>
>>> > +static int brcmstb_cpu_kill(u32 cpu)
>>> > +{
>>> > +       u32 tmp;
>>> > +
>>> > +       pr_info("SMP: Powering down CPU%d...\n", cpu);
>>> > +
>>> > +       while (per_cpu_sw_state_rd(cpu))
>>> > +               ;
>>>
>>> I don't think this is necessary. You don't need to synchronize die and
>>> kill. Look at other implementations that actually power down the core
>>> (vs. just wfi).
>>
>> Hmm, I'm pretty sure the synchronization is required for our B15 core.
>> If we yank the power before the core has properly quiesced, the whole
>> CPU complex will lock up. (Similar story for the power-up while loop you
>> complained about above.)
>
> That is true for every SMP system which is why it is done in the core
> code as Russell pointed out.
>
>>> > +static void brcmstb_secondary_init(unsigned int cpu)
>>> > +{
>>> > +       /*
>>> > +        * Synchronise with the boot thread.
>>> > +        */
>>> > +       spin_lock(&boot_lock);
>>> > +       spin_unlock(&boot_lock);
>>>
>>> I suggest you read previous discussions on attempts to make this
>>> common before replying to Russell.
>>
>> Can you point me to this discussion? linux-arm-kernel is a big and noisy
>> world...
>
> Here's a recent example:
>
> http://www.spinics.net/lists/arm-kernel/msg318585.html
>
>> BTW, I'm not sure the boot_lock is actually necessary at all for us; it
>> was just borrowed from one of the other mach-*'s. The synchronization we
>> need is done in the while loops above.
>
> The blindly copying code without knowing what it does problem...
-- 
Florian
