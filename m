Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab3ENSGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:06:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab3ENSGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:06:45 -0400
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        Eric Paris <eparis@redhat.com>
Subject: [PATCH] fork: reorder permissions when violating number of processes limits
Date: Tue, 14 May 2013 14:06:11 -0400
Message-Id: <1368554771-19738-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a task is attempting to violate the RLIMIT_NPROC limit we have a
check to see if the task is sufficiently priviledged.  The check first
looks at CAP_SYS_ADMIN, then CAP_SYS_RESOURCE, then if the task is
uid=0.  A result is that tasks which are allowed by the uid=0 check are
first checked against the security subsystem.  This results in the
security subsystem auditting a denial for sys_admin and sys_resource and
then the task passing the uid=0 check.  This patch rearrainges the code
to first check uid=0, since if we pass that we shouldn't hit the
security system at all.  We then check sys_resource, since it is the
smallest capability which will solve the problem.  Lastly we check the
fallback everything cap_sysadmin.  We don't want to give this capability
many places since it is so powerful.  This will eliminate many of the
false positive/needless denial messages we get when a root task tries to
violate the nproc limit.  (note that kthreads count against root, so on
a sufficiently large machine we can actually get past the default limits
before any userspace tasks are launched.)

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 kernel/fork.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 987b28a..09dbda3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1199,8 +1199,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	retval = -EAGAIN;
 	if (atomic_read(&p->real_cred->user->processes) >=
 			task_rlimit(p, RLIMIT_NPROC)) {
-		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
-		    p->real_cred->user != INIT_USER)
+		if (p->real_cred->user != INIT_USER &&
+		    !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
 			goto bad_fork_free;
 	}
 	current->flags &= ~PF_NPROC_EXCEEDED;
-- 
1.8.2.1

