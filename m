Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbaIZOWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:22:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:34809 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbaIZOWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:22:41 -0400
Date: Fri, 26 Sep 2014 11:22:34 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v4 2/2] perf tool: improves DSO long names lookup speed
 with rbtree
Message-ID: <20140926142234.GC3879@kernel.org>
References: <1411573540-8765-1-git-send-email-Waiman.Long@hp.com>
 <1411573540-8765-3-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411573540-8765-3-git-send-email-Waiman.Long@hp.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 24, 2014 at 11:45:40AM -0400, Waiman Long escreveu:
> With workload that spawns and destroys many threads and processes,
> it was found that perf-mem could took a long time to post-process
> the perf data after the target workload had completed its operation.
> The performance bottleneck was found to be the lookup and insertion
> of the new DSO structures (thousands of them in this case).
> 
> In a dual-socket Ivy-Bridge E7-4890 v2 machine (30-core, 60-thread),
> the perf profile below shows what perf was doing after the profiled
> AIM7 shared workload completed:
> 
> -     83.94%  perf  libc-2.11.3.so     [.] __strcmp_sse42
>    - __strcmp_sse42
>       - 99.82% map__new
>            machine__process_mmap_event
>            perf_session_deliver_event
>            perf_session__process_event
>            __perf_session__process_events
>            cmd_record
>            cmd_mem
>            run_builtin
>            main
>            __libc_start_main
> -     13.17%  perf  perf               [.] __dsos__findnew
>      __dsos__findnew
>      map__new
>      machine__process_mmap_event
>      perf_session_deliver_event
>      perf_session__process_event
>      __perf_session__process_events
>      cmd_record
>      cmd_mem
>      run_builtin
>      main
>      __libc_start_main
> 
> So about 97% of CPU times were spent in the map__new() function
> trying to insert new DSO entry into the DSO linked list. The whole
> post-processing step took about 9 minutes.
> 
> The DSO structures are currently searched linearly. So the total
> processing time will be proportional to n^2.
> 
> To overcome this performance problem, the DSO code is modified to
> also put the DSO structures in a RB tree sorted by its long name
> in additional to being in a simple linked list. With this change,
> the processing time will become proportional to n*log(n) which will
> be much quicker for large n. However, the short name will still be
> searched using the old linear searching method.  With that patch
> in place, the same perf-mem post-processing step took less than 30
> seconds to complete.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>  tools/perf/util/dso.c     |   73 ++++++++++++++++++++++++++++++++++++++++++--
>  tools/perf/util/dso.h     |    1 +
>  tools/perf/util/machine.h |    4 ++-
>  3 files changed, 73 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
> index c2c6134..810a4b5 100644
> --- a/tools/perf/util/dso.c
> +++ b/tools/perf/util/dso.c
> @@ -651,6 +651,67 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
>  	return dso;
>  }
>  
> +/*
> + * Find a matching entry and/or link current entry to RB tree.
> + * Either one of the dso or name parameter must be non-NULL or the
> + * function will not work.
> + */
> +static struct dso *dso__findlink_by_longname(struct rb_root *root,
> +					     struct dso *dso, const char *name)
> +{
> +	struct rb_node **p = &root->rb_node;
> +	struct rb_node  *parent = NULL;
> +	int warned = false;
> +
> +	if (!name)
> +		name = dso->long_name;
> +	/*
> +	 * Find node with the matching name
> +	 */
> +	while (*p) {
> +		struct dso *this = rb_entry(*p, struct dso, rb_node);
> +		long rc = (long)strcmp(name, this->long_name);
> +
> +		parent = *p;
> +		if (rc == 0) {
> +			/*
> +			 * In case the new DSO is a duplicate of an existing
> +			 * one, print an one-time warning & sort the entry
> +			 * by its DSO address.
> +			 */
> +			if (!dso || (dso == this))
> +				return this;	/* Find matching dso */
> +			/*
> +			 * The kernel DSOs may have duplicated long name,
> +			 * so don't print warning for them.
> +			 */
> +			if (!warned && !strstr(name, "kernel.kallsyms")
> +				    && !strstr(name, "/vmlinux")) {
> +				pr_warning("Duplicated dso long name: %s\n",
> +					   name);

Huh? Can you elaborate on this? Ho can we add multiple DSOs with the
exact same name into this tree? Have you actually seen this in practice?
I guess so, judging by the comment above ("may have").

I'll try the patch to see if I get these warnings...

But initial reaction to these long casts and fallbacking to pointer
arithmetic for tree searching/inserting looked ugly :-\

- Arnaldo

> +				warned = true;
> +			}
> +			rc = (long)dso - (long)this;
> +		}
> +		if (rc < 0)
> +			p = &parent->rb_left;
> +		else
> +			p = &parent->rb_right;
> +	}
> +	if (dso) {
> +		/* Add new node and rebalance tree */
> +		rb_link_node(&dso->rb_node, parent, p);
> +		rb_insert_color(&dso->rb_node, root);
> +	}
> +	return NULL;
> +}
> +
> +static inline struct dso *
> +dso__find_by_longname(struct rb_root *root, const char *name)
> +{
> +	return dso__findlink_by_longname(root, NULL, name);
> +}
> +
>  void dso__set_long_name(struct dso *dso, const char *name, bool name_allocated)
>  {
>  	if (name == NULL)
> @@ -754,6 +815,7 @@ struct dso *dso__new(const char *name)
>  		dso->kernel = DSO_TYPE_USER;
>  		dso->needs_swap = DSO_SWAP__UNSET;
>  		dso->dsos = NULL;
> +		RB_CLEAR_NODE(&dso->rb_node);
>  		INIT_LIST_HEAD(&dso->node);
>  		INIT_LIST_HEAD(&dso->data.open_entry);
>  	}
> @@ -776,6 +838,11 @@ void dso__delete(struct dso *dso)
>  		zfree((char **)&dso->long_name);
>  		dso->long_name_allocated = false;
>  	}
> +	if (dso->dsos) {
> +		/* Remove entry from rbtree */
> +		rb_erase(&dso->rb_node, &dso->dsos->root);
> +		dso->dsos = NULL;
> +	}
>  
>  	dso__data_close(dso);
>  	dso_cache__free(&dso->data.cache);
> @@ -854,6 +921,7 @@ void dsos__add(struct dsos *dsos, struct dso *dso)
>  {
>  	dso->dsos = dsos;
>  	list_add_tail(&dso->node, &dsos->head);
> +	dso__findlink_by_longname(&dsos->root, dso, NULL);
>  }
>  
>  struct dso *dsos__find(const struct dsos *dsos, const char *name,
> @@ -867,10 +935,7 @@ struct dso *dsos__find(const struct dsos *dsos, const char *name,
>  				return pos;
>  		return NULL;
>  	}
> -	list_for_each_entry(pos, &dsos->head, node)
> -		if (strcmp(pos->long_name, name) == 0)
> -			return pos;
> -	return NULL;
> +	return dso__find_by_longname((struct rb_root *)&dsos->root, name);
>  }
>  
>  struct dso *__dsos__findnew(struct dsos *dsos, const char *name)
> diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
> index cadfef7..bae7042 100644
> --- a/tools/perf/util/dso.h
> +++ b/tools/perf/util/dso.h
> @@ -94,6 +94,7 @@ struct dsos;
>  
>  struct dso {
>  	struct list_head node;
> +	struct rb_node	 rb_node;	/* rbtree node sorted by long name */
>  	struct dsos      *dsos;
>  	struct rb_root	 symbols[MAP__NR_TYPES];
>  	struct rb_root	 symbol_names[MAP__NR_TYPES];
> diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
> index d8abb6c..f7546f3 100644
> --- a/tools/perf/util/machine.h
> +++ b/tools/perf/util/machine.h
> @@ -23,10 +23,12 @@ extern const char *ref_reloc_sym_names[];
>  struct vdso_info;
>  
>  /*
> - * DSOs are put into a list for fast iteration.
> + * DSOs are put into both a list for fast iteration and rbtree for fast
> + * long name lookup.
>   */
>  struct dsos {
>  	struct list_head head;
> +	struct rb_root   root;	/* rbtree root sorted by long name */
>  };
>  
>  struct machine {
> -- 
> 1.7.1
