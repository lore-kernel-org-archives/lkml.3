Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaKBMmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 07:42:38 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38648 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaKBMme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 07:42:34 -0500
Subject: [PATCH v4 3/5] perf/sdt: Show SDT cache contents
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Sun, 02 Nov 2014 16:25:18 +0530
Message-ID: <20141102105500.21708.29794.stgit@hemant-fedora>
In-Reply-To: <20141102105006.21708.28734.stgit@hemant-fedora>
References: <20141102105006.21708.28734.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110212-0021-0000-0000-0000007048CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to dump the SDT cache onto sdtout.
The cache data is read into a hash_list and then, it iterates through
the hash_list to dump the data onto stdout.

# ./perf sdt-cache --dump
/usr/lib64/libc-2.16.so:
   %libc:lll_futex_wake
   %libc:longjmp_target
   %libc:longjmp
   %libc:lll_lock_wait_private
   %libc:lll_futex_wake
   %libc:longjmp_target
   %libc:longjmp
   %libc:setjmp

Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-sdt-cache.txt |    7 +++-
 tools/perf/builtin-sdt-cache.c              |   28 +++++++++++++++-
 tools/perf/util/parse-events.h              |    1 +
 tools/perf/util/sdt.c                       |   48 +++++++++++++++++++++++++++
 4 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-sdt-cache.txt b/tools/perf/Documentation/perf-sdt-cache.txt
index 08b9985..e57a867 100644
--- a/tools/perf/Documentation/perf-sdt-cache.txt
+++ b/tools/perf/Documentation/perf-sdt-cache.txt
@@ -9,11 +9,13 @@ SYNOPSIS
 --------
 [verse]
 'perf sdt-cache --add <file_name>'
+'perf sdt-cache --dump'
 
 DESCRIPTION
 -----------
 This command manages the SDT events cache. It can add/remove SDT events
-associated with an ELF to the cache.
+associated with an ELF to the cache. It can also dump the SDT events' cache
+onto stdout.
 
 OPTIONS
 -------
@@ -21,6 +23,9 @@ OPTIONS
 --add::
         Add SDT events in the specified file to the cache. Takes file name
 	as an argument.
+-D::
+--dump::
+	Dump the contents of SDT events cache onto stdout.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-sdt-cache.c b/tools/perf/builtin-sdt-cache.c
index 0e012f6..11f41a2 100644
--- a/tools/perf/builtin-sdt-cache.c
+++ b/tools/perf/builtin-sdt-cache.c
@@ -16,6 +16,7 @@
 /* Session management structure */
 static struct {
 	bool add;
+	bool dump;
 	const char *target;
 } params;
 
@@ -28,20 +29,37 @@ static int opt_add_sdt_events(const struct option *opt __maybe_unused,
 	return 0;
 }
 
+static int opt_show_sdt_events(const struct option *opt __maybe_unused,
+			       const char *str, int unset __maybe_unused)
+{
+	if (str)
+		pr_err("Unknown option %s\n", str);
+	params.dump = true;
+	return 0;
+}
+
 int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int ret;
-	const struct option sdt_cache_options[] = {
+	struct option sdt_cache_options[] = {
 		OPT_CALLBACK('a', "add", NULL, "filename",
 			     "add SDT events from a file.",
 			     opt_add_sdt_events),
+		OPT_CALLBACK_NOOPT('D', "dump", NULL, "show SDT events",
+				   "Read SDT events from cache and display.",
+				   opt_show_sdt_events),
 		OPT_END()
 	};
+
 	const char * const sdt_cache_usage[] = {
 		"perf sdt-cache --add filename",
+		"perf sdt-cache --dump",
 		NULL
 	};
 
+	set_option_flag(sdt_cache_options, 'a', "add", PARSE_OPT_EXCLUSIVE);
+	set_option_flag(sdt_cache_options, 'D', "dump", PARSE_OPT_EXCLUSIVE);
+
 	argc = parse_options(argc, argv, sdt_cache_options,
 			     sdt_cache_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
@@ -53,6 +71,14 @@ int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused
 		ret = add_sdt_events(params.target);
 		if (ret < 0)
 			pr_err("Cannot add SDT events to cache\n");
+	} else if (params.dump) {
+		if (argc == 0) {
+			ret = dump_sdt_events();
+			if (ret < 0)
+				pr_err("Cannot dump SDT event cache\n");
+		} else
+			usage_with_options(sdt_cache_usage, sdt_cache_options);
+
 	} else
 		usage_with_options(sdt_cache_usage, sdt_cache_options);
 	return 0;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 8bde8ea..cca6859 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -124,5 +124,6 @@ extern int is_valid_tracepoint(const char *event_string);
 extern int valid_debugfs_mount(const char *debugfs);
 
 int add_sdt_events(const char *file);
+int dump_sdt_events(void);
 
 #endif /* __PERF_PARSE_EVENTS_H */
diff --git a/tools/perf/util/sdt.c b/tools/perf/util/sdt.c
index 3b84355..5f70dd6 100644
--- a/tools/perf/util/sdt.c
+++ b/tools/perf/util/sdt.c
@@ -613,3 +613,51 @@ out:
 	file_hash_list__cleanup(&file_hash);
 	return ret;
 }
+
+/**
+ * file_hash_list__display: Dump the entries of file_hash list
+ * @file_hash: file hash list
+ *
+ * Iterate through each of the entries and the chains and dump
+ * onto stdscr.
+ */
+static void file_hash_list__display(struct hash_table *file_hash)
+{
+	struct file_sdt_ent *file_pos;
+	struct list_head *sdt_head;
+	struct hlist_head *ent_head;
+	struct sdt_note *sdt_ptr;
+	int i;
+
+	/* Go through all entries */
+	for (i = 0; i < SDT_HASH_SIZE; i++) {
+		/* Obtain the list head */
+		ent_head = &file_hash->ent[i];
+
+		/* ':' are used here as delimiters */
+		hlist_for_each_entry(file_pos, ent_head, file_list) {
+			fprintf(stdout, "%s:\n", file_pos->name);
+			sdt_head = &file_pos->sdt_list;
+			list_for_each_entry(sdt_ptr, sdt_head, note_list) {
+				fprintf(stdout, "%4s%s:%s\n", "%",
+					sdt_ptr->provider, sdt_ptr->name);
+			}
+			printf("\n");
+		}
+	}
+}
+
+/**
+ * dump_sdt_events: Dump the SDT events on stdout
+ */
+int dump_sdt_events(void)
+{
+	struct hash_table file_hash;
+	int ret;
+
+	ret = file_hash_list__init(&file_hash);
+	if (!ret)
+		file_hash_list__display(&file_hash);
+	file_hash_list__cleanup(&file_hash);
+	return ret;
+}

