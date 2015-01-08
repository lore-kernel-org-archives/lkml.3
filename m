Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbbAHPhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:37:11 -0500
Received: from mail.kernel.org ([198.145.29.136]:48867 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464AbbAHPhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:37:06 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf callchain: Free callchains when hist entries are deleted
Date: Thu,  8 Jan 2015 12:36:47 -0300
Message-Id: <1420731408-8631-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420731408-8631-1-git-send-email-acme@kernel.org>
References: <1420731408-8631-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Markus reported that "perf top -g" can leak ~300MB per second on his
machine.  This is partly because it missed to free callchains when hist
entries are deleted.  Fix it.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20141230053813.GD6081@sejong
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/callchain.c | 30 ++++++++++++++++++++++++++++++
 tools/perf/util/callchain.h |  2 ++
 tools/perf/util/hist.c      |  1 +
 3 files changed, 33 insertions(+)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 64b377e591e4..14e7a123d43b 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -841,3 +841,33 @@ char *callchain_list__sym_name(struct callchain_list *cl,
 
 	return bf;
 }
+
+static void free_callchain_node(struct callchain_node *node)
+{
+	struct callchain_list *list, *tmp;
+	struct callchain_node *child;
+	struct rb_node *n;
+
+	list_for_each_entry_safe(list, tmp, &node->val, list) {
+		list_del(&list->list);
+		free(list);
+	}
+
+	n = rb_first(&node->rb_root_in);
+	while (n) {
+		child = container_of(n, struct callchain_node, rb_node_in);
+		n = rb_next(n);
+		rb_erase(&child->rb_node_in, &node->rb_root_in);
+
+		free_callchain_node(child);
+		free(child);
+	}
+}
+
+void free_callchain(struct callchain_root *root)
+{
+	if (!symbol_conf.use_callchain)
+		return;
+
+	free_callchain_node(&root->node);
+}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index dbc08cf5f970..c0ec1acc38e4 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -198,4 +198,6 @@ static inline int arch_skip_callchain_idx(struct thread *thread __maybe_unused,
 char *callchain_list__sym_name(struct callchain_list *cl,
 			       char *bf, size_t bfsize, bool show_dso);
 
+void free_callchain(struct callchain_root *root);
+
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 0ced178ce306..182395546ddc 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -947,6 +947,7 @@ void hist_entry__free(struct hist_entry *he)
 	zfree(&he->mem_info);
 	zfree(&he->stat_acc);
 	free_srcline(he->srcline);
+	free_callchain(he->callchain);
 	free(he);
 }
 
-- 
1.9.3

