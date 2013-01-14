Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab3ANTrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 14:47:53 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:37894 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab3ANTrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 14:47:52 -0500
Date: Mon, 14 Jan 2013 14:47:17 -0500
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] perf: tui: Fix segfault when drawing out-of-bounds jumps
Message-ID: <20130114194716.GA4973@ks398093.ip-192-95-24.net>
References: <20130112000043.GC32415@ks398093.ip-192-95-24.net>
 <20130114134416.GA8768@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130114134416.GA8768@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:44:16AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jan 11, 2013 at 07:00:43PM -0500, Frederik Deweerdt escreveu:
> > Hi,
> > 
> > When perf.data contains out-of-symbol jumps,
> > annotate_browser__mark_jump_targets() correctly avoids marking
> > out-of-symbol jump targets. However, when moving the cursor on one of
> > said jumps, annotate_browser__draw_current_jump() will end up with a
> > bogus 'target' pointer, causing a bogus memory access when dereferencing
> > 'bcursor' or 'btarget'
> > 
> > The following patch performs the same check as mark_jump_targets()
> > in order to avoid drawing the bogus jump.
> 
> Thanks, I'll apply this one later today and introduce a
> disasm_line__is_valid_jump(cursor) routine to be used in both mark and
> draw routines, if you don't do it first :-)

I thought of that, but the code currently displays an error message in
the mark_jump_targets() case:

		if (dl->ops.target.offset >= size) {
			ui__error("jump to after symbol!\n"
				  "size: %zx, jump target: %" PRIx64,
				  size, dl->ops.target.offset);
			continue;
		}

That said, the message is kind of useless and annoying (happens well
over a dozen of times) in the case I hit it (annotate __strstr_sse42).

How about the following:

Factorize jump sanity checks from mark_jump_targets() and
draw_current_jump() in an is_valid_jump() function.

This fixes a segfaut when moving the cursor over an invalid jump.

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 5dab3ca..43ae4f6 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -182,6 +182,16 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 		ab->selection = dl;
 }
 
+static bool annotate_browser__is_valid_jump(struct symbol *sym, struct disasm_line *dl)
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
+	if (!annotate_browser__is_valid_jump(sym, cursor))
 		return;
 
 	target = ab->offsets[cursor->ops.target.offset];
@@ -788,17 +797,9 @@ static void annotate_browser__mark_jump_targets(struct annotate_browser *browser
 		struct disasm_line *dl = browser->offsets[offset], *dlt;
 		struct browser_disasm_line *bdlt;
 
-		if (!dl || !dl->ins || !ins__is_jump(dl->ins) ||
-		    !disasm_line__has_offset(dl))
+		if (!annotate_browser__is_valid_jump(sym, dl))
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
