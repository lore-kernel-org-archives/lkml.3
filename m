Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaLCWTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:19:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:55864 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLCWTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:19:32 -0500
Date: Wed, 3 Dec 2014 23:19:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFw8L06BxpsVnbdiNaU2WSFo=tafND25uV_SHUig=CC1AA@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412032249050.16275@nanos>
References: <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com> <20141201230339.GA20487@ret.masoncoding.com> <1417529606.3924.26.camel@maggy.simpson.net> <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
 <1417540493.21136.3@mail.thefacebook.com> <20141203184111.GA32005@redhat.com> <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com> <20141203190045.GB32005@redhat.com> <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com>
 <CA+55aFxa90b31Fvy6RkvMneY3+GTR=Nko2Sgj2mk7SSHZC7b6g@mail.gmail.com> <20141203200906.GA3118@redhat.com> <CA+55aFxLmBjTOdGu3TFzTJ-ym7TVLDBt79BKqU-vZbX4CvSGog@mail.gmail.com> <alpine.DEB.2.11.1412032141040.16275@nanos>
 <CA+55aFw8L06BxpsVnbdiNaU2WSFo=tafND25uV_SHUig=CC1AA@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014, Linus Torvalds wrote:
> On Wed, Dec 3, 2014 at 12:55 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > But it's always negative, which means HPET is always ahead of
> > TSC. That excludes pretty much the clocksource watchdog starvation
> > issue which results in TSC being ahead of HPET due to a HPET
> > wraparound (which takes ~300s).
> 
> Still, I'd be more likely to trust the TSC than the HPET on modern
> machines.. And DaveJ's machine isn't some old one.

Well, that does not explain the softlock watchdog which is solely
relying on the TSC.

> Of course, there's always BIOS games. Can we read the TSC offset
> register and check it being constant (modulo sleep events)?

The kernel does not touch it. Here is a untested hack to verify it on
every local apic timer interrupt. Not nice, but simple :)

Thanks.

	tglx
---
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index ba6cc041edb1..69b0a8143e83 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -554,6 +554,7 @@ static struct clock_event_device lapic_clockevent = {
 	.irq		= -1,
 };
 static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
+static DEFINE_PER_CPU(u64, tsc_adjust);
 
 /*
  * Setup the local APIC timer for this CPU. Copy the initialized values
@@ -569,6 +570,13 @@ static void setup_APIC_timer(void)
 		lapic_clockevent.rating = 150;
 	}
 
+	if (this_cpu_has(X86_FEATURE_TSC_ADJUST)) {
+		u64 adj;
+
+		rdmsrl(MSR_IA32_TSC_ADJUST, adj);
+		__this_cpu_write(tsc_adjust, adj);
+	}
+
 	memcpy(levt, &lapic_clockevent, sizeof(*levt));
 	levt->cpumask = cpumask_of(smp_processor_id());
 
@@ -912,6 +920,19 @@ static void local_apic_timer_interrupt(void)
 		return;
 	}
 
+	if (this_cpu_has(X86_FEATURE_TSC_ADJUST)) {
+		u64 adj;
+
+		rdmsrl(MSR_IA32_TSC_ADJUST, adj);
+		if (adj != __this_cpu_read(tsc_adjust)) {
+			pr_err("TSC adjustment on cpu %d changed %llu -> %llu\n",
+			       cpu,
+			       (unsigned long long) __this_cpu_read(tsc_adjust),
+			       (unsigned long long) adj);
+			__this_cpu_write(tsc_adjust, adj);
+		}
+	}
+
 	/*
 	 * the NMI deadlock-detector uses this.
 	 */
