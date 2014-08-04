Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbaHDV1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:27:40 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:38726 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaHDV1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:27:38 -0400
Message-ID: <1407187656.11985.20.camel@j-VirtualBox>
Subject: Re: [PATCH] sched: Reduce contention in update_cfs_rq_blocked_load
From: Jason Low <jason.low2@hp.com>
To: bsegall@google.com
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Waiman Long <Waiman.Long@hp.com>,
        Mel Gorman <mgorman@suse.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>, Scott J Norton <scott.norton@hp.com>,
        pjt@google.com
Date: Mon, 04 Aug 2014 14:27:36 -0700
In-Reply-To: <xm264mxsugds.fsf@sword-of-the-dawn.mtv.corp.google.com>
References: <1407184118.11407.11.camel@j-VirtualBox>
	 <xm264mxsugds.fsf@sword-of-the-dawn.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-04 at 13:52 -0700, bsegall@google.com wrote:
> Jason Low <jason.low2@hp.com> writes:
> 
> > When running workloads on 2+ socket systems, based on perf profiles, the
> > update_cfs_rq_blocked_load function constantly shows up as taking up a
> > noticeable % of run time. This is especially apparent on an 8 socket
> > machine. For example, when running the AIM7 custom workload, we see:
> >
> >    4.18%        reaim  [kernel.kallsyms]        [k] update_cfs_rq_blocked_load
> >
> > Much of the contention is in __update_cfs_rq_tg_load_contrib when we
> > update the tg load contribution stats.  However, it turns out that in many
> > cases, they don't need to be updated and "tg_contrib" is 0.
> >
> > This patch adds a check in __update_cfs_rq_tg_load_contrib to skip updating
> > tg load contribution stats when nothing needs to be updated. This reduces the
> > cacheline contention that would be unnecessary. In the above case, with the
> > patch, perf reports the total time spent in this function went down by more
> > than a factor of 3x:
> >
> >    1.18%        reaim  [kernel.kallsyms]        [k] update_cfs_rq_blocked_load
> >
> > Signed-off-by: Jason Low <jason.low2@hp.com>
> Reviewed-by: Ben Segall <bsegall@google.com>
> 
> That said, it might be better to remove force_update for this function,
> or make it just reduce the minimum to /64 or something. If the test is
> easy to run it would be good to see what it's like just removing the
> force_update param for this function to see if it's worth worrying
> about or if the zero case catches ~all the perf gain.

Sure, I can test that out too. I did notice when running another AIM7
workload that !zero was the more common case, so this has the potential
to further reduce contention.

>  Paul, your thoughts?


