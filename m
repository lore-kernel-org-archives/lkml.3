Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3IKNHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:07:17 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62084 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753203Ab3IKNHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:07:14 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Greg KH <greg@kroah.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: "cpufreq: fix serialization issues with freq change notifiers" breaks cpufreq too
Date: Wed, 11 Sep 2013 15:18:15 +0200
Message-ID: <2013615.oHjWkmedue@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpo=RKB-_EO=cjaOorAfN=y_cMgJg-j6=xtX71a-TwujgsA@mail.gmail.com>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange> <2703632.ul5ekQh5oq@vostro.rjw.lan> <CAKohpo=RKB-_EO=cjaOorAfN=y_cMgJg-j6=xtX71a-TwujgsA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 11, 2013 02:08:44 PM Viresh Kumar wrote:
> On 11 September 2013 01:16, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Tuesday, September 10, 2013 08:44:18 PM Viresh Kumar wrote:
> 
> >> Now Second question, is this fine to have multiple PRECHANGE notfications
> >> before any POSTCHANGE notification?
> >>
> >> Logically it looks obvious to me that these must be serialized..
> >> Otherwise this is what we are broadcasting:
> >> - We are changing for freq X, please prepare and let us know if you are
> >> okay with it..
> >> - Oh.. So sorry, we are changing to freq Y instead, please adjust accordingly.
> >>
> >> - Yes we have changed to freq Y...
> >> - Yes we have changed to freq X...
> >>
> >> This looks stupid, isn't it? I don't know how the drivers would behave when
> >> they see such notifications and so got to this patch initially..
> >
> > Well, precisely, you don't know.
> >
> > Can you please look for specific problems and address those instead of trying
> > to address potential issues that may or may not happen and may or may not really
> > be issues even if they actually happen?
> 
> That looked like a straight forward issue/bug to me and so I haven't
> gotten deep into it..

Which you should always do when you're going to deal with concurrency issues.
Even if they appear to be obvious, they often are far from that, like in this
case.

> Scenario 1:
> --------------
> Notifiers are not serialized and suppose this is what happened
> - PRECHANGE Notification for freq A (from cpuinfo_cur_freq)
> - PRECHANGE Notification for freq B (from target())
> - Freq changed by target() to B
> - POSTCHANGE Notification for freq B
> - POSTCHANGE Notification for freq A
> 
> Now the last POSTCHANGE Notification happened for freq A and
> hardware is currently running at freq B :)
> 
> Where would we break then?: adjust_jiffies() in cpufreq.c,
> cpufreq_callback() in arch/arm/kernel/smp.c (which is also adjusting
> jiffies)..
> 
> Now, all loops_per_jiffy based stuff is broken.. Have I missed
> something?
>
> Similarly there are numerous places where we may break.. As we
> have broken expectations of receivers of these notifications..

Now it is clear what the problem is and that should go in the changelog of the
fix patch.
 
> Scenario 2:
> --------------
> Governor is changing freq and has called __cpufreq_driver_target().
> At the same time we are changing scaling_{min|max}_freq from
> sysfs, which would eventually end up calling governors:
> CPUFREQ_GOV_LIMITS notification, that will also call:
> __cpufreq_driver_target()..
> 
> So, we eventually have two concurrent calls to ->target() and we
> don't really know how hardware will behave in this case.. Most of
> the implementations of ->target() routines just go and change
> freq/voltage without checking if we are already in progress of doing
> that (i.e. based on expectation that this call is not re entrant)..
> 
> Now anything can happen at hardware level, which I don't have
> all insight of :(

That is more theoretical, however.

I think that the "Scenario 1" is a good enough reason for making this change,
but it needs to be done with care.

> > And broken patches that try to fix such things definitely don't help.
> 
> Yeah, that's my fault but I honestly try to produce bug-less patches..
> But being a normal human being, there are always some chances
> that my patches are eventually broken :)

Well, that happens for everyone, but in this particular case we had three
different issues because of a single patch ...

And actually I also should have spend more time on this before applying the
patch, especially given the laconic changelog, so it's my fault too.

> > For now I'm reverting the commit in question and everything on top of it.
> 
> Its okay..

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
