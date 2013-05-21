Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab3EUHiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:38:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:57573 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab3EUHiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:38:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,713,1363158000"; 
   d="scan'208";a="244495210"
Message-ID: <1369122001.4432.14.camel@ymzhang.sh.intel.com>
Subject: Re: Subject : [ PATCH ]
 pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Zhang, LongX" <longx.zhang@intel.com>,
        "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Joseph.Liu@Emulex.Com" <Joseph.Liu@Emulex.Com>
Date: Tue, 21 May 2013 15:40:01 +0800
In-Reply-To: <20130520224824.GA31740@google.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
	 <20130520224824.GA31740@google.com>
Organization: Intel.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-20 at 16:48 -0600, Bjorn Helgaas wrote:
> On Fri, Apr 26, 2013 at 06:28:59AM +0000, Zhang, LongX wrote:
> > From: Zhang Long <longx.zhang@intel.com>
> > 
> > Specific pci device drivers might have many functions to call
> > pci_channel_offline to check device states. When slot_reset happens,
> > drivers' slot_reset callback might call such functions and eventually
> > abort the reset.
> > 
> > The patch resets pdev->error_state to pci_channel_io_normal at
> > the begining of report_slot_reset.
> > 
> > Thank Liu Joseph for pointing it out.
> > 
> > Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> > Signed-off-by: Zhang Long <longx.zhang@intel.com>
> > ---
> >  drivers/pci/pcie/aer/aerdrv_core.c |    1 +
> >  drivers/pci/pcie/portdrv_pci.c     |   12 +++++-------
> >  2 files changed, 6 insertions(+), 7 deletions(-)
Thank all for the kind comments.

> > 
> > diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> > index 564d97f..c61fd44 100644
> > --- a/drivers/pci/pcie/aer/aerdrv_core.c
> > +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> > @@ -286,6 +286,7 @@ static int report_slot_reset(struct pci_dev *dev, void *data)
> >  	result_data = (struct aer_broadcast_data *) data;
> >  
> >  	device_lock(&dev->dev);
> > +	dev->error_state = pci_channel_io_normal;
> >  	if (!dev->driver ||
> >  		!dev->driver->err_handler ||
> >  		!dev->driver->err_handler->slot_reset)
> > diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> > index ed4d094..7abefd9 100644
> > --- a/drivers/pci/pcie/portdrv_pci.c
> > +++ b/drivers/pci/pcie/portdrv_pci.c
> > @@ -332,13 +332,11 @@ static pci_ers_result_t pcie_portdrv_slot_reset(struct pci_dev *dev)
> >  	pci_ers_result_t status = PCI_ERS_RESULT_RECOVERED;
> >  	int retval;
> >  
> > -	/* If fatal, restore cfg space for possible link reset at upstream */
> > -	if (dev->error_state == pci_channel_io_frozen) {
> > -		dev->state_saved = true;
> > -		pci_restore_state(dev);
> > -		pcie_portdrv_restore_config(dev);
> > -		pci_enable_pcie_error_reporting(dev);
> > -	}
> > +	/* restore cfg space for possible link reset at upstream */
> > +	dev->state_saved = true;
It's indeed a dirty trick to change it to true. The reason is suspend. The port would
suspend/resume at suspend-to-ram. When the port is suspended, PCI power framework calls
pci_save_state. When the port is resumed, PCI framework calls pci_restore_state and
dev->state_saved is set to false.
A better solution is to add double space in pci_dev->saved_config_space/saved_cap_space,
which seems consume unnecessary resource.

> > +	pci_restore_state(dev);
> > +	pcie_portdrv_restore_config(dev);
> > +	pci_enable_pcie_error_reporting(dev);
> >  
> >  	/* get true return value from &status */
> >  	retval = device_for_each_child(&dev->dev, &status, slot_reset_iter);
> I think this patch changes the behavior in the case of a non-fatal error
> where one of the .error_detected() methods returned
> PCI_ERS_RESULT_NEED_RESET.  In that case, pcie_portdrv_slot_reset()
> previously did not restore config space, but after your patch, it *will*
> restore it.  We need an explanation of why this is safe.
AER standard doesn't define such behavior like if we need reset a slot.
When we implemented the feature in kernel, we assumed at non-fatal error,
config space is still good.

With the new patch, we change the behavior a little.

> 
> I think you should split this into two patches: the first would remove the
> "if (dev->error_state == pci_channel_io_frozen)" test from portdrv_pci.c
The first patch would depend on the 2nd patch as 2nd patch resets error_state 
to pci_channel_io_normal.

> and explain the reason, and the second would make the aerdrv_core.c change.
> 
> I'm also concerned that in that same case (a non-fatal error where one of
> the .error_detected() methods returned PCI_ERS_RESULT_NEED_RESET), I don't
> think we actually *do* any kind of device reset.  This isn't related to
> your patch, of course, so if you resolve the config space restore question,
> we can deal with the reset question later.
It's a good question. At the beginning when we enabled AER feature in kernel,
we didn't really implement the real device reset. It's in the TODO list.

Yanmin


