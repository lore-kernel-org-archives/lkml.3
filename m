Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbaELQ35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:29:57 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:34463 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbaELQ3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:29:55 -0400
Date: Mon, 12 May 2014 18:29:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
Subject: Re: [PATCH 1/5] irq_work: Architecture support for remote irq work
 raise
Message-ID: <20140512162947.GB28033@localhost.localdomain>
References: <1399851237-2226-1-git-send-email-fweisbec@gmail.com>
 <1399851237-2226-2-git-send-email-fweisbec@gmail.com>
 <1399853330.17624.52.camel@pasglop>
 <1399864310.17624.69.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399864310.17624.69.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 01:11:50PM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2014-05-12 at 10:08 +1000, Benjamin Herrenschmidt wrote:
> > On Mon, 2014-05-12 at 01:33 +0200, Frederic Weisbecker wrote:
> > > We are going to extend irq work to support remote queuing.
> > > 
> > > So lets add a cpu argument to arch_irq_work_raise(). The architectures
> > > willing to support that must then provide the backend to raise irq work
> > > IPIs remotely.
> > > 
> > > Initial support is provided for x86 and ARM since they are easily
> > > extended. The other archs that overwrite arch_irq_work_raise() seem
> > > to use local clock interrupts and therefore need deeper rewrite of their
> > > irq work support to implement remote raising.
> > 
> > Well, looks like it's time to turn it into an IPI... It gets a bit more
> > tricky because whether whacking the interrupt controller is safe to
> > do from an NMI is safe or not might depend on that irq controller
> > implementation...
> > 
> > It looks like XICS and MPIC should be safe though, so at least we
> > should be able to cover ppc64, but I'll leave ppc32 alone.
> 
> Correction... that's actually a bit more tricky. We might need an MMIO
> to trigger the IPI. That means potentially having to take a hash miss,
> and we certainly can't do that at NMI time at the moment.
> 
> We *could* hard disable interrupts (which blocks our NMIs since they
> arent't real NMIs, they are just a way to bypass our soft-disable state
> for perf interrupts) for hash_page, but that still makes me somewhat
> nervous.
> 
> Another option would be to add an ioremap flag of some description to
> be able to install bolted hash entries. (It already does so if called
> early enough during boot, so it might actually just work by accident but
> that's an undebuggable horror show waiting to happen if we ever change
> that).
> 
> So needs a bit more thinking on our side.

Yeah, well if we ever end up with native remote irq work, only local raise
will need to be NMI-safe. If that ever helps...
