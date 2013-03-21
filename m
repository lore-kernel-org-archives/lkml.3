Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab3CULVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:21:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56459 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3CULVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:21:24 -0400
Date: Thu, 21 Mar 2013 04:19:42 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-c5a8368ca667d22a6e45396f23a5392d90396f39@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1362462812-30885-8-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-8-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Factor out struct source_line_percent
Git-Commit-ID: c5a8368ca667d22a6e45396f23a5392d90396f39
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:19:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5a8368ca667d22a6e45396f23a5392d90396f39
Gitweb:     http://git.kernel.org/tip/c5a8368ca667d22a6e45396f23a5392d90396f39
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 5 Mar 2013 14:53:27 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:06 -0300

perf annotate: Factor out struct source_line_percent

The source_line_percent struct contains percentage value of the symbol
histogram.  This is a preparation of event group view change.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362462812-30885-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |  2 +-
 tools/perf/util/annotate.c        | 14 +++++++-------
 tools/perf/util/annotate.h        |  8 ++++++--
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 6779847..cfae57f 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -257,7 +257,7 @@ static double disasm_line__calc_percent(struct disasm_line *dl, struct symbol *s
 		while (offset < (s64)len &&
 		       (next == NULL || offset < next->offset)) {
 			if (src_line) {
-				percent += src_line[offset].percent;
+				percent += src_line[offset].p[0].percent;
 			} else
 				hits += h->addr[offset];
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index f080cc4..ebf2596 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -616,7 +616,7 @@ static double disasm__calc_percent(struct annotation *notes, int evidx,
 			if (*path == NULL)
 				*path = src_line[offset].path;
 
-			percent += src_line[offset++].percent;
+			percent += src_line[offset++].p[0].percent;
 		}
 	} else {
 		while (offset < end)
@@ -929,7 +929,7 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 
 		ret = strcmp(iter->path, src_line->path);
 		if (ret == 0) {
-			iter->percent_sum += src_line->percent;
+			iter->p[0].percent_sum += src_line->p[0].percent;
 			return;
 		}
 
@@ -939,7 +939,7 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 			p = &(*p)->rb_right;
 	}
 
-	src_line->percent_sum = src_line->percent;
+	src_line->p[0].percent_sum = src_line->p[0].percent;
 
 	rb_link_node(&src_line->node, parent, p);
 	rb_insert_color(&src_line->node, root);
@@ -955,7 +955,7 @@ static void __resort_source_line(struct rb_root *root, struct source_line *src_l
 		parent = *p;
 		iter = rb_entry(parent, struct source_line, node);
 
-		if (src_line->percent_sum > iter->percent_sum)
+		if (src_line->p[0].percent_sum > iter->p[0].percent_sum)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -1025,8 +1025,8 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 		u64 offset;
 		FILE *fp;
 
-		src_line[i].percent = 100.0 * h->addr[i] / h->sum;
-		if (src_line[i].percent <= 0.5)
+		src_line[i].p[0].percent = 100.0 * h->addr[i] / h->sum;
+		if (src_line[i].p[0].percent <= 0.5)
 			continue;
 
 		offset = start + i;
@@ -1073,7 +1073,7 @@ static void print_summary(struct rb_root *root, const char *filename)
 		char *path;
 
 		src_line = rb_entry(node, struct source_line, node);
-		percent = src_line->percent_sum;
+		percent = src_line->p[0].percent_sum;
 		color = get_percent_color(percent);
 		path = src_line->path;
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 3763954..bb2e3f9 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -74,11 +74,15 @@ struct sym_hist {
 	u64		addr[0];
 };
 
-struct source_line {
-	struct rb_node	node;
+struct source_line_percent {
 	double		percent;
 	double		percent_sum;
+};
+
+struct source_line {
+	struct rb_node	node;
 	char		*path;
+	struct source_line_percent p[1];
 };
 
 /** struct annotated_source - symbols with hits have this attached as in sannotation
