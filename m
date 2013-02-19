Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934408Ab3BSWq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 17:46:29 -0500
Received: from mxin.vub.ac.be ([134.184.129.112]:16164 "EHLO mxin.vub.ac.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933133Ab3BSWq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 17:46:26 -0500
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2013 17:46:25 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQEAHX9I1GGuBhX/2dsb2JhbABFvz+BA4Ejc4IfAQEFJxM/EAsOCgklDwVJE4gSDLAshxqJCgSPDgeCX2EDliqFX4p6gwg
Date: Tue, 19 Feb 2013 23:36:22 +0100
From: Frederik Himpe <fhimpe@vub.ac.be>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>, David Haerdeman <david@hardeman.nu>,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: do not try to assign irq 255
Message-ID: <20130219223622.GA31434@artipc10.vub.ac.be>
References: <1361182193-31894-1-git-send-email-hare@suse.de>
 <CAErSpo5j5WXx-Y4ML22yzsVzXgXnT9JoD1EGvGRMy55GGRdn6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5j5WXx-Y4ML22yzsVzXgXnT9JoD1EGvGRMy55GGRdn6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 12:47:32PM -0700, Bjorn Helgaas wrote:
> On Mon, Feb 18, 2013 at 3:09 AM, Hannes Reinecke <hare@suse.de> wrote:
> > The PCI config space reseves a byte for the interrupt line,
> > so irq 255 actually refers to 'not set'.
> > However, the 'irq' field for struct pci_dev is an integer,
> > so the original meaning is lost, causing the system to
> > assign an interrupt '255', which fails.
> >
> > So we should _not_ assign an interrupt value here, and
> > allow upper layers to fixup things.
> >
> > This patch make PCI devices with MSI interrupts only
> > (like the xhci device on certain HP laptops) work properly.
> >
> > Cc: Frederik Himpe <fhimpe@vub.ac.be>
> > Cc: Oliver Neukum <oneukum@suse.de>
> > Cc: David Haerdeman <david@hardeman.nu>
> > Cc: linux-usb@vger.kernel.org
> > Cc: linux-pci@vger.kernel.org
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> >
> > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> > index 6186f03..a2db887f 100644
> > --- a/drivers/pci/probe.c
> > +++ b/drivers/pci/probe.c
> > @@ -923,7 +923,8 @@ static void pci_read_irq(struct pci_dev *dev)
> >         dev->pin = irq;
> >         if (irq)
> >                 pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &irq);
> > -       dev->irq = irq;
> > +       if (irq < 255)
> > +               dev->irq = irq;
> >  }
> >
> >  void set_pcie_port_type(struct pci_dev *pdev)
> 
> Is there a bugzilla or other URL with more information (problem
> description, hardware involved, dmesg logs, acpidump, etc)?

https://bugzilla.kernel.org/show_bug.cgi?id=52591
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1072918

Basically it looks like most HP Probook/Elitebook of the Ivy Bridge
generation are affected.

-- 
Frederik Himpe
