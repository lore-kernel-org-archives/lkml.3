Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaCZH0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 03:26:30 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:33238 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaCZH03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 03:26:29 -0400
X-Auth-Info: brfbF5Ts5mr1sb8UiRnJbWcZJ7us6HI/3Wvbys4QSg4=
From: Marek Vasut <marex@denx.de>
To: Yao Yuan <yao.yuan@freescale.com>
Subject: Re: [PATCH v3 1/2] i2c: add DMA support for freescale i2c driver
Date: Wed, 26 Mar 2014 08:26:27 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
References: <1394675277-24913-1-git-send-email-yao.yuan@freescale.com> <201403260726.36812.marex@denx.de> <8984936f9e914442995d79039543cb58@BL2PR03MB338.namprd03.prod.outlook.com>
In-Reply-To: <8984936f9e914442995d79039543cb58@BL2PR03MB338.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201403260826.28114.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 26, 2014 at 08:08:28 AM, Yao Yuan wrote:
> On Wednesday, March 26, 2014 at 02:27:46 PM, Marek Vasut wrote:
> > On Wednesday, March 26, 2014 at 06:56:34 AM, Yao Yuan wrote:
> > > On Wednesday, March 26, 2014 at 11:43:27 AM, Marek Vasut wrote:
> > > > On Wednesday, March 26, 2014 at 04:08:27 AM, Yao Yuan wrote:
> > > > 
> > > > [...]
> > > > 
> > > > > > > +		i2c_imx->use_dma = false;
> > > > > > > +	} else if (i2c_imx_dma_request(i2c_imx,
> > > > > > > +(dma_addr_t)phy_addr))
> > > > 
> > > > {
> > > > 
> > > > > > > +		dev_info(&pdev->dev,
> > > > > > > +				"can't request dma chan, faild use dma.
> > 
> > \n");
> > 
> > > > > > > +		i2c_imx->use_dma = false;
> > > > > > > +	} else {
> > > > > > > +		i2c_imx->use_dma = true;
> > > > > > > +	}
> > > > > > 
> > > > > > Can you not just check if i2c_imx->dma is valid pointer or NULL
> > > > 
> > > > pointer ?
> > > > 
> > > > > > Then you won't need a separate variable, for this purpose ...
> > 
> > right ?
> > 
> > > > > Sorry and I think what I know is just to check whether it is NULL.
> > > > > Then for the second question, maybe there are some other ways, But
> > > > > I think it is more tidy and easier understanding for using a
> > > > > separate variable, for this purpose.
> > > > 
> > > > You are just wasting space and duplicating data, unless I am wrong.
> > > 
> > > Well, Do you have a better idea? Although I think it's necessary.
> > 
> > I think we disconnected here, sorry. Why can you not use (i2c_imx->dma !=
> > NULL) instead of (i2c_imx->use_dma == true) please ?
> 
> But there are two judge conditions. But only the "i2c_imx->dma", but also
> whether "i2c_imx_dma_request" success.
> 
> "i2c_imx->use_dma == true" be equivalent to "i2c_imx->dma != NULL &&
> !i2c_imx_dma_request()"

+       /* Init DMA config if support*/
+       i2c_imx->dma = devm_kzalloc(&pdev->dev, sizeof(struct imx_i2c_dma),
+                                       GFP_KERNEL);
+       if (!i2c_imx->dma) {
+               dev_info(&pdev->dev,
+                               "can't allocate dma struct faild use dma.\n");
+               i2c_imx->use_dma = false;
+       } else if (i2c_imx_dma_request(i2c_imx, (dma_addr_t)phy_addr)) {
+               dev_info(&pdev->dev,
+                               "can't request dma chan, faild use dma.\n");
+               i2c_imx->use_dma = false;
+       } else {
+               i2c_imx->use_dma = true;
+       }

OK, looking at this one more time, why don't you wrap the allocation of i2c_imx-
>dma into i2c_imx_dma_request() ? Even better, you can allocate *dma as a local 
variable in i2c_imx_dma_request() and then assign it into i2c_imx->dma only at 
the end of the i2c_imx_dma_request() function , at the point where you are sure 
nothing failed. Then you can check i2c_imx->dma != NULL throughout the code to 
check if the DMA is available, no ?

Shawn, Wolfram, am I talking nonsense or am I just not connecting ?

Best regards,
Marek Vasut
