Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab3JNU0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:26:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38946 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680Ab3JNUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 056/161] perf trace: Use strarray for ltrace's whence arg
Date: Mon, 14 Oct 2013 17:00:45 -0300
Message-Id: <1381780950-25642-57-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-5f9jhbq8my4ojarhtlygveox@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 386ca2058ee7..7cb60526a6f1 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -72,31 +72,6 @@ static size_t syscall_arg__scnprintf_hex(char *bf, size_t size,
 
 #define SCA_HEX syscall_arg__scnprintf_hex
 
-static size_t syscall_arg__scnprintf_whence(char *bf, size_t size,
-					    struct syscall_arg *arg)
-{
-	int whence = arg->val;
-
-	switch (whence) {
-#define P_WHENCE(n) case SEEK_##n: return scnprintf(bf, size, #n)
-	P_WHENCE(SET);
-	P_WHENCE(CUR);
-	P_WHENCE(END);
-#ifdef SEEK_DATA
-	P_WHENCE(DATA);
-#endif
-#ifdef SEEK_HOLE
-	P_WHENCE(HOLE);
-#endif
-#undef P_WHENCE
-	default: break;
-	}
-
-	return scnprintf(bf, size, "%#x", whence);
-}
-
-#define SCA_WHENCE syscall_arg__scnprintf_whence
-
 static size_t syscall_arg__scnprintf_mmap_prot(char *bf, size_t size,
 					       struct syscall_arg *arg)
 {
@@ -254,10 +229,20 @@ static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, struct sysc
 	return printed;
 }
 
+#define SCA_FUTEX_OP  syscall_arg__scnprintf_futex_op
+
 static const char *itimers[] = { "REAL", "VIRTUAL", "PROF", };
 static DEFINE_STRARRAY(itimers);
 
-#define SCA_FUTEX_OP  syscall_arg__scnprintf_futex_op
+static const char *whences[] = { "SET", "CUR", "END",
+#ifdef SEEK_DATA
+"DATA",
+#endif
+#ifdef SEEK_HOLE
+"HOLE",
+#endif
+};
+static DEFINE_STRARRAY(whences);
 
 static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
 					       struct syscall_arg *arg)
@@ -340,7 +325,8 @@ static struct syscall_fmt {
 	{ .name	    = "ioctl",	    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_HEX, /* arg */ }, },
 	{ .name	    = "lseek",	    .errmsg = true,
-	  .arg_scnprintf = { [2] = SCA_WHENCE, /* whence */ }, },
+	  .arg_scnprintf = { [2] = SCA_STRARRAY, /* whence */ },
+	  .arg_parm	 = { [2] = &strarray__whences, /* whence */ }, },
 	{ .name	    = "lstat",	    .errmsg = true, .alias = "newlstat", },
 	{ .name     = "madvise",    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX,	 /* start */
-- 
1.8.1.4

