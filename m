Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbaJXOl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:41:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:38692 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214AbaJXOlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:41:21 -0400
Date: Fri, 24 Oct 2014 11:41:16 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/16] perf tools: Add facility to export data in
 database-friendly way
Message-ID: <20141024144116.GD14687@kernel.org>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
 <1414061124-26830-6-git-send-email-adrian.hunter@intel.com>
 <87lho6c8ec.fsf@sejong.aot.lge.com>
 <544A099C.50104@intel.com>
 <544A2E5F.80508@intel.com>
 <CAM9d7ci6bv_JnK8DkqqTEttPkEp1mtMPN07XjqX=K4ADOUC6SA@mail.gmail.com>
 <544A505C.5030203@intel.com>
 <20141024144002.GC14687@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024144002.GC14687@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 24, 2014 at 11:40:02AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Oct 24, 2014 at 04:13:00PM +0300, Adrian Hunter escreveu:
> > On 24/10/14 15:26, Namhyung Kim wrote:
> > > Hi Adrian,
> > > 
> > > On Fri, Oct 24, 2014 at 7:47 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> > >> On 24/10/14 11:11, Adrian Hunter wrote:
> > >>> On 24/10/14 09:02, Namhyung Kim wrote:
> > >>>> Can we do it somewhere in a script not in the core code?  I don't feel
> > >>>> comfortable to add those bits into the core code.  What if we export
> > >>>
> > >>> Please explain what you mean by "comfortable".
> > >>
> > >> Or rather: What about it is wrong for core code?
> > > 
> > > Well, there's nothing "wrong" about it. :)
> > > 
> > > But I think if some code is used only by a specific bits, it'd be
> > > better hiding it from the rest as much as possible.
> > 
> > It is pretty self-contained in db-export.[ch] and the scripting
> > engines.
> 
> So, what I meant was the patch below, on top of yours.
> 
> In some data structures where there were no provision for tool specific
> storage, I added an unnamed union with db_id and a void *priv pointer,
> where there were, be it a priv pointer, like in perf_evsel, I moved
> db_id to it, no extra costs for the other tools.
> 
> And in struct symbol, I made it use symbol__priv(), that will access the
> area reserved by setting symbol.priv_size at tool start time, like done
> for the annotation case in top, report, annotate. I.e. on the tool that
> will use symbol->db_id you will need to add this just before calling
> symbol__init():
> 
> 	symbol_conf.priv_size = sizeof(u64);
> 
> Since this is all specific to your tool, there should be no problems and
> I'm now applying this change merged with your original patch + note
> about that and then moving on to the other patches that make use of it.

Oops, now with the patch:

diff --git a/tools/perf/util/comm.h b/tools/perf/util/comm.h
index 99e7021..71c9c39 100644
--- a/tools/perf/util/comm.h
+++ b/tools/perf/util/comm.h
@@ -10,9 +10,12 @@ struct comm_str;
 struct comm {
 	struct comm_str *comm_str;
 	u64 start;
-	u64 db_id;
 	struct list_head list;
 	bool exec;
+	union { /* Tool specific area */
+		void	*priv;
+		u64	db_id;
+	};
 };
 
 void comm__free(struct comm *comm);
diff --git a/tools/perf/util/db-export.c b/tools/perf/util/db-export.c
index 53d0e75..be128b0 100644
--- a/tools/perf/util/db-export.c
+++ b/tools/perf/util/db-export.c
@@ -150,10 +150,12 @@ int db_export__dso(struct db_export *dbe, struct dso *dso,
 int db_export__symbol(struct db_export *dbe, struct symbol *sym,
 		      struct dso *dso)
 {
-	if (sym->db_id)
+	u64 *sym_db_id = symbol__priv(sym);
+
+	if (*sym_db_id)
 		return 0;
 
-	sym->db_id = ++dbe->symbol_last_db_id;
+	*sym_db_id = ++dbe->symbol_last_db_id;
 
 	if (dbe->export_symbol)
 		return dbe->export_symbol(dbe, sym, dso);
@@ -161,8 +163,7 @@ int db_export__symbol(struct db_export *dbe, struct symbol *sym,
 	return 0;
 }
 
-static struct thread *get_main_thread(struct machine *machine,
-				      struct thread *thread)
+static struct thread *get_main_thread(struct machine *machine, struct thread *thread)
 {
 	if (thread->pid_ == thread->tid)
 		return thread;
@@ -194,10 +195,12 @@ static int db_ids_from_al(struct db_export *dbe, struct addr_location *al,
 		}
 
 		if (al->sym) {
+			u64 *db_id = symbol__priv(al->sym);
+
 			err = db_export__symbol(dbe, al->sym, dso);
 			if (err)
 				return err;
-			*sym_db_id = al->sym->db_id;
+			*sym_db_id = *db_id;
 			*offset = al->addr - al->sym->start;
 		}
 	}
@@ -253,8 +256,7 @@ int db_export__sample(struct db_export *dbe, union perf_event *event,
 	    sample_addr_correlates_sym(&evsel->attr)) {
 		struct addr_location addr_al;
 
-		perf_event__preprocess_sample_addr(event, sample, al->machine,
-						   thread, &addr_al);
+		perf_event__preprocess_sample_addr(event, sample, thread, &addr_al);
 		err = db_ids_from_al(dbe, &addr_al, &es.addr_dso_db_id,
 				     &es.addr_sym_db_id, &es.addr_offset);
 		if (err)
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 66c99cc..a316e4a 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -111,7 +111,6 @@ struct dso {
 	enum dso_swap_type	needs_swap;
 	enum dso_binary_type	symtab_type;
 	enum dso_binary_type	binary_type;
-	u64		 db_id;
 	u8		 adjust_symbols:1;
 	u8		 has_build_id:1;
 	u8		 has_srcline:1;
@@ -140,6 +139,11 @@ struct dso {
 		struct list_head open_entry;
 	} data;
 
+	union { /* Tool specific area */
+		void	 *priv;
+		u64	 db_id;
+	};
+
 	char		 name[0];
 };
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 9459899..d3854c4 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -54,6 +54,7 @@ struct cgroup_sel;
  * @is_pos: the position (counting backwards) of the event id (PERF_SAMPLE_ID or
  *          PERF_SAMPLE_IDENTIFIER) in a non-sample event i.e. if sample_id_all
  *          is used there is an id sample appended to non-sample events
+ * @priv:   And what is in its containing unnamed union are tool specific
  */
 struct perf_evsel {
 	struct list_head	node;
@@ -73,6 +74,7 @@ struct perf_evsel {
 	union {
 		void		*priv;
 		off_t		id_offset;
+		u64		db_id;
 	};
 	struct cgroup_sel	*cgrp;
 	void			*handler;
@@ -92,7 +94,6 @@ struct perf_evsel {
 	int			sample_read;
 	struct perf_evsel	*leader;
 	char			*group_name;
-	u64			db_id;
 };
 
 union u64_swap {
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 2e150a2..e8b7779 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -40,7 +40,10 @@ struct machine {
 	u64		  kernel_start;
 	symbol_filter_t	  symbol_filter;
 	pid_t		  *current_tid;
-	u64		  db_id;
+	union { /* Tool specific area */
+		void	  *priv;
+		u64	  db_id;
+	};
 };
 
 static inline
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 6f54ade..eb2c19b 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -73,7 +73,6 @@ struct symbol {
 	struct rb_node	rb_node;
 	u64		start;
 	u64		end;
-	u64		db_id;
 	u16		namelen;
 	u8		binding;
 	bool		ignore;
