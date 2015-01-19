Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbbASOmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:42:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbbASOmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:42:02 -0500
Date: Mon, 19 Jan 2015 12:41:00 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Rik van Riel <riel@redhat.com>, Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch -rt 1/2] KVM: use simple waitqueue for vcpu->wq
Message-ID: <20150119144100.GA10794@amt.cnet>
References: <20150114171251.882318257@redhat.com>
 <20150114171459.593877145@redhat.com>
 <20150116114846.4e7b718d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116114846.4e7b718d@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 11:48:46AM -0500, Steven Rostedt wrote:
> > @@ -971,8 +971,8 @@
> >  	kvm_mips_callbacks->queue_timer_int(vcpu);
> >  
> >  	vcpu->arch.wait = 0;
> > -	if (waitqueue_active(&vcpu->wq)) {
> > -		wake_up_interruptible(&vcpu->wq);
> > +	if (swaitqueue_active(&vcpu->wq)) {
> > +		swait_wake_nterruptible(&vcpu->wq);
> 
> Sure you compiled this patch?

Only x86.

> > Index: linux-stable-rt/arch/powerpc/include/asm/kvm_host.h
> > ===================================================================
> > --- linux-stable-rt.orig/arch/powerpc/include/asm/kvm_host.h	2014-11-25 14:13:39.193899944 -0200
> > +++ linux-stable-rt/arch/powerpc/include/asm/kvm_host.h	2014-11-25 14:14:38.621810091 -0200
> > @@ -295,7 +295,7 @@
> >  	u8 in_guest;
> >  	struct list_head runnable_threads;
> >  	spinlock_t lock;
> > -	wait_queue_head_t wq;
> > +	struct swait_head wq;
> >  	u64 stolen_tb;
> >  	u64 preempt_tb;
> >  	struct kvm_vcpu *runner;
> > @@ -612,7 +612,7 @@
> >  	u8 prodded;
> >  	u32 last_inst;
> >  
> > -	wait_queue_head_t *wqp;
> > +	struct swait_head *wqp;
> >  	struct kvmppc_vcore *vcore;
> >  	int ret;
> >  	int trap;
> > Index: linux-stable-rt/arch/powerpc/kvm/book3s_hv.c
> > ===================================================================
> > --- linux-stable-rt.orig/arch/powerpc/kvm/book3s_hv.c	2014-11-25 14:13:39.195899942 -0200
> > +++ linux-stable-rt/arch/powerpc/kvm/book3s_hv.c	2014-11-25 14:14:38.625810085 -0200
> > @@ -74,11 +74,11 @@
> >  {
> >  	int me;
> >  	int cpu = vcpu->cpu;
> > -	wait_queue_head_t *wqp;
> > +	struct swait_head *wqp;
> >  
> >  	wqp = kvm_arch_vcpu_wq(vcpu);
> > -	if (waitqueue_active(wqp)) {
> > -		wake_up_interruptible(wqp);
> > +	if (swaitqueue_active(wqp)) {
> > +		swait_wake_interruptible(wqp);
> >  		++vcpu->stat.halt_wakeup;
> >  	}
> >  
> > @@ -583,8 +583,8 @@
> >  		tvcpu->arch.prodded = 1;
> >  		smp_mb();
> >  		if (vcpu->arch.ceded) {
> > -			if (waitqueue_active(&vcpu->wq)) {
> > -				wake_up_interruptible(&vcpu->wq);
> > +			if (swaitqueue_active(&vcpu->wq)) {
> > +				swait_wake_interruptible(&vcpu->wq);
> >  				vcpu->stat.halt_wakeup++;
> >  			}
> >  		}
> > @@ -1199,7 +1199,7 @@
> >  		if (vcore) {
> >  			INIT_LIST_HEAD(&vcore->runnable_threads);
> >  			spin_lock_init(&vcore->lock);
> > -			init_waitqueue_head(&vcore->wq);
> > +			init_swait_head(&vcore->wq);
> >  			vcore->preempt_tb = TB_NIL;
> >  			vcore->lpcr = kvm->arch.lpcr;
> >  			vcore->first_vcpuid = core * threads_per_core;
> > @@ -1566,13 +1566,13 @@
> >   */
> >  static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
> >  {
> > -	DEFINE_WAIT(wait);
> > +	DEFINE_SWAITER(wait);
> >  
> > -	prepare_to_wait(&vc->wq, &wait, TASK_INTERRUPTIBLE);
> > +	swait_prepare(&vc->wq, &wait, TASK_INTERRUPTIBLE);
> >  	vc->vcore_state = VCORE_SLEEPING;
> >  	spin_unlock(&vc->lock);
> >  	schedule();
> > -	finish_wait(&vc->wq, &wait);
> > +	swait_finish(&vc->wq, &wait);
> >  	spin_lock(&vc->lock);
> >  	vc->vcore_state = VCORE_INACTIVE;
> >  }
> > @@ -1613,7 +1613,7 @@
> >  			kvmppc_create_dtl_entry(vcpu, vc);
> >  			kvmppc_start_thread(vcpu);
> >  		} else if (vc->vcore_state == VCORE_SLEEPING) {
> > -			wake_up(&vc->wq);
> > +			swait_wake(&vc->wq);
> 
> I notice everywhere you have a swait_wake_interruptible() but here. Is
> there a reason why?
> 
> IIRC, Peter wants to make swait wakeup usage homogenous. That is, you
> either sleep in an interruptible state, or you don't. You can't mix and
> match it.

IIUC there is only one waiter on this waitqueue at any given time.

Paul is that correct?

