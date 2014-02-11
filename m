Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaBKOhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:37:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbaBKOhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:37:23 -0500
Date: Tue, 11 Feb 2014 09:36:43 -0500
From: Don Zickus <dzickus@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Davidlohr Bueso <davidlohr@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 01/21] perf c2c: Shared data analyser
Message-ID: <20140211143643.GX25953@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <1392059886-30812-1-git-send-email-dzickus@redhat.com>
 <1392070204.25316.1.camel@buesod1.americas.hpqcorp.net>
 <20140211113127.GA28757@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211113127.GA28757@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 08:31:27AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Feb 10, 2014 at 02:10:04PM -0800, Davidlohr Bueso escreveu:
> > On Mon, 2014-02-10 at 14:18 -0500, Don Zickus wrote:
> > > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > 
> > > This is the start of a new perf tool that will collect information about
> > > memory accesses and analyse it to find things like hot cachelines, etc.
> > > 
> > > This is basically trying to get a prototype written by Richard Fowles
> > > written using the tools/perf coding style and libraries.
> > > 
> > > Start it from 'perf sched', this patch starts the process by adding the
> > > 'record' subcommand to collect the needed mem loads and stores samples.
> > > 
> > > It also have the basic 'report' skeleton, resolving the sample address
> > > and hooking the events found in a perf.data file with methods to handle
> > > them, right now just printing the resolved perf_sample data structure
> > > after each event name.
> > 
> > What tree/branch is this developed against? I'm getting the following
> > with Linus' latest and tip tree:
> 
> I'll try refreshing it on top of my perf/core branch today

Sorry for the trouble.  I guess I missed all the function cleanups from
last month.  Attached is a patch that gets things to compile.

I'll split this patch up to the right spots on my next refresh.

Cheers,
Don

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index a73535a..b55f281 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -1009,15 +1009,20 @@ static int perf_c2c__process_sample(struct perf_tool *tool,
 	struct c2c_entry *entry;
 	sample_handler f;
 	int err = -1;
+	struct addr_location al = {
+			.machine = machine,
+			.cpumode = cpumode,
+	};
 
-	if (evsel->handler.func == NULL)
+	if (evsel->handler == NULL)
 		return 0;
 
 	thread = machine__find_thread(machine, sample->pid);
 	if (thread == NULL)
 		goto err;
 
-	mi = machine__resolve_mem(machine, thread, sample, cpumode);
+	al.thread = thread;
+	mi = sample__resolve_mem(sample, &al);
 	if (mi == NULL)
 		goto err;
 
@@ -1031,7 +1036,7 @@ static int perf_c2c__process_sample(struct perf_tool *tool,
 	if (entry == NULL)
 		goto err_mem;
 
-	f = evsel->handler.func;
+	f = evsel->handler;
 	err = f(c2c, sample, entry);
 	if (err)
 		goto err_entry;
@@ -1040,8 +1045,8 @@ static int perf_c2c__process_sample(struct perf_tool *tool,
 	if (symbol_conf.use_callchain && sample->callchain) {
 		callchain_init(entry->callchain);
 
-		err = machine__resolve_callchain(machine, evsel, thread,
-						 sample, &parent, NULL);
+		err = sample__resolve_callchain(sample, &parent, evsel, &al,
+						PERF_MAX_STACK_DEPTH);
 		if (!err)
 			err = callchain_append(entry->callchain,
 					       &callchain_cursor,
@@ -1198,7 +1203,7 @@ struct refs {
 	struct list_head	list;
 	int			nr;
 	const char		*name;
-	char			*long_name;
+	const char		*long_name;
 };
 
 static int update_ref_tree(struct c2c_entry *entry)
@@ -2732,8 +2737,12 @@ static int perf_c2c__read_events(struct perf_c2c *c2c)
 {
 	int err = -1;
 	struct perf_session *session;
+	struct perf_data_file file = {
+			.path = input_name,
+			.mode = PERF_DATA_MODE_READ,
+	};
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false, &c2c->tool);
+	session = perf_session__new(&file, 0, &c2c->tool);
 	if (session == NULL) {
 		pr_debug("No memory for session\n");
 		goto out;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index faf29b0..49e0328 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1270,10 +1270,10 @@ int __perf_evlist__set_handlers(struct perf_evlist *evlist,
 		if (evsel == NULL)
 			continue;
 
-		if (evsel->handler.func != NULL)
+		if (evsel->handler != NULL)
 			goto out;
 
-		evsel->handler.func = assocs[i].handler;
+		evsel->handler = assocs[i].handler;
 	}
 
 	err = 0;
