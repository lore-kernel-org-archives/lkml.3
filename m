Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847Ab3CSWpC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:45:02 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:35266 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933289Ab3CSWpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:45:00 -0400
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Mar 2013 18:45:00 EDT
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Christophe Aeschlimann <aeschlimann@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe Aeschlimann <c.aeschlimann@acn-group.ch>
Subject: Re: [PATCH] ixp4xx_eth: set the device dma_coherent_mask
References: <1363708765-20778-1-git-send-email-c.aeschlimann@acn-group.ch>
Date: Tue, 19 Mar 2013 23:35:46 +0100
In-Reply-To: <1363708765-20778-1-git-send-email-c.aeschlimann@acn-group.ch>
	(Christophe Aeschlimann's message of "Tue, 19 Mar 2013 16:59:25
	+0100")
Message-ID: <m3sj3rdnlp.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christophe Aeschlimann <aeschlimann@gmail.com> writes:

> Without the mask it is impossible to take the network interface up
> since it returns the following error:
>
>> net eth1: coherent DMA mask is unset
>> ifconfig: SIOCSIFFLAGS: Cannot allocate memory
>
> +++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
> @@ -1398,6 +1398,7 @@ static int eth_init_one(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	SET_NETDEV_DEV(dev, &pdev->dev);
> +	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
>  	port = netdev_priv(dev);
>  	port->netdev = dev;
>  	port->id = pdev->id;

This happens to work but seems to me like a bad "solution". The real
issue is that current ARM coherent_dma_mask (and regular dma_mask)
handling is just broken (at least on platforms with
CONFIG_ARCH_HAS_DMA_SET_COHERENT_MASK). I'm thinking how can it be
fixed.

The problematic parts include the dmabouncer (which takes over DMA
operations and provide services similar to swiotlb), the host DMA and
coherent DMA masks (which are property of the buses) and the device
masks, which should be ANDed with bus masks (but aren't).

What the driver should use is:
	err = dma_set_coherent_mask(xxx);

(but the subsystem have to be fixed first).
Also, according to DMA-API, 32-bit is the default.
-- 
Krzysztof Halasa
