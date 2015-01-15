Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbbAOTUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:20:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637AbbAOTUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:20:52 -0500
Date: Thu, 15 Jan 2015 20:19:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: [PATCH 1/3] x86, fpu: introduce per-cpu "bool in_kernel_fpu"
Message-ID: <20150115191943.GB27332@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <20150115191918.GA27332@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115191918.GA27332@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/include/asm/i387.h |    2 +-
 arch/x86/kernel/i387.c      |    9 +++++++++
 2 files changed, 10 insertions(+), 1 deletions(-)

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
 
-- 
1.5.5.1


