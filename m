Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaL0UMj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 15:12:39 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50603 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751610AbaL0UMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 15:12:37 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Nishanth Menon <nm@ti.com>
Cc: Dmitry Torokhov <dtor@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] PM / OPP: take RCU lock in dev_pm_opp_get_opp_count
Date: Sat, 27 Dec 2014 21:34:35 +0100
Message-ID: <7196872.73t4V7xy4d@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <549B23FA.5050100@ti.com>
References: <1418771379-24369-1-git-send-email-dtor@chromium.org> <CAE_wzQ_djUapN-hwHUttcrfzUiWPHvW9OxV7zqrwidtYh8_FZg@mail.gmail.com> <549B23FA.5050100@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 24, 2014 02:37:14 PM Nishanth Menon wrote:
> On 12/24/2014 11:44 AM, Dmitry Torokhov wrote:
> > On Wed, Dec 24, 2014 at 9:37 AM, Nishanth Menon <nm@ti.com> wrote:
> >> On 12/24/2014 11:31 AM, Dmitry Torokhov wrote:
> >>> On Wed, Dec 24, 2014 at 9:16 AM, Nishanth Menon <nm@ti.com> wrote:
> >>>> On 12/24/2014 11:09 AM, Dmitry Torokhov wrote:
> >>>>> On Wed, Dec 24, 2014 at 8:48 AM, Nishanth Menon <nm@ti.com> wrote:
> >>>>>> On 12/16/2014 05:09 PM, Dmitry Torokhov wrote:
> >>>>>>> A lot of callers are missing the fact that dev_pm_opp_get_opp_count
> >>>>>>> needs to be called under RCU lock. Given that RCU locks can safely be
> >>>>>>> nested, instead of providing *_locked() API, let's take RCU lock inside
> >>>>>>> dev_pm_opp_get_opp_count() and leave callers as is.
> >>>>>>
> >>>>>> While it is true that we can safely do nested RCU locks, This also
> >>>>>> encourages wrong usage.
> >>>>>>
> >>>>>> count = dev_pm_opp_get_opp_count(dev)
> >>>>>> ^^ point A
> >>>>>> array   = kzalloc(count * sizeof (*array));
> >>>>>> rcu_read_lock();
> >>>>>> ^^ point B
> >>>>>> .. work down the list and add OPPs..
> >>>>>> ...
> >>>>>>
> >>>>>> Between A and B, we might have had list modification (dynamic OPP
> >>>>>> addition or deletion) - which implies that the count is no longer
> >>>>>> accurate between point A and B. instead, enforcing callers to have the
> >>>>>> responsibility of rcu_lock is exactly what we have to do since the OPP
> >>>>>> library has no clue how to enforce pointer or data accuracy.
> >>>>>
> >>>>> No, you seem to have a misconception that rcu_lock protects you past
> >>>>> the point B, but that is also wrong. The only thing rcu "lock"
> >>>>> provides is safe traversing the list and guarantee that elements will
> >>>>> not disappear while you are referencing them, but list can both
> >>>>> contract and expand under you. In that regard code in
> >>>>> drivers/cpufreq/cpufreq_opp.c is utterly wrong. If you want to count
> >>>>> the list and use number of elements you should be taking a mutex.
> >>>>> Luckily all cpufreq drivers at the moment only want to see if OPP
> >>>>> table is empty or not, so as a stop-gap we can take rcu_lock
> >>>>> automatically as we are getting count. We won't get necessarily
> >>>>> accurate result, but at least we will be safe traversing the list.
> >>>>
> >>>> So, instead of a half solution, lets consider this in the realm of
> >>>> dynamic OPPs as well. agreed to the point that we only have safe
> >>>> traversal and pointer validity. the real problem however is with
> >>>> "dynamic OPPs" (one of the original reasons why i did not add dynamic
> >>>> OPPs in the original version was to escape from it's complexity for
> >>>> users - anyways.. we are beyond that now). if OPPs can be removed on
> >>>> the fly, we need the following:
> >>>> a) use OPP notifiers to adequately handle list modification
> >>>> b) lock down list modification (and associated APIs) to ensure that
> >>>> the original cpufreq /devfreq list is correct.
> >>>>
> >>>> I still dont see the need to do this half solution.
> >>>
> >>> The need for half solution at the moment is that you can't safely
> >>> travel the lists and may crash on an invalid pointer.
> >>
> >> So, fix the cpufreq-dt instead of moving the hack inside OPP driver.
> > 
> > I started there, but it is not only cpufreq-dt that got it wrong. I
> > considered changing individual drivers (Viresh also suggested adding
> > _locked() variant API), but decided patching opp was less invasive for
> > now.
> 
> True. I had done an audit and cleanup, I think a couple or so years
> back and things ofcourse tend to go down the bitrot path without
> constant checkups :(
> 
> >>> Going forward I think (I mentioned that in my other email) that we
> >>> should rework the OPP API so that callers fetch OPP table object for a
> >>> device at init/probe time and then use it to get OPPs. This way won't
> >>> have to travel two lists any time we want to reference an OPP.
> >>>
> >>> And instead of relying notifiers, maybe look into using OPP tables
> >>> directly in cpufreq drivers instead of converting OPP into static-ish
> >>> cpufreq tables.
> >>>
> >>
> >> If you'd like a proper fix for OPP usage, I am all open to see such a
> >> proposal that works not just for cpufreq, but also for devfreq as well.
> > 
> > Yeah, let's see what kind of time I have ;)
> 
> That would be nice. Thank you.
> 
> if you could post the split off the remaining patches from the series
> esp patches #1 and #2 w.r.t 3.19-rc1 and repost, it will be nice to
> get them merged in as they do look like obvious improvements good to
> get in without depending on the remainder of the series which we can
> work on meanwhile.

I actually have the entire Dmitry's series queued up for the next push
(most likely on Monday) and at this point I'm not seeing a compelling
reason for not pushing it.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
