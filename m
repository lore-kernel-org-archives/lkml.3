Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaAMUwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:52:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40437 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaAMUsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:10 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 21/38] perf report: Move logic to warn about kptr_restrict'ed kernels to separate function
Date: Mon, 13 Jan 2014 17:47:22 -0300
Message-Id: <1389646059-24881-22-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Its too big, better have a separate function for it so that the main
logic gets shorter/clearer.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ahh6vfzyh8fsygjwrsbroeu0@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 56 ++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bf8dd2e893e4..f2ff8609e98e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -412,14 +412,41 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 	return 0;
 }
 
+static void report__warn_kptr_restrict(const struct report *rep)
+{
+	struct map *kernel_map = rep->session->machines.host.vmlinux_maps[MAP__FUNCTION];
+	struct kmap *kernel_kmap = map__kmap(kernel_map);
+
+	if (kernel_map == NULL ||
+	    (kernel_map->dso->hit &&
+	     (kernel_kmap->ref_reloc_sym == NULL ||
+	      kernel_kmap->ref_reloc_sym->addr == 0))) {
+		const char *desc =
+		    "As no suitable kallsyms nor vmlinux was found, kernel samples\n"
+		    "can't be resolved.";
+
+		if (kernel_map) {
+			const struct dso *kdso = kernel_map->dso;
+			if (!RB_EMPTY_ROOT(&kdso->symbols[MAP__FUNCTION])) {
+				desc = "If some relocation was applied (e.g. "
+				       "kexec) symbols may be misresolved.";
+			}
+		}
+
+		ui__warning(
+"Kernel address maps (/proc/{kallsyms,modules}) were restricted.\n\n"
+"Check /proc/sys/kernel/kptr_restrict before running 'perf record'.\n\n%s\n\n"
+"Samples in kernel modules can't be resolved as well.\n\n",
+		desc);
+	}
+}
+
 static int __cmd_report(struct report *rep)
 {
 	int ret = -EINVAL;
 	u64 nr_samples;
 	struct perf_session *session = rep->session;
 	struct perf_evsel *pos;
-	struct map *kernel_map;
-	struct kmap *kernel_kmap;
 	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
 	struct ui_progress prog;
 	struct perf_data_file *file = session->file;
@@ -444,30 +471,7 @@ static int __cmd_report(struct report *rep)
 	if (ret)
 		return ret;
 
-	kernel_map = session->machines.host.vmlinux_maps[MAP__FUNCTION];
-	kernel_kmap = map__kmap(kernel_map);
-	if (kernel_map == NULL ||
-	    (kernel_map->dso->hit &&
-	     (kernel_kmap->ref_reloc_sym == NULL ||
-	      kernel_kmap->ref_reloc_sym->addr == 0))) {
-		const char *desc =
-		    "As no suitable kallsyms nor vmlinux was found, kernel samples\n"
-		    "can't be resolved.";
-
-		if (kernel_map) {
-			const struct dso *kdso = kernel_map->dso;
-			if (!RB_EMPTY_ROOT(&kdso->symbols[MAP__FUNCTION])) {
-				desc = "If some relocation was applied (e.g. "
-				       "kexec) symbols may be misresolved.";
-			}
-		}
-
-		ui__warning(
-"Kernel address maps (/proc/{kallsyms,modules}) were restricted.\n\n"
-"Check /proc/sys/kernel/kptr_restrict before running 'perf record'.\n\n%s\n\n"
-"Samples in kernel modules can't be resolved as well.\n\n",
-		desc);
-	}
+	report__warn_kptr_restrict(rep);
 
 	if (use_browser == 0) {
 		if (verbose > 3)
-- 
1.8.1.4

