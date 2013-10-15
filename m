Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab3JOFVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:21:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60966 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab3JOFVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:21:35 -0400
Date: Mon, 14 Oct 2013 22:20:24 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-zyi2esmas5wfrxznh0x0fkiz@git.kernel.org>
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
  Put syscall formatter parms into struct
Git-Commit-ID: 01533e9720c8527faf0bc6e476c4c911a488e268
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:20:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01533e9720c8527faf0bc6e476c4c911a488e268
Gitweb:     http://git.kernel.org/tip/01533e9720c8527faf0bc6e476c4c911a488e268
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 3 Sep 2013 12:20:12 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:08:15 -0300

perf trace: Put syscall formatter parms into struct

So that we can add more state to formatters without having to modify
all of them.

Example is to pass a table to a generic string formatter, like for
setitimer 'which' arg.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-zyi2esmas5wfrxznh0x0fkiz@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 96 +++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 48 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 71aa3e3..939426c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -33,22 +33,24 @@
 # define MADV_UNMERGEABLE	13
 #endif
 
+struct syscall_arg {
+	unsigned long val;
+	u8	      idx;
+	u8	      mask;
+};
+
 static size_t syscall_arg__scnprintf_hex(char *bf, size_t size,
-					 unsigned long arg,
-					 u8 arg_idx __maybe_unused,
-					 u8 *arg_mask __maybe_unused)
+					 struct syscall_arg *arg)
 {
-	return scnprintf(bf, size, "%#lx", arg);
+	return scnprintf(bf, size, "%#lx", arg->val);
 }
 
 #define SCA_HEX syscall_arg__scnprintf_hex
 
 static size_t syscall_arg__scnprintf_whence(char *bf, size_t size,
-					    unsigned long arg,
-					    u8 arg_idx __maybe_unused,
-					    u8 *arg_mask __maybe_unused)
+					    struct syscall_arg *arg)
 {
-	int whence = arg;
+	int whence = arg->val;
 
 	switch (whence) {
 #define P_WHENCE(n) case SEEK_##n: return scnprintf(bf, size, #n)
@@ -71,11 +73,9 @@ static size_t syscall_arg__scnprintf_whence(char *bf, size_t size,
 #define SCA_WHENCE syscall_arg__scnprintf_whence
 
 static size_t syscall_arg__scnprintf_mmap_prot(char *bf, size_t size,
-					       unsigned long arg,
-					       u8 arg_idx __maybe_unused,
-					       u8 *arg_mask __maybe_unused)
+					       struct syscall_arg *arg)
 {
-	int printed = 0, prot = arg;
+	int printed = 0, prot = arg->val;
 
 	if (prot == PROT_NONE)
 		return scnprintf(bf, size, "NONE");
@@ -104,10 +104,9 @@ static size_t syscall_arg__scnprintf_mmap_prot(char *bf, size_t size,
 #define SCA_MMAP_PROT syscall_arg__scnprintf_mmap_prot
 
 static size_t syscall_arg__scnprintf_mmap_flags(char *bf, size_t size,
-						unsigned long arg, u8 arg_idx __maybe_unused,
-						u8 *arg_mask __maybe_unused)
+						struct syscall_arg *arg)
 {
-	int printed = 0, flags = arg;
+	int printed = 0, flags = arg->val;
 
 #define	P_MMAP_FLAG(n) \
 	if (flags & MAP_##n) { \
@@ -148,10 +147,9 @@ static size_t syscall_arg__scnprintf_mmap_flags(char *bf, size_t size,
 #define SCA_MMAP_FLAGS syscall_arg__scnprintf_mmap_flags
 
 static size_t syscall_arg__scnprintf_madvise_behavior(char *bf, size_t size,
-						      unsigned long arg, u8 arg_idx __maybe_unused,
-						      u8 *arg_mask __maybe_unused)
+						      struct syscall_arg *arg)
 {
-	int behavior = arg;
+	int behavior = arg->val;
 
 	switch (behavior) {
 #define	P_MADV_BHV(n) case MADV_##n: return scnprintf(bf, size, #n)
@@ -190,8 +188,7 @@ static size_t syscall_arg__scnprintf_madvise_behavior(char *bf, size_t size,
 
 #define SCA_MADV_BHV syscall_arg__scnprintf_madvise_behavior
 
-static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, unsigned long arg,
-					      u8 arg_idx __maybe_unused, u8 *arg_mask)
+static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, struct syscall_arg *arg)
 {
 	enum syscall_futex_args {
 		SCF_UADDR   = (1 << 0),
@@ -201,24 +198,24 @@ static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, unsigned lo
 		SCF_UADDR2  = (1 << 4),
 		SCF_VAL3    = (1 << 5),
 	};
-	int op = arg;
+	int op = arg->val;
 	int cmd = op & FUTEX_CMD_MASK;
 	size_t printed = 0;
 
 	switch (cmd) {
 #define	P_FUTEX_OP(n) case FUTEX_##n: printed = scnprintf(bf, size, #n);
-	P_FUTEX_OP(WAIT);	    *arg_mask |= SCF_VAL3|SCF_UADDR2;		  break;
-	P_FUTEX_OP(WAKE);	    *arg_mask |= SCF_VAL3|SCF_UADDR2|SCF_TIMEOUT; break;
-	P_FUTEX_OP(FD);		    *arg_mask |= SCF_VAL3|SCF_UADDR2|SCF_TIMEOUT; break;
-	P_FUTEX_OP(REQUEUE);	    *arg_mask |= SCF_VAL3|SCF_TIMEOUT;	          break;
-	P_FUTEX_OP(CMP_REQUEUE);    *arg_mask |= SCF_TIMEOUT;			  break;
-	P_FUTEX_OP(CMP_REQUEUE_PI); *arg_mask |= SCF_TIMEOUT;			  break;
+	P_FUTEX_OP(WAIT);	    arg->mask |= SCF_VAL3|SCF_UADDR2;		  break;
+	P_FUTEX_OP(WAKE);	    arg->mask |= SCF_VAL3|SCF_UADDR2|SCF_TIMEOUT; break;
+	P_FUTEX_OP(FD);		    arg->mask |= SCF_VAL3|SCF_UADDR2|SCF_TIMEOUT; break;
+	P_FUTEX_OP(REQUEUE);	    arg->mask |= SCF_VAL3|SCF_TIMEOUT;	          break;
+	P_FUTEX_OP(CMP_REQUEUE);    arg->mask |= SCF_TIMEOUT;			  break;
+	P_FUTEX_OP(CMP_REQUEUE_PI); arg->mask |= SCF_TIMEOUT;			  break;
 	P_FUTEX_OP(WAKE_OP);							  break;
-	P_FUTEX_OP(LOCK_PI);	    *arg_mask |= SCF_VAL3|SCF_UADDR2|SCF_TIMEOUT; break;
-	P_FUTEX_OP(UNLOCK_PI);	    *arg_mask |= SCF_VAL3|SCF_UADDR2|SCF_TIMEOUT; break;
-	P_FUTEX_OP(TRYLOCK_PI);	    *arg_mask |= SCF_VAL3|SCF_UADDR2;		  break;
-	P_FUTEX_OP(WAIT_BITSET);    *arg_mask |= SCF_UADDR2;			  break;
-	P_FUTEX_OP(WAKE_BITSET);    *arg_mask |= SCF_UADDR2;			  break;
+	P_FUTEX_OP(LOCK_PI);	    arg->mask |= SCF_VAL3|SCF_UADDR2|SCF_TIMEOUT; break;
+	P_FUTEX_OP(UNLOCK_PI);	    arg->mask |= SCF_VAL3|SCF_UADDR2|SCF_TIMEOUT; break;
+	P_FUTEX_OP(TRYLOCK_PI);	    arg->mask |= SCF_VAL3|SCF_UADDR2;		  break;
+	P_FUTEX_OP(WAIT_BITSET);    arg->mask |= SCF_UADDR2;			  break;
+	P_FUTEX_OP(WAKE_BITSET);    arg->mask |= SCF_UADDR2;			  break;
 	P_FUTEX_OP(WAIT_REQUEUE_PI);						  break;
 	default: printed = scnprintf(bf, size, "%#x", cmd);			  break;
 	}
@@ -235,13 +232,12 @@ static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, unsigned lo
 #define SCA_FUTEX_OP  syscall_arg__scnprintf_futex_op
 
 static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
-					       unsigned long arg,
-					       u8 arg_idx, u8 *arg_mask)
+					       struct syscall_arg *arg)
 {
-	int printed = 0, flags = arg;
+	int printed = 0, flags = arg->val;
 
 	if (!(flags & O_CREAT))
-		*arg_mask |= 1 << (arg_idx + 1); /* Mask the mode parm */
+		arg->mask |= 1 << (arg->idx + 1); /* Mask the mode parm */
 
 	if (flags == 0)
 		return scnprintf(bf, size, "RDONLY");
@@ -294,7 +290,7 @@ static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
 static struct syscall_fmt {
 	const char *name;
 	const char *alias;
-	size_t	   (*arg_scnprintf[6])(char *bf, size_t size, unsigned long arg, u8 arg_idx, u8 *arg_mask);
+	size_t	   (*arg_scnprintf[6])(char *bf, size_t size, struct syscall_arg *arg);
 	bool	   errmsg;
 	bool	   timeout;
 	bool	   hexret;
@@ -364,8 +360,7 @@ struct syscall {
 	const char	    *name;
 	bool		    filtered;
 	struct syscall_fmt  *fmt;
-	size_t		    (**arg_scnprintf)(char *bf, size_t size,
-					      unsigned long arg, u8 arg_idx, u8 *args_mask);
+	size_t		    (**arg_scnprintf)(char *bf, size_t size, struct syscall_arg *arg);
 };
 
 static size_t fprintf_duration(unsigned long t, FILE *fp)
@@ -605,30 +600,35 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 				      unsigned long *args)
 {
-	int i = 0;
 	size_t printed = 0;
 
 	if (sc->tp_format != NULL) {
 		struct format_field *field;
-		u8 mask = 0, bit = 1;
+		u8 bit = 1;
+		struct syscall_arg arg = {
+			.idx  = 0,
+			.mask = 0,
+		};
 
 		for (field = sc->tp_format->format.fields->next; field;
-		     field = field->next, ++i, bit <<= 1) {
-			if (mask & bit)
+		     field = field->next, ++arg.idx, bit <<= 1) {
+			if (arg.mask & bit)
 				continue;
 
 			printed += scnprintf(bf + printed, size - printed,
 					     "%s%s: ", printed ? ", " : "", field->name);
-
-			if (sc->arg_scnprintf && sc->arg_scnprintf[i]) {
-				printed += sc->arg_scnprintf[i](bf + printed, size - printed,
-								args[i], i, &mask);
+			if (sc->arg_scnprintf && sc->arg_scnprintf[arg.idx]) {
+				arg.val = args[arg.idx];
+				printed += sc->arg_scnprintf[arg.idx](bf + printed,
+								      size - printed, &arg);
 			} else {
 				printed += scnprintf(bf + printed, size - printed,
-						     "%ld", args[i]);
+						     "%ld", args[arg.idx]);
 			}
 		}
 	} else {
+		int i = 0;
+
 		while (i < 6) {
 			printed += scnprintf(bf + printed, size - printed,
 					     "%sarg%d: %ld",
