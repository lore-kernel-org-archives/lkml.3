Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3IKS5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:57:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34386 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3IKS5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:57:33 -0400
Date: Wed, 11 Sep 2013 14:56:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@akamai.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Subject: Re: Regression :-) Re: [GIT PULL RESEND] x86/jumpmplabel changes for
 v3.12-rc1
Message-ID: <20130911185654.GB30042@phenom.dumpdata.com>
References: <20130911142545.GA11364@phenom.dumpdata.com>
 <20130911105633.1c029147@gandalf.local.home>
 <20130911152149.GA22076@phenom.dumpdata.com>
 <20130911114708.1b42aec0@gandalf.local.home>
 <20130911161745.GA5884@phenom.dumpdata.com>
 <20130911130507.44a2b115@gandalf.local.home>
 <20130911172552.GB6870@phenom.dumpdata.com>
 <20130911135237.245386fb@gandalf.local.home>
 <20130911180113.GB29406@phenom.dumpdata.com>
 <20130911142644.68d614c9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911142644.68d614c9@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 02:26:44PM -0400, Steven Rostedt wrote:
> On Wed, 11 Sep 2013 14:01:13 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> 
> > <confused>
> > 
> > I am thins would still work:
> > 
> > 
> > 47 static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)             
> > 148 {                                                                               
> > 149         if (TICKET_SLOWPATH_FLAG &&                                             
> > 150             static_key_false(&paravirt_ticketlocks_enabled)) {                  
> > 
> > (from arch/x86/include/asm/spinlock.h) as the static_key_false
> > would check the key->enabled. Which had been incremented?
> > 
> > Granted there are no patching done yet, but that should still allow
> > this code path to be taken?
> 
> Lets look at static_key_false():
> 
> If jump labels is not enabled, you are correct. It simply looks like
> this:
> 
> static __always_inline bool static_key_false(struct static_key *key)
> {
> 	if (unlikely(atomic_read(&key->enabled)) > 0)
> 		return true;
> 	return false;
> }
> 
> 
> But that's not the case here. Here we have code modifying jump labels,
> where static_key_false() looks like this:
> 
> static __always_inline bool static_key_false(struct static_key *key)
> {
> 	return arch_static_branch(key);
> }
> 
> static __always_inline bool arch_static_branch(struct static_key *key)
> {
> 	asm goto("1:"
> 		".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
> 		".pushsection __jump_table,  \"aw\" \n\t"
> 		_ASM_ALIGN "\n\t"
> 		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
> 		".popsection \n\t"
> 		: :  "i" (key) : : l_yes);
> 	return false;
> l_yes:
> 	return true;
> }
> 
> 
> 
> 
> Look in that assembly. That "STATIC_KEY_INIT_NOP" is the byte code for
> a nop, and until we modify it, arch_static_branch() will always return
> false, no matter what "key->enable" is.
> 
> 
> In fact, your call trace you posted earlier proves my point!
> 
> [    4.966912]  [<ffffffff810542e0>] ? poke_int3_handler+0x40/0x40
> [    4.966916]  [<ffffffff816a0cf3>] dump_stack+0x59/0x7b
> [    4.966920]  [<ffffffff81051e0a>] __jump_label_transform+0x18a/0x230
> [    4.966923]  [<ffffffff81162980>] ? fire_user_return_notifiers+0x70/0x70
> [    4.966926]  [<ffffffff81051f15>] arch_jump_label_transform_static+0x65/0x90
> [    4.966930]  [<ffffffff81cfbbfb>] jump_label_init+0x75/0xa3
> [    4.966932]  [<ffffffff81cd3e3c>] start_kernel+0x168/0x3ff
> [    4.966934]  [<ffffffff81cd3af2>] ? repair_env_string+0x5b/0x5b
> [    4.966938]  [<ffffffff81cd35f3>] x86_64_start_reservations+0x2a/0x2c
> [    4.966941]  [<ffffffff81cd833a>] xen_start_kernel+0x594/0x596
> 
> This blew up in your patch:
> 
>  	if (type == JUMP_LABEL_ENABLE) {
>  		/*
>  		 * We are enabling this jump label. If it is not a nop
>  		 * then something must have gone wrong.
>  		 */
> -		if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0))
> -			bug_at((void *)entry->code, __LINE__);
> +		if (init) {
> +			if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0)) {
> +				static int log = 0;
> +
> +				if (log == 0) {
> +					pr_warning("op %pS\n", (void *)entry->code);
> +					dump_stack();
> +				}
> +				log++;
> +			}
> +		}
> 
> 
> It was expecting to have the ideal nop, because on boot up it didn't
> expect to have something already marked for enable. It only thought this
> to be the case after initialization. This explains your origin error
> message:
> 
> Unexpected op at trace_clock_global+0x6b/0x120 [ffffffff8113a21b] (0f 1f 44 00 00)
> 
> The NOP was still the default nop, but it was expecting the ideal nop
> because it normally only gets into this path after the init was already
> done.
> 
> My point is, it wasn't until jump_label_init() where it did the
> conversion from nop to calling the label.
> 
> I'm looking to NAK your patch because it is obvious that the jump label
> code isn't doing what you expect it to be doing. And it wasn't until my

Actually it is OK. They need to be enabled before the SMP code kicks in.

> checks were in place for you to notice.

Any suggestion on how to resolve the crash?

The PV spinlock code is OK (I think, I need to think hard about this) until
the spinlocks start being used by multiple CPUs. At that point the
jump_lables have to be in place - otherwise you will end with a spinlock
going in a slowpath (patched over) and an kicker not using the slowpath
and never kicking the waiter. Which ends with a hanged system.

Or simple said - jump labels have to be setup before we boot
the other CPUs. 

This would affect the KVM guests as well, I think if the slowpath
waiter was blocking on the VCPU (which I think it is doing now, but
not entirely sure?)

P.S.
I am out on vacation tomorrow for a week. Boris (CC-ed here) can help.
