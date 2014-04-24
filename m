Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbaDXOkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:40:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:37822 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578AbaDXOkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:40:18 -0400
Date: Thu, 24 Apr 2014 16:40:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        "Jin, Yao" <yao.jin@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Krogerus, Heikki" <heikki.krogerus@intel.com>
Subject: Re: [PATCH] pinctrl-baytrail: workaround for irq descriptor conflict
 on ASUS T100TA
In-Reply-To: <CACRpkdaHP4sp8fomE_7-2KaHAmBmTYv-cMSA=As04V54OZMo-g@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1404241617360.28206@ionos.tec.linutronix.de>
References: <1397443272-31467-1-git-send-email-yao.jin@linux.intel.com> <534B4C6D.5070003@linux.intel.com> <CACRpkdYXD-Fd0tFJtir8ifsTqdBvA0Rznc4Hmzoq_ByBjTahdw@mail.gmail.com> <5357A594.6050404@linux.intel.com> <CACRpkdYztACye5Xht3f4UuaWDA0gB7t2rgRmpTaL330YcxYhfQ@mail.gmail.com>
 <alpine.DEB.2.02.1404240918110.4704@ionos.tec.linutronix.de> <CACRpkdaHP4sp8fomE_7-2KaHAmBmTYv-cMSA=As04V54OZMo-g@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014, Linus Walleij wrote:
> On Thu, Apr 24, 2014 at 9:25 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > I'm traveling until friday, so please wait before you commit that
> > fugly hack. I'll have a closer look how we can handle that at the core
> > level.
> 
> Thanks a *lot* Thomas, I'll stand by for action.

Find an untested patch below. It should cure the issue.

I went through all code which can be affected by this and except for
some other places, which might erroneously allocate inside the
hardwired space, I can't see any possible fallout.

Thanks,

	tglx

-------------------->

Subject: genirq: x86: Ensure that dynamic irq allocation does not conflict
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 24 Apr 2014 09:50:53 +0200

On x86 the allocation of irq descriptors may allocate interrupts which
are in the range of the GSI interrupts. That's wrong as those
interrupts are hardwired and we don't have the irq domain translation
like PPC. So one of these interrupts can be hooked up later to one of
the devices which are hard wired to it and the io_apic init code for
that particular interrupt line happily reuses that descriptor with a
completely different configuration so hell breaks lose.

Inside x86 we allocate dynamic interrupts from above nr_gsi_irqs,
except for a few usage sites which have not yet blown up in our face
for whatever reason. But for drivers which need an irq range, like the
GPIO drivers, we have no limit in place and we don't want to expose
such a detail to a driver.

To cure this introduce a function which an architecture can implement
to impose a lower bound on the dynamic interrupt allocations.

Implement it for x86 and set the lower bound to nr_gsi_irqs, which is
the end of the hardwired interrupt space, so all dynamic allocations
happen above.

That not only allows the GPIO driver to work sanely, it also protects
the bogus callsites of create_irq_nr() in hpet, uv, irq_remapping and
htirq code. They need to be cleaned up as well, but that's a separate
issue.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |    5 +++++
 include/linux/irq.h            |    2 ++
 kernel/irq/irqdesc.c           |    2 ++
 kernel/softirq.c               |    5 +++++
 4 files changed, 14 insertions(+)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3425,6 +3425,11 @@ int get_nr_irqs_gsi(void)
 	return nr_irqs_gsi;
 }
 
+unsigned int arch_dynirq_lower_bound(unsigned int from)
+{
+	return from < nr_irqs_gsi ? nr_irqs_gsi : from;
+}
+
 int __init arch_probe_nr_irqs(void)
 {
 	int nr;
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -602,6 +602,8 @@ static inline u32 irq_get_trigger_type(u
 	return d ? irqd_get_trigger_type(d) : 0;
 }
 
+unsigned int arch_dynirq_lower_bound(unsigned int from);
+
 int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 		struct module *owner);
 
Index: linux-2.6/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6.orig/kernel/irq/irqdesc.c
+++ linux-2.6/kernel/irq/irqdesc.c
@@ -363,6 +363,8 @@ __irq_alloc_descs(int irq, unsigned int
 		if (from > irq)
 			return -EINVAL;
 		from = irq;
+	} else {
+		from = arch_dynirq_lower_bound(from);
 	}
 
 	mutex_lock(&sparse_irq_lock);
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -779,3 +779,8 @@ int __init __weak arch_early_irq_init(vo
 {
 	return 0;
 }
+
+unsigned int __weak arch_dynirq_lower_bound(unsigned int from)
+{
+	return from;
+}
