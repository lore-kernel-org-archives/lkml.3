Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab3ICHPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:15:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35947 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3ICHPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:15:42 -0400
Date: Tue, 3 Sep 2013 00:14:56 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-abqrg3oldgfsdnltfrvso9f7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Allow syscall arg formatters to mask args
Git-Commit-ID: 6e7eeb51106d2e9ef7975214747e76d23c5d01af
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 03 Sep 2013 00:15:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e7eeb51106d2e9ef7975214747e76d23c5d01af
Gitweb:     http://git.kernel.org/tip/6e7eeb51106d2e9ef7975214747e76d23c5d01af
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 2 Sep 2013 10:39:21 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Sep 2013 14:58:18 -0300

perf trace: Allow syscall arg formatters to mask args

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
