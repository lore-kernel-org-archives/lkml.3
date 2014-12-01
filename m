Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756AbaLAWgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:36:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932726AbaLAWgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:36:13 -0500
Date: Mon, 1 Dec 2014 23:36:11 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Juergen Gross <jgross@suse.com>, Joerg Roedel <jroedel@suse.de>,
        kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        x86@kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <dbueso@suse.de>, Jan Beulich <JBeulich@suse.com>,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        Borislav Petkov <bp@suse.de>, Olaf Hering <ohering@suse.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: privcmd: schedule() after private
	hypercall when non CONFIG_PREEMPT
Message-ID: <20141201223611.GM25677@wotan.suse.de>
References: <1417040805-15857-1-git-send-email-mcgrof@do-not-panic.com> <5476C66F.5040308@suse.com> <20141127183616.GV25677@wotan.suse.de> <547C4CEF.1010603@citrix.com> <20141201150546.GC25677@wotan.suse.de> <547C86BF.2040705@citrix.com> <CAB=NE6WPvCJnAfdbZqcw5pJtZrfxo0zQu6J2gpXp69G-UTtiUg@mail.gmail.com> <547C8F30.1010306@citrix.com> <20141201161905.GH25677@wotan.suse.de> <547CB07C.1050507@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547CB07C.1050507@citrix.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 06:16:28PM +0000, David Vrabel wrote:
> On 01/12/14 16:19, Luis R. Rodriguez wrote:
> > On Mon, Dec 01, 2014 at 03:54:24PM +0000, David Vrabel wrote:
> >> On 01/12/14 15:44, Luis R. Rodriguez wrote:
> >>> On Mon, Dec 1, 2014 at 10:18 AM, David Vrabel <david.vrabel@citrix.com> wrote:
> >>>> On 01/12/14 15:05, Luis R. Rodriguez wrote:
> >>>>> On Mon, Dec 01, 2014 at 11:11:43AM +0000, David Vrabel wrote:
> >>>>>> On 27/11/14 18:36, Luis R. Rodriguez wrote:
> >>>>>>> On Thu, Nov 27, 2014 at 07:36:31AM +0100, Juergen Gross wrote:
> >>>>>>>> On 11/26/2014 11:26 PM, Luis R. Rodriguez wrote:
> >>>>>>>>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >>>>>>>>>
> >>>>>>>>> Some folks had reported that some xen hypercalls take a long time
> >>>>>>>>> to complete when issued from the userspace private ioctl mechanism,
> >>>>>>>>> this can happen for instance with some hypercalls that have many
> >>>>>>>>> sub-operations, this can happen for instance on hypercalls that use
> >>>>>> [...]
> >>>>>>>>> --- a/drivers/xen/privcmd.c
> >>>>>>>>> +++ b/drivers/xen/privcmd.c
> >>>>>>>>> @@ -60,6 +60,9 @@ static long privcmd_ioctl_hypercall(void __user *udata)
> >>>>>>>>>                              hypercall.arg[0], hypercall.arg[1],
> >>>>>>>>>                              hypercall.arg[2], hypercall.arg[3],
> >>>>>>>>>                              hypercall.arg[4]);
> >>>>>>>>> +#ifndef CONFIG_PREEMPT
> >>>>>>>>> + schedule();
> >>>>>>>>> +#endif
> >>>>>>
> >>>>>> As Juergen points out, this does nothing.  You need to schedule while in
> >>>>>> the middle of the hypercall.
> >>>>>>
> >>>>>> Remember that Xen's hypercall preemption only preempts the hypercall to
> >>>>>> run interrupts in the guest.
> >>>>>
> >>>>> How is it ensured that when the kernel preempts on this code path on
> >>>>> CONFIG_PREEMPT=n kernel that only interrupts in the guest are run?
> >>>>
> >>>> Sorry, I really didn't describe this very well.
> >>>>
> >>>> If a hypercall needs a continuation, Xen returns to the guest with the
> >>>> IP set to the hypercall instruction, and on the way back to the guest
> >>>> Xen may schedule a different VCPU or it will do any upcalls (as per normal).
> >>>>
> >>>> The guest is free to return from the upcall to the original task
> >>>> (continuing the hypercall) or to a different one.
> >>>
> >>> OK so that addresses what Xen will do when using continuation and
> >>> hypercall preemption, my concern here was that using
> >>> preempt_schedule_irq() on CONFIG_PREEMPT=n kernels in the middle of a
> >>> hypercall on the return from an interrupt (e.g., the timer interrupt)
> >>> would still let the kernel preempt to tasks other than those related
> >>> to Xen.
> >>
> >> Um.  Why would that be a problem?  We do want to switch to any task the
> >> Linux scheduler thinks is best.
> > 
> > Its safe but -- it technically is doing kernel preemption, unless we want
> > to adjust the definition of CONFIG_PREEMPT=n to exclude hypercalls. This
> > was my original concern with the use of preempt_schedule_irq() to do this.
> > I am afraid of setting precedents without being clear or wider review and
> > acceptance.
> 
> It's voluntary preemption at a well defined point. 

Its voluntarily preempting the kernel even for CONFIG_PREEMPT=n kernels... 

> It's no different to a cond_resched() call.

Then I do agree its a fair analogy (and find this obviously odd that how
widespread cond_resched() is), we just don't have an equivalent for IRQ
context, why not avoid the special check then and use this all the time in the
middle of a hypercall on the return from an interrupt (e.g., the timer
interrupt)?

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e344bb..e60b5a1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2759,6 +2759,12 @@ static inline int signal_pending_state(long state, struct task_struct *p)
  */
 extern int _cond_resched(void);
 
+/*
+ * Voluntarily preempting the kernel even for CONFIG_PREEMPT=n kernels
+ * on very special circumstances.
+ */
+extern int cond_resched_irq(void);
+
 #define cond_resched() ({			\
 	__might_sleep(__FILE__, __LINE__, 0);	\
 	_cond_resched();			\
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 240157c..1c4d443 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4264,6 +4264,16 @@ int __sched _cond_resched(void)
 }
 EXPORT_SYMBOL(_cond_resched);
 
+int __sched cond_resched_irq(void)
+{
+	if (should_resched()) {
+		preempt_schedule_irq();
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cond_resched_irq);
+
 /*
  * __cond_resched_lock() - if a reschedule is pending, drop the given lock,
  * call schedule, and on return reacquire the lock.
  Luis
