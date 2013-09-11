Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab3IKT4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:56:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28031 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3IKT4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:56:31 -0400
Date: Wed, 11 Sep 2013 15:55:50 -0400
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
Message-ID: <20130911195550.GA30581@phenom.dumpdata.com>
References: <20130911152149.GA22076@phenom.dumpdata.com>
 <20130911114708.1b42aec0@gandalf.local.home>
 <20130911161745.GA5884@phenom.dumpdata.com>
 <20130911130507.44a2b115@gandalf.local.home>
 <20130911172552.GB6870@phenom.dumpdata.com>
 <20130911135237.245386fb@gandalf.local.home>
 <20130911180113.GB29406@phenom.dumpdata.com>
 <20130911142644.68d614c9@gandalf.local.home>
 <20130911185654.GB30042@phenom.dumpdata.com>
 <20130911151452.5810c793@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911151452.5810c793@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 03:14:52PM -0400, Steven Rostedt wrote:
> On Wed, 11 Sep 2013 14:56:54 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> 
> > > I'm looking to NAK your patch because it is obvious that the jump label
> > > code isn't doing what you expect it to be doing. And it wasn't until my
> > 
> > Actually it is OK. They need to be enabled before the SMP code kicks in.
> > 
> > > checks were in place for you to notice.
> > 
> > Any suggestion on how to resolve the crash?
> > 
> > The PV spinlock code is OK (I think, I need to think hard about this) until
> > the spinlocks start being used by multiple CPUs. At that point the
> > jump_lables have to be in place - otherwise you will end with a spinlock
> > going in a slowpath (patched over) and an kicker not using the slowpath
> > and never kicking the waiter. Which ends with a hanged system.
> 
> Note, a simple early_initcall() could do the trick. SMP isn't set up
> until much further in the boot process.
> 
> > 
> > Or simple said - jump labels have to be setup before we boot
> > the other CPUs. 
> 
> Right, and initcalls() can easily serve that purpose.
> 
> > 
> > This would affect the KVM guests as well, I think if the slowpath
> > waiter was blocking on the VCPU (which I think it is doing now, but
> > not entirely sure?)
> > 
> > P.S.
> > I am out on vacation tomorrow for a week. Boris (CC-ed here) can help.
> 
> Your patch isn't wrong per say, but I'm hesitant to apply it because it
> the result is different depending on whether JUMP_LABEL is configured
> or not. Using any jump_label() calls before jump_label_init() is
> called, is entering a gray area, and I think it should be avoided.
> 
> This patch should solve it for you:

And also the pv_lock_ops need to be set before alternative_asm
code is called :-) (Called from check_bugs()).

Otherwise you end up with some code still using the native slowpath
kicker/waiter while the modules might be using the Xen variant.

I knew that I forgot to mention something ..

With that in mind and your patch I made this one:

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 253f63f..d90628d 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -267,11 +267,18 @@ void __init xen_init_spinlocks(void)
 		return;
 	}
 
-	static_key_slow_inc(&paravirt_ticketlocks_enabled);
-
 	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(xen_lock_spinning);
 	pv_lock_ops.unlock_kick = xen_unlock_kick;
 }
+static __init int xen_init_spinlocks_jump(void)
+{
+	if (!xen_pvspin)
+		return 0;
+
+	static_key_slow_inc(&paravirt_ticketlocks_enabled);
+	return 0;
+}
+early_initcall(xen_init_spinlocks_jump);
 
 static __init int xen_parse_nopvspin(char *arg)
 {

which seem to work.

