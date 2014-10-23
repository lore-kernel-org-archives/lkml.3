Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaJWVnC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:43:02 -0400
Received: from mail.kernel.org ([198.145.19.201]:51986 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbaJWVm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:42:59 -0400
Date: Thu, 23 Oct 2014 18:42:49 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/16] perf tools: Add facility to export data in
 database-friendly way
Message-ID: <20141023214249.GP14687@kernel.org>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
 <1414061124-26830-6-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414061124-26830-6-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 23, 2014 at 01:45:13PM +0300, Adrian Hunter escreveu:
> This patch introduces an abstraction for exporting sample
> data in a database-friendly way.  The abstraction does not
> implement the actual output.  A subsequent patch takes this
> facility into use for extending the script interface.
> 
> The abstraction is needed because static data like symbols,
> dsos, comms etc need to be exported only once.  That means
> allocating them a unique identifier and recording it on each
> structure.  The member 'db_id' is used for that.  'db_id'
> is just a 64-bit sequence number.
> 
> Exporting centres around the db_export__sample() function
> which exports the associated data structures if they have
> not yet been allocated a db_id.

So this ends up bloating all data structures with 8 extra bytes, can't
we use the priv pointer that some of the structures already have for
tooling to put tool specific stuff?

In places like this:

> @@ -25,6 +25,7 @@ struct thread {
>  	bool			dead; /* if set thread has exited */
>  	struct list_head	comm_list;
>  	int			comm_len;
> +	u64			db_id;
>  
>  	void			*priv;
>  	struct thread_stack	*ts;

Instead we would have:

	union {
		void		*priv;
		u64		db_id;
	};

Using a unnamed union is all that is needed in struct thread case, I
think, the rest of your patch that deals with 'struct thread' doesn't
need to change and the end impact for other tools that have no use
whatsoever fot this thread->db_id is zero.

Because after all you will end up using some tool to just process
samples, etc, i.e. basically a 'perf report' like tool that instead of
creating hist_entries, etc will end up just populating the

machines ->
	machine ->
		threads ->
			map_groups ->
				map ->
					dso ->
						symbols

Hierarchy, right?

Struct symbol even has a mechanism for reserving space for private use,
that symbol_conf.priv_size + symbol__priv(), so that we don't incur even
in the cost of the priv pointer.

struct perf_evsel already has:

        union {
                void            *priv;
                off_t           id_offset;
        };

Just add db_id there and the rest of your patch that deals with
perf_evsel will not need to be changed and again the impact for tools
that do not use this will be zero.

The other data structures that still don't have a ->priv area can have
one added.

I.e. tool specific bloating of core data structures should be avoided.

Fixing up these things will allow a good chunk of this patchkit to be
processed.

Thanks,

- Arnaldo
 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/Makefile.perf    |   2 +
>  tools/perf/util/comm.h      |   1 +
>  tools/perf/util/db-export.c | 268 ++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/db-export.h |  86 ++++++++++++++
>  tools/perf/util/dso.h       |   1 +
>  tools/perf/util/evsel.h     |   1 +
>  tools/perf/util/machine.h   |   1 +
>  tools/perf/util/symbol.h    |   1 +
>  tools/perf/util/thread.h    |   1 +
>  9 files changed, 362 insertions(+)
>  create mode 100644 tools/perf/util/db-export.c
>  create mode 100644 tools/perf/util/db-export.h
> 
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 5bbe1ff..9134c93 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -305,6 +305,7 @@ LIB_H += ui/ui.h
>  LIB_H += util/data.h
>  LIB_H += util/kvm-stat.h
>  LIB_H += util/thread-stack.h
> +LIB_H += util/db-export.h
>  
>  LIB_OBJS += $(OUTPUT)util/abspath.o
>  LIB_OBJS += $(OUTPUT)util/alias.o
> @@ -382,6 +383,7 @@ LIB_OBJS += $(OUTPUT)util/data.o
>  LIB_OBJS += $(OUTPUT)util/tsc.o
>  LIB_OBJS += $(OUTPUT)util/cloexec.o
>  LIB_OBJS += $(OUTPUT)util/thread-stack.o
> +LIB_OBJS += $(OUTPUT)util/db-export.o
>  
>  LIB_OBJS += $(OUTPUT)ui/setup.o
>  LIB_OBJS += $(OUTPUT)ui/helpline.o
> diff --git a/tools/perf/util/comm.h b/tools/perf/util/comm.h
> index 51c10ab..99e7021 100644
> --- a/tools/perf/util/comm.h
> +++ b/tools/perf/util/comm.h
> @@ -10,6 +10,7 @@ struct comm_str;
>  struct comm {
>  	struct comm_str *comm_str;
>  	u64 start;
> +	u64 db_id;
>  	struct list_head list;
>  	bool exec;
>  };
> diff --git a/tools/perf/util/db-export.c b/tools/perf/util/db-export.c
> new file mode 100644
> index 0000000..53d0e75
> --- /dev/null
> +++ b/tools/perf/util/db-export.c
> @@ -0,0 +1,268 @@
> +/*
> + * db-export.c: Support for exporting data suitable for import to a database
> + * Copyright (c) 2014, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + */
> +
> +#include <errno.h>
> +
> +#include "evsel.h"
> +#include "machine.h"
> +#include "thread.h"
> +#include "comm.h"
> +#include "symbol.h"
> +#include "event.h"
> +#include "db-export.h"
> +
> +int db_export__init(struct db_export *dbe)
> +{
> +	memset(dbe, 0, sizeof(struct db_export));
> +	return 0;
> +}
> +
> +void db_export__exit(struct db_export *dbe __maybe_unused)
> +{
> +}
> +
> +int db_export__evsel(struct db_export *dbe, struct perf_evsel *evsel)
> +{
> +	if (evsel->db_id)
> +		return 0;
> +
> +	evsel->db_id = ++dbe->evsel_last_db_id;
> +
> +	if (dbe->export_evsel)
> +		return dbe->export_evsel(dbe, evsel);
> +
> +	return 0;
> +}
> +
> +int db_export__machine(struct db_export *dbe, struct machine *machine)
> +{
> +	if (machine->db_id)
> +		return 0;
> +
> +	machine->db_id = ++dbe->machine_last_db_id;
> +
> +	if (dbe->export_machine)
> +		return dbe->export_machine(dbe, machine);
> +
> +	return 0;
> +}
> +
> +int db_export__thread(struct db_export *dbe, struct thread *thread,
> +		      struct machine *machine, struct comm *comm)
> +{
> +	u64 main_thread_db_id = 0;
> +	int err;
> +
> +	if (thread->db_id)
> +		return 0;
> +
> +	thread->db_id = ++dbe->thread_last_db_id;
> +
> +	if (thread->pid_ != -1) {
> +		struct thread *main_thread;
> +
> +		if (thread->pid_ == thread->tid) {
> +			main_thread = thread;
> +		} else {
> +			main_thread = machine__findnew_thread(machine,
> +							      thread->pid_,
> +							      thread->pid_);
> +			if (!main_thread)
> +				return -ENOMEM;
> +			err = db_export__thread(dbe, main_thread, machine,
> +						comm);
> +			if (err)
> +				return err;
> +			if (comm) {
> +				err = db_export__comm_thread(dbe, comm, thread);
> +				if (err)
> +					return err;
> +			}
> +		}
> +		main_thread_db_id = main_thread->db_id;
> +	}
> +
> +	if (dbe->export_thread)
> +		return dbe->export_thread(dbe, thread, main_thread_db_id,
> +					  machine);
> +
> +	return 0;
> +}
> +
> +int db_export__comm(struct db_export *dbe, struct comm *comm,
> +		    struct thread *main_thread)
> +{
> +	int err;
> +
> +	if (comm->db_id)
> +		return 0;
> +
> +	comm->db_id = ++dbe->comm_last_db_id;
> +
> +	if (dbe->export_comm) {
> +		err = dbe->export_comm(dbe, comm);
> +		if (err)
> +			return err;
> +	}
> +
> +	return db_export__comm_thread(dbe, comm, main_thread);
> +}
> +
> +int db_export__comm_thread(struct db_export *dbe, struct comm *comm,
> +			   struct thread *thread)
> +{
> +	u64 db_id;
> +
> +	db_id = ++dbe->comm_thread_last_db_id;
> +
> +	if (dbe->export_comm_thread)
> +		return dbe->export_comm_thread(dbe, db_id, comm, thread);
> +
> +	return 0;
> +}
> +
> +int db_export__dso(struct db_export *dbe, struct dso *dso,
> +		   struct machine *machine)
> +{
> +	if (dso->db_id)
> +		return 0;
> +
> +	dso->db_id = ++dbe->dso_last_db_id;
> +
> +	if (dbe->export_dso)
> +		return dbe->export_dso(dbe, dso, machine);
> +
> +	return 0;
> +}
> +
> +int db_export__symbol(struct db_export *dbe, struct symbol *sym,
> +		      struct dso *dso)
> +{
> +	if (sym->db_id)
> +		return 0;
> +
> +	sym->db_id = ++dbe->symbol_last_db_id;
> +
> +	if (dbe->export_symbol)
> +		return dbe->export_symbol(dbe, sym, dso);
> +
> +	return 0;
> +}
> +
> +static struct thread *get_main_thread(struct machine *machine,
> +				      struct thread *thread)
> +{
> +	if (thread->pid_ == thread->tid)
> +		return thread;
> +
> +	if (thread->pid_ == -1)
> +		return NULL;
> +
> +	return machine__find_thread(machine, thread->pid_, thread->pid_);
> +}
> +
> +static int db_ids_from_al(struct db_export *dbe, struct addr_location *al,
> +			  u64 *dso_db_id, u64 *sym_db_id, u64 *offset)
> +{
> +	int err;
> +
> +	if (al->map) {
> +		struct dso *dso = al->map->dso;
> +
> +		err = db_export__dso(dbe, dso, al->machine);
> +		if (err)
> +			return err;
> +		*dso_db_id = dso->db_id;
> +
> +		if (!al->sym) {
> +			al->sym = symbol__new(al->addr, 0, 0, "unknown");
> +			if (al->sym)
> +				symbols__insert(&dso->symbols[al->map->type],
> +						al->sym);
> +		}
> +
> +		if (al->sym) {
> +			err = db_export__symbol(dbe, al->sym, dso);
> +			if (err)
> +				return err;
> +			*sym_db_id = al->sym->db_id;
> +			*offset = al->addr - al->sym->start;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int db_export__sample(struct db_export *dbe, union perf_event *event,
> +		      struct perf_sample *sample, struct perf_evsel *evsel,
> +		      struct thread *thread, struct addr_location *al)
> +{
> +	struct export_sample es = {
> +		.event = event,
> +		.sample = sample,
> +		.evsel = evsel,
> +		.thread = thread,
> +		.al = al,
> +	};
> +	struct thread *main_thread;
> +	struct comm *comm = NULL;
> +	int err;
> +
> +	err = db_export__evsel(dbe, evsel);
> +	if (err)
> +		return err;
> +
> +	err = db_export__machine(dbe, al->machine);
> +	if (err)
> +		return err;
> +
> +	main_thread = get_main_thread(al->machine, thread);
> +	if (main_thread)
> +		comm = machine__thread_exec_comm(al->machine, main_thread);
> +
> +	err = db_export__thread(dbe, thread, al->machine, comm);
> +	if (err)
> +		return err;
> +
> +	if (comm) {
> +		err = db_export__comm(dbe, comm, main_thread);
> +		if (err)
> +			return err;
> +		es.comm_db_id = comm->db_id;
> +	}
> +
> +	es.db_id = ++dbe->sample_last_db_id;
> +
> +	err = db_ids_from_al(dbe, al, &es.dso_db_id, &es.sym_db_id, &es.offset);
> +	if (err)
> +		return err;
> +
> +	if ((evsel->attr.sample_type & PERF_SAMPLE_ADDR) &&
> +	    sample_addr_correlates_sym(&evsel->attr)) {
> +		struct addr_location addr_al;
> +
> +		perf_event__preprocess_sample_addr(event, sample, al->machine,
> +						   thread, &addr_al);
> +		err = db_ids_from_al(dbe, &addr_al, &es.addr_dso_db_id,
> +				     &es.addr_sym_db_id, &es.addr_offset);
> +		if (err)
> +			return err;
> +	}
> +
> +	if (dbe->export_sample)
> +		return dbe->export_sample(dbe, &es);
> +
> +	return 0;
> +}
> diff --git a/tools/perf/util/db-export.h b/tools/perf/util/db-export.h
> new file mode 100644
> index 0000000..b3643e8
> --- /dev/null
> +++ b/tools/perf/util/db-export.h
> @@ -0,0 +1,86 @@
> +/*
> + * db-export.h: Support for exporting data suitable for import to a database
> + * Copyright (c) 2014, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + */
> +
> +#ifndef __PERF_DB_EXPORT_H
> +#define __PERF_DB_EXPORT_H
> +
> +#include <linux/types.h>
> +
> +struct perf_evsel;
> +struct machine;
> +struct thread;
> +struct comm;
> +struct dso;
> +struct perf_sample;
> +struct addr_location;
> +
> +struct export_sample {
> +	union perf_event	*event;
> +	struct perf_sample	*sample;
> +	struct perf_evsel	*evsel;
> +	struct thread		*thread;
> +	struct addr_location	*al;
> +	u64			db_id;
> +	u64			comm_db_id;
> +	u64			dso_db_id;
> +	u64			sym_db_id;
> +	u64			offset; /* ip offset from symbol start */
> +	u64			addr_dso_db_id;
> +	u64			addr_sym_db_id;
> +	u64			addr_offset; /* addr offset from symbol start */
> +};
> +
> +struct db_export {
> +	int (*export_evsel)(struct db_export *dbe, struct perf_evsel *evsel);
> +	int (*export_machine)(struct db_export *dbe, struct machine *machine);
> +	int (*export_thread)(struct db_export *dbe, struct thread *thread,
> +			     u64 main_thread_db_id, struct machine *machine);
> +	int (*export_comm)(struct db_export *dbe, struct comm *comm);
> +	int (*export_comm_thread)(struct db_export *dbe, u64 db_id,
> +				  struct comm *comm, struct thread *thread);
> +	int (*export_dso)(struct db_export *dbe, struct dso *dso,
> +			  struct machine *machine);
> +	int (*export_symbol)(struct db_export *dbe, struct symbol *sym,
> +			     struct dso *dso);
> +	int (*export_sample)(struct db_export *dbe, struct export_sample *es);
> +	u64 evsel_last_db_id;
> +	u64 machine_last_db_id;
> +	u64 thread_last_db_id;
> +	u64 comm_last_db_id;
> +	u64 comm_thread_last_db_id;
> +	u64 dso_last_db_id;
> +	u64 symbol_last_db_id;
> +	u64 sample_last_db_id;
> +};
> +
> +int db_export__init(struct db_export *dbe);
> +void db_export__exit(struct db_export *dbe);
> +int db_export__evsel(struct db_export *dbe, struct perf_evsel *evsel);
> +int db_export__machine(struct db_export *dbe, struct machine *machine);
> +int db_export__thread(struct db_export *dbe, struct thread *thread,
> +		      struct machine *machine, struct comm *comm);
> +int db_export__comm(struct db_export *dbe, struct comm *comm,
> +		    struct thread *main_thread);
> +int db_export__comm_thread(struct db_export *dbe, struct comm *comm,
> +			   struct thread *thread);
> +int db_export__dso(struct db_export *dbe, struct dso *dso,
> +		   struct machine *machine);
> +int db_export__symbol(struct db_export *dbe, struct symbol *sym,
> +		      struct dso *dso);
> +int db_export__sample(struct db_export *dbe, union perf_event *event,
> +		      struct perf_sample *sample, struct perf_evsel *evsel,
> +		      struct thread *thread, struct addr_location *al);
> +
> +#endif
> diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
> index acb651a..8463fc3 100644
> --- a/tools/perf/util/dso.h
> +++ b/tools/perf/util/dso.h
> @@ -111,6 +111,7 @@ struct dso {
>  	enum dso_swap_type	needs_swap;
>  	enum dso_binary_type	symtab_type;
>  	enum dso_binary_type	binary_type;
> +	u64		 db_id;
>  	u8		 adjust_symbols:1;
>  	u8		 has_build_id:1;
>  	u8		 has_srcline:1;
> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> index 4861e8c..4777262 100644
> --- a/tools/perf/util/evsel.h
> +++ b/tools/perf/util/evsel.h
> @@ -95,6 +95,7 @@ struct perf_evsel {
>  	int			sample_read;
>  	struct perf_evsel	*leader;
>  	char			*group_name;
> +	u64			db_id;
>  };
>  
>  union u64_swap {
> diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
> index 2b651a7..4bc57e5 100644
> --- a/tools/perf/util/machine.h
> +++ b/tools/perf/util/machine.h
> @@ -40,6 +40,7 @@ struct machine {
>  	u64		  kernel_start;
>  	symbol_filter_t	  symbol_filter;
>  	pid_t		  *current_tid;
> +	u64		  db_id;
>  };
>  
>  static inline
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index eb2c19b..6f54ade 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -73,6 +73,7 @@ struct symbol {
>  	struct rb_node	rb_node;
>  	u64		start;
>  	u64		end;
> +	u64		db_id;
>  	u16		namelen;
>  	u8		binding;
>  	bool		ignore;
> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
> index a057820..a3ebb21 100644
> --- a/tools/perf/util/thread.h
> +++ b/tools/perf/util/thread.h
> @@ -25,6 +25,7 @@ struct thread {
>  	bool			dead; /* if set thread has exited */
>  	struct list_head	comm_list;
>  	int			comm_len;
> +	u64			db_id;
>  
>  	void			*priv;
>  	struct thread_stack	*ts;
> -- 
> 1.9.1
