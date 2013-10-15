Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab3JOFWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:22:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32782 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758476Ab3JOFWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:22:15 -0400
Date: Mon, 14 Oct 2013 22:21:33 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-ypaz9k43lyqy94679feqnv8x@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Beautify access 'mode' arg
Git-Commit-ID: 511089994e33c9dbfe2c6e1fb2fb00b5e53866e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:21:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  511089994e33c9dbfe2c6e1fb2fb00b5e53866e8
Gitweb:     http://git.kernel.org/tip/511089994e33c9dbfe2c6e1fb2fb00b5e53866e8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 4 Sep 2013 11:42:27 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:10:35 -0300

perf trace: Beautify access 'mode' arg

Removing the _OK suffix and using RWX when all three bits are set, for
instance.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ypaz9k43lyqy94679feqnv8x@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2b19aef..7aa6bca 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -312,6 +312,33 @@ static size_t syscall_arg__scnprintf_socket_type(char *bf, size_t size,
 
 #define SCA_SK_TYPE syscall_arg__scnprintf_socket_type
 
+static size_t syscall_arg__scnprintf_access_mode(char *bf, size_t size,
+						 struct syscall_arg *arg)
+{
+	size_t printed = 0;
+	int mode = arg->val;
+
+	if (mode == F_OK) /* 0 */
+		return scnprintf(bf, size, "F");
+#define	P_MODE(n) \
+	if (mode & n##_OK) { \
+		printed += scnprintf(bf + printed, size - printed, "%s", #n); \
+		mode &= ~n##_OK; \
+	}
+
+	P_MODE(R);
+	P_MODE(W);
+	P_MODE(X);
+#undef P_MODE
+
+	if (mode)
+		printed += scnprintf(bf + printed, size - printed, "|%#x", mode);
+
+	return printed;
+}
+
+#define SCA_ACCMODE syscall_arg__scnprintf_access_mode
+
 static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
 					       struct syscall_arg *arg)
 {
@@ -422,7 +449,8 @@ static struct syscall_fmt {
 	bool	   timeout;
 	bool	   hexret;
 } syscall_fmts[] = {
-	{ .name	    = "access",	    .errmsg = true, },
+	{ .name	    = "access",	    .errmsg = true,
+	  .arg_scnprintf = { [1] = SCA_ACCMODE, /* mode */ }, },
 	{ .name	    = "arch_prctl", .errmsg = true, .alias = "prctl", },
 	{ .name	    = "brk",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* brk */ }, },
