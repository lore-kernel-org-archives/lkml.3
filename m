Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaJAHSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:18:34 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:51976 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaJAHSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:18:30 -0400
Subject: [PATCH v1 5/5] perf/sdt: Add support to perf record to trace SDT
 events
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Tue, 30 Sep 2014 21:04:27 +0530
Message-ID: <20140930153400.6698.30853.stgit@hemant-fedora>
In-Reply-To: <20140930152055.6698.82709.stgit@hemant-fedora>
References: <20140930152055.6698.82709.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100107-0017-0000-0000-00000046E618
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SDT events are already stored in a cache file
(/var/cache/perf/perf-sdt-file.cache).
Although the file_hash table helps in addition or deletion of SDT events from the
cache, its not of much use when it comes to probing the actual SDT event, because the
key to this hash list is a file name and not the SDT event name (which is given as
an argument to perf record). So, we won't be able to hash into it.

To avoid this problem, we can create another hash list
"event_hash" list which will be maintained along with the file_hash list.
Whenever a user invokes 'perf record -e %provider:event, perf should initialize
the event_hash list and the file_hash list.
The key to event_hash list is calculated from the event name and its
provider name.

            event_hash       sdt_note
            |---------|   ----------------
            |         |   |   file_ptr   |==> to file_sdt_ent containing this note
key = 129 =>| list  ==|===|=> event_list=|==> to other sdt notes hashed to same entry
	    |         |   |   name       |
            |---------|   |   provider   |
            |	      |   |   note_list==|==> to other notes in the same file
key = 130 =>| list    |   ---------------
            |---------|

The entry at that key in event_hash contains a list of SDT notes hashed to the
same entry. It compares the name and provider to see if that is the SDT note we
are looking for. If yes, find out the file that contains this SDT note. There is
a file_ptr pointer embedded in this note which points to the struct file_sdt_ent
contained in the file_hash. From "file_sdt_ent" we will find out the file name.
Convert this sdt note into a perf event and then write this into uprobe_events
file to be able to record the event.
Then, corresponding entries are added to uprobe_events file for
the SDT events.
After recording is done, these events are silently deleted from uprobe_events
file. The uprobe_events file is present in debugfs/tracing directory.

To support the addition and deletion of SDT events to/from uprobe_events
file, a record_sdt struct is maintained which has the event data.

An example usage:

# ./perf record -e %user_app:fun_start -aR /home/user_app

In main
This is foo
This is fun
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.265 MB perf.data (~11581 samples) ]

# ./perf report --stdio
...
# To display the perf.data header info, please use --header/--header-only options.
#
# Samples: 1  of event 'user_app:fun_start'
# Event count (approx.): 1
#
# Overhead   Command  Shared Object   Symbol
# ........  ........  .............  .......
#
   100.00%  user_app  user_app       [.] fun


Multiple events can also be recorded simultaneously.

Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
---
 tools/perf/builtin-record.c    |   21 ++++
 tools/perf/util/parse-events.c |    7 +
 tools/perf/util/parse-events.h |    3 +
 tools/perf/util/probe-event.c  |  120 ++++++++++++++++++++-----
 tools/perf/util/probe-event.h  |    7 +
 tools/perf/util/probe-finder.c |    3 +
 tools/perf/util/sdt.c          |  194 ++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/symbol.h       |    2 
 8 files changed, 327 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 378b85b..f573a4b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -45,6 +45,25 @@ struct record {
 	long			samples;
 };
 
+/* Session specific to SDT tracing */
+struct record_sdt {
+	bool	sdt;	/* is this SDT event tracing? */
+	char	*str;	/* hold the event name */
+} rec_sdt;
+
+int trace_sdt_event(const char *str)
+{
+	int ret = 0;
+
+	rec_sdt.sdt = true;
+	rec_sdt.str = strdup(str);
+	if (!rec_sdt.str)
+		return -ENOMEM;
+	ret = event_hash_list__lookup(str);
+
+	return ret;
+}
+
 static int record__write(struct record *rec, void *bf, size_t size)
 {
 	if (perf_data_file__write(rec->session->file, bf, size) < 0) {
@@ -953,6 +972,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 	err = __cmd_record(&record, argc, argv);
+	if (rec_sdt.sdt)
+		err = remove_perf_sdt_events(rec_sdt.str);
 out_symbol_exit:
 	perf_evlist__delete(rec->evlist);
 	symbol__exit();
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1e15df1..b2db9e3 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -890,6 +890,13 @@ static int parse_events__scanner(const char *str, void *data, int start_token)
 
 	buffer = parse_events__scan_string(str, scanner);
 
+	/* '%' means it can be an SDT event */
+	if (*str == '%')
+		if (strchr(str, ':')) {
+			ret = event_hash_list__lookup(str);
+			str++;
+		}
+
 #ifdef PARSER_DEBUG
 	parse_events_debug = 1;
 #endif
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 2297af7..52a163a 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -112,5 +112,8 @@ extern int valid_debugfs_mount(const char *debugfs);
 int add_sdt_events(const char *file);
 int dump_sdt_events(void);
 int remove_sdt_events(const char *str);
+int event_hash_list__lookup(const char *str);
+int remove_perf_sdt_events(const char *str);
+int trace_sdt_event(const char *str);
 
 #endif /* __PERF_PARSE_EVENTS_H */
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 9a0a183..114c5de 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -353,7 +353,8 @@ error:
 }
 
 static int add_exec_to_probe_trace_events(struct probe_trace_event *tevs,
-					  int ntevs, const char *exec)
+					  int ntevs, const char *exec,
+					  struct perf_probe_event *pev)
 {
 	int i, ret = 0;
 	unsigned long stext = 0;
@@ -367,7 +368,10 @@ static int add_exec_to_probe_trace_events(struct probe_trace_event *tevs,
 
 	for (i = 0; i < ntevs && ret >= 0; i++) {
 		/* point.address is the addres of point.symbol + point.offset */
-		tevs[i].point.address -= stext;
+		if (pev->sdt)
+			tevs[i].point.address = pev->point.offset;
+		else
+			tevs[i].point.address -= stext;
 		tevs[i].point.module = strdup(exec);
 		if (!tevs[i].point.module) {
 			ret = -ENOMEM;
@@ -415,14 +419,14 @@ static int add_module_to_probe_trace_events(struct probe_trace_event *tevs,
 /* Post processing the probe events */
 static int post_process_probe_trace_events(struct probe_trace_event *tevs,
 					   int ntevs, const char *module,
-					   bool uprobe)
+					   struct perf_probe_event *pev)
 {
 	struct ref_reloc_sym *reloc_sym;
 	char *tmp;
 	int i;
 
-	if (uprobe)
-		return add_exec_to_probe_trace_events(tevs, ntevs, module);
+	if (pev->uprobes)
+		return add_exec_to_probe_trace_events(tevs, ntevs, module, pev);
 
 	/* Note that currently ref_reloc_sym based probe is not for drivers */
 	if (module)
@@ -477,7 +481,7 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 	if (ntevs > 0) {	/* Succeeded to find trace events */
 		pr_debug("Found %d probe_trace_events.\n", ntevs);
 		ret = post_process_probe_trace_events(*tevs, ntevs,
-							target, pev->uprobes);
+							target, pev);
 		if (ret < 0) {
 			clear_probe_trace_events(*tevs, ntevs);
 			zfree(tevs);
@@ -1108,6 +1112,43 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 	return 0;
 }
 
+/* Parse an SDT event */
+static int parse_perf_sdt_event(struct perf_sdt_event *sev,
+				struct perf_probe_event *pev)
+{
+	struct perf_probe_point *pp = &pev->point;
+
+	pev->uprobes = true;
+	pev->sdt = true;
+	pev->event = strdup(sev->note->name);
+	if (pev->event == NULL)
+		return -ENOMEM;
+	pev->group = strdup(sev->note->provider);
+	if (pev->event == NULL)
+		return -ENOMEM;
+
+	pp->file = strdup(sev->file_name);
+	if (pp->file == NULL)
+		return -ENOMEM;
+
+	pp->function = strdup(sev->note->name);
+	pp->offset = sev->note->addr.a64[0];
+	return 0;
+}
+
+int add_perf_sdt_event(struct perf_sdt_event *sev)
+{
+	struct perf_probe_event pev;
+	int ret;
+
+	ret = parse_perf_sdt_event(sev, &pev);
+	if (!ret)
+		add_perf_probe_events(&pev, 1, MAX_PROBES,
+				      sev->file_name, true);
+
+	return ret;
+}
+
 /* Parse perf-probe event argument */
 static int parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 {
@@ -1884,9 +1925,12 @@ static int show_perf_probe_event(struct perf_probe_event *pev,
 	if (ret < 0)
 		return ret;
 
-	printf("  %-20s (on %s", buf, place);
-	if (module)
-		printf(" in %s", module);
+	/* Do not display anything for SDTs */
+	if (!pev->sdt) {
+		printf("  %-20s (on %s", buf, place);
+		if (module)
+			printf(" in %s", module);
+	}
 
 	if (pev->nargs > 0) {
 		printf(" with");
@@ -1898,7 +1942,9 @@ static int show_perf_probe_event(struct perf_probe_event *pev,
 			printf(" %s", buf);
 		}
 	}
-	printf(")\n");
+	/* Not for SDT events */
+	if (!pev->sdt)
+		printf(")\n");
 	free(place);
 	return ret;
 }
@@ -2085,7 +2131,9 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 	}
 
 	ret = 0;
-	printf("Added new event%s\n", (ntevs > 1) ? "s:" : ":");
+	/* If SDT event, do not print anything */
+	if (!pev->sdt)
+		printf("Added new event%s\n", (ntevs > 1) ? "s:" : ":");
 	for (i = 0; i < ntevs; i++) {
 		tev = &tevs[i];
 		if (pev->event)
@@ -2124,6 +2172,12 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 		group = pev->group;
 		pev->event = tev->event;
 		pev->group = tev->group;
+
+		/* Arguments currently not supported with SDT events */
+		if (pev->sdt) {
+			pev->nargs = 0;
+			tev->nargs = 0;
+		}
 		show_perf_probe_event(pev, tev->point.module);
 		/* Trick here - restore current event/group */
 		pev->event = (char *)event;
@@ -2138,8 +2192,8 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 		allow_suffix = true;
 	}
 
-	if (ret >= 0) {
-		/* Show how to use the event. */
+	if (ret >= 0 && !pev->sdt) {
+		/* Show how to use the event except for SDT events */
 		printf("\nYou can now use it in all perf tools, such as:\n\n");
 		printf("\tperf record -e %s:%s -aR sleep 1\n\n", tev->group,
 			 tev->event);
@@ -2332,6 +2386,7 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 {
 	int i, j, ret;
 	struct __event_package *pkgs;
+	bool sdt = pevs->sdt;
 
 	ret = 0;
 	pkgs = zalloc(sizeof(struct __event_package) * npevs);
@@ -2373,12 +2428,13 @@ end:
 		zfree(&pkgs[i].tevs);
 	}
 	free(pkgs);
-	exit_symbol_maps();
+	if (!sdt)     /* We didn't initialize symbol maps for SDT events */
+		exit_symbol_maps();
 
 	return ret;
 }
 
-static int __del_trace_probe_event(int fd, struct str_node *ent)
+static int __del_trace_probe_event(int fd, struct str_node *ent, bool sdt)
 {
 	char *p;
 	char buf[128];
@@ -2405,7 +2461,8 @@ static int __del_trace_probe_event(int fd, struct str_node *ent)
 		goto error;
 	}
 
-	printf("Removed event: %s\n", ent->s);
+	if (!sdt)
+		printf("Removed event: %s\n", ent->s);
 	return 0;
 error:
 	pr_warning("Failed to delete event: %s\n", strerror(-ret));
@@ -2413,7 +2470,8 @@ error:
 }
 
 static int del_trace_probe_event(int fd, const char *buf,
-						  struct strlist *namelist)
+				 struct strlist *namelist,
+				 bool sdt)
 {
 	struct str_node *ent, *n;
 	int ret = -1;
@@ -2421,7 +2479,7 @@ static int del_trace_probe_event(int fd, const char *buf,
 	if (strpbrk(buf, "*?")) { /* Glob-exp */
 		strlist__for_each_safe(ent, n, namelist)
 			if (strglobmatch(ent->s, buf)) {
-				ret = __del_trace_probe_event(fd, ent);
+				ret = __del_trace_probe_event(fd, ent, sdt);
 				if (ret < 0)
 					break;
 				strlist__remove(namelist, ent);
@@ -2429,7 +2487,7 @@ static int del_trace_probe_event(int fd, const char *buf,
 	} else {
 		ent = strlist__find(namelist, buf);
 		if (ent) {
-			ret = __del_trace_probe_event(fd, ent);
+			ret = __del_trace_probe_event(fd, ent, sdt);
 			if (ret >= 0)
 				strlist__remove(namelist, ent);
 		}
@@ -2438,7 +2496,7 @@ static int del_trace_probe_event(int fd, const char *buf,
 	return ret;
 }
 
-int del_perf_probe_events(struct strlist *dellist)
+static int __del_perf_probe_events(struct strlist *dellist, bool sdt)
 {
 	int ret = -1, ufd = -1, kfd = -1;
 	char buf[128];
@@ -2488,10 +2546,10 @@ int del_perf_probe_events(struct strlist *dellist)
 		pr_debug("Group: %s, Event: %s\n", group, event);
 
 		if (namelist)
-			ret = del_trace_probe_event(kfd, buf, namelist);
+			ret = del_trace_probe_event(kfd, buf, namelist, sdt);
 
 		if (unamelist && ret != 0)
-			ret = del_trace_probe_event(ufd, buf, unamelist);
+			ret = del_trace_probe_event(ufd, buf, unamelist, sdt);
 
 		if (ret != 0)
 			pr_info("Info: Event \"%s\" does not exist.\n", buf);
@@ -2513,6 +2571,24 @@ error:
 	return ret;
 }
 
+int del_perf_probe_events(struct strlist *dellist)
+{
+	return __del_perf_probe_events(dellist, false);
+}
+
+int remove_perf_sdt_events(const char *str)
+{
+	struct strlist *dellist;
+	int ret = 0;
+
+	dellist = strlist__new(true, NULL);
+	strlist__add(dellist, str + 1);
+	if (dellist)
+		ret = __del_perf_probe_events(dellist, true);
+
+	return ret;
+}
+
 /* TODO: don't use a global variable for filter ... */
 static struct strfilter *available_func_filter;
 
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 5ba93c6..67d0809 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -75,9 +75,15 @@ struct perf_probe_event {
 	struct perf_probe_point	point;	/* Probe point */
 	int			nargs;	/* Number of arguments */
 	bool			uprobes;
+	bool			sdt;	/* An SDT event? */
 	struct perf_probe_arg	*args;	/* Arguments */
 };
 
+struct perf_sdt_event {
+	struct sdt_note		*note;		/* SDT note info */
+	char			*file_name;	/* File name */
+};
+
 /* Line range */
 struct line_range {
 	char			*file;		/* File name */
@@ -135,6 +141,7 @@ extern int show_available_vars(struct perf_probe_event *pevs, int npevs,
 			       struct strfilter *filter, bool externs);
 extern int show_available_funcs(const char *module, struct strfilter *filter,
 				bool user);
+extern int add_perf_sdt_event(struct perf_sdt_event *sev);
 
 /* Maximum index number of event-name postfix */
 #define MAX_EVENT_INDEX	1024
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 98e3047..9920653 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1191,6 +1191,9 @@ int debuginfo__find_trace_events(struct debuginfo *dbg,
 	tf.tevs = *tevs;
 	tf.ntevs = 0;
 
+	/* Number of trace events for SDT event is 1 */
+	if (pev->sdt)
+		return 1;
 	ret = debuginfo__find_probes(dbg, &tf.pf);
 	if (ret < 0) {
 		zfree(tevs);
diff --git a/tools/perf/util/sdt.c b/tools/perf/util/sdt.c
index 88c53b5..983c7a9 100644
--- a/tools/perf/util/sdt.c
+++ b/tools/perf/util/sdt.c
@@ -328,6 +328,50 @@ static void sdt_note__read(char **ptr, struct list_head *sdt_list, char *end)
 }
 
 /**
+ * event_hash_list__add : add SDT events to event hash table
+ * @fse: obtained from the file_hash
+ * @event_hash: event hash list
+ *
+ * Iterate through the SDT notes list one by one and add them
+ * to event hash table.
+ */
+static int event_hash_list__add(struct file_sdt_ent *fse,
+				 struct hash_list *event_hash)
+{
+	struct list_head *ent_head;
+	struct sdt_note *sn;
+	int event_key, nr_add = 0, len;
+	char *str;
+
+	/* Iterate through the sdt notes and add them to the event hash */
+	list_for_each_entry(sn, &fse->sdt_list, note_list) {
+		/*
+		 * Assign the file_ptr so that we can always find its containing
+		 * file
+		 */
+		sn->file_ptr = fse;
+
+		len = strlen(sn->provider) + strlen(sn->name);
+		str = (char *)malloc(len + 1);
+		if (!str)
+			return -ENOMEM;
+
+		memset(str, '\0', len + 1);
+		/* Concatenate SDT name and provider and find out the key */
+		strcat(str, sn->provider);
+		strcat(str, sn->name);
+		event_key = get_hash_key(str);
+		free(str);
+		/* List adding */
+		ent_head = &event_hash->ent[event_key].list;
+		list_add(&sn->event_list, ent_head);
+		nr_add++;
+	}
+
+	return nr_add;
+}
+
+/**
  * file_hash_list__populate: Fill up the file hash table
  * @file_hash: empty file hash table
  * @data: raw cache data
@@ -339,14 +383,15 @@ static void sdt_note__read(char **ptr, struct list_head *sdt_list, char *end)
  * read the SDT notes. Multiple entries for the same key are delimited
  * by "::". Then, it assigns the file name, build id and SDT notes to the
  * list entry corresponding to 'key'.
+ * Checks if we need to add to the event_hash list.
  */
 static void file_hash_list__populate(struct hash_list *file_hash, char *data,
-				     off_t size)
+				     off_t size, struct hash_list *event_hash)
 {
 	struct list_head *ent_head;
 	struct file_sdt_ent *fse;
 	char *end, tmp[PATH_MAX], *ptr;
-	int key, len = 0;
+	int key, len = 0, ret;
 
 	end = data + size - 1;
 	ptr = data;
@@ -378,6 +423,12 @@ static void file_hash_list__populate(struct hash_list *file_hash, char *data,
 
 			list_add(&fse->file_list, ent_head);
 
+			/* See if we need to add to the event_hash */
+			if (event_hash) {
+				ret = event_hash_list__add(fse, event_hash);
+				if (ret < 0)
+					break;
+			}
 			/* Check for another file entry */
 			if ((*ptr++ == DELIM) && (*ptr == '-'))
 				break;
@@ -396,8 +447,10 @@ static void file_hash_list__populate(struct hash_list *file_hash, char *data,
  *
  * Opens the cache file, reads the data into 'data' and calls
  * file_hash_list__populate() to populate the above hash list.
+ * Updates the event_hash if needed.
  */
-static void file_hash_list__init(struct hash_list *file_hash)
+static void file_hash_list__init(struct hash_list *file_hash,
+				 struct hash_list *event_hash)
 {
 	struct stat sb;
 	char *data;
@@ -440,14 +493,26 @@ static void file_hash_list__init(struct hash_list *file_hash)
 		return;
 	}
 
-	/* Populate the hash list */
-	file_hash_list__populate(file_hash, data, sb.st_size);
+	/* Populate the hash list(s) */
+	file_hash_list__populate(file_hash, data, sb.st_size, event_hash);
 	ret = munmap(data, sb.st_size);
 	if (ret == -1)
 		pr_err("Error in munmap\n");
 }
 
 /**
+ * event_hash_list__init: Initialize the event_hash list
+ * @event_hash: event_hash ptr
+ */
+static void event_hash_list__init(struct hash_list *event_hash)
+{
+	int i;
+
+	for (i = 0; i < HASH_TABLE_SIZE; i++)
+		INIT_LIST_HEAD(&event_hash->ent[i].list);
+}
+
+/**
  * file_hash_list__cleanup: Free up all the space for file_hash list
  * @file_hash: file_hash table
  */
@@ -475,6 +540,23 @@ static void file_hash_list__cleanup(struct hash_list *file_hash)
 }
 
 /**
+ * init_hash_lists: Initialize the hash_lists
+ * @file_hash: file_hash ptr
+ * @event_hash: event_hash ptr
+ *
+ * Wrapper function to initialize both the hash lists.
+ */
+static void init_hash_lists(struct hash_list *file_hash,
+			    struct hash_list *event_hash)
+{
+	if (event_hash)
+		event_hash_list__init(event_hash);
+
+	/* event_hash gets updated in file_hash too */
+	file_hash_list__init(file_hash, event_hash);
+}
+
+/**
  * add_to_hash_list: add an entry to file_hash_list
  * @file_hash: file hash table
  * @target: file name
@@ -645,7 +727,7 @@ int add_sdt_events(const char *arg)
 		return -1;
 	}
 	/* Initialize the file hash_list */
-	file_hash_list__init(&file_hash);
+	init_hash_lists(&file_hash, NULL);
 
 	/* Try to add the events to the file hash_list */
 	ret = add_to_hash_list(&file_hash, arg);
@@ -706,7 +788,7 @@ int dump_sdt_events(void)
 {
 	struct hash_list file_hash;
 
-	file_hash_list__init(&file_hash);
+	init_hash_lists(&file_hash, NULL);
 	file_hash_list__display(&file_hash);
 	return 0;
 }
@@ -725,7 +807,7 @@ int remove_sdt_events(const char *str)
 	int nr_del;
 
 	/* Initialize the hash_lists */
-	file_hash_list__init(&file_hash);
+	init_hash_lists(&file_hash, NULL);
 	res_path = realpath(str, NULL);
 	if (!res_path)
 		return -ENOMEM;
@@ -745,3 +827,99 @@ out:
 	file_hash_list__cleanup(&file_hash);
 	return nr_del;
 }
+
+/**
+ * convert_to_sdt_event : Converts a SDT note into a perf consumable event
+ * @sn: sdt note
+ * @sdt_event: converted sdt_event
+ *
+ * Copies the file name and assigns a reference to @sn to @sdt_event->note
+ */
+static int convert_to_sdt_event(struct sdt_note *sn,
+				struct perf_sdt_event *sdt_event)
+{
+	sdt_event->file_name = strdup(sn->file_ptr->name);
+	if (!sdt_event->file_name) {
+		pr_err("Error: Not enough memory!");
+		return -ENOMEM;
+	}
+	sdt_event->note = sn;
+
+	return 0;
+}
+
+/**
+ * event_hash_list__lookup: Function to lookup an SDT event
+ * @str: provider:name
+ *
+ * file_hash list is not designed to lookup for an SDT event. To do that, we
+ * need another structure : "event_hash". This hash list is built up along
+ * with file_hash list but is based on SDT event names as keys as opposed to
+ * the file names (who serve as keys in file_hash list).
+ * To lookup for the SDT event name, initialize file_hash list first along
+ * with the event_hash. init_hash_lists() will do that for us. Now, obtain
+ * the key for event_hash using @str (provider:name). Go to that entry,
+ * obtain the list_head for that entry, start traversing the list of events.
+ * Once, we get the SDT note we were looking for, change the SDT note to a
+ * perf consumable event.
+ */
+int event_hash_list__lookup(const char *str)
+{
+	struct hash_list file_hash, event_hash;
+	struct sdt_note *sn;
+	struct perf_sdt_event *sdt_event = NULL;
+	struct list_head *ent_head;
+	int  event_key, ret = 0, len;
+	char group[PATH_MAX], event[PATH_MAX], *ptr;
+
+	/* Initialize the hash_lists */
+	init_hash_lists(&file_hash, &event_hash);
+
+	ptr = strdup(str);
+	if (!ptr) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	/* Get the SDT provider name */
+	len = copy_delim(ptr + 1, group, DELIM, strlen(str),
+			 strchr(str, ':'));
+	/* Get the SDT event name */
+	strcpy(event, str + len + 1);
+	/* str + 1 to get rid of leading % */
+	memset(ptr, '\0', strlen(ptr));
+	strcat(ptr, group);
+	strcat(ptr, event);
+	/* Calculate the event hash key */
+	event_key = get_hash_key(ptr);
+	ent_head = &event_hash.ent[event_key].list;
+	if (list_empty(ent_head)) {
+		/* No events at this entry, get out */
+		ret = -1;
+		goto out;
+	}
+
+	/* Found event(s) */
+	list_for_each_entry(sn, ent_head, event_list) {
+		if (!strcmp(sn->name, event) && !strcmp(sn->provider, group)) {
+			sdt_event = (struct perf_sdt_event *)malloc
+				(sizeof(struct perf_sdt_event));
+			if (!sdt_event) {
+				pr_err("Error: Not enough memory!");
+				ret = -ENOMEM;
+				goto out;
+			}
+			ret = convert_to_sdt_event(sn, sdt_event);
+			if (!ret)
+				/* Add the SDT event to uprobes */
+				ret = add_perf_sdt_event(sdt_event);
+		}
+	}
+
+out:
+	file_hash_list__cleanup(&file_hash);
+	if (sdt_event->file_name)
+		free(sdt_event->file_name);
+
+	return ret;
+
+}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index cef620e..33b363d 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -304,6 +304,8 @@ struct sdt_note {
 		Elf32_Addr a32[3];
 	} addr;
 	struct list_head note_list;	/* SDT notes' list */
+	struct list_head event_list;	/* Link to event_hash_list entry */
+	struct file_sdt_ent *file_ptr;	/* ptr to the containing file_sdt_ent */
 };
 
 int get_sdt_note_list(struct list_head *head, const char *target);

