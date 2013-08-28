Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab3H1PEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:04:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40588 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab3H1O7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:59:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 16/21] perf trace: Allow overiding the formatting of syscall fields
Date: Wed, 28 Aug 2013 11:59:32 -0300
Message-Id: <1377701977-2085-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377701977-2085-1-git-send-email-acme@infradead.org>
References: <1377701977-2085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The mmap syscalls, for instance, don't have the FORMAT_IS_POINTER for
its pointer arguments, override it.

This also paves the way for more specialized argument beautifiers, like
for mmap's prot and flags arguments.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-mm864hvhrpt39muxmmbtjasz@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2d759f5..60ee811 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -17,24 +17,35 @@ static size_t syscall_arg__scnprintf_hex(char *bf, size_t size, unsigned long ar
 	return scnprintf(bf, size, "%#lx", arg);
 }
 
+#define SCA_HEX syscall_arg__scnprintf_hex
+
 static struct syscall_fmt {
 	const char *name;
 	const char *alias;
+	size_t	   (*arg_scnprintf[6])(char *bf, size_t size, unsigned long arg);
 	bool	   errmsg;
 	bool	   timeout;
 	bool	   hexret;
 } syscall_fmts[] = {
 	{ .name	    = "access",	    .errmsg = true, },
 	{ .name	    = "arch_prctl", .errmsg = true, .alias = "prctl", },
-	{ .name	    = "brk",	    .hexret = true, },
+	{ .name	    = "brk",	    .hexret = true,
+	  .arg_scnprintf = { [0] = SCA_HEX, /* brk */ }, },
 	{ .name	    = "mmap",	    .hexret = true, },
 	{ .name	    = "connect",    .errmsg = true, },
 	{ .name	    = "fstat",	    .errmsg = true, .alias = "newfstat", },
 	{ .name	    = "fstatat",    .errmsg = true, .alias = "newfstatat", },
 	{ .name	    = "futex",	    .errmsg = true, },
+	{ .name	    = "ioctl",	    .errmsg = true,
+	  .arg_scnprintf = { [2] = SCA_HEX, /* arg */ }, },
 	{ .name	    = "lstat",	    .errmsg = true, .alias = "newlstat", },
-	{ .name	    = "mmap",	    .hexret = true, },
+	{ .name	    = "mmap",	    .hexret = true,
+	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
+	{ .name	    = "mprotect",   .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
 	{ .name	    = "mremap",	    .hexret = true, },
+	{ .name	    = "munmap",	    .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
 	{ .name	    = "open",	    .errmsg = true, },
 	{ .name	    = "poll",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "ppoll",	    .errmsg = true, .timeout = true, },
@@ -232,7 +243,9 @@ static int syscall__set_arg_fmts(struct syscall *sc)
 		return -1;
 
 	for (field = sc->tp_format->format.fields->next; field; field = field->next) {
-		if (field->flags & FIELD_IS_POINTER)
+		if (sc->fmt && sc->fmt->arg_scnprintf[idx])
+			sc->arg_scnprintf[idx] = sc->fmt->arg_scnprintf[idx];
+		else if (field->flags & FIELD_IS_POINTER)
 			sc->arg_scnprintf[idx] = syscall_arg__scnprintf_hex;
 		++idx;
 	}
-- 
1.8.1.4

