Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3FRGmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 02:42:19 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:51861 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3FRGmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 02:42:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130617155156.4c729b5a@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1371195540-2991-1-git-send-email-l.majewski@samsung.com>
	<1371195540-2991-2-git-send-email-l.majewski@samsung.com>
	<CAKohpokQAsuAqWi7rNx9RaFz8KVRNXVkBD22KC5_Qh05k66qqA@mail.gmail.com>
	<20130617091549.398b865f@amdc308.digital.local>
	<CAKohpo=nfuqwCoQJRczmNRNXCOTL5FSJQEzjKpVdXU+wu-KJ1g@mail.gmail.com>
	<20130617110811.1e1805d2@amdc308.digital.local>
	<CAKohpo=oy3SQXgvNvOydggZ5NZu9yyVtKrdFQjNOGVmzhSaQUw@mail.gmail.com>
	<20130617115809.5206c42c@amdc308.digital.local>
	<CAKohpo=yPcH0FW7T38cd3E1xOpzC0AhJ5mtyVaQyuj_S8iLovw@mail.gmail.com>
	<20130617155156.4c729b5a@amdc308.digital.local>
Date: Tue, 18 Jun 2013 12:12:13 +0530
Message-ID: <CAKohpo=_=u35wTb-ZUXrR2hNno+ryAqq4gSC3EiJr=-bmgb9JQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] cpufreq: Add boost frequency support in core
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
        Kukjin Kim <kgene.kim@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 June 2013 19:21, Lukasz Majewski <l.majewski@samsung.com> wrote:
> On Mon, 17 Jun 2013 18:40:50 +0530, Viresh Kumar wrote:
>> >> > The core acpi-cpufreq.c code hadn't been changed by me, so I
>> >> > assume that it will work as before.
>> >>
>> >> That should adapt your patch in your patchset.
>
> Could you explain what do you mean?

Update acpi-cpufreq to use your infrastructure.

>> >> From sysfs?? I thought we are going to have some automatic control
>> >> of this stuff from inside kernel.
>> >
>> > From sysfs I just enable the boost. I do not order from userpace the
>> > cpufreq to run with a particular (boosted) frequency.
>> >
>> > When I enable boost - I ask (politely) the cpufreq core to
>> > reevaluate policies and when applicable increase policy->max.
>> >
>> > Then governor can use this new frequencies for normal operation.
>>
>> So, with your current patchset in, ondemand or conservative governors
>> will start using boost frequencies. Which might burn your chip.
>
> Two scenarios:
> 1. Thermal framework is compiled in and enabled (for exynos/other SoC)
> -> trip point is reached -> boost is disabled -> frequency is reduced ->
> SoC is cooled down.
>
> I think, that thermal framework is a good "safe valve" here.

Even in this case boost shouldn't have been enabled by default.
Its not only about burning the chip but more than that.

According to my understanding, boost was important for power
saving. In case a high load can be managed by a single cpu with
boost freqs, then its better to use boost freqs rather than bringing
another cpu up.

Normally boost freqs are not so useful if we talk about powersaving,
as their energy consumption is much higher with not so great impact
on performance.

That's why when this thread started we talked about boost only when
one cpu is operational. But with your patch all cores can use boost
freq and thermal will come into picture just to save the chip.

That's wrong. This isn't why we invented boost here. Otherwise you
just don't need boost feature at all for your SoC. Just make these
freqs as available freqs and let thermal control policy->max/min
to save your chip.

> 2. Thermal framework is disabled and user has enabled boost and used
> ondemand / conservative governor.
> Then execute gzip < /dev/urandom > /dev/null & (on all cores).
>
> Then yes, chip will hang/burn due to crossing operating point (or burn).
>
>
> What other means of control (despite of thermal) would you consider
> applicable?
>
> What comes to my mind is modifying governor logic to count how long the
> CPU run with boost enabled and then disable it.

Its not about how long.. One cpu type can work longer with boost freq
compared to other.

What we probably need is:
- Enabled boost from sysfs if required (now below steps will come into
  picture)
- See how many cpus are running, if only one then start using boost freqs
- Now thermal should be come into picture to save chip in case a single
cpu running at boost can burn it out.
