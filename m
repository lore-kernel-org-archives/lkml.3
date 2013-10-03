Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3JCI4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 04:56:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40243 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab3JCI4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 04:56:43 -0400
Date: Thu, 3 Oct 2013 10:56:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [BUG] perf tests: Test converting perf time to TSC
Message-ID: <20131003085625.GA3081@twins.programming.kicks-ass.net>
References: <20131002132308.GB20396@krava.brq.redhat.com>
 <524C23D3.6020300@intel.com>
 <20131003081737.GB993@krava.brq.redhat.com>
 <524D2E06.5020801@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524D2E06.5020801@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 11:42:46AM +0300, Adrian Hunter wrote:
> On 03/10/13 11:17, Jiri Olsa wrote:
> > On Wed, Oct 02, 2013 at 04:46:59PM +0300, Adrian Hunter wrote:
> >> On 02/10/13 16:23, Jiri Olsa wrote:
> >>> hi,
> >>> got a segfault in the tsc test on latest acme's tree.
> >>>
> >>> I'm dealing with some other issues right now, so just reporting ;-)
> >>
> >> The capability bits have changed positions.  You need to have:
> >>
> >> commit fa7315871046b9a4c48627905691dbde57e51033
> >> Author: Peter Zijlstra <peterz@infradead.org>
> >> Date:   Thu Sep 19 10:16:42 2013 +0200
> >>
> >>     perf: Fix capabilities bitfield compatibility in 'struct
> >> perf_event_mmap_page'
> > 
> > ok, I'll try that.. but anyway, the test should
> > not crash in account of missing kernel change 
> 
> No the ABI is broken in that case - better to crash.

No; neither case should crash.

Anyway; looking at this, why does time_zero have these different checks
from the other time bits?

@@ -1897,6 +1898,11 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
        userpg->time_mult = this_cpu_read(cyc2ns);
        userpg->time_shift = CYC2NS_SCALE_FACTOR;
        userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
+
+       if (sched_clock_stable && !check_tsc_disabled()) {
+               userpg->cap_usr_time_zero = 1;
+               userpg->time_zero = this_cpu_read(cyc2ns_offset);
+       }
 }

That doesn't make any kind of sense.. why is cyc2ns_offset differently
tested from cyc2ns itself?
