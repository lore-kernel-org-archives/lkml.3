Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab3ANOgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:36:44 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33062 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3ANOgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:36:43 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <1357624239-13938-1-git-send-email-rajagopal.venkat@linaro.org>
References: <1357624239-13938-1-git-send-email-rajagopal.venkat@linaro.org>
Date: Mon, 14 Jan 2013 23:36:38 +0900
X-Google-Sender-Auth: D0EDdkUKSNDmff-VZcpnVGda0kA
Message-ID: <CAJ0PZbTAOdQrUjefOpc2MDam1hHLjSEDLHw3VrP+9=OAbgQ8ug@mail.gmail.com>
Subject: Re: [PATCH 1/3] PM / devfreq: set min/max freq limit from freq table
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: kyungmin.park@samsung.com, mturquette@linaro.org, rjw@sisk.pl,
        patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 2:50 PM, Rajagopal Venkat
<rajagopal.venkat@linaro.org> wrote:
> Set devfreq device min and max frequency limits when device
> is added to devfreq, provided frequency table is supplied.
> This helps governors to suggest target frequency with in
> limits.
>
> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>

Could you please elaborate the benefit of the patch?

The devfreq device drivers are required to choose proper frequencies
anyway regardless which values the governors may give (hopefully by
choosing the closest value that can support the required performance).

Besides, the min/max values are to be set by userspace. Users may
enter 0 in order to express that they do not want to limit the
behaviors of governors.


Cheers,
MyungJoo.

> ---
>  drivers/devfreq/devfreq.c |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index a8f0173..5782c9b 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -69,6 +69,29 @@ static struct devfreq *find_device_devfreq(struct device *dev)
>  }
>
>  /**
> + * devfreq_set_freq_limits() - Set min and max frequency from freq_table
> + * @devfreq:   the devfreq instance
> + */
> +static void devfreq_set_freq_limits(struct devfreq *devfreq)
> +{
> +       int idx;
> +       unsigned long min = ~0, max = 0;
> +
> +       if (!devfreq->profile->freq_table)
> +               return;
> +
> +       for (idx = 0; idx < devfreq->profile->max_state; idx++) {
> +               if (min > devfreq->profile->freq_table[idx])
> +                       min = devfreq->profile->freq_table[idx];
> +               if (max < devfreq->profile->freq_table[idx])
> +                       max = devfreq->profile->freq_table[idx];
> +       }
> +
> +       devfreq->min_freq = min;
> +       devfreq->max_freq = max;
> +}
> +
> +/**
>   * devfreq_get_freq_level() - Lookup freq_table for the frequency
>   * @devfreq:   the devfreq instance
>   * @freq:      the target frequency
> @@ -476,6 +499,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
>                                                 devfreq->profile->max_state,
>                                                 GFP_KERNEL);
>         devfreq->last_stat_updated = jiffies;
> +       devfreq_set_freq_limits(devfreq);
>
>         dev_set_name(&devfreq->dev, dev_name(dev));
>         err = device_register(&devfreq->dev);
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
