Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaHDVEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:04:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:35234 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaHDVEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:04:33 -0400
Date: Mon, 4 Aug 2014 23:04:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ben Segall <bsegall@google.com>, Waiman Long <Waiman.Long@hp.com>,
        Mel Gorman <mgorman@suse.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>, Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH] sched: Reduce contention in update_cfs_rq_blocked_load
Message-ID: <20140804210427.GV3935@laptop>
References: <1407184118.11407.11.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407184118.11407.11.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 01:28:38PM -0700, Jason Low wrote:
> When running workloads on 2+ socket systems, based on perf profiles, the
> update_cfs_rq_blocked_load function constantly shows up as taking up a
> noticeable % of run time. This is especially apparent on an 8 socket
> machine. For example, when running the AIM7 custom workload, we see:
> 
>    4.18%        reaim  [kernel.kallsyms]        [k] update_cfs_rq_blocked_load
> 
> Much of the contention is in __update_cfs_rq_tg_load_contrib when we
> update the tg load contribution stats.  However, it turns out that in many
> cases, they don't need to be updated and "tg_contrib" is 0.
> 
> This patch adds a check in __update_cfs_rq_tg_load_contrib to skip updating
> tg load contribution stats when nothing needs to be updated. This reduces the
> cacheline contention that would be unnecessary. In the above case, with the
> patch, perf reports the total time spent in this function went down by more
> than a factor of 3x:
> 
>    1.18%        reaim  [kernel.kallsyms]        [k] update_cfs_rq_blocked_load
> 

Supposedly adding something like __cacheline_aligned to
task_group::load_avg is also rumoured to help.
