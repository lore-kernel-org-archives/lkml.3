Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbaJXNn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:43:57 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57051 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756522AbaJXNny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:43:54 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Imre Deak <imre.deak@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PM / Sleep: fix recovery during s2ram/hibernation
Date: Fri, 24 Oct 2014 16:04:24 +0200
Message-ID: <6868563.CWP0SXTtWm@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414137549-30005-1-git-send-email-imre.deak@intel.com>
References: <1414136593-25329-1-git-send-email-imre.deak@intel.com> <1414137549-30005-1-git-send-email-imre.deak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 24, 2014 10:59:09 AM Imre Deak wrote:
> Atm, if one of the dev_pm_ops::freeze callbacks fails during the QUIESCE
> phase we don't rollback things correctly calling the thaw and complete
> callbacks. This could leave some devices in a suspended state in case of
> an error during resuming from hibernation.
> 
> Also if an asynchronous suspend_late or freeze_late callback fails
> during the SUSPEND, FREEZE or QUIESCE phases we don't propagate the
> corresponding error correctly, in effect ignoring the error and
> continuing the suspend-to-ram/hibernation. During suspend-to-ram this
> could leave some devices without a valid saved context, leading to a
> failure to reinitialize them during resume. During hibernation this
> could leave some devices active interfeering with the creation /
> restoration of the hibernation image. Also this could leave the
> corresponding devices without a valid saved context and failure to
> reinitialize them during resume.
> 
> v2:
> - call dpm_resume_end() unconditionally, it's guaranteed that error
>   is non-zero
> 
> Signed-off-by: Imre Deak <imre.deak@intel.com>

These are two unrelated fixes, so please send them as two patches.

> ---
>  drivers/base/power/main.c | 2 ++
>  kernel/power/hibernate.c  | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 4497319..9717d5f 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -1266,6 +1266,8 @@ int dpm_suspend_late(pm_message_t state)
>  	}
>  	mutex_unlock(&dpm_list_mtx);
>  	async_synchronize_full();
> +	if (!error)
> +		error = async_error;
>  	if (error) {
>  		suspend_stats.failed_suspend_late++;
>  		dpm_save_failed_step(SUSPEND_SUSPEND_LATE);

So the above will be the first fix and the below will be the second one.

> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index a9dfa79..594ee7f 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -502,8 +502,9 @@ int hibernation_restore(int platform_mode)
>  	error = dpm_suspend_start(PMSG_QUIESCE);
>  	if (!error) {
>  		error = resume_target_kernel(platform_mode);
> -		dpm_resume_end(PMSG_RECOVER);
> +		BUG_ON(!error);

Why BUG_ON()?  Is crashing the kernel necessary here?

>  	}
> +	dpm_resume_end(PMSG_RECOVER);
>  	pm_restore_gfp_mask();
>  	resume_console();
>  	pm_restore_console();
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
