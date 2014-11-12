Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaKLIfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:35:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbaKLIfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:35:41 -0500
Message-ID: <1415781342.1761.10.camel@linux-0dmf.site>
Subject: Re: [V2 PATCH 02/10] added media agnostic (MA) USB HCD roothubs
From: Oliver Neukum <oneukum@suse.de>
To: Stephanie Wallick <stephanie.s.wallick@intel.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Date: Wed, 12 Nov 2014 09:35:42 +0100
In-Reply-To: <1415671781-11351-2-git-send-email-stephanie.s.wallick@intel.com>
References: <MA USB drivers>
	 <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
	 <1415671781-11351-2-git-send-email-stephanie.s.wallick@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 18:09 -0800, Stephanie Wallick wrote:
> This is where we implement USB 2.0 and 3.0 roothubs. From the host's
> perspective, hub state is set and tracked just like any other USB roothub.
> Likewise, requests to the roothub appear to be handled like any other wired
> USB request.
> 
> Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
> Signed-off-by: Stephanie Wallick <stephanie.s.wallick@intel.com>
> ---
>  drivers/staging/mausb/drivers/mausb_hub.c | 849 ++++++++++++++++++++++++++++++
>  drivers/staging/mausb/drivers/mausb_hub.h | 128 +++++
>  2 files changed, 977 insertions(+)
>  create mode 100644 drivers/staging/mausb/drivers/mausb_hub.c
>  create mode 100644 drivers/staging/mausb/drivers/mausb_hub.h
> 
> diff --git a/drivers/staging/mausb/drivers/mausb_hub.c b/drivers/staging/mausb/drivers/mausb_hub.c
> new file mode 100644
> index 0000000..63c0fe4
> --- /dev/null
> +++ b/drivers/staging/mausb/drivers/mausb_hub.c

> +/**
> + * Returns true if the given is the superspeed HCD. Note: The primary HCD is
> + * High Speed and the shared HCD is SuperSpeed.
> + */

Why in that order?

> +bool mausb_is_ss_hcd(struct usb_hcd *hcd)
> +{
> +	if (usb_hcd_is_primary_hcd(hcd))
> +		return false;
> +	else
> +		return true;
> +}



> +
> +/**
> + * Called by usb core when polling for a port status change.
> + *
> + * @hcd:	USB HCD being polled.
> + * @buf:	Holds port status changes (if any).
> + *
> + * Returns zero if there is no status change, otherwise returns number of
> + * bytes in buf. When there is a status change on a port, the bit indexed
> + * at the port number + 1 (e.g. bit 2 for port 1) is set in the buffer.
> + */
> +int mausb_hub_status_data(struct usb_hcd *hcd, char *buf)
> +{
> +	int                      i;
> +	u16                      port_change = 0;
> +	u32                      status = 0;
> +	int                      ret = 1;
> +	struct mausb_hcd	 *mhcd = usb_hcd_to_mausb_hcd(hcd);
> +	struct mausb_root_hub	 *roothub = usb_hcd_to_roothub(hcd);
> +
> +	/*
> +	 * Buf should never be more that 2 bytes. USB 3.0 hubs cannot have
> +	 * more than 15 downstream ports.
> +	 */
> +	buf[0] = 0;
> +	if (MAUSB_ROOTHUB_NUM_PORTS > 7) {
> +		buf[1] = 0;
> +		ret++;
> +	}

Endianness bug.

> +
> +	for (i = 0; i < MAUSB_ROOTHUB_NUM_PORTS; i++) {
> +		port_change = roothub->port_status[i].wPortChange;
> +		if (port_change)
> +			status |= (1 << (i + 1));
> +	}
> +
> +	mausb_dbg(mhcd, "%s: hub status is 0x%x\n", __func__, status);
> +
> +	/* hcd might be suspended, resume if there is a status change */
> +	if (mhcd->disabled == 0) {
> +		if ((hcd->state == HC_STATE_SUSPENDED) && status)
> +			usb_hcd_resume_root_hub(hcd);
> +	}
> +
> +	memcpy(buf, (char *)&status, ret);
> +
> +	return status ? ret : 0;
> +}
> +
> +/**
> + * Sets the bitfields in the hub descriptor of the 2.0 root hub. Always
> + * returns zero.
> + */
> +int mausb_set_hub_descriptor(struct usb_hub_descriptor *hub_des)
> +{
> +	/* set the values to the default */
> +	hub_des->bDescLength          = sizeof(struct usb_hub_descriptor);
> +	hub_des->bDescriptorType      = USB_DT_HUB;
> +	hub_des->bNbrPorts            = MAUSB_ROOTHUB_NUM_PORTS;
> +	hub_des->wHubCharacteristics  = MAUSB_ROOTHUB_CHAR;
> +	hub_des->bPwrOn2PwrGood       = MAUSB_ROOTHUB_PWR_ON_2_PWR_GOOD;
> +	hub_des->bHubContrCurrent     = MAUSB_ROOTHUB_CONTR_CURRENT;

Is that descriptor in bus or host endianness?

> +
> +	return 0;
> +}
> +
> +/**
> + * Sets the bitfields in the hub descriptor of the 3.0 root hub. Always
> + * returns zero.

Then why return anything?

> + */
> +int mausb_set_ss_hub_descriptor(struct usb_hub_descriptor *hub_des)
> +{
> +	/* set the values to the default */
> +	hub_des->bDescLength          = sizeof(struct usb_hub_descriptor);
> +	hub_des->bDescriptorType      = USB_DT_SS_HUB;
> +	hub_des->bNbrPorts            = MAUSB_ROOTHUB_NUM_PORTS;
> +	hub_des->wHubCharacteristics  = MAUSB_ROOTHUB_CHAR;
> +	hub_des->bPwrOn2PwrGood       = MAUSB_ROOTHUB_PWR_ON_2_PWR_GOOD;
> +	hub_des->bHubContrCurrent     = MAUSB_ROOTHUB_CONTR_CURRENT;
> +
> +	/* USB3-specific parameters */
> +	hub_des->u.ss.bHubHdrDecLat   = MAUSB_ROOTHUB_HDR_DEC_LAT;
> +	hub_des->u.ss.wHubDelay       = MAUSB_ROOTHUB_DELAY;
> +	hub_des->u.ss.DeviceRemovable = MAUSB_ALL_DEV_REMOVABLE;
> +
> +	return 0;
> +}


> +/**
> + * Contains all the structures required to emulate a root hub. One instance
> + * exists per root hub.
> + */
> +struct __attribute__((__packed__)) mausb_root_hub {

Why __packed__ ?
> +
> +	/* hub parameters */
> +	struct usb_hub_descriptor descriptor;
> +	struct usb_hub_status     status;
> +
> +	/* port parameters*/
> +	struct usb_port_status    port_status[MAUSB_ROOTHUB_NUM_PORTS];
> +
> +	/* root hub state */
> +	enum   mausb_rh_state     rh_state;
> +
> +};

	HTH
		Oliver

-- 
Oliver Neukum <oneukum@suse.de>

