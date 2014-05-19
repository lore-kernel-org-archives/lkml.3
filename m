Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbaESNHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:07:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59240 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaESNH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:07:28 -0400
Date: Mon, 19 May 2014 06:06:30 -0700
From: tip-bot for Michael Kerrisk <tipbot@zytor.com>
Message-ID: <tip-51b2b2dc49a8a053de58b836be7efd2401a88699@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mtk.manpages@gmail.com
In-Reply-To: <536CEC17.9070903@gmail.com>
References: <536CEC17.9070903@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Make sched_setattr()
  correctly return -EFBIG
Git-Commit-ID: 51b2b2dc49a8a053de58b836be7efd2401a88699
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

Commit-ID:  51b2b2dc49a8a053de58b836be7efd2401a88699
Gitweb:     http://git.kernel.org/tip/51b2b2dc49a8a053de58b836be7efd2401a88699
Author:     Michael Kerrisk <mtk.manpages@gmail.com>
AuthorDate: Fri, 9 May 2014 16:54:15 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 21:47:33 +0900

sched: Make sched_setattr() correctly return -EFBIG

The documented[1] behavior of sched_attr() in your proposed man page text is:

    sched_attr::size must be set to the size of the structure, as in
    sizeof(struct sched_attr), if the provided structure is smaller
    than the kernel structure, any additional fields are assumed
    '0'. If the provided structure is larger than the kernel structure,
    the kernel verifies all additional fields are '0' if not the
    syscall will fail with -E2BIG.

As currently implemented, sched_copy_attr() returns -EFBIG for
for this case, but the logic in sys_sched_setattr() converts that
error to -EFAULT. This patch fixes the behavior.

[1] http://thread.gmane.org/gmane.linux.kernel/1615615/focus=1697760

Cc: stable@vger.kernel.org
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/536CEC17.9070903@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 13584f1..f2205f0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3658,8 +3658,9 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
 	if (!uattr || pid < 0 || flags)
 		return -EINVAL;
 
-	if (sched_copy_attr(uattr, &attr))
-		return -EFAULT;
+	retval = sched_copy_attr(uattr, &attr);
+	if (retval)
+		return retval;
 
 	rcu_read_lock();
 	retval = -ESRCH;
