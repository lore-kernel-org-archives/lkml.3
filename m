Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbaGNKN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:13:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:41917 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbaGNKFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:05:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434577"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 26/41] perf tools: Add ability to iterate over a dso's symbols
Date: Mon, 14 Jul 2014 13:02:50 +0300
Message-Id: <1405332185-4050-27-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose dso__first_symbol() and dso__next_symbol() to make
it possible to iterate over a dso's symbols.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/symbol.c | 17 ++++++++++++++++-
 tools/perf/util/symbol.h |  3 +++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 21b2e45..d5dc547 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -341,6 +341,16 @@ static struct symbol *symbols__first(struct rb_root *symbols)
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
@@ -411,11 +421,16 @@ struct symbol *dso__find_symbol(struct dso *dso,
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
index 6ba8a22..e1350bc 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -239,6 +239,9 @@ struct symbol *dso__find_symbol(struct dso *dso, enum map_type type,
 struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name);
 
+struct symbol *dso__first_symbol(struct dso *dso, enum map_type type);
+struct symbol *dso__next_symbol(struct symbol *sym);
+
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 int modules__parse(const char *filename, void *arg,
-- 
1.8.3.2

