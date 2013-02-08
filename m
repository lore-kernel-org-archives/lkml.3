Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009Ab3BHHJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:09:08 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60396 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759945Ab3BHHJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:09:06 -0500
X-AuditID: 9c93016f-b7b1fae000006419-25-5114a48f9a58
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 7/7] perf annotate: Make it to be able to skip unannotatable symbols
References: <1360227734-375-1-git-send-email-namhyung@kernel.org>
	<1360227734-375-8-git-send-email-namhyung@kernel.org>
	<20130205011247.GG19155@ghostprotocols.net>
Date: Fri, 08 Feb 2013 16:09:03 +0900
In-Reply-To: <20130205011247.GG19155@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Mon, 4 Feb 2013 22:12:47 -0300")
Message-ID: <87y5ezqo34.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Mon, 4 Feb 2013 22:12:47 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Feb 07, 2013 at 06:02:14PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Add --skip-missing option for skipping symbols that cannot be used for
>> annotation.  It's the case of kernel symbols that user doesn't have a
>> vmlinux image file.
>> 
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/builtin-annotate.c | 17 +++++++++++++++--
>
> You forgot to add the entry in the man page...

Arghh... resending..


---------------------8<-----------------------
>From 797a62666d6098aaeda816279fa9181473762dc6 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung.kim@lge.com>
Date: Thu, 7 Feb 2013 17:37:03 +0900
Subject: [PATCH v2 7/7] perf annotate: Make it to be able to skip unannotatable
 symbols

Add --skip-missing option for skipping symbols that cannot be used for
annotation.  It's the case of kernel symbols that user doesn't have a
vmlinux image file.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-annotate.txt |  3 +++
 tools/perf/builtin-annotate.c              | 17 +++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index e5e1d06efc37..5ad07ef417f0 100644
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

