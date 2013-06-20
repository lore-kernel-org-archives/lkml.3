Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab3FTFHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:07:30 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:37045 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab3FTFH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:07:29 -0400
MIME-Version: 1.0
In-Reply-To: <3258927.Qds4G9CTyG@vostro.rjw.lan>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<20130617155156.4c729b5a@amdc308.digital.local>
	<CAKohpo=_=u35wTb-ZUXrR2hNno+ryAqq4gSC3EiJr=-bmgb9JQ@mail.gmail.com>
	<3258927.Qds4G9CTyG@vostro.rjw.lan>
Date: Thu, 20 Jun 2013 10:31:30 +0530
Message-ID: <CAKohponVBjvQf-5BibzDUko=fVtzPYWMOr2xywp=r0TTB_t6Bw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] cpufreq: Add boost frequency support in core
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
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

On 18 June 2013 18:56, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, June 18, 2013 12:12:13 PM Viresh Kumar wrote:
>> On 17 June 2013 19:21, Lukasz Majewski <l.majewski@samsung.com> wrote:

>> According to my understanding, boost was important for power
>> saving. In case a high load can be managed by a single cpu with
>> boost freqs, then its better to use boost freqs rather than bringing
>> another cpu up.
>
> Do you mean the 'boost' sysfs attribute or the 'turbo frequencies' concept?

I thought they are the. Probably not, but I am not sure about the
difference.

>> Normally boost freqs are not so useful if we talk about powersaving,
>> as their energy consumption is much higher with not so great impact
>> on performance.
>
> Er, er, please be careful here.  The impact on performance may be sufficient
> for deep C-states to become relevant in some cases.

Hmm.

>> That's why when this thread started we talked about boost only when
>> one cpu is operational. But with your patch all cores can use boost
>> freq and thermal will come into picture just to save the chip.
>
> Well, that's why on x86 turbo is controlled by hardware that takes care of
> keeping things within the chip's thermal limits.

Yeah.

>> That's wrong. This isn't why we invented boost here. Otherwise you
>> just don't need boost feature at all for your SoC. Just make these
>> freqs as available freqs and let thermal control policy->max/min
>> to save your chip.
>
> The 'boost' attribute added by acpi-cpufreq means "let the hardware use turbo
> frequencies".
>
> I'd recommend you both to read Documentation/cpu-freq/boost.txt now. :-)

I did it now :)

> I think we can extend the meaning to "let turbo frequencies be used", but if
> we need software to play the role of the hardware's thermal control, we need
> to be very careful.

Exactly. There are two variants now:
- Hardware boost: x86: Don't do any trick in software to prevent hardware
from boosting... Let the hardware take control as it is today
- Software boost: The initial idea from Lukasz was about using boost only
when one cpu is used. That's the impression I had in mind. And it looked
sensible too to some extent. BUT there is a great chance that any mistake
can burn chips, so we need to be extremely careful.

>> What we probably need is:
>> - Enabled boost from sysfs if required (now below steps will come into
>>   picture)
>
> This has to be compatible with the existing stuff.

Sure.

>> - See how many cpus are running, if only one then start using boost freqs
>> - Now thermal should be come into picture to save chip in case a single
>> cpu running at boost can burn it out.
>
> I'd say there needs to be a separate controller/monitor for that that will
> know what the chip's thermal limit is and how that relates to how fast the
> CPU core(s) may run and for how much time.  I'm not sure it is sufficient
> to "wait for thermal to kick in" here, because you may need to slow down
> things in advance (i.e. before thermal sensors tell you there's too much heat,
> because that may be too late already).

That's why I wasn't sure about software boosting initially. But at the same
time a thermal sensor might be good enough. They just have to be programmed
accordingly, so that they fire a bit in advance before things are out of
control. :)
