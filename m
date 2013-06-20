Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965844Ab3FTVkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:40:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:43263 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965663Ab3FTVkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:40:47 -0400
Message-ID: <1371764435.3944.30.camel@pasglop>
Subject: Re: Masked MSIs expectations
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 21 Jun 2013 07:40:35 +1000
In-Reply-To: <20130620133314.GR2575@8bytes.org>
References: <1368086982.25488.165.camel@pasglop>
	 <20130620133314.GR2575@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 15:33 +0200, Joerg Roedel wrote:
> (In case this topic is still relevant)
> 
> On Thu, May 09, 2013 at 06:09:42PM +1000, Benjamin Herrenschmidt wrote:
> > Do we provide drivers any guarantee to what happen if an MSI is shot
> > while masked with disable_irq() or while not yet request_irq()'ed ?
> > 
> > Do we guarantee delivery (latched while masked), non-delivery, or
> > undefined ?
> 
> I am not aware of any guarantees the kernel gives in this situation. I
> think it would just drop the IRQ and print a "nobody cared" message.

Well, I was not necessarily talking about the kernel reaction here, my
statement was high level, it could be that the interrupt controller
latches it and "shoots" it as soon as enabled for example in some cases,
or drops it in others.

Also we wouldn't print a message in the kernel, we "lazy disable" edge
interrupts, so we would just drop it.

> > I'm bringing up a piece of HW where if it happened, it won't be
> > automatically sent to the CPU and can block further MSIs unless I
> > explicitly either ditch it or force a resend when unmasking (at the PCI
> > Express controller PIC level).
> > 
> > I'm tempted to just ditch anything that happened while masked, it would
> > make everything easier on my side, but maybe drivers have different
> > expectations (and of course an LSI would still shoot, that's not an
> > issue, only MSIs are in question here).
> > 
> > I have cases of devices continuing to shoot one or two MSIs after kexec
> > and before the new kernel takes over, causing a "loss" of any subsequent
> > one unless I deal with that case one way or another.
> 
> I would also just ditch such IRQs that happen in that kexec case and
> make sure that they will work again when the kexec-kernel device driver
> wants to initialize them.

Yes, in the kexec case it sounds obvious to just ditch anything, but I
wanted to make sure of the general idea, ie, if the driver temporarily
does disable_irq()/enable_irq() I can potentially ditch them all too,
rather than "latch" them. 

Anyway, I've done that, so far so good.

Cheers,
Ben.

> 	Joerg
> 


