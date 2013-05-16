Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab3EPUcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:32:54 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:59380 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab3EPUcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:32:50 -0400
MIME-Version: 1.0
In-Reply-To: <1944811.006SLH6aYj@flatron>
References: <1368724352-10849-1-git-send-email-dianders@chromium.org>
	<1368724352-10849-2-git-send-email-dianders@chromium.org>
	<1944811.006SLH6aYj@flatron>
Date: Thu, 16 May 2013 13:32:48 -0700
X-Google-Sender-Auth: TMAjmnq1CbTXDknWwVyuMwk4QH0
Message-ID: <CAD=FV=Wk4sib4RvgVqonSj_wANmUh6vftTqveFNn6X4ceFc6Gw@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: samsung: fix suspend/resume functionality
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Prathyush K <prathyush.k@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz,

Thanks for the review!  I'll get a new patch out either today or tomorrow...

On Thu, May 16, 2013 at 12:19 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> +/**
>> + * samsung_pinctrl_resume_noirq - save pinctrl state for suspend
>> + *
>> + * Save data for all banks handled by this device.
>> + */
>> +static int samsung_pinctrl_suspend_noirq(struct device *dev)
>> +{
>> +     struct samsung_pinctrl_drv_data *drvdata = dev_get_drvdata(dev);
>> +     struct samsung_pin_ctrl *ctrl = drvdata->ctrl;
>> +     void __iomem * const virt_base = drvdata->virt_base;
>
> Nit: This const is ugly :) . Is it needed for anything?

Not anything really.  I just got in the habit of adding them for
variables that are simple shorthand variables: AKA I'm only creating
this variable to avoid typing some long complicated thing below.  It's
a hint to someone reading the code that they don't need to think about
it.  I have also occasionally caught bugs by doing this.

...but I can understand the dislike.  I'll remove this and other
similar (but keep const pointers).


>> +             if (type->fld_width[PINCFG_TYPE_FUNC] > 4)
>
> What is this condition supposed to check?

It is supposed to be checking whether there are two CON registers in
use.  ...oh, but that's probably not the right way to do it now that I
think about it.  I need to check (bank->nr_pins *
type->fld_width[PINCFG_TYPE_FUNC]).

I will fix.


>> +                     bank->pm_save.con |= (u64)readl(reg + 4 +
>> +                                   type->reg_offset[PINCFG_TYPE_FUNC])
> << 32;
>
> This looks ugly. Whatever is going on here, wouldn't it be better to use
> separate field, like con2 or something?

Probably.  The resume code seemed cleaner with a 64-bit value, but I
think I could make it nearly as clean with two 32-bit ones by using a
helper function.


> I wonder if you couldn't do all the saving here in a single loop over all
> pin control types, like:
>
>         unsigned int offsets = bank->type->reg_offsets;
>         unsigned int widths = bank->type->fld_width;
>
>         for (i = 0; i < PINCFG_TYPE_NUM; ++i)
>                 if (widths[i])
>                         bank->pm_save[i] = readl(reg + offsets[i]);
>
> The only thing not handled by this loop is second CON registers in banks
> with two of them. I can't think of any better solution for this other than
> just adding a special case after the loop.

Yes, that would work.  I think it wasn't possible when I first wrote
the code against an older code base that didn't have the arrays.  I
can give it a shot if it doesn't make restore too bad...


> Now as I think of it, do CON_PDN and PUD_PDN really need to be saved? I
> couldn't find in the documentation if they are preserved or lost in sleep
> mode. Do you have some information on this?

I remember it being important.  Running a test now.  Yes, it's
important on exynos5250.  As an example:

[   62.220000] samsung-pinctrl 11400000.pinctrl: Restore gpa2@f0048040
(0x22220000=>0x22123333 ch 0x0000ffff)
[   62.220000] samsung-pinctrl 11400000.pinctrl: Restore gpb0@f0048060
CON_PDN (0x00000000=>0x000002aa)
[   62.220000] samsung-pinctrl 11400000.pinctrl: Restore gpb0@f0048060
PUD_PDN (0x00000000=>0x00000155)


> I wonder if the whole restoration procedure couldn't be simplified. I
> don't remember my version being so complicated, but I don't have my patch
> on my screen at the moment, so I might be wrong on this.

I debated about this a bunch.  Perhaps I should just delete it.  I saw
that it was there in the old "2-bit" code and it also seemed quite
reasonable, so I kept it.  Things seem to work OK without it, but most
things are pretty tolerant to their lines glitching (or even driving
high to low for a short period of time).

...but your question made me check again.

>From previous experimentation I'm pretty certain that most pins on the
exynos are held in the powerdown state even during early bootup of the
SoC.  The hope is that they are released from powerdown _after_ the
GPIO init is called.  If not then we're already glitching somewhat as
we transition from powerdown state to default state before this
function finally gets called.

Looking at exynos, that's probably done in exynos_pm_resume(), maybe
by mucking with the pad retention options?

Oh, that probably means taht no_irq() is too late and that I need to
figure out how to get my code called earlier...  The
exynos_pm_resume() is called by syscore.


>> +#else
>> +#define samsung_pinctrl_suspend_noirq        NULL
>> +#define samsung_pinctrl_resume_noirq NULL
>> +#endif
>> +
>> +static const struct dev_pm_ops samsung_pinctrl_dev_pm_ops = {
>> +     .suspend_noirq = samsung_pinctrl_suspend_noirq,
>> +     .resume_noirq = samsung_pinctrl_resume_noirq,
>> +};
>
> I'm not sure if resume_noirq is really early enough. Some drivers might
> already need correct pin configuration in their resume_noirq callback.
>
> In my patch I have used syscore_ops to register very late suspend and very
> early resume callbacks for the whole pinctrl-samsung driver and a global
> list of registered pin controllers, that is iterated over in suspend and
> resume.

OK, as per above syscore is actually important.  ...and in fact I need
to figure out how to ensure that this is called _before_
exynos_pm_resume(), which is also syscore.  I guess I also need to
stash an array of devices in an global somewhere, since syscore passes
no params...

-Doug
