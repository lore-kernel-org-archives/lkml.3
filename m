Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbaFYQdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:33:36 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:55868 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbaFYQde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:33:34 -0400
MIME-Version: 1.0
In-Reply-To: <02e701cf9066$7332b280$59981780$@samsung.com>
References: <1403654093-24134-1-git-send-email-dianders@chromium.org>
	<02e701cf9066$7332b280$59981780$@samsung.com>
Date: Wed, 25 Jun 2014 09:33:32 -0700
X-Google-Sender-Auth: MSmqn7o85GYM_QZ--7K_fH_Nog8
Message-ID: <CAD=FV=WSuxbTg2g-Cb79fFQKV4+_Gtc4PUQ4poovNM0eUkkMeg@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: exynos5: Properly use the "noirq" variants of suspend/resume
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Tomasz Figa <tomasz.figa@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        naveen krishna <ch.naveen@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Simon Glass <sjg@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin,

On Wed, Jun 25, 2014 at 4:13 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Doug Anderson wrote:
>>
>> The original code for the exynos i2c controller registered for the
>> "noirq" variants.  However during review feedback it was moved to
>> SIMPLE_DEV_PM_OPS without anyone noticing that it meant we were no
>> longer actually "noirq" (despite functions named
>> exynos5_i2c_suspend_noirq and exynos5_i2c_resume_noirq).
>>
>> i2c controllers that might have wakeup sources on them seem to need to
>> resume at noirq time so that the individual drivers can actually read
>> the i2c bus to handle their wakeup.
>>
>> NOTE: I took the original review feedback from Wolfram and added
>> poweroff, thaw, freeze, restore.
>>
> Yeah I'm not sure except .suspend_noirq and .resume_noirq but I'm fine if
> Wolfram suggested ;-)

Sorry, I didn't mean to imply that Wolfram suggested the "noirq" versions.

Specifically in <https://lkml.org/lkml/2013/9/8/133> Naveen had:

> +static const struct dev_pm_ops exynos5_i2c_dev_pm_ops = {
> + .suspend_noirq = exynos5_i2c_suspend_noirq,
> + .resume_noirq = exynos5_i2c_resume_noirq,
> +};
> +
> +#define EXYNOS5_DEV_PM_OPS (&exynos5_i2c_dev_pm_ops)
> +#else
> +#define EXYNOS5_DEV_PM_OPS NULL
> +#endif

And Wolfram said:

> Isn't there a macro for this? SIMPLE_DEV_PM_OPS*? Not sure, I always mix
> them up...

That had the side effect of getting freeze, restore, ...

Ah, I also see that Felipe Balbi was the one that gave earlier
feedback about this also at <https://lkml.org/lkml/2012/11/27/262>.
He said "you need to define poweroff, thaw, freeze, restore."


>> This patch has only been compile-tested since I don't have all the
>> patches needed to make my machine using this i2c driver actually
>> suspend/resume.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>> Changes in v2:
>> - Added missing CONFIG_PM_SLEEP
>>
>>  drivers/i2c/busses/i2c-exynos5.c | 12 ++++++++++--
>>  1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-
>> exynos5.c
>> index 63d2292..348b1cd 100644
>> --- a/drivers/i2c/busses/i2c-exynos5.c
>> +++ b/drivers/i2c/busses/i2c-exynos5.c
>> @@ -789,8 +789,16 @@ static int exynos5_i2c_resume_noirq(struct device *dev)
>>  }
>>  #endif
>>
>> -static SIMPLE_DEV_PM_OPS(exynos5_i2c_dev_pm_ops, exynos5_i2c_suspend_noirq,
>> -                      exynos5_i2c_resume_noirq);
>> +const struct dev_pm_ops exynos5_i2c_dev_pm_ops = {
>
> Maybe static const struct...?

Duh, right.  Fixing and will spin.


>> +#ifdef CONFIG_PM_SLEEP
>> +     .suspend_noirq = exynos5_i2c_suspend_noirq,
>> +     .resume_noirq = exynos5_i2c_resume_noirq,
>> +     .freeze_noirq = exynos5_i2c_suspend_noirq,
>> +     .thaw_noirq = exynos5_i2c_resume_noirq,
>> +     .poweroff_noirq = exynos5_i2c_suspend_noirq,
>> +     .restore_noirq = exynos5_i2c_resume_noirq,
>> +#endif
>> +};
>>
>>  static struct platform_driver exynos5_i2c_driver = {
>>       .probe          = exynos5_i2c_probe,
>> --
>> 2.0.0.526.g5318336
>
> Others look good to me,
>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>
> Thanks,
> Kukjin
>
