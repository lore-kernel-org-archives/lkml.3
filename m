Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbaJUND1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:03:27 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51775 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435AbaJUND0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:03:26 -0400
MIME-Version: 1.0
In-Reply-To: <1413775748-22478-1-git-send-email-zhangwm@marvell.com>
References: <1413775748-22478-1-git-send-email-zhangwm@marvell.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Tue, 21 Oct 2014 09:02:59 -0400
X-Google-Sender-Auth: VYMuLxFKG8TxCLq6vQhr43hq76Y
Message-ID: <CALZtONB-qX-qL4BnCxadhKc6v60mNtrv8UxinhEwehtiff6S3g@mail.gmail.com>
Subject: Re: [PATCH] drivers: base: update cpu offline info when do hotplug
To: Neil Zhang <zhangwm@marvell.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 11:29 PM, Neil Zhang <zhangwm@marvell.com> wrote:
> The current per-cpu offline info won't be updated if it is
> hotplugged in/out by a kernel governer.
> Let's update it via cpu notifier.
>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  drivers/base/cpu.c |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 006b1bc..9d61824 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -418,10 +418,35 @@ static void __init cpu_dev_register_generic(void)
>  #endif
>  }
>
> +static int device_hotplug_notifier(struct notifier_block *nfb,
> +                                     unsigned long action, void *hcpu)
> +{
> +       unsigned int cpu = (unsigned long)hcpu;
> +       struct device *dev = get_cpu_device(cpu);
> +       int ret;
> +
> +       switch (action & ~CPU_TASKS_FROZEN) {
> +       case CPU_ONLINE:
> +               dev->offline = false;
> +               ret = NOTIFY_OK;
> +               break;
> +       case CPU_DYING:
> +               dev->offline = true;

one thing i just thought of here, since dev->offline is getting set
here, can you remove it being set in drivers/base/core.c at
device_online() and device_offline() ?  That's probably redundant now
right?


> +               ret = NOTIFY_OK;
> +               break;
> +       default:
> +               ret = NOTIFY_DONE;
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
>  void __init cpu_dev_init(void)
>  {
>         if (subsys_system_register(&cpu_subsys, cpu_root_attr_groups))
>                 panic("Failed to register CPU subsystem");
>
>         cpu_dev_register_generic();
> +       cpu_notifier(device_hotplug_notifier, 0);
>  }
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
