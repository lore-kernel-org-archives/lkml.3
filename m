Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaBUUdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:33:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58582 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbaBUUdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:33:19 -0500
Date: Fri, 21 Feb 2014 12:32:38 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-6d35ab48090b10c5ea5604ed5d6e91f302dc6060@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        mtk.manpages@gmail.com
In-Reply-To: <20140214161929.GL27965@twins.programming.kicks-ass.net>
References: <20140214161929.GL27965@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Add 'flags' argument to sched_{set,
 get}attr() syscalls
Git-Commit-ID: 6d35ab48090b10c5ea5604ed5d6e91f302dc6060
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

Commit-ID:  6d35ab48090b10c5ea5604ed5d6e91f302dc6060
Gitweb:     http://git.kernel.org/tip/6d35ab48090b10c5ea5604ed5d6e91f302dc6060
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 14 Feb 2014 17:19:29 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:27:10 +0100

sched: Add 'flags' argument to sched_{set,get}attr() syscalls

Because of a recent syscall design debate; its deemed appropriate for
each syscall to have a flags argument for future extension; without
immediately requiring new syscalls.

Cc: juri.lelli@gmail.com
Cc: Ingo Molnar <mingo@redhat.com>
Suggested-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140214161929.GL27965@twins.programming.kicks-ass.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/syscalls.h |  6 ++++--
 kernel/sched/core.c      | 11 ++++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 40ed9e9..a747a77 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -281,13 +281,15 @@ asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
 asmlinkage long sys_sched_setparam(pid_t pid,
 					struct sched_param __user *param);
 asmlinkage long sys_sched_setattr(pid_t pid,
-					struct sched_attr __user *attr);
+					struct sched_attr __user *attr,
+					unsigned int flags);
 asmlinkage long sys_sched_getscheduler(pid_t pid);
 asmlinkage long sys_sched_getparam(pid_t pid,
 					struct sched_param __user *param);
 asmlinkage long sys_sched_getattr(pid_t pid,
 					struct sched_attr __user *attr,
-					unsigned int size);
+					unsigned int size,
+					unsigned int flags);
 asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 					unsigned long __user *user_mask_ptr);
 asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a6e7470..6edbef2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3661,13 +3661,14 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
  * @pid: the pid in question.
  * @uattr: structure containing the extended parameters.
  */
-SYSCALL_DEFINE2(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr)
+SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
+			       unsigned int, flags)
 {
 	struct sched_attr attr;
 	struct task_struct *p;
 	int retval;
 
-	if (!uattr || pid < 0)
+	if (!uattr || pid < 0 || flags)
 		return -EINVAL;
 
 	if (sched_copy_attr(uattr, &attr))
@@ -3804,8 +3805,8 @@ err_size:
  * @uattr: structure containing the extended parameters.
  * @size: sizeof(attr) for fwd/bwd comp.
  */
-SYSCALL_DEFINE3(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
-		unsigned int, size)
+SYSCALL_DEFINE4(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
+		unsigned int, size, unsigned int, flags)
 {
 	struct sched_attr attr = {
 		.size = sizeof(struct sched_attr),
@@ -3814,7 +3815,7 @@ SYSCALL_DEFINE3(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
 	int retval;
 
 	if (!uattr || pid < 0 || size > PAGE_SIZE ||
-	    size < SCHED_ATTR_SIZE_VER0)
+	    size < SCHED_ATTR_SIZE_VER0 || flags)
 		return -EINVAL;
 
 	rcu_read_lock();
