Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbbATMzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:55:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57174 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbbATMzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:55:20 -0500
Date: Tue, 20 Jan 2015 04:55:01 -0800
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-33a3ebdc077fd85f1bf4d4586eea579b297461ae@git.kernel.org>
Cc: mingo@kernel.org, sbsiddha@gmail.com, riel@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, oleg@redhat.com
Reply-To: sbsiddha@gmail.com, riel@redhat.com, hpa@zytor.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20150115192005.GC27332@redhat.com>
References: <20150115192005.GC27332@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: Don't abuse has_fpu in __kernel_fpu_begin
 /end()
Git-Commit-ID: 33a3ebdc077fd85f1bf4d4586eea579b297461ae
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

Commit-ID:  33a3ebdc077fd85f1bf4d4586eea579b297461ae
Gitweb:     http://git.kernel.org/tip/33a3ebdc077fd85f1bf4d4586eea579b297461ae
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Thu, 15 Jan 2015 20:20:05 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 20 Jan 2015 13:53:07 +0100

x86, fpu: Don't abuse has_fpu in __kernel_fpu_begin/end()

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
Acked-by: Rik van Riel <riel@redhat.com>
Cc: matt.fleming@intel.com
Cc: bp@suse.de
Cc: pbonzini@redhat.com
Cc: luto@amacapital.net
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <sbsiddha@gmail.com>
Link: http://lkml.kernel.org/r/20150115192005.GC27332@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/i387.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

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
 
