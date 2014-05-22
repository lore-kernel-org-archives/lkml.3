Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaEVM0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:26:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51130 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbaEVMZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:25:58 -0400
Date: Thu, 22 May 2014 05:24:50 -0700
From: tip-bot for Michael Kerrisk <tipbot@zytor.com>
Message-ID: <tip-143cf23df25b7082cd706c3c53188e741e7881c3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        stable@vger.kernel.org, tglx@linutronix.de, mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        stable@vger.kernel.org, tglx@linutronix.de, mtk.manpages@gmail.com
In-Reply-To: <536CEC17.9070903@gmail.com>
References: <536CEC17.9070903@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Make sched_setattr()
  correctly return -EFBIG
Git-Commit-ID: 143cf23df25b7082cd706c3c53188e741e7881c3
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

Commit-ID:  143cf23df25b7082cd706c3c53188e741e7881c3
Gitweb:     http://git.kernel.org/tip/143cf23df25b7082cd706c3c53188e741e7881c3
Author:     Michael Kerrisk <mtk.manpages@gmail.com>
AuthorDate: Fri, 9 May 2014 16:54:15 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 22 May 2014 10:21:25 +0200

sched: Make sched_setattr() correctly return -EFBIG

The documented[1] behavior of sched_attr() in the proposed man page text is:

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

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/536CEC17.9070903@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
