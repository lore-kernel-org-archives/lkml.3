Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbaCNONy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:13:54 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:65175 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbaCNONw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:13:52 -0400
Date: Fri, 14 Mar 2014 11:13:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/5] perf tools: Allocate thread map_groups dynamicaly
Message-ID: <20140314141344.GC2396@ghostprotocols.net>
References: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
 <1394805606-25883-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394805606-25883-4-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 14, 2014 at 03:00:04PM +0100, Jiri Olsa escreveu:
> Moving towards sharing map groups within a process threads.
> 
> Because of this we need the map groups to be dynamically
> allocated. No other functional change is intended in here.

When I saw the get() idiom I thought: cool, he is doing refcounting, but
as I see it you're using it just to make sure that it gets allocated.

I'm continuing to read the patches, but I thought it would be better to
make sure it gets allocated at some suitable moment, that at first sight
doesn't seem to be "the first time it is accessed anywhere", for
instance, I wouldn't expect at all that it would be allocated just
before calling __map_groups__fprintf_maps() :-)

- Arnaldo
 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> ---
>  tools/perf/arch/x86/tests/dwarf-unwind.c |  2 +-
>  tools/perf/ui/stdio/hist.c               |  8 ++++-
>  tools/perf/util/event.c                  |  4 +--
>  tools/perf/util/machine.c                |  6 ++--
>  tools/perf/util/map.h                    |  1 -
>  tools/perf/util/thread.c                 | 52 +++++++++++++++++++++++++++-----
>  tools/perf/util/thread.h                 | 10 ++++--
>  7 files changed, 64 insertions(+), 19 deletions(-)
> 
> diff --git a/tools/perf/arch/x86/tests/dwarf-unwind.c b/tools/perf/arch/x86/tests/dwarf-unwind.c
> index b602ad9..d804511 100644
> --- a/tools/perf/arch/x86/tests/dwarf-unwind.c
> +++ b/tools/perf/arch/x86/tests/dwarf-unwind.c
> @@ -23,7 +23,7 @@ static int sample_ustack(struct perf_sample *sample,
>  
>  	sp = (unsigned long) regs[PERF_REG_X86_SP];
>  
> -	map = map_groups__find(&thread->mg, MAP__FUNCTION, (u64) sp);
> +	map = map_groups__find(thread->mg, MAP__FUNCTION, (u64) sp);
>  	if (!map) {
>  		pr_debug("failed to get stack map\n");
>  		return -1;
> diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
> index 9bad892..880238e 100644
> --- a/tools/perf/ui/stdio/hist.c
> +++ b/tools/perf/ui/stdio/hist.c
> @@ -496,7 +496,13 @@ print_entries:
>  			break;
>  
>  		if (h->ms.map == NULL && verbose > 1) {
> -			__map_groups__fprintf_maps(&h->thread->mg,
> +			struct map_groups *mg = thread__map_groups_get(h->thread);
> +
> +			if (!mg) {
> +				ret = -ENOMEM;
> +				break;
> +			}
> +			__map_groups__fprintf_maps(mg,
>  						   MAP__FUNCTION, verbose, fp);
>  			fprintf(fp, "%.10s end\n", graph_dotted_line);
>  		}
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 55eebe9..197b594 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -655,7 +655,7 @@ void thread__find_addr_map(struct thread *thread,
>  			   enum map_type type, u64 addr,
>  			   struct addr_location *al)
>  {
> -	struct map_groups *mg = &thread->mg;
> +	struct map_groups *mg = thread__map_groups_get(thread);
>  	bool load_map = false;
>  
>  	al->machine = machine;
> @@ -664,7 +664,7 @@ void thread__find_addr_map(struct thread *thread,
>  	al->cpumode = cpumode;
>  	al->filtered = false;
>  
> -	if (machine == NULL) {
> +	if ((machine == NULL) || (mg == NULL)) {
>  		al->map = NULL;
>  		return;
>  	}
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index a189faf..009dfb4 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1046,8 +1046,7 @@ int machine__process_mmap2_event(struct machine *machine,
>  	if (map == NULL)
>  		goto out_problem;
>  
> -	thread__insert_map(thread, map);
> -	return 0;
> +	return thread__insert_map(thread, map);
>  
>  out_problem:
>  	dump_printf("problem processing PERF_RECORD_MMAP2, skipping event.\n");
> @@ -1093,8 +1092,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
>  	if (map == NULL)
>  		goto out_problem;
>  
> -	thread__insert_map(thread, map);
> -	return 0;
> +	return thread__insert_map(thread, map);
>  
>  out_problem:
>  	dump_printf("problem processing PERF_RECORD_MMAP, skipping event.\n");
> diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
> index f00f058..99a6488 100644
> --- a/tools/perf/util/map.h
> +++ b/tools/perf/util/map.h
> @@ -202,5 +202,4 @@ struct map *map_groups__find_by_name(struct map_groups *mg,
>  				     enum map_type type, const char *name);
>  
>  void map_groups__flush(struct map_groups *mg);
> -
>  #endif /* __PERF_MAP_H */
> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
> index 0358882..ac77b6c 100644
> --- a/tools/perf/util/thread.c
> +++ b/tools/perf/util/thread.c
> @@ -15,7 +15,6 @@ struct thread *thread__new(pid_t pid, pid_t tid)
>  	struct thread *thread = zalloc(sizeof(*thread));
>  
>  	if (thread != NULL) {
> -		map_groups__init(&thread->mg);
>  		thread->pid_ = pid;
>  		thread->tid = tid;
>  		thread->ppid = -1;
> @@ -45,12 +44,15 @@ void thread__delete(struct thread *thread)
>  {
>  	struct comm *comm, *tmp;
>  
> -	map_groups__exit(&thread->mg);
> +	if (thread->mg)
> +		map_groups__exit(thread->mg);
> +
>  	list_for_each_entry_safe(comm, tmp, &thread->comm_list, list) {
>  		list_del(&comm->list);
>  		comm__free(comm);
>  	}
>  
> +	thread__map_groups_put(thread);
>  	free(thread);
>  }
>  
> @@ -111,13 +113,22 @@ int thread__comm_len(struct thread *thread)
>  size_t thread__fprintf(struct thread *thread, FILE *fp)
>  {
>  	return fprintf(fp, "Thread %d %s\n", thread->tid, thread__comm_str(thread)) +
> -	       map_groups__fprintf(&thread->mg, verbose, fp);
> +	       map_groups__fprintf(thread->mg, verbose, fp);
>  }
>  
> -void thread__insert_map(struct thread *thread, struct map *map)
> +int thread__insert_map(struct thread *thread, struct map *map)
>  {
> -	map_groups__fixup_overlappings(&thread->mg, map, verbose, stderr);
> -	map_groups__insert(&thread->mg, map);
> +	struct map_groups *mg = thread->mg;
> +
> +	if (!mg) {
> +		mg = thread__map_groups_get(thread);
> +		if (!mg)
> +			return -ENOMEM;
> +	}
> +
> +	map_groups__fixup_overlappings(mg, map, verbose, stderr);
> +	map_groups__insert(mg, map);
> +	return 0;
>  }
>  
>  int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
> @@ -135,10 +146,37 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
>  	}
>  
>  	for (i = 0; i < MAP__NR_TYPES; ++i)
> -		if (map_groups__clone(&thread->mg, &parent->mg, i) < 0)
> +		if (map_groups__clone(thread->mg, parent->mg, i) < 0)
>  			return -ENOMEM;
>  
>  	thread->ppid = parent->tid;
>  
>  	return 0;
>  }
> +
> +static struct map_groups* thread__map_groups_alloc(struct thread *thread)
> +{
> +	struct map_groups* mg = zalloc(sizeof(*mg));
> +
> +	if (mg) {
> +		map_groups__init(mg);
> +		thread->mg = mg;
> +	}
> +
> +	return mg;
> +}
> +
> +struct map_groups* thread__map_groups_get(struct thread *thread)
> +{
> +	struct map_groups* mg = thread->mg;
> +
> +	if (!mg)
> +		mg = thread__map_groups_alloc(thread);
> +
> +	return mg;
> +}
> +
> +void thread__map_groups_put(struct thread *thread)
> +{
> +	zfree(&thread->mg);
> +}
> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
> index 5b856bf..77d0be2 100644
> --- a/tools/perf/util/thread.h
> +++ b/tools/perf/util/thread.h
> @@ -13,7 +13,7 @@ struct thread {
>  		struct rb_node	 rb_node;
>  		struct list_head node;
>  	};
> -	struct map_groups	mg;
> +	struct map_groups	*mg;
>  	pid_t			pid_; /* Not all tools update this */
>  	pid_t			tid;
>  	pid_t			ppid;
> @@ -40,14 +40,14 @@ int thread__set_comm(struct thread *thread, const char *comm, u64 timestamp);
>  int thread__comm_len(struct thread *thread);
>  struct comm *thread__comm(const struct thread *thread);
>  const char *thread__comm_str(const struct thread *thread);
> -void thread__insert_map(struct thread *thread, struct map *map);
> +int thread__insert_map(struct thread *thread, struct map *map);
>  int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp);
>  size_t thread__fprintf(struct thread *thread, FILE *fp);
>  
>  static inline struct map *thread__find_map(struct thread *thread,
>  					   enum map_type type, u64 addr)
>  {
> -	return thread ? map_groups__find(&thread->mg, type, addr) : NULL;
> +	return thread ? map_groups__find(thread->mg, type, addr) : NULL;
>  }
>  
>  void thread__find_addr_map(struct thread *thread, struct machine *machine,
> @@ -78,4 +78,8 @@ static inline bool thread__is_filtered(struct thread *thread)
>  	return false;
>  }
>  
> +struct map_groups* thread__map_groups_get(struct thread *thread);
> +
> +void thread__map_groups_put(struct thread *thread);
> +
>  #endif	/* __PERF_THREAD_H */
> -- 
> 1.8.3.1
