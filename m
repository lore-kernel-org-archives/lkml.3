Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaLXQ6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:58:39 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34466 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaLXQ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:58:38 -0500
Message-ID: <549AF0AD.4070209@ti.com>
Date: Wed, 24 Dec 2014 10:58:21 -0600
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
Subject: Re: [PATCH 4/4] cpufreq-dt: defer probing if OPP table is not ready
References: <1418771379-24369-1-git-send-email-dtor@chromium.org>	<1418771379-24369-5-git-send-email-dtor@chromium.org> <CAKohpokj=u-VhNsW1ZoRsjjPEioMO6FqzVEL3y-7vDCt07cjKw@mail.gmail.com>
In-Reply-To: <CAKohpokj=u-VhNsW1ZoRsjjPEioMO6FqzVEL3y-7vDCt07cjKw@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 10:37 PM, Viresh Kumar wrote:
> On 17 December 2014 at 04:39, Dmitry Torokhov <dtor@chromium.org> wrote:
>> cpufreq-dt driver supports mode when OPP table is provided by platform
>> code and not device tree. However on certain platforms code that fills
>> OPP table may run after cpufreq driver tries to initialize, so let's
>> report -EPROBE_DEFER if we do not find any entires in OPP table for the
>> CPU.
>>
>> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
>> ---
>>  drivers/cpufreq/cpufreq-dt.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/cpufreq/cpufreq-dt.c b/drivers/cpufreq/cpufreq-dt.c
>> index f56147a..fde97d6 100644
>> --- a/drivers/cpufreq/cpufreq-dt.c
>> +++ b/drivers/cpufreq/cpufreq-dt.c
>> @@ -211,6 +211,17 @@ static int cpufreq_init(struct cpufreq_policy *policy)
>>         /* OPPs might be populated at runtime, don't check for error here */
>>         of_init_opp_table(cpu_dev);
>>
>> +       /*
>> +        * But we need OPP table to function so if it is not there let's
>> +        * give platform code chance to provide it for us.
>> +        */
>> +       ret = dev_pm_opp_get_opp_count(cpu_dev);
>> +       if (ret <= 0) {
>> +               pr_debug("OPP table is not ready, deferring probe\n");
>> +               ret = -EPROBE_DEFER;
>> +               goto out_free_opp;
Umm.. why would I be here? because of_init_opp_table(cpu_dev) did not
find any OPPs at all. but that is OK, coz, we expect dynamic addition
of OPPs by someone else... now,

case 1:
if I did have few OPPs in DT (of_init_opp_table) and cpufreq_init gets
called *before* my dynamic OPPs are added(example based on efuse
entries) -> I'd already have built my dev_pm_opp_init_cpufreq_table
and that wont be accurate. but at that point dev_pm_opp_get_opp_count
cant fail either.. and if cpufreq_init was called *after* dynamic OPPs
are added - correct table, AND dev_pm_opp_get_opp_count wont fail either.

case 2:
If I had 0 OPPs in DT (of_init_opp_table fails) and cpufreq_init gets
called *before* my dynamic OPPs are added(example based on efuse
entries) -> doing a goto out_free_opp and of_free_opp_table is of no
use at all..

case 3:
If I had 0 OPPs in DT (of_init_opp_table fails) and cpufreq_init gets
called *after* my dynamic OPPs are added(example based on efuse
entries) -> I wont have error dev_pm_opp_get_opp_count.

So, you'd better want to introduce an intermediate goto for of_node_put

Also, please use dev_dbg instead of pr_*, since you already have
cpu_dev pointer.

>> +       }
>> +
>>         priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>>         if (!priv) {
>>                 ret = -ENOMEM;
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 


-- 
Regards,
Nishanth Menon
