Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaL3FhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 00:37:05 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62091 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaL3FhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 00:37:02 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Tue, 30 Dec 2014 14:38:13 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: "perf top -g" leaking ~300MB per second.
Message-ID: <20141230053813.GD6081@sejong>
References: <20141213084845.GA13453@x4>
 <20141213090331.GB13453@x4>
 <20141213152635.GG9845@kernel.org>
 <548C828B.4040309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <548C828B.4040309@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David and Markus,

On Sat, Dec 13, 2014 at 11:16:43AM -0700, David Ahern wrote:
> On 12/13/14 8:26 AM, Arnaldo Carvalho de Melo wrote:
> >The callchain code was done initially for 'report' and when I made 'top'
> >reuse the hist_entry code allowing 'top' to collect callchains was too
> >easy, but then we need to go thru the callchain/hists/hist_entry code to
> >make sure that they don't leak, will try to do it...
> >
> 
> As I recall it is build up of the dead_threads list.

Maybe.  But I guess it's because of leak of callchains..

Markus, could you please test below patch how much it affects?


>From b29ccd79727654653986ab1170e0b1f5d6518035 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 30 Dec 2014 14:28:45 +0900
Subject: [PATCH] perf callchain: Free callchains when hist entries are deleted

Markus reported that "perf top -g" can leak ~300MB per second on his
machine.  This is partly because it missed to free callchains when
hist entries are deleted.  Fix it.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
index 30ff2cb92884..e17163fcb702 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -945,6 +945,7 @@ void hist_entry__delete(struct hist_entry *he)
 	zfree(&he->mem_info);
 	zfree(&he->stat_acc);
 	free_srcline(he->srcline);
+	free_callchain(he->callchain);
 	free(he);
 }
 
-- 
2.1.3

