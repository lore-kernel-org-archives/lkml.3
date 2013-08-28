Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3H1O75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:59:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40580 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab3H1O7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:59:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 12/21] perf trace: Introduce syscall arg formatters
Date: Wed, 28 Aug 2013 11:59:28 -0300
Message-Id: <1377701977-2085-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377701977-2085-1-git-send-email-acme@infradead.org>
References: <1377701977-2085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Starting with one for printing pointers in hexadecimal, using the
information in the syscall tracepoint format.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-c4y4jy7qqkn8wsd8q6j1g7zh@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c3caabb..86568ed 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -12,6 +12,11 @@
 #include <libaudit.h>
 #include <stdlib.h>
 
+static size_t syscall_arg__scnprintf_hex(char *bf, size_t size, unsigned long arg)
+{
+	return scnprintf(bf, size, "%#lx", arg);
+}
+
 static struct syscall_fmt {
 	const char *name;
 	const char *alias;
@@ -51,6 +56,7 @@ struct syscall {
 	const char	    *name;
 	bool		    filtered;
 	struct syscall_fmt  *fmt;
+	size_t		    (**arg_scnprintf)(char *bf, size_t size, unsigned long arg);
 };
 
 static size_t fprintf_duration(unsigned long t, FILE *fp)
@@ -207,6 +213,24 @@ static int trace__symbols_init(struct trace *trace, struct perf_evlist *evlist)
 	return err;
 }
 
+static int syscall__set_arg_fmts(struct syscall *sc)
+{
+	struct format_field *field;
+	int idx = 0;
+
+	sc->arg_scnprintf = calloc(sc->tp_format->format.nr_fields - 1, sizeof(void *));
+	if (sc->arg_scnprintf == NULL)
+		return -1;
+
+	for (field = sc->tp_format->format.fields->next; field; field = field->next) {
+		if (field->flags & FIELD_IS_POINTER)
+			sc->arg_scnprintf[idx] = syscall_arg__scnprintf_hex;
+		++idx;
+	}
+
+	return 0;
+}
+
 static int trace__read_syscall_info(struct trace *trace, int id)
 {
 	char tp_name[128];
@@ -259,7 +283,10 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 		sc->tp_format = event_format__new("syscalls", tp_name);
 	}
 
-	return sc->tp_format != NULL ? 0 : -1;
+	if (sc->tp_format == NULL)
+		return -1;
+
+	return syscall__set_arg_fmts(sc);
 }
 
 static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
@@ -273,8 +300,14 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 
 		for (field = sc->tp_format->format.fields->next; field; field = field->next) {
 			printed += scnprintf(bf + printed, size - printed,
-					     "%s%s: %ld", printed ? ", " : "",
-					     field->name, args[i++]);
+					     "%s%s: ", printed ? ", " : "", field->name);
+
+			if (sc->arg_scnprintf && sc->arg_scnprintf[i])
+				printed += sc->arg_scnprintf[i](bf + printed, size - printed, args[i]);
+			else
+				printed += scnprintf(bf + printed, size - printed,
+						     "%ld", args[i]);
+                       ++i;
 		}
 	} else {
 		while (i < 6) {
-- 
1.8.1.4

