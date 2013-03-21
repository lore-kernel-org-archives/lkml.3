Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab3CULXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:23:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56490 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab3CULXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:23:35 -0400
Date: Thu, 21 Mar 2013 04:22:01 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-ab77df672cdbf7a0235a9de3289c173e2fce68e5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1362462812-30885-10-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-10-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: Make browser_disasm_line->
 percent an array
Git-Commit-ID: ab77df672cdbf7a0235a9de3289c173e2fce68e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:22:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab77df672cdbf7a0235a9de3289c173e2fce68e5
Gitweb:     http://git.kernel.org/tip/ab77df672cdbf7a0235a9de3289c173e2fce68e5
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 5 Mar 2013 14:53:29 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:06 -0300

perf annotate browser: Make browser_disasm_line->percent an array

Make percent field of struct browser_disasm_line an array and move it to
the last.  This is a preparation of event group view feature.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362462812-30885-10-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index cfae57f..62369f0 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -14,10 +14,10 @@
 
 struct browser_disasm_line {
 	struct rb_node	rb_node;
-	double		percent;
 	u32		idx;
 	int		idx_asm;
 	int		jump_sources;
+	double		percent[1];
 };
 
 static struct annotate_browser_opt {
@@ -97,9 +97,9 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 	int width = browser->width, printed;
 	char bf[256];
 
-	if (dl->offset != -1 && bdl->percent != 0.0) {
-		ui_browser__set_percent_color(browser, bdl->percent, current_entry);
-		slsmg_printf("%6.2f ", bdl->percent);
+	if (dl->offset != -1 && bdl->percent[0] != 0.0) {
+		ui_browser__set_percent_color(browser, bdl->percent[0], current_entry);
+		slsmg_printf("%6.2f ", bdl->percent[0]);
 	} else {
 		ui_browser__set_percent_color(browser, 0, current_entry);
 		slsmg_write_nstring(" ", 7);
@@ -283,7 +283,7 @@ static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_l
 	while (*p != NULL) {
 		parent = *p;
 		l = rb_entry(parent, struct browser_disasm_line, rb_node);
-		if (bdl->percent < l->percent)
+		if (bdl->percent[0] < l->percent[0])
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -345,8 +345,8 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		struct browser_disasm_line *bpos = disasm_line__browser(pos);
-		bpos->percent = disasm_line__calc_percent(pos, sym, evsel->idx);
-		if (bpos->percent < 0.01) {
+		bpos->percent[0] = disasm_line__calc_percent(pos, sym, evsel->idx);
+		if (bpos->percent[0] < 0.01) {
 			RB_CLEAR_NODE(&bpos->rb_node);
 			continue;
 		}
