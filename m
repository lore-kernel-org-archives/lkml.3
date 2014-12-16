Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaLPFcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 00:32:20 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:44980 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaLPFcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 00:32:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpo=mcG99N5q_CCua8Hdydo=ydHKD-CiTJO9SsAhLvkTJHw@mail.gmail.com>
References: <20141216001058.GA31286@dtor-ws>
	<CAKohpo=mcG99N5q_CCua8Hdydo=ydHKD-CiTJO9SsAhLvkTJHw@mail.gmail.com>
Date: Mon, 15 Dec 2014 21:32:16 -0800
Message-ID: <CAE_wzQ_Lz7pv1io6UMAXjesVeurbC=as2BuxBrA+XXkh5b+AWA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq-dt: defer probing if OPP table is not ready
From: Dmitry Torokhov <dtor@chromium.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dmitry Torokhov <dtor@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lucas Stach <l.stach@pengutronix.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 9:10 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 16 December 2014 at 05:40, Dmitry Torokhov <dtor@chromium.org> wrote:
>> cpufreq-dt driver supports mode when OPP table is provided by platform
>> code and not device tree. However on certain platforms code that fills
>> OPP table may run after cpufreq driver tries to initialize, so let's
>> report -EPROBE_DEFER if we do not find any entires in OPP table for the
>> CPU.
>>
>> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
>> ---
>>  drivers/cpufreq/cpufreq-dt.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/drivers/cpufreq/cpufreq-dt.c b/drivers/cpufreq/cpufreq-dt.c
>> index f56147a..4f874fa 100644
>> --- a/drivers/cpufreq/cpufreq-dt.c
>> +++ b/drivers/cpufreq/cpufreq-dt.c
>> @@ -211,6 +211,19 @@ static int cpufreq_init(struct cpufreq_policy *policy)
>>         /* OPPs might be populated at runtime, don't check for error here */
>>         of_init_opp_table(cpu_dev);
>>
>> +       /*
>> +        * But we need OPP table to function so if it is not there let's
>> +        * give platform code chance to provide it for us.
>> +        */
>> +       rcu_read_lock();
>> +       ret = dev_pm_opp_get_opp_count(cpu_dev);
>> +       rcu_read_unlock();
>> +       if (ret <= 0) {
>> +               pr_debug("OPP table is not ready, deferring probe\n");
>> +               ret = -EPROBE_DEFER;
>> +               goto out_free_opp;
>
> Hmm, so we are trying to free opps while we failed to find one.
>
> Are you sure you have tested this on one such platform where we
> fail here?

Not with the linux-next, but generally yes.

>
> Because this is what I see:
>
> void of_free_opp_table(struct device *dev)
> {
>         struct device_opp *dev_opp;
>         struct dev_pm_opp *opp, *tmp;
>
>         /* Check for existing list for 'dev' */
>         dev_opp = find_device_opp(dev);
>         if (WARN(IS_ERR(dev_opp), "%s: dev_opp: %ld\n", dev_name(dev),
>                  PTR_ERR(dev_opp)))
>                 return;
>
>         ...
> }
>
>
> And we probably will hit this WARN(), wouldn't we ?

Yes we will. Which simply means that this WARN is stupid. We also will
hit it if there is no opp table and the allocation below fails; or if
it succeeds then dev_pm_opp_init_cpufreq_table() will fail and we'll
hit this code path again.

We should either drop that WARN() or handle -ENODEV there properly.

Thanks,
Dmitry
