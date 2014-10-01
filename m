Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaJAImc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:42:32 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:50719 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaJAIm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:42:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Wed, 01 Oct 2014 10:41:53 +0200
Message-ID: <1845601.0ISfgfFO3Y@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <abb0c775ec2549e3abb0a2218b4eef98@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com> <10249326.XCThPmSrfL@wuerfel> <abb0c775ec2549e3abb0a2218b4eef98@BN1PR0301MB0772.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:xMd3626+Sv9NxWzeU7sm3+sOEQICGtx+QVCyezeSBjw
 BDG/ZA8n9nqKQ2tOFR2s0hOc372jp1F9ktZU3V6rW7b1nrv2i8
 XxYdodEdYHCdbA6Cjz2eVRj/eMBmMbudGbPhE2FCQh8ksOF8Ms
 zIWpkURvO9yAScpXMkfEepf9B0lOXUY/ntBRhbzyc9oczk/5Yv
 MaBqCk1EYLo7tIft12KeFHh2C7YUlKa84CPJjAwER1asBK0pwb
 a/+1P7+QH8V+0gmX/a0YzG8hruAw409xsHRlfuYTbXgvRySelh
 iZeSBB0uIpnjBcTUoiSxOmkInv21Le+DMl5Dax4s8bYJk/zQIN
 dRZMsHYt6glNNWfjqPuE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 06:35:58 Peter Chen wrote:
> > Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
> > 
> > On Tuesday 30 September 2014 20:39:34 Peter Chen wrote:
> > > Thanks, Arnd. I had not thought setting dma mask is so complicated,
> > > yes, it should check the return value, two things to confirm:
> > >
> > > - dma_coerce_mask_and_coherent or dma_set_mask_and_coherent, the
> > only
> > > difference of these two API is the first one do "dev->dma_mask = &dev-
> > >coherent_dma_mask;"
> > > The reason you suggest choosing dma_set_mask_and_coherent is you do
> > > not want assign dev->dma_mask?
> > 
> > No, that is just the current definition on ARM32 with
> > CONFIG_ARCH_MULTIPLATFORM, and that is going to change soon to be DT
> > aware.
> > dma_set_mask_and_coherent() is supposed to check whether the platform
> > can support the respective mask and return an error if it cannot.
> > 
> > > - The second parameter for dma_set_mask_and_coherent is
> > > DMA_BIT_MASK(32), is it ok?
> > >
> > > I just a little confused of what's the operation is "hardcoding the dma mask"?
> > 
> > dma_coerce_mask_and_coherent() will hardcode the dma mask and override
> > whatever the platform says is necessary.
> > 
> 
> So, we should use dma_set_mask_and_coherent() in most of cases in device driver,
> and use dma_coerce_mask_and_coherent() only  when the device's dma_mask is wrong?
> 
> 

dma_coerce_mask_and_coherent() should really not be used at all. Russell
introduced it to convert drivers that were incorrectly setting the dma_mask
pointer themselves to something slightly more palatable.

The initial dma_mask is supposed to be set by the platform for each DMA
capable device, according to the address width of its upstream bus.
For DT based probing, we now set it to 32-bit mask but should really set
it to something smaller if the bus is more limited than that.

For devices created by platform code (board files), the platform should
call platform_device_register_full() and specify the dma mask in the
platform_device_info. Older platforms sometimes define a static platform
device structure that has the dma mask set. This works as well but is
discouraged for other reasons.

Drivers that require a dma mask that is either smaller than 32-bit (because
of device specific quirks) or that know that the device is capable of
larger DMA space and want to use that need to call dma_set_mask or
dma_set_mask_and_coherent and check the return value.

Ideally all device drivers that want to do DMA should call set_dma_mask
or set_dma_mask_and_coherent, even if the device has exactly a 32-bit
connection to the upstream bus.	

One more complication: if the device is not a DMA master itself but
uses a dma engine, you should not use set_dma_mask_and_coherent()
but instead use dma_get_mask() on the dmaengine device to query its
mask, and also use that same pointer to pass into dma_alloc_coherent
and dma_map_*.

	Arnd
