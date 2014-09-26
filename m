Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaIZQ6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 12:58:42 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:51479 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaIZQ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:58:41 -0400
MIME-Version: 1.0
In-Reply-To: <2213339.XxHo9Gxm0z@vostro.rjw.lan>
References: <CAA9CXT07f01KW4UeoPPy4k1NM6qfxdtsOQXXSPjTKx7mG_v7Rw@mail.gmail.com>
	<30052021.2q1IqLHYpU@dtor-glaptop>
	<alpine.DEB.2.10.1409181326140.4206@nanos>
	<2213339.XxHo9Gxm0z@vostro.rjw.lan>
Date: Fri, 26 Sep 2014 09:58:39 -0700
Message-ID: <CAA9CXT0p+J2aHE0uLcHdaX5xurV-==5h_bCg--NWxRMwO2b0tA@mail.gmail.com>
Subject: Re: irq mask swapping during suspend/resume
From: Eric Caruso <ejcaruso@google.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Dmitry Torokhov <dtor@google.com>,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was putting together a prototype for this, and ran into a design
issue. It's not obvious how to get from the struct wakeup_source to
places where we hold all of the relevant device information or irq
information. If we were to walk the list of wakeup source objects,
where would we actually get the irq information to call
enable_irq_wake()?

Does this just require a bunch of extra plumbing we don't have right
now, and this is what you meant by changes to wakeup_source_create()
and friends?

On Sat, Sep 20, 2014 at 5:48 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, September 18, 2014 01:32:06 PM Thomas Gleixner wrote:
>> On Wed, 17 Sep 2014, Dmitry Torokhov wrote:
>> > Hi Thomas,
>> >
>> > On Wednesday, September 17, 2014 12:05:42 PM Thomas Gleixner wrote:
>> > > On Tue, 16 Sep 2014, Eric Caruso wrote:
>> > > > We would like to be able to set different irq masks for triggers during
>> > > > normal operation and for waking up the system. For example, while a laptop
>> > > > is awake, closing the lid and opening the lid should both fire an
>> > > > interrupt, but when the system is asleep, we would like to stay asleep
>> > > > when
>> > > > closing the lid.
>> > > >
>> > > > We are thinking about stashing the irq mask used specifically for waking
>> > > > the system up in the irq_desc struct, and then swapping it during
>> > > > enable_irq_wake and disable_irq_wake calls. Devices that do not specify a
>> > > > different wake mask will use their normal trigger mask for both
>> > > > situations.
>> > > >
>> > > > Is this acceptable?
>> > >
>> > > Not really. Why should irq_desc provide storage for random
>> > > configurations and bind them to some random system state?
>> > >
>> > > What's wrong with calling
>> > >
>> > >        irq_set_type(irq, B);
>> > >        enable_irq_wake(irq);
>> > >
>> > >        disable_irq_wake(irq);
>> > >        irq_set_type(irq, A);
>> >
>> > The desire is to avoid doing it in [every] driver but rather have it done
>> > centrally by device/PM core. It does not have to be irq_desc though,
>> > maybe you can suggest a better place for it (aside of the individual driver
>> > code that is)?
>>
>> Well, if it should be done by the device/pm core then you want to
>> store that information in the device related data structure.
>>
>> struct dev_pm_info might be the right place for it, but that's up to
>> Rafael.
>>
>> So driver would set
>>
>>    dev->power.update_wakeirq_type = true;
>>    dev->power.irq_type_normal = IRQ_TYPE_EDGE_BOTH;
>>    dev->power.irq_type_sleep = IRQ_TYPE_EDGE_LOW;
>>
>> And the dev/PM core can issue the calls on suspend/resume.
>
> So I'd rather put that into the struct wakeup_source pointed to by
> the wakeup pointer in struct dev_pm_info.  That would give us a mapping
> between wakeup source objects and wakeup interrupts and which would make
> a fair amount of sense in my view.
>
> Then, we could simply walk the list of wakeup source objects before
> suspend_device_irqs() and call enable_irq_wake() etc. for all of the
> interrupts in question without drivers having to worry about that.
> We also could save the current IRQ type for them at that point and
> restore it during resume.
>
> Of course, that would require some changes to wakeup_source_create()
> and friends, but is probably worth doing.
>
> Still, before we start making those changes, here's a bunch of questions
> to answer:
>
> (1) Say a wakeup interrupt is shared between two drivers and one of them
>     asks for a different "IRQ type for sleep" than the other one.  How are
>     we going to resolve such conflicts?
>
> (2) Can platforms place restrictions on the IRQ type to be used with a given
>     line?  If so, how do we handle situations in which the requested
>     "IRQ type for sleep" is different from what the given line can use?
>     Do we need to resolve that at the struct wakeup_source creation time or
>     can we do that later (during suspend?) and how?
>
> Rafael
>
