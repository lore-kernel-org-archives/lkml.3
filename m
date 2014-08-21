Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaHUIeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:34:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:56474 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbaHUIe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:34:28 -0400
Message-ID: <53F5AF0D.5060409@linutronix.de>
Date: Thu, 21 Aug 2014 10:34:21 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 15/15] tty: serial: 8250: omap: add dma support
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de> <1408124563-31541-16-git-send-email-bigeasy@linutronix.de> <20140815210211.GD9239@atomide.com>
In-Reply-To: <20140815210211.GD9239@atomide.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2014 11:02 PM, Tony Lindgren wrote:
> * Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140815 11:13]:
>> +#ifdef CONFIG_SERIAL_8250_DMA
>> +	if (pdev->dev.of_node) {
>> +		/*
>> +		 * Oh DMA support. If there are no DMA properties in the DT then
>> +		 * we will fall back to a generic DMA channel which does not
>> +		 * really work here. To ensure that we do not get a generic DMA
>> +		 * channel assigned, we have the the_no_dma_filter_fn() here.
>> +		 * To avoid "failed to request DMA" messages we check for DMA
>> +		 * properties in DT.
>> +		 */
>> +		ret = of_property_count_strings(pdev->dev.of_node, "dma-names");
>> +		if (ret == 2) {
>> +			up.dma = &priv->omap8250_dma;
>> +			priv->omap8250_dma.fn = the_no_dma_filter_fn;
>> +			priv->omap8250_dma.rx_size = RX_TRIGGER;
>> +			priv->omap8250_dma.rxconf.src_maxburst = RX_TRIGGER;
>> +			priv->omap8250_dma.txconf.dst_maxburst = TX_TRIGGER;
>> +
>> +			if (of_machine_is_compatible("ti,am33xx"))
>> +				up.bugs |= UART_BUG_DMATX;
>> +		}
>> +	}
>> +#endif
> 
> Hmm I wonder if there's a more generic solution to this?

To what exactly? The trigger level, the TX-bug or using DMA in the
first place?

> It would be also nice to be able to specify the use of DMA from
> the board specific .dts file.

Really? I don't see this requirement for MMC for instance. However you
still could provide an empty "dma-names" property in your board .dts
file if you do not want use DMA. Would this work?

> Also, with DMA enabled, looks like omap deeper idle states are
> blocked as the DMA stays reserved. After I commented out the
> DMA info for my console UART, PM started working.

Hmm. This would explain something. This would mean that I should cancel
the RX DMA transfer in the PM-suspend routine. Let me see how that
works.

> Regards,
> 
> Tony

Sebastian
