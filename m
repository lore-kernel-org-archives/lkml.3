Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088AbaEJOfv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 10:35:51 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57679 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755096AbaEJOfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 10:35:50 -0400
Date: Sat, 10 May 2014 10:35:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Maxime Ripard <maxime.ripard@free-electrons.com>
cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, <kishon@ti.com>,
        <hdegoede@redhat.com>, Boris Brezillon <boris@free-electrons.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <kevin.z.m.zh@gmail.com>,
        <sunny@allwinnertech.com>, <shuge@allwinnertech.com>,
        <zhuzhenhua@allwinnertech.com>, <linux-sunxi@googlegroups.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v2 4/7] usb: ehci-platform: add optional reset controller
 retrieval
In-Reply-To: <1399726619-30150-5-git-send-email-maxime.ripard@free-electrons.com>
Message-ID: <Pine.LNX.4.44L0.1405101023510.1268-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2014, Maxime Ripard wrote:

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

This basically is good. fine.  I have only two comments, and one of
them is a matter of taste rather than substance.

> @@ -206,6 +208,19 @@ static int ehci_platform_probe(struct platform_device *dev)
>  				break;
>  			}
>  		}
> +
> +		priv->rst = devm_reset_control_get_optional(&dev->dev,
> +							    NULL);

I hate the style that matches arguments on a continuation line with the
opening paren of the function call, for a couple of reasons.  Instead I
simply indent continuation lines by two or more tab stops.  But some
people seem to be incurably attached to it.

> +		if (IS_ERR(priv->rst)) {
> +			err = PTR_ERR(priv->rst);
> +			if (err == -EPROBE_DEFER)
> +				goto err_put_clks;
> +			priv->rst = NULL;
> +		} else {
> +			err = reset_control_deassert(priv->rst);
> +			if (err)
> +				goto err_put_clks;
> +		}
>  	}
>  
>  	if (pdata->big_endian_desc)

The new code was added inside an "if" statement, which will cause it to
apply only to OF devices.  Is there any reason not to put the new code
outside the "if" statement, so it applies to all devices?

Alan Stern

