Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab3BBPBV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 10:01:21 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53347 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3BBPBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 10:01:20 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 2 Feb 2013 16:01:03 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mark Einon <mark.einon@gmail.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] firewire: Fix ohci free_irq() warning
Message-ID: <20130202160103.0ce1fc43@stein>
In-Reply-To: <CANK3SE2nsxLMUyANzsov4d86ow4v9NuzaZsS3XvjpQJOfYXYUQ@mail.gmail.com>
References: <CANK3SE09VqvshdLrV4xp2W8BHZqLmuz-pV9jQVj7tbk1JBX+9g@mail.gmail.com>
	<Pine.LNX.4.44L0.1301311002190.1876-100000@iolanthe.rowland.org>
	<CANK3SE25kcgSu2dwKtQKU6-wvryC4qNQJu_nj3NPJHQTTC0oXw@mail.gmail.com>
	<1359752988.22968.16.camel@thor.lan>
	<CANK3SE2nsxLMUyANzsov4d86ow4v9NuzaZsS3XvjpQJOfYXYUQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 01 Mark Einon wrote:
> On 1 February 2013 21:09, Peter Hurley <peter@hurleysoftware.com> wrote:
> >>>> On Jan 29 Alan Stern wrote:
> >>>>> Why does the pci_suspend routine call free_irq() at all?  As far as I 
> >>>>> know, it's not supposed to do that.  Won't the device continue to use 
> >>>>> the same IRQ after it is resumed?

As far as I can tell, it happened to be done that way as a side effect of
how the probe() and resume() methods share code.  It has remained like
this since the initial implementation:
http://git.kernel.org/linus/2aef469a35a2

Still, at this point I would like to learn whether .suspend() followed
by .remove() is a valid order of sequence which drivers must support
before I prepare myself to get comfortable with a refactoring of
firewire-ohci's .probe()/.resume()/suspend()/remove().  Obviously, so far
my assumption was that a successful .suspend() can only ever be followed
by .resume().

> > I think what Alan means is that the suspend/resume code should just
> > mask/unmask interrupts at the OHCI controller, via the OHCI
> > IntEventClear/Set registers (naturally, saving the current mask and
> > restoring it on resume).
> >
> > Of course, there's a lot more to do with an OHCI controller -- as you
> > note. Like stopping running DMA contexts :)  And restarting them on
> > resume.
> >
> > I'd do it, but I'm buried to my eyeballs in tty right now -- not fun. I
> > can _eventually_ do this as I need to address problems with the FW643
> > anyway at some point, but it's going to be a little while.
> 
> Hi Peter,
> 
> Ok, understood. I can certainly attempt a patch if I get time.
> 
> >
> > In the meantime, I'm a little confused: you say you can't test this code
> > because you have no hardware; but then how'd you trip this bug?
> 
> I can test the code in that I have a firewire port on my laptop, but
> haven't got anything to plug into the port.
> I assume that any large changes I make are quite capable of breaking
> something there...

This is a valid assumption.  Some years ago I caused a regression in
stable kernel branches in exactly this way myself.
-- 
Stefan Richter
-=====-===-= --=- ---=-
http://arcgraph.de/sr/
