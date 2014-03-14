Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbaCNOSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:18:11 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:38726 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbaCNOSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:18:09 -0400
Date: Fri, 14 Mar 2014 11:18:03 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 5/5] perf tools: Share process map groups within process
 threads
Message-ID: <20140314141803.GF2396@ghostprotocols.net>
References: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
 <1394805606-25883-6-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394805606-25883-6-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 14, 2014 at 03:00:06PM +0100, Jiri Olsa escreveu:
> Sharing map groups within all process threads. This way
> there's only one copy of mmap info and it's reachale
> from any thread within the process.
> 
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
>  tools/perf/util/map.h    |  2 ++
>  tools/perf/util/thread.c | 37 ++++++++++++++++++++++++++++++++++---
>  2 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
> index 99a6488..d4c8df2 100644
> --- a/tools/perf/util/map.h
> +++ b/tools/perf/util/map.h
> @@ -59,6 +59,8 @@ struct map_groups {
>  	struct rb_root	 maps[MAP__NR_TYPES];
>  	struct list_head removed_maps[MAP__NR_TYPES];
>  	struct machine	 *machine;
> +	/* Used for thread sharing */
> +	int		  refcnt;

So in the end you use those get/put ops for ref counting, cool. We need
some more of those for other stuff like those pointers in hist_entries
to dead_threads, etc.

- Arnaldo

>  };
>  
>  static inline struct kmap *map__kmap(struct map *map)
> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
> index 7c1aad0..2599754 100644
> --- a/tools/perf/util/thread.c
> +++ b/tools/perf/util/thread.c
> @@ -156,6 +156,16 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
>  	return 0;
>  }
>  
> +static struct thread* thread__get_leader(struct thread *thread)
> +{
> +	pid_t pid = thread->pid_;
> +
> +	if (pid == thread->tid)
> +		return thread;
> +
> +	return machine__findnew_thread(thread->machine, pid, pid);
> +}
> +
>  static struct map_groups* thread__map_groups_alloc(struct thread *thread)
>  {
>  	struct map_groups* mg = zalloc(sizeof(*mg));
> @@ -172,13 +182,34 @@ struct map_groups* thread__map_groups_get(struct thread *thread)
>  {
>  	struct map_groups* mg = thread->mg;
>  
> -	if (!mg)
> -		mg = thread__map_groups_alloc(thread);
> +	if (!mg) {
> +		struct thread *leader = thread__get_leader(thread);
> +
> +		if (!leader)
> +			return NULL;
> +
> +		if (leader->mg)
> +			mg = leader->mg;
> +		else
> +			mg = thread__map_groups_alloc(leader);
> +
> +		if (leader != thread)
> +			thread->mg = mg;
> +
> +		mg->refcnt++;
> +	}
>  
>  	return mg;
>  }
>  
>  void thread__map_groups_put(struct thread *thread)
>  {
> -	zfree(&thread->mg);
> +	struct map_groups* mg = thread->mg;
> +
> +	if (mg) {
> +		BUG_ON(!mg->refcnt);
> +
> +		if (!--mg->refcnt)
> +			zfree(&thread->mg);
> +	}
>  }
> -- 
> 1.8.3.1
