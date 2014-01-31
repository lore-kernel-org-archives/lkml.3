Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237AbaAaU3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:29:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55492 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932460AbaAaU3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:29:40 -0500
Date: Fri, 31 Jan 2014 21:29:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 2/2] timer: really raise softirq if there is irq_work to
 do
Message-ID: <20140131202933.GE2936@laptop.programming.kicks-ass.net>
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>
 <1391178845-15837-2-git-send-email-bigeasy@linutronix.de>
 <20140131120757.594e24d6@gandalf.local.home>
 <20140131174227.GN9012@linux.vnet.ibm.com>
 <20140131125719.73340f6e@gandalf.local.home>
 <52EBF8FE.3080608@linutronix.de>
 <20140131143441.478f79ee@gandalf.local.home>
 <52EBFE1D.4020201@linutronix.de>
 <20140131200535.GR5002@laptop.programming.kicks-ass.net>
 <52EC0658.3010205@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52EC0658.3010205@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 09:23:52PM +0100, Sebastian Andrzej Siewior wrote:
> Okay, this makes sense. What looked odd was the powerpc implementation
> where they let the timer interrupt expire and call the irq_work from
> the timer interrupt just before the clockevents callback is executed
> (which would invoke the irq_work callback as well).

Ah, so what I remember Paul Mackerras saying was that that was the
easiest way to trigger an interrupt on the local CPU.

ARM runs the things from every IRQ tail IIRC (or maybe only the PMI, I
forget).

> Would it be a win if we would remove the arch specific code and instead
> raise the timer interrupt asap? It sure won't be a win or change for
> -RT but it would allow all architectures to get irq_work done as soon
> as possible in IRQ context (and out of NMI context if I understand
> correct) without an arch specific implementation.

No, because poking at timer hardware on x86 is stupid expensive, whereas
sending a self-IPI through the APIC is tons cheaper.

Also, I don't really want to poke at the fragile x86 timer hardware from
NMI context while we might already be poking at it from another context.


