Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaJGSmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:42:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42788 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753242AbaJGSme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:42:34 -0400
Date: Tue, 7 Oct 2014 14:42:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Krzysztof Opasiak <k.opasiak@samsung.com>,
        "'Robert Baldyga'" <r.baldyga@samsung.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <andrzej.p@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
In-Reply-To: <20141007175713.GA16781@saruman>
Message-ID: <Pine.LNX.4.44L0.1410071429500.1504-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2014, Felipe Balbi wrote:

> > It seems to me that we should imitate what an ordinary USB device would
> > do.  If part of the firmware crashes, generally you would expect none
> > of the endpoints associated with that function to work.  Either they
> > refuse to accept output from the host or they stall everything.  But
> > endpoints associated with other parts of the firmware might very well
> > continue to work okay.
> 
> dunno, I have never seen a USB device firmware crash and I don't think
> anybody deliberately does anything to make sure other parts of the
> device work. If it _does_ work, I'd assume it's really by chance.

I've seen it happen lots of times, but only on single-function devices.  
When it somes to multi-function devices, who knows?

Still, with the single-function devices, firmware crashes generally 
don't lead to disconnections.  Sometimes they do, but usually they 
don't.

> > Don't buffer requests.  Either allow the internal FIFOs to fill up or
> > else reject everything.  Any reasonable host will start getting timeout
> > expirations and will realize that something is wrong.
> 
> Right, but if we allow this, I can already see folks abusing to connect
> to the host early and only when necessary do some trickery to e.g. start
> adbd (not saying Android will do this, just using it as an easy
> example).

We can still keep the pullup turned off until all the functions are
ready.  That's a part of normal behavior -- unlike what happens when a
userspace component crashes or is killed.

> Sure, we can deactivate and only activate when files are opened but is
> there any guarantee that when a process receives segfault that we will
> have, from FFS point of view, any information to know that the thing
> crashed ? I mean, a userland application can register its own handler
> for SIGSEGV/SIGKILL, right ? And that handler could very well just call
> close() on all file descriptors. Then how do we differentiate a normal
> close() from a "oh-crap-I-died" close() ?

We can't, so why worry about it?

If a file handle was closed for normal reasons then userspace probably 
in the middle of shutting down the gadget anyway.  If not then the 
user will get what they deserve.

If the file handle was closed for abnormal reasons, we can behave like 
crashed firmware.  Which means, in the end, doing the same thing as in 
the normal-reason case -- i.e., do nothing.  In particular, don't 
disconnect.

If you want to allow for the possibility of orderly shutdown (and maybe 
even possible restart) of a userspace handler, the function library 
should first tell the kernel explicitly to disconnect.  Then function 
components can be changed around completely, and when everything is 
ready, userspace can tell the kernel to connect again.

Alan Stern

