Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaB1Rn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:43:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbaB1Rny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:43:54 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 17/19] perf, c2c: Dump rbtree for debugging
Date: Fri, 28 Feb 2014 12:43:06 -0500
Message-Id: <1393609388-40489-18-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes you want to verify the rbtree sorting on a unique id
is working correctly.  This allows you to dump it.

Sample output:

   Idx Hit Maj Min      Ino           InoGen    Pid            Daddr            Iaddr         Data Src                         (string)  cpumode
     0       0   0        0                0      0               22 ffffffff813044cf         48080184           [STORE,L1,MISS,SNP NA]        1

     1       0   0        0                0   2332              ca3 ffffffffa0226032         48080184           [STORE,L1,MISS,SNP NA]        1
     2       0   0        0                0   2332              ca3 ffffffffa0226032         48080184           [STORE,L1,MISS,SNP NA]        1
     3       0   0        0                0   2332              ca3 ffffffffa0226032         48080184           [STORE,L1,MISS,SNP NA]        1
     4       0   0        0                0   2332              ca3 ffffffffa0226032         48080184           [STORE,L1,MISS,SNP NA]        1
     5       0   0        0                0   2332              ca3 ffffffffa0226032         48080184           [STORE,L1,MISS,SNP NA]        1
     6       0   0        0                0   2332              ca3 ffffffffa0226032         48080184           [STORE,L1,MISS,SNP NA]        1

     7       0   0        0                0  18179          135f860 ffffffff812ad509         68100242          [LOAD,LFB,HIT,SNP NONE]        1

     8       0   0        0                0  18179     7ff9d7fbaf98 ffffffff812ad509         68100242          [LOAD,LFB,HIT,SNP NONE]        1

V2: refresh with hist_entry

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 3b0e0b2..c095f1b 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -616,6 +616,55 @@ err:
 
 #define HAS_HITMS(h) (h->stats.t.lcl_hitm || h->stats.t.rmt_hitm)
 
+static void dump_rb_tree(struct rb_root *tree,
+			 struct perf_c2c *c2c __maybe_unused)
+{
+	struct rb_node *next = rb_first(tree);
+	struct hist_entry *he;
+	u64 cl = 0;
+	int idx = 0;
+
+	printf("# Summary: Total entries - %d\n", c2c->stats.nr_entries);
+	printf("# HITMs: Local - %d   Remote - %d     Total - %d\n",
+		c2c->stats.t.lcl_hitm, c2c->stats.t.rmt_hitm,
+		(c2c->stats.t.lcl_hitm + c2c->stats.t.rmt_hitm));
+
+	printf("%6s %3s %3s %3s %8s %16s %6s %16s %16s %16s %32s %8s\n",
+		"Idx", "Hit", "Maj", "Min", "Ino", "InoGen", "Pid", 
+		"Daddr", "Iaddr", "Data Src", "(string)", "cpumode");
+	while (next) {
+		char data_src[32];
+		u64 val;
+
+		he = rb_entry(next, struct hist_entry, rb_node_in);
+		next = rb_next(&he->rb_node_in);
+
+		if ((!he->color) || (cl != CLADRS(he->mem_info->daddr.al_addr))) {
+			printf("\n");
+			cl = CLADRS(he->mem_info->daddr.al_addr);
+		}
+
+		val = he->mem_info->data_src.val;
+		perf_c2c__scnprintf_data_src(data_src, sizeof(data_src), val);
+
+		printf("%6d %3s %3x %3x %8lx %16lx %6d %16lx %16lx %16lx %32s %8x\n",
+			idx,
+			(PERF_MEM_S(SNOOP,HITM) & val) ? " * " : "   ",
+			he->mem_info->daddr.map->maj,
+			he->mem_info->daddr.map->min,
+			he->mem_info->daddr.map->ino,
+			he->mem_info->daddr.map->ino_generation,
+			he->thread->pid_,
+			he->mem_info->daddr.addr,
+			he->mem_info->iaddr.addr,
+			val,
+			data_src,
+			he->cpumode);
+
+		idx++;
+	}
+}
+
 static void c2c_hit__update_stats(struct c2c_stats *new,
 				  struct c2c_stats *old)
 {
@@ -1213,6 +1262,8 @@ static int perf_c2c__process_events(struct perf_session *session,
 		goto err;
 	}
 
+	if (verbose > 2)
+		dump_rb_tree(c2c->hists.entries_in, c2c);
 	print_c2c_trace_report(c2c);
 	c2c_analyze_hitms(c2c);
 
-- 
1.7.11.7

