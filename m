Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab3KTIDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:03:15 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:42864 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3KTIDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:03:12 -0500
MIME-Version: 1.0
In-Reply-To: <61fdca8bd1502d7319bfaad29583013f0fbec6b4.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
	<61fdca8bd1502d7319bfaad29583013f0fbec6b4.1380815504.git.viresh.kumar@linaro.org>
Date: Wed, 20 Nov 2013 13:33:12 +0530
Message-ID: <CAKohpo=+W9vTcfRcH=6t0Bbct2+GJYge60ZoQZwYuZ=An6UCtQ@mail.gmail.com>
Subject: Re: [PATCH V2 13/16] cpuidle: free all state kobjects from cpuidle_free_state_kobj()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 October 2013 21:26, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Loop for states is currently present on callers side and so is replicated at
> several places. It would be better to move that inside cpuidle_free_state_kobj()
> instead.
>
> This patch does it.
>
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpuidle/sysfs.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)

Hi Rafael,

You missed applying this one?

> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> index e918b6d..ade31a9 100644
> --- a/drivers/cpuidle/sysfs.c
> +++ b/drivers/cpuidle/sysfs.c
> @@ -378,12 +378,17 @@ static struct kobj_type ktype_state_cpuidle = {
>         .release = cpuidle_state_sysfs_release,
>  };
>
> -static inline void cpuidle_free_state_kobj(struct cpuidle_device *device, int i)
> +static inline void cpuidle_free_state_kobj(struct cpuidle_device *device,
> +               int count)
>  {
> -       kobject_put(&device->kobjs[i]->kobj);
> -       wait_for_completion(&device->kobjs[i]->kobj_unregister);
> -       kfree(device->kobjs[i]);
> -       device->kobjs[i] = NULL;
> +       int i;
> +
> +       for (i = 0; i < count; i++) {
> +               kobject_put(&device->kobjs[i]->kobj);
> +               wait_for_completion(&device->kobjs[i]->kobj_unregister);
> +               kfree(device->kobjs[i]);
> +               device->kobjs[i] = NULL;
> +       }
>  }
>
>  /**
> @@ -419,8 +424,7 @@ static int cpuidle_add_state_sysfs(struct cpuidle_device *device)
>         return 0;
>
>  error_state:
> -       for (i = i - 1; i >= 0; i--)
> -               cpuidle_free_state_kobj(device, i);
> +       cpuidle_free_state_kobj(device, i);
>         return ret;
>  }
>
> @@ -430,10 +434,7 @@ error_state:
>   */
>  static void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
>  {
> -       int i;
> -
> -       for (i = 0; i < device->state_count; i++)
> -               cpuidle_free_state_kobj(device, i);
> +       cpuidle_free_state_kobj(device, device->state_count);
>  }
>
>  #ifdef CONFIG_CPU_IDLE_MULTIPLE_DRIVERS
> --
> 1.7.12.rc2.18.g61b472e
>
