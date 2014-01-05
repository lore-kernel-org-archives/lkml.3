Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaAEUjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 15:39:40 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:59502 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaAEUjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 15:39:35 -0500
From: Yann Droneaud <ydroneaud@opteya.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCHv5 6/7] perf: introduce a flag to enable close-on-exec in perf_event_open()
Date: Sun,  5 Jan 2014 21:36:33 +0100
Message-Id: <8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <cover.1388952061.git.ydroneaud@opteya.com>
References: <cover.1388952061.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1388952061.git.ydroneaud@opteya.com>
References: <cover.1388952061.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike recent modern userspace API such as
  epoll_create1 (EPOLL_CLOEXEC), eventfd (EFD_CLOEXEC),
  fanotify_init (FAN_CLOEXEC), inotify_init1 (IN_CLOEXEC),
  signalfd (SFD_CLOEXEC), timerfd_create (TFD_CLOEXEC),
  or the venerable general purpose open (O_CLOEXEC),
perf_event_open() syscall lack a flag to atomically set FD_CLOEXEC
(eg. close-on-exec) flag on file descriptor it returns to userspace.

The present patch adds a PERF_FLAG_FD_CLOEXEC flag to allow
perf_event_open() syscall to atomically set close-on-exec.

Having this flag will enable userspace to remove the file descriptor
from the list of file descriptors being inherited across exec,
without the need to call fcntl(fd, F_SETFD, FD_CLOEXEC) and the
associated race condition between the current thread and another
thread calling fork(2) then execve(2).

Links:

 - Secure File Descriptor Handling (Ulrich Drepper, 2008)
   http://udrepper.livejournal.com/20407.html

 - Excuse me son, but your code is leaking !!! (Dan Walsh, March 2012)
   http://danwalsh.livejournal.com/53603.html

 - Notes in DMA buffer sharing: leak and security hole
   http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/dma-buf-sharing.txt?id=v3.13-rc3#n428

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Link: http://lkml.kernel.org/r/1383168950%2d8933-1-git-send-email-ydroneaud@opteya.com
Link: http://lkml.kernel.org/r/1383170413.9171.10.camel@dworkin
Link: http://lkml.kernel.org/r/cover.1388952061.git.ydroneaud@opteya.com
---
 include/uapi/linux/perf_event.h |  1 +
 kernel/events/core.c            | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 959d454f76a1..e244ed412745 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -725,6 +725,7 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_NO_GROUP		(1U << 0)
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
+#define PERF_FLAG_FD_CLOEXEC		(1U << 3) /* O_CLOEXEC */
 
 union perf_mem_data_src {
 	__u64 val;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4b743b299124..86e6a49abf8e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -119,7 +119,8 @@ static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
 
 #define PERF_FLAG_ALL (PERF_FLAG_FD_NO_GROUP |\
 		       PERF_FLAG_FD_OUTPUT  |\
-		       PERF_FLAG_PID_CGROUP)
+		       PERF_FLAG_PID_CGROUP |\
+		       PERF_FLAG_FD_CLOEXEC)
 
 /*
  * branch priv levels that need permission checks
@@ -6995,6 +6996,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	int event_fd;
 	int move_group = 0;
 	int err;
+	int f_flags = O_RDWR;
 
 	/* for future expandability... */
 	if (flags & ~PERF_FLAG_ALL)
@@ -7023,7 +7025,10 @@ SYSCALL_DEFINE5(perf_event_open,
 	if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
 		return -EINVAL;
 
-	event_fd = get_unused_fd();
+	if (flags & PERF_FLAG_FD_CLOEXEC)
+		f_flags |= O_CLOEXEC;
+
+	event_fd = get_unused_fd_flags(f_flags);
 	if (event_fd < 0)
 		return event_fd;
 
@@ -7145,7 +7150,8 @@ SYSCALL_DEFINE5(perf_event_open,
 			goto err_context;
 	}
 
-	event_file = anon_inode_getfile("[perf_event]", &perf_fops, event, O_RDWR);
+	event_file = anon_inode_getfile("[perf_event]", &perf_fops, event,
+					f_flags);
 	if (IS_ERR(event_file)) {
 		err = PTR_ERR(event_file);
 		goto err_context;
-- 
1.8.4.2

