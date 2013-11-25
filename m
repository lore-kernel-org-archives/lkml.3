Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3KYNnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:43:10 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:59344 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab3KYNnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:43:07 -0500
Date: Mon, 25 Nov 2013 10:42:59 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 2/3] perf script: Print comm, fork and exit events also
Message-ID: <20131125134259.GB20168@ghostprotocols.net>
References: <1384752894-10974-1-git-send-email-namhyung@kernel.org>
 <1384752894-10974-2-git-send-email-namhyung@kernel.org>
 <20131118135700.GB3669@ghostprotocols.net>
 <87bo1hutv7.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo1hutv7.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 19, 2013 at 09:18:20AM +0900, Namhyung Kim escreveu:
> On Mon, 18 Nov 2013 10:57:00 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Nov 18, 2013 at 02:34:53PM +0900, Namhyung Kim escreveu:
> >> If --show-task option is given, also print internal COMM, FORK and
> >> EXIT events.  It would be helpful for debugging.

> > Humm, --show-task-events is clearer albeit long :-\ With shell
> > completion shouldn't be an issue tho.
 
> Okay, will change.

Ok, waiting for a new patchset then.
 
> > Also, can't we use: perf_event__fprintf_{mmap,comm,task}?
 
> We can do it.  The output will look like below if we use
> perf_event__fprintf():
 
>           swapper     0 [009] 3350640.335261: sched:sched_switch: prev_comm=swapper/9
>             sleep  9486 [009] 3350640.335509: PERF_RECORD_COMM: sleep:9486
>             sleep  9486 [009] 3350640.335806: sched:sched_stat_runtime: comm=sleep pid=9486
>           firefox  2635 [003] 3350641.275896: PERF_RECORD_FORK(2635:9487):(2635:2635)
>           firefox  2635 [003] 3350641.275896: sched:sched_process_fork: comm=firefox pid=2635
>             sleep  9486 [009] 3350641.336009: PERF_RECORD_EXIT(9486:9486):(9486:9486)

> But I'd prefer original version below since it shows the changes more
> intuitively, no?

Well, by reusing perf_event__fprintf() we will make it clear the kind of
that event, i.e. its not a tracepoint, but a sideband record generated
by the perf infrastructure.

Or perhaps we can change perf_event__fprintf* to show:

           swapper     0 [009] 3350640.335261: sched:sched_switch: prev_comm=swapper/9
             sleep  9486 [009] 3350640.335509: perf:comm: sleep:9486
             sleep  9486 [009] 3350640.335806: sched:sched_stat_runtime: comm=sleep pid=9486
           firefox  2635 [003] 3350641.275896: perf:fork(2635:9487):(2635:2635)
           firefox  2635 [003] 3350641.275896: sched:sched_process_fork: comm=firefox pid=2635
             sleep  9486 [009] 3350641.336009: perf:exit(9486:9486):(9486:9486)

Would that look nicer here and in 'perf report -D'? Ingo?

- Arnaldo
