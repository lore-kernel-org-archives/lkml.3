Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3H3AO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 20:14:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:47128 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab3H3AOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 20:14:55 -0400
Message-ID: <1377821644.4028.41.camel@pasglop>
Subject: Re: Memory synchronization vs. interrupt handlers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: paulmck@linux.vnet.ibm.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Stern <stern@rowland.harvard.edu>,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        David Howells <dhowells@redhat.com>, Ming Lei <ming.lei@canonical.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        arnd.bergmann@linaro.org, olof@lixom.net
Date: Fri, 30 Aug 2013 10:14:04 +1000
In-Reply-To: <20130829235136.GX3871@linux.vnet.ibm.com>
References: <Pine.LNX.4.44L0.1308281501000.1541-100000@iolanthe.rowland.org>
	 <521E5D58.5070708@zytor.com> <20130829235136.GX3871@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-29 at 16:51 -0700, Paul E. McKenney wrote:
> On Wed, Aug 28, 2013 at 01:28:08PM -0700, H. Peter Anvin wrote:
> > On 08/28/2013 12:16 PM, Alan Stern wrote:
> > > Russell, Peter, and Ingo:
> > > 
> > > Can you folks enlighten us regarding this issue for some common 
> > > architectures?
> > 
> > On x86, IRET is a serializing instruction; it guarantees hard
> > serialization of absolutely everything.
> 
> So a second interrupt from this same device could not appear to happen
> before the IRET, no matter what device and/or I/O bus?  Or is IRET
> defined to synchronize all the way out to the whatever device is
> generating the next interrupt?
> 
> > I would expect architectures that have weak memory ordering to put
> > appropriate barriers in the IRQ entry/exit code.

Not sure why you would expect that, there is no reason to do such a
thing.

> Adding a few on CC.  Also restating the question as I understand it:
> 
> 	Suppose that a given device generates an interrupt on CPU 0,
> 	but that before CPU 0's interrupt handler completes, this device
> 	wants to generate a second interrupt on CPU 1.  This can happen
> 	as soon as CPU 0's handler does an EOI or equivalent.

By "interrupt handler" are you talking about the general handling of all
interrupts in the kernel or the device specific interrupt handler ?

Typically the EOI is done after the later has run.

> 	Can CPU 1's interrupt handler assume that all the in-memory effects
> 	of CPU 0's interrupt handler will be visible, even if neither
> 	interrupt handler uses locking or memory barriers?

We don't formally provide such a guarantee no. There is a spin_lock on
the way back from the device handler and before the EOI but not an
unlock so we don't have a full ordering here (see handle_irq_event).

At least on powerpc, the EOI will generally be an MMIO which will
however synchronize everything because we have a sync before the store
in our MMIO accessors, but that might not be true when running under the
pHyp hypervisor, as we do a hypercall there and I don't think that
includes a sync instruction inside the hypervisor.

So I'd say that as-is, no, we don't provide that guarantee.

Cheers,
Ben.

> 
> 							Thanx, Paul
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


