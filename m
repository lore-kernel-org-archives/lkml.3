Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab3JOFWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:22:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32805 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542Ab3JOFW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:22:28 -0400
Date: Mon, 14 Oct 2013 22:21:25 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-cbn57082gq9v0sbsd67edwjq@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Beautify socket 'type' arg
Git-Commit-ID: a28b24b27869d7a2fc0e6a0cae714641c83791a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:21:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a28b24b27869d7a2fc0e6a0cae714641c83791a2
Gitweb:     http://git.kernel.org/tip/a28b24b27869d7a2fc0e6a0cae714641c83791a2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 4 Sep 2013 11:00:44 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:10:28 -0300

perf trace: Beautify socket 'type' arg

Taking into account the fact that the SOCK_ types can be overriden for
ABI reasons on MIPS and also masking and interpreting the socket flags
(NONBLOCK and CLOEXEC), printing whatever is left in the flags bits
as an hex number, or'ed.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-cbn57082gq9v0sbsd67edwjq@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 50 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6280166..2b19aef 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -265,6 +265,53 @@ static const char *socket_families[] = {
 };
 static DEFINE_STRARRAY(socket_families);
 
+#ifndef SOCK_TYPE_MASK
+#define SOCK_TYPE_MASK 0xf
+#endif
+
+static size_t syscall_arg__scnprintf_socket_type(char *bf, size_t size,
+						      struct syscall_arg *arg)
+{
+	size_t printed;
+	int type = arg->val,
+	    flags = type & ~SOCK_TYPE_MASK;
+
+	type &= SOCK_TYPE_MASK;
+	/*
+ 	 * Can't use a strarray, MIPS may override for ABI reasons.
+ 	 */
+	switch (type) {
+#define	P_SK_TYPE(n) case SOCK_##n: printed = scnprintf(bf, size, #n); break;
+	P_SK_TYPE(STREAM);
+	P_SK_TYPE(DGRAM);
+	P_SK_TYPE(RAW);
+	P_SK_TYPE(RDM);
+	P_SK_TYPE(SEQPACKET);
+	P_SK_TYPE(DCCP);
+	P_SK_TYPE(PACKET);
+#undef P_SK_TYPE
+	default:
+		printed = scnprintf(bf, size, "%#x", type);
+	}
+
+#define	P_SK_FLAG(n) \
+	if (flags & SOCK_##n) { \
+		printed += scnprintf(bf + printed, size - printed, "|%s", #n); \
+		flags &= ~SOCK_##n; \
+	}
+
+	P_SK_FLAG(CLOEXEC);
+	P_SK_FLAG(NONBLOCK);
+#undef P_SK_FLAG
+
+	if (flags)
+		printed += scnprintf(bf + printed, size - printed, "|%#x", flags);
+
+	return printed;
+}
+
+#define SCA_SK_TYPE syscall_arg__scnprintf_socket_type
+
 static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
 					       struct syscall_arg *arg)
 {
@@ -440,7 +487,8 @@ static struct syscall_fmt {
 	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* which */ },
 	  .arg_parm	 = { [0] = &strarray__itimers, /* which */ }, },
 	{ .name	    = "socket",	    .errmsg = true,
-	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* family */ },
+	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* family */
+			     [1] = SCA_SK_TYPE, /* type */ },
 	  .arg_parm	 = { [0] = &strarray__socket_families, /* family */ }, },
 	{ .name	    = "stat",	    .errmsg = true, .alias = "newstat", },
 	{ .name	    = "tgkill",	    .errmsg = true,
