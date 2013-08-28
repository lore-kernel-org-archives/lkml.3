Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3H1TQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:16:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51657 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753666Ab3H1TQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:16:56 -0400
Date: Wed, 28 Aug 2013 15:16:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
cc: David Howells <dhowells@redhat.com>, Ming Lei <ming.lei@canonical.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Memory synchronization vs. interrupt handlers
In-Reply-To: <20130828011923.GS3871@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.44L0.1308281501000.1541-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell, Peter, and Ingo:

Can you folks enlighten us regarding this issue for some common 
architectures?

On Tue, 27 Aug 2013, Paul E. McKenney wrote:

> On Mon, Aug 26, 2013 at 11:49:15AM -0400, Alan Stern wrote:
> > David and Paul:
> > 
> > Here's a question that doesn't seem to be answered in 
> > Documentation/memory-barriers.txt.  Are memory accesses within an 
> > interrupt handler synchronized with respect to interrupts?
> > 
> > In more detail, suppose we have an interrupt handler that uses a memory
> > variable A.  The device attached to the IRQ line sends two interrupt
> > requests, and we get:
> > 
> > 	CPU 0				CPU 1
> > 	-----				-----
> > 	Receive IRQ
> > 	Call the interrupt handler
> > 		Write A
> > 	Finish IRQ processing
> > 
> > 					Receive IRQ
> > 					Call the interrupt handler
> > 						Read A
> > 					Finish IRQ processing
> > 
> > Is CPU 0's write to A guaranteed to be visible on CPU 1?  Given that 
> > interrupts on an IRQ line are serialized, and that IRQ processing must 
> > involve some amount of memory barriers, I would expect the answer to be 
> > Yes.
> 
> I have no idea.  I would hope that it did, but a lot depends on how or
> whether the end-of-interrupt processing is handled by the I/O hardware.

Isn't this the sort of thing the kernel should guarantee?  The
low-level code that fields interrupts ought to do the equivalent of an
"acquire" barrier at the start and a "release" barrier at the end, so
that operations by the higher-level handlers don't "leak out".

For example, if the low-level code would lock and unlock a spinlock at 
the start and end of the interrupt, that would be more than sufficient 
(provided it always used the same spinlock for the same IRQ line).

Of course, drivers needing this behavior can always use their own 
spinlocks.  Still, it seems like this ought to fall under the purview 
of the core kernel.

> I believe that we need to ask the architecture maintainers.  And maybe
> also someone who knows about the devices in question.

The devices aren't relevant here because the variable A resides in
main memory, not on the device.  What matter is, as you say, the
architectural code.

Alan Stern

