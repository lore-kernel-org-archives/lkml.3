Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab3IWGwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 02:52:36 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44528 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab3IWGwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 02:52:35 -0400
X-AuditID: 9c930179-b7c8bae000006c65-b6-523fe531ac52
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf bench sched: Add --threaded 0/1 option
References: <20130917114256.GA31159@gmail.com>
Date: Mon, 23 Sep 2013 15:52:33 +0900
In-Reply-To: <20130917114256.GA31159@gmail.com> (Ingo Molnar's message of
	"Tue, 17 Sep 2013 13:42:56 +0200")
Message-ID: <87hadcqbbi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Just a few nitpicks...

On Tue, 17 Sep 2013 13:42:56 +0200, Ingo Molnar wrote:
> Allow the measurement of thread versus process context switch performance.
>
> The default stays at 'process' based measurement, like lmbench's lat_ctx 
> benchmark.
>
> Sample output:
>
>  comet:~/tip/tools/perf> taskset 1 ./perf bench sched pipe --threaded 0
>  # Running sched/pipe benchmark...
>  # Executed 1000000 pipe operations between two processes
>
>      Total time: 4.138 [sec]
>
>        4.138729 usecs/op
>          241620 ops/sec
>  comet:~/tip/tools/perf> taskset 1 ./perf bench sched pipe --threaded 1

Why not just make it boolean?  IMHO the integer argument can confuse
users as they can think it a number of threads..


>  # Running sched/pipe benchmark...
>  # Executed 1000000 pipe operations between two threads
>
>      Total time: 3.667 [sec]
>
>        3.667667 usecs/op
>          272652 ops/sec
>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
>
> diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
> index 69cfba8..7630dc6 100644
> --- a/tools/perf/bench/sched-pipe.c
> +++ b/tools/perf/bench/sched-pipe.c
> @@ -28,12 +28,25 @@
>  #include <sys/time.h>
>  #include <sys/types.h>
>  
> +#include <pthread.h>
> +
> +struct thread_data {
> +	int			nr;
> +	int			pipe_read;
> +	int			pipe_write;
> +	pthread_t		pthread;
> +};
> +
>  #define LOOPS_DEFAULT 1000000
>  static int loops = LOOPS_DEFAULT;
>  
> +static int threaded = 0;
> +
>  static const struct option options[] = {
>  	OPT_INTEGER('l', "loop", &loops,
>  		    "Specify number of loops"),
> +	OPT_INTEGER('T', "threaded", &threaded,
> +		    "Specify threaded/process based task setup"),
>  	OPT_END()
>  };
>  
> @@ -42,13 +55,38 @@ static const char * const bench_sched_pipe_usage[] = {
>  	NULL
>  };
>  
> +static void *worker_thread(void *__tdata)
> +{
> +        struct thread_data *td = __tdata;

Whitespace damaged.  Otherwise looks good to me!

Thanks,
Namhyung


> +	int m = 0, i;
> +	int ret;
> +
> +	for (i = 0; i < loops; i++) {
> +		if (!td->nr) {
> +			ret = read(td->pipe_read, &m, sizeof(int));
> +			BUG_ON(ret != sizeof(int));
> +			ret = write(td->pipe_write, &m, sizeof(int));
> +			BUG_ON(ret != sizeof(int));
> +		} else {
> +			ret = write(td->pipe_write, &m, sizeof(int));
> +			BUG_ON(ret != sizeof(int));
> +			ret = read(td->pipe_read, &m, sizeof(int));
> +			BUG_ON(ret != sizeof(int));
> +		}
> +	}
> +
> +	return NULL;
> +}
