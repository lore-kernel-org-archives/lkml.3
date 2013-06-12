Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3FLIJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:09:23 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:45168 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab3FLIJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:09:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130612093938.1cf73c9a@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1370941408-29304-1-git-send-email-l.majewski@samsung.com>
	<1370941408-29304-2-git-send-email-l.majewski@samsung.com>
	<CAKohpomD1ru3_nqQkUq8EmMjJzR7hrtRNAY=UNPWCDHuVxZfBA@mail.gmail.com>
	<20130612093938.1cf73c9a@amdc308.digital.local>
Date: Wed, 12 Jun 2013 13:39:18 +0530
Message-ID: <CAKohpo=Q6ry9NJU7w3suQ3kB4LQT-CEoy8vcR9W0zL2rSa3hkg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] cpufreq:boost: CPU frequency boost code
 unification for software and hardware solutions
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 June 2013 13:09, Lukasz Majewski <l.majewski@samsung.com> wrote:
> Hi Viresh,

Hi Lukasz,

>> Hi,

Please don't remove the line which says, who wrote last mail at what time.
These >, >>, >>>, >>>>, ... have a meaning. They help us understand who
wrote what in bottom posting. And as you removed my line, nobody can see
who wrote above "Hi" to you :)

>> You don't have to manually add "---" here. Just keep a blank line
>> instead.
>
> One "---" is added by git automatically. The [*] was added to distinct
> the changelog from rest of the commit. At least older versions of GIT
> required this to not include changelog to commit messages.

You don't have to add an extra "---" line. Just write your changelog
after "---" added by git and give a blank line between your last
changelog line and below ones (probably just to make it more
readable and not a must, but i am not sure).

>> >  drivers/cpufreq/cpufreq.c    |   69
>> > ++++++++++++++++++++++++++++++++++++++++++
>> > drivers/cpufreq/freq_table.c |   57
>> > ++++++++++++++++++++++++++++++++-- include/linux/cpufreq.h      |
>> > 12 ++++++++ 3 files changed, 136 insertions(+), 2 deletions(-)

> I think that we shall give users some flexibility and don't assume that
> low_level_boost is only used for one solution/vendor.
>
> It is also needed with software controlled boost. Please refer to patch
> 3/3.

You didn't get me. I am not asking to keep it only for Intel. But keep
this variable as is (s/low_level_boost/set_boost_freq), and make it
optional. So, few drivers can implement it but not everybody is required
to.

So, Add another variable: boost_supported, which will tell cpufreq core
that boost is supported by governor or not.

And a global variable in cpufreq.c boost_enabled to track status of
what user has requested.

> However I've added one global flag: cpufreq_boost_sysfs_defined
> which indicates if /sys/devices/system/cpu/cpufreq/boost attribute has
> been already defined (to prevent multiple definitions attempts).

You don't need this variable anymore as sysfs create file is now
moved to cpufreq_register_driver(), so this can't be called twice.

>> > char *buf) +static ssize_t show_available_freqs(struct
>> > cpufreq_policy *policy, char *buf,
>> > +                                   int show_boost)
>> >  {
>> >         unsigned int i = 0;
>> >         unsigned int cpu = policy->cpu;
>> > @@ -186,22 +208,53 @@ static ssize_t show_available_freqs(struct
>> > cpufreq_policy *policy, char *buf) for (i = 0;
>> > (table[i].frequency != CPUFREQ_TABLE_END); i++) { if
>> > (table[i].frequency == CPUFREQ_ENTRY_INVALID) continue;
>> > +               if (show_boost)
>> > +                       if (table[i].index != CPUFREQ_BOOST_FREQ)
>> > +                               continue;
>> > +
>>
>> Looks wrong. You will show boost freqs when show_boost is false.
>
> My purpose here is to display frequencies only tagged with
> CPUFREQ_BOOST_FREQ and when show_boost is true.
>
> When show_boost is false, the operation of the function is unchanged.

Which is wrong. When show_boost is false, it means that user don't
want to see boost frequencies and so you should skip them.

>> With this patch alone, we would be using boost frequencies even in
>> normal cases where we haven't enabled boost.
>
> Correct me if I'm wrong here, but the
> cpufreq_freq_attr_boost_available_freqs will be added to cpufreq
> driver's freq_attr table (i.e. *exynos_cpufreq_attr[]).
> It is cpufreq driver's responsibility to add this attribute. By default
> all other drivers add only cpufreq_freq_attr_boost_available_freqs.

You are just talking about showing boost freqs in sysfs. I am talking
about the frequencies that governors will select when boost is
disabled from sysfs. Because we don't skip boost frequencies in
target() routines, we will set them as and when governor requests
them.
