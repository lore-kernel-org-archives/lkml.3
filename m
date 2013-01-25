Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab3AYLu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:50:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42036 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab3AYLuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:50:54 -0500
Date: Fri, 25 Jan 2013 03:50:35 -0800
From: tip-bot for Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Message-ID: <tip-865c66c4183aab1d12522ca3ad3a3339d2437e5c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, frederik.deweerdt@xprog.eu,
        hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, frederik.deweerdt@xprog.eu,
        linux-kernel@vger.kernel.org, acme@redhat.com, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <20130114194716.GA4973@ks398093.ip-192-95-24.net>
References: <20130114194716.GA4973@ks398093.ip-192-95-24.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser:
  Fix segfault when drawing out-of-bounds jumps
Git-Commit-ID: 865c66c4183aab1d12522ca3ad3a3339d2437e5c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:50:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  865c66c4183aab1d12522ca3ad3a3339d2437e5c
Gitweb:     http://git.kernel.org/tip/865c66c4183aab1d12522ca3ad3a3339d2437e5c
Author:     Frederik Deweerdt <frederik.deweerdt@xprog.eu>
AuthorDate: Mon, 14 Jan 2013 14:47:17 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:36 -0300

perf annotate browser: Fix segfault when drawing out-of-bounds jumps

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
