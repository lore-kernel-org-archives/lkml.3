Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3HVRKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:10:44 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:54817 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3HVRKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <1375475882-3660-1-git-send-email-zoran.markovic@linaro.org>
References: <1375475882-3660-1-git-send-email-zoran.markovic@linaro.org>
Date: Thu, 22 Aug 2013 10:10:42 -0700
Message-ID: <CAME+o4mgWZjpUy7hhpBM3gJFu4KDaRrc42VitCKFUhUuYgOtSg@mail.gmail.com>
Subject: Re: [RFC PATCH] pm: prevent suspend until power supply events are processed
From: Zoran Markovic <zoran.markovic@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Arve Hjonnevag <arve@android.com>, Todd Poynor <toddpoynor@google.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any opinions on this patch?
Regards, Zoran

On 2 August 2013 13:38, Zoran Markovic <zoran.markovic@linaro.org> wrote:
> This patch, originally authored by Arve Hjonnevag and Todd Poynor,
> prevents the system from entering suspend mode until the power
> supply plug, unplug, or any other change of state event is fully
> processed. This guarantees that the screen lights up and displays
> the battery charging state. The implementation uses the power
> supply wakeup_source object.
>
> Cc: Anton Vorontsov <anton@enomsg.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Arve Hjonnevag <arve@android.com>
> Cc: Todd Poynor <toddpoynor@google.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
> ---
>  drivers/power/power_supply_core.c |   37 +++++++++++++++++++++++++++++++------
>  include/linux/power_supply.h      |    2 ++
>  2 files changed, 33 insertions(+), 6 deletions(-)
>
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
> +       spin_unlock_irqrestore(&psy->changed_lock, flags);
>  }
>
>  void power_supply_changed(struct power_supply *psy)
>  {
> +       unsigned long flags;
> +
>         dev_dbg(psy->dev, "%s\n", __func__);
>
> +       spin_lock_irqsave(&psy->changed_lock, flags);
> +       psy->changed = true;
> +       pm_stay_awake(psy->dev);
> +       spin_unlock_irqrestore(&psy->changed_lock, flags);
>         schedule_work(&psy->changed_work);
>  }
>  EXPORT_SYMBOL_GPL(power_supply_changed);
> @@ -500,6 +518,11 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
>                 goto check_supplies_failed;
>         }
>
> +       spin_lock_init(&psy->changed_lock);
> +       rc = device_init_wakeup(dev, true);
> +       if (rc)
> +               goto wakeup_init_failed;
> +
>         rc = kobject_set_name(&dev->kobj, "%s", psy->name);
>         if (rc)
>                 goto kobject_set_name_failed;
> @@ -529,6 +552,7 @@ create_triggers_failed:
>  register_cooler_failed:
>         psy_unregister_thermal(psy);
>  register_thermal_failed:
> +wakeup_init_failed:
>         device_del(dev);
>  kobject_set_name_failed:
>  device_add_failed:
> @@ -546,6 +570,7 @@ void power_supply_unregister(struct power_supply *psy)
>         power_supply_remove_triggers(psy);
>         psy_unregister_cooler(psy);
>         psy_unregister_thermal(psy);
> +       device_init_wakeup(psy->dev, false);
>         device_unregister(psy->dev);
>  }
>  EXPORT_SYMBOL_GPL(power_supply_unregister);
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index 804b906..253d412 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -194,6 +194,8 @@ struct power_supply {
>         /* private */
>         struct device *dev;
>         struct work_struct changed_work;
> +       spinlock_t changed_lock;
> +       bool changed;
>  #ifdef CONFIG_THERMAL
>         struct thermal_zone_device *tzd;
>         struct thermal_cooling_device *tcd;
> --
> 1.7.9.5
>
