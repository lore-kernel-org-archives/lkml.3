Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaFYFyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:54:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36262 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbaFYFvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:51:08 -0400
Date: Tue, 24 Jun 2014 22:50:10 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-vcm22xpjxc3j4hbyuzjzf7ik@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Fix up fd -> pathname resolution
Git-Commit-ID: cdcd1e6bd8a92f8353fc2f37003c6eae2d1e6903
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cdcd1e6bd8a92f8353fc2f37003c6eae2d1e6903
Gitweb:     http://git.kernel.org/tip/cdcd1e6bd8a92f8353fc2f37003c6eae2d1e6903
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 10 Jun 2014 16:00:18 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Jun 2014 16:13:11 -0300

perf trace: Fix up fd -> pathname resolution

There was a brown paper bag bug in the patch that introduced a reference
implementation on using 'perf probe' made wannabe tracepoints that broke fd ->
pathname resolution, fix it:

  [root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
  Added new event:
    probe:vfs_getname    (on getname_flags:65 with pathname=result->name:string)

  You can now use it in all perf tools, such as:

	perf record -e probe:vfs_getname -aR sleep 1

  [root@zoo ~]

Before:

  [acme@zoo linux]$ trace touch -e open,fstat /tmp/b
     1.159 ( 0.007 ms): open(filename: 0x7fd73f2fe088, flags: CLOEXEC                         ) = 3
     1.163 ( 0.002 ms): fstat(fd: 3, statbuf: 0x7fff1b25e610                                  ) = 0
     1.192 ( 0.009 ms): open(filename: 0x7fd73f4fedb8, flags: CLOEXEC                         ) = 3
     1.201 ( 0.002 ms): fstat(fd: 3, statbuf: 0x7fff1b25e660                                  ) = 0
     1.501 ( 0.013 ms): open(filename: 0x7fd73f0a1610, flags: CLOEXEC                         ) = 3
     1.505 ( 0.002 ms): fstat(fd: 3, statbuf: 0x7fd73f2ddb60                                  ) = 0
     1.581 ( 0.011 ms): open(filename: 0x7fff1b2603da, flags: CREAT|NOCTTY|NONBLOCK|WRONLY, mode: 438) = 3
  [acme@zoo linux]$

After:

  [acme@zoo linux]$ trace touch -e open,fstat,dup2,mmap,close /tmp/b
     1.105 ( 0.004 ms): mmap(len: 4096, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: -1    ) = 0x2fbf000
     1.136 ( 0.008 ms): open(filename: 0x7f8902dbc088, flags: CLOEXEC                         ) = 3
     1.140 ( 0.002 ms): fstat(fd: 3</etc/ld.so.cache>, statbuf: 0x7fff19889ef0                ) = 0
     1.146 ( 0.004 ms): mmap(len: 86079, prot: READ, flags: PRIVATE, fd: 3</etc/ld.so.cache>  ) = 0x2fa9000
     1.149 ( 0.001 ms): close(fd: 3</etc/ld.so.cache>                                         ) = 0
     1.170 ( 0.010 ms): open(filename: 0x7f8902fbcdb8, flags: CLOEXEC                         ) = 3
     1.178 ( 0.002 ms): fstat(fd: 3</lib64/libc.so.6>, statbuf: 0x7fff19889f40                ) = 0
     1.188 ( 0.006 ms): mmap(len: 3924576, prot: EXEC|READ, flags: PRIVATE|DENYWRITE, fd: 3</lib64/libc.so.6>) = 0x29e2000
     1.207 ( 0.007 ms): mmap(addr: 0x7f8902d96000, len: 24576, prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3</lib64/libc.so.6>, off: 1785856) = 0x2d96000
     1.217 ( 0.004 ms): mmap(addr: 0x7f8902d9c000, len: 16992, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS|FIXED, fd: -1) = 0x2d9c000
     1.228 ( 0.002 ms): close(fd: 3</lib64/libc.so.6>                                         ) = 0
     1.243 ( 0.003 ms): mmap(len: 4096, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: -1    ) = 0x2fa8000
     1.250 ( 0.003 ms): mmap(len: 8192, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: -1    ) = 0x2fa6000
     1.452 ( 0.010 ms): open(filename: 0x7f8902b5f610, flags: CLOEXEC                         ) = 3
     1.455 ( 0.002 ms): fstat(fd: 3</usr/lib/locale/locale-archive>, statbuf: 0x7f8902d9bb60  ) = 0
     1.461 ( 0.004 ms): mmap(len: 106070960, prot: READ, flags: PRIVATE, fd: 3</usr/lib/locale/locale-archive>) = 0xfc4b9000
     1.469 ( 0.002 ms): close(fd: 3</usr/lib/locale/locale-archive>                           ) = 0
     1.528 ( 0.010 ms): open(filename: 0x7fff1988c3da, flags: CREAT|NOCTTY|NONBLOCK|WRONLY, mode: 438) = 3
     1.532 ( 0.002 ms): dup2(oldfd: 3</tmp/b>                                                 ) = 0
     1.535 ( 0.001 ms): close(fd: 3</tmp/b>                                                   ) = 0
     1.544 ( 0.001 ms): close(                                                                ) = 0
     1.555 ( 0.001 ms): close(fd: 1                                                           ) = 0
     1.558 ( 0.001 ms): close(fd: 2                                                           ) = 0
  [acme@zoo linux]$

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-vcm22xpjxc3j4hbyuzjzf7ik@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f954c26..5ab2f67 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1276,11 +1276,11 @@ static const char *thread__fd_path(struct thread *thread, int fd,
 	if (fd < 0)
 		return NULL;
 
-	if ((fd > ttrace->paths.max || ttrace->paths.table[fd] == NULL))
+	if ((fd > ttrace->paths.max || ttrace->paths.table[fd] == NULL)) {
 		if (!trace->live)
 			return NULL;
 		++trace->stats.proc_getname;
-		if (thread__read_fd_path(thread, fd)) {
+		if (thread__read_fd_path(thread, fd))
 			return NULL;
 	}
 
