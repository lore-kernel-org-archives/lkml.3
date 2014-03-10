Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaCJSYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 14:24:38 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:63610 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaCJSYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 14:24:36 -0400
Date: Mon, 10 Mar 2014 12:24:31 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Steven Newbury <steve@snewbury.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [Intel-gfx] agp/intel: can't ioremap flush page - no chipset
 flushing
Message-ID: <20140310182431.GA11424@google.com>
References: <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
 <1391951759.6036.7.camel@artifact>
 <1391952344.25424.4.camel@x220>
 <CAErSpo6uj_Kuk0_F97nRsnM1Pss4C7=HeEaVu6D-NwFFK=1cvA@mail.gmail.com>
 <1394185698.5608.5.camel@x41>
 <CAErSpo4jiq38P3TNuGLGS--nbV9NtUAmiuK=cwWyFAneY-=eOA@mail.gmail.com>
 <1394212609.1987.6.camel@x41>
 <20140307204021.GA9822@google.com>
 <CAErSpo7Np8oju1ENQA5EgEpN4=Vv7f3s4E823ecbyp6FCWPL_Q@mail.gmail.com>
 <1394289877.31006.2.camel@x41>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394289877.31006.2.camel@x41>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci]

On Sat, Mar 08, 2014 at 03:44:37PM +0100, Paul Bolle wrote:
> Bjorn Helgaas schreef op za 08-03-2014 om 07:12 [-0700]:
> > I assume you have CONFIG_PHYS_ADDR_T_64BIT=n (which is perfectly
> > legal); let me know if otherwise.
> 
> $ grep CONFIG_PHYS_ADDR_T_64BIT /boot/config-3.14.0-0.rc5.1.local2.fc20.i686 
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> 
> So, yes, CONFIG_PHYS_ADDR_T_64BIT=n here.

Thanks.  Can you try the patch below?  I think it should fix the problem.


PCI: Don't check resource_size() in pci_bus_alloc_resource()

From: Bjorn Helgaas <bhelgaas@google.com>

When resource_size_t is 32 bits wide, e.g., when CONFIG_PHYS_ADDR_T_64BIT
is not defined, resource_size() on [mem 0x00000000-0xffffffff] returns 0
because (r->end - r->start + 1) overflows.

Therefore, we can't use "resource_size() == 0" to decide that allocation
from this resource will fail.  allocate_resource() should fail anyway if it
can't satisfy the address constraints, so we should just depend on that.

A [mem 0x00000000-0xffffffff] bus resource is obviously not really valid,
but we do fall back to it as a default when we don't have information about
host bridge apertures.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=71611
Fixes: f75b99d5a77d PCI: Enforce bus address limits in resource allocation
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/bus.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 00660cc502c5..38901665c770 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -162,8 +162,6 @@ static int pci_bus_alloc_from_region(struct pci_bus *bus, struct resource *res,
 
 		avail = *r;
 		pci_clip_resource_to_region(bus, &avail, region);
-		if (!resource_size(&avail))
-			continue;
 
 		/*
 		 * "min" is typically PCIBIOS_MIN_IO or PCIBIOS_MIN_MEM to
