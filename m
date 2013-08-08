Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054Ab3HHCy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:54:27 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53673 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933959Ab3HHCvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:40 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 12/19] perf tool: Add support for exclude symbol list to symbol_conf
Date: Wed,  7 Aug 2013 22:50:54 -0400
Message-Id: <1375930261-77273-13-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows user to specify a list of symbols not interested in. One use case is
the upcoming timehist command.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/symbol.c |   20 ++++++++++++++++++++
 tools/perf/util/symbol.h |    3 +++
 2 files changed, 23 insertions(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 1f777f9..4c90a7a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -549,6 +549,18 @@ bool symbol__is_idle(struct symbol *sym)
 	return sym->is_idle;
 }
 
+bool symbol__is_excluded(struct symbol *sym)
+{
+	if (sym == NULL)
+		return false;
+
+	if (symbol_conf.excl_sym_list &&
+	    strlist__has_entry(symbol_conf.excl_sym_list, sym->name))
+		return true;
+
+	return false;
+}
+
 static int map__process_kallsym_symbol(void *arg, const char *name,
 				       char type, u64 start)
 {
@@ -1518,6 +1530,10 @@ int symbol__init(void)
 		       symbol_conf.sym_list_str, "symbol") < 0)
 		goto out_free_comm_list;
 
+	if (setup_list(&symbol_conf.excl_sym_list,
+		       symbol_conf.excl_sym_list_str, "exclude symbol") < 0)
+		goto out_free_sym_list;
+
 	/*
 	 * A path to symbols of "/" is identical to ""
 	 * reset here for simplicity.
@@ -1535,6 +1551,8 @@ int symbol__init(void)
 	symbol_conf.initialized = true;
 	return 0;
 
+out_free_sym_list:
+	strlist__delete(symbol_conf.sym_list);
 out_free_comm_list:
 	strlist__delete(symbol_conf.comm_list);
 out_free_dso_list:
@@ -1546,10 +1564,12 @@ void symbol__exit(void)
 {
 	if (!symbol_conf.initialized)
 		return;
+	strlist__delete(symbol_conf.excl_sym_list);
 	strlist__delete(symbol_conf.sym_list);
 	strlist__delete(symbol_conf.dso_list);
 	strlist__delete(symbol_conf.comm_list);
 	vmlinux_path__exit();
+	symbol_conf.excl_sym_list = NULL;
 	symbol_conf.sym_list = symbol_conf.dso_list = symbol_conf.comm_list = NULL;
 	symbol_conf.initialized = false;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index c163ba9..9501213 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -112,10 +112,12 @@ struct symbol_conf {
 	const char	*dso_list_str,
 			*comm_list_str,
 			*sym_list_str,
+			*excl_sym_list_str,
 			*col_width_list_str;
        struct strlist	*dso_list,
 			*comm_list,
 			*sym_list,
+			*excl_sym_list,
 			*dso_from_list,
 			*dso_to_list,
 			*sym_from_list,
@@ -239,6 +241,7 @@ bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 bool symbol__restricted_filename(const char *filename,
 				 const char *restricted_filename);
 bool symbol__is_idle(struct symbol *sym);
+bool symbol__is_excluded(struct symbol *sym);
 
 int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 		  struct symsrc *runtime_ss, symbol_filter_t filter,
-- 
1.7.10.1

