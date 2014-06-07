Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaFGWgF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 18:36:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:57114 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbaFGWgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 18:36:04 -0400
Message-ID: <1402180544.3979.3.camel@pasglop>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>
Date: Sun, 08 Jun 2014 08:35:44 +1000
In-Reply-To: <Pine.LNX.4.44L0.1406071133090.31120-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1406071133090.31120-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-07 at 11:40 -0400, Alan Stern wrote:

> The current xhci-hcd driver includes a quirk flag (XHCI_SPURIOS_WAKEUP) 
> that causes the shutdown routine to reset the controller.  It wasn't 
> meant for fixing kexec problems, but I bet you could use it for that 
> purpose.
> 
> In addition, it's possible that a reset is needed in the probe pathway.

Looking at the code a bit more ... that xhci_shutdown() worries me.

It basically just whacks xhci_halt() and optionally reset() but nothing
is done that I can see to ensure that we aren't concurrently
doing things like queuing URBs, polling the root hub etc...

That's definitely not clean and while it might work (most of the time
at least) on actual shutdown it's definitely not right for kexec I
reckon.

Now there's a separate discussion that we had a while ago and might
want to resume which is to say that kexec shouldn't be calling
shutdown() anyway, but instead remove() on all drivers which is
a much better code path for the purpose of leaving the device in
a state where a driver can reconnect to it.

However, in the case of XHCI that leads to another issue described
here:

http://marc.info/?l=linux-usb&m=139483181809062&w=2

For which there was little / no discussion at all... I suppose we could
do a quirk but I don't think the problem is fundamentally
specific to the TI chip, we should probably stop both root hubs
before we halt both HCDs.

Cheers,
Ben.


