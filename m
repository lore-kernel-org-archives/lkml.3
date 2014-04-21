Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaDUIBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 04:01:19 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34384 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaDUIBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 04:01:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=GZxUBA63k8-vAQWvoUEikCBNGNrWK87vzn=geVL3_gQ@mail.gmail.com>
References: <1397728407-13909-1-git-send-email-geert+renesas@glider.be>
	<1397728407-13909-3-git-send-email-geert+renesas@glider.be>
	<CAKohpo=GZxUBA63k8-vAQWvoUEikCBNGNrWK87vzn=geVL3_gQ@mail.gmail.com>
Date: Mon, 21 Apr 2014 10:01:13 +0200
X-Google-Sender-Auth: VAlaaMUGcYu_mrc51dfc4gt3wsU
Message-ID: <CAMuHMdV7p93j_nbyOtjKo8na02C8YYcL4DcqjY2TP=9x_se+4w@mail.gmail.com>
Subject: Re: [PATCH 3/3] cpufreq: ppc: Fix handling of non-existent clocks
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Mike Turquette <mike.turquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Mon, Apr 21, 2014 at 8:01 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 17 April 2014 15:23, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
>> If the clock doesn't exist, clk_get_rate() returns -EINVAL
>
> You clk_get_rate() isn't written well then, it should return zero.

You're right, thanks!
Once again I looked at the wrong clk_get_rate() implementation :-(
These non-CCF variants should die soon...

So the original code was correct: if the clock is not valid, freq == 0,
and thus "freq < min_cpufreq" is true.

> @Mike: I didn't see this clearly mentioned in clk.h, should we fix
> that?
>
>>, which becomes
>> a large number (freq is u32), failing the "freq < min_cpufreq" test.
>> Explicitly test for "(u32)-EINVAL" to fix this.
>
> That's a bad check. We should have done this instead:
>
> (s32)freq < 0; but that would be true for high values of clock. And that's
> why clk_get_rate() must return zero for errors.
>
>> Update the comment, and fix a grammer issue while we're at it.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> ---
>>  drivers/cpufreq/ppc-corenet-cpufreq.c |    7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
>> index 53881d78a931..7027eab814ce 100644
>> --- a/drivers/cpufreq/ppc-corenet-cpufreq.c
>> +++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
>> @@ -179,10 +179,11 @@ static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
>>                 clk = of_clk_get(data->parent, i);
>>                 freq = clk_get_rate(clk);
>>                 /*
>> -                * the clock is valid if its frequency is not masked
>> -                * and large than minimum allowed frequency.
>> +                * the clock is valid if it exists, its frequency is not
>> +                * masked, and larger than minimum allowed frequency.
>>                  */
>> -               if (freq < min_cpufreq || (mask & (1 << i)))
>> +               if (freq == (u32)-EINVAL || freq < min_cpufreq ||
>> +                   (mask & (1 << i)))
>>                         table[i].frequency = CPUFREQ_ENTRY_INVALID;
>>                 else
>>                         table[i].frequency = freq / 1000;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
