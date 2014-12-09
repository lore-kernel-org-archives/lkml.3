Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbaLIN0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:26:05 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:64438 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892AbaLIN0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:26:03 -0500
MIME-Version: 1.0
In-Reply-To: <1417786892-477-1-git-send-email-amerilainen@nvidia.com>
References: <1417786892-477-1-git-send-email-amerilainen@nvidia.com>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Tue, 9 Dec 2014 14:25:41 +0100
X-Google-Sender-Auth: xwDBLwvgCU7BXBxIoAg925i9MsY
Message-ID: <CAAObsKBA9ckYYB89q0QLprx2zJbVFcH3=5qvKiCsPaatqe58dQ@mail.gmail.com>
Subject: Re: [RFC RESEND 0/3] Add watermark support to devfreq
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "srasal@nvidia.com" <srasal@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 December 2014 at 14:41, Arto Merilainen <amerilainen@nvidia.com> wrote:
> (Sorry for the spam. I am resending the series because I noted that
> some of the email addresses were mistyped)
>
> Currently main mechanism to implement scaling using devfreq is
> polling and the device profile is free to set polling interval.
> However, in many cases this approach is not optimal; We may
> unnecessarily use CPU time to determine load on engine that
> is idle most of time - or we may simply read load when we
> already know that the device is busy.
>
> In some cases a device itself has counters to track its activity
> and possibility to raise interrupts when load goes above or below
> certain threshold.

Hi Arto,

this is very interesting stuff, thanks for sending.

Regarding the question of whether the ACTMON driver should use this
generic governor, I think it comes down to whether we are able to
reach the best compromise between performance and power usage with it.

I see that the logic of the downstream ACTMON driver is much more
complex, as it takes into account the activity caused by the CPU
complex and gives it more weight than the total. It also sets
watermarks for the running average over the last 128 samples. The
frequency of the CPU is also taken into account.

Besides that, there's several factors and adjustments that I can only
think that have been determined through experimentation and
measurement and that in that case are very likely to be specific to a
given board and/or SoC.

It also takes into account consecutive watermark breaches and boosts
the frequency accordingly.

It would be great if you could ask within NVIDIA for the rationale
behind the way of calculating the target frequency downstream, as it
would allow us to better discern what can be made generic and what
belongs to the ACTMON driver itself.

It would be also good if we can find other SoCs that have similar
functionality, so we can make sure that what we end up adding to the
generic framework is of use to others.

Besides the above general points, two more specific comments:

* why not use the opp freq table from the DT (operating-points)
instead of freq_table?

* why having wmark_simple at all? And if we don't actually want it,
guess we can drop the event type arg?

Thanks,

Tomeu


> This series adds support for watermark events to devfreq and
> introduces two example governors. The first patch adds two
> callbacks to the device profile (for setting watermark) and
> adds a new function call to devfreq that informs of crossed
> watermark.
>
> The added governors demonstrate usage of the new API. The first
> governor (watermark simple) sets device to trigger low watermark
> event when load goes below 10% and high watermark interrupt when
> the load goes above 60%. Watermark active tries to keep load at
> certain level and it actively sets thresholds based on the
> frequency table in order get interrupts only when the load value
> would affect to the current frequency in re-estimation.
>
> Arto Merilainen (1):
>   PM / devfreq: Add watermark active governor
>
> Shridhar Rasal (2):
>   PM / devfreq: Add watermark events
>   PM / devfreq: Add watermark simple governor
>
>  drivers/devfreq/Kconfig                 |  18 +++
>  drivers/devfreq/Makefile                |   2 +
>  drivers/devfreq/devfreq.c               |  19 +++
>  drivers/devfreq/governor.h              |   1 +
>  drivers/devfreq/governor_wmark_active.c | 276 ++++++++++++++++++++++++++++++++
>  drivers/devfreq/governor_wmark_simple.c | 245 ++++++++++++++++++++++++++++
>  include/linux/devfreq.h                 |  26 +++
>  7 files changed, 587 insertions(+)
>  create mode 100644 drivers/devfreq/governor_wmark_active.c
>  create mode 100644 drivers/devfreq/governor_wmark_simple.c
>
> --
> 1.8.1.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
