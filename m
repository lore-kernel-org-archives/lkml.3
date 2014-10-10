Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaJJK7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:59:39 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:57803 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaJJK7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:59:36 -0400
Subject: [PATCH v3 4/5] perf/sdt: Delete SDT events from cache
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Fri, 10 Oct 2014 16:29:09 +0530
Message-ID: <20141010105848.15506.6929.stgit@hemant-fedora>
In-Reply-To: <20141010104402.15506.73285.stgit@hemant-fedora>
References: <20141010104402.15506.73285.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101010-0017-0000-0000-000001946B42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support to delete SDT events from the cache.
To delete an event corresponding to a file, first the cache is read into
the file_hash list. The key is calculated from the file name.
And then, the file_list for that file_hash entry is traversed to find out
the target file_list entry. Once, it is found, its contents are freed up.

# ./perf sdt-cache --del /usr/lib64/libc-2.16.so

8 events removed for /usr/lib64/libc-2.16.so

Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-sdt-cache.txt |    6 +++-
 tools/perf/builtin-sdt-cache.c              |   28 +++++++++++++++++++
 tools/perf/util/parse-events.h              |    1 +
 tools/perf/util/sdt.c                       |   39 +++++++++++++++++++++++++++
 4 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-sdt-cache.txt b/tools/perf/Documentation/perf-sdt-cache.txt
index e57a867..523dcda 100644
--- a/tools/perf/Documentation/perf-sdt-cache.txt
+++ b/tools/perf/Documentation/perf-sdt-cache.txt
@@ -8,7 +8,7 @@ perf-sdt-cache - Manage SDT events' cache.
 SYNOPSIS
 --------
 [verse]
-'perf sdt-cache --add <file_name>'
+'perf sdt-cache [--add | --del] <file_name>'
 'perf sdt-cache --dump'
 
 DESCRIPTION
@@ -23,6 +23,10 @@ OPTIONS
 --add::
         Add SDT events in the specified file to the cache. Takes file name
 	as an argument.
+-d::
+--del::
+        Remove SDT events in the specified file from the cache. Takes file as an
+	argument.
 -D::
 --dump::
 	Dump the contents of SDT events cache onto stdout.
diff --git a/tools/perf/builtin-sdt-cache.c b/tools/perf/builtin-sdt-cache.c
index 31041db..b9ed5d4 100644
--- a/tools/perf/builtin-sdt-cache.c
+++ b/tools/perf/builtin-sdt-cache.c
@@ -16,6 +16,7 @@
 /* Session management structure */
 static struct {
 	bool add;
+	bool del;
 	bool dump;
 	const char *target;
 } params;
@@ -29,6 +30,16 @@ static int opt_add_sdt_events(const struct option *opt __maybe_unused,
 	return 0;
 }
 
+static int opt_del_sdt_events(const struct option *opt __maybe_unused,
+			      const char *str, int unset __maybe_unused)
+{
+	params.del = true;
+	params.target = str;
+
+	return 0;
+}
+
+
 static int opt_show_sdt_events(const struct option *opt __maybe_unused,
 			       const char *str, int unset __maybe_unused)
 {
@@ -45,13 +56,16 @@ int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused
 		OPT_CALLBACK('a', "add", NULL, "filename",
 			     "add SDT events from a file.",
 			     opt_add_sdt_events),
+		OPT_CALLBACK('d', "del", NULL, "filename",
+			     "Remove SDT events corresponding to a file from the sdt cache.",
+			     opt_del_sdt_events),
 		OPT_CALLBACK_NOOPT('D', "dump", NULL, "show SDT events",
 				   "Read SDT events from cache and display.",
 				   opt_show_sdt_events),
 		OPT_END()
 	};
 	const char * const sdt_cache_usage[] = {
-		"perf sdt-cache --add filename",
+		"perf sdt-cache [--add | --del] filename",
 		"perf sd-cache --dump",
 		NULL
 	};
@@ -64,6 +78,10 @@ int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused
 
 	symbol__elf_init();
 	if (params.add) {
+		if (params.del) {
+			pr_err("Error: Don't use --del with --add\n");
+			usage_with_options(sdt_cache_usage, sdt_cache_options);
+		}
 		if (params.dump) {
 			pr_err("Error: Don't use --dump with --add\n");
 			usage_with_options(sdt_cache_usage, sdt_cache_options);
@@ -72,6 +90,14 @@ int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused
 		ret = add_sdt_events(params.target);
 		if (ret < 0)
 			pr_err("Cannot add SDT events to cache\n");
+	} else if (params.del) {
+		if (params.dump) {
+			pr_err("Error: Don't use --dump with --del\n");
+			usage_with_options(sdt_cache_usage, sdt_cache_options);
+		}
+		ret = remove_sdt_events(params.target);
+		if (ret < 0)
+			pr_err("Cannot remove SDT events from cache\n");
 	} else if (params.dump) {
 		if (argc == 0) {
 			ret = dump_sdt_events();
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index f43e6aa..2297af7 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -111,5 +111,6 @@ extern int valid_debugfs_mount(const char *debugfs);
 
 int add_sdt_events(const char *file);
 int dump_sdt_events(void);
+int remove_sdt_events(const char *str);
 
 #endif /* __PERF_PARSE_EVENTS_H */
diff --git a/tools/perf/util/sdt.c b/tools/perf/util/sdt.c
index 4e64f3e..880c089 100644
--- a/tools/perf/util/sdt.c
+++ b/tools/perf/util/sdt.c
@@ -655,3 +655,42 @@ int dump_sdt_events(void)
 	file_hash_list__cleanup(&file_hash);
 	return ret;
 }
+
+/**
+ * remove_sdt_events: remove SDT events from cache
+ * @str: filename
+ *
+ * Removes the SDT events from the cache corresponding to the file name
+ * @str.
+ */
+int remove_sdt_events(const char *str)
+{
+	struct hash_table file_hash;
+	char *res_path;
+	int nr_del, ret = -ENOMEM;
+
+	res_path = realpath(str, NULL);
+	if (!res_path)
+		goto out_clean;
+
+	/* Initialize the hash_lists */
+	ret = file_hash_list__init(&file_hash);
+	if (ret < 0)
+		goto out;
+
+	/* Remove the file_list entry from file_hash and update the file_hash */
+	nr_del = file_hash_list__remove(&file_hash, res_path);
+	if (nr_del > 0) {
+		printf("%d event(s) removed for %s\n", nr_del, res_path);
+		flush_hash_list_to_cache(&file_hash);
+		ret = nr_del;
+		goto out;
+	} else if (!nr_del)
+		pr_err("Error: Events for %s not found\n", str);
+
+out:
+	free(res_path);
+out_clean:
+	file_hash_list__cleanup(&file_hash);
+	return ret;
+}

