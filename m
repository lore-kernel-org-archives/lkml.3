Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab3BGJCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 04:02:53 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45999 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab3BGJCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 04:02:43 -0500
X-AuditID: 9c930179-b7c24ae00000119c-29-51136da9da8b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 7/7] perf annotate: Make it to be able to skip unannotatable symbols
Date: Thu,  7 Feb 2013 18:02:14 +0900
Message-Id: <1360227734-375-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1360227734-375-1-git-send-email-namhyung@kernel.org>
References: <1360227734-375-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add --skip-missing option for skipping symbols that cannot be used for
annotation.  It's the case of kernel symbols that user doesn't have a
vmlinux image file.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 68e3a16abd3d..2e6961ea3184 100644
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
1.7.11.7

