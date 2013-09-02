Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447Ab3IBLnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 07:43:43 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:38837 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758419Ab3IBLnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 07:43:41 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1308261129200.1445-100000@iolanthe.rowland.org>
References: <CACVXFVMi8VU=m_XkdToAWtMDj-AJ2H+Jz6J4yy0=YWAweV1UMA@mail.gmail.com>
 <Pine.LNX.4.44L0.1308261129200.1445-100000@iolanthe.rowland.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 2 Sep 2013 12:43:21 +0100
X-Google-Sender-Auth: twBY9qICnoCJvrXic-i4ws4CXqA
Message-ID: <CAHkRjk5LdzTCY2w+OJo2Xm9CxBPnXgY7cfJhMYW0nV9J0QmOTg@mail.gmail.com>
Subject: Re: Memory synchronization vs. interrupt handlers
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ming Lei <ming.lei@canonical.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 August 2013 16:49, Alan Stern <stern@rowland.harvard.edu> wrote:
> Here's a question that doesn't seem to be answered in
> Documentation/memory-barriers.txt.  Are memory accesses within an
> interrupt handler synchronized with respect to interrupts?
>
> In more detail, suppose we have an interrupt handler that uses a memory
> variable A.  The device attached to the IRQ line sends two interrupt
> requests, and we get:
>
>         CPU 0                           CPU 1
>         -----                           -----
>         Receive IRQ
>         Call the interrupt handler
>                 Write A
>         Finish IRQ processing
>
>                                         Receive IRQ
>                                         Call the interrupt handler
>                                                 Read A
>                                         Finish IRQ processing
>
> Is CPU 0's write to A guaranteed to be visible on CPU 1?  Given that
> interrupts on an IRQ line are serialized, and that IRQ processing must
> involve some amount of memory barriers, I would expect the answer to be
> Yes.

On arm (or arm64), this is not guaranteed. Finishing the IRQ
processing usually involves a device write but there is no ordering
required with other write accesses. It could easily be fixed in the
IRQ controller code (drivers/irqchip/irq-gic.c for newer ARM
processors). We have a barrier for SMP cross-calls for the same
ordering reason, so I guess we need one for EOI as well.

In practice I would think it's nearly impossible to hit this issue,
given the time to save the state when taking the interrupt plus some
spinlocks, the write from CPU0 would become visible.

Also, if the data is accessed by the same driver with the same IRQ,
most likely the interrupt goes to the same CPU (unless you had some
rebalancing, but this being rarer it makes it less likely). If the
data is being accessed between two separate IRQ handlers, a spinlock
must be used anyway.

-- 
Catalin
