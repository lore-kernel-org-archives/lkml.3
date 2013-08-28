Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3H1CiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 22:38:19 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48508 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab3H1CiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 22:38:14 -0400
Date: Tue, 27 Aug 2013 18:19:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Howells <dhowells@redhat.com>, Ming Lei <ming.lei@canonical.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Memory synchronization vs. interrupt handlers
Message-ID: <20130828011923.GS3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CACVXFVMi8VU=m_XkdToAWtMDj-AJ2H+Jz6J4yy0=YWAweV1UMA@mail.gmail.com>
 <Pine.LNX.4.44L0.1308261129200.1445-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308261129200.1445-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082802-7164-0000-0000-0000010EDA9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 11:49:15AM -0400, Alan Stern wrote:
> David and Paul:
> 
> Here's a question that doesn't seem to be answered in 
> Documentation/memory-barriers.txt.  Are memory accesses within an 
> interrupt handler synchronized with respect to interrupts?
> 
> In more detail, suppose we have an interrupt handler that uses a memory
> variable A.  The device attached to the IRQ line sends two interrupt
> requests, and we get:
> 
> 	CPU 0				CPU 1
> 	-----				-----
> 	Receive IRQ
> 	Call the interrupt handler
> 		Write A
> 	Finish IRQ processing
> 
> 					Receive IRQ
> 					Call the interrupt handler
> 						Read A
> 					Finish IRQ processing
> 
> Is CPU 0's write to A guaranteed to be visible on CPU 1?  Given that 
> interrupts on an IRQ line are serialized, and that IRQ processing must 
> involve some amount of memory barriers, I would expect the answer to be 
> Yes.

I have no idea.  I would hope that it did, but a lot depends on how or
whether the end-of-interrupt processing is handled by the I/O hardware.

> Does the answer change if the IRQ line is shared?  I wouldn't expect 
> it to be.
> 
> Now, if the handler were bound to multiple IRQ (or MSI) lines, then
> there'd be no reason to expect this to work.  However, even in this
> case, it seems that as long as we restrict our attention to handler
> invocations in response to interrupt requests from one particular IRQ
> line, the answer should be Yes.  (For example, if device X on IRQ I and 
> device Y on IRQ J both used the same handler, a write to A in response 
> to an interrupt from device X should be visible the next time X sends
> an interrupt.)
> 
> Do you know the answers?

I believe that we need to ask the architecture maintainers.  And maybe
also someone who knows about the devices in question.

							Thanx, Paul

