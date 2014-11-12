Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaKLT2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:28:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:3367 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbaKLT2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:28:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,370,1413270000"; 
   d="scan'208";a="606803084"
Date: Wed, 12 Nov 2014 11:28:19 -0800
From: "Sean O. Stalley" <sean.stalley@intel.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Stephanie Wallick <stephanie.s.wallick@intel.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [V2 PATCH 02/10] added media agnostic (MA) USB HCD roothubs
Message-ID: <20141112192819.GB2651@sean.stalley.intel.com>
References: <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415671781-11351-2-git-send-email-stephanie.s.wallick@intel.com>
 <1415781342.1761.10.camel@linux-0dmf.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415781342.1761.10.camel@linux-0dmf.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your review. My responses are inline.

Greg has requested that we clean up the driver internally before
we resubmit another patchset to the mailing list. I will make
sure the changes you requested make it in, but it may be a while
before you see a patchset with the fixes included.

Thanks,
Sean O. Stalley

On Wed, Nov 12, 2014 at 09:35:42AM +0100, Oliver Neukum wrote:
> On Mon, 2014-11-10 at 18:09 -0800, Stephanie Wallick wrote:
> > diff --git a/drivers/staging/mausb/drivers/mausb_hub.c b/drivers/staging/mausb/drivers/mausb_hub.c
> > new file mode 100644
> > index 0000000..63c0fe4
> > --- /dev/null
> > +++ b/drivers/staging/mausb/drivers/mausb_hub.c
> 
> > +/**
> > + * Returns true if the given is the superspeed HCD. Note: The primary HCD is
> > + * High Speed and the shared HCD is SuperSpeed.
> > + */
> 
> Why in that order?
> 

We should probably switch this & make the superspeed hub primary.
That way we match the xhci driver.

> > +bool mausb_is_ss_hcd(struct usb_hcd *hcd)
> > +{
> > +	if (usb_hcd_is_primary_hcd(hcd))
> > +		return false;
> > +	else
> > +		return true;
> > +}
> 
> 
> 
> > +
> > +/**
> > + * Called by usb core when polling for a port status change.
> > + *
> > + * @hcd:	USB HCD being polled.
> > + * @buf:	Holds port status changes (if any).
> > + *
> > + * Returns zero if there is no status change, otherwise returns number of
> > + * bytes in buf. When there is a status change on a port, the bit indexed
> > + * at the port number + 1 (e.g. bit 2 for port 1) is set in the buffer.
> > + */
> > +int mausb_hub_status_data(struct usb_hcd *hcd, char *buf)
> > +{
> > +	int                      i;
> > +	u16                      port_change = 0;
> > +	u32                      status = 0;
> > +	int                      ret = 1;
> > +	struct mausb_hcd	 *mhcd = usb_hcd_to_mausb_hcd(hcd);
> > +	struct mausb_root_hub	 *roothub = usb_hcd_to_roothub(hcd);
> > +
> > +	/*
> > +	 * Buf should never be more that 2 bytes. USB 3.0 hubs cannot have
> > +	 * more than 15 downstream ports.
> > +	 */
> > +	buf[0] = 0;
> > +	if (MAUSB_ROOTHUB_NUM_PORTS > 7) {
> > +		buf[1] = 0;
> > +		ret++;
> > +	}
> 
> Endianness bug.
> 

Could you elaborate?
It was my understanding that this buffer was host-endian.
Is this an unacceptable way to clear the buffer?

> > +
> > +	for (i = 0; i < MAUSB_ROOTHUB_NUM_PORTS; i++) {
> > +		port_change = roothub->port_status[i].wPortChange;
> > +		if (port_change)
> > +			status |= (1 << (i + 1));
> > +	}
> > +
> > +	mausb_dbg(mhcd, "%s: hub status is 0x%x\n", __func__, status);
> > +
> > +	/* hcd might be suspended, resume if there is a status change */
> > +	if (mhcd->disabled == 0) {
> > +		if ((hcd->state == HC_STATE_SUSPENDED) && status)
> > +			usb_hcd_resume_root_hub(hcd);
> > +	}
> > +
> > +	memcpy(buf, (char *)&status, ret);
> > +
> > +	return status ? ret : 0;
> > +}
> > +
> > +/**
> > + * Sets the bitfields in the hub descriptor of the 2.0 root hub. Always
> > + * returns zero.
> > + */
> > +int mausb_set_hub_descriptor(struct usb_hub_descriptor *hub_des)
> > +{
> > +	/* set the values to the default */
> > +	hub_des->bDescLength          = sizeof(struct usb_hub_descriptor);
> > +	hub_des->bDescriptorType      = USB_DT_HUB;
> > +	hub_des->bNbrPorts            = MAUSB_ROOTHUB_NUM_PORTS;
> > +	hub_des->wHubCharacteristics  = MAUSB_ROOTHUB_CHAR;
> > +	hub_des->bPwrOn2PwrGood       = MAUSB_ROOTHUB_PWR_ON_2_PWR_GOOD;
> > +	hub_des->bHubContrCurrent     = MAUSB_ROOTHUB_CONTR_CURRENT;
> 
> Is that descriptor in bus or host endianness?
> 

All of the fields are little-endian. We should be using cpu_to_le16()
when setting wHubCharacteristics.

> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * Sets the bitfields in the hub descriptor of the 3.0 root hub. Always
> > + * returns zero.
> 
> Then why return anything?
> 

Good point. I will change this (and mausb_set_hub_descriptor()) to be void.

> > + */
> > +int mausb_set_ss_hub_descriptor(struct usb_hub_descriptor *hub_des)
> > +{
> > +	/* set the values to the default */
> > +	hub_des->bDescLength          = sizeof(struct usb_hub_descriptor);
> > +	hub_des->bDescriptorType      = USB_DT_SS_HUB;
> > +	hub_des->bNbrPorts            = MAUSB_ROOTHUB_NUM_PORTS;
> > +	hub_des->wHubCharacteristics  = MAUSB_ROOTHUB_CHAR;
> > +	hub_des->bPwrOn2PwrGood       = MAUSB_ROOTHUB_PWR_ON_2_PWR_GOOD;
> > +	hub_des->bHubContrCurrent     = MAUSB_ROOTHUB_CONTR_CURRENT;
> > +
> > +	/* USB3-specific parameters */
> > +	hub_des->u.ss.bHubHdrDecLat   = MAUSB_ROOTHUB_HDR_DEC_LAT;
> > +	hub_des->u.ss.wHubDelay       = MAUSB_ROOTHUB_DELAY;
> > +	hub_des->u.ss.DeviceRemovable = MAUSB_ALL_DEV_REMOVABLE;
> > +
> > +	return 0;
> > +}
> 
> 
> > +/**
> > + * Contains all the structures required to emulate a root hub. One instance
> > + * exists per root hub.
> > + */
> > +struct __attribute__((__packed__)) mausb_root_hub {
> 
> Why __packed__ ?

Doesn't need to be. I will remove.

> > +
> > +	/* hub parameters */
> > +	struct usb_hub_descriptor descriptor;
> > +	struct usb_hub_status     status;
> > +
> > +	/* port parameters*/
> > +	struct usb_port_status    port_status[MAUSB_ROOTHUB_NUM_PORTS];
> > +
> > +	/* root hub state */
> > +	enum   mausb_rh_state     rh_state;
> > +
> > +};
> 
> 	HTH
> 		Oliver
> 
> -- 
> Oliver Neukum <oneukum@suse.de>
> 
