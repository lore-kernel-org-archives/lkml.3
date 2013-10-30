Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3J3VgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:36:24 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:51662 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab3J3VgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:36:23 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yann Droneaud <ydroneaud@opteya.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: [PATCH] events: add a flag to perf_event_open() to set O_CLOEXEC
Date: Wed, 30 Oct 2013 22:35:50 +0100
Message-Id: <1383168950-8933-1-git-send-email-ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.1.4
References: <cover.1383121137.git.ydroneaud@opteya.com> <3b0bc009ff1410d04f8a1e71bfae0d27e1254b90.1383121137.git.ydroneaud@opteya.com> <20131030202041.GS16117@laptop.programming.kicks-ass.net> <94b641a81a06ba4943cf77e80bc271c8@meuh.org>
In-Reply-To: <94b641a81a06ba4943cf77e80bc271c8@meuh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds PERF_FLAG_FD_CLOEXEC flag for
perf_event_open() syscall.

perf_event_open() creates a new file descriptor,
but unlike open() syscall, it lack a flag to atomicaly
set close-on-exec (O_CLOEXEC).

Not using O_CLOEXEC by default and not letting userspace
provide the "open" flags should be avoided: in most case
O_CLOEXEC must be used to not leak file descriptor across
exec().

Using O_CLOEXEC when creating a file descriptor allows
userspace to set latter, using fcntl(), without any risk
of race, if the file descriptor is going to be inherited
or not across exec().

Link: http://lkml.kernel.org/r/94b641a81a06ba4943cf77e80bc271c8@meuh.org
Link: http://lkml.kernel.org/r/cover.1383121137.git.ydroneaud@opteya.com
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---

Hi Peter,

This patch should replaces
"[PATCH v4 6/7] events: use get_unused_fd_flags(0) instead of get_unused_fd()"

Please have a look.

Regards.

 include/uapi/linux/perf_event.h |  1 +
 kernel/events/core.c            | 11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 009a655..c217765 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -699,6 +699,7 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_NO_GROUP		(1U << 0)
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
+#define PERF_FLAG_FD_CLOEXEC		(1U << 3) /* O_CLOEXEC */
 
 union perf_mem_data_src {
 	__u64 val;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 953c143..44de88c 100644
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
@@ -6933,6 +6934,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	int event_fd;
 	int move_group = 0;
 	int err;
+	int fd_flags;
 
 	/* for future expandability... */
 	if (flags & ~PERF_FLAG_ALL)
@@ -6961,7 +6963,9 @@ SYSCALL_DEFINE5(perf_event_open,
 	if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
 		return -EINVAL;
 
-	event_fd = get_unused_fd();
+	fd_flags = (flags & PERF_FLAG_FD_CLOEXEC) ? O_CLOEXEC : 0;
+
+	event_fd = get_unused_fd_flags(fd_flags);
 	if (event_fd < 0)
 		return event_fd;
 
@@ -7083,7 +7087,8 @@ SYSCALL_DEFINE5(perf_event_open,
 			goto err_context;
 	}
 
-	event_file = anon_inode_getfile("[perf_event]", &perf_fops, event, O_RDWR);
+	event_file = anon_inode_getfile("[perf_event]", &perf_fops, event,
+					O_RDWR | fd_flags);
 	if (IS_ERR(event_file)) {
 		err = PTR_ERR(event_file);
 		goto err_context;
-- 
1.8.1.4

