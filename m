Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbbAIMbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:31:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60137 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbbAIMba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:31:30 -0500
Date: Fri, 9 Jan 2015 04:31:07 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-d114960c488b5a95705a04bba305f931cef0efd6@git.kernel.org>
Cc: hpa@zytor.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, acme@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, a.p.zijlstra@chello.nl, markus@trippelsdorf.de,
        tglx@linutronix.de, paulus@samba.org, mingo@kernel.org
Reply-To: namhyung@kernel.org, acme@redhat.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        markus@trippelsdorf.de, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        dsahern@gmail.com, paulus@samba.org, mingo@kernel.org
In-Reply-To: <20141230053813.GD6081@sejong>
References: <20141230053813.GD6081@sejong>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf callchain:
  Free callchains when hist entries are deleted
Git-Commit-ID: d114960c488b5a95705a04bba305f931cef0efd6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d114960c488b5a95705a04bba305f931cef0efd6
Gitweb:     http://git.kernel.org/tip/d114960c488b5a95705a04bba305f931cef0efd6
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 30 Dec 2014 14:38:13 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 8 Jan 2015 11:56:35 -0300

perf callchain: Free callchains when hist entries are deleted

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
index 64b377e..14e7a12 100644
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
index dbc08cf..c0ec1ac 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -198,4 +198,6 @@ static inline int arch_skip_callchain_idx(struct thread *thread __maybe_unused,
 char *callchain_list__sym_name(struct callchain_list *cl,
 			       char *bf, size_t bfsize, bool show_dso);
 
+void free_callchain(struct callchain_root *root);
+
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 0ced178..1823955 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -947,6 +947,7 @@ void hist_entry__free(struct hist_entry *he)
 	zfree(&he->mem_info);
 	zfree(&he->stat_acc);
 	free_srcline(he->srcline);
+	free_callchain(he->callchain);
 	free(he);
 }
 
