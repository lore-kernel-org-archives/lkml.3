Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaICEkC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 00:40:02 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:55165 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaICEkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 00:40:00 -0400
MIME-Version: 1.0
In-Reply-To: <1375475882-3660-1-git-send-email-zoran.markovic@linaro.org>
References: <1375475882-3660-1-git-send-email-zoran.markovic@linaro.org>
Date: Wed, 3 Sep 2014 10:09:58 +0530
X-Google-Sender-Auth: 15VrssonLExpF1yDbmdbIjA3pIo
Message-ID: <CAOh2x==TSbtOKBn6KOL9Z_M-nkzQOiO+EqSTmEtQeRLXROC1rw@mail.gmail.com>
Subject: Re: [RFC PATCH] pm: prevent suspend until power supply events are processed
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Arve Hjonnevag <arve@android.com>, Todd Poynor <toddpoynor@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Zoran Markovic <zoran.markovic@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't have Zoran's new email address, but probably other might have
answers to my queries.

I have just started with the power-supply framework a day or two back
and so my understanding might not be good enough :)

On Sat, Aug 3, 2013 at 2:08 AM, Zoran Markovic
<zoran.markovic@linaro.org> wrote:
> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
> index 3b2d5df..e68d598 100644
> --- a/drivers/power/power_supply_core.c
> +++ b/drivers/power/power_supply_core.c
> @@ -67,23 +67,41 @@ static int __power_supply_changed_work(struct device *dev, void *data)
>
>  static void power_supply_changed_work(struct work_struct *work)
>  {
> +       unsigned long flags;
>         struct power_supply *psy = container_of(work, struct power_supply,
>                                                 changed_work);
>
>         dev_dbg(psy->dev, "%s\n", __func__);
>
> -       class_for_each_device(power_supply_class, NULL, psy,
> -                             __power_supply_changed_work);
> -
> -       power_supply_update_leds(psy);
> -
> -       kobject_uevent(&psy->dev->kobj, KOBJ_CHANGE);
> +       spin_lock_irqsave(&psy->changed_lock, flags);
> +       if (psy->changed) {

Can this be false here? We have reached here as the work was
scheduled after setting it to true..

Maybe a WARN_ON(psy->changed) is more sensible here ?

> +               psy->changed = false;
> +               spin_unlock_irqrestore(&psy->changed_lock, flags);
> +               class_for_each_device(power_supply_class, NULL, psy,
> +                                     __power_supply_changed_work);
> +               power_supply_update_leds(psy);
> +               kobject_uevent(&psy->dev->kobj, KOBJ_CHANGE);
> +               spin_lock_irqsave(&psy->changed_lock, flags);
> +       }
> +       /* dependent power supplies (e.g. battery) may have changed
> +        * state as a result of this event, so poll again and hold
> +        * the wakeup_source until all events are processed.
> +        */
> +       if (!psy->changed)
> +               pm_relax(psy->dev);

I got a bit confused here. Does the above comment say this:

The supplies dependent on 'psy' may change states and that *may*
change the state of 'psy' again? And so psy->changed is set to true
again?
