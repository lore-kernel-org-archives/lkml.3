Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3AXUiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:38:18 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53993
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755773Ab3AXUIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Frederik Deweerdt <frederik.deweerdt@xprog.eu>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 53/74] perf annotate browser: Fix segfault when drawing out-of-bounds jumps
Date: Thu, 24 Jan 2013 17:08:02 -0300
Message-Id: <1359058103-31645-54-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>

Factorize jump sanity checks from mark_jump_targets() and
draw_current_jump() in an is_valid_jump() function.

This fixes a segfault when moving the cursor over an invalid jump.

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20130114194716.GA4973@ks398093.ip-192-95-24.net
[ committer note: Make it a disasm_line method ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 5dab3ca..2fc7f04 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -182,6 +182,16 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 		ab->selection = dl;
 }
 
+static bool disasm_line__is_valid_jump(struct disasm_line *dl, struct symbol *sym)
+{
+	if (!dl || !dl->ins || !ins__is_jump(dl->ins)
+	    || !disasm_line__has_offset(dl)
+	    || dl->ops.target.offset >= symbol__size(sym))
+		return false;
+
+	return true;
+}
+
 static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 {
 	struct annotate_browser *ab = container_of(browser, struct annotate_browser, b);
@@ -195,8 +205,7 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 	if (strstr(sym->name, "@plt"))
 		return;
 
-	if (!cursor || !cursor->ins || !ins__is_jump(cursor->ins) ||
-	    !disasm_line__has_offset(cursor))
+	if (!disasm_line__is_valid_jump(cursor, sym))
 		return;
 
 	target = ab->offsets[cursor->ops.target.offset];
@@ -788,17 +797,9 @@ static void annotate_browser__mark_jump_targets(struct annotate_browser *browser
 		struct disasm_line *dl = browser->offsets[offset], *dlt;
 		struct browser_disasm_line *bdlt;
 
-		if (!dl || !dl->ins || !ins__is_jump(dl->ins) ||
-		    !disasm_line__has_offset(dl))
+		if (!disasm_line__is_valid_jump(dl, sym))
 			continue;
 
-		if (dl->ops.target.offset >= size) {
-			ui__error("jump to after symbol!\n"
-				  "size: %zx, jump target: %" PRIx64,
-				  size, dl->ops.target.offset);
-			continue;
-		}
-
 		dlt = browser->offsets[dl->ops.target.offset];
 		/*
  		 * FIXME: Oops, no jump target? Buggy disassembler? Or do we
@@ -921,7 +922,7 @@ out_free_offsets:
 
 #define ANNOTATE_CFG(n) \
 	{ .name = #n, .value = &annotate_browser__opts.n, }
-	
+
 /*
  * Keep the entries sorted, they are bsearch'ed
  */
-- 
1.8.1.1.361.gec3ae6e

