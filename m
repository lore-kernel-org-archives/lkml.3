Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaB0QVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:21:11 -0500
Received: from 2.mo3.mail-out.ovh.net ([46.105.75.36]:53021 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753076AbaB0QVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:21:08 -0500
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2014 11:21:08 EST
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402262119560.4174@ionos.tec.linutronix.de>
References: <1393345719-3707-1-git-send-email-jjhiblot@traphandler.com>
	<alpine.DEB.2.02.1402262119560.4174@ionos.tec.linutronix.de>
Date: Thu, 27 Feb 2014 17:03:47 +0100
Message-ID: <CACh+v5Nkuct0J65OHcnSd6Dfq4EyfafY8RpTvdwKXUA7A8_+Xw@mail.gmail.com>
Subject: Re: [PATCH] irq: Consider a negative return value of irq_startup() as
 an error
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 7043348343423850520
X-Ovh-Remote: 209.85.192.172 (mail-pd0-f172.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-26 23:15 GMT+01:00 Thomas Gleixner <tglx@linutronix.de>:
> On Tue, 25 Feb 2014, Jean-Jacques Hiblot wrote:
>
>> The irq_startup() function returns the return value of the
>> irq_startup callback of the underlying irq_chip. Currently this
>> value only tells if the interrupt is pending, but we can make it
>> also return an error code when it fails.
>>
>> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>> ---
>>
>> Hi Thomas,
>>
>> This patch updates the semantic of the return value of the irq_startup()
>> callback of an irq_chip : a negative value indicates an error. The purpose is
>> to make __setup_irq() fail if the irq_chip can't startup the interrupt.
>
> How does that work?
>
>     unsigned int    (*irq_startup)(struct irq_data *data);
well .. no excuse sir
>
>> I checked in the kernel for drivers impacted by this. It turns out that most
>> of the implementation of irq_startup() return 0. The only drivers that return
>> non-zero values are:
>>  * arch/x86/kernel/apic/io_apic.c: returns 1 when an interrupt is pending
>>  * drivers/pinctrl/pinctrl-adi2.c: may return -ENODEV.
>
>    which is wrong to begin with.
>
>> GPIO-based irq_chip could use this feature because an output gpio
>> can't be used as an interrupt, and thus a call to irq_startup() is
>> likely to fail. You can check out
>> http://www.spinics.net/lists/arm-kernel/msg302713.html for a
>> reference.
>
> And that tells me that the design of the gpio stuff is just wrong.
>
> The whole drviers/gpio directory is full of this gpio_lock_as_irq()
> called from the guts of irq_chip callbacks braindamage.
>
> The comment above gpiod_lock_as_irq() is so wrong it's not even funny
> anymore.
>
> "....or in the .irq_enable() from its irq_chip implementation ..."
>
>         void            (*irq_enable)(struct irq_data *data);
>
> So how does that help, if the gpio is not available as irq?
>
> And no, you are not going to cure that design brainfart by adding a
> negative return value to a function returning unsigned int. And I'm
> not going to accept anything which is just a duct tape based
> workaround for a complete braindamaged design.
>
> Lets look at the usage sites:
>
> The following irqchip callback implementations printk some blurb and
> proceed:
>
>  sirfsoc_gpio_irq_startup
>  nmk_gpio_irq_startup
>  msm_gpio_irq_startup
>  u300_gpio_irq_enable
>  byt_irq_startup
>  mcp23s08_irq_startup
>  lp_irq_startup
>  intel_mid_irq_startup
>  em_gio_irq_startup
>  bcm_kona_gpio_irq_startup
>  adnp_irq_startup
>
> The following functions return an error code from the set_type
> callback:
>
>  tegra_gpio_irq_set_type
>  gpio_irq_type
>
> The whole idiocy starts with commit d468bf9e, which tells people to
> call this from irq_startup/enable. But it fails to tell, that this is
> pointless because it wont prevent the interrupt from starting up.
>
>From a GPIO subsystem standpoint, the IRQ lock is sensible because
using a gpio as an interrupt source, adds some restrictions to its
usage. Ouput configuration and IRQ configuration are exclusive for
example.
That  request_irq() succeeds if a GPIO can't be used as interrupt, is
however a problem. It can be fixed.


> So 11 SoC lemmings followed and added this completely pointless
> nonsense to their drivers.
>
> Two lemmings added it to a function which can actually fail. Failure
> as well, because there is no guarantee that this function gets invoked
> before request_irq(). What's worse is that if request_irq() succeeds
> then the following code which tries to set the type fails for no
> obvious reason.
>
> Now at least Jean-Jacques tried to make it actually fail, but that
> turns out to be a failure on its own.
just to clarify: is the failure the problem with the unsigned or the
principle of making request_irq fail ?

>
> Dammit, I told you folks often enough that workarounds in some
> subsystem do not actually cure a shortcoming in the core code. When
> the core code was written, the GPIO case which might actually fail was
> definitly not thought of. But that's not a reason for adding
> tasteless and useless workarounds to the GPIO subsystem.
>
> Of course you encouraged people to copy that nonsense all over the
> place. All startup functions do the same thing:
>
>     if (gpio_lock_as_irq() < 0)
>        dev_err("BLA");
>     unmask_irq();
>
> Plus the shutdown functions having the gpio_unlock_as_irq() +
> mask_irq() sequence. Sigh.
>
> So the proper solution to the problem if we want to use irq_startup()
> is:
>
>   Change the return value of the irq_startup() callback to int and
>   fixup all existing implementations. This wants to be done with a
>   coccinelle script. If you hurry up, I might squeeze it into 3.14 as
>   there is no risk at all. Otherwise this is going to happen after the
>   3.15 merge window closes.
I'll post a patch doing just this in the next email.

Jean-Jacques
>
>   After that's done, remove all the copies of startup/shutdown
>   nonsense in drivers/gpio and force all gpio chips to call
>   gpio_set_irq_chip*() instead of irq_set_irq_chip*() and add generic
>   irq_startup/shutdown callbacks which are implemented in the gpiolib
>   core code.
>
> There is a less intrusive alternative solution:
>
>   Mark the interrupt as GPIO based in the core and let the core call
>   conditonally the gpio_[un]lock_as_irq functions.
>
> And no, I'm not going to provide you the proper solution on the silver
> tablet this time. Go and figure it out yourself and if you're
> confident enough that it might be an acceptable solution, post it and
> we'll see.
>
> Thanks,
>
>         tglx
