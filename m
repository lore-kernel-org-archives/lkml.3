Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab3BAVMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 16:12:03 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:52275 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757227Ab3BAVL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 16:11:59 -0500
Message-ID: <1359752988.22968.16.camel@thor.lan>
Subject: Re: [PATCH] firewire: Fix ohci free_irq() warning
From: Peter Hurley <peter@hurleysoftware.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Fri, 01 Feb 2013 16:09:48 -0500
In-Reply-To: <CANK3SE25kcgSu2dwKtQKU6-wvryC4qNQJu_nj3NPJHQTTC0oXw@mail.gmail.com>
References: <CANK3SE09VqvshdLrV4xp2W8BHZqLmuz-pV9jQVj7tbk1JBX+9g@mail.gmail.com>
	 <Pine.LNX.4.44L0.1301311002190.1876-100000@iolanthe.rowland.org>
	 <CANK3SE25kcgSu2dwKtQKU6-wvryC4qNQJu_nj3NPJHQTTC0oXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-01 at 19:13 +0000, Mark Einon wrote:
> On 31 January 2013 15:04, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Wed, 30 Jan 2013, Mark Einon wrote:
> >
> >> >> > >> This patch fixes the kernel warning generated when putting an MSI MS-1727
> >> >> > >> GT740 laptop into suspend mode. The call sequence in this case calls
> >> >> > >> free_irq() twice, once in pci_remove() and once then in pci_suspend().
> >> >> > >
> >> >> > > You mean /first/ in pci_suspend() and /then/ in pci_remove() on the
> >> >> > > already suspended devices, right?
> >> >> >
> >> >> > Yes, I did. The call sequence is suspend then resume. My bad.
> >> >
> >> > Why does the pci_suspend routine call free_irq() at all?  As far as I
> >> > know, it's not supposed to do that.  Won't the device continue to use
> >> > the same IRQ after it is resumed?
> >>
> >> This sounds reasonable to me - I think we could probably get rid of
> >> the request_irq() call from resume, and use
> >> disable_irq()/enable_irq()?
> >
> > Why mess around with IRQ settings at all?  Just have the suspend
> > routine tell the controller to stop generating them.
> >
> > Alan Stern
> >
> 
> I looked into doing this; using context_stop() to stop the controller running.
> 
> However, removing the enable_irq() from pci_resume() involves not
> calling ohci_enable() (as it is also the fw_card_driver.enable
> function, and can't easily be modified). As this call involves a lot
> of register writes and I have no devices to test, I decided against
> it.
> 
> I'll send an updated patch for consideration that merely uses a bool
> to stop the irq being freed twice - crude, but it works without
> changing too much code.

Hi Mark,

I think what Alan means is that the suspend/resume code should just
mask/unmask interrupts at the OHCI controller, via the OHCI
IntEventClear/Set registers (naturally, saving the current mask and
restoring it on resume).

Of course, there's a lot more to do with an OHCI controller -- as you
note. Like stopping running DMA contexts :)  And restarting them on
resume.

I'd do it, but I'm buried to my eyeballs in tty right now -- not fun. I
can _eventually_ do this as I need to address problems with the FW643
anyway at some point, but it's going to be a little while.

In the meantime, I'm a little confused: you say you can't test this code
because you have no hardware; but then how'd you trip this bug?

Regards,
Peter Hurley

