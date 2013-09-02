Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab3IBU4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 16:56:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48848 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991Ab3IBU4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 16:56:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/10] perf trace: Allow syscall arg formatters to mask args
Date: Mon,  2 Sep 2013 17:56:24 -0300
Message-Id: <1378155393-7993-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378155393-7993-1-git-send-email-acme@infradead.org>
References: <1378155393-7993-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The futex syscall ignores some arguments according to the 'operation'
arg, so allow arg formatters to mask those.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-abqrg3oldgfsdnltfrvso9f7@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 69a065e..c29692a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -15,14 +15,16 @@
 #include <stdlib.h>
 #include <sys/mman.h>
 
-static size_t syscall_arg__scnprintf_hex(char *bf, size_t size, unsigned long arg)
+static size_t syscall_arg__scnprintf_hex(char *bf, size_t size,
+					 unsigned long arg, u8 *arg_mask __maybe_unused)
 {
 	return scnprintf(bf, size, "%#lx", arg);
 }
 
 #define SCA_HEX syscall_arg__scnprintf_hex
 
-static size_t syscall_arg__scnprintf_mmap_prot(char *bf, size_t size, unsigned long arg)
+static size_t syscall_arg__scnprintf_mmap_prot(char *bf, size_t size,
+					       unsigned long arg, u8 *arg_mask __maybe_unused)
 {
 	int printed = 0, prot = arg;
 
@@ -52,7 +54,8 @@ static size_t syscall_arg__scnprintf_mmap_prot(char *bf, size_t size, unsigned l
 
 #define SCA_MMAP_PROT syscall_arg__scnprintf_mmap_prot
 
-static size_t syscall_arg__scnprintf_mmap_flags(char *bf, size_t size, unsigned long arg)
+static size_t syscall_arg__scnprintf_mmap_flags(char *bf, size_t size,
+						unsigned long arg, u8 *arg_mask __maybe_unused)
 {
 	int printed = 0, flags = arg;
 
@@ -92,7 +95,8 @@ static size_t syscall_arg__scnprintf_mmap_flags(char *bf, size_t size, unsigned
 
 #define SCA_MMAP_FLAGS syscall_arg__scnprintf_mmap_flags
 
-static size_t syscall_arg__scnprintf_madvise_behavior(char *bf, size_t size, unsigned long arg)
+static size_t syscall_arg__scnprintf_madvise_behavior(char *bf, size_t size,
+						      unsigned long arg, u8 *arg_mask __maybe_unused)
 {
 	int behavior = arg;
 
@@ -136,7 +140,7 @@ static size_t syscall_arg__scnprintf_madvise_behavior(char *bf, size_t size, uns
 static struct syscall_fmt {
 	const char *name;
 	const char *alias;
-	size_t	   (*arg_scnprintf[6])(char *bf, size_t size, unsigned long arg);
+	size_t	   (*arg_scnprintf[6])(char *bf, size_t size, unsigned long arg, u8 *arg_mask);
 	bool	   errmsg;
 	bool	   timeout;
 	bool	   hexret;
@@ -198,7 +202,8 @@ struct syscall {
 	const char	    *name;
 	bool		    filtered;
 	struct syscall_fmt  *fmt;
-	size_t		    (**arg_scnprintf)(char *bf, size_t size, unsigned long arg);
+	size_t		    (**arg_scnprintf)(char *bf, size_t size,
+					      unsigned long arg, u8 *args_mask);
 };
 
 static size_t fprintf_duration(unsigned long t, FILE *fp)
@@ -443,17 +448,23 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 
 	if (sc->tp_format != NULL) {
 		struct format_field *field;
+		u8 mask = 0, bit = 1;
+
+		for (field = sc->tp_format->format.fields->next; field;
+		     field = field->next, ++i, bit <<= 1) {
+			if (mask & bit)
+				continue;
 
-		for (field = sc->tp_format->format.fields->next; field; field = field->next) {
 			printed += scnprintf(bf + printed, size - printed,
 					     "%s%s: ", printed ? ", " : "", field->name);
 
-			if (sc->arg_scnprintf && sc->arg_scnprintf[i])
-				printed += sc->arg_scnprintf[i](bf + printed, size - printed, args[i]);
-			else
+			if (sc->arg_scnprintf && sc->arg_scnprintf[i]) {
+				printed += sc->arg_scnprintf[i](bf + printed, size - printed,
+								args[i], &mask);
+			} else {
 				printed += scnprintf(bf + printed, size - printed,
 						     "%ld", args[i]);
-                       ++i;
+			}
 		}
 	} else {
 		while (i < 6) {
-- 
1.8.1.4

