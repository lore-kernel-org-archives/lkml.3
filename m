Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab3GZJdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:33:37 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36644 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353Ab3GZJdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:33:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130726103321.21238bbb@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1374770011-22171-1-git-send-email-l.majewski@samsung.com>
	<1374770011-22171-3-git-send-email-l.majewski@samsung.com>
	<CAKohpom9QHf+XBYQcajv4tni4_KA2x+Y3BAXWhZkdCFnZxp3XA@mail.gmail.com>
	<20130726103321.21238bbb@amdc308.digital.local>
Date: Fri, 26 Jul 2013 15:03:34 +0530
Message-ID: <CAKohpokBGyHa=jHYpf358Aaa2kRko9=NtkS_2H_ywAn59h1axQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/8] cpufreq: Add boost frequency support in core
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 July 2013 14:03, Lukasz Majewski <l.majewski@samsung.com> wrote:
> On Fri, 26 Jul 2013 12:47:15 +0530 Viresh Kumar wrote,
>> On 25 July 2013 22:03, Lukasz Majewski <l.majewski@samsung.com> wrote:

>> > +int cpufreq_boost_trigger_state(int state)
>> > +{
>> > +       unsigned long flags;
>> > +       int ret = 0;
>> > +
>> > +       if (cpufreq_driver->boost_enabled == state)
>> > +               return 0;
>> > +
>> > +       write_lock_irqsave(&cpufreq_driver_lock, flags);
>> > +       cpufreq_driver->boost_enabled = state;
>> > +       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>             ^^^^^^^^^^^^^^^^^^^^ [*]
>>
>> Not sure if we should leave the lock at this point of time, as we
>> haven't enabled boost until now.
>
> The problem here is with the cpufreq_driver->set_boost() call.
>
> I tried to avoid acquiring lock at one function and release it at
> another (in this case cpufreq_boost_set_sw), especially since the
> __cpufreq_governor() acquires its own lock - good place for deadlock.
>
> Is it OK for you to grab lock at one function
> (cpufreq_boost_trigger_state()) and then at other function
> (cpufreq_boost_set_sw) release it before calling __cpufreq_governor()
> and grab it again after its completion?

>> > +       ret = cpufreq_driver->set_boost(state);
>> > +       if (ret) {
>> > +               write_lock_irqsave(&cpufreq_driver_lock, flags);
>> > +               cpufreq_driver->boost_enabled = 0;
>>
>> should be:
>>                     cpufreq_driver->boost_enabled = !state;
>
> For me = 0 (or = false) is more readable.
> If you wish, I will change it to = !state.

Its not about readability but logic... What if boost was enabled
earlier and we are disabling it now.. and we reach here.. We
need to enable boost again, whereas you are disabling it.

>> > +int cpufreq_boost_supported(void)
>> > +{
>> > +       if (cpufreq_driver)
>>
>> This routine is always called from places where cpufreq_driver
>> can't be NULL..
>
> It is also called from thermal. And it happens that thermal is
> initialized earlier.
> Then "NULL pointer dereference" happens.

Ok.. Put a likely() around this check for cpufreq_driver..

> In my opinion at [1] we don't need the if (cpufreq_driver) check.
> But it is up to you to decide.

leave it as is.

> If we agree about above comments, I will post v7 ASAP.

Don't post it ASAP, wait for few more days for others to give
comments.. And also I haven't finished reviewing it until
now.
