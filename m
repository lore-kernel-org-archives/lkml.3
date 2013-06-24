Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3FXL7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:59:31 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49015 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab3FXL73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:59:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bernie Thompson <bhthompson@chromium.org>
Cc: linux-pm@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / wakeup: Adjust messaging for wake events during suspend
Date: Mon, 24 Jun 2013 14:08:56 +0200
Message-ID: <1758800.Qrg3TzNCst@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1370047663-432-1-git-send-email-bhthompson@chromium.org>
References: <1370047663-432-1-git-send-email-bhthompson@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 31, 2013 05:47:43 PM Bernie Thompson wrote:
> This adds in a new message to the wakeup code which adds an indication to
> the log that suspend was cancelled due to a wake event occouring during
> the suspend sequence. It also adjusts the message printed in suspend.c to
> reflect the potential that a suspend was aborted, as opposed to a device
> failing to suspend.
> 
> Without these message adjustments one can end up with a kernel log that says
> that a device failed to suspend with no actual device suspend failures,
> which can be confusing to the log examiner.
> 
> Signed-off-by: Bernie Thompson <bhthompson@chromium.org>

Queued up for 3.11.

Thanks,
Rafael


> ---
>  drivers/base/power/wakeup.c | 4 +++-
>  kernel/power/suspend.c      | 2 +-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
> index 79715e7..407a2ef 100644
> --- a/drivers/base/power/wakeup.c
> +++ b/drivers/base/power/wakeup.c
> @@ -707,8 +707,10 @@ bool pm_wakeup_pending(void)
>  	}
>  	spin_unlock_irqrestore(&events_lock, flags);
>  
> -	if (ret)
> +	if (ret) {
> +		pr_info("PM: Wakeup pending, aborting suspend\n");
>  		print_active_wakeup_sources();
> +	}
>  
>  	return ret;
>  }
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index bef86d1..ece0422 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -269,7 +269,7 @@ int suspend_devices_and_enter(suspend_state_t state)
>  	suspend_test_start();
>  	error = dpm_suspend_start(PMSG_SUSPEND);
>  	if (error) {
> -		printk(KERN_ERR "PM: Some devices failed to suspend\n");
> +		pr_err("PM: Some devices failed to suspend, or early wake event detected\n");
>  		goto Recover_platform;
>  	}
>  	suspend_test_finish("suspend devices");
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
