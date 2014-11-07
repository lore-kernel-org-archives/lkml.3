Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaKGO5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:57:48 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43513 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbaKGO5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:57:47 -0500
Subject: Re: [PATCH 1/3] perf tools: Allow vmlinux to fallback to kallsyms
 on NO_LIBELF=1
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
In-Reply-To: <20141107082723.GB23531@worktop.programming.kicks-ass.net>
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
	 <20141107082723.GB23531@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Nov 2014 23:57:39 +0900
Message-ID: <1415372259.1648.51.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

2014-11-07 (금), 09:27 +0100, Peter Zijlstra:
> On Fri, Nov 07, 2014 at 02:20:04PM +0900, Namhyung Kim wrote:
> > When libelf is not used, perf cannot not show symbol names since it
> > doesn't access the ELF symbol table.  But kernel is different as it
> > can fallback to kallsyms.
> > 
> > It worked w/o libelf, but recent change to use vmlinux for kernel
> > symbols break it.
> > 
> > With this change, it now can show kernel symbols again:
> > 
> >   # Overhead  Command  Shared Object      Symbol
> >   # ........  .......  .................  ........................
> >   #
> >       34.51%  swapper  [kernel.kallsyms]  [k] intel_idle
> >       12.54%  perf     [kernel.kallsyms]  [k] generic_exec_single
> >       10.11%  swapper  [kernel.kallsyms]  [k] int_sqrt
> >        9.83%  swapper  [kernel.kallsyms]  [k] hrtimer_interrupt
> >        7.25%  emacs    [kernel.kallsyms]  [k] __switch_to
> >        7.06%  sleep    [kernel.kallsyms]  [k] find_next_iomem_res
> >        7.02%  swapper  [kernel.kallsyms]  [k] run_timer_softirq
> >        2.55%  swapper  [kernel.kallsyms]  [k] _raw_spin_unlock_irq
> >        1.90%  swapper  [kernel.kallsyms]  [k] lapic_next_deadline
> >        1.75%  swapper  [kernel.kallsyms]  [k] native_sched_clock
> >        1.49%  swapper  [kernel.kallsyms]  [k] __schedule
> >        1.20%  swapper  [kernel.kallsyms]  [k] read_tsc
> >        1.10%  sleep    [kernel.kallsyms]  [k] current_kernel_time
> >        0.99%  swapper  [kernel.kallsyms]  [k] pick_next_task_rt
> >        0.36%  swapper  [kernel.kallsyms]  [k] group_sched_in
> >        0.24%  swapper  [kernel.kallsyms]  [k] x86_pmu_commit_txn
> >        0.06%  swapper  [kernel.kallsyms]  [k] intel_pmu_enable_all
> >        0.03%  perf     [kernel.kallsyms]  [k] intel_pmu_enable_all
> > 
> > Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Adrian Hunter <adrian.hunter@intel.com>
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/util/symbol-minimal.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
> > index c9541fea9514..226cf41ed7e6 100644
> > --- a/tools/perf/util/symbol-minimal.c
> > +++ b/tools/perf/util/symbol-minimal.c
> > @@ -335,6 +335,9 @@ int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
> >  	unsigned char *build_id[BUILD_ID_SIZE];
> >  	int ret;
> >  
> > +	if (dso->kernel)
> > +		return 0;  /* always use kallsyms */
> > +
> >  	ret = fd__is_64_bit(ss->fd);
> >  	if (ret >= 0)
> >  		dso->is_64_bit = ret;
> 
> Why does this live in the minimal implementation; should we not always
> discard ELF files with 0 symbols?
> 
> Suppose I have a vmlinux but removed all symbols from it; I want it to
> fall back to kallsyms too.

I'm not sure I understood what you said correctly.  With this change,
dso__load_kernel_sym() always ends up calling dso__load_kallsyms() since
dso__load_vmlinux() will always return 0;

So I think you'll fall back to kallsyms even though you have a vmlinux
with symbol.  This makes dso__load_sym() in the patch 2/3 simpler IMHO.

Thanks,
Namhyung


