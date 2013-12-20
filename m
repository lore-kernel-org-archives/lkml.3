Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab3LTTKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38566 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab3LTTJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/35] perf sort: Compare addresses if no symbol info
Date: Fri, 20 Dec 2013 16:08:36 -0300
Message-Id: <1387566550-3524-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If a hist entry doesn't have symbol information, compare it with its
address.  Currently it only compares its level or whether it's NULL.

This can lead to an undesired result like an overhead exceeds 100%
especially when callchain accumulation is enabled by later patch.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1387344086-12744-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 8b0bb1f4494a..68a4fd2f505e 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -161,6 +161,11 @@ struct sort_entry sort_dso = {
 
 /* --sort symbol */
 
+static int64_t _sort__addr_cmp(u64 left_ip, u64 right_ip)
+{
+	return (int64_t)(right_ip - left_ip);
+}
+
 static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r)
 {
 	u64 ip_l, ip_r;
@@ -183,7 +188,7 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 	int64_t ret;
 
 	if (!left->ms.sym && !right->ms.sym)
-		return right->level - left->level;
+		return _sort__addr_cmp(left->ip, right->ip);
 
 	/*
 	 * comparing symbol address alone is not enough since it's a
@@ -372,7 +377,7 @@ sort__sym_from_cmp(struct hist_entry *left, struct hist_entry *right)
 	struct addr_map_symbol *from_r = &right->branch_info->from;
 
 	if (!from_l->sym && !from_r->sym)
-		return right->level - left->level;
+		return _sort__addr_cmp(from_l->addr, from_r->addr);
 
 	return _sort__sym_cmp(from_l->sym, from_r->sym);
 }
@@ -384,7 +389,7 @@ sort__sym_to_cmp(struct hist_entry *left, struct hist_entry *right)
 	struct addr_map_symbol *to_r = &right->branch_info->to;
 
 	if (!to_l->sym && !to_r->sym)
-		return right->level - left->level;
+		return _sort__addr_cmp(to_l->addr, to_r->addr);
 
 	return _sort__sym_cmp(to_l->sym, to_r->sym);
 }
-- 
1.8.1.4

