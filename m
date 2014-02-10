Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaBJRbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:31:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbaBJRa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:30:58 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 15/21] perf, c2c: Dump rbtree for debugging
Date: Mon, 10 Feb 2014 12:29:10 -0500
Message-Id: <1392053356-23024-16-git-send-email-dzickus@redhat.com>
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes you want to verify the rbtree sorting on a unique id
is working correctly.  This allows you to dump it.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index c8e76dc..0760f6a 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -900,6 +900,34 @@ err:
 
 #define HAS_HITMS(h) (h->stats.t.lcl_hitm || h->stats.t.rmt_hitm)
 
+static void dump_rb_tree(struct rb_root *tree,
+			 struct perf_c2c *c2c __maybe_unused)
+{
+	struct rb_node *next = rb_first(tree);
+	struct c2c_entry *n;
+
+	printf("%3s %3s %8s %8s %6s %16s %16s %16s %16s %16s %8s\n",
+		"Maj", "Min", "Ino", "InoGen", "Pid", "Start",
+		"Vaddr", "al_addr", "ip addr", "pgoff", "cpumode");
+	while (next) {
+		n = rb_entry(next, struct c2c_entry, rb_node);
+		next = rb_next(&n->rb_node);
+
+		printf("%3x %3x %8lx %8lx %6d %16lx %16lx %16lx %16lx %16lx %8x\n",
+			n->mi->daddr.map->maj,
+			n->mi->daddr.map->min,
+			n->mi->daddr.map->ino,
+			n->mi->daddr.map->ino_generation,
+			n->thread->pid_,
+			n->mi->daddr.map->start,
+			n->mi->daddr.addr,
+			n->mi->daddr.al_addr,
+			n->mi->iaddr.al_addr,
+			n->mi->daddr.map->pgoff,
+			n->cpumode);
+	}
+}
+
 static void c2c_hit__update_stats(struct c2c_stats *new,
 				  struct c2c_stats *old)
 {
@@ -1494,6 +1522,8 @@ static int perf_c2c__process_events(struct perf_session *session,
 		goto err;
 	}
 
+	if (verbose > 2)
+		dump_rb_tree(&c2c->tree_physid, c2c);
 	print_c2c_trace_report(c2c);
 	c2c_analyze_hitms(c2c);
 
-- 
1.7.11.7

