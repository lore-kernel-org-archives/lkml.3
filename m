Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab3BOQij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:38:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35938 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab3BOQih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:38:37 -0500
Date: Fri, 15 Feb 2013 08:36:58 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-18c9e5c567e1bc475edc67dca3680ecd2562dc5c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        bp@alien8.de, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, bp@alien8.de, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1360227734-375-8-git-send-email-namhyung@kernel.org>
References: <1360227734-375-8-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Make it to be able to skip unannotatable symbols
Git-Commit-ID: 18c9e5c567e1bc475edc67dca3680ecd2562dc5c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 15 Feb 2013 08:37:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18c9e5c567e1bc475edc67dca3680ecd2562dc5c
Gitweb:     http://git.kernel.org/tip/18c9e5c567e1bc475edc67dca3680ecd2562dc5c
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 7 Feb 2013 18:02:14 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Feb 2013 14:59:28 -0300

perf annotate: Make it to be able to skip unannotatable symbols

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
