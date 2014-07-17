Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854AbaGQQON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:14:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:52433 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965313AbaGQQOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:14:10 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/33] perf symbols: Add ability to iterate over a dso's symbols
Date: Thu, 17 Jul 2014 13:12:20 -0300
Message-Id: <1405613555-23380-19-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Expose dso__first_symbol() and dso__next_symbol() to make it possible to
iterate over a dso's symbols.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-27-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 17 ++++++++++++++++-
 tools/perf/util/symbol.h |  3 +++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 156ae36dfcfc..eb06746b06b2 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -342,6 +342,16 @@ static struct symbol *symbols__first(struct rb_root *symbols)
 	return NULL;
 }
 
+static struct symbol *symbols__next(struct symbol *sym)
+{
+	struct rb_node *n = rb_next(&sym->rb_node);
+
+	if (n)
+		return rb_entry(n, struct symbol, rb_node);
+
+	return NULL;
+}
+
 struct symbol_name_rb_node {
 	struct rb_node	rb_node;
 	struct symbol	sym;
@@ -412,11 +422,16 @@ struct symbol *dso__find_symbol(struct dso *dso,
 	return symbols__find(&dso->symbols[type], addr);
 }
 
-static struct symbol *dso__first_symbol(struct dso *dso, enum map_type type)
+struct symbol *dso__first_symbol(struct dso *dso, enum map_type type)
 {
 	return symbols__first(&dso->symbols[type]);
 }
 
+struct symbol *dso__next_symbol(struct symbol *sym)
+{
+	return symbols__next(sym);
+}
+
 struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name)
 {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 436169dd1d84..ee2d3ccd3ad1 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -240,6 +240,9 @@ struct symbol *dso__find_symbol(struct dso *dso, enum map_type type,
 struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name);
 
+struct symbol *dso__first_symbol(struct dso *dso, enum map_type type);
+struct symbol *dso__next_symbol(struct symbol *sym);
+
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 int modules__parse(const char *filename, void *arg,
-- 
1.9.3

