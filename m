Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaIIXbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 19:31:47 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44816 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaIIXbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 19:31:45 -0400
Date: Tue, 9 Sep 2014 16:31:41 -0700
From: Anup Chenthamarakshan <anupc@chromium.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Sameer Nanda <snanda@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] intel_pstate: track and export frequency residency stats
 via sysfs.
Message-ID: <20140909233141.GB28142@google.com>
References: <1410221424-20590-1-git-send-email-anupc@chromium.org>
 <CAKohponb199_zt11M2J39yHn45MjFMSrT+hPBp7rbqiHu4vKpQ@mail.gmail.com>
 <CAN1Daczk+YT3ETviCL5d7xLGKzRL+AAo1z6rLs=r+j5+r45-xw@mail.gmail.com>
 <CAOh2x==oX4HN2NJ=bMUzyuL0K9KdrmV7HjRctX9dio7yw-4sbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOh2x==oX4HN2NJ=bMUzyuL0K9KdrmV7HjRctX9dio7yw-4sbQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 11:56:18AM +0530, Viresh Kumar wrote:
> On Tue, Sep 9, 2014 at 11:02 AM, Anup Chenthamarakshan
> <anupc@chromium.org> wrote:
> > I had initially tried reusing cpufreq_stats.c to export stats.
> > Calling cpufreq_stats_update() via the cpufreq notifier added
> > some amount of overhead while switching frequencies. Specifically,
> > looking up the index of the new frequency in freq_table_get_index()
> > is a linear search through all available frequencies (vs a single
> > subtraction with custom stats export). Also, the notifier mechanism
> 
> I don't think just this linear search will make things so bad..

Linear search usually slows down transition to higher P-states because
it has to go through the full list (and the list is longer in intel_pstate
compared to acpi-cpufreq). But, yes, this is probably not a bottleneck.

> 
> > itself added a level of indirection before calling stats_update.
> 
> Probably some other notifier is registered which is taking considerable
> amount of time.. Try checking what all registered with cpufreq-core.

There was no other notifier which was listening to freq transitions events.

> 
> > There is a 5X increase in time taken to complete intel_pstate_set_pstate
> > while using cpufreq_stats compared to having custom stats exported.
> 
> Try calling cpufreq_stat_notifier_trans() directly instead of a notifier
> and lets see if this makes it any better.

Here's a comparison of time taken to run intel_pstate_set_pstate() using
different approaches:
                                  average time for a transition
no stats                                      4.7us
intel_pstate-stats                            5.7us
direct call to cpufreq_stat_notifier_trans    8.1us
cpufreq-notifier-event                       10.6us


I was wrong about the 5x increase (got tripped by calls to
intel_pstate_set_pstate where no change in P-state actually happened)
