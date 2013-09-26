Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab3IZAZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 20:25:31 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:47810 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3IZAZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 20:25:29 -0400
MIME-Version: 1.0
In-Reply-To: <564c8b1f073dc396b54866a2220b09b7869289f4.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
	<564c8b1f073dc396b54866a2220b09b7869289f4.1379779777.git.viresh.kumar@linaro.org>
Date: Wed, 25 Sep 2013 17:25:28 -0700
Message-ID: <CAMbhsRQRGGpShFiTBP7OZ8txhKG_i-1_s=AAGPQx+JzTkW=0Lg@mail.gmail.com>
Subject: Re: [PATCH 14/21] cpuidle: coupled: don't compare cpu masks unnecessarily
From: Colin Cross <ccross@google.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 6:21 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> In cpuidle_coupled_register_device() we do following:
>         if (WARN_ON(!cpumask_equal(&dev->coupled_cpus, &coupled->coupled_cpus)))
>                 coupled->prevent++;
>
> This is only required to be done when we are using 'coupled' from an existing
> cpuidle_device and not when we have just done this:
>
>         coupled->coupled_cpus = dev->coupled_cpus
>
> So, move this compare statement to the right place.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

I don't agree with this.  This patch is a tiny optimization in code
that is rarely called, and it moves a final sanity check somewhere
that it might get missed if the code were later refactored.

> ---
>  drivers/cpuidle/coupled.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> index e952936..19a89eb 100644
> --- a/drivers/cpuidle/coupled.c
> +++ b/drivers/cpuidle/coupled.c
> @@ -642,6 +642,10 @@ int cpuidle_coupled_register_device(struct cpuidle_device *dev)
>                 other_dev = per_cpu(cpuidle_devices, cpu);
>                 if (other_dev && other_dev->coupled) {
>                         coupled = other_dev->coupled;
> +
> +                       if (WARN_ON(!cpumask_equal(&dev->coupled_cpus,
> +                                               &coupled->coupled_cpus)))
> +                               coupled->prevent++;
>                         goto have_coupled;
>                 }
>         }
> @@ -655,9 +659,6 @@ int cpuidle_coupled_register_device(struct cpuidle_device *dev)
>
>  have_coupled:
>         dev->coupled = coupled;
> -       if (WARN_ON(!cpumask_equal(&dev->coupled_cpus, &coupled->coupled_cpus)))
> -               coupled->prevent++;
> -
>         cpuidle_coupled_update_online_cpus(coupled);
>
>         coupled->refcnt++;
> --
> 1.7.12.rc2.18.g61b472e
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
