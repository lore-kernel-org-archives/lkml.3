Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab3HZPtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:49:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59150 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751909Ab3HZPtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:49:16 -0400
Date: Mon, 26 Aug 2013 11:49:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ming Lei <ming.lei@canonical.com>
cc: USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Memory synchronization vs. interrupt handlers
In-Reply-To: <CACVXFVMi8VU=m_XkdToAWtMDj-AJ2H+Jz6J4yy0=YWAweV1UMA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1308261129200.1445-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David and Paul:

Here's a question that doesn't seem to be answered in 
Documentation/memory-barriers.txt.  Are memory accesses within an 
interrupt handler synchronized with respect to interrupts?

In more detail, suppose we have an interrupt handler that uses a memory
variable A.  The device attached to the IRQ line sends two interrupt
requests, and we get:

	CPU 0				CPU 1
	-----				-----
	Receive IRQ
	Call the interrupt handler
		Write A
	Finish IRQ processing

					Receive IRQ
					Call the interrupt handler
						Read A
					Finish IRQ processing

Is CPU 0's write to A guaranteed to be visible on CPU 1?  Given that 
interrupts on an IRQ line are serialized, and that IRQ processing must 
involve some amount of memory barriers, I would expect the answer to be 
Yes.

Does the answer change if the IRQ line is shared?  I wouldn't expect 
it to be.

Now, if the handler were bound to multiple IRQ (or MSI) lines, then
there'd be no reason to expect this to work.  However, even in this
case, it seems that as long as we restrict our attention to handler
invocations in response to interrupt requests from one particular IRQ
line, the answer should be Yes.  (For example, if device X on IRQ I and 
device Y on IRQ J both used the same handler, a write to A in response 
to an interrupt from device X should be visible the next time X sends
an interrupt.)

Do you know the answers?

Alan Stern

