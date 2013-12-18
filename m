Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab3LRFVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:21:48 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56165 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3LRFVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:21:30 -0500
X-AuditID: 9c93017d-b7c5eae000004296-1d-52b130d8c57f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/18] perf sort: Compare addresses if no symbol info
Date: Wed, 18 Dec 2013 14:21:09 +0900
Message-Id: <1387344086-12744-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If a hist entry doesn't have symbol information, compare it with its
address.  Currently it only compares its level or whether it's NULL.
This can lead to an undesired result like an overhead exceeds 100%
especially when callchain accumulation is enabled by later patch.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
1.7.11.7

