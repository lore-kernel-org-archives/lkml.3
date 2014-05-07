Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbaEGM0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:26:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58348 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751435AbaEGM0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:26:30 -0400
Date: Wed, 7 May 2014 14:26:16 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Felipe Balbi <balbi@ti.com>
Cc: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 05/20] usb: host: xhci-plat: Add clocks support
Message-ID: <20140507142616.39f32438@free-electrons.com>
In-Reply-To: <1399335255-589-6-git-send-email-gregory.clement@free-electrons.com>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
	<1399335255-589-6-git-send-email-gregory.clement@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe, Gregory,

On Tue,  6 May 2014 02:14:00 +0200, Gregory CLEMENT wrote:

> +struct xhci_plat_priv {
> +	struct clk *clk;
> +};
> +
>  static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
>  {
>  	/*
> @@ -38,7 +43,8 @@ static int xhci_plat_setup(struct usb_hcd *hcd)
>  static const struct hc_driver xhci_plat_xhci_driver = {
>  	.description =		"xhci-hcd",
>  	.product_desc =		"xHCI Host Controller",
> -	.hcd_priv_size =	sizeof(struct xhci_hcd *),
> +	.hcd_priv_size =	sizeof(struct xhci_hcd *) +
> +				sizeof(struct xhci_plat_priv),
>  
>  	/*
>  	 * generic hardware linkage
> @@ -85,6 +91,40 @@ static const struct hc_driver xhci_plat_xhci_driver = {
>  	.bus_resume =		xhci_bus_resume,
>  };
>  
> +static int xhci_plat_enable_clk(struct platform_device *pdev)
> +{
> +	struct usb_hcd *hcd = platform_get_drvdata(pdev);
> +	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
> +	struct xhci_plat_priv *priv = (struct xhci_plat_priv *) xhci->priv;

Unless I misread the USB code, I believe the way this patch proposes to
handle private data for the XHCI HCD is wrong and leads to memory
corruption.

By growing the size .hcd_priv_size, it increases the memory size
pointed by usb_hcd->hcd_priv. However, this pointer has nothing to do
with xhci->priv, which points to the end of the xhci_hcd structure.

I believe the confusion comes from the fact that OHCI and EHCI do
allocate the entire ohci_hcd and ehci_hcd structure as part of the
usb_hcd private data:

	.hcd_priv_size =	sizeof(struct ohci_hcd),

or

	.hcd_priv_size = 	sizeof(struct ehci_hcd),

In this case, enlarging hcd_priv_size, and having a ehci->priv or
ohci->priv pointing to the end of {ohci,ehci}_hcd structures works fine.

However, in the XHCI case, the usb_hcd private data is not used to hold
the entire xhci_hcd structure, but only a *pointer* to it:

	.hcd_priv_size =	sizeof(struct xhci_hcd *),

Therefore, adding more size to .hcd_priv_size isn't going to give extra
room at the end of the xhci_hcd structure. And therefore the whole
strategy of using xhci->priv pointing at the end of xhci_hcd is broken.

In v4, what I will do is simply to add a 'struct clk *' member to
xhci_hcd. A clock is, like a register area or an interrupt, a very
typical resource for any device, so it makes sense to have a pointer to
it from xhci_hcd. If someone complains that the clock would only be
used by xhci_plat, then I could point him to the fact that xhci_hcd
already contains members such as msix_count and msix_entries, that are
only used in xhci_pci :-)

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
