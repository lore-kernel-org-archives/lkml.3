Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbaHNJAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 05:00:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36194 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbaHNIns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:43:48 -0400
Date: Thu, 14 Aug 2014 01:42:39 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-54haztkeigmbump5sexxnzhv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org, efault@gmx.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, efault@gmx.de, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Don'
 t look for kernel idle symbols in all DSOs
Git-Commit-ID: e7110b9fb901dcc022afd358386c1be69658af7d
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

Commit-ID:  e7110b9fb901dcc022afd358386c1be69658af7d
Gitweb:     http://git.kernel.org/tip/e7110b9fb901dcc022afd358386c1be69658af7d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 8 Aug 2014 18:00:39 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 11:14:21 -0300

perf top: Don't look for kernel idle symbols in all DSOs

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
---
 tools/perf/builtin-top.c | 4 +++-
 tools/perf/util/symbol.c | 4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index bde216b..4fb6f72 100644
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
index f134ec1..35a8bd5 100644
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
