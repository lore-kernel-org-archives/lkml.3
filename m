Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaB1Rq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:46:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbaB1Rnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:43:49 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 18/19] perf, c2c: Add symbol count table
Date: Fri, 28 Feb 2014 12:43:07 -0500
Message-Id: <1393609388-40489-19-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just another table that displays the referenced symbols in the analysis
report.  The table lists the most frequently used symbols first.

It is just another way to look at similar data to figure out who
is causing the most contention (based on the workload used).

Original done by Dick Fowles, backported by me.

Sample output:

=======================================================================================================
                                                   Object Name, Path & Reference Counts

Index    Records   Object Name                       Object Path
=======================================================================================================
    0     931379   [kernel.kallsyms]                 [kernel.kallsyms]
    1     192258   fio                               /home/joe/old_fio-2.0.15/fio
    2      80302   [jbd2]                            /lib/modules/3.10.0c2c_all+/kernel/fs/jbd2/jbd2.ko
    3      65392   [ext4]                            /lib/modules/3.10.0c2c_all+/kernel/fs/ext4/ext4.ko

V2: refresh to latest upstream changes and hist_entry

Original-by: Dick Fowles <rfowles@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index c095f1b..0749ea6 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -685,6 +685,104 @@ static void c2c_hit__update_stats(struct c2c_stats *new,
 	new->total_period	+= old->total_period;
 }
 
+LIST_HEAD(ref_tree);
+LIST_HEAD(ref_tree_sorted);
+struct refs {
+	struct list_head	list;
+	int			nr;
+	const char		*name;
+	const char		*long_name;
+};
+
+static int update_ref_list(struct hist_entry *entry)
+{
+	struct refs *p;
+	struct dso *dso = entry->mem_info->iaddr.map->dso;
+	const char *name = dso->short_name;
+
+	list_for_each_entry(p, &ref_tree, list) {
+		if (!strcmp(p->name, name))
+			goto found;
+	}
+
+	p = zalloc(sizeof(struct refs));
+	if (!p)
+		return -1;
+	p->name = name;
+	p->long_name = dso->long_name;
+	list_add_tail(&p->list, &ref_tree);
+
+found:
+	p->nr++;
+	return 0;
+}
+
+static void print_symbol_record_count(struct rb_root *tree)
+{
+	struct rb_node *next = rb_first(tree);
+	struct hist_entry *he;
+	struct refs *p, *q, *pn;
+	char      string[256];
+	char      delimit[256];
+	int       i;
+	int       idx = 0;
+
+	/* gather symbol references */
+	while (next) {
+		he = rb_entry(next, struct hist_entry, rb_node_in);
+		next = rb_next(&he->rb_node_in);
+
+		if (update_ref_list(he)) {
+			pr_err("Could not update reference tree\n");
+			goto cleanup;
+		}
+	}
+
+	/* sort on number of references per symbol */
+	list_for_each_entry_safe(p, pn, &ref_tree, list) {
+		list_del_init(&p->list);
+		list_for_each_entry(q, &ref_tree_sorted, list) {
+			if (p->nr > q->nr) {
+				list_add_tail(&p->list, &q->list);
+				break;
+			}
+		}
+		if (list_empty(&p->list))
+			list_add_tail(&p->list, &ref_tree_sorted);
+	}
+
+	/* print header info */
+	sprintf(string, "%5s   %8s   %-32s  %-80s",
+		"Index",
+		"Records",
+		"Object Name",
+		"Object Path");
+
+	delimit[0] = '\0';
+	for (i = 0; i < (int)strlen(string); i++) strcat(delimit, "=");
+
+	printf("\n\n");
+	printf("%s\n", delimit);
+	printf("%50s %s\n", " ", "Object Name, Path & Reference Counts");
+	printf("\n");
+	printf("%s\n", string);
+	printf("%s\n", delimit);
+
+	/* print out table */
+	list_for_each_entry(p, &ref_tree_sorted, list) {
+		printf("%5d   %8d   %-32s  %-80s\n",
+			idx, p->nr, p->name, p->long_name);
+		idx++;
+	}
+	printf("\n");
+
+cleanup:
+	list_for_each_entry_safe(p, pn, &ref_tree_sorted, list) {
+		list_del(&p->list);
+		free(p);
+	}
+}
+
 static void print_hitm_cacheline_header(void)
 {
 #define SHARING_REPORT_TITLE  "Shared Cache Line Distribution Pareto"
@@ -1266,6 +1364,7 @@ static int perf_c2c__process_events(struct perf_session *session,
 		dump_rb_tree(c2c->hists.entries_in, c2c);
 	print_c2c_trace_report(c2c);
 	c2c_analyze_hitms(c2c);
+	print_symbol_record_count(c2c->hists.entries_in);
 
 err:
 	return err;
-- 
1.7.11.7

