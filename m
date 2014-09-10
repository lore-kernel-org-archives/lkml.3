Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaIJWaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 18:30:22 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52003 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751754AbaIJWaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 18:30:20 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Anup Chenthamarakshan <anupc@chromium.org>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Sameer Nanda <snanda@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_pstate: track and export frequency residency stats via sysfs.
Date: Thu, 11 Sep 2014 00:49:48 +0200
Message-ID: <1610826.tK4V65ABJD@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140910221508.GA18951@google.com>
References: <1410221424-20590-1-git-send-email-anupc@chromium.org> <54107EC2.1010501@intel.com> <20140910221508.GA18951@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 10, 2014 03:15:08 PM Anup Chenthamarakshan wrote:
> On Wed, Sep 10, 2014 at 09:39:30AM -0700, Dirk Brandewie wrote:
> > On 09/09/2014 04:22 PM, Anup Chenthamarakshan wrote:
> > >On Tue, Sep 09, 2014 at 08:15:13AM -0700, Dirk Brandewie wrote:
> > >>On 09/08/2014 05:10 PM, Anup Chenthamarakshan wrote:
> > >>>Exported stats appear in
> > >>><sysfs>/devices/system/cpu/intel_pstate/time_in_state as follows:
> > >>>
> > >>>## CPU 0
> > >>>400000 3647
> > >>>500000 24342
> > >>>600000 144150
> > >>>700000 202469
> > >>>## CPU 1
> > >>>400000 4813
> > >>>500000 22628
> > >>>600000 149564
> > >>>700000 211885
> > >>>800000 173890
> > >>>
> > >>>Signed-off-by: Anup Chenthamarakshan <anupc@chromium.org>
> > >>
> > >>What is this information being used for?
> > >
> > >I'm using P-state residency information in power consumption tests to calculate
> > >proportion of time spent in each P-state across all processors (one global set
> > >of percentages, corresponding to each P-state). This is used to validate new
> > >changes from the power perspective. Essentially, sanity checks to flag changes
> > >with large difference in P-state residency.
> > >
> > >So far, we've been using the data exported by acpi-cpufreq to track this.
> > >
> > >>
> > >>Tracking the current P state request for each core is only part of the
> > >>story.  The processor aggregates the requests from all cores and then decides
> > >>what frequency the package will run at, this evaluation happens at ~1ms time
> > >>frame.  If a core is idle then it loses its vote for that package frequency will
> > >>be and its frequency will be zero even though it may have been requesting
> > >>a high P state when it went idle.  Tracking the residency of the requested
> > >>P state doesn't provide much useful information other than ensuring the the
> > >>requests are changing over time IMHO.
> > >
> > >This is exactly why we're trying to track it.
> > 
> > My point is that you are tracking the residency of the request and not
> > the P state the package was running at.  On a lightly loaded system
> > it is not unusual for a core that was very busy and requesting a high
> > P state to go idle for several seconds.  In this case that core would
> > lose its vote for the package P state but the stats would show that
> > the P state was high for a very long time when its real frequency
> > was zero.
> 
> I see what you're saying. Requesting a p-state does not necessarily mean that is
> the state the CPU is in.
> 
> > 
> > There are a couple of ways to get what I consider better information
> > about what is actually going on.
> > 
> >   The current turbostat provides C state residency and calculates the
> >   average/effective frequency of the core over its sample time.
> >   Turbostat will also measure the power consumption from the CPU point
> >   of view if your processor supports the RAPL registers.
> > 
> >   Reading MSR 0x198 MSR_IA32_PERF_STATUS will tell you what the core
> >   would run at if it not idle, this reflects the decision that the
> >   package made based on current requests.
> > 
> >   Using perf to collect power:pstate_sample event will give information
> >   about each sample on the core and give you timestamps to detect idle
> >   times.
> > 
> >   Using perf to collect power:cpu_frequency will show when the P state
> >   request was changed on each core and is triggered by intel_pstate and
> >   acpi_cpufreq.
> > 
> >   Powertop collects that same information as turbostat and a bunch of
> >   other information useful in seeing where you could be burning power
> >   for no good reason.
> > 
> > For getting an idea of real power turbostat is the easiest to use and
> > is available on most systems.  Using perf will give you a very fine grained
> > view of what is going on as well as point to the culprit for bad
> > behaviour in most cases.
> 
> Tools like powertop and turbostat are not present by default on all systems,
> so it is not always possible to use them :(

Which systems are you referring to in particular?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
