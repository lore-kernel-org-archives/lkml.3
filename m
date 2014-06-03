Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaFCI5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:57:46 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:36749 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaFCI5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:57:42 -0400
Message-ID: <1401785835.32444.18.camel@localhost.localdomain>
Subject: Re: [PATCHv5] perf tools: enable close-on-exec flag on perf file
 descriptor
From: Yann Droneaud <ydroneaud@opteya.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, AdrianHunter <adrian.hunter@intel.com>,
        ydroneaud@opteya.com
Date: Tue, 03 Jun 2014 10:57:15 +0200
In-Reply-To: <20140602192320.GD7861@krava.brq.redhat.com>
References: <1389005485-12778-1-git-send-email-ydroneaud@opteya.com>
	 <20140106112436.GF31570@twins.programming.kicks-ass.net>
	 <20140106144347.GA13500@ghostprotocols.net>
	 <20140106142220.GB1183@krava.brq.redhat.com>
	 <1389463628-24869-1-git-send-email-ydroneaud@opteya.com>
	 <1389607770-4485-1-git-send-email-ydroneaud@opteya.com>
	 <20140115185026.GA14248@ghostprotocols.net>
	 <1390771203-28415-1-git-send-email-ydroneaud@opteya.com>
	 <1394527147-7010-1-git-send-email-ydroneaud@opteya.com>
	 <1401706594-4995-1-git-send-email-ydroneaud@opteya.com>
	 <20140602192320.GD7861@krava.brq.redhat.com>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 02 juin 2014 à 21:23 +0200, Jiri Olsa a écrit :
> On Mon, Jun 02, 2014 at 12:56:34PM +0200, Yann Droneaud wrote:
> 
> SNIP
> 
> > 
> > Hi,
> > 
> > Quite the same patch from v4. I'm interested in some
> > feedback so that I could improve the patch if needed.
> > 
> > Regards.
> > 
> > Changes from v4 [1]:
> > - rebase on next-20140530 and update commit message.
> 
> hi,
> I wasn't following on this one before.. so please shut me up
> if my comments were already discussed ;-)
> 

You had a chance to review it before :)
See http://lkml.kernel.org/r/20140106142220.GB1183@krava.brq.redhat.com

> SNIP
> 
> > index d7176830b9b2..bb4afc9fae54 100644
> > --- a/tools/perf/builtin-sched.c
> > +++ b/tools/perf/builtin-sched.c
> > @@ -10,6 +10,7 @@
> >  #include "util/header.h"
> >  #include "util/session.h"
> >  #include "util/tool.h"
> > +#include "util/cloexec.h"
> >  
> >  #include "util/parse-options.h"
> >  #include "util/trace-event.h"
> > @@ -434,7 +435,8 @@ static int self_open_counters(void)
> >  	attr.type = PERF_TYPE_SOFTWARE;
> >  	attr.config = PERF_COUNT_SW_TASK_CLOCK;
> >  
> > -	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
> > +	fd = sys_perf_event_open(&attr, 0, -1, -1,
> > +				 perf_event_open_cloexec_flag());
> >  
> >  	if (fd < 0)
> >  		pr_err("Error: sys_perf_event_open() syscall returned "
> > diff --git a/tools/perf/tests/bp_signal.c b/tools/perf/tests/bp_signal.c
> > index aba095489193..fdc0d3e185f9 100644
> > --- a/tools/perf/tests/bp_signal.c
> > +++ b/tools/perf/tests/bp_signal.c
> > @@ -25,6 +25,7 @@
> >  #include "tests.h"
> >  #include "debug.h"
> >  #include "perf.h"
> > +#include "../util/cloexec.h"
> 
> #include "cloexec.h" should be enough
> 

OK

> >  
> >  static int fd1;
> >  static int fd2;
> > @@ -78,7 +79,8 @@ static int bp_event(void *fn, int setup_signal)
> >  	pe.exclude_kernel = 1;
> >  	pe.exclude_hv = 1;
> >  
> > -	fd = sys_perf_event_open(&pe, 0, -1, -1, 0);
> > +	fd = sys_perf_event_open(&pe, 0, -1, -1,
> > +				 perf_event_open_cloexec_flag());
> >  	if (fd < 0) {
> >  		pr_debug("failed opening event %llx\n", pe.config);
> >  		return TEST_FAIL;
> > diff --git a/tools/perf/tests/bp_signal_overflow.c b/tools/perf/tests/bp_signal_overflow.c
> > index 44ac82179708..b0b17415f18c 100644
> > --- a/tools/perf/tests/bp_signal_overflow.c
> > +++ b/tools/perf/tests/bp_signal_overflow.c
> > @@ -24,6 +24,7 @@
> >  #include "tests.h"
> >  #include "debug.h"
> >  #include "perf.h"
> > +#include "../util/cloexec.h"
> 
> ditto
> 

OK

> >  
> >  static int overflows;
> >  
> > @@ -91,7 +92,8 @@ int test__bp_signal_overflow(void)
> >  	pe.exclude_kernel = 1;
> >  	pe.exclude_hv = 1;
> >  
> > -	fd = sys_perf_event_open(&pe, 0, -1, -1, 0);
> > +	fd = sys_perf_event_open(&pe, 0, -1, -1,
> > +				 perf_event_open_cloexec_flag());
> >  	if (fd < 0) {
> >  		pr_debug("failed opening event %llx\n", pe.config);
> >  		return TEST_FAIL;
> > diff --git a/tools/perf/tests/rdpmc.c b/tools/perf/tests/rdpmc.c
> > index e59143fd9e71..8432bfcffed6 100644
> > --- a/tools/perf/tests/rdpmc.c
> > +++ b/tools/perf/tests/rdpmc.c
> > @@ -6,6 +6,7 @@
> >  #include "perf.h"
> >  #include "debug.h"
> >  #include "tests.h"
> > +#include "../util/cloexec.h"
> 
> ditto
> 

OK

> SNIP
> 
> > +
> > +static int perf_flag_probe(void)
> > +{
> > +	/* use 'safest' configuration as used in perf_evsel__fallback() */
> > +	struct perf_event_attr attr = {
> > +		.type = PERF_COUNT_SW_CPU_CLOCK,
> > +		.config = PERF_COUNT_SW_CPU_CLOCK,
> > +	};
> > +	int fd;
> > +	int err;
> > +
> > +	/* check cloexec flag */
> > +	fd = sys_perf_event_open(&attr, 0, -1, -1,
> > +				 PERF_FLAG_FD_CLOEXEC);
> > +	if (fd >= 0) {
> > +		close(fd);
> > +		return 1;
> > +	}
> > +
> > +	if (errno != EINVAL) {
> > +		err = errno;
> > +		pr_warning("sys_perf_event_open() syscall returned "
> > +			   "%d (%d: %s)\n", fd, err, strerror(err));
> > +	}
> > +
> > +	/* not supported, confirm error related to PERF_FLAG_FD_CLOEXEC */
> > +	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
> > +	if (fd >= 0) {
> > +		close(fd);
> > +		return 0;
> > +	}
> > +
> > +	err = errno;
> > +	die("sys_perf_event_open() syscall returned "
> > +	    "%d (%d: %s)\n", fd, err, strerror(err));
> 
> I think we have a strategy of not using die in new code..
> please just use WARN_ONCE.. and let the code fail in the
> standard way
> 

OK


> SNIP
> 
> >  
> >  #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
> > @@ -988,7 +989,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
> >  			      struct thread_map *threads)
> >  {
> >  	int cpu, thread;
> > -	unsigned long flags = 0;
> > +	unsigned long flags = PERF_FLAG_FD_CLOEXEC;
> >  	int pid = -1, err;
> >  	enum { NO_CHANGE, SET_TO_MAX, INCREASED_MAX } set_rlimit = NO_CHANGE;
> >  
> > @@ -997,11 +998,13 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
> >  		return -ENOMEM;
> >  
> >  	if (evsel->cgrp) {
> > -		flags = PERF_FLAG_PID_CGROUP;
> > +		flags |= PERF_FLAG_PID_CGROUP;
> >  		pid = evsel->cgrp->fd;
> >  	}
> >  
> >  fallback_missing_features:
> > +	if (perf_missing_features.cloexec)
> > +		flags &= ~(unsigned long)PERF_FLAG_FD_CLOEXEC;
> >  	if (perf_missing_features.mmap2)
> >  		evsel->attr.mmap2 = 0;
> >  	if (perf_missing_features.exclude_guest)
> > @@ -1070,7 +1073,10 @@ try_fallback:
> >  	if (err != -EINVAL || cpu > 0 || thread > 0)
> >  		goto out_close;
> >  
> > -	if (!perf_missing_features.mmap2 && evsel->attr.mmap2) {
> > +	if (!perf_missing_features.cloexec && (flags & PERF_FLAG_FD_CLOEXEC)) {
> > +		perf_missing_features.cloexec = true;
> > +		goto fallback_missing_features;
> 
> I think it does not fit in here, because we check latest perf_event_attr
> bits and removing one after another, to see if miracle happens.
> (also looks like we miss exclude_callchain_(kernel|user) bits)
> 
> Wouldn't it be better just to use perf_event_open_cloexec_flag() function
> as you did in the rest of the code? I think we dont need 2 detection codes
> for this.
> 

I was asked by ACME to use here the missing feature detection pattern
and to treat the flag just as a new feature like perf_event_attr new
attributes.

See http://lkml.kernel.org/r/20140106144347.GA13500@ghostprotocols.net
    http://lkml.kernel.org/r/20140106211444.GD2810@ghostprotocols.net

> > +	} else if (!perf_missing_features.mmap2 && evsel->attr.mmap2) {
> >  		perf_missing_features.mmap2 = true;
> >  		goto fallback_missing_features;
> >  	} else if (!perf_missing_features.exclude_guest &&
> > diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
> > index 049e0a09ccd3..9a8d622809f6 100644
> > --- a/tools/perf/util/record.c
> > +++ b/tools/perf/util/record.c
> > @@ -4,6 +4,7 @@
> >  #include "parse-events.h"
> >  #include <api/fs/fs.h>
> >  #include "util.h"
> > +#include "cloexec.h"
> >  
> >  typedef void (*setup_probe_fn_t)(struct perf_evsel *evsel);
> >  
> > @@ -11,6 +12,7 @@ static int perf_do_probe_api(setup_probe_fn_t fn, int cpu, const char *str)
> >  {
> >  	struct perf_evlist *evlist;
> >  	struct perf_evsel *evsel;
> > +	unsigned long flags = perf_event_open_cloexec_flag();
> >  	int err = -EAGAIN, fd;
> >  
> >  	evlist = perf_evlist__new();
> > @@ -22,14 +24,14 @@ static int perf_do_probe_api(setup_probe_fn_t fn, int cpu, const char *str)
> >  
> >  	evsel = perf_evlist__first(evlist);
> >  
> > -	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
> > +	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, flags);
> >  	if (fd < 0)
> >  		goto out_delete;
> >  	close(fd);
> >  
> >  	fn(evsel);
> >  
> > -	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
> > +	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, flags);
> >  	if (fd < 0) {
> >  		if (errno == EINVAL)
> >  			err = -EINVAL;
> > @@ -203,7 +205,8 @@ bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str)
> >  		cpu = evlist->cpus->map[0];
> >  	}
> 
> hum... no one calls this exported function ^^^ :-) I wonder why it's there.. cool
> 

Nice catch. This function was introduced by commit 
c09ec622629eeb4b7877646a42852e7156363425 ('perf evlist: Add 
can_select_event() method') by Adrian Hunter <adrian.hunter@intel.com>
and it seems it was never used by perf tools.
Is it available to some outside tree perf tools ?


Thanks for the review.

Regards

-- 
Yann Droneaud
OPTEYA


