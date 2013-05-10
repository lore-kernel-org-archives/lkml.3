Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab3EJJEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:04:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab3EJJEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:04:23 -0400
Date: Fri, 10 May 2013 11:04:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 12/14] perf ftrace: Use pager for displaying result
Message-ID: <20130510090405.GA1040@krava.brq.redhat.com>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
 <1366705872-12132-13-git-send-email-namhyung@kernel.org>
 <20130424141724.GH971@krava.brq.redhat.com>
 <877gjr9k8q.fsf@sejong.aot.lge.com>
 <20130426084023.GB1054@krava.brq.redhat.com>
 <87ip2w98nl.fsf@sejong.aot.lge.com>
 <20130506113819.GB1093@krava.brq.redhat.com>
 <871u9i81ih.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u9i81ih.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 02:49:10PM +0900, Namhyung Kim wrote:

SNIP

> 
> 
> diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
> index f1ecfa207822..6b7aeae2dfa5 100644
> --- a/tools/perf/builtin-ftrace.c
> +++ b/tools/perf/builtin-ftrace.c
> @@ -40,9 +40,11 @@ struct perf_ftrace {
>  };
>  
>  static bool done;
> +static int _signal;
>  
>  static void sig_handler(int sig __maybe_unused)
>  {
> +	_signal = sig;
>  	done = true;
>  }
>  
> @@ -218,6 +220,20 @@ static int do_ftrace_live(struct perf_ftrace *ftrace)
>  
>  	perf_evlist__start_workload(ftrace->evlist);
>  
> +	BUG_ON(ftrace->evlist->threads->map[0] != ftrace->evlist->workload.pid);
> +
> +	trace_file = get_tracing_file("tracing_on");
> +	if (trace_file) {
> +		int fd = open(trace_file, O_RDONLY);
> +
> +		BUG_ON(fd < 0);
> +		BUG_ON(read(fd, buf, sizeof(buf)) < 0);
> +		BUG_ON(buf[0] != '1');
> +
> +		close(fd);
> +		put_tracing_file(trace_file);
> +	}
> +
>  	while (!done) {
>  		if (poll(&pollfd, 1, -1) < 0)
>  			break;
> @@ -231,6 +247,7 @@ static int do_ftrace_live(struct perf_ftrace *ftrace)
>  		}
>  	}
>  
> +	psignal(_signal, "perf");
>  	write_tracing_file("tracing_on", "0");
>  
>  	/* read remaining buffer contents */
> 
> 

yep, that did it.. seems I'm getting the ftrace output
all the time, with:

[jolsa@krava perf]$ sudo ./perf --no-pager ftrace live ls -l /usr/ 2>&1  | grep perf
perf: Child exited
[jolsa@krava perf]$ sudo ./perf --no-pager ftrace live ls -l /usr/ 2>&1  | grep perf
 1)   0.030 us    |   perf: Child exited
[jolsa@krava perf]$ sudo ./perf --no-pager ftrace live ls -l /usr/ 2>&1  | grep perf
 1)          perf: Child exited
[jolsa@krava perf]$ sudo ./perf --no-pager ftrace live ls -l /usr/ 2>&1  | grep perf
 2)   perf: Child exited
[jolsa@krava perf]$ sudo ./perf --no-pager ftrace live ls -l /usr/ 2>&1  | grep perf
 1)   4.549 us  perf: Child exited
^[[A[jolsa@krava perf]$ sudo ./perf --no-pager ftrace live ls -l /usr/ 2>&1  | grep perf
 1)   0.024 us    |       perf: Child exited


thanks,
jirka
