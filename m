Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaB1UcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:32:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:15263 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaB1UcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:32:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,564,1389772800"; 
   d="scan'208";a="491844949"
Date: Fri, 28 Feb 2014 12:32:00 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>, linux-usb@vger.kernel.org,
        david.a.cohen@linux.intel.com, jianqiang.tang@intel.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] xhci: Prevent runtime pm from autosuspending
 during initialization
Message-ID: <20140228203200.GE3405@xanatos>
References: <1393259343-825-1-git-send-email-mathias.nyman@linux.intel.com>
 <Pine.LNX.4.44L0.1402241243230.1427-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.1402241243230.1427-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 12:44:46PM -0500, Alan Stern wrote:
> On Mon, 24 Feb 2014, Mathias Nyman wrote:
> 
> > xHCI driver has its own pci probe function that will call usb_hcd_pci_probe
> > to register its usb-2 bus, and then continue to manually register the
> > usb-3 bus. usb_hcd_pci_probe does a pm_runtime_put_noidle at the end and
> > might thus trigger a runtime suspend before the usb-3 bus is ready.
> > 
> > Prevent the runtime suspend by increasing the usage count in the
> > beginning of xhci_pci_probe, and decrease it once the usb-3 bus is
> > ready.
> > 
> > xhci-platform driver is not using usb_hcd_pci_probe to set up
> > busses and should not need to have it's usage count increased during probe.
> > 
> > Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> > ---
> >  drivers/usb/host/xhci-pci.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> > index 04f986d..ea7158b 100644
> > --- a/drivers/usb/host/xhci-pci.c
> > +++ b/drivers/usb/host/xhci-pci.c
> > @@ -190,6 +190,10 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
> >  	struct usb_hcd *hcd;
> >  
> >  	driver = (struct hc_driver *)id->driver_data;
> > +
> > +	/* Prevent USB-2 roothub runtime suspend until USB-3 is initialized. */
> > +	pm_runtime_get_noresume(&dev->dev);
> 
> Strictly speaking, this prevents the _controller_ from going into
> runtime suspend -- not the root hub.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>

Mathias, want to fix this comment and queue this up to Greg?  It should
probably be marked for stable.

> Apart from nit about the comment,
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
