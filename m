Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423225Ab3FUQQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:16:24 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:34431 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423018Ab3FUQQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:16:22 -0400
Message-ID: <51C47C50.8000606@itdev.co.uk>
Date: Fri, 21 Jun 2013 09:16:16 -0700
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
References: <20130606131638.GX31367@sirena.org.uk> <51B0B52C.1090807@itdev.co.uk> <20130606164629.GG31367@sirena.org.uk> <51B1F859.1010504@itdev.co.uk> <20130607154134.GU31367@sirena.org.uk> <51B20630.7000304@itdev.co.uk> <20130607164700.GW31367@sirena.org.uk> <51B6FE69.6060505@itdev.co.uk> <20130611114727.GY1403@sirena.org.uk> <51B7151F.5070307@itdev.co.uk> <20130619185909.GG1403@sirena.org.uk>
In-Reply-To: <20130619185909.GG1403@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
>> Is that a nicer design from your point of view? I don't personally think
>> that is really gains anything functional other than making the API more
>> complex and increasing the number of read/write operations. I guess you
> 
> Yes, to be honest.  I'd hope it wouldn't be increasing the number of
> read/write operations...

For some operations it does. For example updating the whole chip config
(which is a common thing to want to do), it would turn a couple of write
operations into ~20 on recent chips.

>> would stop bugs in user space code from accidentally writing into the wrong
>> object.
> 
> That seems like a useful thing, and it does allow the driver to
> relatively easily understand what any of the attributes is doing and
> take it over if it needs to.

I guess you might save a tiny amount of lookup code.

>>> Well, there's also the potential issues with standard application layer
>>> code either not being able to do things that the hardware supports or
>>> getting into a fight with the magic custom stuff.
> 
>> I think it's better to present a clean API cut at the right level. If you
>> look at the drivers in various Android trees for these maXTouch chips,
>> there's an awful lot of phone specific code which is not very general and
>> it would be impossible to mainline without having a 20,000 line driver full
>> of #ifdefs. Surely it's better for that to go into a userspace daemon if
>> possible?
> 
> Yes, having some of the stuff that understands the contents of the
> controls in userspace is sensible.  However the kernel does offer an API
> for controlling devices it supports and it seems reasonable to expect
> that to work too - callibration and whatnot is a bit different but core
> functionality should just work from the kernel.

I completely agree - I just don't think that the API under discussion
really forces a choice over any of this.

Anyway, I will pull this patch (and the other sysfs interface one) from the
series, and try to come up with something along the lines that we have
discussed.

>> In the reference design for that particular model of chip (mXT1386), there
>> is a WAKEUP pin cross-wired to an I2C line. The only way of getting it to
>> wake up when it is asleep is by trying to perform an I2C operation, which
>> will fail, and then retrying before it times out and goes back to sleep
>> again. There isn't any other way of waking it up.
> 
> That still sounds like something the driver can handle (for example, by
> eating the first error silently if it knows the chip is powered down)

We've tried to implement this idea of tracking the chip power state in
the driver and only eating the first error silently when necessary. But
there are various entertaining corner cases (for example, it may or may
not be in sleep on probe, how do you deal with intermittent i2c glitch). It
would end up either being very brittle or an extremely complex mechanism
involving tracking state and timers, the result of which is only to
suppress a dmesg debug output saying "i2c retry", and to fail very slightly
earlier in the normal i2c failure case. The normal fast path through
this code is exactly the same.

> and of course a system integrator may choose not to copy the reference
> design in this respect, it does seem a bit odd after all.

You're being a bit optimistic there. Examples of devices that require
this are Samsung Galaxy Tab 10.1, Asus Transformer TF101.
