Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbbA0TGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:06:21 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:52245 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbbA0TGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:06:19 -0500
MIME-Version: 1.0
In-Reply-To: <20150127000428.GK21293@sirena.org.uk>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
 <1422029330-10971-9-git-send-email-ricardo.ribalda@gmail.com> <20150127000428.GK21293@sirena.org.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 27 Jan 2015 20:05:57 +0100
Message-ID: <CAPybu_1RW0F-ak-B_4H-riTUwF2yCrpKdT2RWviTdCMR_kQmww@mail.gmail.com>
Subject: Re: [PATCH 08/18] spi/xilinx: Support cores with no interrupt
To: Mark Brown <broonie@kernel.org>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark

> Right, for short transfers polling tends to win every time over
> interrupts - if you look at other controller drivers you'll see a lot of
> them use this technique.  The best practice here is generally to use a
> copy break and do very short transfers in polling mode and go back to
> interrupts for larger ones.  This break is typically done at the point
> where we go over a FIFO in transfer size since normally if the device is
> designed to be run with DMA the FIFO will be quite small.

Seems very reasonable. Only problem I can see is if the spi clk is
veeery slow, then a irq approach, even for transfer size bellow
buffer_size will be better.


>
> Obviously this isn't quite the same case since not only is there no DMA
> support (yet?) but the FIFO could be any size but similar things apply
> especially if someone configured the device with a large FIFO.

The hardware does not support dma (at least without making use of
another core called cdma....)

We can always argue that the system engineer can select polling by not
specifying an irq on the device tree.


>> +     xspi_init_hw(xspi);
>
> This appears to move the interrupt request before the hardware reset.
> Are you sure the interrupt handler won't misbehave if it fires before we
> finished initializing?  One thing the hardware reset should do is get
> the device in a known good state.

The hardware will be reseted and in good state by the function
find_buffer_size, so this should be good. Also the initialization is
slightly different for polling and irq mode.

So far I have fixed what you have sent and implemented a new patch for
the "heuristic" irq mode. I will try to run in on hw tomorrow and send
a new patchset with the patches that have not been merged yet.

Maybe you want to consider also this patch from Michal Simek to your
topic/xilinx branch

https://patchwork.kernel.org/patch/5648351/

Thanks!



-- 
Ricardo Ribalda
