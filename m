Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761452Ab3BNQeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:34:04 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:53814 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab3BNQeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:34:00 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] driver core: add wait event for deferred probe
To: anish singh <anish198519851985@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        viro@zeniv.linux.org.uk, rusty@rustcorp.com.au, hpa@linux.intel.com,
        jim.cromie@gmail.com, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com,
        Patch Tracking <patches@linaro.org>
In-Reply-To: <CAK7N6voJJ_g_LLmKdd=95fQOQPaTvQbs3HJsKJoPcrDUyUWxaA@mail.gmail.com>
References: <1360429077-14616-1-git-send-email-haojian.zhuang@linaro.org> <20130211151038.8421aa54.akpm@linux-foundation.org> <CAD6h2NRGiD=hDOjF8CBDrKuBZm-ALOdcj8mT=h6Cde4PuU=AHw@mail.gmail.com> <20130213213624.079BA3E3557@localhost> <CAK7N6voJJ_g_LLmKdd=95fQOQPaTvQbs3HJsKJoPcrDUyUWxaA@mail.gmail.com>
Date: Thu, 14 Feb 2013 16:33:57 +0000
Message-Id: <20130214163357.863A13E12FB@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2013 08:57:17 +0530, anish singh <anish198519851985@gmail.com> wrote:
> On Thu, Feb 14, 2013 at 3:06 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> >  static int deferred_probe_initcall(void)
> >  {
> >         deferred_wq = create_singlethread_workqueue("deferwq");
> >         if (WARN_ON(!deferred_wq))
> >                 return -ENOMEM;
> >
> >         driver_deferred_probe_enable = true;
> > +       deferred_probe_work_func(NULL);
> > -       driver_deferred_probe_trigger();
> >         return 0;
> >  }
> >  late_initcall(deferred_probe_initcall);
> >
> > Or something similar. That would guarantee that as many passes as are needed
> > (which in practical terms only means a couple) for device probing to
> > settle down before exiting the initcall processing. That should achieve
> > the effect you desire.
> >
> > It still masks the __init section issue by making it a lot less likely,
> Grant, Can you please explain me this problem?My understanding is below:
> If all the detection of devices with there respective driver is done before
> __init section is freed then we will not have the problem mentioned.
> However if the driver requests the probing to be deferred then __init section
> of the deferred driver will not be freed right?
> 
> I am afraid but the patch description is bit cryptic for me specially
> this line "kernel has to open console failure & release __init section before
> reinvoking failure".

Yes I can, but first I'll briefly describe the Linux driver model to make sure
we're talking about the same thing...

drivercore in Linux is oriented around two data structures:
1) Devices (struct device), and
2) Drivers (struct device_driver)

Hardware is modeled with instances of 'struct device'. For each device
that Linux knows about there is one 'struct device'[1]. The devices are
organized into a hierarchical tree, and you can see it by looking in
/sys/devices.

Device drivers are represended by struct device_driver. Each driver,
whether built-in or a module, is responsible to register itself by
embedding a struct device_driver, or a structure that contains a struct
device_driver. For example, struct platform_driver has an embedded
struct device_driver.

The whole purpose of drivercore is to match up drivers to devices. Each
bus_type has its own mechanism for deciding which devices and
device_drivers go together, but it still results in trying to bind a
struct device_driver to each struct device.

An important detail here is that drivercore is entirely asynchronous.
There are no requirements on what order devices and device_drivers are
registered. When a device gets registered, drivercore attempts to bind
it to any device_driver that it already knows about. Similarly, when a
new device_driver gets registered, drivercore will see if there are any
unbound devices that it can bind it to. It is even possible to trigger a
bind attempt sometime after both device and device_driver have been
registered.[2]

This is the reason that deferred_probe is an option. As long as the
kernel keeps track of which device_drivers requested deferred probe, we
can nudge drivercore to reattempt probing. It really doesn't matter what
order or when drivers get bound...

...except when it does. Here's where we get into the issues related to
__init sections and deferred probe. Since the driver model can bind a
driver at any time, including after userspace has started, the
expectation is that none of the code paths associated with probing will
be discarded. That is why .probe hooks cannot be __init annotated. The
problem for consoles is that the console init hook gets called from
the probe path and a lot of console init hooks are __init annotated.

Before deferred probe, this was rarely (if ever) an actual problem. In
general the order of operations during kernel init is:

1) (early boot) create and register a bunch of struct devices
2) (initcalls) register a bunch of struct device_drivers
 - a bunch of binds happen at this point as device drivers get
   registered
 - This is why device initialization order is primarily driven by driver
   link order.
3) discard __init sections
4) userspace.

It's not that bind is guaranteed to occur before __init discard, but
rather nothing prevented it from happening after. Deferred probe changes
that. With deferred probe, Haojian correctly analyzed that driver bind
is getting pushed after __init is discarded.

However, the problem with his solution was that it assumed that *all*
deferred drivers must be resolved before proceeding with init which
cannot be guaranteed. It is absolutely possble for a built-in driver to
depend on something provided by a module. As rmk pointed out, that is
not okay for console devices, so it is still important to make sure
everything needed for the console is built-in, but non-critical devices
may not care.

The difference between my fix and Haojian's is that my fix forces a
single pass of the deferred list in the same context as the initcalls
before the deferred probe workqueue takes over. That will ensure that
all inter-driver dependencies get themselves sorted out before
completing the initcalls, and therefore before __init gets discarded.

Phew, that was a lot more long-winded that I indended. I hope that helps
though.

g.

[1] It's not quite that simple. Some devices have more than one struct
device, but for the purpose of this discussion, one per device is
sufficient.
[2] It is also possible to unbind drivers from devices without
unregistering the device driver, but I don't want to get too complicated
in this description.
