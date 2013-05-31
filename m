Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab3EaTqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:46:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:39898 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab3EaTqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:46:12 -0400
Date: Fri, 31 May 2013 21:46:09 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.8.13-rt10
Message-ID: <20130531194609.GA24632@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.8.13-rt10 release.

changes since v3.8.13-rt9:
- x86's mce timer was not scheduled properly due do missing µsec -> nsec
  conversation. Fix sent by Mike Galbraith.
- 32bit PowerPC missed to check _TIF_NEED_RESCHED and call
  preempt_schedule_irq() if needed. Fix sent by Priyanka Jain.

Known issues:

    - SLxB is broken on PowerPC, e500 based cpus. Can't repdroduce the
      problem on mpc5200 based board.

The delta patch against v3.8.13-rt9 is appended below and can be found here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.13-rt9-rt10.patch.xz

The RT patch against 3.8.11 can be found here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13-rt10.patch.xz

The split quilt queue is available at:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patches-3.8.13-rt10.tar.xz

Sebastian

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 95b884e..086dce7 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -851,7 +851,7 @@ user_exc_return:		/* r10 contains MSR_KERNEL here */
 	/* check current_thread_info, _TIF_EMULATE_STACK_STORE */
 	CURRENT_THREAD_INFO(r9, r1)
 	lwz	r8,TI_FLAGS(r9)
-	andis.	r8,r8,_TIF_EMULATE_STACK_STORE@h
+	andis.	r0,r8,_TIF_EMULATE_STACK_STORE@h
 	beq+	1f
 
 	addi	r8,r1,INT_FRAME_SIZE	/* Get the kprobed function entry */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 332e133..f54c5bf 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1295,7 +1295,8 @@ static enum hrtimer_restart mce_timer_fn(struct hrtimer *timer)
 	__this_cpu_write(mce_next_interval, iv);
 	/* Might have become 0 after CMCI storm subsided */
 	if (iv) {
-		hrtimer_forward_now(timer, ns_to_ktime(jiffies_to_usecs(iv)));
+		hrtimer_forward_now(timer, ns_to_ktime(
+					jiffies_to_usecs(iv) * 1000ULL));
 		return HRTIMER_RESTART;
 	}
 	return HRTIMER_NORESTART;
@@ -1323,7 +1324,7 @@ void mce_timer_kick(unsigned long interval)
 		}
 	} else {
 		hrtimer_start_range_ns(t,
-				ns_to_ktime(jiffies_to_usecs(interval) * 1000),
+			ns_to_ktime(jiffies_to_usecs(interval) * 1000ULL),
 				0, HRTIMER_MODE_REL_PINNED);
 	}
 	if (interval < iv)
@@ -1691,7 +1692,7 @@ static void mce_start_timer(unsigned int cpu, struct hrtimer *t)
 	if (mca_cfg.ignore_ce || !iv)
 		return;
 
-	hrtimer_start_range_ns(t, ns_to_ktime(jiffies_to_usecs(iv) * 1000),
+	hrtimer_start_range_ns(t, ns_to_ktime(jiffies_to_usecs(iv) * 1000ULL),
 			0, HRTIMER_MODE_REL_PINNED);
 }
 
diff --git a/localversion-rt b/localversion-rt
index 22746d6..d79dde6 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt9
+-rt10
