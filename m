Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab3JNUiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:38:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38807 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616Ab3JNUDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 061/161] perf trace: Beautify socket 'type' arg
Date: Mon, 14 Oct 2013 17:00:50 -0300
Message-Id: <1381780950-25642-62-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
index 62801663bd46..2b19aef7d3b5 100644
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
-- 
1.8.1.4

