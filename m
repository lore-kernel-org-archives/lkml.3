Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbbAOTVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:21:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637AbbAOTVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:21:08 -0500
Date: Thu, 15 Jan 2015 20:20:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: [PATCH 2/3] x86, fpu: don't abuse ->has_fpu in
	__kernel_fpu_{begin,end}()
Message-ID: <20150115192005.GC27332@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <20150115191918.GA27332@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115191918.GA27332@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have in_kernel_fpu we can remove __thread_clear_has_fpu()
in __kernel_fpu_begin(). And this allows to replace the asymmetrical
and nontrivial use_eager_fpu + tsk_used_math check in kernel_fpu_end()
with the same __thread_has_fpu() check.

The logic becomes really simple; if _begin() does save() then _end()
needs restore(), this is controlled by __thread_has_fpu(). Otherwise
they do clts/stts unless use_eager_fpu().

Not only this makes begin/end symmetrical and imo more understandable,
potentially this allows to change irq_fpu_usable() to avoid all other
checks except "in_kernel_fpu".

Also, with this patch __kernel_fpu_end() does restore_fpu_checking()
and WARNs if it fails instead of math_state_restore(). I think this
looks better because we no longer need __thread_fpu_begin(), and it
would be better to report the failure in this case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/i387.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index a815723..12088a3 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -81,9 +81,7 @@ void __kernel_fpu_begin(void)
 	this_cpu_write(in_kernel_fpu, true);
 
 	if (__thread_has_fpu(me)) {
-		__thread_clear_has_fpu(me);
 		__save_init_fpu(me);
-		/* We do 'stts()' in __kernel_fpu_end() */
 	} else if (!use_eager_fpu()) {
 		this_cpu_write(fpu_owner_task, NULL);
 		clts();
@@ -93,17 +91,12 @@ EXPORT_SYMBOL(__kernel_fpu_begin);
 
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


