Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaENEIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 00:08:14 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:44572 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaENEIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 00:08:13 -0400
Message-ID: <1400040489.5157.44.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: wake up task on prev_cpu if not in
 SD_WAKE_AFFINE domain with cpu
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com, mingo@kernel.org,
        george.mccollister@gmail.com, ktkhai@parallels.com,
        Mel Gorman <mgorman@suse.de>, "Vinod, Chegu" <chegu_vinod@hp.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Wed, 14 May 2014 06:08:09 +0200
In-Reply-To: <53722754.6040102@redhat.com>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
	 <1399011219.5233.55.camel@marge.simpson.net> <53633B81.1080403@redhat.com>
	 <1399016273.5233.94.camel@marge.simpson.net> <536379D0.8070306@redhat.com>
	 <1399030032.5233.142.camel@marge.simpson.net> <5363B793.9010208@redhat.com>
	 <20140506115448.GH11096@twins.programming.kicks-ass.net>
	 <536943C9.4030502@redhat.com>
	 <20140506203916.GQ17778@laptop.programming.kicks-ass.net>
	 <536C3B69.1000208@redhat.com>
	 <20140509012743.67d4006d@annuminas.surriel.com>
	 <1399620873.5200.68.camel@marge.simpson.net> <536CE48E.2060305@redhat.com>
	 <1399649042.31219.47.camel@marge.simpson.net> <536CF346.6080009@redhat.com>
		 <1399658123.5187.2.camel@marge.simpson.net> <536D1B6D.8060004@redhat.com>
	 <1399694090.5146.13.camel@marge.simpson.net> <53722754.6040102@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-13 at 10:08 -0400, Rik van Riel wrote:

> OK, after doing some other NUMA stuff, and then looking at the scheduler
> again with a fresh mind, I have drawn some more conclusions about what
> the scheduler does, and how it breaks NUMA locality :)
> 
> 1) If the node_distance between nodes on a NUMA system is
>    <= RECLAIM_DISTANCE, we will call select_idle_sibling for
>    a wakeup of a previously existing task (SD_BALANCE_WAKE)
> 
> 2) If the node distance exceeds RECLAIM_DISTANCE, we will
>    wake up a task on prev_cpu, even if it is not currently
>    idle
> 
>    This behaviour only happens on certain large NUMA systems,
>    and is different from the behaviour on small systems.
>    I suspect we will want to call select_idle_sibling with
>    prev_cpu in case target and prev_cpu are not in the same
>    SD_WAKE_AFFINE domain.

Sometimes.  It's the same can of worms remote as it is local.. latency
gain may or may not outweigh cache miss pain.

> 3) If wake_wide is false, we call select_idle_sibling with
>    the CPU number of the code that is waking up the task
> 
> 4) If wake_wide is true, we call select_idle_sibling with
>    the CPU number the task was previously running on (prev_cpu)
> 
>    In effect, the "wake task on waking task's CPU" behaviour
>    is the default, regardless of how frequently a task wakes up
>    its wakee, and regardless of impact on NUMA locality.
> 
>    This may need to be changed.

That behavior also improves the odds of communicating tasks sharing a
cache though.

> Am I overlooking anything?

No, I think you're seeing where the worms live. 

> What benchmarks should I run to test any changes I make?

Mixed bag, it'll affects all, bursty, static, ramp up/down.

-Mike



