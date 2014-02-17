Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaBQQ5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 11:57:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbaBQQ5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 11:57:44 -0500
Date: Mon, 17 Feb 2014 17:57:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Dave Jones <davej@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140217165735.GA29173@redhat.com>
References: <20140213174020.GA14455@redhat.com> <CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com> <20140215052531.GX18016@ZenIV.linux.org.uk> <20140215142700.GA15540@redhat.com> <20140215152251.GY18016@ZenIV.linux.org.uk> <20140215153631.GZ18016@ZenIV.linux.org.uk> <20140215155838.GA18016@ZenIV.linux.org.uk> <20140215174345.GA24799@redhat.com> <20140215180520.GC18016@ZenIV.linux.org.uk> <20140215184531.GA27314@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140215184531.GA27314@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Oleg Nesterov wrote:
>
> On 02/15, Al Viro wrote:
> >
> > On Sat, Feb 15, 2014 at 06:43:45PM +0100, Oleg Nesterov wrote:
> > > > So basically we want a different condition for "can we just go ahead and
> > > > free that sucker", right?  Instead of "it's on the list, shan't free it"
> > > > it ought to be something like "it's on the list or it is referenced by
> > > > ksiginfo".  Locking will be interesting, though... ;-/
> > >
> > > I guess yes... send_sigqueue() checks list_empty() too, probably nobody else.
> >
> > The trouble being, we might end up with
> > 	Q picked by collect_signal and and stuff into ksiginfo
> > 	Q resubmitted by timer code
>
> In this case the timer code should simply inc ->si_overrun and do nothing.
>
> IOW, list_empty() should be turned into is_queued(), and is_queued()
> should be true until dismiss_siginfo() which should also do
> do_schedule_next_timer(). I think.

No, this is even more complicated. We also need do_schedule_next_timer()
to calculate ->si_overrun we are going to report, I missed this...

Looks like, this is all is really nasty. Actually, I think siginfo on
stack is not that bad if we are going to do handle_signal() or restart,
perhaps we can do the extra kmalloc/memcpy/kfree for do_coredump().
Something like below.

Oleg.


diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 9e5de68..52f16f9 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -684,6 +684,52 @@ handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 	test_thread_flag(TIF_IA32) ? __NR_ia32_restart_syscall : __NR_restart_syscall
 #endif /* CONFIG_X86_32 */
 
+static noinline int process_signal(struct pt_regs *regs, siginfo_t **pinfo)
+{
+	struct ksignal ksig;
+
+	switch (get_signal(&ksig)) {
+	case SIG_DUMP:
+		*pinfo = kmalloc(sizeof(siginfo_t), GFP_KERNEL);
+		if (*pinfo)
+			copy_siginfo(*pinfo, &ksig.info);
+
+	case SIG_EXIT:
+		return ksig.info.si_signo;
+
+	default:
+		handle_signal(&ksig, regs);
+		break;
+
+	case 0:
+		/* Did we come from a system call? */
+		if (syscall_get_nr(current, regs) >= 0) {
+			/* Restart the system call - no handlers present */
+			switch (syscall_get_error(current, regs)) {
+			case -ERESTARTNOHAND:
+			case -ERESTARTSYS:
+			case -ERESTARTNOINTR:
+				regs->ax = regs->orig_ax;
+				regs->ip -= 2;
+				break;
+
+			case -ERESTART_RESTARTBLOCK:
+				regs->ax = NR_restart_syscall;
+				regs->ip -= 2;
+				break;
+			}
+		}
+
+		/*
+		 * If there's no signal to deliver, we just put the saved sigmask
+		 * back.
+		 */
+		restore_saved_sigmask();
+	}
+
+	return 0;
+}
+
 /*
  * Note that 'init' is a special process: it doesn't get signals it doesn't
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
@@ -691,37 +737,16 @@ handle_signal(struct ksignal *ksig, struct pt_regs *regs)
  */
 static void do_signal(struct pt_regs *regs)
 {
-	struct ksignal ksig;
+	siginfo_t *info = NULL;
+	int sig = process_signal(regs, &info);
 
-	if (get_signal(&ksig)) {
-		/* Whee! Actually deliver the signal.  */
-		handle_signal(&ksig, regs);
-		return;
-	}
-
-	/* Did we come from a system call? */
-	if (syscall_get_nr(current, regs) >= 0) {
-		/* Restart the system call - no handlers present */
-		switch (syscall_get_error(current, regs)) {
-		case -ERESTARTNOHAND:
-		case -ERESTARTSYS:
-		case -ERESTARTNOINTR:
-			regs->ax = regs->orig_ax;
-			regs->ip -= 2;
-			break;
-
-		case -ERESTART_RESTARTBLOCK:
-			regs->ax = NR_restart_syscall;
-			regs->ip -= 2;
-			break;
+	if (sig) {
+		if (info) {
+			do_coredump(info);
+			kfree(info);
 		}
+		do_group_exit(sig);
 	}
-
-	/*
-	 * If there's no signal to deliver, we just put the saved sigmask
-	 * back.
-	 */
-	restore_saved_sigmask();
 }
 
 /*
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 2ac423b..33b5e04 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -285,6 +285,9 @@ struct ksignal {
 	int sig;
 };
 
+#define SIG_EXIT	-1
+#define SIG_DUMP	-2
+
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
 extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping);
 extern void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka, struct pt_regs *regs, int stepping);
@@ -299,7 +302,7 @@ extern void exit_signals(struct task_struct *tsk);
 	struct ksignal *p = (ksig);				\
 	p->sig = get_signal_to_deliver(&p->info, &p->ka,	\
 					signal_pt_regs(), NULL);\
-	p->sig > 0;						\
+	p->sig;							\
 })
 
 extern struct kmem_cache *sighand_cachep;
diff --git a/kernel/signal.c b/kernel/signal.c
index 52f881d..8a4c4a3 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2353,22 +2353,11 @@ relock:
 			if (print_fatal_signals)
 				print_fatal_signal(info->si_signo);
 			proc_coredump_connector(current);
-			/*
-			 * If it was able to dump core, this kills all
-			 * other threads in the group and synchronizes with
-			 * their demise.  If we lost the race with another
-			 * thread getting here, it set group_exit_code
-			 * first and our do_group_exit call below will use
-			 * that value and ignore the one we pass it.
-			 */
-			do_coredump(info);
+			return SIG_DUMP;
 		}
 
-		/*
-		 * Death signals, no core dump.
-		 */
-		do_group_exit(info->si_signo);
-		/* NOTREACHED */
+		return SIG_EXIT;
+
 	}
 	spin_unlock_irq(&sighand->siglock);
 	return signr;

