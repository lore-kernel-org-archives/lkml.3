Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030253Ab3BNVos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 16:44:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57471 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934995Ab3BNVoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 16:44:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/10] perf annotate: Make it to be able to skip unannotatable symbols
Date: Thu, 14 Feb 2013 18:44:20 -0300
Message-Id: <1360878263-12694-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1360878263-12694-1-git-send-email-acme@infradead.org>
References: <1360878263-12694-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add --skip-missing option for skipping symbols that cannot be used for
annotation.  It's the case of kernel symbols that user doesn't have a
vmlinux image file.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1360227734-375-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-annotate.txt |  3 +++
 tools/perf/builtin-annotate.c              | 17 +++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index e5e1d06..5ad07ef 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -90,6 +90,9 @@ OPTIONS
 --objdump=<path>::
         Path to objdump binary.
 
+--skip-missing::
+	Skip symbols that cannot be annotated.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 68e3a16..2e6961e 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -37,6 +37,7 @@ struct perf_annotate {
 	bool	   force, use_tui, use_stdio, use_gtk;
 	bool	   full_paths;
 	bool	   print_line;
+	bool	   skip_missing;
 	const char *sym_hist_filter;
 	const char *cpu_list;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
@@ -139,11 +140,21 @@ find_next:
 		}
 
 		if (use_browser == 2) {
-			hist_entry__gtk_annotate(he, evidx, NULL);
-			return;
+			int ret;
+
+			ret = hist_entry__gtk_annotate(he, evidx, NULL);
+			if (!ret || !ann->skip_missing)
+				return;
+
+			/* skip missing symbols */
+			nd = rb_next(nd);
 		} else if (use_browser == 1) {
 			key = hist_entry__tui_annotate(he, evidx, NULL);
 			switch (key) {
+			case -1:
+				if (!ann->skip_missing)
+					return;
+				/* fall through */
 			case K_RIGHT:
 				next = rb_next(nd);
 				break;
@@ -288,6 +299,8 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "print matching source lines (may be slow)"),
 	OPT_BOOLEAN('P', "full-paths", &annotate.full_paths,
 		    "Don't shorten the displayed pathnames"),
+	OPT_BOOLEAN(0, "skip-missing", &annotate.skip_missing,
+		    "Skip symbols that cannot be annotated"),
 	OPT_STRING('C', "cpu", &annotate.cpu_list, "cpu", "list of cpus to profile"),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		   "Look for files with symbols relative to this directory"),
-- 
1.8.1.1.361.gec3ae6e

