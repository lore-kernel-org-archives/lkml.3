Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaILQIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:08:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51075 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaILQIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:08:36 -0400
Message-ID: <54131A90.4020501@wwwdotorg.org>
Date: Fri, 12 Sep 2014 10:08:48 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: mmc: freeing host while host->detect work queue is still active
References: <54121C1C.8080408@wwwdotorg.org>
In-Reply-To: <54121C1C.8080408@wwwdotorg.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 04:03 PM, Stephen Warren wrote:
> Running Fedora rawhides's 3.17.0-0.rc4.git2.1.fc22.armv7hl kernel on
> Jetson TK1 (an ARM board containing Tegra SoC), I see the following
> during boot most times the Tegra SDHCI driver defers probe for the SD slot:

(and indeed I can reproduce the same issue in plain old v3.17-rc4, so 
this isn't at all Fedora specific)

>> [    8.377719] sdhci-tegra 700b0400.sdhci: Got CD GPIO #170.
>> [    8.377780] sdhci-tegra 700b0400.sdhci: Got WP GPIO #132.
>> [    8.377898] mmc1: Unknown controller version (3). You may
>> experience problems.
>> [    8.379796] sdhci-tegra 700b0400.sdhci: No vmmc regulator found
>> [    8.380225] ------------[ cut here ]------------
>> [    8.380243] WARNING: CPU: 2 PID: 6 at lib/debugobjects.c:263
>> debug_print_object+0x8c/0xb4()
>> [    8.380261] ODEBUG: free active (active state 0) object type:
>> timer_list hint: delayed_work_timer_fn+0x0/0x18
>> [    8.380308] Modules linked in: ehci_tegra(+) sdhci_tegra
>> sdhci_pltfm sdhci phy_tegra_usb mmc_core i2c_tegra tegra_drm
>> drm_kms_helper drm host1x
>> [    8.380319] CPU: 2 PID: 6 Comm: kworker/u8:0 Not tainted
>> 3.17.0-0.rc4.git2.1.fc22.armv7hl #1
>> [    8.380336] Workqueue: deferwq deferred_probe_work_func
>> [    8.380358] [<c0218ffc>] (unwind_backtrace) from [<c0212bf0>]
>> (show_stack+0x18/0x1c)
>> [    8.380374] [<c0212bf0>] (show_stack) from [<c094dbe0>]
>> (dump_stack+0x84/0xb0)
>> [    8.380395] [<c094dbe0>] (dump_stack) from [<c0251690>]
>> (warn_slowpath_common+0x70/0x94)
>> [    8.380413] [<c0251690>] (warn_slowpath_common) from [<c02516e8>]
>> (warn_slowpath_fmt+0x34/0x44)
>> [    8.380426] [<c02516e8>] (warn_slowpath_fmt) from [<c057ec6c>]
>> (debug_print_object+0x8c/0xb4)
>> [    8.380439] [<c057ec6c>] (debug_print_object) from [<c057f8d8>]
>> (debug_check_no_obj_freed+0xf4/0x1dc)
>> [    8.380453] [<c057f8d8>] (debug_check_no_obj_freed) from
>> [<c0398174>] (kfree+0x160/0x308)
>> [    8.380465] [<c0398174>] (kfree) from [<c0658094>]
>> (device_release+0x64/0x98)
>> [    8.380479] [<c0658094>] (device_release) from [<c056a8a4>]
>> (kobject_release+0x12c/0x19c)
>> [    8.380498] [<c056a8a4>] (kobject_release) from [<bf2994b0>]
>> (sdhci_tegra_probe+0x190/0x1bc [sdhci_tegra])
>> [    8.380810] [<bf2994b0>] (sdhci_tegra_probe [sdhci_tegra]) from
>> [<c065e024>] (platform_drv_probe+0x34/0x68)
>> [    8.380825] [<c065e024>] (platform_drv_probe) from [<c065c0bc>]
>> (driver_probe_device+0x13c/0x33c)
>> [    8.380838] [<c065c0bc>] (driver_probe_device) from [<c065a5f8>]
>> (bus_for_each_drv+0x8c/0x9c)
>> [    8.380852] [<c065a5f8>] (bus_for_each_drv) from [<c065bf08>]
>> (device_attach+0x70/0x94)
>> [    8.380865] [<c065bf08>] (device_attach) from [<c065b464>]
>> (bus_probe_device+0x30/0xa4)
>> [    8.380878] [<c065b464>] (bus_probe_device) from [<c065b954>]
>> (deferred_probe_work_func+0x88/0xb8)
>> [    8.380894] [<c065b954>] (deferred_probe_work_func) from
>> [<c026b0e8>] (process_one_work+0x2a0/0x5f8)
>> [    8.380908] [<c026b0e8>] (process_one_work) from [<c026c7e4>]
>> (worker_thread+0x2d0/0x40c)
>> [    8.380922] [<c026c7e4>] (worker_thread) from [<c027153c>]
>> (kthread+0xd4/0xe8)
>> [    8.380936] [<c027153c>] (kthread) from [<c020ecc8>]
>> (ret_from_fork+0x14/0x20)
>> [    8.380941] ---[ end trace b1f4b0fe632eb3a4 ]---
>
> The problem is as follows:
>
> The following sequence of calls requests the CD (Change Detect) IRQ for
> the SD slot:
>
> sdhci_tegra_probe()
> sdhci_tegra_parse_dt()
> mmc_of_parse()
> mmc_gpio_request_cd()
> devm_request_threaded_irq()
>
> The IRQ is triggered by a pin on the SD slot, so could be in any state,
> and might fire immediately. This causes the IRQ handler
> mmc_gpio_cd_irqt() to run, which calls mmc_detect_change() which calls
> mmc_schedule_delayed_work(&host->detect, ...); Thus, the work queue can
> be immediately active.
>
> However, if later part of sdhci_tegra_probe() fails, e.g.
> sdhci_add_host() -> mmc_regulator_get_supply() ->
> devm_regulator_get_optional() -> -EPROBE_DEFER, then sdhci_tegra_probe()
> needs to tear everything down, and so calls sdhci_pltfm_free() ->
> sdhci_free_host() -> mmc_free_host() -> put_device(&host->class_dev) ->
> mmc_host_classdev_release() -> kfree(host). However, host->detect is
> part of host and may still be active at this point, which is what
> triggers the ODETECT log spew mentioned above.
>
> This doesn't happen in linux-next, because mmc_gpiod_request_cd()
> doesn't set up the IRQ handler. Rather this happens inside
> mmc_gpiod_request_cd_irq() which is called from mmc_start_host(), which
> I believe is well after deferred probe could occur.
>
> Some possible options for fixing this in 3.17 are:
>
> a) Back-port whatever changes in mainline stopped mmc_of_parse()() from
> requesting the IRQ. That is commit 740a221ef0e5 "mmc: slot-gpio: Add
> GPIO descriptor based CD GPIO API". I haven't investigated how many
> other commits would be required for that commit to apply, but I'm
> nervous it'd be too many to apply to 3.17.

Sorry, I quoted the wrong commit ID there. That commit is already 
present in 3.17 (and some earlier). That commit adds the separate 
mmc_gpiod_request_cd_irq() function that's necessary to solve the 
problem, and adds a call to it from mmc_start_host(). However, it still 
leaves a call to mmc_gpiod_request_cd_irq() in mmc_gpio_request_cd(), 
thus leaving the problem in place.

The following commit from linux-next actually solves the problem for me, 
by having mmc_of_parse() call mmc_gpiod_request_cd() [which doesn't call 
mmc_gpiod_request_cd_irq()] rather than mmc_gpio_request_cd():

98e90de99a0c mmc: host: switch OF parser to use gpio descriptors

That commit relies on at least one of the following two commits in order 
to successfully build directly on top of 3.17-rc4:

9d2fa2428ae1 mmc: slot-gpio: add gpiod variant to get wp GPIO
9fbc695075e9 mmc: slot-gpio: switch to use flags when getting GPIO

Is that too much to apply for 3.17 too?

However I note that this only solves the problem for any user of 
mmc_of_parse(); any code still calling mmc_gpio_request_cd() directly 
could still be exposed to the issue. I wonder if we shouldn't also 
remove the call to mmc_gpiod_request_cd_irq() from mmc_gpio_request_cd().

So...

> b) Fix the -EPROBE_DEFER cleanup path to explicitly free the IRQ (so it
> can't schedule the work queue any more), and then cancel the work queue
> (so it isn't active and doesn't trigger the ODETECT message).
>
> A naive patch might be like:
>
> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index 31969436d77c..8125f916be4a 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -586,6 +586,9 @@ void mmc_free_host(struct mmc_host *host)
>       idr_remove(&mmc_host_idr, host->index);
>       spin_unlock(&mmc_host_lock);
>
> +    mmc_gpiod_free_cd(host);
> +    cancel_delayed_work_sync(&host->detect);
> +
>       put_device(&host->class_dev);
>   }

... something like that (but calling a new mmc_gpiod_free_cd_irq()) 
might still be the best approach. I guess I should just send a patch to 
do that?

> However, that's problematic, since I think mmc_free_host() would have to
> somehow determine whether it needs to call mmc_gpio_free_cd() or
> mmc_gpiod_free_cd()? Perhaps we should *just* call devm_free_irq()
> there, rather than tearing down all the GPIO stuff too, i.e. split out a
> separate mmc_gpio_free_cd_irq() function rather like there's a separate
> IRQ request function?
>
> What approach do people prefer and/or does anyone have any other ideas
> for a fix?
