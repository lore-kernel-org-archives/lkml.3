Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab3ICHRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:17:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36116 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470Ab3ICHRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:17:03 -0400
Date: Tue, 3 Sep 2013 00:16:28 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-bgokqpkufd4sio7ixxknf1ux@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Tell arg formatters the arg index
Git-Commit-ID: 31cd3855c98119cae287b761d8d2e75018714c5d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 03 Sep 2013 00:16:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  31cd3855c98119cae287b761d8d2e75018714c5d
Gitweb:     http://git.kernel.org/tip/31cd3855c98119cae287b761d8d2e75018714c5d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 2 Sep 2013 16:40:40 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Sep 2013 16:40:40 -0300

perf trace: Tell arg formatters the arg index

... so that it can mask args relative to its position, like the 'mode' arg
that may or not be printed according to the 'flags' (O_CREAT) value.

 [root@zoo ~]# perf trace -a -e openat,open_by_handle_at | head -1
    469.754 ( 0.034 ms): 1183 openat(dfd: -100, filename: 0x7fbde40014b0, flags: CLOEXEC|DIRECTORY|NONBLOCK) = 23
 [root@zoo ~]#

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-bgokqpkufd4sio7ixxknf1ux@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 5b6b287..b6f0725 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -17,7 +17,9 @@
 #include <linux/futex.h>
 
 static size_t syscall_arg__scnprintf_hex(char *bf, size_t size,
-					 unsigned long arg, u8 *arg_mask __maybe_unused)
+					 unsigned long arg,
+					 u8 arg_idx __maybe_unused,
+					 u8 *arg_mask __maybe_unused)
 {
 	return scnprintf(bf, size, "%#lx", arg);
 }
@@ -25,7 +27,9 @@ static size_t syscall_arg__scnprintf_hex(char *bf, size_t size,
 #define SCA_HEX syscall_arg__scnprintf_hex
 
 static size_t syscall_arg__scnprintf_whence(char *bf, size_t size,
-					    unsigned long arg, u8 *arg_mask __maybe_unused)
+					    unsigned long arg,
+					    u8 arg_idx __maybe_unused,
+					    u8 *arg_mask __maybe_unused)
 {
 	int whence = arg;
 
@@ -50,7 +54,9 @@ static size_t syscall_arg__scnprintf_whence(char *bf, size_t size,
 #define SCA_WHENCE syscall_arg__scnprintf_whence
 
 static size_t syscall_arg__scnprintf_mmap_prot(char *bf, size_t size,
-					       unsigned long arg, u8 *arg_mask __maybe_unused)
+					       unsigned long arg,
+					       u8 arg_idx __maybe_unused,
+					       u8 *arg_mask __maybe_unused)
 {
 	int printed = 0, prot = arg;
 
@@ -81,7 +87,8 @@ static size_t syscall_arg__scnprintf_mmap_prot(char *bf, size_t size,
 #define SCA_MMAP_PROT syscall_arg__scnprintf_mmap_prot
 
 static size_t syscall_arg__scnprintf_mmap_flags(char *bf, size_t size,
-						unsigned long arg, u8 *arg_mask __maybe_unused)
+						unsigned long arg, u8 arg_idx __maybe_unused,
+						u8 *arg_mask __maybe_unused)
 {
 	int printed = 0, flags = arg;
 
@@ -122,7 +129,8 @@ static size_t syscall_arg__scnprintf_mmap_flags(char *bf, size_t size,
 #define SCA_MMAP_FLAGS syscall_arg__scnprintf_mmap_flags
 
 static size_t syscall_arg__scnprintf_madvise_behavior(char *bf, size_t size,
-						      unsigned long arg, u8 *arg_mask __maybe_unused)
+						      unsigned long arg, u8 arg_idx __maybe_unused,
+						      u8 *arg_mask __maybe_unused)
 {
 	int behavior = arg;
 
@@ -163,7 +171,8 @@ static size_t syscall_arg__scnprintf_madvise_behavior(char *bf, size_t size,
 
 #define SCA_MADV_BHV syscall_arg__scnprintf_madvise_behavior
 
-static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, unsigned long arg, u8 *arg_mask)
+static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, unsigned long arg,
+					      u8 arg_idx __maybe_unused, u8 *arg_mask)
 {
 	enum syscall_futex_args {
 		SCF_UADDR   = (1 << 0),
@@ -207,12 +216,13 @@ static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, unsigned lo
 #define SCA_FUTEX_OP  syscall_arg__scnprintf_futex_op
 
 static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
-					       unsigned long arg, u8 *arg_mask)
+					       unsigned long arg,
+					       u8 arg_idx, u8 *arg_mask)
 {
 	int printed = 0, flags = arg;
 
 	if (!(flags & O_CREAT))
-		*arg_mask |= 1 << 2; /* Mask the mode parm */
+		*arg_mask |= 1 << (arg_idx + 1); /* Mask the mode parm */
 
 	if (flags == 0)
 		return scnprintf(bf, size, "RDONLY");
@@ -265,7 +275,7 @@ static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
 static struct syscall_fmt {
 	const char *name;
 	const char *alias;
-	size_t	   (*arg_scnprintf[6])(char *bf, size_t size, unsigned long arg, u8 *arg_mask);
+	size_t	   (*arg_scnprintf[6])(char *bf, size_t size, unsigned long arg, u8 arg_idx, u8 *arg_mask);
 	bool	   errmsg;
 	bool	   timeout;
 	bool	   hexret;
@@ -302,6 +312,10 @@ static struct syscall_fmt {
 	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
 	{ .name	    = "open",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_OPEN_FLAGS, /* flags */ }, },
+	{ .name	    = "open_by_handle_at", .errmsg = true,
+	  .arg_scnprintf = { [2] = SCA_OPEN_FLAGS, /* flags */ }, },
+	{ .name	    = "openat",	    .errmsg = true,
+	  .arg_scnprintf = { [2] = SCA_OPEN_FLAGS, /* flags */ }, },
 	{ .name	    = "poll",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "ppoll",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "pread",	    .errmsg = true, .alias = "pread64", },
@@ -332,7 +346,7 @@ struct syscall {
 	bool		    filtered;
 	struct syscall_fmt  *fmt;
 	size_t		    (**arg_scnprintf)(char *bf, size_t size,
-					      unsigned long arg, u8 *args_mask);
+					      unsigned long arg, u8 arg_idx, u8 *args_mask);
 };
 
 static size_t fprintf_duration(unsigned long t, FILE *fp)
@@ -589,7 +603,7 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 
 			if (sc->arg_scnprintf && sc->arg_scnprintf[i]) {
 				printed += sc->arg_scnprintf[i](bf + printed, size - printed,
-								args[i], &mask);
+								args[i], i, &mask);
 			} else {
 				printed += scnprintf(bf + printed, size - printed,
 						     "%ld", args[i]);
