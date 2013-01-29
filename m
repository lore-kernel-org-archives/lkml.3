Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab3A2QEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:04:36 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36125 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab3A2QEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:04:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 29 Jan 2013 17:04:23 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mark Einon <mark.einon@gmail.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] firewire: Fix ohci free_irq() warning
Message-ID: <20130129170423.0f83cd31@stein>
In-Reply-To: <CANK3SE0w08n1RSzqy5dV4eAymAfmnb-a+T9UfVSxw-+3fP-PVA@mail.gmail.com>
References: <1359410988-3740-1-git-send-email-mark.einon@gmail.com>
	<20130129000149.5fa5b0c3@stein>
	<CANK3SE0w08n1RSzqy5dV4eAymAfmnb-a+T9UfVSxw-+3fP-PVA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Cc: linux-pm.

On Jan 29 Mark Einon wrote:
> On 28 January 2013 23:01, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> > On Jan 28 Mark Einon wrote:
> >> This patch fixes the kernel warning generated when putting an MSI MS-1727
> >> GT740 laptop into suspend mode. The call sequence in this case calls
> >> free_irq() twice, once in pci_remove() and once then in pci_suspend().
> >
> > You mean /first/ in pci_suspend() and /then/ in pci_remove() on the
> > already suspended devices, right?
> 
> Yes, I did. The call sequence is suspend then resume. My bad.
> 
> >
> > Because the other way around, first pci_remove(), then pci_suspend(),
> > surely must not appen.  And if it does, the bug is elsewhere but not in
> > firewire-ohci.
> >
> > On that note, is pci_suspend() -> pci_remove() actually a legal state
> > transition that must be handled by drivers?
> 
> It's happening on the Ubuntu 12.10 distro which performs the suspend
> then remove sequence. I assumed that was normal.

Maybe a parent device (PCI bridge or the likes) of the OHCI is
requested to be removed during suspend or is being removed during
resume, thereby causing a removal request to the OHCI?

Or the suspend method of firewire-ohci exited with an error return code...
but then the suspend sequence would be rolled back, not the offending
device be removed, right?

In any case, could you check the dmesg right before the warning which you
already posted --- and right after it too --- whether there is an
indication what else was going on?

Also, what are the parent devices of the OHCI according to "lspci -tv" (or
what else can show PCI topology)?

> > Another comment below.
> <snip>
> >
> > firewire-ohci's pci_resume() calls request_irq() a little bit before that,
> > in ohci_enable().  Is the sequence pci_probe/request_irq() ->
> > pci_suspend/disable_irq() -> pci_resume/request_irq() ->
> > pci_resume/enable_irq() legal?
> 
> I missed the call to request_irq(). Perhaps the simplest way to handle
> the fix would be to use a flag that holds the irq state? I'm open to
> suggestions.

Not sure what extent of state tracking the PCI core or driver core already
offer; I'll have to look.
-- 
Stefan Richter
-=====-===-= ---= ===-=
http://arcgraph.de/sr/
