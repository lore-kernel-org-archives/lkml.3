Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab3APPIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:08:37 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60090 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754099Ab3APPIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:08:35 -0500
Date: Wed, 16 Jan 2013 10:08:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Venu Byravarasu <vbyravarasu@nvidia.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <linux-doc@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4/4] usb: Add APIs to access host registers from Tegra
 PHY
In-Reply-To: <1358343022-28919-5-git-send-email-vbyravarasu@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1301161004380.1704-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013, Venu Byravarasu wrote:

> As Tegra PHY driver needs to access one of the Host registers,
> added few APIs.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>

> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c

> @@ -605,6 +619,50 @@ static const struct dev_pm_ops tegra_ehci_pm_ops = {
>  
>  #endif
>  
> +void tegra_ehci_set_wakeon_events(struct usb_phy *x, bool enable)
> +{
> +	unsigned long val;
> +	struct usb_hcd *hcd = bus_to_hcd(x->otg->host);
> +	void __iomem *base = hcd->regs;
> +	u32 wake = USB_PORTSC1_WKOC | USB_PORTSC1_WKDS | USB_PORTSC1_WKCN;
> +
> +	val = readl(base + USB_PORTSC1);
> +	if (enable)
> +		val |= wake;
> +	else
> +		val &= ~wake;
> +	writel(val, base + USB_PORTSC1);
> +}

Here and below, this sort of code is highly questionable.  You
evidently don't realize that some of the bits in the PORTSC registers
are R/WC.  This means writing a 1 to these bits will clear them.  

Consequently it is almost always wrong to read a PORTSC register and
then write back the same (or a slightly modified) value.

Alan Stern


