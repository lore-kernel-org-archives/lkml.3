Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbaIWQpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:45:16 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:54035 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaIWQpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:45:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, sebastian.hesselbarth@gmail.com,
        Peter.Chen@freescale.com, balbi@ti.com, p.zabel@pengutronix.de,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Tue, 23 Sep 2014 18:44:40 +0200
Message-ID: <5140494.LzvyOiyY3U@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140923133645.GA18924@kwain>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com> <2909480.SL9c0XWUbW@wuerfel> <20140923133645.GA18924@kwain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:y/sdfMYigUK36Mh74gJmA+m/NnQcmwLNqqzZ/OPY5Tz
 Wv9rfAS5qQZLhmdXOn3tLRpJ8yI5ut34qRjLK3sg8yDdvV9pyq
 APGUAbun/XL+FSrZ/6SPJ7cYN5f4v2Lr7Yfq+FYgSkYUeL2RKH
 Gks4G7dbDKJB5sGjNIaNoaAtYYQ5SWntbGS2RaXvYAOgmfRXSa
 tGt2iAOJy3LeWNYOMPbLLAQ1Tvm19umS7J+HmoJ8bRWO1MyRy8
 jGFQ1GaKE3NbA0E/B6C9SMopOu9bV73N4x5pas9+Q2XT67rJ1/
 C3O+TB80LaLh14wou/FFPJMJseDxD9IFpk2lmJdi6v0unrSQY6
 JkUak2spAP4BqRGQb0wc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 15:36:45 Antoine Tenart wrote:
> On Tue, Sep 23, 2014 at 12:39:04PM +0200, Arnd Bergmann wrote:
> > On Tuesday 23 September 2014 12:28:03 Antoine Tenart wrote:
> > > +       if (dev->of_node) {
> > > +               ret = ci_hdrc_usb2_dt_probe(dev, ci_pdata);
> > > +               if (ret)
> > > +                       goto clk_err;
> > > +       } else {
> > > +               ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> > > +               if (ret)
> > > +                       goto clk_err;
> > > +       }
> > > 
> > 
> > Why do you care about the non-DT case here? I think it would be nicer to
> > open-code the ci_hdrc_usb2_dt_probe() function in here and remove
> > the dma_set_mask_and_coherent(), which should not even be necessary for
> > the case where you have a hardwired platform device.
> > 
> 
> I thought we agreed to call dma_set_mask_and_coherent():
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/273335.html
> 
> I do not have a strong opinion on this as I only use the dt case for my
> usage.

The question is more about who actually wants the non-DT case.

Since this is a new driver, I suspect that the answer is "nobody",
as the existing board files are all for legacy platforms that we
are not going to adapt for this driver.

I see in the thread that at least Peter Chen was assuming the non-DT
case was still needed, but I can't find a reason for this in the code.
If we no longer care about that, the call to dev_get_platdata()
can also get removed.

Looking through the code some more, I also notice that it's using
a strange way of doing the abstraction: ci_hdrc_add_device()
actually creates a child device node, while the preferred way would
be to just call into ci_hdrc_probe(), or a generalized version of
that.
That should probably be changed, but can be done as a later cleanup.


	Arnd
