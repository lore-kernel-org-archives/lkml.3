Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3LCHPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 02:15:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:2119 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab3LCHPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 02:15:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,816,1378882800"; 
   d="scan'208";a="445838738"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/7] perf tools: Retain symbol source file name to lookup source line numbers
Date: Tue,  3 Dec 2013 09:23:08 +0200
Message-Id: <1386055390-13757-6-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
References: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, lookup of an ip's source file name
and line number is done using the dso file name.
Instead retain the file name used to lookup the
dso's symbols and use that.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/dso.c     | 1 +
 tools/perf/util/dso.h     | 1 +
 tools/perf/util/srcline.c | 7 ++++++-
 tools/perf/util/symbol.c  | 2 ++
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 68aa55a..49da968 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -470,6 +470,7 @@ void dso__delete(struct dso *dso)
 		free(dso->long_name);
 	dso_cache__free(&dso->cache);
 	dso__free_a2l(dso);
+	free(dso->symsrc_filename);
 	free(dso);
 }
 
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index d8613dc..7142e52 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -78,6 +78,7 @@ struct dso {
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
 	struct rb_root	 cache;
 	void		 *a2l;
+	char		 *symsrc_filename;
 	enum dso_kernel_type	kernel;
 	enum dso_swap_type	needs_swap;
 	enum dso_binary_type	symtab_type;
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 25b85b2..93795f9 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -249,11 +249,16 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	char *file = NULL;
 	unsigned line = 0;
 	char *srcline;
-	char *dso_name = dso->long_name;
+	char *dso_name;
 
 	if (!dso->has_srcline)
 		return SRCLINE_UNKNOWN;
 
+	if (dso->symsrc_filename)
+		dso_name = dso->symsrc_filename;
+	else
+		dso_name = dso->long_name;
+
 	if (dso_name[0] == '[')
 		goto out;
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 360eefe..de87dba 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1336,6 +1336,8 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 		if (!syms_ss && symsrc__has_symtab(ss)) {
 			syms_ss = ss;
 			next_slot = true;
+			if (!dso->symsrc_filename)
+				dso->symsrc_filename = strdup(name);
 		}
 
 		if (!runtime_ss && symsrc__possibly_runtime(ss)) {
-- 
1.7.11.7

