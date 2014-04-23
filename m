Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaDWLps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:45:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaDWLpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:45:45 -0400
Date: Wed, 23 Apr 2014 13:45:29 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/tool: Fix usage of trace events with '-' in trace
 system name.
Message-ID: <20140423114529.GB11124@krava.brq.redhat.com>
References: <1395694140-43447-1-git-send-email-borntraeger@de.ibm.com>
 <53315741.9010508@redhat.com>
 <20140417113221.GA7422@krava.brq.redhat.com>
 <874n1mg021.wl%yarygin@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874n1mg021.wl%yarygin@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 07:43:50PM +0400, Alexander Yarygin wrote:

SNIP

> 
> --- a/tools/perf/tests/parse-events.c
> +++ b/tools/perf/tests/parse-events.c
> @@ -1346,6 +1346,12 @@ static struct evlist_test test__events[] = {
>  		.name  = "{cycles,cache-misses,branch-misses}:D",
>  		.check = test__pinned_group,
>  	},
> +#if defined(__s390x__)
> +	[42] = {
> +		.name  = "kvm-s390:kvm_s390_create_vm",
> +		.check = test__checkevent_tracepoint,
> +	},
> +#endif /* and what will be the next number: 42 or 43? */
>  };
> 
>  static struct evlist_test test__events_pmu[] = {
> 
> 
> Because it breaks explicit numbering of test__events[].
> I can suggest to move numeration into evlist_test, i.e.
> 
> --- a/tools/perf/tests/parse-events.c
> +++ b/tools/perf/tests/parse-events.c
> @@ -1174,25 +1174,30 @@ static int test__all_tracepoints(struct perf_evlist *evlist)
>  struct evlist_test {
>  	const char *name;
>  	__u32 type;
> +	int index;
>  	int (*check)(struct perf_evlist *evlist);
>  };
>  
>  static struct evlist_test test__events[] = {
> -	[0] = {
> +	{
>  		.name  = "syscalls:sys_enter_open",
>  		.check = test__checkevent_tracepoint,
> +		.index = 0;
>  	},
> ...
> 
> or just to remove it?

right, that numbering is there to ease the search for test,
and is printed for -v option

the 'index' field should be fine, and please print it
out for '-v' option


> 
> How do you think?
> 
> 
> And a bit of offtopic :)
> Apparently, s390 doesn't have syscalls:*, so some of the tests
> don't work properly (or maybe I missed something? I set CONFIG_FTRACE_SYSCALLS
> to 'y' in my config: still no syscalls:*).
> 
> What do you think about this idea:
> 
> --- a/tools/perf/tests/parse-events.c
> +++ b/tools/perf/tests/parse-events.c
> @@ -1177,13 +1177,21 @@ struct evlist_test {
>  	int (*check)(struct perf_evlist *evlist);
>  };
> 
> +#if !defined(__s390x__)
> +#define TP_SYS_NAME "syscalls"
> +#define TP_EVENT_NAME "sys_enter_open"
> +#else
> +#define TP_SYS_NAME "sched"
> +#define TP_EVENT_NAME "sched_wakeup"
> +#endif
> +
>  static struct evlist_test test__events[] = {
>  	[0] = {
> -		.name  = "syscalls:sys_enter_open",
> +		.name  = TP_SYS_NAME ":" TP_EVENT_NAME,
>  		.check = test__checkevent_tracepoint,
>  	},
> 
> ... and so on?

that looks fine.. also we could use just generic tracepoints
like the 'sched' ones

> 
> Also, test_pmu() looks at /sys/bus/event_source/devices/cpu/
> but instead of "cpu/" on s390 there are "cpum_sf/" and "cpum_cf/",
> so pmu tests don't work either..

we could #ifdef the pmu name for s390 and other archs

or make it more fancy and detect it by using pmu.c code,
please check perf_pmu__scan,perf_pmu__find functions

thanks,
jirka
