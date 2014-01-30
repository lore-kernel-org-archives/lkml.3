Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaA3WCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:02:06 -0500
Received: from aurora.thatsmathematics.com ([162.209.10.89]:49889 "EHLO
	aurora.thatsmathematics.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767AbaA3WCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:02:04 -0500
Date: Thu, 30 Jan 2014 15:01:56 -0700 (MST)
From: Nate Eldredge <nate@thatsmathematics.com>
X-X-Sender: nate@minerva.lan
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maarten Baert <maarten-baert@hotmail.com>, jack@suse.cz,
        linux@horizon.com, Nate Eldredge <nate@thatsmathematics.com>,
        torvalds@linux-foundation.org, sbsiddha@gmail.com
Subject: [PATCH] Make math_state_restore() save and restore the interrupt
 flag
Message-ID: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nate Eldredge <nate@thatsmathematics.com>

Make math_state_restore() save and restore the interrupt flag, rather
than always disabling interrupts.

If math_state_restore() is called in a task that has not used math, it
needs to allocate some memory (via init_fpu()).  Since this can sleep,
it enables interrupts first.  Currently, it always disables them
afterwards, regardless of whether or not they were enabled on entry.
(See commit aa283f4927 where this was introduced.)  This doesn't make
sense, so instead have it put interrupts back the way they were.

This is the cause of Ubuntu bug #1265841
(https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1265841): if a
user process dumps core on an ecrypt fs while aesni-intel is loaded,
we get a BUG() in __find_get_block() complaining that it was called
with interrupts disabled; then all further accesses to our ecrypt fs
hang and we have to reboot.  The aesni-intel code (encrypting the core
file that we are writing) needs the FPU and quite properly wraps its
code in kernel_fpu_{begin,end}(), the latter of which calls
math_state_restore().  So after kernel_fpu_end(), interrupts may be
disabled, which nobody seems to expect, and they stay that way until
we eventually get to __find_get_block() which barfs.  With this patch,
the testcase works fine and no BUG() is triggered.

math_state_restore() may need further review, as it still seems
suspicious that it can unilaterally enable interupts for itself.  It's
not clear to me what are the intended semantics of
math_state_restore() and kernel_fpu_{begin,end}() with respect to
interrupts.  Nevertheless, this patch should be appropriate for now.

Signed-off-by: Nate Eldredge <nate@thatsmathematics.com>
Tested-by: George Spelvin <linux@horizon.com>
Cc: <stable@vger.kernel.org>
Fixes: aa283f4927

---

Applies to linux-3.13.  Previous discussion in linux-kernel thread
"math_state_restore and kernel_fpu_end disable interrupts?"

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b857ed8..09df67d 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -628,6 +628,9 @@ void math_state_restore(void)
  	struct task_struct *tsk = current;

  	if (!tsk_used_math(tsk)) {
+		unsigned long flags;
+
+		local_save_flags(flags);
  		local_irq_enable();
  		/*
  		 * does a slab alloc which can sleep
@@ -639,7 +642,7 @@ void math_state_restore(void)
  			do_group_exit(SIGKILL);
  			return;
  		}
-		local_irq_disable();
+		local_irq_restore(flags);
  	}

  	__thread_fpu_begin(tsk);


-- 
Nate Eldredge
nate@thatsmathematics.com

