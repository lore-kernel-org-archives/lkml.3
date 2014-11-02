Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaKBMn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 07:43:26 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:41155 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaKBMnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 07:43:25 -0500
Subject: [PATCH v4 5/5] perf/sdt: Add support to perf record to trace SDT
 events
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Sun, 02 Nov 2014 16:26:28 +0530
Message-ID: <20141102105557.21708.19032.stgit@hemant-fedora>
In-Reply-To: <20141102105006.21708.28734.stgit@hemant-fedora>
References: <20141102105006.21708.28734.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110212-4790-0000-0000-000004A5FEDA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to perf to record SDT events. When invoked,
the SDT event is looked up in the sdt-cache. If its found, an entry is
made silently to uprobe_events file and then recording is invoked, and
then the entry for the SDT event in uprobe_events is silently discarded.

The SDT events are already stored in a cache file
(/var/cache/perf/perf-sdt-file.cache).
Although the file_hash table helps in addition or deletion of SDT events
from the cache, its not of much use when it comes to probing the actual
SDT event, because the key to this hash list is a file name and not the
SDT event name (which is given as an argument to perf record). So, we
won't be able to hash into it.

To avoid this problem, we can create another hash list "event_hash" list
which will be maintained along with the file_hash list.
Whenever a user invokes 'perf record -e %provider:event, perf should
initialize the event_hash list and the file_hash list.
The key to event_hash list is calculated from the event name and its
provider name.

            event_hash       sdt_note
            |---------|   ----------------
            |         |   |   file_ptr   |==> container file_sdt_ent
key = 129 =>| hlist ==|===|=> event_list=|==> to sdt notes hashed to
       	    |         |   |   name       |    same entry
            |---------|   |   provider   |
            |	      |   |   note_list==|==> to other notes in the
key = 130 =>| hlist   |   ---------------     same file
            |---------|

The entry at that key in event_hash contains a list of SDT notes hashed to
the same entry. It compares the name and provider to see if that is the SDT
note we are looking for. If yes, find out the file that contains this SDT
note. There is a file_ptr pointer embedded in this note which points to the
struct file_sdt_ent contained in the file_hash. From "file_sdt_ent" we will
find out the file name.
Convert this sdt note into a perf event and then write this into
uprobe_events file to be able to record the event.
Then, corresponding entries are added to uprobe_events file for
the SDT events.
After recording is done, these events are silently deleted from uprobe_events
file. The uprobe_events file is present in debugfs/tracing directory.

To support the addition and deletion of SDT events to/from uprobe_events
file, a record_sdt struct is maintained which has the event data.

An example usage:

# perf record -e %libc:setjmp -aR sleep 10
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.277 MB perf.data (~12103 samples) ]

# perf report --stdio
# To display the perf.data header info, please use --header/--header-only
#
# Samples: 1  of event 'libc:setjmp'
# Event count (approx.): 1
#
# Overhead  Command  Shared Object  Symbol
# ........  .......  .............  ...............
#
   100.00%  sleep    libc-2.16.so   [.] __sigsetjmp


Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
---
 tools/perf/builtin-probe.c     |    5 +
 tools/perf/builtin-record.c    |   23 ++++
 tools/perf/util/parse-events.c |    6 +
 tools/perf/util/parse-events.h |    3 +
 tools/perf/util/probe-event.c  |   85 ++++++++++++++--
 tools/perf/util/probe-event.h  |    8 ++
 tools/perf/util/probe-finder.c |    3 +
 tools/perf/util/sdt.c          |  213 ++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/symbol.h       |    2 
 9 files changed, 329 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 921bb69..7a64e5b 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -509,3 +509,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix)
 
 	return ret;
 }
+
+void goto_quiet_mode(void)
+{
+	verbose = -1;
+}
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5091a27..1e5fc84 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -47,6 +47,25 @@ struct record {
 	long			samples;
 };
 
+/* Session specific to SDT tracing */
+struct record_sdt {
+	bool    sdt;    /* is this SDT event tracing? */
+	char    *str;   /* hold the event name */
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
+	return ret;
+}
+
+
 static int record__write(struct record *rec, void *bf, size_t size)
 {
 	if (perf_data_file__write(rec->session->file, bf, size) < 0) {
@@ -879,6 +898,10 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 	err = __cmd_record(&record, argc, argv);
+	if (rec_sdt.sdt) {
+		err = remove_perf_sdt_events(rec_sdt.str);
+		free(rec_sdt.str);
+	}
 out_symbol_exit:
 	perf_evlist__delete(rec->evlist);
 	symbol__exit();
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c659a3c..532ef83 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -990,6 +990,12 @@ static int parse_events__scanner(const char *str, void *data, int start_token)
 		return ret;
 
 	buffer = parse_events__scan_string(str, scanner);
+	/* '%' means it can be an SDT event */
+	if (*str == '%')
+		if (strchr(str, ':')) {
+			ret = trace_sdt_event(str);
+			str++;
+		}
 
 #ifdef PARSER_DEBUG
 	parse_events_debug = 1;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index cafdab6..15bd431 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -126,5 +126,8 @@ extern int valid_debugfs_mount(const char *debugfs);
 int add_sdt_events(const char *file);
 int dump_sdt_events(void);
 int remove_sdt_events(const char *str);
+int event_hash_list__lookup(const char *str);
+int remove_perf_sdt_events(const char *str);
+int trace_sdt_event(const char *str);
 
 #endif /* __PERF_PARSE_EVENTS_H */
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 28eb141..f644b46 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -364,7 +364,8 @@ error:
 }
 
 static int add_exec_to_probe_trace_events(struct probe_trace_event *tevs,
-					  int ntevs, const char *exec)
+					  int ntevs, const char *exec,
+					  struct perf_probe_event *pev)
 {
 	int i, ret = 0;
 	unsigned long stext = 0;
@@ -378,7 +379,10 @@ static int add_exec_to_probe_trace_events(struct probe_trace_event *tevs,
 
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
@@ -426,15 +430,14 @@ static int add_module_to_probe_trace_events(struct probe_trace_event *tevs,
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
-
+	if (pev->uprobes)
+		return add_exec_to_probe_trace_events(tevs, ntevs, module, pev);
 	/* Note that currently ref_reloc_sym based probe is not for drivers */
 	if (module)
 		return add_module_to_probe_trace_events(tevs, ntevs, module);
@@ -486,7 +489,7 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 	if (ntevs > 0) {	/* Succeeded to find trace events */
 		pr_debug("Found %d probe_trace_events.\n", ntevs);
 		ret = post_process_probe_trace_events(*tevs, ntevs,
-							target, pev->uprobes);
+							target, pev);
 		if (ret < 0) {
 			clear_probe_trace_events(*tevs, ntevs);
 			zfree(tevs);
@@ -1117,6 +1120,43 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
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
+	goto_quiet_mode();
+	ret = parse_perf_sdt_event(sev, &pev);
+	if (!ret)
+		add_perf_probe_events(&pev, 1, MAX_PROBES,
+				      sev->file_name, true);
+	return ret;
+}
+
 /* Parse perf-probe event argument */
 static int parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 {
@@ -2163,6 +2203,11 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 		group = pev->group;
 		pev->event = tev->event;
 		pev->group = tev->group;
+		/* Arguments currently not supported with SDT events */
+		if (pev->sdt) {
+			pev->nargs = 0;
+			tev->nargs = 0;
+		}
 		show_perf_probe_event(pev, tev->point.module);
 		/* Trick here - restore current event/group */
 		pev->event = (char *)event;
@@ -2371,6 +2416,7 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 {
 	int i, j, ret;
 	struct __event_package *pkgs;
+	bool sdt = pevs->sdt;
 
 	ret = 0;
 	pkgs = zalloc(sizeof(struct __event_package) * npevs);
@@ -2412,7 +2458,8 @@ end:
 		zfree(&pkgs[i].tevs);
 	}
 	free(pkgs);
-	exit_symbol_maps();
+	if (!sdt)	/* We didn't initialize symbol maps for SDT events */
+		exit_symbol_maps();
 
 	return ret;
 }
@@ -2453,7 +2500,7 @@ error:
 }
 
 static int del_trace_probe_event(int fd, const char *buf,
-						  struct strlist *namelist)
+				 struct strlist *namelist)
 {
 	struct str_node *ent, *n;
 	int ret = -1;
@@ -2478,7 +2525,7 @@ static int del_trace_probe_event(int fd, const char *buf,
 	return ret;
 }
 
-int del_perf_probe_events(struct strlist *dellist)
+static int __del_perf_probe_events(struct strlist *dellist)
 {
 	int ret = -1, ufd = -1, kfd = -1;
 	char buf[128];
@@ -2556,6 +2603,24 @@ error:
 	return ret;
 }
 
+int del_perf_probe_events(struct strlist *dellist)
+{
+	return __del_perf_probe_events(dellist);
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
+		ret = __del_perf_probe_events(dellist);
+
+	return ret;
+}
+
 /* TODO: don't use a global variable for filter ... */
 static struct strfilter *available_func_filter;
 
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index e01e994..dd7a0b06 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -74,9 +74,15 @@ struct perf_probe_event {
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
@@ -135,7 +141,9 @@ extern int show_available_vars(struct perf_probe_event *pevs, int npevs,
 			       struct strfilter *filter, bool externs);
 extern int show_available_funcs(const char *module, struct strfilter *filter,
 				bool user);
+extern int add_perf_sdt_event(struct perf_sdt_event *sev);
 
+void goto_quiet_mode(void);
 /* Maximum index number of event-name postfix */
 #define MAX_EVENT_INDEX	1024
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c7918f8..1dd89db8 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1197,6 +1197,9 @@ int debuginfo__find_trace_events(struct debuginfo *dbg,
 	tf.tevs = *tevs;
 	tf.ntevs = 0;
 
+	/* Number of trace events for SDT event is 1 */
+	if (pev->sdt)
+		return 1;
 	ret = debuginfo__find_probes(dbg, &tf.pf);
 	if (ret < 0) {
 		zfree(tevs);
diff --git a/tools/perf/util/sdt.c b/tools/perf/util/sdt.c
index 9dd7e4da..e94a469 100644
--- a/tools/perf/util/sdt.c
+++ b/tools/perf/util/sdt.c
@@ -273,6 +273,37 @@ out_err:
 }
 
 /**
+ * event_hash_list__add : add SDT events to event hash table
+ * @fse: obtained from the file_hash
+ * @event_hash: event_hash list
+ *
+ * Iterate through the SDT notes list one by one and add them
+ * to event hash table.
+ */
+static int event_hash_list__add(struct sdt_note *sn,
+				struct hash_table *event_hash)
+{
+	struct hlist_head *ent_head;
+	int event_key, len;
+	char *str;
+
+	len = strlen(sn->provider) + strlen(sn->name);
+	str = (char *)zalloc(len + 1);
+	if (!str)
+		return -ENOMEM;
+
+	/* Concatenate SDT name and provider and find out the key */
+	sprintf(str, "%s%s", sn->provider, sn->name);
+	event_key = get_hash_key(str);
+	free(str);
+	/* List adding */
+	ent_head = &event_hash->ent[event_key];
+	hlist_add_head(&sn->event_list, ent_head);
+
+	return 0;
+}
+
+/**
  * file_hash_list__populate: Fill up the file hash table
  * @file_hash: empty file hash table
  * @cache: FILE * to read from
@@ -291,11 +322,12 @@ out_err:
  * Find out the hash key from the file_name and use that to add this new
  * entry to file hash.
  */
-static int file_hash_list__populate(struct hash_table *file_hash, FILE *cache)
+static int file_hash_list__populate(struct hash_table *file_hash, FILE *cache,
+				    struct hash_table *event_hash)
 {
 	struct file_sdt_ent *fse = NULL;
 	struct sdt_note *sn;
-	int key, val, ret = -EBADF;
+	int key, val, nr_add = 0, ret = -EBADF;
 	char *ptr, *tmp, *data = NULL;
 	size_t len = 2 * PATH_MAX;
 
@@ -321,6 +353,13 @@ static int file_hash_list__populate(struct hash_table *file_hash, FILE *cache)
 				goto out;
 			}
 			list_add(&sn->note_list, &fse->sdt_list);
+			sn->file_ptr = fse;
+			if (event_hash) {
+				ret = event_hash_list__add(sn, event_hash);
+				if (ret < 0)
+					break;
+				nr_add++;
+			}
 		} else {
 			/*
 			 * Its a file entry:
@@ -345,7 +384,7 @@ static int file_hash_list__populate(struct hash_table *file_hash, FILE *cache)
 			strcpy(fse->sbuild_id, ptr);
 			key = get_hash_key(fse->name);
 			hlist_add_head(&fse->file_list, &file_hash->ent[key]);
-			ret = 0;
+			ret = nr_add;
 		}
 	}
 
@@ -360,8 +399,10 @@ out:
  *
  * Initializes the entries(ent's) of file_hash and opens the cache file.
  * To look for the cache file, look into the directory in HOME env variable.
+ * Updates the event_hash list if needed.
  */
-static int file_hash_list__init(struct hash_table *file_hash)
+static int file_hash_list__init(struct hash_table *file_hash,
+				struct hash_table *event_hash)
 {
 	FILE *cache;
 	int i, ret = 0;
@@ -389,9 +430,9 @@ static int file_hash_list__init(struct hash_table *file_hash)
 	ret = stat(sdt_cache_path, &fs);
 	if (ret)
 		goto out;
-	/* Populate the hash list */
+	/* Populate the hash lists */
 	if (fs.st_size > 0)
-		ret = file_hash_list__populate(file_hash, cache);
+		ret = file_hash_list__populate(file_hash, cache, event_hash);
 	fclose(cache);
 out:
 	return ret;
@@ -421,6 +462,34 @@ static void file_hash_list__cleanup(struct hash_table *file_hash)
 	}
 }
 
+/**
+ * event_hash_list__init: Initialize the event_hash list
+ * @event_hash: event_hash ptr
+ */
+static void event_hash_list__init(struct hash_table *event_hash)
+{
+	int i;
+
+	for (i = 0; i < SDT_HASH_SIZE; i++)
+		INIT_HLIST_HEAD(&event_hash->ent[i]);
+}
+
+/**
+ * init_hash_lists: Initialize the hash_lists
+ * @file_hash: file_hash ptr
+ * @event_hash: event_hash ptr
+ *
+ * Wrapper function to initialize both the hash lists.
+ */
+static int init_hash_lists(struct hash_table *file_hash,
+			    struct hash_table *event_hash)
+{
+	if (event_hash)
+		event_hash_list__init(event_hash);
+
+	/* event_hash gets updated in file_hash too */
+	return file_hash_list__init(file_hash, event_hash);
+}
 
 /**
  * add_to_hash_list: add an entry to file_hash_list
@@ -593,7 +662,7 @@ int add_sdt_events(const char *arg)
 	int ret, val;
 
 	/* Initialize the file hash_list */
-	ret = file_hash_list__init(&file_hash);
+	ret = init_hash_lists(&file_hash, NULL);
 	if (ret < 0) {
 		pr_err("Error: Couldn't initialize the SDT hash tables\n");
 		goto out;
@@ -656,7 +725,7 @@ int dump_sdt_events(void)
 	struct hash_table file_hash;
 	int ret;
 
-	ret = file_hash_list__init(&file_hash);
+	ret = init_hash_lists(&file_hash, NULL);
 	if (!ret)
 		file_hash_list__display(&file_hash);
 	file_hash_list__cleanup(&file_hash);
@@ -682,7 +751,7 @@ int remove_sdt_events(const char *str)
 		goto out_err;
 	}
 	/* Initialize the hash_lists */
-	ret = file_hash_list__init(&file_hash);
+	ret = init_hash_lists(&file_hash, NULL);
 	if (ret < 0)
 		goto out;
 
@@ -702,3 +771,129 @@ out:
 out_err:
 	return ret;
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
+ * build_id__matches: Function to compare build-ids
+ * @fse: file_entry
+ *
+ * This function finds out the current build id of the file @fse->name
+ * and then compares that to the build id stored in @fse->sbuild_id.
+ * This is used to see if the file has changed since addition of that
+ * file's sdt events to the cache.
+ * Returns 0 if the build-ids match and non-zero in case of an error.
+ */
+static int build_id__matches(struct file_sdt_ent *fse)
+{
+	u8 curr_build_id[BUILD_ID_SIZE];
+	char curr_sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+	symbol__elf_init();
+	if (filename__read_build_id(fse->name, &curr_build_id,
+				    sizeof(curr_build_id)) < 0) {
+		pr_err("Couldn't read build-id in %s\n", fse->name);
+		goto out_err;
+	}
+	build_id__sprintf(curr_build_id, sizeof(curr_build_id),
+			  curr_sbuild_id);
+	if (!strcmp(curr_sbuild_id, fse->sbuild_id))
+		return 0;
+out_err:
+	return -1;
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
+	struct hash_table file_hash, event_hash;
+	struct sdt_note *sn;
+	struct perf_sdt_event *sdt_event = NULL;
+	struct hlist_head *ent_head;
+	char group[PATH_MAX], event[PATH_MAX];
+	char *ptr, *tmp, s[PATH_MAX], delim[2] = {DELIM, '\0'};
+	int  event_key, ret = 0;
+
+	/* Initialize the hash_lists */
+	ret = init_hash_lists(&file_hash, &event_hash);
+	if (ret < 0)
+		goto out;
+	strcpy(s, str);
+	/* Get the SDT provider name */
+	ptr = strtok_r(s + 1, delim, &tmp);	/* s + 1 to get rid of '%' */
+	if (!ptr)
+		goto out;
+	strcpy(group, ptr);
+	/* Get the SDT event name */
+	ptr = strtok_r(NULL, delim, &tmp);
+	if (!ptr)
+		goto out;
+	strcpy(event, ptr);
+
+	/* Get the SDT event name */
+	memset(ptr, '\0', strlen(ptr));
+	sprintf(ptr, "%s%s", group, event);
+	/* Calculate the event hash key */
+	event_key = get_hash_key(ptr);
+	ent_head = &event_hash.ent[event_key];
+
+	/* Found event(s) */
+	hlist_for_each_entry(sn, ent_head, event_list) {
+		if (!strcmp(sn->name, event) && !strcmp(sn->provider, group)) {
+			sdt_event = malloc(sizeof(*sdt_event));
+			if (!sdt_event) {
+				pr_err("Error: Not enough memory!");
+				ret = -ENOMEM;
+				goto out;
+			}
+			sdt_event->file_name = NULL;
+			ret = build_id__matches(sn->file_ptr);
+			if (ret) {
+				pr_err("File versions don't match\nPlease run \"perf sdt-cache --add <file>\" before doing \"perf record\"\n");
+				ret = 0;
+				goto out;
+			}
+			ret = convert_to_sdt_event(sn, sdt_event);
+			/* Add the SDT event to uprobes */
+			if (!ret)
+				ret = add_perf_sdt_event(sdt_event);
+		}
+	}
+out:
+	file_hash_list__cleanup(&file_hash);
+	if (sdt_event)
+		free(sdt_event->file_name);
+	return ret;
+}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ed4ecfa..245f093 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -323,6 +323,8 @@ struct sdt_note {
 		Elf32_Addr a32[3];
 	} addr;
 	struct list_head note_list;	/* SDT notes' list */
+	struct hlist_node event_list;	/* Link to event_hash_list entry */
+	struct file_sdt_ent *file_ptr;	/* ptr to the containing file_sdt_ent */
 };
 
 int get_sdt_note_list(struct list_head *head, const char *target);

