Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3FGObQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:31:16 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:44816 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3FGObP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:31:15 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH 3/3] i2c: nomadik: use pinctrl PM helpers
References: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
	<1370439873-30053-3-git-send-email-linus.walleij@stericsson.com>
	<87bo7kwm6q.fsf@linaro.org>
	<CACRpkdZCxCF_znnYJC=UR6ma8y4s0ev9iQSSy1hPvb5wxcnNFw@mail.gmail.com>
Date: Fri, 07 Jun 2013 07:31:10 -0700
In-Reply-To: <CACRpkdZCxCF_znnYJC=UR6ma8y4s0ev9iQSSy1hPvb5wxcnNFw@mail.gmail.com>
	(Linus Walleij's message of "Fri, 7 Jun 2013 10:33:42 +0200")
Message-ID: <87wqq6m1qp.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij <linus.walleij@linaro.org> writes:

> On Wed, Jun 5, 2013 at 6:34 PM, Kevin Hilman <khilman@linaro.org> wrote:
>
>>> From: Linus Walleij <linus.walleij@linaro.org>
>>>
>>> This utilize the new pinctrl core PM helpers to transition
>>> the driver to "sleep" and "idle" states, cutting away some
>>> boilerplate code.
>>>
>>> Cc: Hebbar Gururaja <gururaja.hebbar@ti.com>
>>> Cc: Mark Brown <broonie@kernel.org>
>>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>>> Cc: Kevin Hilman <khilman@linaro.org>
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Cc: Stephen Warren <swarren@wwwdotorg.org>
>>> Cc: Wolfram Sang <wsa@the-dreams.de>
>>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> I have some questions on the interaction with runtime PM here...
>
> OK, to get the basic infrastructure in place I have merged these
> patches with the I2C maintainers ACK, since it is doing one thing,
> i.e. moving the functionality out of the driver and into the pinctrl
> core.
>
> I am considering semantic changes related to runtime PM in
> addition to this as a separate patch, so let's start talking about
> that here.
>
> It would be inappropriate to try to create a patch that is
> changing these two things at once, but let's see where we end
> up by the merge window.
>
>>> @@ -645,13 +636,7 @@ static int nmk_i2c_xfer(struct i2c_adapter *i2c_adap,
>>>       }
>>>
>>>       /* Optionaly enable pins to be muxed in and configured */
>>> -     if (!IS_ERR(dev->pins_default)) {
>>> -             status = pinctrl_select_state(dev->pinctrl,
>>> -                             dev->pins_default);
>>> -             if (status)
>>> -                     dev_err(&dev->adev->dev,
>>> -                             "could not set default pins\n");
>>> -     }
>>> +     pinctrl_pm_select_default_state(&dev->adev->dev);
>>
>> Shouldn't this be in the ->runtime_resume() callback of the driver (the
>> original code should've as well.)
>>
>> IOW, the pinctrl changes only need to happen when the runtime PM
>> usecount goes from zero to 1.  For any additional users, the device will
>> already be active and pins already in default state.
>>
>> I'm not familiar with this HW, and maybe the driver already prevents
>> multiple users, but for correctness sake (and because others will copy
>> this), the (re)muxing should be in the runtime PM callback.
>
> I2C message are serialized/marshalled by nature so it's actually
> not causing a concurrency problem: this xfer function will not be
> called from two places for the same driver.
>
> What is true however is that we're hammering the pins from
> active to idle for every transfer, instead of letting runtime PM
> provide some nice hysteresis (autosuspend) around that.
>
> Notice though that:
>
> - This driver has no driver-local runtime PM callbacks, so the
>   runtime PM calls are intended to inform the rest of the system,
>   such as the bus, that the device is idle.
>
> - The bus used is the AMBA (PrimeCell) bus,
>   drivers/amba/bus.c
>
>> Also, IMO, that's further evidence that the pinctrl stuff could (and
>> probably should) be handled by the PM core.
>
> So I'm now thinking about how to achieve this.
>
> What happens for this driver when the usecount goes from
> 1->0 is (the other way is very similar):
>
> drivers/base/power/runtime.c
>
>         if (dev->pm_domain)
>                 callback = dev->pm_domain->ops.runtime_suspend;
>         else if (dev->type && dev->type->pm)
>                 callback = dev->type->pm->runtime_suspend;
>         else if (dev->class && dev->class->pm)
>                 callback = dev->class->pm->runtime_suspend;
>         else if (dev->bus && dev->bus->pm)
>                 callback = dev->bus->pm->runtime_suspend;
>         else
>                 callback = NULL;
>
>         if (!callback && dev->driver && dev->driver->pm)
>                 callback = dev->driver->pm->runtime_suspend;
>
>         retval = rpm_callback(callback, dev);
>
> This platform will currently hit dev->bus->pm->runtime_suspend
> to drivers/amba/bus.c:
>
> static int amba_pm_runtime_suspend(struct device *dev)
> {
>         struct amba_device *pcdev = to_amba_device(dev);
>         int ret = pm_generic_runtime_suspend(dev);
>
>         if (ret == 0 && dev->driver)
>                 clk_disable(pcdev->pclk);
>
>         return ret;
> }
>
> The pm_generic_runtime_suspend will call the driver callbacks
> (none in this case).
>
> Then the bus core proceeds to gate off the block clock and
> we're done.
>
> I could make a patch adding runtime PM ops to the
> driver itself to set the pinctrl state from there, which would
> be a nice improvement in itself.
>
> But we're discussing handling it all in the PM core, so
> let's think bigger.
>
> If we're making this all generic, were in this chain do you
> suggest that I set the pins to idle?
> drivers/base/power/runtime.c?

Yes, that's where I was thinking.

> One thing in particular that worries me here is the ordering
> of things, because that has been a severe issue for us.

In the original series from Hebbar Gururaja, Grygorii Strashko pointed
out that we may have some of the ordering issues on OMAP as well.  I
hadn't thought about that (enough) yet.

> For example: maybe on a certain platform pins need to
> be idled/defaulted *before* calling the PM domain or
> bus callbacks are executed, because of transient IRQs
> and whatnot. So I put my pinctrl_pm_select_idle_state()
> *before* the chain of calls.

Right, that corresponds to the runtime PM core calling the drivers
->runtime_suspend() callback before the subsystem/bus/domain has done
its thing.

> But sometimes you may want to execute the
> pinctrl_pm_select_idle_state() *after* all other things have
> been done, including the calls to the domain/bus/driver.

Whether it's in the PM core or not, with runtime PM today, there is no
easy way to do this from the driver ($SUBJECT patch assumes a single
user, which is not true in general.)

The only way a driver truly knows that the domain/bus/subsystem calls
have been done is when its own callback is called, and for suspend this
only happens *before* the device is actually idled.  This is effectively
a pre-runtime_suspend callback.  We don't currently have a
post-runtime_suspend callback (or a pre-runtime_resume callback.)  

Might be we need something like that to do this in a generic way.

> And this is only for the runtime suspend/resume path.
>
> For the common suspend/resume path things get more
> complex still. Users may need to call
> pinctrl_pm_select_sleep_state() in the middle of the
> code sending the platform done, and will not survive it
> being called by the PM core, and we'd need to add a flag
> for this etc.
>
> To sum up I am afraid of a can of worms of corner cases
> on something that looks simple here. Thus I cannot really
> make a patch moving pinctrl state selection to the PM
> core, I don't know the business there well enough, I just know
> there are tigers in there :-/

Yeah, the static PM case is definitely a can of worms, especially in the
case where many devices are already runtime suspended.  That defnitely
needs some serious thought and testing before handling in the PM core.

So for now, it's probably not a good idea to move things to the PM core
until we see a strong pattern emerging.

That being said, maybe we could handle this in the
subsystem/bus/pm_domain level though (in your case AMBA, in OMAP case
the pm_domain) to still avoid sprinkling this across all the drivers?

Kevin

