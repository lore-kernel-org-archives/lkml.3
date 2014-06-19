Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934119AbaFSRHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:07:30 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:48055 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbaFSRH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:07:27 -0400
MIME-Version: 1.0
In-Reply-To: <53A030DB.3090009@linaro.org>
References: <1401903034-20074-1-git-send-email-dianders@chromium.org>
	<53A030DB.3090009@linaro.org>
Date: Thu, 19 Jun 2014 10:07:26 -0700
X-Google-Sender-Auth: bvNias8uLCHvbbQwUpjYSR6sIrU
Message-ID: <CAD=FV=X+Wdkm60OU4Mh+0YWhAs6M2gLTNoTm=3pNp+Za7Haj8w@mail.gmail.com>
Subject: Re: [PATCH 1/3] clocksource: exynos_mct: Fix ftrace
From: Doug Anderson <dianders@chromium.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Chirantan Ekbote <chirantan@chromium.org>,
        David Riley <davidriley@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On Tue, Jun 17, 2014 at 5:13 AM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> On 06/04/2014 07:30 PM, Doug Anderson wrote:
>>
>> In (93bfb76 clocksource: exynos_mct: register sched_clock callback) we
>> supported using the MCT as a scheduler clock.  We properly marked
>> exynos4_read_sched_clock() as notrace.  However, we then went and
>> called another function that _wasn't_ notrace.  That means if you do:
>>
>>    cd /sys/kernel/debug/tracing/
>>    echo function_graph > current_tracer
>>
>> You'll get a crash.
>>
>> Fix this (but still let other readers of the MCT be trace-enabled) by
>> adding an extra function.  It's important to keep other users of MCT
>> traceable because the MCT is actually quite slow.
>
>
> Thanks for the explanation in the other email.
>
> I think the last sentence is a bit confusing because you are implicitly
> saying you need these traces to investigate why the timer is slow which is
> referring to something not related to this fix.

Done

>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>   drivers/clocksource/exynos_mct.c | 9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/clocksource/exynos_mct.c
>> b/drivers/clocksource/exynos_mct.c
>> index 8d64200..ba3a683 100644
>> --- a/drivers/clocksource/exynos_mct.c
>> +++ b/drivers/clocksource/exynos_mct.c
>> @@ -165,7 +165,7 @@ static void exynos4_mct_frc_start(u32 hi, u32 lo)
>>         exynos4_mct_write(reg, EXYNOS4_MCT_G_TCON);
>>   }
>>
>> -static cycle_t exynos4_frc_read(struct clocksource *cs)
>> +static inline cycle_t notrace _exynos4_frc_read(void)
>
>
> Why inline ?

Somehow I thought that without the "inline" that somehow
exynos4_frc_read() would not be traceable.  ...but this makes no sense
so I've removed.
