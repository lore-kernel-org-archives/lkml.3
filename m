Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaHXTuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 15:50:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbaHXTuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 15:50:04 -0400
Date: Sun, 24 Aug 2014 21:47:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] x86, fpu: sanitize the usage of use_eager_fpu() in
	switch_fpu_prepare()
Message-ID: <20140824194747.GA27458@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140824194700.GA27281@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

switch_fpu_prepare() calls use_eager_fpu() 3 times, and every call
is confusing.

1st: "tsk_used_math(new) && use_eager_fpu()" is pointless, eagerfpu
     means that used_math() is also true.

2nd: !fpu.preload && use_eager_fpu() is not possible, we do not need
     to check use_eager_fpu() before use_eager_fpu(). IOW, !preload
     alway means !use_eager_fpu(), so this check only adds more
     confusion.

3rd: If __thread_has_fpu(old) == F then use_eager_fpu() is false too,
     no need to check it before fpu_lazy_restore(). IOW, the "else"
     branch is simply impossible if use_eager_fpu().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/fpu-internal.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index ae6bd35..7b95a87 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -424,8 +424,8 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
 	 * If the task has used the math, pre-load the FPU on xsave processors
 	 * or if the past 5 consecutive context-switches used math.
 	 */
-	fpu.preload = tsk_used_math(new) && (use_eager_fpu() ||
-					     new->thread.fpu_counter > 5);
+	fpu.preload = use_eager_fpu() ||
+			(tsk_used_math(new) && new->thread.fpu_counter > 5);
 	if (__thread_has_fpu(old)) {
 		if (!__save_init_fpu(old))
 			cpu = ~0;
@@ -437,14 +437,14 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
 			new->thread.fpu_counter++;
 			__thread_set_has_fpu(new);
 			prefetch(new->thread.fpu.state);
-		} else if (!use_eager_fpu())
+		} else
 			stts();
 	} else {
 		old->thread.fpu_counter = 0;
 		old->thread.fpu.last_cpu = ~0;
 		if (fpu.preload) {
 			new->thread.fpu_counter++;
-			if (!use_eager_fpu() && fpu_lazy_restore(new, cpu))
+			if (fpu_lazy_restore(new, cpu))
 				fpu.preload = 0;
 			else
 				prefetch(new->thread.fpu.state);
-- 
1.5.5.1

