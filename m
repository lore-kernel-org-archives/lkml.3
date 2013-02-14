Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965072Ab3BNRiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:38:10 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40187 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab3BNRiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:38:08 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] driver core: add wait event for deferred probe
To: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        viro@zeniv.linux.org.uk, rusty@rustcorp.com.au, hpa@linux.intel.com,
        jim.cromie@gmail.com, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com,
        Patch Tracking <patches@linaro.org>
In-Reply-To: <CAD6h2NT73-af1Hgx0hCBkg8z1hQukK0XPESvrEcrUFv_VKGWjA@mail.gmail.com>
References: <1360429077-14616-1-git-send-email-haojian.zhuang@linaro.org> <20130211151038.8421aa54.akpm@linux-foundation.org> <CAD6h2NRGiD=hDOjF8CBDrKuBZm-ALOdcj8mT=h6Cde4PuU=AHw@mail.gmail.com> <20130213213624.079BA3E3557@localhost> <CAD6h2NT73-af1Hgx0hCBkg8z1hQukK0XPESvrEcrUFv_VKGWjA@mail.gmail.com>
Date: Thu, 14 Feb 2013 17:38:05 +0000
Message-Id: <20130214173805.61AA73E12FB@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2013 23:52:14 +0800, Haojian Zhuang <haojian.zhuang@linaro.org> wrote:
> On 14 February 2013 05:36, Grant Likely <grant.likely@secretlab.ca> wrote:
> > On Tue, 12 Feb 2013 10:52:10 +0800, Haojian Zhuang <haojian.zhuang@linaro.org> wrote:
> >> On 12 February 2013 07:10, Andrew Morton <akpm@linux-foundation.org> wrote:
> >> > On Sun, 10 Feb 2013 00:57:57 +0800
> >> > Haojian Zhuang <haojian.zhuang@linaro.org> wrote:
> >> >
> >> >> do_initcalls() could call all driver initialization code in kernel_init
> >> >> thread. It means that probe() function will be also called from that
> >> >> time. After this, kernel could access console & release __init section
> >> >> in the same thread.
> >> >>
> >> >> But if device probe fails and moves into deferred probe list, a new
> >> >> thread is created to reinvoke probe. If the device is serial console,
> >> >> kernel has to open console failure & release __init section before
> >> >> reinvoking failure. Because there's no synchronization mechanism.
> >> >> Now add wait event to synchronize after do_initcalls().
> >> >
> >> > It sounds like this:
> >> >
> >> > static int __ref kernel_init(void *unused)
> >> > {
> >> >         kernel_init_freeable();
> >> >         /* need to finish all async __init code before freeing the memory */
> >> >         async_synchronize_full();
> >> >
> >> > is designed to prevent the problem you describe?
> >> >
> >> It can't prevent the problem that I described. Because deferred_probe()
> >> is introduced recently.
> >>
> >> All synchronization should be finished just after do_initcalls(). Since
> >> load_default_modules() is also called in the end of kernel_init_freeable(),
> >> I'm not sure that whether I could remove async_synchronize_full()
> >> here. So I didn't touch it.
> >>
> >> >> --- a/init/main.c
> >> >> +++ b/init/main.c
> >> >> @@ -786,6 +786,7 @@ static void __init do_basic_setup(void)
> >> >>       do_ctors();
> >> >>       usermodehelper_enable();
> >> >>       do_initcalls();
> >> >> +     wait_for_device_probe();
> >> >>  }
> >> >
> >> > Needs a nice comment here explaining what's going on.
> >>
> >> No problem. I'll add comment here.
> >
> > Actually, this approach will create new problems. There is no guarantee
> > that a given device will be able to initialize before exiting
> > do_basic_setup(). If, for instance, a device depends on a resource
> > provided by a module, then it will just keep deferring. In that case
> > you've got a hung kernel.
> >
> > I think what you really want is the following:
> >
> >  static int deferred_probe_initcall(void)
> >  {
> >         deferred_wq = create_singlethread_workqueue("deferwq");
> >         if (WARN_ON(!deferred_wq))
> >                 return -ENOMEM;
> >
> >         driver_deferred_probe_enable = true;
> > +       deferred_probe_work_func(NULL);
> > -       driver_deferred_probe_trigger();
> 
> If you can change it into code in below, it could work. Otherwise, it
> always fails.
>         driver_deferred_probe_enable = true;
>         driver_deferred_probe_trigger();
> +      deferred_probe_work_func(NULL);
>         return 0;
> 
> Because deferred_probe_work_func() depends on that deferred_probe is added
> into deferred_probe_active_list. If driver_deferred_probe_trigger() isn't called
> first, the deferred uart probe can't be added into active list. So even you call
> work_func at here, it doesn't help.
> 
> Would you send it again? If so, you can add tested-by with my signature.

Hmmm, that works, but it isn't very elegant. With that solution both the
workqueue and the initcall are processing the deferred devices at the
same time. It quite possibly could result in missed devices when walking
the deferred list. Consider the scenario:

B depends on A, C and D depend on B

1) Inital conditions    pending:A-B-C-D active:empty    WQ:idle  IC:idle
2) Trigger              pending:empty   active:A-B-C-D
3) WQ: pop device       pending:empty   active:B-C-D    WQ:A     IC:idle
4) IC: pop device       pending:empty   active:C-D      WQ:A     IC:B
5) WQ: A probed & pop   pending:empty   active:D        WQ:C     IC:B
6) IC: B defers & pop   pending:B       active:empty    WQ:C     IC:D
   /* B defers because A wasn't ready, but when A did complete B wasn't
    * onthe pending list - this is bad */
7) WQ: C defers         pending:B-C     active:empty    WQ:idle  IC:D
8) IC: D defers         pending:B-C-D   active:empty    WQ:idle  IC:idle

When A successfully probes, everthing in the pending list gets appended
to the active one, but if there are multiple threads poping devices off
the list, then there can be devices that /should/ be moved to the active
list but don't because they've been popped off by a separate thread.

With the current code there really should only be one processor of the
deferred list at a time. Try this instead:


        driver_deferred_probe_enable = true;
        driver_deferred_probe_trigger();
+       flush_workqueue(deferred_wq);
        return 0;

I had tried to keep the first pass of the list within the initcall
context, but it created a lot of special cases in the code that I wasn't
happy with. This is a lot simpler and has exactly the same visible
behaviour.

Let me know if that works for you and I'll send a proper patch to Linus
with your Tested-by.  He may yell at me for sending something so
incredibly late in the v3.8 stablization, but this really is a bug fix.
If he won't take it then I'll ask Greg to put it into v3.8.1.

g.
