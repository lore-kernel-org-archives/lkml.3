Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab3BFWES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:04:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37251 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab3BFWD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:03:58 -0500
Date: Wed, 6 Feb 2013 14:03:33 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-51f27d1440cede5a413d279a20b38767b6f85097@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1360130237-9963-1-git-send-email-namhyung@kernel.org>
References: <1360130237-9963-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort: Drop ip_[lr]
  arguments from _sort__sym_cmp()
Git-Commit-ID: 51f27d1440cede5a413d279a20b38767b6f85097
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 14:03:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  51f27d1440cede5a413d279a20b38767b6f85097
Gitweb:     http://git.kernel.org/tip/51f27d1440cede5a413d279a20b38767b6f85097
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 6 Feb 2013 14:57:15 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 6 Feb 2013 18:09:25 -0300

perf sort: Drop ip_[lr] arguments from _sort__sym_cmp()

Current _sort__sym_cmp() function is used for comparing symbols between
two hist entries on symbol, symbol_from and symbol_to sort keys.  Those
functions pass addresses of symbols but it's meaningless since it gets
over-written inside of the _sort__sym_cmp function to a start address of
the symbol.  So just get rid of them.

This might cause a difference than prior output for branch stacks since
it seems not using start address of the symbol but branch address.
However AFAICS it'd be same as it gets overwritten anyway.

Also remove redundant part of code in sort__sym_cmp().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1360130237-9963-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 8333661..03cabe5 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -160,9 +160,10 @@ struct sort_entry sort_dso = {
 
 /* --sort symbol */
 
-static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r,
-			      u64 ip_l, u64 ip_r)
+static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r)
 {
+	u64 ip_l, ip_r;
+
 	if (!sym_l || !sym_r)
 		return cmp_null(sym_l, sym_r);
 
@@ -178,21 +179,10 @@ static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r,
 static int64_t
 sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	u64 ip_l, ip_r;
-
 	if (!left->ms.sym && !right->ms.sym)
 		return right->level - left->level;
 
-	if (!left->ms.sym || !right->ms.sym)
-		return cmp_null(left->ms.sym, right->ms.sym);
-
-	if (left->ms.sym == right->ms.sym)
-		return 0;
-
-	ip_l = left->ms.sym->start;
-	ip_r = right->ms.sym->start;
-
-	return _sort__sym_cmp(left->ms.sym, right->ms.sym, ip_l, ip_r);
+	return _sort__sym_cmp(left->ms.sym, right->ms.sym);
 }
 
 static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
@@ -383,8 +373,7 @@ sort__sym_from_cmp(struct hist_entry *left, struct hist_entry *right)
 	if (!from_l->sym && !from_r->sym)
 		return right->level - left->level;
 
-	return _sort__sym_cmp(from_l->sym, from_r->sym, from_l->addr,
-			     from_r->addr);
+	return _sort__sym_cmp(from_l->sym, from_r->sym);
 }
 
 static int64_t
@@ -396,7 +385,7 @@ sort__sym_to_cmp(struct hist_entry *left, struct hist_entry *right)
 	if (!to_l->sym && !to_r->sym)
 		return right->level - left->level;
 
-	return _sort__sym_cmp(to_l->sym, to_r->sym, to_l->addr, to_r->addr);
+	return _sort__sym_cmp(to_l->sym, to_r->sym);
 }
 
 static int hist_entry__sym_from_snprintf(struct hist_entry *self, char *bf,
