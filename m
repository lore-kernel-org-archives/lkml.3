Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaELUGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:06:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43493 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751567AbaELUGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:06:17 -0400
Date: Mon, 12 May 2014 16:06:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Maxime Ripard <maxime.ripard@free-electrons.com>
cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, <kishon@ti.com>,
        <hdegoede@redhat.com>, Boris Brezillon <boris@free-electrons.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <kevin.z.m.zh@gmail.com>,
        <sunny@allwinnertech.com>, <shuge@allwinnertech.com>,
        <zhuzhenhua@allwinnertech.com>, <linux-sunxi@googlegroups.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v3 5/8] usb: ehci-platform: add optional reset controller
 retrieval
In-Reply-To: <1399923274-6017-6-git-send-email-maxime.ripard@free-electrons.com>
Message-ID: <Pine.LNX.4.44L0.1405121604140.1202-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014, Maxime Ripard wrote:

> From: Boris BREZILLON <boris.brezillon@free-electrons.com>
> 
> On the Allwinner's A31 SoC the reset line connected to the EHCI IP has to
> be deasserted for the EHCI block to be usable.
> 
> Add support for an optional reset controller that will be deasserted on
> power off and asserted on power on.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>

...

> @@ -208,6 +210,18 @@ static int ehci_platform_probe(struct platform_device *dev)
>  		}
>  	}
>  
> +	priv->rst = devm_reset_control_get_optional(&dev->dev, NULL);
> +	if (IS_ERR(priv->rst)) {
> +		err = PTR_ERR(priv->rst);
> +		if (err == -EPROBE_DEFER)
> +			goto err_put_clks;
> +		priv->rst = NULL;
> +	} else {
> +		err = reset_control_deassert(priv->rst);
> +		if (err)
> +			goto err_put_clks;
> +	}
> +
>  	if (pdata->big_endian_desc)
>  		ehci->big_endian_desc = 1;
>  	if (pdata->big_endian_mmio)

You don't re-assert the reset control if an error happens later on 
during probe.  Was that intentional?

Alan Stern

