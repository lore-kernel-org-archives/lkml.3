Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab3IKTO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:14:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26261 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab3IKTOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:14:54 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=cpn0iEa-oVMA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=uXgjhyO7DfoA:10 a=yPCof4ZbAAAA:8 a=_flo8y1ajH9H8brGRecA:9 a=CjuIK1q_8ugA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 15:14:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@akamai.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Subject: Re: Regression :-) Re: [GIT PULL RESEND] x86/jumpmplabel changes
 for v3.12-rc1
Message-ID: <20130911151452.5810c793@gandalf.local.home>
In-Reply-To: <20130911185654.GB30042@phenom.dumpdata.com>
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
	<20130911185654.GB30042@phenom.dumpdata.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013 14:56:54 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:


> > I'm looking to NAK your patch because it is obvious that the jump label
> > code isn't doing what you expect it to be doing. And it wasn't until my
> 
> Actually it is OK. They need to be enabled before the SMP code kicks in.
> 
> > checks were in place for you to notice.
> 
> Any suggestion on how to resolve the crash?
> 
> The PV spinlock code is OK (I think, I need to think hard about this) until
> the spinlocks start being used by multiple CPUs. At that point the
> jump_lables have to be in place - otherwise you will end with a spinlock
> going in a slowpath (patched over) and an kicker not using the slowpath
> and never kicking the waiter. Which ends with a hanged system.

Note, a simple early_initcall() could do the trick. SMP isn't set up
until much further in the boot process.

> 
> Or simple said - jump labels have to be setup before we boot
> the other CPUs. 

Right, and initcalls() can easily serve that purpose.

> 
> This would affect the KVM guests as well, I think if the slowpath
> waiter was blocking on the VCPU (which I think it is doing now, but
> not entirely sure?)
> 
> P.S.
> I am out on vacation tomorrow for a week. Boris (CC-ed here) can help.

Your patch isn't wrong per say, but I'm hesitant to apply it because it
the result is different depending on whether JUMP_LABEL is configured
or not. Using any jump_label() calls before jump_label_init() is
called, is entering a gray area, and I think it should be avoided.

This patch should solve it for you:

xen: Do not enable spinlocks before jump_label_init()

The static_key paravirt_ticketlocks_enabled does not need to be
initialized before jump_label_init(), as that will cause an
inconsistent result between JUMP_LABEL being configured or not. The
static key update will not take place at the time of the
static_key_slow_inc() but instead at the time of jump_label_init(), if
CONFIG_JUMP_LABEL is configured, otherwise it happens at the time of
the static_key_slow_inc() call.

The updates to the spinlocks need to happen before other processors are
initialized, which happens much later in boot up. A simple use of
early_initcall() will do the trick, as that too is called before other
processors are enabled and after jump_label_init() is called.

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 9235842..4214bde 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -279,7 +279,6 @@ static void __init xen_smp_prepare_boot_cpu(void)
 
 	xen_filter_cpu_maps();
 	xen_setup_vcpu_info_placement();
-	xen_init_spinlocks();
 }
 
 static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 0438b93..52582fd 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -285,25 +285,28 @@ void xen_uninit_lock_cpu(int cpu)
 
 static bool xen_pvspin __initdata = true;
 
-void __init xen_init_spinlocks(void)
+static __init int xen_init_spinlocks(void)
 {
 	/*
 	 * See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
 	 * (xen: disable PV spinlocks on HVM)
 	 */
 	if (xen_hvm_domain())
-		return;
+		return 0;
 
 	if (!xen_pvspin) {
 		printk(KERN_DEBUG "xen: PV spinlocks disabled\n");
-		return;
+		return 0;
 	}
 
 	static_key_slow_inc(&paravirt_ticketlocks_enabled);
 
 	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(xen_lock_spinning);
 	pv_lock_ops.unlock_kick = xen_unlock_kick;
+
+	return 0;
 }
+early_initcall(xen_init_spinlocks);
 
 static __init int xen_parse_nopvspin(char *arg)
 {
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 95f8c61..7609eb1 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -72,13 +72,9 @@ static inline void xen_hvm_smp_init(void) {}
 #endif
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
-void __init xen_init_spinlocks(void);
 void xen_init_lock_cpu(int cpu);
 void xen_uninit_lock_cpu(int cpu);
 #else
-static inline void xen_init_spinlocks(void)
-{
-}
 static inline void xen_init_lock_cpu(int cpu)
 {
 }

