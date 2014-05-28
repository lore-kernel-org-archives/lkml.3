Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaE1IkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:40:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:29934 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252AbaE1Ij6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:39:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,926,1392192000"; 
   d="scan'208";a="437944179"
Date: Wed, 28 May 2014 08:35:40 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, dirk.j.brandewie@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Doug Smythies <dsmythies@telus.net>,
        Stratos Karafotis <stratosk@semaphore.gr>
Subject: Re: Performance regression in v3.14
Message-ID: <20140528003540.GA2296@intel.com>
References: <20140506163559.GA5308@localhost>
 <CAKohpokYEvazxm0-JJXPzq-4OgLXmROfaCMcgHDZwugChOxtsQ@mail.gmail.com>
 <536A3EE9.5050409@intel.com>
 <20140521090051.GO21412@localhost>
 <20140528075945.GA21705@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528075945.GA21705@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I tried applying your (rejected) patch "intel_pstate: Remove C0
> tracking" posted here:
> 
> 	https://lkml.org/lkml/2014/5/8/574
> 
> to v3.14.4 and it fixes the problem as expected.
> 
> So we have a commit fcb6a15c2e7e ("intel_pstate: Take core C0 time into
> account for core busy calculation") that went into v3.14-rc2 (and was
> even marked for *stable*) that first broke Greg KH's system:
> 
> 	https://lkml.org/lkml/2014/2/19/626
> 
> That was apparently fixed by e66c17683746 ("intel_pstate: Change
> busy calculation to use fixed point math."), but still left v3.14
> basically unusable for lower-intensity workloads such as my
> bash-completion example and other reported regressions:
> 
> 	https://bugzilla.kernel.org/show_bug.cgi?id=75121
> 
> Sure there may be issues with v3.13 not hitting the lowest frequencies
> but at least the system was *usable*.
> 
> In my opinion there's really no other option than to restore the 3.13
> behaviour by effectively reverting fcb6a15c2e7e ("intel_pstate: Take
> core C0 time into account for core busy calculation") until you have
> figured out a way to take C0 into account without breaking things too
> badly.

Hi all,

My posts before and now are only relevant to why C0 tracking can't be
removed. Maybe I need to elaborate on it a little bit more.

In a nutshell, without C0 tracking, the intel_pstate is effectively performance
governor in terms of frequency control. Why?

Without C0 trakcing, the machinery of the freq control is as I formed:

last_freq_average / last_requested_freq ==> setpoint

which can be virtually formed into:

last_freq_average / last_requested_freq * last_C0_pct ==> setpoint * last_C0_pct

which said, the control machinery will increase the freuqency at ANY frequency at
ANY C0_pct (which is the CPU utilization), since setpoint is less then 100
percent. And a few iterations later, we will reach max (possible) frequency,
then we are effectively performance governor (highest frequency all the time).

So, sure, without C0 tracking, the performance issues should be fixed. But
let's simply set highest frequency, that should be better.

It is your decision whether we should remove C0 tracking as a no-other option fix
right now. I am ok either way.

Thanks,
Yuyang
