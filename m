Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3H2KJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:09:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35131 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab3H2KJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:09:49 -0400
Date: Thu, 29 Aug 2013 03:09:08 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-c4y4jy7qqkn8wsd8q6j1g7zh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Introduce syscall arg formatters
Git-Commit-ID: 13d4ff3eb36474728be2acfa773b31ff39f3ea4d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 03:09:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13d4ff3eb36474728be2acfa773b31ff39f3ea4d
Gitweb:     http://git.kernel.org/tip/13d4ff3eb36474728be2acfa773b31ff39f3ea4d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 23 Aug 2013 18:14:48 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 26 Aug 2013 17:25:47 -0300

perf trace: Introduce syscall arg formatters

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
