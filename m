Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3ALABQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 19:01:16 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:53964 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3ALABP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 19:01:15 -0500
Date: Fri, 11 Jan 2013 19:00:43 -0500
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: namhyung@kernel.org, acme@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch] perf: tui: Fix segfault when drawing out-of-bounds jumps
Message-ID: <20130112000043.GC32415@ks398093.ip-192-95-24.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When perf.data contains out-of-symbol jumps,
annotate_browser__mark_jump_targets() correctly avoids marking
out-of-symbol jump targets. However, when moving the cursor on one of
said jumps, annotate_browser__draw_current_jump() will end up with a
bogus 'target' pointer, causing a bogus memory access when dereferencing
'bcursor' or 'btarget'

The following patch performs the same check as mark_jump_targets()
in order to avoid drawing the bogus jump.

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 5dab3ca..8b84246 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -195,8 +195,9 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 	if (strstr(sym->name, "@plt"))
 		return;
 
-	if (!cursor || !cursor->ins || !ins__is_jump(cursor->ins) ||
-	    !disasm_line__has_offset(cursor))
+	if (!cursor || !cursor->ins || !ins__is_jump(cursor->ins)
+	    || !disasm_line__has_offset(cursor)
+	    || cursor->ops.target.offset >= symbol__size(sym))
 		return;
 
 	target = ab->offsets[cursor->ops.target.offset];
