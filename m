Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaHMWsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:48:50 -0400
Received: from mail.kernel.org ([198.145.19.201]:54774 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbaHMWsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:48:46 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 01/41] perf top: Don't look for kernel idle symbols in all DSOs
Date: Wed, 13 Aug 2014 19:47:47 -0300
Message-Id: <1407970107-24540-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The 'top' tool initially supported only kernel symbols, when making it
support userspace symbols we forgot to make the symbol filter first
check that the DSO is the kernel one. Fix it.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
 c: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-54haztkeigmbump5sexxnzhv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 4 +++-
 tools/perf/util/symbol.c | 4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index bde216b2071c..4fb6f726271c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -623,10 +623,12 @@ repeat:
 	return NULL;
 }
 
-static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
+static int symbol_filter(struct map *map, struct symbol *sym)
 {
 	const char *name = sym->name;
 
+	if (!map->dso->kernel)
+		return 0;
 	/*
 	 * ppc64 uses function descriptors and appends a '.' to the
 	 * start of every instruction address. Remove it.
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f134ec138934..35a8bd56cd15 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -523,6 +523,10 @@ struct process_kallsyms_args {
 	struct dso *dso;
 };
 
+/*
+ * These are symbols in the kernel image, so make sure that
+ * sym is from a kernel DSO.
+ */
 bool symbol__is_idle(struct symbol *sym)
 {
 	const char * const idle_symbols[] = {
-- 
1.9.3

