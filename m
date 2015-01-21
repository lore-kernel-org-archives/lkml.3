Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbbAUPCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:02:23 -0500
Received: from mail.kernel.org ([198.145.29.136]:43438 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbbAUPBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:01:39 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 6/9] perf symbols: Introduce method to iterate symbols ordered by name
Date: Wed, 21 Jan 2015 12:01:07 -0300
Message-Id: <1421852470-20153-7-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421852470-20153-1-git-send-email-acme@kernel.org>
References: <1421852470-20153-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Given a symbol, go to the next entry in a rbtree sorted by symbol name.

Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/n/tip-aq210drxprnu2so4dye5xa3j@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 11 +++++++++++
 tools/perf/util/symbol.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 3cb928e51a99..a194702a0a2f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -450,6 +450,17 @@ struct symbol *dso__next_symbol(struct symbol *sym)
 	return symbols__next(sym);
 }
 
+struct symbol *symbol__next_by_name(struct symbol *sym)
+{
+	struct symbol_name_rb_node *s = container_of(sym, struct symbol_name_rb_node, sym);
+	struct rb_node *n = rb_next(&s->rb_node);
+
+	return n ? &rb_entry(n, struct symbol_name_rb_node, rb_node)->sym : NULL;
+}
+
+ /*
+  * Teturns first symbol that matched with @name.
+  */
 struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name)
 {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 9d602e9c6f59..1650dcb3a67b 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -231,6 +231,7 @@ struct symbol *dso__find_symbol(struct dso *dso, enum map_type type,
 				u64 addr);
 struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name);
+struct symbol *symbol__next_by_name(struct symbol *sym);
 
 struct symbol *dso__first_symbol(struct dso *dso, enum map_type type);
 struct symbol *dso__next_symbol(struct symbol *sym);
-- 
1.9.3

