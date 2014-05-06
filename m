Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbaEFObA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:31:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42573 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752982AbaEFOa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:30:58 -0400
Date: Tue, 6 May 2014 10:30:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
cc: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v3 01/20] usb: ehci-orion: Fix clock reference leaking
In-Reply-To: <1399335255-589-2-git-send-email-gregory.clement@free-electrons.com>
Message-ID: <Pine.LNX.4.44L0.1405061027490.1312-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014, Gregory CLEMENT wrote:

> In order to disable the clock while the module was removing, a call to
> devm_clk_get() was made. This was wrong and lead to a leak module
> ref-counts.
> 
> In order to have a reference of the clock get, a private structure was
> added using the override mechanism provided by the ehci framework.
> 
> The bug was introduced in v3.6, however the ehci framework allowing to
> use the override mechanism have only been introduced in v3.8, so this
> patch won't apply before it.
> 
> Fixes: 8c869edaee07c623066266827371235fb9c12e01 ('ARM: Orion: EHCI: Add support for enabling clocks')
> Cc: <stable@vger.kernel.org> # v3.8+
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>


>  	hcd = usb_create_hcd(&ehci_orion_hc_driver,
>  			&pdev->dev, dev_name(&pdev->dev));
>  	if (!hcd) {
>  		err = -ENOMEM;
> -		goto err2;
> +		goto err1;
>  	}
>  
>  	hcd->rsrc_start = res->start;
> @@ -211,6 +215,15 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
>  	ehci->caps = hcd->regs + 0x100;
>  	hcd->has_tt = 1;
>  
> +	priv = hcd_to_orion_priv(hcd);
> +	/*
> +	 * Not all platforms can gate the clock, so it is not an error if
> +	 * the clock does not exists.
> +	 */
> +	priv->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (!IS_ERR(priv->clk))
> +		clk_prepare_enable(priv->clk);
> +
>  	/*
>  	 * (Re-)program MBUS remapping windows if we are asked to.
>  	 */
> @@ -240,16 +253,16 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
>  
>  	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
>  	if (err)
> -		goto err3;
> +		goto err2;
>  
>  	device_wakeup_enable(hcd->self.controller);
>  	return 0;
>  
> -err3:
> -	usb_put_hcd(hcd);
>  err2:
> -	if (!IS_ERR(clk))
> -		clk_disable_unprepare(clk);
> +	usb_put_hcd(hcd);

At this point, priv has just become a dangling pointer, because it
points to something that was allocated along with hcd.

> +
> +	if (!IS_ERR(priv->clk))
> +		clk_disable_unprepare(priv->clk);

And now you are dereferencing memory that has been deallocated.  The
real problem is that you get and enable the clock _after_ creating hcd,
but you don't disable it _before_ deallocating hcd.

>  err1:
>  	dev_err(&pdev->dev, "init %s fail, %d\n",
>  		dev_name(&pdev->dev), err);
> @@ -260,14 +273,14 @@ err1:
>  static int ehci_orion_drv_remove(struct platform_device *pdev)
>  {
>  	struct usb_hcd *hcd = platform_get_drvdata(pdev);
> -	struct clk *clk;
> +	struct orion_ehci_hcd *priv = hcd_to_orion_priv(hcd);
>  
>  	usb_remove_hcd(hcd);
>  	usb_put_hcd(hcd);
>  
> -	clk = devm_clk_get(&pdev->dev, NULL);
> -	if (!IS_ERR(clk))
> -		clk_disable_unprepare(clk);
> +	if (!IS_ERR(priv->clk))
> +		clk_disable_unprepare(priv->clk);

This has the same problem as above.

Also, for both this patch and 02/20, it would be better to replace the
"errN" labels with something more descriptive, so that it's not
necessary to renumber them every time something changes.

Alan Stern

