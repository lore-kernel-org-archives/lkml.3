Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaALScR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:32:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45303 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaALSbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:31:36 -0500
Date: Sun, 12 Jan 2014 10:30:57 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-2037be53b2bceac3c2e648b8ff3fd62e21af2d35@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, rodrigo@sdfg.com.ar,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, rodrigo@sdfg.com.ar,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1387344086-12744-2-git-send-email-namhyung@kernel.org>
References: <1387344086-12744-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort: Compare addresses if no symbol info
Git-Commit-ID: 2037be53b2bceac3c2e648b8ff3fd62e21af2d35
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:31:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2037be53b2bceac3c2e648b8ff3fd62e21af2d35
Gitweb:     http://git.kernel.org/tip/2037be53b2bceac3c2e648b8ff3fd62e21af2d35
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 18 Dec 2013 14:21:09 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 18 Dec 2013 14:42:30 -0300

perf sort: Compare addresses if no symbol info

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
index 8b0bb1f..68a4fd2 100644
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
