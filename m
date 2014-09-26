Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaIZOGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:06:43 -0400
Received: from mail.kernel.org ([198.145.19.201]:33367 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbaIZOGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:06:40 -0400
Date: Fri, 26 Sep 2014 11:06:25 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v4 1/2] perf tool: encapsulate dsos list head into struct
 dsos
Message-ID: <20140926140625.GA3879@kernel.org>
References: <1411573540-8765-1-git-send-email-Waiman.Long@hp.com>
 <1411573540-8765-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411573540-8765-2-git-send-email-Waiman.Long@hp.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 24, 2014 at 11:45:39AM -0400, Waiman Long escreveu:
> This is a precursor patch to enable long name searching of DSOs
> using the rbtree. In this patch, a new dsos structure is created
> which contains only a list head structure for the moment. The new
> dsos structure is used, in turn, in the machine structure for the
> user_dsos and kernel_dsos fields. Only the following 3 dsos functions
> are modified to accept the new dsos structure parameter instead
> of list_head:
>  - dsos__add()
>  - dsos__find()
>  - __dsos__findnew()
> 
> Because of the need to find out the corresponding dsos structure to
> properly call dsos__add() in dso__load_sym() of util/symbol-elf.c,
> a new dsos field is also added to the dso structure.

Argh, yeah, that is unfortunate that we need to add entries that deep
inside dso__load_syms() :-\

At some point I need to go over that symbols layer, in this case, doing
multiple passes could probably limit dso__load_sym() to act _just_ on
one dso, as it should not be creating any other dso :-\

Anyway, continuing to review, enough ranting :-)

- Arnaldo
 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>  tools/perf/util/dso.c         |   19 +++++++++++--------
>  tools/perf/util/dso.h         |    9 ++++++---
>  tools/perf/util/header.c      |   32 ++++++++++++++++++--------------
>  tools/perf/util/machine.c     |   24 ++++++++++++------------
>  tools/perf/util/machine.h     |   11 +++++++++--
>  tools/perf/util/probe-event.c |    3 ++-
>  tools/perf/util/symbol-elf.c  |    2 +-
>  7 files changed, 59 insertions(+), 41 deletions(-)
> 
> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
> index 90d02c6..c2c6134 100644
> --- a/tools/perf/util/dso.c
> +++ b/tools/perf/util/dso.c
> @@ -753,6 +753,7 @@ struct dso *dso__new(const char *name)
>  		dso->a2l_fails = 1;
>  		dso->kernel = DSO_TYPE_USER;
>  		dso->needs_swap = DSO_SWAP__UNSET;
> +		dso->dsos = NULL;
>  		INIT_LIST_HEAD(&dso->node);
>  		INIT_LIST_HEAD(&dso->data.open_entry);
>  	}
> @@ -849,35 +850,37 @@ bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
>  	return have_build_id;
>  }
>  
> -void dsos__add(struct list_head *head, struct dso *dso)
> +void dsos__add(struct dsos *dsos, struct dso *dso)
>  {
> -	list_add_tail(&dso->node, head);
> +	dso->dsos = dsos;
> +	list_add_tail(&dso->node, &dsos->head);
>  }
>  
> -struct dso *dsos__find(const struct list_head *head, const char *name, bool cmp_short)
> +struct dso *dsos__find(const struct dsos *dsos, const char *name,
> +		       bool cmp_short)
>  {
>  	struct dso *pos;
>  
>  	if (cmp_short) {
> -		list_for_each_entry(pos, head, node)
> +		list_for_each_entry(pos, &dsos->head, node)
>  			if (strcmp(pos->short_name, name) == 0)
>  				return pos;
>  		return NULL;
>  	}
> -	list_for_each_entry(pos, head, node)
> +	list_for_each_entry(pos, &dsos->head, node)
>  		if (strcmp(pos->long_name, name) == 0)
>  			return pos;
>  	return NULL;
>  }
>  
> -struct dso *__dsos__findnew(struct list_head *head, const char *name)
> +struct dso *__dsos__findnew(struct dsos *dsos, const char *name)
>  {
> -	struct dso *dso = dsos__find(head, name, false);
> +	struct dso *dso = dsos__find(dsos, name, false);
>  
>  	if (!dso) {
>  		dso = dso__new(name);
>  		if (dso != NULL) {
> -			dsos__add(head, dso);
> +			dsos__add(dsos, dso);
>  			dso__set_basename(dso);
>  		}
>  	}
> diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
> index 5e463c0..cadfef7 100644
> --- a/tools/perf/util/dso.h
> +++ b/tools/perf/util/dso.h
> @@ -90,8 +90,11 @@ struct dso_cache {
>  	char data[0];
>  };
>  
> +struct dsos;
> +
>  struct dso {
>  	struct list_head node;
> +	struct dsos      *dsos;
>  	struct rb_root	 symbols[MAP__NR_TYPES];
>  	struct rb_root	 symbol_names[MAP__NR_TYPES];
>  	void		 *a2l;
> @@ -224,10 +227,10 @@ struct map *dso__new_map(const char *name);
>  struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
>  				const char *short_name, int dso_type);
>  
> -void dsos__add(struct list_head *head, struct dso *dso);
> -struct dso *dsos__find(const struct list_head *head, const char *name,
> +void dsos__add(struct dsos *dsos, struct dso *dso);
> +struct dso *dsos__find(const struct dsos *dsos, const char *name,
>  		       bool cmp_short);
> -struct dso *__dsos__findnew(struct list_head *head, const char *name);
> +struct dso *__dsos__findnew(struct dsos *dsos, const char *name);
>  bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
>  
>  size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 158c787..ce0de00 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -214,11 +214,11 @@ static int machine__hit_all_dsos(struct machine *machine)
>  {
>  	int err;
>  
> -	err = __dsos__hit_all(&machine->kernel_dsos);
> +	err = __dsos__hit_all(&machine->kernel_dsos.head);
>  	if (err)
>  		return err;
>  
> -	return __dsos__hit_all(&machine->user_dsos);
> +	return __dsos__hit_all(&machine->user_dsos.head);
>  }
>  
>  int dsos__hit_all(struct perf_session *session)
> @@ -288,11 +288,12 @@ static int machine__write_buildid_table(struct machine *machine, int fd)
>  		umisc = PERF_RECORD_MISC_GUEST_USER;
>  	}
>  
> -	err = __dsos__write_buildid_table(&machine->kernel_dsos, machine,
> +	err = __dsos__write_buildid_table(&machine->kernel_dsos.head, machine,
>  					  machine->pid, kmisc, fd);
>  	if (err == 0)
> -		err = __dsos__write_buildid_table(&machine->user_dsos, machine,
> -						  machine->pid, umisc, fd);
> +		err = __dsos__write_buildid_table(&machine->user_dsos.head,
> +						  machine, machine->pid, umisc,
> +						  fd);
>  	return err;
>  }
>  
> @@ -455,9 +456,10 @@ static int __dsos__cache_build_ids(struct list_head *head,
>  
>  static int machine__cache_build_ids(struct machine *machine, const char *debugdir)
>  {
> -	int ret = __dsos__cache_build_ids(&machine->kernel_dsos, machine,
> +	int ret = __dsos__cache_build_ids(&machine->kernel_dsos.head, machine,
>  					  debugdir);
> -	ret |= __dsos__cache_build_ids(&machine->user_dsos, machine, debugdir);
> +	ret |= __dsos__cache_build_ids(&machine->user_dsos.head, machine,
> +				       debugdir);
>  	return ret;
>  }
>  
> @@ -483,8 +485,10 @@ static int perf_session__cache_build_ids(struct perf_session *session)
>  
>  static bool machine__read_build_ids(struct machine *machine, bool with_hits)
>  {
> -	bool ret = __dsos__read_build_ids(&machine->kernel_dsos, with_hits);
> -	ret |= __dsos__read_build_ids(&machine->user_dsos, with_hits);
> +	bool ret;
> +
> +	ret  = __dsos__read_build_ids(&machine->kernel_dsos.head, with_hits);
> +	ret |= __dsos__read_build_ids(&machine->user_dsos.head, with_hits);
>  	return ret;
>  }
>  
> @@ -1548,7 +1552,7 @@ static int __event_process_build_id(struct build_id_event *bev,
>  				    struct perf_session *session)
>  {
>  	int err = -1;
> -	struct list_head *head;
> +	struct dsos *dsos;
>  	struct machine *machine;
>  	u16 misc;
>  	struct dso *dso;
> @@ -1563,22 +1567,22 @@ static int __event_process_build_id(struct build_id_event *bev,
>  	switch (misc) {
>  	case PERF_RECORD_MISC_KERNEL:
>  		dso_type = DSO_TYPE_KERNEL;
> -		head = &machine->kernel_dsos;
> +		dsos = &machine->kernel_dsos;
>  		break;
>  	case PERF_RECORD_MISC_GUEST_KERNEL:
>  		dso_type = DSO_TYPE_GUEST_KERNEL;
> -		head = &machine->kernel_dsos;
> +		dsos = &machine->kernel_dsos;
>  		break;
>  	case PERF_RECORD_MISC_USER:
>  	case PERF_RECORD_MISC_GUEST_USER:
>  		dso_type = DSO_TYPE_USER;
> -		head = &machine->user_dsos;
> +		dsos = &machine->user_dsos;
>  		break;
>  	default:
>  		goto out;
>  	}
>  
> -	dso = __dsos__findnew(head, filename);
> +	dso = __dsos__findnew(dsos, filename);
>  	if (dso != NULL) {
>  		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
>  
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 16bba9f..214b6f7 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -17,8 +17,8 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
>  {
>  	map_groups__init(&machine->kmaps);
>  	RB_CLEAR_NODE(&machine->rb_node);
> -	INIT_LIST_HEAD(&machine->user_dsos);
> -	INIT_LIST_HEAD(&machine->kernel_dsos);
> +	INIT_LIST_HEAD(&machine->user_dsos.head);
> +	INIT_LIST_HEAD(&machine->kernel_dsos.head);
>  
>  	machine->threads = RB_ROOT;
>  	INIT_LIST_HEAD(&machine->dead_threads);
> @@ -70,11 +70,11 @@ out_delete:
>  	return NULL;
>  }
>  
> -static void dsos__delete(struct list_head *dsos)
> +static void dsos__delete(struct dsos *dsos)
>  {
>  	struct dso *pos, *n;
>  
> -	list_for_each_entry_safe(pos, n, dsos, node) {
> +	list_for_each_entry_safe(pos, n, &dsos->head, node) {
>  		list_del(&pos->node);
>  		dso__delete(pos);
>  	}
> @@ -448,23 +448,23 @@ struct map *machine__new_module(struct machine *machine, u64 start,
>  size_t machines__fprintf_dsos(struct machines *machines, FILE *fp)
>  {
>  	struct rb_node *nd;
> -	size_t ret = __dsos__fprintf(&machines->host.kernel_dsos, fp) +
> -		     __dsos__fprintf(&machines->host.user_dsos, fp);
> +	size_t ret = __dsos__fprintf(&machines->host.kernel_dsos.head, fp) +
> +		     __dsos__fprintf(&machines->host.user_dsos.head, fp);
>  
>  	for (nd = rb_first(&machines->guests); nd; nd = rb_next(nd)) {
>  		struct machine *pos = rb_entry(nd, struct machine, rb_node);
> -		ret += __dsos__fprintf(&pos->kernel_dsos, fp);
> -		ret += __dsos__fprintf(&pos->user_dsos, fp);
> +		ret += __dsos__fprintf(&pos->kernel_dsos.head, fp);
> +		ret += __dsos__fprintf(&pos->user_dsos.head, fp);
>  	}
>  
>  	return ret;
>  }
>  
> -size_t machine__fprintf_dsos_buildid(struct machine *machine, FILE *fp,
> +size_t machine__fprintf_dsos_buildid(struct machine *m, FILE *fp,
>  				     bool (skip)(struct dso *dso, int parm), int parm)
>  {
> -	return __dsos__fprintf_buildid(&machine->kernel_dsos, fp, skip, parm) +
> -	       __dsos__fprintf_buildid(&machine->user_dsos, fp, skip, parm);
> +	return __dsos__fprintf_buildid(&m->kernel_dsos.head, fp, skip, parm) +
> +	       __dsos__fprintf_buildid(&m->user_dsos.head, fp, skip, parm);
>  }
>  
>  size_t machines__fprintf_dsos_buildid(struct machines *machines, FILE *fp,
> @@ -965,7 +965,7 @@ static bool machine__uses_kcore(struct machine *machine)
>  {
>  	struct dso *dso;
>  
> -	list_for_each_entry(dso, &machine->kernel_dsos, node) {
> +	list_for_each_entry(dso, &machine->kernel_dsos.head, node) {
>  		if (dso__is_kcore(dso))
>  			return true;
>  	}
> diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
> index b972824..d8abb6c 100644
> --- a/tools/perf/util/machine.h
> +++ b/tools/perf/util/machine.h
> @@ -22,6 +22,13 @@ extern const char *ref_reloc_sym_names[];
>  
>  struct vdso_info;
>  
> +/*
> + * DSOs are put into a list for fast iteration.
> + */
> +struct dsos {
> +	struct list_head head;
> +};
> +
>  struct machine {
>  	struct rb_node	  rb_node;
>  	pid_t		  pid;
> @@ -31,8 +38,8 @@ struct machine {
>  	struct list_head  dead_threads;
>  	struct thread	  *last_match;
>  	struct vdso_info  *vdso_info;
> -	struct list_head  user_dsos;
> -	struct list_head  kernel_dsos;
> +	struct dsos	  user_dsos;
> +	struct dsos	  kernel_dsos;
>  	struct map_groups kmaps;
>  	struct map	  *vmlinux_maps[MAP__NR_TYPES];
>  	symbol_filter_t	  symbol_filter;
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 9a0a183..b153636 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -184,7 +184,8 @@ static struct dso *kernel_get_module_dso(const char *module)
>  	const char *vmlinux_name;
>  
>  	if (module) {
> -		list_for_each_entry(dso, &host_machine->kernel_dsos, node) {
> +		list_for_each_entry(dso, &host_machine->kernel_dsos.head,
> +				    node) {
>  			if (strncmp(dso->short_name + 1, module,
>  				    dso->short_name_len - 2) == 0)
>  				goto found;
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index d753499..cbecc3d 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -916,7 +916,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
>  				}
>  				curr_dso->symtab_type = dso->symtab_type;
>  				map_groups__insert(kmap->kmaps, curr_map);
> -				dsos__add(&dso->node, curr_dso);
> +				dsos__add(dso->dsos, curr_dso);
>  				dso__set_loaded(curr_dso, map->type);
>  			} else
>  				curr_dso = curr_map->dso;
> -- 
> 1.7.1
