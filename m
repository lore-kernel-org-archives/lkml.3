Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaH2STH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:19:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbaH2STE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:19:04 -0400
Date: Fri, 29 Aug 2014 20:16:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Suresh Siddha <sbsiddha@gmail.com>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] x86, fpu: don't abuse ->has_fpu in
	__kernel_fpu_begin/end
Message-ID: <20140829181632.GC30659@redhat.com>
References: <20140827185138.GA12487@redhat.com> <CA+55aFwi-S27_maZXU+baOqPAYfi_NTGcfbnRnk45+B8+i4hVQ@mail.gmail.com> <20140828111628.GB15276@redhat.com> <20140829181533.GA30659@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140829181533.GA30659@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have in_kernel_fpu we can remove __thread_clear_has_fpu()
in __kernel_fpu_begin(). And this allow to replace the asymmetrical
and nontrivial use_eager_fpu+tsk_used_math check in kernel_fpu_end()
with the same __thread_has_fpu().

The logic becomes really simple afaics: if _begin() does save() then
_end() needs restore(), and this is controlled by __thread_has_fpu().

Also, with this patch __kernel_fpu_end() does restore_fpu_checking()
and WARNs if it fails instead of math_state_restore(). I think this
looks better because we no longer need __thread_fpu_begin(), and it
would be better to report the failure in this case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/i387.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 8fb8868..19dd36d 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -82,9 +82,7 @@ void __kernel_fpu_begin(void)
 
 	/* FIXME: race with math_state_restore()-like code */
 	if (__thread_has_fpu(me)) {
-		__thread_clear_has_fpu(me);
 		__save_init_fpu(me);
-		/* We do 'stts()' in __kernel_fpu_end() */
 	} else if (!use_eager_fpu()) {
 		this_cpu_write(fpu_owner_task, NULL);
 		clts();
@@ -94,17 +92,12 @@ EXPORT_SYMBOL(__kernel_fpu_begin);
 
 void __kernel_fpu_end(void)
 {
-	if (use_eager_fpu()) {
-		/*
-		 * For eager fpu, most the time, tsk_used_math() is true.
-		 * Restore the user math as we are done with the kernel usage.
-		 * At few instances during thread exit, signal handling etc,
-		 * tsk_used_math() is false. Those few places will take proper
-		 * actions, so we don't need to restore the math here.
-		 */
-		if (likely(tsk_used_math(current)))
-			math_state_restore();
-	} else {
+	struct task_struct *me = current;
+
+	if (__thread_has_fpu(me)) {
+		if (WARN_ON(restore_fpu_checking(me)))
+			drop_init_fpu(me);
+	} else if (!use_eager_fpu()) {
 		stts();
 	}
 
-- 
1.5.5.1


