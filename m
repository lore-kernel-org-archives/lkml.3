Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbaLBEfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:35:36 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36285 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbaLBEfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:35:33 -0500
From: Alex Dubov <alex.dubov@gmail.com>
X-Google-Original-From: Alex Dubov <oakad@yahoo.com>
To: linux-kernel@vger.kernel.org
Cc: alex.dubov@gmail.com, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 1/2] fs: introduce sendfd() syscall
Date: Tue,  2 Dec 2014 15:35:18 +1100
Message-Id: <1417494919-4577-2-git-send-email-oakad@yahoo.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Present patch introduces exceptionally easy to use, low latency and low
overhead mechanism for transferring file descriptors between cooperating
processes:

    int sendfd(pid_t pid, int sig, int fd)

Given a target process pid, the sendfd() syscall will create a duplicate
file descriptor in a target task's (referred by pid) file table pointing to
the file references by descriptor fd. Then, it will attempt to notify the
target task by issuing a Posix.1b real-time signal (sig), carrying the new
file descriptor as integer payload. If real-time signal can not be enqueued
at the destination signal queue, the newly created file descriptor will be
promptly closed.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 fs/Makefile  |  1 +
 fs/sendfd.c  | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 init/Kconfig | 11 ++++++++
 3 files changed, 94 insertions(+)
 create mode 100644 fs/sendfd.c

diff --git a/fs/Makefile b/fs/Makefile
index da0bbb4..bed05a8 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_ANON_INODES)	+= anon_inodes.o
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
 obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
+obj-$(CONFIG_SENDFD)		+= sendfd.o
 obj-$(CONFIG_AIO)               += aio.o
 obj-$(CONFIG_FILE_LOCKING)      += locks.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
diff --git a/fs/sendfd.c b/fs/sendfd.c
new file mode 100644
index 0000000..1e85484
--- /dev/null
+++ b/fs/sendfd.c
@@ -0,0 +1,82 @@
+/*
+ *  fs/sendfd.c
+ *
+ *  Copyright (C) 2014 Alex Dubov <oakad@yahoo.com>
+ *
+ */
+
+#include <linux/file.h>
+#include <linux/fdtable.h>
+#include <linux/syscalls.h>
+
+SYSCALL_DEFINE3(sendfd, pid_t, pid, int, sig, int, fd)
+{
+	struct siginfo s_info = {
+		.si_signo = sig,
+		.si_errno = 0,
+		.si_code = __SI_RT
+	};
+	struct file *src_file = NULL;
+	struct task_struct *dst_task = NULL;
+	struct files_struct *dst_files  = NULL;
+	unsigned long rlim = 0;
+	unsigned long flags = 0;
+	int rc = 0;
+
+	if ((sig < SIGRTMIN) || (sig > SIGRTMAX))
+		return -EINVAL;
+
+	s_info.si_pid = task_pid_vnr(current);
+	s_info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
+	s_info.si_int = -1;
+
+	src_file = fget(fd);
+	if (!src_file)
+		return -EBADF;
+
+	rcu_read_lock();
+	dst_task = find_task_by_vpid(pid);
+
+	if (!dst_task) {
+		rc = -ESRCH;
+		goto out_put_src_file;
+	}
+	get_task_struct(dst_task);
+	rcu_read_unlock();
+
+	dst_files = get_files_struct(dst_task);
+	if (!dst_files) {
+		rc = -EMFILE;
+		goto out_put_dst_task;
+	}
+
+	if (!lock_task_sighand(dst_task, &flags)) {
+		rc = -EMFILE;
+		goto out_put_dst_files;
+	}
+
+	rlim = task_rlimit(dst_task, RLIMIT_NOFILE);
+
+	unlock_task_sighand(dst_task, &flags);
+
+	rc = __alloc_fd(dst_task->files, 0, rlim, O_CLOEXEC);
+	if (rc < 0)
+		goto out_put_dst_files;
+
+	s_info.si_int = rc;
+
+	get_file(src_file);
+	__fd_install(dst_files, rc, src_file);
+	rc = kill_pid_info(sig, &s_info, task_pid(dst_task));
+
+	if (rc < 0)
+		__close_fd(dst_files, s_info.si_int);
+
+out_put_dst_files:
+	put_files_struct(dst_files);
+out_put_dst_task:
+	put_task_struct(dst_task);
+out_put_src_file:
+	fput(src_file);
+	return rc;
+}
diff --git a/init/Kconfig b/init/Kconfig
index 2081a4d..dfe8b6f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1525,6 +1525,17 @@ config EVENTFD
 
 	  If unsure, say Y.
 
+config SENDFD
+	bool "Enable sendfd() system call" if EXPERT
+	default y
+	help
+	  Enable the sendfd() system call that allows rapid duplication
+	  of file descriptor across process boundaries. The target process
+	  will receive a duplicate file descriptor delivered with one of
+	  Posix.1b real-time signals.
+
+	  If unsure, say Y.
+
 # syscall, maps, verifier
 config BPF_SYSCALL
 	bool "Enable bpf() system call" if EXPERT
-- 
1.8.3.2

