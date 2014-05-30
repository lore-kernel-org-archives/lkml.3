Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934166AbaE3RYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:24:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933239AbaE3RYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:24:23 -0400
Date: Fri, 30 May 2014 19:24:20 +0200
From: Jan Kara <jack@suse.cz>
To: Jet Chen <jet.chen@intel.com>
Cc: Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [prink]  BUG: spinlock lockup suspected on CPU#0, swapper/1
Message-ID: <20140530172420.GA28291@quack.suse.cz>
References: <538808FD.3060707@intel.com>
 <20140530155051.GD2419@quack.suse.cz>
 <20140530161647.GD11096@twins.programming.kicks-ass.net>
 <20140530161948.GZ13658@twins.programming.kicks-ass.net>
 <20140530165810.GE2419@quack.suse.cz>
 <20140530172327.GF2419@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <20140530172327.GF2419@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Now with the attachment... :)

On Fri 30-05-14 19:23:27, Jan Kara wrote:
> On Fri 30-05-14 18:58:10, Jan Kara wrote:
> > On Fri 30-05-14 18:19:48, Peter Zijlstra wrote:
> > > On Fri, May 30, 2014 at 06:16:47PM +0200, Peter Zijlstra wrote:
> > > > On Fri, May 30, 2014 at 05:50:51PM +0200, Jan Kara wrote:
> > > > > > [    7.492350] ======================================================
> > > > > > [    7.492350] [ INFO: possible circular locking dependency detected ]
> > > > > > [    7.492350] 3.15.0-rc5-00567-gbafe980 #1 Not tainted
> > > > > > [    7.492350] -------------------------------------------------------
> > > > > > [    7.492350] swapper/1 is trying to acquire lock:
> > > > > > [    7.492350]  (&irq_desc_lock_class){-.-...}, at: [<8107dc8c>] __irq_get_desc_lock+0x3c/0x70
> > > > > > [    7.492350] 
> > > > > > [    7.492350] but task is already holding lock:
> > > > > > [    7.492350]  (&port_lock_key){......}, at: [<815f5b27>] serial8250_startup+0x337/0x720
> > > > > > [    7.492350] 
> > > > > > [    7.492350] which lock already depends on the new lock.
> > > > > > [    7.492350] 
> > > > > > [    7.492350] 
> > > > > > [    7.492350] the existing dependency chain (in reverse order) is:
> > > > > > [    7.492350] 
> > > > > > -> #2 (&port_lock_key){......}:
> > > > > > [    7.492350]        [<810750e5>] lock_acquire+0x85/0x190
> > > > > > [    7.492350]        [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
> > > > > > [    7.492350]        [<8106eb1c>] down_trylock+0xc/0x30
> > > > > > [    7.492350]        [<8107b795>] console_trylock+0x15/0xb0
> > > > > > [    7.492350]        [<8107be8f>] vprintk_emit+0x14f/0x4d0
> > > > > > [    7.492350]        [<81b969b9>] printk+0x38/0x3a
> > > > > > [    7.492350]        [<82137f78>] print_ICs+0x5b/0x3e7
> > > > > > [    7.492350]        [<8212bb41>] do_one_initcall+0x8b/0x128
> > > > > > [    7.492350]        [<8212bd7d>] kernel_init_freeable+0x19f/0x236
> > > > > > [    7.492350]        [<81b9238b>] kernel_init+0xb/0xd0
> > > > > > [    7.492350]        [<81bb0080>] ret_from_kernel_thread+0x20/0x30
> > > > >
> > > > >   But this looks really strange. How can we possibly get port_lock_key in
> > > > > down_trylock() which calls raw_spin_lock_irqsave() on console_sem->lock?
> > > > > That looks like some strange lockdep key aliasing issue? Peter do you have
> > > > > any idea?
> > > > 
> > > > No, strange that, I can't say I've ever seen a bogus stracktrace in
> > > > lockdep reports like this.
> > > > 
> > > > So this is through: check_prev_add()->save_trace(). And that doesn't
> > > > reuse entries, at worst it can truncate a trace when we run out of
> > > > entries, but the above looks complete since it terminates in
> > > > lock_acquire(), which is the right place to be.
> > > > 
> > > > But its worse than that, the above trace should link i8259A_lock to
> > > > port_lock_key, and I can't see where we would have taken i8259A_lock
> > > > either.
> > > 
> > > Oh, wait, I missed it, that would be: print_ICs()->print_PIC(), it takes
> > > that lock there.
> >   Yeah, so as much as the lockdep reported stack trace looks strange I can
> > now see how a locking problem lockdep reports can happen. We really do call
> > printk() under i8259A_lock in print_PIC() and so the locking chain lockdep
> > found is real. Luckily it likely cannot lead to any real problems because
> > printk only happens during early init.
> > 
> > In any case it is another example of a problem that was just uncovered by
> > my change which increased lockdep coverage of printk code. I'll send a fix
> > to x86 maintainers.
>   Jet, can you please test the attached patch? Thanks!
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--tKW2IUtsqtDRztdT
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-x86-Fixup-lockdep-complaint-caused-by-io-apic-code.patch"

>From e163478616bfcce62842e7db2279678a22f1f1f1 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 30 May 2014 19:00:31 +0200
Subject: [PATCH] x86: Fixup lockdep complaint caused by io apic code

0day kernel testing guys have reported following lockdep complaint:
======================================================
[ INFO: possible circular locking dependency detected ]
3.15.0-rc5-00567-gbafe980 #1 Not tainted
-------------------------------------------------------
swapper/1 is trying to acquire lock:
 (&irq_desc_lock_class){-.-...}, at: [<8107dc8c>] __irq_get_desc_lock+0x3c/0x70

but task is already holding lock:
 (&port_lock_key){......}, at: [<815f5b27>] serial8250_startup+0x337/0x720

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&port_lock_key){......}:
       <this stack looks somewhat bogus but we do end up taking
        port->lock when printing to serial console>
       [<810750e5>] lock_acquire+0x85/0x190
       [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
       [<8106eb1c>] down_trylock+0xc/0x30
       [<8107b795>] console_trylock+0x15/0xb0
       [<8107be8f>] vprintk_emit+0x14f/0x4d0
       [<81b969b9>] printk+0x38/0x3a
       [<82137f78>] print_ICs+0x5b/0x3e7
       [<8212bb41>] do_one_initcall+0x8b/0x128
       [<8212bd7d>] kernel_init_freeable+0x19f/0x236
       [<81b9238b>] kernel_init+0xb/0xd0
       [<81bb0080>] ret_from_kernel_thread+0x20/0x30

-> #1 (i8259A_lock){-.....}:
       [<810750e5>] lock_acquire+0x85/0x190
       [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
       [<81005af1>] unmask_8259A_irq+0x11/0x60
       [<81005b4b>] enable_8259A_irq+0xb/0x10
       [<8107fffb>] irq_enable+0x2b/0x40
       [<8108005d>] irq_startup+0x4d/0x60
       [<8107f2bc>] __setup_irq+0x39c/0x460
       [<8107f433>] setup_irq+0x33/0x80
       [<8212db15>] setup_default_timer_irq+0xf/0x11
       [<8212db2d>] hpet_time_init+0x16/0x18
       [<8212daff>] x86_late_time_init+0x9/0x10
       [<8212ba3d>] start_kernel+0x331/0x3aa
       [<8212b380>] i386_start_kernel+0x12e/0x131

-> #0 (&irq_desc_lock_class){-.-...}:
       [<810743c2>] __lock_acquire+0x19c2/0x1b20
       [<810750e5>] lock_acquire+0x85/0x190
       [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
       [<8107dc8c>] __irq_get_desc_lock+0x3c/0x70
       [<8107eb1e>] __disable_irq_nosync+0x1e/0x50
       [<8107eb58>] disable_irq_nosync+0x8/0x10
       [<815f5c78>] serial8250_startup+0x488/0x720
       [<815f205e>] uart_startup.part.4+0x6e/0x1e0
       [<815f2a40>] uart_open+0xe0/0x140
       [<815e4b51>] tty_open+0x141/0x510
       [<81118bc0>] chrdev_open+0x60/0x140
       [<8111372c>] do_dentry_open+0x14c/0x230
       [<8111459e>] finish_open+0x2e/0x40
       [<8112132a>] do_last+0x4aa/0xd30
       [<81121c5a>] path_openat+0xaa/0x610
       [<811221ec>] do_filp_open+0x2c/0x70
       [<81114a81>] do_sys_open+0x111/0x210
       [<81114b9d>] SyS_open+0x1d/0x20
       [<8212bda4>] kernel_init_freeable+0x1c6/0x236
       [<81b9238b>] kernel_init+0xb/0xd0
       [<81bb0080>] ret_from_kernel_thread+0x20/0x30

I believe the core of the problem is that print_PIC() calls printk()
from under i8259A_lock. I've checked and that doesn't seem to happen
anywhere else in the kernel. So let's move printk() from under that
lock.

As a side note this problem has existed for a long time but it was
uncovered by my patch resulting in extended lockdep coverage of printk
code.

Reported-by: Jet Chen <jet.chen@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 arch/x86/kernel/apic/io_apic.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6ad4658de705..b815a4c9e5e5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1770,7 +1770,7 @@ __apicdebuginit(void) print_local_APICs(int maxcpu)
 
 __apicdebuginit(void) print_PIC(void)
 {
-	unsigned int v;
+	unsigned int v0, v1, v2;
 	unsigned long flags;
 
 	if (!legacy_pic->nr_legacy_irqs)
@@ -1780,24 +1780,23 @@ __apicdebuginit(void) print_PIC(void)
 
 	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
-	v = inb(0xa1) << 8 | inb(0x21);
-	printk(KERN_DEBUG "... PIC  IMR: %04x\n", v);
-
-	v = inb(0xa0) << 8 | inb(0x20);
-	printk(KERN_DEBUG "... PIC  IRR: %04x\n", v);
+	v0 = inb(0xa1) << 8 | inb(0x21);
+	v1 = inb(0xa0) << 8 | inb(0x20);
 
 	outb(0x0b,0xa0);
 	outb(0x0b,0x20);
-	v = inb(0xa0) << 8 | inb(0x20);
+	v2 = inb(0xa0) << 8 | inb(0x20);
 	outb(0x0a,0xa0);
 	outb(0x0a,0x20);
 
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 
-	printk(KERN_DEBUG "... PIC  ISR: %04x\n", v);
+	printk(KERN_DEBUG "... PIC  IMR: %04x\n", v0);
+	printk(KERN_DEBUG "... PIC  IRR: %04x\n", v1);
+	printk(KERN_DEBUG "... PIC  ISR: %04x\n", v2);
 
-	v = inb(0x4d1) << 8 | inb(0x4d0);
-	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
+	v0 = inb(0x4d1) << 8 | inb(0x4d0);
+	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v0);
 }
 
 static int __initdata show_lapic = 1;
-- 
1.8.1.4


--tKW2IUtsqtDRztdT--
