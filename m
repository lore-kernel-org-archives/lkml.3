Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaDYUCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:02:55 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:51311 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaDYUCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:02:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        devicetree@vger.kernel.org, Nadav Haklai <nadavh@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 03/18] usb: host: xhci-plat: Add support for the Armada 38x
Date: Fri, 25 Apr 2014 22:01:51 +0200
Message-ID: <5392399.GiPjM0CIZ0@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398434836-18908-4-git-send-email-gregory.clement@free-electrons.com>
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com> <1398434836-18908-4-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:S2AIUNL5o6/ewvJAZ3JrFOJGc5qjKRXnfdnYb13/+Ex
 zp8SJl6hTtPhSNQh9VEakDtzpKeiayN/Xi1E689/8rdQ+Cgnq7
 fRoFgwIJKMHZVqPfNvZfllReEKFqmMf76khaKuwzG7zrQl3WXJ
 jUV1umElw5jFPtVSGjuv2nh21wmO8DldZe28Wd7soMY/I3xJ7w
 ojpY9x6XpSs4XShYouL7DRAbw6nC0kVu6QDpgaPB/588bF7PsY
 AFcDLq9DceFU6nnjp8ckCiCRS3gOjHLhS3VBXen3v/1BRQje/9
 yp23DSjyyPHgN6rg7a1WfTtMppXKHkDh2WhBbRNNUjBzfCUvqh
 871UOfLe699u6eC3pNHs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 April 2014 16:07:01 Gregory CLEMENT wrote:
> @@ -148,6 +149,9 @@ static int xhci_plat_probe(struct platform_device *pdev)
>         if (ret)
>                 return ret;
>  
> +       if (of_device_is_compatible(pdev->dev.of_node, "marvell,armada-380-xhci"))
> +               xhci_mvebu_mbus_init_quirk(pdev);
> +
>         /* Initialize dma_mask and coherent_dma_mask to 32-bits */
>         ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
>         if (ret)

I think you're doing it the wrong way around: You have a specialized
version of the generic xhci-plat driver. The normal way to handle this
is to have a loadable module that contains all the Armada specific
code and that registers a platform_driver. In the probe() function of
that driver, you can do the platform specific setup and then call
the generic xhci_plat_probe() function, which of course has to
be provided using EXPORT_SYMBOL_GPL.

We have just spent a lot of effort converting the EHCI and OHCI drivers
to the more generic model, so we shouldn't do it the wrong way for
xhci. I just noticed that we already have this creeping into the 
xhci driver in the from of a common xhci_hcd_init() function calling
xhci_register_pci() and xhci_register_plat(). It would be good to
clean that up at the same time, it should only require exporting
a few symbols from xhci.c for use by the two front-ends.

	Arnd
