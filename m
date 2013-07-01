Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab3GAWtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:49:00 -0400
Received: from cynthia.allandria.com ([76.245.85.235]:33080 "EHLO
	cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab3GAWs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:48:59 -0400
Date: Mon, 1 Jul 2013 15:48:54 -0700
From: Brad Boyer <flar@allandria.com>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k/mac: Allocate IOP message pool and queues
 dynamically
Message-ID: <20130701224854.GB12663@cynthia.pants.nu>
References: <1372586542-1318-1-git-send-email-geert@linux-m68k.org>
 <20130701065258.GA8425@cynthia.pants.nu>
 <alpine.LNX.2.00.1307011741500.9202@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1307011741500.9202@nippy.intranet>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 05:48:22PM +1000, Finn Thain wrote:
> 
> On Sun, 30 Jun 2013, Brad Boyer wrote:
> 
> > On Sun, Jun 30, 2013 at 12:02:22PM +0200, Geert Uytterhoeven wrote:
> > >  
> > >  	if (iop_scc_present) {
> > >  		printk("IOP: detected SCC IOP at %p\n", iop_base[IOP_NUM_SCC]);
> > > +		alloc_msg_queue(IOP_NUM_SCC);
> > 
> > Technically, this isn't actually useful. As long as we never start this
> > IOP, it can't ever send or be sent any messages.
> 
> That assumes that the SCC IOP is in a stopped state after iop_preinit(). 
> But I don't think that's the case. If it is technically possible to 
> exchange messages with a device in bypass mode (?) then I think the code 
> above is correct.

You're right. The value we write during iop_preinit actually leaves the
IOP running. I'm not sure why we did that. I wonder if it's possible to
put the ISM IOP into bypass mode and still use the ADB driver. Then we
could possibly use the normal SWIM driver on these systems.

> > > @@ -315,6 +307,9 @@ void __init iop_register_interrupts(void)
> > >  		} else {
> > >  			printk("IOP: the ISM IOP seems to be alive.\n");
> > >  		}
> > 
> > The if/else above isn't useful if it is run before the call to 
> > iop_start. However, it's also useless if it is called immediately after 
> > the call to iop_alive which is now below. It was supposed to eventually 
> > be called in the background on a regular schedule, but that never 
> > happened.
> > 
> 
> I agree. That if/else statement and the conditional printk's should be 
> omitted.
> 
> I had thought that in the existing code the interrupt service routine was 
> registered before the call to iop_start() but in fact iop_start() happens 
> first. Looks like a bug to me. The interrupt handler needs to be able to 
> acknowledge unsolicited messages...

Yes, we definitely should install the IRQ handler before calling iop_start.

	Brad Boyer
	flar@allandria.com

