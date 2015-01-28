Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbbA1Uts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:49:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759386AbbA1Utn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:49:43 -0500
Date: Wed, 28 Jan 2015 07:01:50 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-aq210drxprnu2so4dye5xa3j@git.kernel.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        hpa@zytor.com, jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        masami.hiramatsu.pt@hitachi.com
Reply-To: mingo@kernel.org, acme@redhat.com, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, hpa@zytor.com, jolsa@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Introduce method to iterate symbols ordered by name
Git-Commit-ID: 18bd726418f2a2e12f85104f0f4b5d5d077e1752
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

Commit-ID:  18bd726418f2a2e12f85104f0f4b5d5d077e1752
Gitweb:     http://git.kernel.org/tip/18bd726418f2a2e12f85104f0f4b5d5d077e1752
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 16 Jan 2015 15:39:53 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 10:05:54 -0300

perf symbols: Introduce method to iterate symbols ordered by name

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
index 3cb928e..a194702 100644
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
index 9d602e9..1650dcb 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -231,6 +231,7 @@ struct symbol *dso__find_symbol(struct dso *dso, enum map_type type,
 				u64 addr);
 struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name);
+struct symbol *symbol__next_by_name(struct symbol *sym);
 
 struct symbol *dso__first_symbol(struct dso *dso, enum map_type type);
 struct symbol *dso__next_symbol(struct symbol *sym);
