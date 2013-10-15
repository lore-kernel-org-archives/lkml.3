Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab3JOFXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:23:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32843 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542Ab3JOFW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:22:56 -0400
Date: Mon, 14 Oct 2013 22:22:16 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-h25k5k50nac0ej5cl5iwgvae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Beautify send/recv syscall 'flags'
  arg
Git-Commit-ID: b2cc99fdaad20b6e787f0864a1ac7b14391f9fe6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:22:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2cc99fdaad20b6e787f0864a1ac7b14391f9fe6
Gitweb:     http://git.kernel.org/tip/b2cc99fdaad20b6e787f0864a1ac7b14391f9fe6
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 12 Sep 2013 11:54:48 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:11:13 -0300

perf trace: Beautify send/recv syscall 'flags' arg

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
index 516f6b3..c400fbe 100644
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
