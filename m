Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab3JNUe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:34:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38855 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523Ab3JNUDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 067/161] perf trace: Beautify send/recv syscall 'flags' arg
Date: Mon, 14 Oct 2013 17:00:56 -0300
Message-Id: <1381780950-25642-68-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

 [root@sandy ~]# perf trace -a -e recvmmsg,recvmsg,recvfrom,sendto,sendmsg,sendmmsg
  6.901 (0.002 ms): 589 recvmsg(fd: 51, msg: 0x7fff35673420, flags: CMSG_CLOEXEC) = -1 EAGAIN Resource temporarily unavailable
  6.966 (0.008 ms): 589 sendmsg(fd: 50, msg: 0x7fff35673230, flags: NOSIGNAL    ) = 961
  6.984 (0.004 ms): 979 sendmsg(fd: 3, msg: 0x7fff5b484940, flags: NOSIGNAL     ) = 945

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-h25k5k50nac0ej5cl5iwgvae@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 67 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 516f6b39b4b6..c400fbee1fc7 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -319,6 +319,60 @@ static size_t syscall_arg__scnprintf_socket_type(char *bf, size_t size,
 
 #define SCA_SK_TYPE syscall_arg__scnprintf_socket_type
 
+#ifndef MSG_PROBE
+#define MSG_PROBE	     0x10
+#endif
+#ifndef MSG_SENDPAGE_NOTLAST
+#define MSG_SENDPAGE_NOTLAST 0x20000
+#endif
+#ifndef MSG_FASTOPEN
+#define MSG_FASTOPEN	     0x20000000
+#endif
+
+static size_t syscall_arg__scnprintf_msg_flags(char *bf, size_t size,
+					       struct syscall_arg *arg)
+{
+	int printed = 0, flags = arg->val;
+
+	if (flags == 0)
+		return scnprintf(bf, size, "NONE");
+#define	P_MSG_FLAG(n) \
+	if (flags & MSG_##n) { \
+		printed += scnprintf(bf + printed, size - printed, "%s%s", printed ? "|" : "", #n); \
+		flags &= ~MSG_##n; \
+	}
+
+	P_MSG_FLAG(OOB);
+	P_MSG_FLAG(PEEK);
+	P_MSG_FLAG(DONTROUTE);
+	P_MSG_FLAG(TRYHARD);
+	P_MSG_FLAG(CTRUNC);
+	P_MSG_FLAG(PROBE);
+	P_MSG_FLAG(TRUNC);
+	P_MSG_FLAG(DONTWAIT);
+	P_MSG_FLAG(EOR);
+	P_MSG_FLAG(WAITALL);
+	P_MSG_FLAG(FIN);
+	P_MSG_FLAG(SYN);
+	P_MSG_FLAG(CONFIRM);
+	P_MSG_FLAG(RST);
+	P_MSG_FLAG(ERRQUEUE);
+	P_MSG_FLAG(NOSIGNAL);
+	P_MSG_FLAG(MORE);
+	P_MSG_FLAG(WAITFORONE);
+	P_MSG_FLAG(SENDPAGE_NOTLAST);
+	P_MSG_FLAG(FASTOPEN);
+	P_MSG_FLAG(CMSG_CLOEXEC);
+#undef P_MSG_FLAG
+
+	if (flags)
+		printed += scnprintf(bf + printed, size - printed, "%s%#x", printed ? "|" : "", flags);
+
+	return printed;
+}
+
+#define SCA_MSG_FLAGS syscall_arg__scnprintf_msg_flags
+
 static size_t syscall_arg__scnprintf_access_mode(char *bf, size_t size,
 						 struct syscall_arg *arg)
 {
@@ -512,7 +566,12 @@ static struct syscall_fmt {
 	  .arg_parm	 = { [1] = &strarray__rlimit_resources, /* resource */ }, },
 	{ .name	    = "pwrite",	    .errmsg = true, .alias = "pwrite64", },
 	{ .name	    = "read",	    .errmsg = true, },
-	{ .name	    = "recvfrom",   .errmsg = true, },
+	{ .name	    = "recvfrom",   .errmsg = true,
+	  .arg_scnprintf = { [3] = SCA_MSG_FLAGS, /* flags */ }, },
+	{ .name	    = "recvmmsg",   .errmsg = true,
+	  .arg_scnprintf = { [3] = SCA_MSG_FLAGS, /* flags */ }, },
+	{ .name	    = "recvmsg",    .errmsg = true,
+	  .arg_scnprintf = { [2] = SCA_MSG_FLAGS, /* flags */ }, },
 	{ .name	    = "rt_sigaction", .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_SIGNUM, /* sig */ }, },
 	{ .name	    = "rt_sigprocmask", .errmsg = true,
@@ -523,6 +582,12 @@ static struct syscall_fmt {
 	{ .name	    = "rt_tgsigqueueinfo", .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_SIGNUM, /* sig */ }, },
 	{ .name	    = "select",	    .errmsg = true, .timeout = true, },
+	{ .name	    = "sendmmsg",    .errmsg = true,
+	  .arg_scnprintf = { [3] = SCA_MSG_FLAGS, /* flags */ }, },
+	{ .name	    = "sendmsg",    .errmsg = true,
+	  .arg_scnprintf = { [2] = SCA_MSG_FLAGS, /* flags */ }, },
+	{ .name	    = "sendto",	    .errmsg = true,
+	  .arg_scnprintf = { [3] = SCA_MSG_FLAGS, /* flags */ }, },
 	{ .name	    = "setitimer",  .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* which */ },
 	  .arg_parm	 = { [0] = &strarray__itimers, /* which */ }, },
-- 
1.8.1.4

