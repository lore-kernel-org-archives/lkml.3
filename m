Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab3BND1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:27:21 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37314 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab3BND1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:27:19 -0500
MIME-Version: 1.0
In-Reply-To: <20130213213624.079BA3E3557@localhost>
References: <1360429077-14616-1-git-send-email-haojian.zhuang@linaro.org>
	<20130211151038.8421aa54.akpm@linux-foundation.org>
	<CAD6h2NRGiD=hDOjF8CBDrKuBZm-ALOdcj8mT=h6Cde4PuU=AHw@mail.gmail.com>
	<20130213213624.079BA3E3557@localhost>
Date: Thu, 14 Feb 2013 08:57:17 +0530
Message-ID: <CAK7N6voJJ_g_LLmKdd=95fQOQPaTvQbs3HJsKJoPcrDUyUWxaA@mail.gmail.com>
Subject: Re: [PATCH] driver core: add wait event for deferred probe
From: anish singh <anish198519851985@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        viro@zeniv.linux.org.uk, rusty@rustcorp.com.au, hpa@linux.intel.com,
        jim.cromie@gmail.com, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 3:06 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Tue, 12 Feb 2013 10:52:10 +0800, Haojian Zhuang <haojian.zhuang@linaro.org> wrote:
>> On 12 February 2013 07:10, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > On Sun, 10 Feb 2013 00:57:57 +0800
>> > Haojian Zhuang <haojian.zhuang@linaro.org> wrote:
>> >
>> >> do_initcalls() could call all driver initialization code in kernel_init
>> >> thread. It means that probe() function will be also called from that
>> >> time. After this, kernel could access console & release __init section
>> >> in the same thread.
>> >>
>> >> But if device probe fails and moves into deferred probe list, a new
>> >> thread is created to reinvoke probe. If the device is serial console,
>> >> kernel has to open console failure & release __init section before
>> >> reinvoking failure. Because there's no synchronization mechanism.
>> >> Now add wait event to synchronize after do_initcalls().
>> >
>> > It sounds like this:
>> >
>> > static int __ref kernel_init(void *unused)
>> > {
>> >         kernel_init_freeable();
>> >         /* need to finish all async __init code before freeing the memory */
>> >         async_synchronize_full();
>> >
>> > is designed to prevent the problem you describe?
>> >
>> It can't prevent the problem that I described. Because deferred_probe()
>> is introduced recently.
>>
>> All synchronization should be finished just after do_initcalls(). Since
>> load_default_modules() is also called in the end of kernel_init_freeable(),
>> I'm not sure that whether I could remove async_synchronize_full()
>> here. So I didn't touch it.
>>
>> >> --- a/init/main.c
>> >> +++ b/init/main.c
>> >> @@ -786,6 +786,7 @@ static void __init do_basic_setup(void)
>> >>       do_ctors();
>> >>       usermodehelper_enable();
>> >>       do_initcalls();
>> >> +     wait_for_device_probe();
>> >>  }
>> >
>> > Needs a nice comment here explaining what's going on.
>>
>> No problem. I'll add comment here.
>
> Actually, this approach will create new problems. There is no guarantee
> that a given device will be able to initialize before exiting
> do_basic_setup(). If, for instance, a device depends on a resource
> provided by a module, then it will just keep deferring. In that case
> you've got a hung kernel.
>
> I think what you really want is the following:
>
>  static int deferred_probe_initcall(void)
>  {
>         deferred_wq = create_singlethread_workqueue("deferwq");
>         if (WARN_ON(!deferred_wq))
>                 return -ENOMEM;
>
>         driver_deferred_probe_enable = true;
> +       deferred_probe_work_func(NULL);
> -       driver_deferred_probe_trigger();
>         return 0;
>  }
>  late_initcall(deferred_probe_initcall);
>
> Or something similar. That would guarantee that as many passes as are needed
> (which in practical terms only means a couple) for device probing to
> settle down before exiting the initcall processing. That should achieve
> the effect you desire.
>
> It still masks the __init section issue by making it a lot less likely,
Grant, Can you please explain me this problem?My understanding is below:
If all the detection of devices with there respective driver is done before
__init section is freed then we will not have the problem mentioned.
However if the driver requests the probing to be deferred then __init section
of the deferred driver will not be freed right?

I am afraid but the patch description is bit cryptic for me specially
this line "kernel has to open console failure & release __init section before
reinvoking failure".

> but it does ensure that all of the built-in driver dependency order
> issues are processed before continuing on to userspace.
>
> g.
>
> --
> Grant Likely, B.Sc, P.Eng.
> Secret Lab Technologies, Ltd.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
