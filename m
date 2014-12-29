Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaL2NqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 08:46:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:44818 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbaL2NqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 08:46:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,659,1413270000"; 
   d="scan'208";a="654460518"
Message-ID: <54A15AB5.6050806@intel.com>
Date: Mon, 29 Dec 2014 15:44:21 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 05/37] perf tools: Create separate mmap for dummy tracking
 event
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org> <1419405333-27952-6-git-send-email-namhyung@kernel.org>
In-Reply-To: <1419405333-27952-6-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/12/14 09:15, Namhyung Kim wrote:
> When multi file support is enabled, a dummy tracking event will be
> used to track metadata (like task, comm and mmap events) for a session
> and actual samples will be recorded in separate files.
> 
> Provide separate mmap to the dummy tracking event.  The size is fixed
> to 128KiB (+ 1 page) as the event rate will be lower than samples.  I
> originally wanted to use a single mmap for this but cross-cpu sharing
> is prohibited so it's per-cpu (or per-task) like normal mmaps.
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-record.c |   9 +++-
>  tools/perf/util/evlist.c    | 104 +++++++++++++++++++++++++++++++++++---------
>  tools/perf/util/evlist.h    |  11 ++++-
>  3 files changed, 102 insertions(+), 22 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 054c6e57d3b9..129fab35fdc5 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -69,7 +69,7 @@ static int process_synthesized_event(struct perf_tool *tool,
>  
>  static int record__mmap_read(struct record *rec, int idx)
>  {
> -	struct perf_mmap *md = &rec->evlist->mmap[idx];
> +	struct perf_mmap *md = perf_evlist__mmap_desc(rec->evlist, idx);
>  	unsigned int head = perf_mmap__read_head(md);
>  	unsigned int old = md->prev;
>  	unsigned char *data = md->base + page_size;
> @@ -105,6 +105,7 @@ static int record__mmap_read(struct record *rec, int idx)
>  	}
>  
>  	md->prev = old;
> +
>  	perf_evlist__mmap_consume(rec->evlist, idx);
>  out:
>  	return rc;
> @@ -263,6 +264,12 @@ static int record__mmap_read_all(struct record *rec)
>  				goto out;
>  			}
>  		}
> +		if (rec->evlist->track_mmap) {
> +			if (record__mmap_read(rec, track_mmap_idx(i)) != 0) {
> +				rc = -1;
> +				goto out;
> +			}
> +		}
>  	}
>  
>  	/*
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 72dff295237e..d99343b988fe 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -27,6 +27,7 @@
>  
>  static void perf_evlist__mmap_put(struct perf_evlist *evlist, int idx);
>  static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx);
> +static void __perf_evlist__munmap_track(struct perf_evlist *evlist, int idx);
>  
>  #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
>  #define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
> @@ -735,22 +736,39 @@ static bool perf_mmap__empty(struct perf_mmap *md)
>  	return perf_mmap__read_head(md) != md->prev;
>  }
>  
> +struct perf_mmap *perf_evlist__mmap_desc(struct perf_evlist *evlist, int idx)
> +{
> +	if (idx >= 0)
> +		return &evlist->mmap[idx];
> +	else
> +		return &evlist->track_mmap[track_mmap_idx(idx)];
> +}
> +
>  static void perf_evlist__mmap_get(struct perf_evlist *evlist, int idx)
>  {
> -	++evlist->mmap[idx].refcnt;
> +	struct perf_mmap *md = perf_evlist__mmap_desc(evlist, idx);
> +
> +	++md->refcnt;
>  }
>  
>  static void perf_evlist__mmap_put(struct perf_evlist *evlist, int idx)
>  {
> -	BUG_ON(evlist->mmap[idx].refcnt == 0);
> +	struct perf_mmap *md = perf_evlist__mmap_desc(evlist, idx);
> +
> +	BUG_ON(md->refcnt == 0);
> +
> +	if (--md->refcnt != 0)
> +		return;
>  
> -	if (--evlist->mmap[idx].refcnt == 0)
> +	if (idx >= 0)
>  		__perf_evlist__munmap(evlist, idx);
> +	else
> +		__perf_evlist__munmap_track(evlist, track_mmap_idx(idx));
>  }
>  
>  void perf_evlist__mmap_consume(struct perf_evlist *evlist, int idx)
>  {
> -	struct perf_mmap *md = &evlist->mmap[idx];
> +	struct perf_mmap *md = perf_evlist__mmap_desc(evlist, idx);
>  
>  	if (!evlist->overwrite) {
>  		unsigned int old = md->prev;
> @@ -771,6 +789,15 @@ static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
>  	}
>  }
>  
> +static void __perf_evlist__munmap_track(struct perf_evlist *evlist, int idx)
> +{
> +	if (evlist->track_mmap[idx].base != NULL) {
> +		munmap(evlist->track_mmap[idx].base, TRACK_MMAP_SIZE);
> +		evlist->track_mmap[idx].base = NULL;
> +		evlist->track_mmap[idx].refcnt = 0;
> +	}
> +}
> +
>  void perf_evlist__munmap(struct perf_evlist *evlist)
>  {
>  	int i;
> @@ -782,23 +809,43 @@ void perf_evlist__munmap(struct perf_evlist *evlist)
>  		__perf_evlist__munmap(evlist, i);
>  
>  	zfree(&evlist->mmap);
> +
> +	if (evlist->track_mmap == NULL)
> +		return;
> +
> +	for (i = 0; i < evlist->nr_mmaps; i++)
> +		__perf_evlist__munmap_track(evlist, i);
> +
> +	zfree(&evlist->track_mmap);
>  }
>  
> -static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
> +static int perf_evlist__alloc_mmap(struct perf_evlist *evlist, bool track_mmap)
>  {
>  	evlist->nr_mmaps = cpu_map__nr(evlist->cpus);
>  	if (cpu_map__empty(evlist->cpus))
>  		evlist->nr_mmaps = thread_map__nr(evlist->threads);
>  	evlist->mmap = zalloc(evlist->nr_mmaps * sizeof(struct perf_mmap));
> -	return evlist->mmap != NULL ? 0 : -ENOMEM;
> +	if (evlist->mmap == NULL)
> +		return -ENOMEM;
> +
> +	if (track_mmap) {
> +		evlist->track_mmap = calloc(evlist->nr_mmaps,
> +					    sizeof(struct perf_mmap));
> +		if (evlist->track_mmap == NULL) {
> +			zfree(&evlist->mmap);
> +			return -ENOMEM;
> +		}
> +	}
> +	return 0;
>  }
>  
>  struct mmap_params {
> -	int prot;
> -	int mask;
> +	int	prot;
> +	size_t	len;
>  };
>  
> -static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
> +static int __perf_evlist__mmap(struct perf_evlist *evlist __maybe_unused,
> +			       struct perf_mmap *pmmap,
>  			       struct mmap_params *mp, int fd)
>  {
>  	/*
> @@ -814,15 +861,14 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
>  	 * evlist layer can't just drop it when filtering events in
>  	 * perf_evlist__filter_pollfd().
>  	 */
> -	evlist->mmap[idx].refcnt = 2;
> -	evlist->mmap[idx].prev = 0;
> -	evlist->mmap[idx].mask = mp->mask;
> -	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, mp->prot,
> -				      MAP_SHARED, fd, 0);
> -	if (evlist->mmap[idx].base == MAP_FAILED) {
> +	pmmap->refcnt = 2;
> +	pmmap->prev = 0;
> +	pmmap->mask = mp->len - page_size - 1;
> +	pmmap->base = mmap(NULL, mp->len, mp->prot, MAP_SHARED, fd, 0);
> +	if (pmmap->base == MAP_FAILED) {
>  		pr_debug2("failed to mmap perf event ring buffer, error %d\n",
>  			  errno);
> -		evlist->mmap[idx].base = NULL;
> +		pmmap->base = NULL;
>  		return -1;
>  	}
>  
> @@ -843,9 +889,22 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
>  
>  		fd = FD(evsel, cpu, thread);
>  
> -		if (*output == -1) {
> +		if (perf_evsel__is_dummy_tracking(evsel)) {
> +			struct mmap_params track_mp = {
> +				.prot	= mp->prot,
> +				.len	= TRACK_MMAP_SIZE,
> +			};
> +
> +			if (__perf_evlist__mmap(evlist, &evlist->track_mmap[idx],
> +						&track_mp, fd) < 0)
> +				return -1;
> +
> +			/* mark idx as track mmap idx (negative) */
> +			idx = track_mmap_idx(idx);

Do you not still need to do SET_OUTPUT when there are multiple cpus and
multiple pids?


> +		} else if (*output == -1) {
>  			*output = fd;
> -			if (__perf_evlist__mmap(evlist, idx, mp, *output) < 0)
> +			if (__perf_evlist__mmap(evlist, &evlist->mmap[idx],
> +						mp, *output) < 0)
>  				return -1;
>  		} else {
>  			if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, *output) != 0)
> @@ -874,6 +933,11 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
>  			perf_evlist__set_sid_idx(evlist, evsel, idx, cpu,
>  						 thread);
>  		}
> +
> +		if (mp->track && perf_evsel__is_dummy_tracking(evsel)) {
> +			/* restore idx as normal idx (positive) */
> +			idx = track_mmap_idx(idx);
> +		}
>  	}
>  
>  	return 0;
> @@ -1025,7 +1089,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
>  		.prot = PROT_READ | (overwrite ? 0 : PROT_WRITE),
>  	};
>  
> -	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
> +	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist, use_track_mmap) < 0)
>  		return -ENOMEM;
>  
>  	if (evlist->pollfd.entries == NULL && perf_evlist__alloc_pollfd(evlist) < 0)
> @@ -1034,7 +1098,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
>  	evlist->overwrite = overwrite;
>  	evlist->mmap_len = perf_evlist__mmap_size(pages);
>  	pr_debug("mmap size %zuB\n", evlist->mmap_len);
> -	mp.mask = evlist->mmap_len - page_size - 1;
> +	mp.len = evlist->mmap_len;
>  
>  	evlist__for_each(evlist, evsel) {
>  		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
> diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
> index b974bddf6b8b..b7f54b8577f7 100644
> --- a/tools/perf/util/evlist.h
> +++ b/tools/perf/util/evlist.h
> @@ -48,11 +48,14 @@ struct perf_evlist {
>  	bool		 overwrite;
>  	struct fdarray	 pollfd;
>  	struct perf_mmap *mmap;
> +	struct perf_mmap *track_mmap;
>  	struct thread_map *threads;
>  	struct cpu_map	  *cpus;
>  	struct perf_evsel *selected;
>  };
>  
> +#define TRACK_MMAP_SIZE  (((128 * 1024 / page_size) + 1) * page_size)
> +
>  struct perf_evsel_str_handler {
>  	const char *name;
>  	void	   *handler;
> @@ -100,8 +103,8 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
>  struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id);
>  
>  union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx);
> -
>  void perf_evlist__mmap_consume(struct perf_evlist *evlist, int idx);
> +struct perf_mmap *perf_evlist__mmap_desc(struct perf_evlist *evlist, int idx);
>  
>  int perf_evlist__open(struct perf_evlist *evlist);
>  void perf_evlist__close(struct perf_evlist *evlist);
> @@ -211,6 +214,12 @@ bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str);
>  void perf_evlist__to_front(struct perf_evlist *evlist,
>  			   struct perf_evsel *move_evsel);
>  
> +/* convert from/to negative idx for track mmaps */
> +static inline int track_mmap_idx(int idx)
> +{
> +	return -idx - 1;
> +}
> +
>  /**
>   * __evlist__for_each - iterate thru all the evsels
>   * @list: list_head instance to iterate
> 

