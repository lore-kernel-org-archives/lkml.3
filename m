Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaAOSum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:50:42 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:52820 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaAOSug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:50:36 -0500
Date: Wed, 15 Jan 2014 15:50:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCHv2] perf tools: enable close-on-exec flag on perf file
 descriptor
Message-ID: <20140115185026.GA14248@ghostprotocols.net>
References: <cover.1388952061.git.ydroneaud@opteya.com>
 <8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com>
 <20140106092929.GA31570@twins.programming.kicks-ass.net>
 <1389005485-12778-1-git-send-email-ydroneaud@opteya.com>
 <20140106112436.GF31570@twins.programming.kicks-ass.net>
 <20140106144347.GA13500@ghostprotocols.net>
 <20140106142220.GB1183@krava.brq.redhat.com>
 <1389463628-24869-1-git-send-email-ydroneaud@opteya.com>
 <1389607770-4485-1-git-send-email-ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389607770-4485-1-git-send-email-ydroneaud@opteya.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 13, 2014 at 11:09:30AM +0100, Yann Droneaud escreveu:
> +++ b/tools/perf/util/cloexec.c
> @@ -0,0 +1,54 @@
> +#include "util.h"
> +#include "../perf.h"
> +#include "cloexec.h"
> +
> +static unsigned long flag = PERF_FLAG_FD_CLOEXEC;
> +
> +static int perf_flag_probe(void)
> +{
> +	struct perf_event_attr attr;
> +	int fd;
> +	int err;
> +
> +	/* check cloexec flag */
> +	memset(&attr, 0, sizeof(attr));

If you do this you'll use attr.type = PERF_TYPE_HARDWARE and
attr.config then means PERF_COUNT_HW_CPU_CYCLES, which will fail
where we don't have a PMU, see perf_evsel__fallback(), perhaps it is
better for you to go with the fallback that is most likely supported in
all arches:

                evsel->attr.type   = PERF_TYPE_SOFTWARE;       // 1
                evsel->attr.config = PERF_COUNT_SW_CPU_CLOCK;  // 0

I.e. just do a:

	struct perf_event_attr attr = { .type = 1, }; and ditch the
memset (or do a attr.type = PERF_COUNT_SW_CPU_CLOCK;, up to you).

Thanks for doing the __perf_evsel__open fallbacking!

- Arnaldo

> +	fd = sys_perf_event_open(&attr, 0, -1, -1,
> +				 PERF_FLAG_FD_CLOEXEC);
> +	if (fd >= 0) {
> +		close(fd);
> +		return 1;
> +	}
> +
> +	if (errno != EINVAL) {
> +		err = errno;
> +		pr_warning("sys_perf_event_open() syscall returned "
> +			   "%d (%d: %s)\n", fd, err, strerror(err));
> +	}
> +
> +	/* not supported, confirm error related to PERF_FLAG_FD_CLOEXEC */
> +	memset(&attr, 0, sizeof(attr));
> +	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
> +	if (fd >= 0) {
> +		close(fd);
> +		return 0;
> +	}
> +
> +	err = errno;
> +	die("sys_perf_event_open() syscall returned "
> +	    "%d (%d: %s)\n", fd, err, strerror(err));
> +
> +	return -1;
> +}
> +
> +unsigned long perf_event_open_cloexec_flag(void)
> +{
> +	static bool probed;
> +
> +	if (!probed) {
> +		if (perf_flag_probe() <= 0)
> +			flag = 0;
> +		probed = true;
> +	}
> +
> +	return flag;
> +}
> diff --git a/tools/perf/util/cloexec.h b/tools/perf/util/cloexec.h
> new file mode 100644
> index 000000000000..94a5a7d829d5
> --- /dev/null
> +++ b/tools/perf/util/cloexec.h
> @@ -0,0 +1,6 @@
> +#ifndef __PERF_CLOEXEC_H
> +#define __PERF_CLOEXEC_H
> +
> +unsigned long perf_event_open_cloexec_flag(void);
> +
> +#endif /* __PERF_CLOEXEC_H */
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index ade8d9c1c431..ff845c7e7a4f 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -29,6 +29,7 @@ static struct {
>  	bool sample_id_all;
>  	bool exclude_guest;
>  	bool mmap2;
> +	bool cloexec;
>  } perf_missing_features;
>  
>  #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
> @@ -968,7 +969,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
>  			      struct thread_map *threads)
>  {
>  	int cpu, thread;
> -	unsigned long flags = 0;
> +	unsigned long flags = PERF_FLAG_FD_CLOEXEC;
>  	int pid = -1, err;
>  	enum { NO_CHANGE, SET_TO_MAX, INCREASED_MAX } set_rlimit = NO_CHANGE;
>  
> @@ -977,11 +978,13 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
>  		return -ENOMEM;
>  
>  	if (evsel->cgrp) {
> -		flags = PERF_FLAG_PID_CGROUP;
> +		flags |= PERF_FLAG_PID_CGROUP;
>  		pid = evsel->cgrp->fd;
>  	}
>  
>  fallback_missing_features:
> +	if (perf_missing_features.cloexec)
> +		flags &= ~(unsigned long)PERF_FLAG_FD_CLOEXEC;
>  	if (perf_missing_features.mmap2)
>  		evsel->attr.mmap2 = 0;
>  	if (perf_missing_features.exclude_guest)
> @@ -1050,7 +1053,10 @@ try_fallback:
>  	if (err != -EINVAL || cpu > 0 || thread > 0)
>  		goto out_close;
>  
> -	if (!perf_missing_features.mmap2 && evsel->attr.mmap2) {
> +	if (!perf_missing_features.cloexec && (flags & PERF_FLAG_FD_CLOEXEC)) {
> +		perf_missing_features.cloexec = true;
> +		goto fallback_missing_features;
> +	} else if (!perf_missing_features.mmap2 && evsel->attr.mmap2) {
>  		perf_missing_features.mmap2 = true;
>  		goto fallback_missing_features;
>  	} else if (!perf_missing_features.exclude_guest &&
> diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
> index 104a47563d39..6483ef5df31b 100644
> --- a/tools/perf/util/record.c
> +++ b/tools/perf/util/record.c
> @@ -4,6 +4,7 @@
>  #include "parse-events.h"
>  #include "fs.h"
>  #include "util.h"
> +#include "cloexec.h"
>  
>  typedef void (*setup_probe_fn_t)(struct perf_evsel *evsel);
>  
> @@ -11,6 +12,7 @@ static int perf_do_probe_api(setup_probe_fn_t fn, int cpu, const char *str)
>  {
>  	struct perf_evlist *evlist;
>  	struct perf_evsel *evsel;
> +	unsigned long flags = perf_event_open_cloexec_flag();
>  	int err = -EAGAIN, fd;
>  
>  	evlist = perf_evlist__new();
> @@ -22,14 +24,14 @@ static int perf_do_probe_api(setup_probe_fn_t fn, int cpu, const char *str)
>  
>  	evsel = perf_evlist__first(evlist);
>  
> -	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
> +	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, flags);
>  	if (fd < 0)
>  		goto out_delete;
>  	close(fd);
>  
>  	fn(evsel);
>  
> -	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
> +	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, flags);
>  	if (fd < 0) {
>  		if (errno == EINVAL)
>  			err = -EINVAL;
> @@ -203,7 +205,8 @@ bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str)
>  		cpu = evlist->cpus->map[0];
>  	}
>  
> -	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
> +	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1,
> +				 perf_event_open_cloexec_flag());
>  	if (fd >= 0) {
>  		close(fd);
>  		ret = true;
> -- 
> 1.8.4.2
