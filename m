Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaKCORy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:17:54 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:53166 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaKCORw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:17:52 -0500
Date: Mon, 3 Nov 2014 14:17:40 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Bastien Nocera <hadess@hadess.net>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141103141740.2d913583@alan.etchedpixels.co.uk>
In-Reply-To: <1414764218.2406.76.camel@hadess.net>
References: <1413881397.30379.7.camel@hadess.net>
	<CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	<1413911644.30379.12.camel@hadess.net>
	<CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
	<1413914978.30379.14.camel@hadess.net>
	<CALAqxLX2Q-2RBF1zY6JAWrqNiqBFG3vxUwUSLVS3qXpgSOb9xA@mail.gmail.com>
	<1414419579.30379.49.camel@hadess.net>
	<CALAqxLXyaL55JuDuHAcWX0PEdem-jpVxK0rbJaNrBbBJ3rQY5Q@mail.gmail.com>
	<20141028225740.2cd0ea5f@alan.etchedpixels.co.uk>
	<1414680060.2406.51.camel@hadess.net>
	<20141030233906.6647d005@alan.etchedpixels.co.uk>
	<1414764218.2406.76.camel@hadess.net>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It's a reasonable ask but answers even if available are likely
> > to be things like "because GPE36" and GPE36 will just be some connection
> > to something that could be anything from a lid switch to a light sensor
> > or even a smart wifi chip deciding it wants the CPU to help out because
> > you are out of range of the base station. We may not even know what it
> > relates to.
> 
> But the device or platform driver would know that, presumably.

Quite often it has no idea - maybe the firmware knows but it isn't
telling us. It's an internal detail.
> 
> > A non suspend system will exit deep idle type status because they got
> > an IRQ or perhaps some DMA needed the cache coherency. That doesn't mean
> > they've got the foggiest which IRQ kicked them out if idle, just that hey
> > I'm awake and there are four pending interrupts. That of course is
> > assuming it even noticed it entered a deep idle state - you don't want to
> > wake an idle CPU to tell it that its more idle than it was before.
> 
> Sure, the CPU might not be the best example of a device for which we
> need to track the wakeup reason. The device drivers however...

You keep assuming a wakeup is "special" - it's quite possibly not. The
RTC driver knows whether an alarm went off, it's got no idea if that
cause a wakeup or even what a wake up is or if the platform has wakeups
or just deep sleeps.

Same for most other stuff - plugging in a display may well bump a machine
out of deep sleep but the graphics driver isn't going to know anything
other than "I'm handling a cable change".

Events can also be processed entirely by firmware so we just wake up, look
round, scratch out head and go back to sleep.

So I really think "why did I wake up" is actually the wrong question to
be asking.

What you probably should be asking (and what the kernel effectively asks)
is "Why am I not idle ?". That plus "what state changes have occurred
that I care about". Both of those are questions you can ask at any time
without caring how sleeping may or may not happen.

ie you don't care if a lid event woke you, you care if the lid is open or
shut. You don't care whether a wireless event woke you, you care that the
wireless has been lost etc..

Ie instead of doing

	if (woken && cause == BATTERY_LOW)
		suspend_to_disk()

you want to be doing (as part of the normal flow)

	if (battery < BATTERY_LOW && battery_prev >= BATTERY_LOW +
						HYSTERISIS)
		suspend_to_disk();

because it's kind of irrelevant whether it woke you for this, you need to
do it anyway.

Alan
