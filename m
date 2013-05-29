Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab3E2QRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:17:14 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:43951 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760187Ab3E2QQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:16:52 -0400
Message-ID: <1369844192.12792.3.camel@ejdallLaptop>
Subject: Re: [PATCH 3/3] PCI/AER: Provide reset_link for firmware first root
 port
From: Betty Dall <betty.dall@hp.com>
To: "Pearson, Greg" <greg.pearson@hp.com>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>, "bhelgaas@google.com" <bhelgaas@google.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Wed, 29 May 2013 10:16:32 -0600
In-Reply-To: <51A621E2.2050202@hp.com>
References: <1369766929-4386-1-git-send-email-betty.dall@hp.com>
	 <1369766929-4386-4-git-send-email-betty.dall@hp.com>
	 <51A621E2.2050202@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 09:42 -0600, Pearson, Greg wrote:
> On 05/28/2013 12:48 PM, Betty Dall wrote:
> > The firmware first path does not install the aerdrv root port
> > service driver, so the firmware first root port does not have
> > a reset_link callback. When a firmware first root port does not have
> > a reset_link callback, use a new default reset_link similar to what
> > we already do for the default_downstream_reset_link(). The firmware
> > first default reset_link brings the root port out of SBR if firmware
> > left it in SBR.
> >
> > Signed-off-by: Betty Dall <betty.dall@hp.com>
> > ---
> >
> >   drivers/pci/pcie/aer/aerdrv_core.c |   37 ++++++++++++++++++++++++++++++++++++
> >   1 files changed, 37 insertions(+), 0 deletions(-)
> >
> >
> > diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> > index 8ec8b4f..6862fe3 100644
> > --- a/drivers/pci/pcie/aer/aerdrv_core.c
> > +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> > @@ -413,6 +413,40 @@ static pci_ers_result_t default_downstream_reset_link(struct pci_dev *dev)
> >   	return PCI_ERS_RESULT_RECOVERED;
> >   }
> >   
> > +/**
> > + * default_ff_root_port_reset_link - default reset function for firmware
> > + *		first Root Port
> > + * @dev: pointer to root port's pci_dev data structure
> > + *
> > + * Invoked when performing link reset at Root Port w/ no aer driver.
> > + * This happens through the firmware first path. Firmware may leave
> > + * the Root Port in SBR and it is the OS responsiblity to bring it out
> > + * of SBR.
> > + */
> > +static pci_ers_result_t default_ff_root_port_reset_link(struct pci_dev *dev)
> > +{
> > +	u16 p2p_ctrl;
> > +
> > +	/* Read Secondary Bus Reset */
> > +	pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &p2p_ctrl);
> > +	p2p_ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
> 
> Remove "p2p_ctrl |= PCI_BRIDGE_CTL_BUS_RESET;" otherwise the following 
> conditional is always taken.
> 
> --
> Greg

Agreed. That was a copy and paste mistake. I will fix and retest.

-Betty

> > +
> > +	/* De-assert Secondary Bus Reset, if it is set */
> > +	if (p2p_ctrl & PCI_BRIDGE_CTL_BUS_RESET) {
> > +		p2p_ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
> > +		pci_write_config_word(dev, PCI_BRIDGE_CONTROL, p2p_ctrl);
> > +
> > +		/*
> > +		 * System software must wait for at least 100ms from the end
> > +		 * of a reset of one or more device before it is permitted
> > +		 * to issue Configuration Requests to those devices.
> > +		 */
> > +		msleep(200);
> > +		dev_dbg(&dev->dev, "Root Port link has been reset\n");
> > +	}
> > +	return PCI_ERS_RESULT_RECOVERED;
> > +}
> > +
> >   static int find_aer_service_iter(struct device *device, void *data)
> >   {
> >   	struct pcie_port_service_driver *service_driver, **drv;
> > @@ -460,6 +494,9 @@ static pci_ers_result_t reset_link(struct pci_dev *dev)
> >   		status = driver->reset_link(udev);
> >   	} else if (pci_pcie_type(udev) == PCI_EXP_TYPE_DOWNSTREAM) {
> >   		status = default_downstream_reset_link(udev);
> > +	} else if (pci_pcie_type(udev) == PCI_EXP_TYPE_ROOT_PORT &&
> > +		pcie_aer_get_firmware_first(udev)) {
> > +		status = default_ff_root_port_reset_link(udev);
> >   	} else {
> >   		dev_printk(KERN_DEBUG, &dev->dev,
> >   			"no link-reset support at upstream device %s\n",
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >


