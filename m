Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbaIPAUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:20:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:10904 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760671AbaIPAUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:20:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,531,1406617200"; 
   d="scan'208";a="600070664"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/8] perf, tools: Support source line numbers in annotate
Date: Mon, 15 Sep 2014 16:54:30 -0700
Message-Id: <1410825273-7054-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410825273-7054-1-git-send-email-andi@firstfloor.org>
References: <1410825273-7054-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

With srcline key/sort'ing it's useful to have line numbers
in the annotate window. This patch implements this.

Use objdump -l to request the line numbers and
save them in the line structure. Then the browser
displays them for source lines.

The line numbers are not displayed by default, but can be
toggled on with 'k'

There is one unfortunate problem with this setup. For
lines not containing source and which are outside functions
objdump -l reports line numbers off by a few: it always reports
the first line number in the next function even for lines
that are outside the function.
I haven't found a nice way to detect/correct this. Probably objdump
has to be fixed.
See https://sourceware.org/bugzilla/show_bug.cgi?id=16433

The line numbers are still useful even with these problems,
as most are correct and the ones which are not are nearby.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/ui/browsers/annotate.c | 13 ++++++++++++-
 tools/perf/util/annotate.c        | 30 +++++++++++++++++++++++++-----
 tools/perf/util/annotate.h        |  1 +
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index f0697a3..8df6787 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -27,6 +27,7 @@ static struct annotate_browser_opt {
 	bool hide_src_code,
 	     use_offset,
 	     jump_arrows,
+	     show_linenr,
 	     show_nr_jumps;
 } annotate_browser__opts = {
 	.use_offset	= true,
@@ -128,7 +129,11 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 	if (!*dl->line)
 		slsmg_write_nstring(" ", width - pcnt_width);
 	else if (dl->offset == -1) {
-		printed = scnprintf(bf, sizeof(bf), "%*s  ",
+		if (dl->line_nr && annotate_browser__opts.show_linenr)
+			printed = scnprintf(bf, sizeof(bf), "%*s %-5d ",
+					ab->addr_width, " ", dl->line_nr);
+		else
+			printed = scnprintf(bf, sizeof(bf), "%*s  ",
 				    ab->addr_width, " ");
 		slsmg_write_nstring(bf, printed);
 		slsmg_write_nstring(dl->line, width - printed - pcnt_width + 1);
@@ -733,6 +738,7 @@ static int annotate_browser__run(struct annotate_browser *browser,
 		"o             Toggle disassembler output/simplified view\n"
 		"s             Toggle source code view\n"
 		"/             Search string\n"
+		"k	       Toggle line numbers\n"
 		"r             Run available scripts\n"
 		"?             Search string backwards\n");
 			continue;
@@ -741,6 +747,10 @@ static int annotate_browser__run(struct annotate_browser *browser,
 				script_browse(NULL);
 				continue;
 			}
+		case 'k':
+			annotate_browser__opts.show_linenr =
+				!annotate_browser__opts.show_linenr;
+			break;
 		case 'H':
 			nd = browser->curr_hot;
 			break;
@@ -984,6 +994,7 @@ static struct annotate_config {
 } annotate__configs[] = {
 	ANNOTATE_CFG(hide_src_code),
 	ANNOTATE_CFG(jump_arrows),
+	ANNOTATE_CFG(show_linenr),
 	ANNOTATE_CFG(show_nr_jumps),
 	ANNOTATE_CFG(use_offset),
 };
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 3643752..f49f9a5 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -17,11 +17,13 @@
 #include "debug.h"
 #include "annotate.h"
 #include "evsel.h"
+#include <regex.h>
 #include <pthread.h>
 #include <linux/bitops.h>
 
 const char 	*disassembler_style;
 const char	*objdump_path;
+static regex_t	 file_lineno;
 
 static struct ins *ins__find(const char *name);
 static int disasm_line__parse(char *line, char **namep, char **rawp);
@@ -570,13 +572,15 @@ out_free_name:
 	return -1;
 }
 
-static struct disasm_line *disasm_line__new(s64 offset, char *line, size_t privsize)
+static struct disasm_line *disasm_line__new(s64 offset, char *line,
+					size_t privsize, int line_nr)
 {
 	struct disasm_line *dl = zalloc(sizeof(*dl) + privsize);
 
 	if (dl != NULL) {
 		dl->offset = offset;
 		dl->line = strdup(line);
+		dl->line_nr = line_nr;
 		if (dl->line == NULL)
 			goto out_delete;
 
@@ -788,13 +792,15 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
  * The ops.raw part will be parsed further according to type of the instruction.
  */
 static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
-				      FILE *file, size_t privsize)
+				      FILE *file, size_t privsize,
+				      int *line_nr)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	struct disasm_line *dl;
 	char *line = NULL, *parsed_line, *tmp, *tmp2, *c;
 	size_t line_len;
 	s64 line_ip, offset = -1;
+	regmatch_t match[2];
 
 	if (getline(&line, &line_len, file) < 0)
 		return -1;
@@ -812,6 +818,12 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 	line_ip = -1;
 	parsed_line = line;
 
+	/* /filename:linenr ? Save line number and ignore. */
+	if (regexec(&file_lineno, line, 2, match, 0) == 0) {
+		*line_nr = atoi(line + match[1].rm_so);
+		return 0;
+	}
+
 	/*
 	 * Strip leading spaces:
 	 */
@@ -842,8 +854,9 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 			parsed_line = tmp2 + 1;
 	}
 
-	dl = disasm_line__new(offset, parsed_line, privsize);
+	dl = disasm_line__new(offset, parsed_line, privsize, *line_nr);
 	free(line);
+	(*line_nr)++;
 
 	if (dl == NULL)
 		return -1;
@@ -869,6 +882,11 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 	return 0;
 }
 
+static __attribute__((constructor)) void symbol__init_regexpr(void)
+{
+	regcomp(&file_lineno, "^/[^:]+:([0-9]+)$", REG_EXTENDED);
+}
+
 static void delete_last_nop(struct symbol *sym)
 {
 	struct annotation *notes = symbol__annotation(sym);
@@ -904,6 +922,7 @@ int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
 	char symfs_filename[PATH_MAX];
 	struct kcore_extract kce;
 	bool delete_extract = false;
+	int lineno = 0;
 
 	if (filename)
 		symbol__join_symfs(symfs_filename, filename);
@@ -982,7 +1001,7 @@ fallback:
 	snprintf(command, sizeof(command),
 		 "%s %s%s --start-address=0x%016" PRIx64
 		 " --stop-address=0x%016" PRIx64
-		 " -d %s %s -C %s 2>/dev/null|grep -v %s|expand",
+		 " -l -d %s %s -C %s 2>/dev/null|grep -v %s|expand",
 		 objdump_path ? objdump_path : "objdump",
 		 disassembler_style ? "-M " : "",
 		 disassembler_style ? disassembler_style : "",
@@ -999,7 +1018,8 @@ fallback:
 		goto out_free_filename;
 
 	while (!feof(file))
-		if (symbol__parse_objdump_line(sym, map, file, privsize) < 0)
+		if (symbol__parse_objdump_line(sym, map, file, privsize,
+			    &lineno) < 0)
 			break;
 
 	/*
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 112d6e2..0784a94 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -58,6 +58,7 @@ struct disasm_line {
 	char		    *line;
 	char		    *name;
 	struct ins	    *ins;
+	int		    line_nr;
 	struct ins_operands ops;
 };
 
-- 
1.9.3

