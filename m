Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaELDNA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 23:13:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:48525 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaELDM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 23:12:59 -0400
Message-ID: <1399864310.17624.69.camel@pasglop>
Subject: Re: [PATCH 1/5] irq_work: Architecture support for remote irq work
 raise
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Date: Mon, 12 May 2014 13:11:50 +1000
In-Reply-To: <1399853330.17624.52.camel@pasglop>
References: <1399851237-2226-1-git-send-email-fweisbec@gmail.com>
	 <1399851237-2226-2-git-send-email-fweisbec@gmail.com>
	 <1399853330.17624.52.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-12 at 10:08 +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2014-05-12 at 01:33 +0200, Frederic Weisbecker wrote:
> > We are going to extend irq work to support remote queuing.
> > 
> > So lets add a cpu argument to arch_irq_work_raise(). The architectures
> > willing to support that must then provide the backend to raise irq work
> > IPIs remotely.
> > 
> > Initial support is provided for x86 and ARM since they are easily
> > extended. The other archs that overwrite arch_irq_work_raise() seem
> > to use local clock interrupts and therefore need deeper rewrite of their
> > irq work support to implement remote raising.
> 
> Well, looks like it's time to turn it into an IPI... It gets a bit more
> tricky because whether whacking the interrupt controller is safe to
> do from an NMI is safe or not might depend on that irq controller
> implementation...
> 
> It looks like XICS and MPIC should be safe though, so at least we
> should be able to cover ppc64, but I'll leave ppc32 alone.

Correction... that's actually a bit more tricky. We might need an MMIO
to trigger the IPI. That means potentially having to take a hash miss,
and we certainly can't do that at NMI time at the moment.

We *could* hard disable interrupts (which blocks our NMIs since they
arent't real NMIs, they are just a way to bypass our soft-disable state
for perf interrupts) for hash_page, but that still makes me somewhat
nervous.

Another option would be to add an ioremap flag of some description to
be able to install bolted hash entries. (It already does so if called
early enough during boot, so it might actually just work by accident but
that's an undebuggable horror show waiting to happen if we ever change
that).

So needs a bit more thinking on our side.

Cheers,
Ben.


