Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbaIBWTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:19:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40533 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbaIBWT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:19:28 -0400
Date: Tue, 2 Sep 2014 15:19:16 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-f1853505d9ca1c3ea27c29cf83c24661531c527b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sbsiddha@gmail.com, oleg@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sbsiddha@gmail.com, tglx@linutronix.de, oleg@redhat.com,
        hpa@linux.intel.com
In-Reply-To: <20140902175723.GA21659@redhat.com>
References: <20140902175723.GA21659@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: copy_process: Avoid fpu_alloc/
 copy if !used_math()
Git-Commit-ID: f1853505d9ca1c3ea27c29cf83c24661531c527b
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

Commit-ID:  f1853505d9ca1c3ea27c29cf83c24661531c527b
Gitweb:     http://git.kernel.org/tip/f1853505d9ca1c3ea27c29cf83c24661531c527b
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 2 Sep 2014 19:57:23 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 2 Sep 2014 14:51:16 -0700

x86, fpu: copy_process: Avoid fpu_alloc/copy if !used_math()

arch_dup_task_struct() copies thread.fpu if fpu_allocated(), this
looks suboptimal and misleading. Say, a forking process could use
FPU only once in a signal handler but now tsk_used_math(src) == F,
in this case the child gets a copy of fpu->state for no reason. The
child won't use the saved registers anyway even if it starts to use
FPU, this can only avoid fpu_alloc() in do_device_not_available().

Change this code to check tsk_used_math(current) instead. We still
need to clear fpu->has_fpu/state, we could do this memset(0) under
fpu_allocated() check but I think this doesn't make sense. See also
the next change.

use_eager_fpu() assumes that fpu_allocated() is always true, but a
forking task (and thus its child) must always have PF_USED_MATH set,
otherwise the child can either use FPU without used_math() (note that
switch_fpu_prepare() doesn't do stts() in this case), or it will be
killed by do_device_not_available()->BUG_ON(use_eager_fpu).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20140902175723.GA21659@redhat.com
Reviewed-by: Suresh Siddha <sbsiddha@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/process.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index f804dc9..b9ba9d5 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -64,14 +64,13 @@ EXPORT_SYMBOL_GPL(task_xstate_cachep);
  */
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
-	int ret;
-
 	*dst = *src;
-	if (fpu_allocated(&src->thread.fpu)) {
-		memset(&dst->thread.fpu, 0, sizeof(dst->thread.fpu));
-		ret = fpu_alloc(&dst->thread.fpu);
-		if (ret)
-			return ret;
+
+	memset(&dst->thread.fpu, 0, sizeof(dst->thread.fpu));
+	if (tsk_used_math(src)) {
+		int err = fpu_alloc(&dst->thread.fpu);
+		if (err)
+			return err;
 		fpu_copy(dst, src);
 	}
 	return 0;
