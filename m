Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbbAPQP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:15:58 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:47296 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbbAPQP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:15:56 -0500
Date: Fri, 16 Jan 2015 10:15:52 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] PCI: Reset exclusions
Message-ID: <20150116161552.GH29776@google.com>
References: <20141121180322.26669.65689.stgit@gimli.home>
 <20150116002802.GE29776@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116002802.GE29776@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 06:28:02PM -0600, Bjorn Helgaas wrote:
> On Fri, Nov 21, 2014 at 11:24:02AM -0700, Alex Williamson wrote:
> > This is really 2 sets of 2 patches, but they both add bits to
> > dev_flags so are included together.
> > 
> > This fixes two problems we've seen with resets.  The first is for
> > devices that advertise a PM reset mechanism, but it doesn't appear to
> > do anything.  We add a quirk and flags bit to indicate the PM reset
> > mechanism isn't viable.  This happens on some AMD GPUs and causes
> > vfio-pci to assume the PM reset was successful when it really did
> > nothing and we should have escalated to a PCI bus reset.  Alex
> > Deucher confirms that PM reset isn't used by graphics drivers.  The
> > exclusion here is for users of pci_reset_function(), which mostly
> > only includes pci-sysfs and drivers like legacy KVM device assignment
> > and VFIO.
> > 
> > The second issue is a problem identified with an Atheros wifi chip
> > where in performing a bus reset of the device, we not only permanently
> > lose access to the device, but it introduces host stability issues if
> > we try to access it.  I've been unsuccessful in finding any way to
> > make the device behave or in finding anyone with access to hardware
> > documentation and errata for this device, so it seems like the most
> > appropriate path is to blacklist bus resets for topologies including
> > this device.  The second two patches add infrastructure and quirks to
> > do this.  Thanks,
> > 
> > Alex
> > 
> > ---
> > 
> > Alex Williamson (4):
> >       PCI: quirk Atheros AR93xx to avoid bus reset
> >       PCI: Allow device quirks to exclude bus reset
> 
> I applied these two (above) to for-linus for v3.19, thanks.
> 
> >       PCI: quirk AMD/ATI VGA cards to avoid PM reset
> >       PCI: Allow device quirks to exclude D3->D0 PM reset

And I applied these PM reset patches to pci/virtualization for v3.20 (with
Alex's ack on the latter), thanks!

> > 
> >  drivers/pci/pci.c    |   42 +++++++++++++++++++++++++++++++++++++-----
> >  drivers/pci/quirks.c |   35 +++++++++++++++++++++++++++++++++++
> >  include/linux/pci.h  |    4 ++++
> >  3 files changed, 76 insertions(+), 5 deletions(-)
