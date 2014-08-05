Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbaHEGRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 02:17:52 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:39975 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbaHEGRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 02:17:51 -0400
MIME-Version: 1.0
In-Reply-To: <1407183283-21921-1-git-send-email-moon.linux@yahoo.com>
References: <1407183283-21921-1-git-send-email-moon.linux@yahoo.com>
Date: Tue, 5 Aug 2014 11:47:50 +0530
Message-ID: <CAKohpo=j59=5fmVAdhGXkdb3YHN6zDQBkibZZTfc73GvSqx=3A@mail.gmail.com>
Subject: Re: [PATCH] cpufreq_opp.c: Fixed the __might_sleep by changing
 GFP_KERNEL to GFP_ATOMIC.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Anand Moon <moon.linux@yahoo.com>, Stephen Boyd <sboyd@codeaurora.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 August 2014 01:44, Anand Moon <moon.linux@yahoo.com> wrote:
> Note: Generally, you should use GFP_ATOMIC in interrupt context
> or in process context where it is not allowed to sleep, and GFP_KERNEL elsewhere.
>
> This changes fixes bellow bug on ARM imx6
>
> Signed-off-by: Anand Moon <moon.linux@yahoo.com>

This should have come after the kernel dump.

> [    7.331858]
> [    7.333369] ===============================
> [    7.337633] [ INFO: suspicious RCU usage. ]
> [    7.341834] 3.16.0-armv7-x2 #1 Not tainted
> [    7.346506] -------------------------------
> [    7.350709] include/linux/rcupdate.h:513 Illegal context switch in RCU read-side critical section!
> [    7.359735]
> [    7.359735] other info that might help us debug this:
> [    7.359735]
> [    7.367932]
> [    7.367932] rcu_scheduler_active = 1, debug_locks = 1
> [    7.374477] 2 locks held by swapper/0/1:
> [    7.378491]  #0:  (&dev->mutex){......}, at: [<c06b273c>] device_attach+0x28/0x9c
> [    7.386212]  #1:  (rcu_read_lock){......}, at: [<c083cfc8>] dev_pm_opp_init_cpufreq_table+0x0/0x23c
> [    7.396284]
> [    7.396284] stack backtrace:
> [    7.400666] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-armv7-x2 #1
> [    7.407668] [<c0019234>] (unwind_backtrace) from [<c0014218>] (show_stack+0x20/0x24)
> [    7.415473] [<c0014218>] (show_stack) from [<c0a5b8a0>] (dump_stack+0x9c/0xbc)
> [    7.422818] [<c0a5b8a0>] (dump_stack) from [<c00b4474>] (lockdep_rcu_suspicious+0xdc/0x110)
> [    7.431298] [<c00b4474>] (lockdep_rcu_suspicious) from [<c008d214>] (__might_sleep+0x204/0x240)
> [    7.440106] [<c008d214>] (__might_sleep) from [<c01c8090>] (__kmalloc+0x2a8/0x328)
> [    7.447801] [<c01c8090>] (__kmalloc) from [<c083d06c>] (dev_pm_opp_init_cpufreq_table+0xa4/0x23c)
> [    7.456780] [<c083d06c>] (dev_pm_opp_init_cpufreq_table) from [<c0841bb0>] (imx6q_cpufreq_probe+0x160/0x750)
> [    7.466734] [<c0841bb0>] (imx6q_cpufreq_probe) from [<c06b4b84>] (platform_drv_probe+0x28/0x5c)
> [    7.475456] [<c06b4b84>] (platform_drv_probe) from [<c06b2960>] (driver_probe_device+0x14c/0x39c)
> [    7.484457] [<c06b2960>] (driver_probe_device) from [<c06b2c00>] (__device_attach+0x50/0x54)
> [    7.492986] [<c06b2c00>] (__device_attach) from [<c06b09e0>] (bus_for_each_drv+0x70/0xa4)
> [    7.501291] [<c06b09e0>] (bus_for_each_drv) from [<c06b279c>] (device_attach+0x88/0x9c)
> [    7.509388] [<c06b279c>] (device_attach) from [<c06b1c08>] (bus_probe_device+0x98/0xbc)
> [    7.517600] [<c06b1c08>] (bus_probe_device) from [<c06afac0>] (device_add+0x4a8/0x5a0)
> [    7.525679] [<c06afac0>] (device_add) from [<c06b487c>] (platform_device_add+0xd4/0x26c)
> [    7.533974] [<c06b487c>] (platform_device_add) from [<c06b5144>] (platform_device_register+0x30/0x34)
> [    7.543404] [<c06b5144>] (platform_device_register) from [<c0f0dcb4>] (imx6q_init_late+0x17c/0x18c)
> [    7.552609] [<c0f0dcb4>] (imx6q_init_late) from [<c0f00b8c>] (init_machine_late+0x28/0x30)
> [    7.560991] [<c0f00b8c>] (init_machine_late) from [<c0008bb0>] (do_one_initcall+0xec/0x224)
> [    7.569538] [<c0008bb0>] (do_one_initcall) from [<c0efef00>] (kernel_init_freeable+0x208/0x2ac)
> [    7.578448] [<c0efef00>] (kernel_init_freeable) from [<c0a557ac>] (kernel_init+0x1c/0xf8)
> [    7.586764] [<c0a557ac>] (kernel_init) from [<c000fce8>] (ret_from_fork+0x14/0x20)
> ---
>  drivers/cpufreq/cpufreq_opp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq_opp.c b/drivers/cpufreq/cpufreq_opp.c
> index c0c6f4a..d5b5625 100644
> --- a/drivers/cpufreq/cpufreq_opp.c
> +++ b/drivers/cpufreq/cpufreq_opp.c
> @@ -60,7 +60,7 @@ int dev_pm_opp_init_cpufreq_table(struct device *dev,
>                 goto out;
>         }
>
> -       freq_table = kzalloc(sizeof(*freq_table) * (max_opps + 1), GFP_KERNEL);
> +       freq_table = kzalloc(sizeof(*freq_table) * (max_opps + 1), GFP_ATOMIC);
>         if (!freq_table) {
>                 ret = -ENOMEM;
>                 goto out;

Please see this:

https://lkml.org/lkml/2014/7/16/815

@Rafael: Have you already applied patch from above link?
