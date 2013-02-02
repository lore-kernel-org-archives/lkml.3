Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab3BBPQD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 10:16:03 -0500
Received: from netrider.rowland.org ([192.131.102.5]:43512 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757731Ab3BBPQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 10:16:01 -0500
Date: Sat, 2 Feb 2013 10:16:00 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Mark Einon <mark.einon@gmail.com>, Peter Hurley <peter@hurleysoftware.com>,
        <linux1394-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] firewire: Fix ohci free_irq() warning
In-Reply-To: <20130202160103.0ce1fc43@stein>
Message-ID: <Pine.LNX.4.44L0.1302021010340.25931-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Feb 2013, Stefan Richter wrote:

> On Feb 01 Mark Einon wrote:
> > On 1 February 2013 21:09, Peter Hurley <peter@hurleysoftware.com> wrote:
> > >>>> On Jan 29 Alan Stern wrote:
> > >>>>> Why does the pci_suspend routine call free_irq() at all?  As far as I 
> > >>>>> know, it's not supposed to do that.  Won't the device continue to use 
> > >>>>> the same IRQ after it is resumed?
> 
> As far as I can tell, it happened to be done that way as a side effect of
> how the probe() and resume() methods share code.  It has remained like
> this since the initial implementation:
> http://git.kernel.org/linus/2aef469a35a2

At one point, quite a few years ago, Linus complained about drivers the 
release IRQs during suspend only to reacquire them during resume.  A 
little refactoring should be able to separate out resource 
acquisition/release (done only during probe and remove) from activation 
and shutdown (also done during resume and suspend).

> Still, at this point I would like to learn whether .suspend() followed
> by .remove() is a valid order of sequence which drivers must support
> before I prepare myself to get comfortable with a refactoring of
> firewire-ohci's .probe()/.resume()/suspend()/remove().  Obviously, so far
> my assumption was that a successful .suspend() can only ever be followed
> by .resume().

It depends on the subsystem.  Some subsystems do have suspend -> remove
transitions and others don't.  In general, it's a good idea for drivers
to be prepared for removal while the system is asleep.  Presumably any
hot-unpluggable bus (which includes most of the important buses these
days) would have to support it.

Alan Stern

