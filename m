Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaJARj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:39:59 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:52994 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbaJARj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:39:58 -0400
Subject: [PATCH v2 4/5] perf/sdt: Delete SDT events from cache
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Wed, 01 Oct 2014 08:18:41 +0530
Message-ID: <20141001024834.28985.5943.stgit@hemant-fedora>
In-Reply-To: <20141001023723.28985.39736.stgit@hemant-fedora>
References: <20141001023723.28985.39736.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100117-2674-0000-0000-000002152AAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support to delete SDT events from the cache.
To delete an event corresponding to a file, first the cache is read into
the file_hash list. The key is calculated from the file name.
And then, the file_list for that file_hash entry is traversed to find out
the target file_list entry. Once, it is found, its contents are all freed up.

# ./perf sdt-cache --del /usr/lib64/libc-2.16.so

8 events removed for /usr/lib64/libc-2.16.so!

Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
---
 tools/perf/builtin-sdt-cache.c |   28 +++++++++++++++++++++++++++-
 tools/perf/util/parse-events.h |    1 +
 tools/perf/util/sdt.c          |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sdt-cache.c b/tools/perf/builtin-sdt-cache.c
index 5faf8e5..12276da 100644
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
@@ -29,6 +30,15 @@ static int opt_add_sdt_events(const struct option *opt __maybe_unused,
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
 static int opt_show_sdt_events(const struct option *opt __maybe_unused,
 			       const char *str, int unset __maybe_unused)
 {
@@ -45,13 +55,17 @@ int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused
 		OPT_CALLBACK('a', "add", NULL, "filename",
 			     "add SDT events from a file.",
 			     opt_add_sdt_events),
+		OPT_CALLBACK('d', "del", NULL, "filename",
+			     "Remove SDT events corresponding to a file from the"
+			     " sdt cache.",
+			     opt_del_sdt_events),
 		OPT_CALLBACK_NOOPT('s', "dump", NULL, "show SDT events",
 				   "Read SDT events from cache and display.",
 				   opt_show_sdt_events),
 		OPT_END()
 	};
 	const char * const sdt_cache_usage[] = {
-		"perf sdt_cache [--add filename | --dump]",
+		"perf sdt_cache [--add filename | --del filename | --dump]",
 		NULL
 	};
 
@@ -63,6 +77,10 @@ int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused
 
 	symbol__elf_init();
 	if (params.add) {
+		if (params.del) {
+			pr_err("Error: Don't use --del with --add\n");
+			usage_with_options(sdt_cache_usage, sdt_cache_options);
+		}
 		if (params.dump) {
 			pr_err("Error: Don't use --dump with --add\n");
 			usage_with_options(sdt_cache_usage, sdt_cache_options);
@@ -70,6 +88,14 @@ int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused
 		ret = add_sdt_events(params.target);
 		if (ret < 0)
 			pr_err("Cannot add SDT events to cache!\n");
+	} else if (params.del) {
+		if (params.dump) {
+			pr_err("Error: Don't use --dump with --del\n");
+			usage_with_options(sdt_cache_usage, sdt_cache_options);
+		}
+		ret = remove_sdt_events(params.target);
+		if (ret < 0)
+			pr_err("Cannot remove SDT events from cache!\n");
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
index f2c7dc0..e8eea48 100644
--- a/tools/perf/util/sdt.c
+++ b/tools/perf/util/sdt.c
@@ -711,3 +711,38 @@ int dump_sdt_events(void)
 	file_hash_list__display(&file_hash);
 	return 0;
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
+	struct hash_list file_hash;
+	char *res_path;
+	int nr_del;
+
+	/* Initialize the hash_lists */
+	file_hash_list__init(&file_hash);
+	res_path = realpath(str, NULL);
+	if (!res_path)
+		return -ENOMEM;
+
+	/* Remove the file_list entry from file_hash and update the event_hash */
+	nr_del = file_hash_list__remove(&file_hash, res_path);
+	if (nr_del > 0) {
+		printf("%d events removed for %s!\n", nr_del, res_path);
+		flush_hash_list_to_cache(&file_hash);
+		goto out;
+	} else if (!nr_del) {
+		pr_err("Events for %s not found!\n", str);
+	}
+
+out:
+	free(res_path);
+	file_hash_list__cleanup(&file_hash);
+	return nr_del;
+}

