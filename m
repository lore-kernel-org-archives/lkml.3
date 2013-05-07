Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab3EGHBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:01:33 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58468 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3EGHBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:01:31 -0400
Date: Tue, 7 May 2013 09:01:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf: fix symbol processing bug and greatly improve
 performance
Message-ID: <20130507070127.GA17830@gmail.com>
References: <1367847833-4932-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367847833-4932-1-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <Waiman.Long@hp.com> wrote:

> When "perf record" was used on a large machine with a lot of CPUs,
> the perf post-processing time could take a lot of minutes and even
> hours depending on how large the resulting perf.data file was.
> 
> While running AIM7 1500-user high_systime workload on a 80-core x86-64
> system with a 3.9 kernel, the workload itself took about 2 minutes
> to run and the perf.data file had a size of 1108.746 MB. However,
> the post-processing step took more than 10 minutes.
> 
> With a gprof-profiled perf binary, the time spent by perf was as
> follows:
> 
>   %   cumulative   self              self     total
>  time   seconds   seconds    calls   s/call   s/call  name
>  96.90    822.10   822.10   192156     0.00     0.00  dsos__find
>   0.81    828.96     6.86 172089958     0.00     0.00  rb_next
>   0.41    832.44     3.48 48539289     0.00     0.00  rb_erase
> 
> So 97% (822 seconds) of the time was spent in a single dsos_find()
> function. After analyzing the call-graph data below:
> 
> -----------------------------------------------
>                 0.00  822.12  192156/192156      map__new [6]
> [7]     96.9    0.00  822.12  192156         vdso__dso_findnew [7]
>               822.10    0.00  192156/192156      dsos__find [8]
>                 0.01    0.00  192156/192156      dsos__add [62]
>                 0.01    0.00  192156/192366      dso__new [61]
>                 0.00    0.00       1/45282525     memdup [31]
>                 0.00    0.00  192156/192230      dso__set_long_name [91]
> -----------------------------------------------
>               822.10    0.00  192156/192156      vdso__dso_findnew [7]
> [8]     96.9  822.10    0.00  192156         dsos__find [8]
> -----------------------------------------------
> 
> It was found that the vdso__dso_findnew() function failed to locate
> VDSO__MAP_NAME ("[vdso]") in the dso list and have to insert a new
> entry at the end for 192156 times. This problem is due to the fact that
> there are 2 types of name in the dso entry - short name and long name.
> The initial dso__new() adds "[vdso]" to both the short and long names.
> After that, vdso__dso_findnew() modifies the long name to something
> like /tmp/perf-vdso.so-NoXkDj. The dsos__find() function only compares
> the long name. As a result, the same vdso entry is duplicated many
> time in the dso list. This bug increases memory consumption as well
> as slows the symbol processing time to a crawl.
> 
> To resolve this problem, the dsos__find() function interface was
> modified to enable searching either the long name or the short
> name. The vdso__dso_findnew() will now search only the short name
> while the other call sites search for the long name as before.
> 
> With this change, the cpu time of perf was reduced from 848.38s to
> 15.77s and dsos__find() only accounted for 0.06% of the total time.
> 
>   0.06     15.73     0.01   192151     0.00     0.00  dsos__find

Very nice!

I noticed that you used gprof to instrument perf itself on a call graph 
level.

Does this method of profiling perf via perf:

  perf record -g perf report
  perf report

... produce similarly useful call-graph instrumentation for you?

If not or not quite then could you describe the differences? We could use 
that to further improve perf call-graph profiling.

Thanks,

	Ingo
