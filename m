Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaD2Dbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 23:31:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:44889 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbaD2Dbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 23:31:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,948,1389772800"; 
   d="scan'208";a="531324734"
Date: Tue, 29 Apr 2014 03:26:21 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "arjan.van.de.ven@intel.com" <arjan.van.de.ven@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan.cox@intel.com" <alan.cox@intel.com>,
        "mark.gross@intel.com" <mark.gross@intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "rajeev.d.muralidhar@intel.com" <rajeev.d.muralidhar@intel.com>,
        "vishwesh.m.rudramuni@intel.com" <vishwesh.m.rudramuni@intel.com>,
        "nicole.chalhoub@intel.com" <nicole.chalhoub@intel.com>,
        "ajaya.durg@intel.com" <ajaya.durg@intel.com>,
        "harinarayanan.seshadri@intel.com" <harinarayanan.seshadri@intel.com>,
        yuyang.du@intel.com
Subject: Re: [RFC] A new CPU load metric for power-efficient scheduler: CPU
 ConCurrency
Message-ID: <20140428192621.GA6470@intel.com>
References: <20140424193004.GA2467@intel.com>
 <20140425102307.GN2500@e103034-lin>
 <13348109.c4H00groOp@vostro.rjw.lan>
 <20140425145334.GC2639@e103034-lin>
 <20140427200725.GA4771@intel.com>
 <20140428152213.GD2639@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428152213.GD2639@e103034-lin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm a bit confused, do you have one global CC that tracks the number of
> tasks across all runqueues in the system or one for each cpu? There
> could be some contention when updating that value on larger systems if
> it one global CC. If they are separate, how do you then decide when to
> consolidate? 

Oh, we are getting down to business. Currently, CC is per CPU. To consolidate,
the formula is based on a heuristic. Because:

suppose we have 2 CPUs, their task concurrency over time is ('-' means no
task, 'x' having tasks):

1)
CPU0: ---xxxx---------- (CC[0])
CPU1: ---------xxxx---- (CC[1])

2)
CPU0: ---xxxx---------- (CC[0])
CPU1: ---xxxx---------- (CC[1])

If we consolidate CPU0 and CPU1, the consolidated CC will be: CC' = CC[0] +
CC[1] for case 1 and CC'' = (CC[0] + CC[1]) * 2 for case 2. For the cases
in between case 1 and 2 in terms of how xxx overlaps, the CC should be between
CC' and CC''. So, we uniformly use this condition to evaluate for
consolidation (suppose we consolidate m CPUs to n CPUs, m > n):

(CC[0] + CC[1] + ... + CC[m-2] + CC[m-1]) * (n + log(m-n)) >=<? (1 * n) * n *
consolidate_coefficient

The consolidate_coeffient could be like 100% or more or less.

> How do you determine your "f" parameter? How fast is the reaction time?
> If you have had a period of consolidation and have a bunch of tasks
> waking up at the same time. How long will it be until you spread the
> load to all cpus?

Per CPU vs. per task? This is really not about who is (more) informative or
not, or why not both or not. It is about when you have task concurrency and
CPU utilization at the same time, and you must make a fast decision right now,
then what? Actually, it is also about how I want to position the whole CC
fuss. CC and the associated CPU workload consolidation can be regarded as
another "layer" beneath the current sophisticated load balancing, such that
this layer senses globally how many CPUs are needed and then do whatever it is
currently supposed to do in the needed CPUs. I think this is only a design
choice that is effective but simpler and less intrusive to just realize
consolidation/packing.

> It seems to me that you are loosing some important information by
> tracking per cpu and not per task. Also, your load balance behaviour is
> very sensitive to the choice of decay factor. We have that issue with
> the runqueue load tracking already. It reacts very slowly to load
> changes, so it can't really be used for periodic load-balancing
> decisions.

The current halflife is 1 period, and the period was 32ms, and now 64ms for
more aggressive consolidation.

Thanks,
Yuyang
