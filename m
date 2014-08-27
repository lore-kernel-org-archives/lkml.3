Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964936AbaH0Sy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:54:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964884AbaH0SyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:54:24 -0400
Date: Wed, 27 Aug 2014 20:51:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
Cc: Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86, fpu: copy_process: avoid fpu_alloc/copy if
	!used_math()
Message-ID: <20140827185158.GA12512@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140827185138.GA12487@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/kernel/process.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 08c5ded..60076b4 100644
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
-- 
1.5.5.1

