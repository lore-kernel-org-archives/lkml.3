Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbbAPTDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:03:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49604 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846AbbAPTDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:03:42 -0500
Date: Fri, 16 Jan 2015 20:03:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 00/23] x86: Cleanup apic/ioapic/x2apic setup code
Message-ID: <20150116190339.GT18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <54B8DBC1.6080205@linux.intel.com>
 <alpine.DEB.2.11.1501161120560.5526@nanos>
 <alpine.DEB.2.11.1501161203340.5526@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501161203340.5526@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 12:05:24PM +0100, Thomas Gleixner wrote:
> On Fri, 16 Jan 2015, Thomas Gleixner wrote:
> > On Fri, 16 Jan 2015, Jiang Liu wrote:
> > > 5) x86_32, UP, IO_APIC disabled
> > > 5.1) boot: panic with following call stack:
> > > do_ono_initcall()->APIC_init_uniprocessor()->setup_local_APIC().
> > > I can't capture the full log message due to lack of serial console.
> > > It seems we have trouble with:
> > > early_initcall(APIC_init_uniprocessor);
> > 
> > Hmm, worked here. Lemme find some other machine.
> 
> Found the issue, won't work. But I still want to remove that x86
> nonsense from init. So we need to do it different.
> 
> Subject: init: Get rid of x86isms
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 14 Jan 2015 14:59:48 +0100
> 
> Provide a config option and make the UP smp_init() implementation
> depend on it and confine this to x86.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/Kconfig            |    4 ++++
>  arch/x86/kernel/apic/apic.c |    7 +++++++
>  include/linux/smp.h         |    6 ++++++
>  init/main.c                 |   13 -------------
>  4 files changed, 17 insertions(+), 13 deletions(-)
> 
> Index: tip/arch/x86/Kconfig
> ===================================================================
> --- tip.orig/arch/x86/Kconfig
> +++ tip/arch/x86/Kconfig
> @@ -855,6 +855,10 @@ config SCHED_MC
>  
>  source "kernel/Kconfig.preempt"
>  
> +config UP_SMP_INIT

UP_SMP might confuse people. UP_INIT looks fine to me too.

And then maybe some more monkey business like this:

---
Index: b/arch/x86/kernel/apic/apic.c
===================================================================
--- a/arch/x86/kernel/apic/apic.c	2015-01-16 18:33:11.988358926 +0100
+++ b/arch/x86/kernel/apic/apic.c	2015-01-16 18:31:36.544360760 +0100
@@ -2266,7 +2266,7 @@ int __init APIC_init_uniprocessor(void)
 }
 
 #ifdef CONFIG_UP_SMP_INIT
-void smp_init(void)
+void up_init(void)
 {
 	APIC_init_uniprocessor();
 }
Index: b/include/linux/smp.h
===================================================================
--- a/include/linux/smp.h	2015-01-16 18:33:11.988358926 +0100
+++ b/include/linux/smp.h	2015-01-16 18:31:53.792360428 +0100
@@ -152,9 +152,10 @@ static inline void kick_all_cpus_sync(vo
 static inline void wake_up_all_idle_cpus(void) {  }
 
 #ifdef CONFIG_UP_SMP_INIT
-extern void __init smp_init(void);
+#define smp_init up_init
+extern void __init up_init(void);
 #else
-static inline void smp_init(void) { }
+static inline void up_init(void) { }
 #endif
 
 #endif /* !SMP */

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
