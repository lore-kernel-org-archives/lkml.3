Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbaALSnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:43:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaALSnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:43:45 -0500
Date: Sun, 12 Jan 2014 10:43:06 -0800
From: tip-bot for Yann Droneaud <tipbot@zytor.com>
Message-ID: <tip-a21b0b354d4ac39be691f51c53562e2c24443d9e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        acme@ghostprotocols.net, ydroneaud@opteya.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        acme@ghostprotocols.net, peterz@infradead.org, ydroneaud@opteya.com,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com>
References: <8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Introduce a flag to enable close-on-exec in perf_event_open()
Git-Commit-ID: a21b0b354d4ac39be691f51c53562e2c24443d9e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:43:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a21b0b354d4ac39be691f51c53562e2c24443d9e
Gitweb:     http://git.kernel.org/tip/a21b0b354d4ac39be691f51c53562e2c24443d9e
Author:     Yann Droneaud <ydroneaud@opteya.com>
AuthorDate: Sun, 5 Jan 2014 21:36:33 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 12 Jan 2014 10:16:59 +0100

perf: Introduce a flag to enable close-on-exec in perf_event_open()

Unlike recent modern userspace API such as:

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

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/uapi/linux/perf_event.h |  1 +
 kernel/events/core.c            | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index e1802d6..ca018b4 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -724,6 +724,7 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_NO_GROUP		(1U << 0)
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
+#define PERF_FLAG_FD_CLOEXEC		(1U << 3) /* O_CLOEXEC */
 
 union perf_mem_data_src {
 	__u64 val;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c3b6c27..5c87264 100644
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
@@ -6982,6 +6983,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	int event_fd;
 	int move_group = 0;
 	int err;
+	int f_flags = O_RDWR;
 
 	/* for future expandability... */
 	if (flags & ~PERF_FLAG_ALL)
@@ -7010,7 +7012,10 @@ SYSCALL_DEFINE5(perf_event_open,
 	if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
 		return -EINVAL;
 
-	event_fd = get_unused_fd();
+	if (flags & PERF_FLAG_FD_CLOEXEC)
+		f_flags |= O_CLOEXEC;
+
+	event_fd = get_unused_fd_flags(f_flags);
 	if (event_fd < 0)
 		return event_fd;
 
@@ -7132,7 +7137,8 @@ SYSCALL_DEFINE5(perf_event_open,
 			goto err_context;
 	}
 
-	event_file = anon_inode_getfile("[perf_event]", &perf_fops, event, O_RDWR);
+	event_file = anon_inode_getfile("[perf_event]", &perf_fops, event,
+					f_flags);
 	if (IS_ERR(event_file)) {
 		err = PTR_ERR(event_file);
 		goto err_context;
