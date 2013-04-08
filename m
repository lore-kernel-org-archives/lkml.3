Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935159Ab3DHJY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:24:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:33295 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934484Ab3DHJY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:24:26 -0400
Date: Mon, 8 Apr 2013 11:24:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Dave Hansen <dave@sr71.net>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, dhillf@gmail.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: kernel BUG at kernel/smpboot.c:134!
In-Reply-To: <20130407095025.GA31307@pd.tnic>
Message-ID: <alpine.LFD.2.02.1304081122040.21884@ionos>
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Apr 2013, Borislav Petkov wrote:

> On Sun, Apr 07, 2013 at 11:20:10AM +0200, Thomas Gleixner wrote:
> > And it's even more bogus because the cpu to which we would bind in
> > kthread_create_on_cpu() is not yet online.
> 
> In case you guys are wondering about reproducibility, I saw the same
> BUG_ON yesterday on a 32-bit atom smp qemu guest too (don't ask why?
> :-))

I don't have to ask. It's caused by massive brain failure on my side.

Does the patch below fix the issue ?

Thanks,

	tglx
---
Index: linux-2.6/kernel/kthread.c
===================================================================
--- linux-2.6.orig/kernel/kthread.c
+++ linux-2.6/kernel/kthread.c
@@ -131,8 +131,14 @@ static void __kthread_parkme(struct kthr
 		schedule();
 		__set_current_state(TASK_INTERRUPTIBLE);
 	}
-	clear_bit(KTHREAD_IS_PARKED, &self->flags);
 	__set_current_state(TASK_RUNNING);
+	clear_bit(KTHREAD_IS_PARKED, &self->flags);
+
+	/* Rebind ourself to the target cpu */
+	if (test_bit(KTHREAD_IS_PER_CPU, &self->flags)) {
+		set_cpus_allowed_ptr(currrent, cpumask_of(self->cpu));
+		current->flags |= PF_THREAD_BOUND;
+	}
 }
 
 void kthread_parkme(void)
@@ -344,11 +350,8 @@ void kthread_unpark(struct task_struct *
 		 * park before that happens we'd see the IS_PARKED bit
 		 * which might be about to be cleared.
 		 */
-		if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
-			if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
-				__kthread_bind(k, kthread->cpu);
+		if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags))
 			wake_up_process(k);
-		}
 	}
 	put_task_struct(k);
 }
