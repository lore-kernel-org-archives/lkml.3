Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458Ab3KMR7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:59:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36006 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480Ab3KMR7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:59:38 -0500
Date: Wed, 13 Nov 2013 14:59:31 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: perf top -u <uid> does not seem to be working
Message-ID: <20131113175931.GC14758@ghostprotocols.net>
References: <20131112232249.GA31384@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112232249.GA31384@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 13, 2013 at 12:22:49AM +0100, Ingo Molnar escreveu:
> Hm, this is unexpected I think:
> 
>   hubble:~> perf top --stdio -u mingo
>   Error:
>   You may not have permission to collect stats.
>   Consider tweaking /proc/sys/kernel/perf_event_paranoid:
>    -1 - Not paranoid at all
>     0 - Disallow raw tracepoint access for unpriv
>     1 - Disallow cpu events for unpriv
>     2 - Disallow kernel profiling for unpriv
> 
>   hubble:~> cat /proc/sys/kernel/perf_event_paranoid 
>   -1
> 
> (perf is the latest version from tip:perf/core)

https://lkml.org/lkml/2012/1/26/142

Fell thru the cracks, summary:

> > > +++ b/kernel/events/core.c
> > > @@ -2636,7 +2636,8 @@ find_lively_task_by_vpid(pid_t vpid)
> > >  	/* Reuse ptrace permission checks for now. */
> > >  	err = -EACCES;
> > > -	if (!ptrace_may_access(task, PTRACE_MODE_READ))
> > > +	if (perf_paranoid_tracepoint_raw() &&
> > > +	    !ptrace_may_access(task, PTRACE_MODE_READ))
> > >  		goto errout;
> > >  	return task;

> > > ptrace_may_access(task, PTRACE_MODE_READ) fails for some tasks 
> > > owned by the user because, IIRC, in __ptrace_may_access:

> > Which tasks are these, are they privileged in any sense?

> IIRC one of them was a child of sshd, that runs as root and then changes
> the child ownership to the user logging in.

- Arnaldo
