Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964823AbaEMOJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:09:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933871AbaEMOJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:09:00 -0400
Message-ID: <53722754.6040102@redhat.com>
Date: Tue, 13 May 2014 10:08:20 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com, mingo@kernel.org,
        george.mccollister@gmail.com, ktkhai@parallels.com,
        Mel Gorman <mgorman@suse.de>, "Vinod, Chegu" <chegu_vinod@hp.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] sched: wake up task on prev_cpu if not in SD_WAKE_AFFINE
 domain with cpu
References: <20140502004237.79dd3de6@annuminas.surriel.com>	 <1399011219.5233.55.camel@marge.simpson.net> <53633B81.1080403@redhat.com>	 <1399016273.5233.94.camel@marge.simpson.net> <536379D0.8070306@redhat.com>	 <1399030032.5233.142.camel@marge.simpson.net> <5363B793.9010208@redhat.com>	 <20140506115448.GH11096@twins.programming.kicks-ass.net>	 <536943C9.4030502@redhat.com>	 <20140506203916.GQ17778@laptop.programming.kicks-ass.net>	 <536C3B69.1000208@redhat.com>	 <20140509012743.67d4006d@annuminas.surriel.com>	 <1399620873.5200.68.camel@marge.simpson.net> <536CE48E.2060305@redhat.com>	 <1399649042.31219.47.camel@marge.simpson.net> <536CF346.6080009@redhat.com>	 <1399658123.5187.2.camel@marge.simpson.net> <536D1B6D.8060004@redhat.com> <1399694090.5146.13.camel@marge.simpson.net>
In-Reply-To: <1399694090.5146.13.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 11:54 PM, Mike Galbraith wrote:
> On Fri, 2014-05-09 at 14:16 -0400, Rik van Riel wrote:
> 
>> That leaves the big question: do we want to fall back to
>> prev_cpu if it is not idle, and it has an idle sibling,
>> or would it be better to find an idle sibling of prev_cpu
>> when we wake up a task?
> 
> Yes.  If there was A correct answer, this stuff would be a lot easier.

OK, after doing some other NUMA stuff, and then looking at the scheduler
again with a fresh mind, I have drawn some more conclusions about what
the scheduler does, and how it breaks NUMA locality :)

1) If the node_distance between nodes on a NUMA system is
   <= RECLAIM_DISTANCE, we will call select_idle_sibling for
   a wakeup of a previously existing task (SD_BALANCE_WAKE)

2) If the node distance exceeds RECLAIM_DISTANCE, we will
   wake up a task on prev_cpu, even if it is not currently
   idle

   This behaviour only happens on certain large NUMA systems,
   and is different from the behaviour on small systems.
   I suspect we will want to call select_idle_sibling with
   prev_cpu in case target and prev_cpu are not in the same
   SD_WAKE_AFFINE domain.

3) If wake_wide is false, we call select_idle_sibling with
   the CPU number of the code that is waking up the task

4) If wake_wide is true, we call select_idle_sibling with
   the CPU number the task was previously running on (prev_cpu)

   In effect, the "wake task on waking task's CPU" behaviour
   is the default, regardless of how frequently a task wakes up
   its wakee, and regardless of impact on NUMA locality.

   This may need to be changed.

5) select_idle_sibling will place the task on (3) or (4) only
   if the CPU is actually idle. If task A communicates with task
   B through a pipe or a socket, and does a sync wakeup, task
   B will never be placed on task A's CPU (not idle yet), and it
   will only be placed on its own previous CPU if it is currently
   idle.

6) If neither CPU is idle, select_idle_sibling will walk all the
   CPUs in the SD_SHARE_PKG_RESOURCES SD of the target. This looks
   correct to me, though it could result in more work by the load
   balancing code later on, since it does not take load into account
   at all. It is unclear if this needs any changes.

Am I overlooking anything?

What benchmarks should I run to test any changes I make?

Are there particular system types people want me to run tests with?

-- 
All rights reversed
