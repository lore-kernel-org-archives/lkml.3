Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaHRIYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:24:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51620 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaHRIYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:24:51 -0400
Date: Mon, 18 Aug 2014 01:23:19 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-5f03cba41590b5e7db5b66d2b2aa3e146ff8a84f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, naota@elisp.net, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        naota@elisp.net, namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <20140814022234.3545.22199.stgit@kbuild-fedora.novalocal>
References: <20140814022234.3545.22199.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Make error messages thread-safe
Git-Commit-ID: 5f03cba41590b5e7db5b66d2b2aa3e146ff8a84f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f03cba41590b5e7db5b66d2b2aa3e146ff8a84f
Gitweb:     http://git.kernel.org/tip/5f03cba41590b5e7db5b66d2b2aa3e146ff8a84f
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Aug 2014 02:22:34 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Aug 2014 10:56:53 -0300

perf probe: Make error messages thread-safe

To make error messages thread-safe, this replaces strerror with
strerror_r for warnings, and just shows the return value instead of
using strerror for debug messages.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140814022234.3545.22199.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c     |  5 ++++-
 tools/perf/util/probe-event.c  | 28 +++++++++++++++-------------
 tools/perf/util/probe-finder.c |  7 +++++--
 3 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index c63fa29..347729e 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -290,8 +290,11 @@ static void cleanup_params(void)
 
 static void pr_err_with_code(const char *msg, int err)
 {
+	char sbuf[STRERR_BUFSIZE];
+
 	pr_err("%s", msg);
-	pr_debug(" Reason: %s (Code: %d)", strerror(-err), err);
+	pr_debug(" Reason: %s (Code: %d)",
+		 strerror_r(-err, sbuf, sizeof(sbuf)), err);
 	pr_err("\n");
 }
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index bf39c23..f73595f 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -573,7 +573,7 @@ static int get_real_path(const char *raw_path, const char *comp_dir,
 
 static int __show_one_line(FILE *fp, int l, bool skip, bool show_num)
 {
-	char buf[LINEBUF_SIZE];
+	char buf[LINEBUF_SIZE], sbuf[STRERR_BUFSIZE];
 	const char *color = show_num ? "" : PERF_COLOR_BLUE;
 	const char *prefix = NULL;
 
@@ -593,7 +593,8 @@ static int __show_one_line(FILE *fp, int l, bool skip, bool show_num)
 	return 1;
 error:
 	if (ferror(fp)) {
-		pr_warning("File read error: %s\n", strerror(errno));
+		pr_warning("File read error: %s\n",
+			   strerror_r(errno, sbuf, sizeof(sbuf)));
 		return -1;
 	}
 	return 0;
@@ -626,6 +627,7 @@ static int __show_line_range(struct line_range *lr, const char *module)
 	FILE *fp;
 	int ret;
 	char *tmp;
+	char sbuf[STRERR_BUFSIZE];
 
 	/* Search a line range */
 	dinfo = open_debuginfo(module, false);
@@ -662,7 +664,7 @@ static int __show_line_range(struct line_range *lr, const char *module)
 	fp = fopen(lr->path, "r");
 	if (fp == NULL) {
 		pr_warning("Failed to open %s: %s\n", lr->path,
-			   strerror(errno));
+			   strerror_r(errno, sbuf, sizeof(sbuf)));
 		return -errno;
 	}
 	/* Skip to starting line number */
@@ -1410,8 +1412,7 @@ int synthesize_perf_probe_arg(struct perf_probe_arg *pa, char *buf, size_t len)
 
 	return tmp - buf;
 error:
-	pr_debug("Failed to synthesize perf probe argument: %s\n",
-		 strerror(-ret));
+	pr_debug("Failed to synthesize perf probe argument: %d\n", ret);
 	return ret;
 }
 
@@ -1460,8 +1461,7 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 
 	return buf;
 error:
-	pr_debug("Failed to synthesize perf probe point: %s\n",
-		 strerror(-ret));
+	pr_debug("Failed to synthesize perf probe point: %d\n", ret);
 	free(buf);
 	return NULL;
 }
@@ -1787,7 +1787,7 @@ static void clear_probe_trace_event(struct probe_trace_event *tev)
 
 static void print_open_warning(int err, bool is_kprobe)
 {
-	char sbuf[128];
+	char sbuf[STRERR_BUFSIZE];
 
 	if (err == -ENOENT) {
 		const char *config;
@@ -1817,7 +1817,7 @@ static void print_both_open_warning(int kerr, int uerr)
 		pr_warning("Please rebuild kernel with CONFIG_KPROBE_EVENTS "
 			   "or/and CONFIG_UPROBE_EVENTS.\n");
 	else {
-		char sbuf[128];
+		char sbuf[STRERR_BUFSIZE];
 		pr_warning("Failed to open kprobe events: %s.\n",
 			   strerror_r(-kerr, sbuf, sizeof(sbuf)));
 		pr_warning("Failed to open uprobe events: %s.\n",
@@ -2038,6 +2038,7 @@ static int write_probe_trace_event(int fd, struct probe_trace_event *tev)
 {
 	int ret = 0;
 	char *buf = synthesize_probe_trace_command(tev);
+	char sbuf[STRERR_BUFSIZE];
 
 	if (!buf) {
 		pr_debug("Failed to synthesize probe trace event.\n");
@@ -2049,7 +2050,7 @@ static int write_probe_trace_event(int fd, struct probe_trace_event *tev)
 		ret = write(fd, buf, strlen(buf));
 		if (ret <= 0)
 			pr_warning("Failed to write event: %s\n",
-				   strerror(errno));
+				   strerror_r(errno, sbuf, sizeof(sbuf)));
 	}
 	free(buf);
 	return ret;
@@ -2063,7 +2064,7 @@ static int get_new_event_name(char *buf, size_t len, const char *base,
 	/* Try no suffix */
 	ret = e_snprintf(buf, len, "%s", base);
 	if (ret < 0) {
-		pr_debug("snprintf() failed: %s\n", strerror(-ret));
+		pr_debug("snprintf() failed: %d\n", ret);
 		return ret;
 	}
 	if (!strlist__has_entry(namelist, buf))
@@ -2079,7 +2080,7 @@ static int get_new_event_name(char *buf, size_t len, const char *base,
 	for (i = 1; i < MAX_EVENT_INDEX; i++) {
 		ret = e_snprintf(buf, len, "%s_%d", base, i);
 		if (ret < 0) {
-			pr_debug("snprintf() failed: %s\n", strerror(-ret));
+			pr_debug("snprintf() failed: %d\n", ret);
 			return ret;
 		}
 		if (!strlist__has_entry(namelist, buf))
@@ -2444,7 +2445,8 @@ static int __del_trace_probe_event(int fd, struct str_node *ent)
 	printf("Removed event: %s\n", ent->s);
 	return 0;
 error:
-	pr_warning("Failed to delete event: %s\n", strerror(-ret));
+	pr_warning("Failed to delete event: %s\n",
+		   strerror_r(-ret, buf, sizeof(buf)));
 	return ret;
 }
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index dca9145..9c59356 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -281,6 +281,7 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 	struct probe_trace_arg_ref **ref_ptr = &tvar->ref;
 	Dwarf_Die type;
 	char buf[16];
+	char sbuf[STRERR_BUFSIZE];
 	int bsize, boffs, total;
 	int ret;
 
@@ -367,7 +368,7 @@ formatted:
 		if (ret >= 16)
 			ret = -E2BIG;
 		pr_warning("Failed to convert variable type: %s\n",
-			   strerror(-ret));
+			   strerror_r(-ret, sbuf, sizeof(sbuf)));
 		return ret;
 	}
 	tvar->type = strdup(buf);
@@ -779,10 +780,12 @@ static int find_lazy_match_lines(struct intlist *list,
 	size_t line_len;
 	ssize_t len;
 	int count = 0, linenum = 1;
+	char sbuf[STRERR_BUFSIZE];
 
 	fp = fopen(fname, "r");
 	if (!fp) {
-		pr_warning("Failed to open %s: %s\n", fname, strerror(errno));
+		pr_warning("Failed to open %s: %s\n", fname,
+			   strerror_r(errno, sbuf, sizeof(sbuf)));
 		return -errno;
 	}
 
