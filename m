Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab3IKIit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:38:49 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:43741 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3IKIip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:38:45 -0400
MIME-Version: 1.0
In-Reply-To: <2703632.ul5ekQh5oq@vostro.rjw.lan>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange>
	<4292924.3iHJT5nzNS@vostro.rjw.lan>
	<CAKohponUdE0LCciPb+nf3t_vfNqAy3MeWQO8gTOdEDvQJeWcgg@mail.gmail.com>
	<2703632.ul5ekQh5oq@vostro.rjw.lan>
Date: Wed, 11 Sep 2013 14:08:44 +0530
Message-ID: <CAKohpo=RKB-_EO=cjaOorAfN=y_cMgJg-j6=xtX71a-TwujgsA@mail.gmail.com>
Subject: Re: "cpufreq: fix serialization issues with freq change notifiers"
 breaks cpufreq too
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Greg KH <greg@kroah.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2013 01:16, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, September 10, 2013 08:44:18 PM Viresh Kumar wrote:

>> Now Second question, is this fine to have multiple PRECHANGE notfications
>> before any POSTCHANGE notification?
>>
>> Logically it looks obvious to me that these must be serialized..
>> Otherwise this is what we are broadcasting:
>> - We are changing for freq X, please prepare and let us know if you are
>> okay with it..
>> - Oh.. So sorry, we are changing to freq Y instead, please adjust accordingly.
>>
>> - Yes we have changed to freq Y...
>> - Yes we have changed to freq X...
>>
>> This looks stupid, isn't it? I don't know how the drivers would behave when
>> they see such notifications and so got to this patch initially..
>
> Well, precisely, you don't know.
>
> Can you please look for specific problems and address those instead of trying
> to address potential issues that may or may not happen and may or may not really
> be issues even if they actually happen?

That looked like a straight forward issue/bug to me and so I haven't
gotten deep into it..

Scenario 1:
--------------
Notifiers are not serialized and suppose this is what happened
- PRECHANGE Notification for freq A (from cpuinfo_cur_freq)
- PRECHANGE Notification for freq B (from target())
- Freq changed by target() to B
- POSTCHANGE Notification for freq B
- POSTCHANGE Notification for freq A

Now the last POSTCHANGE Notification happened for freq A and
hardware is currently running at freq B :)

Where would we break then?: adjust_jiffies() in cpufreq.c,
cpufreq_callback() in arch/arm/kernel/smp.c (which is also adjusting
jiffies)..

Now, all loops_per_jiffy based stuff is broken.. Have I missed
something?

Similarly there are numerous places where we may break.. As we
have broken expectations of receivers of these notifications..

Scenario 2:
--------------
Governor is changing freq and has called __cpufreq_driver_target().
At the same time we are changing scaling_{min|max}_freq from
sysfs, which would eventually end up calling governors:
CPUFREQ_GOV_LIMITS notification, that will also call:
__cpufreq_driver_target()..

So, we eventually have two concurrent calls to ->target() and we
don't really know how hardware will behave in this case.. Most of
the implementations of ->target() routines just go and change
freq/voltage without checking if we are already in progress of doing
that (i.e. based on expectation that this call is not re entrant)..

Now anything can happen at hardware level, which I don't have
all insight of :(

> And broken patches that try to fix such things definitely don't help.

Yeah, that's my fault but I honestly try to produce bug-less patches..
But being a normal human being, there are always some chances
that my patches are eventually broken :)

> For now I'm reverting the commit in question and everything on top of it.

Its okay..
