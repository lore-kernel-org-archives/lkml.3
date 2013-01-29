Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab3A2QNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:13:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55149 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3A2QNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:13:08 -0500
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] dw_dmac: apply default dma_mask if needed
Date: Tue, 29 Jan 2013 16:12:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        "spear-devel" <spear-devel@list.st.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1359471984-26336-1-git-send-email-andriy.shevchenko@linux.intel.com> <CAKohpo=upCjze53v5STZJUz5OSrRqBU+mU3Q-C9BL18sXYAs5Q@mail.gmail.com>
In-Reply-To: <CAKohpo=upCjze53v5STZJUz5OSrRqBU+mU3Q-C9BL18sXYAs5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301291612.58501.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:9rEkzcm4/+HnSLFmPchkQi6Tj2e9kfW48L2//budmgY
 0V9S+wCDD09IppCIx7X1kbyg8ehFmCZXLQhWeg/2gpcfMloeIV
 j69ciYl2HrF5rf9kSz1tXjZbp0ln4rerXFqy1kVfOOrQUv3ESX
 uH9rYCQEm6GEQ+BXUM4o8sjhfYeMEjMzzFl24yaKEI/3J2xkMS
 k6ulFbkvJ2m/PhGf48kz4Fq4jLRf3E+cDYpJXnOVk+cxu62Y0y
 B3Vk8KMLojY/BJUTklGUSvpOAvgYkQQQOp+w4WjF9qORf8YPKE
 4yQLh6aMIvXSwZZPO+AU2aLBQI0bmqyyMcxZBhOtABYUTihUEz
 an0PNxYPIHBh1i8cHHwFtBY+g5w58qFxaGE+S+z88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2013, Viresh Kumar wrote:
> Adding Arnd in cc.
> 
> On 29 January 2013 20:36, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > In some cases we got the device without dma_mask configured. We have to apply
> > the default value to avoid crashes during memory mapping.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/dma/dw_dmac.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> > index e8d0679..a572a1e 100644
> > --- a/drivers/dma/dw_dmac.c
> > +++ b/drivers/dma/dw_dmac.c
> > @@ -1673,6 +1673,12 @@ static int dw_probe(struct platform_device *pdev)
> >         if (IS_ERR(regs))
> >                 return PTR_ERR(regs);
> >
> > +       /* Apply default dma_mask if needed */
> > +       if (!pdev->dev.dma_mask) {
> > +               pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> > +               pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> > +       }
> > +
> 
> Hmm... Why is it required for a DMA controller? What kind of crash do you
> get?

A valid dma mask is required for any device that is passed into dma_map_*
and other dma-mapping.h interfaces. The question is more about is
responsible for setting up the mask. Traditionally we'd do that from the
platform definition in the place where the platform_device is created,
but this now comes from the device tree, which is a bit inconsistent
with the DMA masks at the moment.

We do set the dev.coherent_dma_mask to DMA_BIT_MASK(32) for all platform
devices instatiated from DT, but I cannot find the code that sets the
dma_mask for a platform_device. For an amba_device, we set both to
the same value. Maybe Grant can remember if the difference here is
intentional, or if the dma_mask is set up elsewhere for a platform_device
coming from DT.

> @Arnd: Is this change recommended?

For all I can tell, it cannot hurt to do it this way.

	Arnd
