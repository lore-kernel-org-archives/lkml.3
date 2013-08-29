Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab3H2KKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:10:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab3H2KK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:10:28 -0400
Date: Thu, 29 Aug 2013 03:09:47 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-mm864hvhrpt39muxmmbtjasz@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Allow overiding the formatting of syscall fields
Git-Commit-ID: beccb2b54a39ca5e49a7aa2912faa33617a45cc1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 03:09:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  beccb2b54a39ca5e49a7aa2912faa33617a45cc1
Gitweb:     http://git.kernel.org/tip/beccb2b54a39ca5e49a7aa2912faa33617a45cc1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 26 Aug 2013 12:29:38 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 26 Aug 2013 17:25:57 -0300

perf trace: Allow overiding the formatting of syscall fields

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
