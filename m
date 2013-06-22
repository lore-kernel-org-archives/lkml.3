Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab3FVVR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 17:17:29 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47207 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab3FVVR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 17:17:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: pavel@ucw.cz, len.brown@intel.com, gregkh@linuxfoundation.org,
        airlied@linux.ie, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH 1/2] power: add new interface to return pm_transition state
Date: Sat, 22 Jun 2013 23:26:50 +0200
Message-ID: <4133846.I1XZFprb5V@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371931874-3220-1-git-send-email-shuah.kh@samsung.com>
References: <1371931874-3220-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 22, 2013 02:11:14 PM Shuah Khan wrote:
> Add a new interface get_pm_transition() to return pm_transition state.
> This interface is intended to be used from dev_pm_ops class and type
> suspend interfaces that call legacy pm ops driver suspend interfaces.
> Legacy suspend pm_ops take pm_message_t as a parameter.
> 
> e.g: drm_class_suspend() calls into driver suspend routines
> via drm_dev->driver->suspend(drm_dev, state).
> 
> Once drm_class_suspend() is converted to dev_pm_ops, it will no longer
> have access to pm_transition which it has to pass into driver legacy
> suspend calls. get_pm_transition() interface addresses this need.

That shouldn't be necessary because each transition has its own callback
in strict dev_pm_ops.

Thanks,
Rafael


> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  drivers/base/power/main.c |   17 +++++++++++++++++
>  include/linux/pm.h        |    3 +++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index c2132b8..3e2e09d 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -57,6 +57,23 @@ static pm_message_t pm_transition;
>  static int async_error;
>  
>  /**
> + * get_pm_transition - return pm_transition state.
> + * This interface is intended to be used from dev_pm_ops class and type
> + * suspend interfaces that call legacy pm ops driver suspend interfaces.
> + * Legacy suspend pm_ops take pm_message_t as a parameter.
> + * e.g: drm_class_suspend() calls into driver suspend routines
> + * via drm_dev->driver->suspend(drm_dev, state).
> + * Once drm_class_suspend() is converted to dev_pm_ops, it will no longer
> + * have access to pm_transition which it has to pass into driver legacy
> + * suspend calls. get_pm_transition() interface addresses this need.
> +*/
> +pm_message_t get_pm_transition()
> +{
> +	return pm_transition;
> +}
> +EXPORT_SYMBOL_GPL(get_pm_transition);
> +
> +/**
>   * device_pm_sleep_init - Initialize system suspend-related device fields.
>   * @dev: Device object being initialized.
>   */
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index a224c7f..46f3252 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -63,6 +63,9 @@ typedef struct pm_message {
>  	int event;
>  } pm_message_t;
>  
> +/* drivers/base/power/main.c */
> +extern pm_message_t get_pm_transition(void);
> +
>  /**
>   * struct dev_pm_ops - device PM callbacks
>   *
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
