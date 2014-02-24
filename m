Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaBXNhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:37:35 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:42214 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaBXNhe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:37:34 -0500
MIME-Version: 1.0
In-Reply-To: <1393248238-995-1-git-send-email-sre@debian.org>
References: <1393248238-995-1-git-send-email-sre@debian.org>
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Mon, 24 Feb 2014 14:36:53 +0100
Message-ID: <CAHYPw2HwArH2bYof6iQd8CTJqcoBU-Z4fS4F+tipYvN73-C0xQ@mail.gmail.com>
Subject: Re: [PATCH] bq2415x_charger: Fix Atomic Sleep Bug
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

2014-02-24 14:23 GMT+01:00 Sebastian Reichel <sre@debian.org>:
> Move sysfs_notify and i2c_transfer calls from bq2415x_notifier_call
> to bq2415x_timer_work to avoid sleeping in atomic context.
>
> This fixes the following bug:
>
> [ 7.667449] Workqueue: events power_supply_changed_work
> [ 7.673034] [<c0015c28>] (unwind_backtrace+0x0/0xe0) from [<c0011e1c>] (show_stack+0x10/0x14)
> [ 7.682098] [<c0011e1c>] (show_stack+0x10/0x14) from [<c052cdd0>] (dump_stack+0x78/0xac)
> [ 7.690704] [<c052cdd0>] (dump_stack+0x78/0xac) from [<c052a044>] (__schedule_bug+0x48/0x60)
> [ 7.699645] [<c052a044>] (__schedule_bug+0x48/0x60) from [<c053071c>] (__schedule+0x74/0x638)
> [ 7.708618] [<c053071c>] (__schedule+0x74/0x638) from [<c05301fc>] (schedule_timeout+0x1dc/0x24c)
> [ 7.718017] [<c05301fc>] (schedule_timeout+0x1dc/0x24c) from [<c05316ec>] (wait_for_common+0x138/0x17c)
> [ 7.727966] [<c05316ec>] (wait_for_common+0x138/0x17c) from [<c0362a70>] (omap_i2c_xfer+0x340/0x4a0)
> [ 7.737640] [<c0362a70>] (omap_i2c_xfer+0x340/0x4a0) from [<c035d928>] (__i2c_transfer+0x40/0x74)
> [ 7.747039] [<c035d928>] (__i2c_transfer+0x40/0x74) from [<c035e22c>] (i2c_transfer+0x6c/0x90)
> [ 7.756195] [<c035e22c>] (i2c_transfer+0x6c/0x90) from [<c037ad24>] (bq2415x_i2c_write+0x48/0x78)
> [ 7.765563] [<c037ad24>] (bq2415x_i2c_write+0x48/0x78) from [<c037ae60>] (bq2415x_set_weak_battery_voltage+0x4c/0x50)
> [ 7.776824] [<c037ae60>] (bq2415x_set_weak_battery_voltage+0x4c/0x50) from [<c037bce8>] (bq2415x_set_mode+0xdc/0x14c)
> [ 7.788085] [<c037bce8>] (bq2415x_set_mode+0xdc/0x14c) from [<c037bfb8>] (bq2415x_notifier_call+0xa8/0xb4)
> [ 7.798309] [<c037bfb8>] (bq2415x_notifier_call+0xa8/0xb4) from [<c005f228>] (notifier_call_chain+0x38/0x68)
> [ 7.808715] [<c005f228>] (notifier_call_chain+0x38/0x68) from [<c005f284>] (__atomic_notifier_call_chain+0x2c/0x3c)
> [ 7.819732] [<c005f284>] (__atomic_notifier_call_chain+0x2c/0x3c) from [<c005f2a8>] (atomic_notifier_call_chain+0x14/0x18)
> [ 7.831420] [<c005f2a8>] (atomic_notifier_call_chain+0x14/0x18) from [<c0378078>] (power_supply_changed_work+0x6c/0xb8)
> [ 7.842864] [<c0378078>] (power_supply_changed_work+0x6c/0xb8) from [<c00556c0>] (process_one_work+0x248/0x440)
> [ 7.853546] [<c00556c0>] (process_one_work+0x248/0x440) from [<c0055d6c>] (worker_thread+0x208/0x350)
> [ 7.863372] [<c0055d6c>] (worker_thread+0x208/0x350) from [<c005b0ac>] (kthread+0xc8/0xdc)
> [ 7.872131] [<c005b0ac>] (kthread+0xc8/0xdc) from [<c000e138>] (ret_from_fork+0x14/0x3c)
>
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
> Hi Dmitry,
>
> I think this patch should be applied to 3.14-rc.
>
> -- Sebastian

Thanks for looking at this problem! I cannot test your code now
because I do not have ready env for compiling and testing. Just one
note on patch.

> ---
>  drivers/power/bq2415x_charger.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
> index 79a37f6..8bf14fc 100644
> --- a/drivers/power/bq2415x_charger.c
> +++ b/drivers/power/bq2415x_charger.c
> @@ -840,8 +840,7 @@ static int bq2415x_notifier_call(struct notifier_block *nb,
>         if (bq->automode < 1)
>                 return NOTIFY_OK;
>
> -       sysfs_notify(&bq->charger.dev->kobj, NULL, "reported_mode");
> -       bq2415x_set_mode(bq, bq->reported_mode);
> +       schedule_delayed_work(&bq->work, 0);
>
>         return NOTIFY_OK;
>  }
> @@ -892,6 +891,11 @@ static void bq2415x_timer_work(struct work_struct *work)
>         int error;
>         int boost;
>
> +       if (bq->automode == 1 && (bq->reported_mode != bq->mode)) {

For consistency with other parts of code use: if (bq->automode > 0 && ...)

> +               sysfs_notify(&bq->charger.dev->kobj, NULL, "reported_mode");
> +               bq2415x_set_mode(bq, bq->reported_mode);
> +       }
> +
>         if (!bq->autotimer)
>                 return;
>
> --
> 1.8.5.3
>

Otherwise looks ok.

-- 
Pali Rohár
pali.rohar@gmail.com
