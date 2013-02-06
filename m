Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab3BFVsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:48:06 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33193
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758751Ab3BFVob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:44:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/17] perf sort: Drop ip_[lr] arguments from _sort__sym_cmp()
Date: Wed,  6 Feb 2013 18:44:07 -0300
Message-Id: <1360187059-12661-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1360187059-12661-1-git-send-email-acme@infradead.org>
References: <1360187059-12661-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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
-- 
1.8.1.1.361.gec3ae6e

