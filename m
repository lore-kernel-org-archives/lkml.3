Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbbAUPDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:03:53 -0500
Received: from mail.kernel.org ([198.145.29.136]:43419 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbbAUPBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:01:36 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/9] perf symbols: Return the first entry with a given name in find_by_name method
Date: Wed, 21 Jan 2015 12:01:06 -0300
Message-Id: <1421852470-20153-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421852470-20153-1-git-send-email-acme@kernel.org>
References: <1421852470-20153-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When a dso contains multiple symbols which have same name, current
dso__find_symbol_by_name() only finds an one of them and there's no way
to get the all symbols without going through the rbtree.

So make symbols__find_by_name() return the first entry with the given
name and the next patch in this series will provide a way to iterate
from there, by the name ordered rb_tree, till a suitable symbol is
found.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/1421234288-22758-2-git-send-email-namhyung@kernel.org
[ Yanked this independent hunk, without changes, from a larger patch  ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c24c5b83156c..3cb928e51a99 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -396,6 +396,7 @@ static struct symbol *symbols__find_by_name(struct rb_root *symbols,
 					    const char *name)
 {
 	struct rb_node *n;
+	struct symbol_name_rb_node *s;
 
 	if (symbols == NULL)
 		return NULL;
@@ -403,7 +404,6 @@ static struct symbol *symbols__find_by_name(struct rb_root *symbols,
 	n = symbols->rb_node;
 
 	while (n) {
-		struct symbol_name_rb_node *s;
 		int cmp;
 
 		s = rb_entry(n, struct symbol_name_rb_node, rb_node);
@@ -414,10 +414,24 @@ static struct symbol *symbols__find_by_name(struct rb_root *symbols,
 		else if (cmp > 0)
 			n = n->rb_right;
 		else
-			return &s->sym;
+			break;
 	}
 
-	return NULL;
+	if (n == NULL)
+		return NULL;
+
+	/* return first symbol that has same name (if any) */
+	for (n = rb_prev(n); n; n = rb_prev(n)) {
+		struct symbol_name_rb_node *tmp;
+
+		tmp = rb_entry(n, struct symbol_name_rb_node, rb_node);
+		if (strcmp(tmp->sym.name, s->sym.name))
+			break;
+
+		s = tmp;
+	}
+
+	return &s->sym;
 }
 
 struct symbol *dso__find_symbol(struct dso *dso,
-- 
1.9.3

