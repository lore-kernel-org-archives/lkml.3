Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaABK6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:58:34 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:65067 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaABK61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:58:27 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/5] perf kmem: introduce --list-cmds
Date: Thu,  2 Jan 2014 16:28:47 +0530
Message-Id: <1388660330-16781-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.227.g53f3478
In-Reply-To: <1388660330-16781-1-git-send-email-artagnon@gmail.com>
References: <1388660330-16781-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose build_usage_string() and list_cmds_raw() via util.h, and reuse
the functions to implement --list-cmds for 'perf kmem', just like we did
for 'perf kvm'. Also use it in perf-completion.sh to aid completions.

Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-kmem.c     | 15 +++++++++++----
 tools/perf/builtin-kvm.c      | 23 -----------------------
 tools/perf/perf-completion.sh |  6 +++---
 tools/perf/util/util.c        | 24 ++++++++++++++++++++++++
 tools/perf/util/util.h        |  4 ++++
 5 files changed, 42 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 929462a..af2ddb7 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -743,6 +743,7 @@ static int __cmd_record(int argc, const char **argv)
 int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	const char * const default_sort_order = "frag,hit,bytes";
+	bool list_cmds = false;
 	const struct option kmem_options[] = {
 	OPT_STRING('i', "input", &input_name, "file", "input file name"),
 	OPT_CALLBACK_NOOPT(0, "caller", NULL, NULL,
@@ -754,14 +755,20 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 		     parse_sort_opt),
 	OPT_CALLBACK('l', "line", NULL, "num", "show n lines", parse_line_opt),
 	OPT_BOOLEAN(0, "raw-ip", &raw_ip, "show raw ip instead of symbol"),
+	OPT_BOOLEAN(0, "list-cmds", &list_cmds,
+		"list commands raw for use by scripts"),
 	OPT_END()
 	};
-	const char * const kmem_usage[] = {
-		"perf kmem [<options>] {record|stat}",
-		NULL
-	};
+	const char *const subcommands[] = { "record", "stat", NULL };
+	const char *kmem_usage[] = { NULL, NULL };
+	build_usage_string(kmem_usage, "kmem", subcommands);
+
 	argc = parse_options(argc, argv, kmem_options, kmem_usage, 0);
 
+	if (list_cmds) {
+		list_cmds_raw(subcommands);
+		return 0;
+	}
 	if (!argc)
 		usage_with_options(kmem_usage, kmem_options);
 
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 313b217..1825466 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1669,29 +1669,6 @@ __cmd_buildid_list(const char *file_name, int argc, const char **argv)
 	return cmd_buildid_list(i, rec_argv, NULL);
 }
 
-static void build_usage_string(const char **usage_str, const char *command,
-			const char *const *subcommands)
-{
-	struct strbuf buf = STRBUF_INIT;
-
-	strbuf_addf(&buf, "perf %s [<options>] {", command);
-	for (int i = 0; subcommands[i]; i++) {
-		if (i)
-			strbuf_addstr(&buf, "|");
-		strbuf_addstr(&buf, subcommands[i]);
-	}
-	strbuf_addstr(&buf, "}");
-
-	usage_str[0] = strdup(buf.buf);
-	strbuf_release(&buf);
-}
-
-static void list_cmds_raw(const char *const *subcommands)
-{
-	for (int i = 0; subcommands[i]; i++)
-		printf("%s ", subcommands[i]);
-}
-
 int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	const char *file_name = NULL;
diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index d8bfa43..81a932a 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -121,9 +121,9 @@ __perf_main ()
 	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
 		evts=$($cmd list --raw-dump)
 		__perfcomp_colon "$evts" "$cur"
-	# List subcommands for 'perf kvm'
-	elif [[ $prev == "kvm" ]]; then
-		subcmds=$($cmd kvm --list-cmds)
+	# List subcommands for kmem, kvm
+	elif [[ $prev == @(kmem|kvm) ]]; then
+		subcmds=$($cmd $prev --list-cmds)
 		__perfcomp_colon "$subcmds" "$cur"
 	# List long option names
 	elif [[ $cur == --* ]];  then
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 42ad667..e42bedc 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -11,6 +11,7 @@
 #include <errno.h>
 #include <limits.h>
 #include <byteswap.h>
+#include <strbuf.h>
 #include <linux/kernel.h>
 
 /*
@@ -537,3 +538,26 @@ void mem_bswap_64(void *src, int byte_size)
 		++m;
 	}
 }
+
+void build_usage_string(const char **usage_str, const char *command,
+			const char *const *subcommands)
+{
+	struct strbuf buf = STRBUF_INIT;
+
+	strbuf_addf(&buf, "perf %s [<options>] {", command);
+	for (int i = 0; subcommands[i]; i++) {
+		if (i)
+			strbuf_addstr(&buf, "|");
+		strbuf_addstr(&buf, subcommands[i]);
+	}
+	strbuf_addstr(&buf, "}");
+
+	usage_str[0] = strdup(buf.buf);
+	strbuf_release(&buf);
+}
+
+void list_cmds_raw(const char *const *subcommands)
+{
+	for (int i = 0; subcommands[i]; i++)
+		printf("%s ", subcommands[i]);
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 9a2c268..0268347 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -327,4 +327,8 @@ void mem_bswap_64(void *src, int byte_size);
 void mem_bswap_32(void *src, int byte_size);
 
 const char *get_filename_for_perf_kvm(void);
+
+void build_usage_string(const char **usage_str, const char *command, const char *const *subcommands);
+void list_cmds_raw(const char *const *subcommands);
+
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.8.5.2.227.g53f3478

