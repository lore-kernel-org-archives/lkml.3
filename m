Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaIYHLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:11:47 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:59612 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaIYHLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:11:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter Chen <peter.chen@freescale.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com,
        alexandre.belloni@free-electrons.com, p.zabel@pengutronix.de,
        jszhang@marvell.com, sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Thu, 25 Sep 2014 09:11:35 +0200
Message-ID: <3696520.MDUrkdjfGZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140925011647.GB3716@peterchendt>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com> <1411468088-5702-8-git-send-email-antoine.tenart@free-electrons.com> <20140925011647.GB3716@peterchendt>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/Ccb5GYl6UvZIpT4H7BhZPuvVbkUpfK97KwucD59Jkd
 oGSOpGs4ahx/fz8E5AshK7e0tjOT7GstmX9OAw3lRB6ak6I84L
 6kW0eyq6DNVP50zgsMyFRm41pLSOx2KLfMiSCWTHxyVbzltXsr
 zXPzJfkMUtm4+7CCvQDj+2M48GzlvzzSE3cC4IScEUveug1/m+
 PGSvz4P0V9e1uE91nxyhqfBlwzJ5dwZGMOW1W+vnQqpgKqagt9
 DTiJFdIZ8Qsn2RZvVey9hGxCUwpVU/IyqPPR+tQBfjQP+GynCx
 dsZIzc1Z4KNhXI0k/fhGMSbCFNuXG4NGi9hSW4EEHs7U5reNJM
 fvDmpoNEPTg3arK9/3HM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2014 09:16:48 Peter Chen wrote:
> > +     }
> > +
> > +     if (dev->of_node) {
> > +             ret = ci_hdrc_usb2_dt_probe(dev, ci_pdata);
> > +             if (ret)
> > +                     goto clk_err;
> > +     } else {
> > +             ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> > +             if (ret)
> > +                     goto clk_err;
> > +     }
> 
> Hi Antoine, the above code may not be needed, since get phy and set dma
> mask are common operation, we can do it at core code, the only thing you
> need to do is something like: dev->dma_mask = DMA_BIT_MASK(32).
> 

Certainly not, doing that would be broken for a number of reasons:

- dev->dma_mask is a pointer, a driver should not reassign that
- the device may have been set up for a bus that requires a smaller mask
  that is already set, changing the mask would cause data corruption
- setting just the dma mask but not coherent mask is wrong
- setting the dma mask can fail, e.g. if the mask is smaller than the
  smallest memory zone, so you have to check the return value.

	Arnd
