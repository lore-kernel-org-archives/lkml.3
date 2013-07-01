Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab3GAH55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 03:57:57 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33580 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab3GAH54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:57:56 -0400
Date: Mon, 1 Jul 2013 17:48:22 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Brad Boyer <flar@allandria.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k/mac: Allocate IOP message pool and queues
 dynamically
In-Reply-To: <20130701065258.GA8425@cynthia.pants.nu>
Message-ID: <alpine.LNX.2.00.1307011741500.9202@nippy.intranet>
References: <1372586542-1318-1-git-send-email-geert@linux-m68k.org> <20130701065258.GA8425@cynthia.pants.nu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 30 Jun 2013, Brad Boyer wrote:

> On Sun, Jun 30, 2013 at 12:02:22PM +0200, Geert Uytterhoeven wrote:
> >  
> >  	if (iop_scc_present) {
> >  		printk("IOP: detected SCC IOP at %p\n", iop_base[IOP_NUM_SCC]);
> > +		alloc_msg_queue(IOP_NUM_SCC);
> 
> Technically, this isn't actually useful. As long as we never start this
> IOP, it can't ever send or be sent any messages.

That assumes that the SCC IOP is in a stopped state after iop_preinit(). 
But I don't think that's the case. If it is technically possible to 
exchange messages with a device in bypass mode (?) then I think the code 
above is correct.

> > @@ -315,6 +307,9 @@ void __init iop_register_interrupts(void)
> >  		} else {
> >  			printk("IOP: the ISM IOP seems to be alive.\n");
> >  		}
> 
> The if/else above isn't useful if it is run before the call to 
> iop_start. However, it's also useless if it is called immediately after 
> the call to iop_alive which is now below. It was supposed to eventually 
> be called in the background on a regular schedule, but that never 
> happened.
> 

I agree. That if/else statement and the conditional printk's should be 
omitted.

I had thought that in the existing code the interrupt service routine was 
registered before the call to iop_start() but in fact iop_start() happens 
first. Looks like a bug to me. The interrupt handler needs to be able to 
acknowledge unsolicited messages...

Finn
