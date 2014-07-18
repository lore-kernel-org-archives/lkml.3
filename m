Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934699AbaGRE0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:26:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33253 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaGRE0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:26:19 -0400
Date: Thu, 17 Jul 2014 21:25:23 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-9c00a81b6aafc4ed375a43e7a54e6cf2d720c7c6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1405332185-4050-27-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-27-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Add ability to iterate over a dso'
 s symbols
Git-Commit-ID: 9c00a81b6aafc4ed375a43e7a54e6cf2d720c7c6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c00a81b6aafc4ed375a43e7a54e6cf2d720c7c6
Gitweb:     http://git.kernel.org/tip/9c00a81b6aafc4ed375a43e7a54e6cf2d720c7c6
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Jul 2014 13:02:50 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:35 -0300

perf symbols: Add ability to iterate over a dso's symbols

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
index 156ae36..eb06746 100644
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
index 436169d..ee2d3cc 100644
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
