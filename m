Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbaFSIaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 04:30:04 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:40084 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466AbaFSIaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 04:30:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=WHK7TDdqcAd6aVs2g8rcHJx834im_4nTKHJAkUisWq4A@mail.gmail.com>
References: <1403091060-5054-1-git-send-email-amit.daniel@samsung.com>
	<CAD=FV=WHK7TDdqcAd6aVs2g8rcHJx834im_4nTKHJAkUisWq4A@mail.gmail.com>
Date: Thu, 19 Jun 2014 13:59:59 +0530
X-Google-Sender-Auth: DA7QIUrw0b_SYEFTqhFNVjWLcuc
Message-ID: <CADGdYn6-SnwgTiOi5f8waXBStPaxndep6T6swfkuAcU4=KdcUQ@mail.gmail.com>
Subject: Re: [PATCH] clocksource: exynos-mct: Register the timer for stable udelay
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Riley <davidriley@chromium.org>,
        Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 4:47 AM, Doug Anderson <dianders@chromium.org> wrote:
> Amit,
>
> Thanks for posting!
>
> On Wed, Jun 18, 2014 at 4:31 AM, Amit Daniel Kachhap
> <amit.daniel@samsung.com> wrote:
>> This patch register the exynos mct clocksource as the current timer
>> as it has constant clock rate. This will generate correct udelay for the
>> exynos platform and avoid using unnecessary calibrated jiffies. This change
>> have been tested on exynos5420 based board.
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>
>> Patches from David Riley confirmed that udelay is broken in exynos5420.
>> Link to those patches are,
>> 1) https://patchwork.kernel.org/patch/4344911/
>> 2) https://patchwork.kernel.org/patch/4344881/
>>
>>  drivers/clocksource/exynos_mct.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
>> index 8d64200..57cb3dc 100644
>> --- a/drivers/clocksource/exynos_mct.c
>> +++ b/drivers/clocksource/exynos_mct.c
>> @@ -198,10 +198,21 @@ static u64 notrace exynos4_read_sched_clock(void)
>>         return exynos4_frc_read(&mct_frc);
>>  }
>>
>> +static struct delay_timer exynos4_delay_timer;
>> +
>> +static unsigned long exynos4_read_current_timer(void)
>> +{
>> +       return exynos4_frc_read(&mct_frc);
>
> This is terribly inefficient to read all 64-bits and then cast back to
> a 32-bit value.  Replace with:
Yes agree.
This unsigned long strangely behaves as 32 bits for arm32 and 64 bits for arm64.
So I think it better is to do something like this,
+static unsigned long exynos4_read_current_timer(void)
+{
+#ifdef ARM
+       return __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_L);
+#else /* ARM64, etc */
+       return exynos4_frc_read(&mct_frc);
+#endif
+}
+
I will post V2 version like above and see what the maintainer says.

>
> return __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_L);
>
>
>> +}
>> +
>>  static void __init exynos4_clocksource_init(void)
>>  {
>>         exynos4_mct_frc_start(0, 0);
>
> Please rebase atop (1d80415 clocksource: exynos_mct: Don't reset the
> counter during boot and resume), which is in linuxnext among other
> places.
OK will re base my patch on top of this.
>
>>
>> +       exynos4_delay_timer.read_current_timer = &exynos4_read_current_timer;
>> +       exynos4_delay_timer.freq = clk_rate;
>> +       register_current_timer_delay(&exynos4_delay_timer);
>> +
>>         if (clocksource_register_hz(&mct_frc, clk_rate))
>>                 panic("%s: can't register clocksource\n", mct_frc.name);
>
> It does seem to work for me though.  :)
thanks,

> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
