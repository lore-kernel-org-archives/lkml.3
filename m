Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbbATMy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:54:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57152 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbbATMy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:54:56 -0500
Date: Tue, 20 Jan 2015 04:54:41 -0800
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-14e153ef75eecae8fd0738ffb42120f4962a00cd@git.kernel.org>
Cc: hpa@zytor.com, oleg@redhat.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, sbsiddha@gmail.com,
        linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org
Reply-To: tglx@linutronix.de, hpa@zytor.com, oleg@redhat.com,
        torvalds@linux-foundation.org, sbsiddha@gmail.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org
In-Reply-To: <20150115191943.GB27332@redhat.com>
References: <20150115191943.GB27332@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: Introduce per-cpu in_kernel_fpu state
Git-Commit-ID: 14e153ef75eecae8fd0738ffb42120f4962a00cd
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

Commit-ID:  14e153ef75eecae8fd0738ffb42120f4962a00cd
Gitweb:     http://git.kernel.org/tip/14e153ef75eecae8fd0738ffb42120f4962a00cd
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Thu, 15 Jan 2015 20:19:43 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 20 Jan 2015 13:53:07 +0100

x86, fpu: Introduce per-cpu in_kernel_fpu state

interrupted_kernel_fpu_idle() tries to detect if kernel_fpu_begin()
is safe or not. In particular it should obviously deny the nested
kernel_fpu_begin() and this logic looks very confusing.

If use_eager_fpu() == T we rely on a) __thread_has_fpu() check in
interrupted_kernel_fpu_idle(), and b) on the fact that _begin() does
__thread_clear_has_fpu().

Otherwise we demand that the interrupted task has no FPU if it is in
kernel mode, this works because __kernel_fpu_begin() does clts() and
interrupted_kernel_fpu_idle() checks X86_CR0_TS.

Add the per-cpu "bool in_kernel_fpu" variable, and change this code
to check/set/clear it. This allows to do more cleanups and fixes, see
the next changes.

The patch also moves WARN_ON_ONCE() under preempt_disable() just to
make this_cpu_read() look better, this is not really needed. And in
fact I think we should move it into __kernel_fpu_begin().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: matt.fleming@intel.com
Cc: bp@suse.de
Cc: pbonzini@redhat.com
Cc: luto@amacapital.net
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <sbsiddha@gmail.com>
Link: http://lkml.kernel.org/r/20150115191943.GB27332@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/i387.h | 2 +-
 arch/x86/kernel/i387.c      | 9 +++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index ed8089d..5e275d3 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -40,8 +40,8 @@ extern void __kernel_fpu_end(void);
 
 static inline void kernel_fpu_begin(void)
 {
-	WARN_ON_ONCE(!irq_fpu_usable());
 	preempt_disable();
+	WARN_ON_ONCE(!irq_fpu_usable());
 	__kernel_fpu_begin();
 }
 
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index a9a4229..a815723 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -19,6 +19,8 @@
 #include <asm/fpu-internal.h>
 #include <asm/user.h>
 
+static DEFINE_PER_CPU(bool, in_kernel_fpu);
+
 /*
  * Were we in an interrupt that interrupted kernel mode?
  *
@@ -33,6 +35,9 @@
  */
 static inline bool interrupted_kernel_fpu_idle(void)
 {
+	if (this_cpu_read(in_kernel_fpu))
+		return false;
+
 	if (use_eager_fpu())
 		return __thread_has_fpu(current);
 
@@ -73,6 +78,8 @@ void __kernel_fpu_begin(void)
 {
 	struct task_struct *me = current;
 
+	this_cpu_write(in_kernel_fpu, true);
+
 	if (__thread_has_fpu(me)) {
 		__thread_clear_has_fpu(me);
 		__save_init_fpu(me);
@@ -99,6 +106,8 @@ void __kernel_fpu_end(void)
 	} else {
 		stts();
 	}
+
+	this_cpu_write(in_kernel_fpu, false);
 }
 EXPORT_SYMBOL(__kernel_fpu_end);
 
