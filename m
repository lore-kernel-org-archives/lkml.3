Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaATTHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:07:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbaATTHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:07:07 -0500
Date: Mon, 20 Jan 2014 17:06:52 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        jolsa@redhat.com, dsahern@gmail.com
Subject: Re: [PATCH 2/2] perf stat: fix memory corruption of xyarray when
 cpumask is used
Message-ID: <20140120190652.GA2643@infradead.org>
References: <1389972846-6566-1-git-send-email-eranian@google.com>
 <1389972846-6566-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389972846-6566-3-git-send-email-eranian@google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 17, 2014 at 04:34:06PM +0100, Stephane Eranian escreveu:
> This patch fixes a memory corruption problem with the xyarray when
> the evsel fds get closed at the end of the run_perf_stat() call.
> 
> It could be triggered with:
>  # perf stat -a -e power/energy-cores/ ls
 
> When cpumask are used by events (.e.g, RAPL or uncores) then the evsel
> fds are allocated based on the actual number of CPUs monitored. That
> number can be smaller than the total number of CPUs on the system. The
> problem arises at the end by perf stat closes the fds twice. When fds
> are closed, their entry in the xyarray are set to -1. The first
> close() on the evsel is made from __run_perf_stat() and it uses the
> actual number of CPUS for the event which is how the xyarray was
> allocated for. The second is from perf_evlist_close() but that one is
> on the total number of CPUs in the system, so it assume the xyarray
> was allocated to cover it. However it was not, and some writes corrupt
> memory.
 
> The fix is in perf_evlist_close() is to first try with the
> evsel->cpus if present, if not use the evlist->cpus. That
> fixes the problem.

Humm, if there is an evsel->cpus, why does perf_evsel__close needs to
get that ncpus parameter?

My first reaction is that evsel->cpus needs to point to what is being
used for its evsel->fd member, that way we will never need to pass a
ncpus, because evsel->cpus->nr will be the size of ots evsel->fd
xyarray.

Now to figure out why is that we pass ncpus when we have evsel->cpus,
bet ->cpus came after ->fd, i.e. the assumption was that we don't ever
need to have a per evsel cpu map, as it would use the one in the evlist
that contains said evsel, but for some reason we grew evsel->cpus anyway
abd forgot to use its cpus->nr to ditch the ncpus evsel__close() parm.

I'll apply your patch, as it fixes the issue, but the above analysis
probably will led us to remove that.

But just a moment, why have you removed the evsel->fd zeroing at the end
of perf_evsel__close()? Since we called perf_evsel__free_fd(), ok, that
is because perf_evsel__free_fd() does that already, no need to zero it
again, ok, moving that to a separate, prep patch.

Thanks for looking into this, I'll get this to Ingo soon.

- Arnaldo
 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/util/evlist.c |    7 +++++--
>  tools/perf/util/evsel.c  |    2 --
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 40bd2c0..59ef280 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -1003,9 +1003,12 @@ void perf_evlist__close(struct perf_evlist *evlist)
>  	struct perf_evsel *evsel;
>  	int ncpus = cpu_map__nr(evlist->cpus);
>  	int nthreads = thread_map__nr(evlist->threads);
> +	int n;
>  
> -	evlist__for_each_reverse(evlist, evsel)
> -		perf_evsel__close(evsel, ncpus, nthreads);
> +	evlist__for_each_reverse(evlist, evsel) {
> +		n = evsel->cpus ? evsel->cpus->nr : ncpus;
> +		perf_evsel__close(evsel, n, nthreads);
> +	}
>  }
>  
>  int perf_evlist__open(struct perf_evlist *evlist)
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 22e18a2..0a878db 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -667,7 +667,6 @@ int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
>  {
>  	int cpu, thread;
>  	evsel->fd = xyarray__new(ncpus, nthreads, sizeof(int));
> -
>  	if (evsel->fd) {
>  		for (cpu = 0; cpu < ncpus; cpu++) {
>  			for (thread = 0; thread < nthreads; thread++) {
> @@ -1081,7 +1080,6 @@ void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads)
>  
>  	perf_evsel__close_fd(evsel, ncpus, nthreads);
>  	perf_evsel__free_fd(evsel);
> -	evsel->fd = NULL;
>  }
>  
>  static struct {
> -- 
> 1.7.9.5
