Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab3LONif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 08:38:35 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:35592 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab3LONia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 08:38:30 -0500
MIME-Version: 1.0
In-Reply-To: <4229773.U5JovcREjb@amdc1227>
References: <1384515691-26299-1-git-send-email-sachin.kamat@linaro.org>
	<1384515691-26299-2-git-send-email-sachin.kamat@linaro.org>
	<4229773.U5JovcREjb@amdc1227>
Date: Sun, 15 Dec 2013 22:30:13 +0900
Message-ID: <CAKew6eVSOQaHjYj3JRhJKnozY26OkeUGhvC2usadfUqW9hyu2Q@mail.gmail.com>
Subject: Re: [RFC v2 1/4] power: asv: Add common ASV support for Samsung SoCs
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Andrew Bresticker <abrestic@google.com>,
        Doug Anderson <dianders@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

Thanks for your thorough review and nice suggestions.

[snip]
>> +}
>> +
>> +static struct asv_member *asv_get_mem(enum asv_type_id asv_type)
>
> I don't really like this enum based look-up. It's hard to define an enum
> that covers any possible existing and future platforms that would not be
> bloated with single platform specific entries. IMHO something string based
> could be more scalable.
>

Yes, I also agree string based look-up will be better. I was thinking
to convert to it,
after initial discussion over the APIs.

>> +{
>> +     struct asv_member *asv_mem;
>> +     struct asv_info *asv_info;
>> +
>> +     list_for_each_entry(asv_mem, &asv_list, node) {
>> +             asv_info = asv_mem->asv_info;
>> +             if (asv_type == asv_info->type)
>> +                     return asv_mem;
>> +     }
>
> Don't you need any kind of locking here? A mutex in add_asv_member()
> suggests that read access to the list should be protected as well.
>

hmmm, yes should be their for completeness of code.

>> +
>> +     return NULL;
>> +}
>> +
>> +unsigned int asv_get_volt(enum asv_type_id target_type,
>> +                                             unsigned int target_freq)
>
> Do you need this function at all? I believe this is all about populating
> device's OPP array with frequencies and voltages according to its ASV
> level. Users will be able to query for required voltage using standard OPP
> calls then, without a need for ASV specific functions like this one.
>

Yes, I had put a comment in initial version after commit message :
"Hopefully asv_get_volt() can go out in future, once all users start using OPP
library." , which seems to be missed in this version.
I had kept it for the time being in initial version, to keep it
usable(for testing) with
existing cpufreq drivers, which need to reworked and may take time.

[snip]
>> +
>> +     for (i = 0; i < asv_info->nr_dvfs_level; i++) {
>> +             if (dev_pm_opp_add(dev, dvfs_table[i].freq * 1000,
>> +                     dvfs_table[i].volt)) {
>> +                     dev_warn(dev, "Failed to add OPP %d\n",
>> +                              dvfs_table[i].freq);
>
> Hmm, shouldn't it be considered a failure instead?
>

hmm, not really always. Theoretically system with some less(failed to add)
levels can work. Moreover I had prefered to keep it only warning, just to
keep the behaviour of  asv_init_opp_table() similar to that of its
counter part of_init_opp_table().

>> +                     continue;
>> +             }
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static struct asv_member *asv_init_member(struct asv_info *asv_info)
>> +{
>> +     struct asv_member *asv_mem;
>> +     int ret = 0;
>> +
>> +     if (!asv_info) {
>> +             pr_err("No ASV info provided\n");
>> +             return NULL;
>
> I'd suggest adopting the ERR_PTR() convention, which allows returning more
> information about the error.
>

Will it be really usefull here?, as we are not checking return value
of any function.
Bur for some cases below, i will also like to get it used.

>> +     }
>> +
>> +     asv_mem = kzalloc(sizeof(*asv_mem), GFP_KERNEL);
>> +     if (!asv_mem) {
>> +             pr_err("Allocation failed for member: %s\n", asv_info->name);
>> +             return NULL;
>> +     }

[snip]
>
> Hmm, I don't see a point of these three separate callbacks above.
>
> In general, I'd suggest a different architecture. I'd see this more as:
>
> 1) Platform code registers static platform device to instantiate SoC ASV
>    driver.
> 2) SoC specific ASV driver probes, reads group ID from hardware register,
>    calls register_asv_member() with appropriate DVFS table for detected
>    group.
> 3) Driver using ASV calls asv_init_opp_table() with its struct device and
>    ASV member name, which causes the ASV code to fill device's operating
>    point using OPP calls.
>
> Now client driver has all the information it needs and the work of ASV
> subsystem is done. The control flow between drivers would be much simpler
> and no callbacks would have to be called.
>

Architecture stated above seems to be a subset(one possible way of use),
of the proposed architecture. If someone really have nothing much to do,
he can adopt the above stated approach using this framework also,
callbacks are not mandatory.

Since we usually have more things to do other than only reading
fused group value and simply parsing a table index, so in drivers we have to
implement functions to segregate stuff and different people do it in
different way. Its an attempt to provide a way to keep structure(functions)
similar for easy understanding and factoring out of common code.

Moreover, I feels need of callbacks if we have to do something depending
upon(specific) the user/instance of  ASV member. One thing came
in my mind was dev_node may be required if we may think of parsing
ASV table from DT and may be more things in future.


I would like to get rectified, other nit/suggestions stated by you in
next version.


Thanks & Regards,
 Yadwinder
