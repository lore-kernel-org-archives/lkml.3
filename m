Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaLXQmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:42:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50709 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbaLXQmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:42:33 -0500
Message-ID: <549AECEB.7020505@ti.com>
Date: Wed, 24 Dec 2014 10:42:19 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Dmitry Torokhov <dtor@chromium.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] PM / OPP: fix warning in of_free_opp_table
References: <1418771379-24369-1-git-send-email-dtor@chromium.org>	<1418771379-24369-3-git-send-email-dtor@chromium.org> <CAKohpok+_wee9HwvQqpn7HRj_9zH3EifNn0MX_1yXx=WJuK0RQ@mail.gmail.com>
In-Reply-To: <CAKohpok+_wee9HwvQqpn7HRj_9zH3EifNn0MX_1yXx=WJuK0RQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$subject:
PM / OPP: Do not warn when no OPP was ever registered in of_free_opp_table

might be more appropriate?

On 12/16/2014 10:28 PM, Viresh Kumar wrote:
> On 17 December 2014 at 04:39, Dmitry Torokhov <dtor@chromium.org> wrote:
>> Not having OPP defined for a device is not a crime, we should not splat
>> warning in this case. Also, it seems that we are ready to accept invalid
>> dev (find_device_opp will return ERR_PTR(-EINVAL) then) so let's not
>> crash in dev_name() in such case.
>>
>> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
>> ---
>>  drivers/base/power/opp.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
>> index b78c14d..413c7fe 100644
>> --- a/drivers/base/power/opp.c
>> +++ b/drivers/base/power/opp.c
>> @@ -799,9 +799,15 @@ void of_free_opp_table(struct device *dev)
>>
>>         /* Check for existing list for 'dev' */
>>         dev_opp = find_device_opp(dev);
>> -       if (WARN(IS_ERR(dev_opp), "%s: dev_opp: %ld\n", dev_name(dev),
>> -                PTR_ERR(dev_opp)))
>> +       if (IS_ERR(dev_opp)) {
>> +               int error = PTR_ERR(dev_opp);
>> +               if (error != -ENODEV)
>> +                       WARN(1, "%s: dev_opp: %ld\n",
>> +                            IS_ERR_OR_NULL(dev) ?
>> +                                       "Invalid device" : dev_name(dev),
>> +                            error);
>>                 return;
> 
> What about this:
> 
>         if (IS_ERR(dev_opp)) {
>                 int error = PTR_ERR(dev_opp);
>                 WARN(error != -ENODEV, "%s: dev_opp: %ld\n",
>                      IS_ERR_OR_NULL(dev) ?  "Invalid device" : dev_name(dev),
>                      error);
>                 return;
>         }
Adds the following build warning: I suggest changing the %ld to %d

"warning: format ‘%ld’ expects argument of type ‘long int’, but
argument 5 has type ‘int’ [-Wformat]"


This also fixes the warning I got on AM437x based platforms. test results:
1: am437x-sk: BOOT: PASS: crit=2 err=13 warn=25, CPUFreq: N/A,
CPUIdle: N/A: http://slexy.org/raw/s20MAtNEbt
 2: am437x-sk-before: BOOT: PASS: crit=2 err=13 warn=57, CPUFreq: N/A,
CPUIdle: N/A: http://slexy.org/raw/s21rZCo4cD

With the suggested changes,

Acked-by: Nishanth Menon <nm@ti.com>

> 
> We can get rid of the extra indentation level and an extra comparison check.
> 
> Otherwise:
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>


PS: I am sure you have already done some level of checks, but I
suggest using something like aiaiai or
https://github.com/nmenon/kernel_patch_verify or other solutions like
those discussed in
https://plus.google.com/112464029509057661457/posts/5LTuHHMyXLT to
help do some initial clean up of the patches..


-- 
Regards,
Nishanth Menon
