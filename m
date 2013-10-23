Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3JWNR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:17:59 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38319 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab3JWNR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:17:57 -0400
Date: Wed, 23 Oct 2013 10:17:50 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 12/14] perf sched: Fix optimized build time
Message-ID: <20131023131750.GB14490@ghostprotocols.net>
References: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com>
 <1382427258-17495-13-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382427258-17495-13-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 22, 2013 at 10:34:16AM +0300, Adrian Hunter escreveu:
> builtin-sched.c took a log time to build with
> -O6 optimization. This turned out to be caused
> by:
> 
> 	.curr_pid = { [0 ... MAX_CPUS - 1] = -1 },
> 
> Fix by initializing curr_pid programmatically.

Ok, understood, so its just this bit that was causing the delay,
applying both patches, thanks!

- Arnaldo
 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/builtin-sched.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
> index 5a33856..ddb5dc1 100644
> --- a/tools/perf/builtin-sched.c
> +++ b/tools/perf/builtin-sched.c
> @@ -1670,7 +1670,6 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
>  		.sort_list	      = LIST_HEAD_INIT(sched.sort_list),
>  		.start_work_mutex     = PTHREAD_MUTEX_INITIALIZER,
>  		.work_done_wait_mutex = PTHREAD_MUTEX_INITIALIZER,
> -		.curr_pid	      = { [0 ... MAX_CPUS - 1] = -1 },
>  		.sort_order	      = default_sort_order,
>  		.replay_repeat	      = 10,
>  		.profile_cpu	      = -1,
> @@ -1732,6 +1731,10 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
>  		.switch_event	    = replay_switch_event,
>  		.fork_event	    = replay_fork_event,
>  	};
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(sched.curr_pid); i++)
> +		sched.curr_pid[i] = -1;
>  
>  	argc = parse_options(argc, argv, sched_options, sched_usage,
>  			     PARSE_OPT_STOP_AT_NON_OPTION);
> -- 
> 1.7.11.7
