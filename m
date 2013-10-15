Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab3JOF1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:27:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33257 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3JOF1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:27:45 -0400
Date: Mon, 14 Oct 2013 22:27:06 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-88xz9phc8cbicnxonud6if8h@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Beautify epoll_ctl 'op' arg
Git-Commit-ID: eac032c54be48e899a7be2b8db4b746be1b51748
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:27:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eac032c54be48e899a7be2b8db4b746be1b51748
Gitweb:     http://git.kernel.org/tip/eac032c54be48e899a7be2b8db4b746be1b51748
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 20 Sep 2013 11:27:32 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 17:36:37 -0300

perf trace: Beautify epoll_ctl 'op' arg

[root@sandy ~]# perf trace -e epoll_ctl
 2.490 (0.003 ms): systemd-logind/586 epoll_ctl(epfd: 10, op: ADD, fd: 24, event: 0x7fff22314ef0) = 0
 2.621 (0.003 ms): systemd-logind/586 epoll_ctl(epfd: 10, op: DEL, fd: 24                       ) = 0
 2.833 (0.010 ms): systemd-logind/586 epoll_ctl(epfd: 10, op: ADD, fd: 24, event: 0x7fff22314cd0) = 0
 2.953 (0.002 ms): systemd-logind/586 epoll_ctl(epfd: 10, op: DEL, fd: 24                       ) = 0
 3.118 (0.002 ms): systemd-logind/586 epoll_ctl(epfd: 10, op: ADD, fd: 24, event: 0x7fff22314d20) = 0
 4.762 (0.002 ms): systemd-logind/586 epoll_ctl(epfd: 10, op: DEL, fd: 24                       ) = 0
^C[root@sandy ~]#

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-88xz9phc8cbicnxonud6if8h@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f3ddbb0..807e542 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -232,6 +232,9 @@ static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, struct sysc
 
 #define SCA_FUTEX_OP  syscall_arg__scnprintf_futex_op
 
+static const char *epoll_ctl_ops[] = { [1] = "ADD", "DEL", "MOD", };
+static DEFINE_STRARRAY(epoll_ctl_ops);
+
 static const char *itimers[] = { "REAL", "VIRTUAL", "PROF", };
 static DEFINE_STRARRAY(itimers);
 
@@ -543,6 +546,9 @@ static struct syscall_fmt {
 	{ .name	    = "brk",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* brk */ }, },
 	{ .name	    = "connect",    .errmsg = true, },
+	{ .name	    = "epoll_ctl",  .errmsg = true,
+	  .arg_scnprintf = { [1] = SCA_STRARRAY, /* op */ },
+	  .arg_parm	 = { [1] = &strarray__epoll_ctl_ops, /* op */ }, },
 	{ .name	    = "eventfd2",   .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_EFD_FLAGS, /* flags */ }, },
 	{ .name	    = "fcntl",	    .errmsg = true,
