Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3ANM0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 07:26:16 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40437 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab3ANM0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 07:26:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / Runtime: Fix the twice judgement in rpm_suspend/resume()
Date: Mon, 14 Jan 2013 13:32:04 +0100
Message-ID: <2969423.iZ1VgpHf54@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358185698.1223.13.camel@cliu38-desktop-build>
References: <1358185698.1223.13.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 15, 2013 01:48:18 AM Chuansheng Liu wrote:
> 
> In function rpm_suspend/resume(), when going into the for(;;),
> the pre-condition judgement has been done, and the variable runtime_status
> are always protected by &power.lock, so it is not necessary to judge
> them again before unlock_irq &power.lock in for(;;).
> 
> This patch clean them up.

Well, I don't really think this fixes anything.  Yes, we may save one check
here and there, but the current code follows the wait_event() convention.

Thanks,
Rafael


> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  drivers/base/power/runtime.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index 3148b10..32d6497 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -377,14 +377,14 @@ static int rpm_suspend(struct device *dev, int rpmflags)
>  		for (;;) {
>  			prepare_to_wait(&dev->power.wait_queue, &wait,
>  					TASK_UNINTERRUPTIBLE);
> -			if (dev->power.runtime_status != RPM_SUSPENDING)
> -				break;
>  
>  			spin_unlock_irq(&dev->power.lock);
>  
>  			schedule();
>  
>  			spin_lock_irq(&dev->power.lock);
> +			if (dev->power.runtime_status != RPM_SUSPENDING)
> +				break;
>  		}
>  		finish_wait(&dev->power.wait_queue, &wait);
>  		goto repeat;
> @@ -557,15 +557,15 @@ static int rpm_resume(struct device *dev, int rpmflags)
>  		for (;;) {
>  			prepare_to_wait(&dev->power.wait_queue, &wait,
>  					TASK_UNINTERRUPTIBLE);
> -			if (dev->power.runtime_status != RPM_RESUMING
> -			    && dev->power.runtime_status != RPM_SUSPENDING)
> -				break;
>  
>  			spin_unlock_irq(&dev->power.lock);
>  
>  			schedule();
>  
>  			spin_lock_irq(&dev->power.lock);
> +			if (dev->power.runtime_status != RPM_RESUMING
> +			    && dev->power.runtime_status != RPM_SUSPENDING)
> +				break;
>  		}
>  		finish_wait(&dev->power.wait_queue, &wait);
>  		goto repeat;
> @@ -989,15 +989,15 @@ static void __pm_runtime_barrier(struct device *dev)
>  		for (;;) {
>  			prepare_to_wait(&dev->power.wait_queue, &wait,
>  					TASK_UNINTERRUPTIBLE);
> -			if (dev->power.runtime_status != RPM_SUSPENDING
> -			    && dev->power.runtime_status != RPM_RESUMING
> -			    && !dev->power.idle_notification)
> -				break;
>  			spin_unlock_irq(&dev->power.lock);
>  
>  			schedule();
>  
>  			spin_lock_irq(&dev->power.lock);
> +			if (dev->power.runtime_status != RPM_SUSPENDING
> +			    && dev->power.runtime_status != RPM_RESUMING
> +			    && !dev->power.idle_notification)
> +				break;
>  		}
>  		finish_wait(&dev->power.wait_queue, &wait);
>  	}
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
