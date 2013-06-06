Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab3FFI1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:27:47 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:49764 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab3FFI1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:27:35 -0400
MIME-Version: 1.0
In-Reply-To: <1370502472-7249-2-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1370502472-7249-2-git-send-email-l.majewski@samsung.com>
Date: Thu, 6 Jun 2013 13:57:34 +0530
Message-ID: <CAKohpokYdwutUX-zkHLs3bKmLg=Fb7WvKcwvfek9Q8k=XXs3bw@mail.gmail.com>
Subject: Re: [PATCH 1/5] cpufreq: Define cpufreq_set_drv_attr_files() to add
 per CPU sysfs attributes
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 June 2013 12:37, Lukasz Majewski <l.majewski@samsung.com> wrote:

> Subject: cpufreq: Define cpufreq_set_drv_attr_files() to add per CPU sysfs attributes

Its not per-cpu. We just add it for policy->cpu and other routines
actually create links.

> The cpufreq_set_drv_attr_files() function creates sysfs file entry for
> each available CPU. With it in place it is possible to add different
> set of attributes without code duplication.

Not for each available cpu but are linked to a policy->kobj and so
shows up on each policy->cpus.

> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> ---
>  drivers/cpufreq/cpufreq.c |   23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 1b8a48e..ca74e27 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -730,12 +730,23 @@ static int cpufreq_add_dev_symlink(unsigned int cpu,
>         return ret;
>  }
>
> +static int cpufreq_set_drv_attr_files(struct cpufreq_policy *policy,
> +                                     struct freq_attr **drv_attr)
> +{
> +       while ((drv_attr) && (*drv_attr)) {
> +               if (sysfs_create_file(&policy->kobj, &((*drv_attr)->attr)))
> +                       return 1;

You are changing the semantics here. We used to return error
value from sysfs_create_file() and you are returning 1.

> +               drv_attr++;

If drv_attr was valid initially, then drv_attr++ can't make it NULL.
So, we don't need to check validity of drv_attr for every loop.
