Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab3H2KKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:10:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35175 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab3H2KKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:10:13 -0400
Date: Thu, 29 Aug 2013 03:09:27 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-lfuveegw4od1t08n7bsmonrm@git.kernel.org>
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
  Allow printing syscall return values in hex
Git-Commit-ID: 04b34729e4584adfcb2e8ea908ff9478b1563001
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 03:09:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04b34729e4584adfcb2e8ea908ff9478b1563001
Gitweb:     http://git.kernel.org/tip/04b34729e4584adfcb2e8ea908ff9478b1563001
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 26 Aug 2013 11:36:30 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 26 Aug 2013 17:25:52 -0300

perf trace: Allow printing syscall return values in hex

event_format->flags has a FIELD_IS_POINTER, but it is not set for
the sys_exit 'ret' field in syscalls like mmap, so we need a way to
ask for hex printing for pointer returns and keep things like 'read'
returns printing in decimal.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-lfuveegw4od1t08n7bsmonrm@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 9e23660..b2038fd 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -22,13 +22,18 @@ static struct syscall_fmt {
 	const char *alias;
 	bool	   errmsg;
 	bool	   timeout;
+	bool	   hexret;
 } syscall_fmts[] = {
 	{ .name	    = "access",	    .errmsg = true, },
 	{ .name	    = "arch_prctl", .errmsg = true, .alias = "prctl", },
+	{ .name	    = "brk",	    .hexret = true, },
+	{ .name	    = "mmap",	    .hexret = true, },
 	{ .name	    = "connect",    .errmsg = true, },
 	{ .name	    = "fstat",	    .errmsg = true, .alias = "newfstat", },
 	{ .name	    = "fstatat",    .errmsg = true, .alias = "newfstatat", },
 	{ .name	    = "futex",	    .errmsg = true, },
+	{ .name	    = "mmap",	    .hexret = true, },
+	{ .name	    = "mremap",	    .hexret = true, },
 	{ .name	    = "open",	    .errmsg = true, },
 	{ .name	    = "poll",	    .errmsg = true, .timeout = true, },
 	{ .name	    = "ppoll",	    .errmsg = true, .timeout = true, },
@@ -475,6 +480,8 @@ signed_print:
 		fprintf(trace->output, ") = -1 %s %s", e, emsg);
 	} else if (ret == 0 && sc->fmt->timeout)
 		fprintf(trace->output, ") = 0 Timeout");
+	else if (sc->fmt->hexret)
+		fprintf(trace->output, ") = %#x", ret);
 	else
 		goto signed_print;
 
