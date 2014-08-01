Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaHANn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:43:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:41807 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaHANnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:43:25 -0400
Date: Fri, 1 Aug 2014 15:43:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] irq / PM: New driver interface for wakeup
 interruptsn
In-Reply-To: <19816559.O6O5RjzKM1@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.10.1408011533580.4997@nanos>
References: <20140724212620.GO3935@laptop> <1624300.2IhdzCt5pu@vostro.rjw.lan> <alpine.DEB.2.10.1408010217090.4997@nanos> <19816559.O6O5RjzKM1@vostro.rjw.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2014, Rafael J. Wysocki wrote:
> OK, I guess "IRQ_HANDLED from a wakeup interrupt" may be interpreted as
> IRQ_HANDLED_PMWAKE.  On the other hand, if that's going to be handled in
> handle_irq_event_percpu(), then using a special return code would save us
> a brach for IRQ_HANDLED interrupts.  We could convert it to IRQ_HANDLED
> immediately then.

We can handle it at the end of the function by calling
note_interrupt() unconditionally do the following there:

      if (suspended) {
      	 if (ret == IRQ_NONE) {
	    if (shared)
	       yell_and_abort_or_resume();
         } else {
	    abort_or_resume();
         }
      }
      if (noirqdebug)
      	 return;
 
> OK, I'll take a stab at the IRQF_SHARED thing if you don't mind.

Definitely not :)

> Here's my current understanding of what can be done for IRQF_NO_SUSPEND.
> 
> In suspend_device_irqs():
> 
> (1) If all actions in the list have the same setting (eg. IRQF_NO_SUSPEND unset),
>     keep the current behavior.
> (2) If the actions have different settings:
>     - Actions with IRQF_NO_SUSPEND set are not modified.
>     - Actions with IRQF_NO_SUSPEND unset are switched over to a stub handler.
>     - IRQS_SUSPEND_MODE (new flag) is set for the IRQ.

Can we please do that in setup_irq() and let the shared ones always
run through the stub? That keeps suspend/resume_device_irqs() simple.

Thanks,

	tglx
