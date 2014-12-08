Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaLHI6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:58:03 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:36603 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaLHI6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:58:01 -0500
MIME-Version: 1.0
In-Reply-To: <1555621726.710701418024675477.JavaMail.weblogic@epmlwas04c>
References: <1555621726.710701418024675477.JavaMail.weblogic@epmlwas04c>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Mon, 8 Dec 2014 09:57:39 +0100
X-Google-Sender-Auth: cdtKmg8anKSNZKSp2dzQy0s50ks
Message-ID: <CAAObsKDmWDez5tRNa=zGuCDhM+FNgeXOUCygpjeQ-eyK=4Kq9g@mail.gmail.com>
Subject: Re: [RFC RESEND 0/3] Add watermark support to devfreq
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Arto Merilainen <amerilainen@nvidia.com>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "javier.martinez@collabora.co.uk" <javier.martinez@collabora.co.uk>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "srasal@nvidia.com" <srasal@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 December 2014 at 08:44, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
>> (Sorry for the spam. I am resending the series because I noted that
>> some of the email addresses were mistyped)
>>
>> Currently main mechanism to implement scaling using devfreq is
>> polling and the device profile is free to set polling interval.
>> However, in many cases this approach is not optimal; We may
>> unnecessarily use CPU time to determine load on engine that
>> is idle most of time - or we may simply read load when we
>> already know that the device is busy.
>>
>> In some cases a device itself has counters to track its activity
>> and possibility to raise interrupts when load goes above or below
>> certain threshold.
>>
>> This series adds support for watermark events to devfreq and
>> introduces two example governors. The first patch adds two
>> callbacks to the device profile (for setting watermark) and
>> adds a new function call to devfreq that informs of crossed
>> watermark.
>>
>> The added governors demonstrate usage of the new API. The first
>> governor (watermark simple) sets device to trigger low watermark
>> event when load goes below 10% and high watermark interrupt when
>> the load goes above 60%. Watermark active tries to keep load at
>> certain level and it actively sets thresholds based on the
>> frequency table in order get interrupts only when the load value
>> would affect to the current frequency in re-estimation.
>
> Hi Arto,
>
>
> Please let me start with somewhat naive high-level question:
>   What do you mean by watermark in this context?
> Is it a product name of yours (interrupt-based PMU, I presume)?
> Or does watermark have another semantics that I am not aware of?
> Or do you really mean something like
>   http://en.wikipedia.org/wiki/Digital_watermarking

The watermark term is borrowed here from queues. The high and low
watermarks define the boundaries within the load has to be contained.
If the load is above or below the watermarks, a more suitable
frequency has to be found.

Regards,

Tomeu

> Other itching points include:
> - devfreq_watermark_event() was declared but has never been used.
>     Who is supposed to call this function?
> - Is enum watermark_type supposed to be used out of /drivers/devfreq/* ?
>     Otherwise, please move it inside /drivers/devfreq/governor.h
>     (I guess it is to be used inside corresponding governors only)
> - Could you please watermark-specific interfaces (set_high/low_wmark) into
>     its own public header file? (e.g., /include/linux/devfreq/governor_wmark.h)
>   I think we can create another (governor_simpleondemand.h) in there as well
>     in order to have threshold values configured by device drivers.
>   Adding governor-specific configurations into devfreq.h seems not
>     appropriate especially when we expect that we may need many different
>     governors.
>
>   OR..
>
>   This seems that you can keep set_h/l_wmark functions exposed to
>     drivers/devfreq/* only. Therefore, having /drivers/devfreq/governor_wmark.h
>     should be sufficient as well, which should be more neat than the above.
>   The callbacks are to be defined by the devfreq drivers, aren't they?
>
> - The event name, "DEVFREQ_GOV_WMARK", defined in governor.h, seems to be
>     more appropriate if it is named "DEVFREQ_GOV_INTERNAL" as we won't need
>     to define event names for each govornor's internal needs.
>
>   OR.. for more generality,
>     we may define a macro like:
>
> #define DEVFREQ_GOV_INTERNAL(value)     ((0x1 << 31) | (value))
> #define GET_DEVFREQ_GOV_INTERNAL(event) ((event) & ~(0x1 << 31))
>
> - In general, I would love to see governors with minimal intervention on
>     the framework core/main code, especially when it is not beneficial to
>     other governors. Unlike cpufreq, we may contain many different types of
>     devices in devfreq, which has the potential to accompany many different
>     governors.
>
>
> Cheers,
> MyungJoo.
>
>>
>> Arto Merilainen (1):
>>   PM / devfreq: Add watermark active governor
>>
>> Shridhar Rasal (2):
>>   PM / devfreq: Add watermark events
>>   PM / devfreq: Add watermark simple governor
>>
>>  drivers/devfreq/Kconfig                 |  18 +++
>>  drivers/devfreq/Makefile                |   2 +
>>  drivers/devfreq/devfreq.c               |  19 +++
>>  drivers/devfreq/governor.h              |   1 +
>>  drivers/devfreq/governor_wmark_active.c | 276 ++++++++++++++++++++++++++++++++
>>  drivers/devfreq/governor_wmark_simple.c | 245 ++++++++++++++++++++++++++++
>>  include/linux/devfreq.h                 |  26 +++
>>  7 files changed, 587 insertions(+)
>>  create mode 100644 drivers/devfreq/governor_wmark_active.c
>>  create mode 100644 drivers/devfreq/governor_wmark_simple.c
>>
>> --
>> 1.8.1.5
>>
