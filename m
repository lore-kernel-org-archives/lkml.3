Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaLIHRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 02:17:25 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:40750 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaLIHRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 02:17:23 -0500
MIME-Version: 1.0
In-Reply-To: <1417786892-477-2-git-send-email-amerilainen@nvidia.com>
References: <1417786892-477-1-git-send-email-amerilainen@nvidia.com> <1417786892-477-2-git-send-email-amerilainen@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 9 Dec 2014 16:17:01 +0900
Message-ID: <CAAVeFuKS7qigoL63NQHBcWKphsL9MELD_kchexBX_GiDGABidw@mail.gmail.com>
Subject: Re: [RFC RESEND 1/3] PM / devfreq: Add watermark events
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, srasal@nvidia.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 10:41 PM, Arto Merilainen <amerilainen@nvidia.com> wrote:
> From: Shridhar Rasal <srasal@nvidia.com>
>
> This patch adds support for watermark events. These events inform
> the governor that the device load has gone below (low watermark) or
> above (high watermark) certain load value.

This is definitely a useful feature to have, as it reflects what
efficient hardware does (raise an interrupt when load goes above/under
a certain threshold). In particular Tomeu's ACTMON driver would
probably greatly benefit from it.

A few comments below:

>
> Signed-off-by: Shridhar Rasal <srasal@nvidia.com>
> Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
> ---
>  drivers/devfreq/devfreq.c  | 19 +++++++++++++++++++
>  drivers/devfreq/governor.h |  1 +
>  include/linux/devfreq.h    | 26 ++++++++++++++++++++++++++
>  3 files changed, 46 insertions(+)
>
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 30b538d8cc90..8333d024132a 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -1050,6 +1050,25 @@ static struct attribute *devfreq_attrs[] = {
>  };
>  ATTRIBUTE_GROUPS(devfreq);
>
> +/**
> + * devfreq_watermark_event() - Handles watermark events
> + * @devfreq: the devfreq instance to be updated
> + * @type: type of watermark event
> + */
> +int devfreq_watermark_event(struct devfreq *devfreq, int type)

Here I suppose "type" is to be an enum watermark_type - therefore it
should probably be changed to that type instead of int.

> +{
> +       if (!devfreq)
> +               return -EINVAL;
> +
> +       if (!devfreq->governor)
> +               return -EINVAL;

Let's fold these two conditions into "if (!devfreq || !devfreq->governor)"

> +
> +       return devfreq->governor->event_handler(devfreq,
> +                               DEVFREQ_GOV_WMARK, &type);
> +}
> +EXPORT_SYMBOL(devfreq_watermark_event);
> +
> +

Extra whiteline here.

>  static int __init devfreq_init(void)
>  {
>         devfreq_class = class_create(THIS_MODULE, "devfreq");
> diff --git a/drivers/devfreq/governor.h b/drivers/devfreq/governor.h
> index fad7d6321978..fb9875388f3f 100644
> --- a/drivers/devfreq/governor.h
> +++ b/drivers/devfreq/governor.h
> @@ -24,6 +24,7 @@
>  #define DEVFREQ_GOV_INTERVAL                   0x3
>  #define DEVFREQ_GOV_SUSPEND                    0x4
>  #define DEVFREQ_GOV_RESUME                     0x5
> +#define DEVFREQ_GOV_WMARK                      0x6
>
>  /* Caution: devfreq->lock must be locked before calling update_devfreq */
>  extern int update_devfreq(struct devfreq *devfreq);
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index f1863dcd83ea..b5bf6c4fe286 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -21,6 +21,12 @@
>
>  struct devfreq;
>
> +enum watermark_type {

Change the name to devfreq_watermark_event maybe? We know it's a type
already from the context, and we should use the devfreq_ prefix to
avoid name collisions.

> +       NO_WATERMARK_EVENT = 0,
> +       HIGH_WATERMARK_EVENT = 1,
> +       LOW_WATERMARK_EVENT = 2

... and if the type is renamed to watermark_event, these could become
DEVFREQ_NO_WATERMARK, DEVFREQ_HIGH_WATERMARK, and
DEVFREQ_LOW_WATERMARK.

> +};
> +
>  /**
>   * struct devfreq_dev_status - Data given from devfreq user device to
>   *                          governors. Represents the performance
> @@ -68,6 +74,16 @@ struct devfreq_dev_status {
>   *                     status to devfreq, which is used by governors.
>   * @get_cur_freq:      The device should provide the current frequency
>   *                     at which it is operating.
> + * @set_high_wmark:    This is an optional callback to set high
> + *                     watermark for watermark event. The value is
> + *                     be scaled between 0 and 1000 where 1000 equals to
> + *                     100% load. Setting this value to 1000 disables
> + *                     the event
> + * @set_low_wmark:     This is an optional callback to set low
> + *                     watermark for watermark event. The value is
> + *                     be scaled between 0 and 1000 where 1000 equals to
> + *                     100% load. Setting this value to 0 disables the
> + *                     event.

>From the comment it is not clear whether the 0..1000 range corresponds
to the load between two frequencies in the frequencies table, or
covers the whole frequency table. I understand it is the former, but
it would be nice to explicitly state it.
