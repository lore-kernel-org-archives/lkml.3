Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196Ab3ARFmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 00:42:21 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11644 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3ARFmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 00:42:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 17 Jan 2013 21:42:11 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 18 Jan 2013 11:12:14 +0530
Subject: RE: [PATCH v2 4/4] usb: Add APIs to access host registers from
 Tegra PHY
Thread-Topic: [PATCH v2 4/4] usb: Add APIs to access host registers from
 Tegra PHY
Thread-Index: Ac30xYCMUrR0Ubv0RlCpR7YeuP5bEgAbug4wAAKA2fA=
Message-ID: <D958900912E20642BCBC71664EFECE3E6E1A6F108F@BGMAIL02.nvidia.com>
References: <1358411292-12288-1-git-send-email-vbyravarasu@nvidia.com>
 <Pine.LNX.4.44L0.1301171012500.1339-100000@iolanthe.rowland.org> 
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Venu Byravarasu
> Sent: Friday, January 18, 2013 10:26 AM
> To: 'Alan Stern'
> Cc: gregkh@linuxfoundation.org; balbi@ti.com; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org; swarren@wwwdotorg.org; linux-
> tegra@vger.kernel.org
> Subject: RE: [PATCH v2 4/4] usb: Add APIs to access host registers from Tegra
> PHY
> 
> > -----Original Message-----
> > From: Alan Stern [mailto:stern@rowland.harvard.edu]
> > Sent: Thursday, January 17, 2013 8:45 PM
> > To: Venu Byravarasu
> > Cc: gregkh@linuxfoundation.org; balbi@ti.com; linux-usb@vger.kernel.org;
> > linux-kernel@vger.kernel.org; swarren@wwwdotorg.org; linux-
> > tegra@vger.kernel.org
> > Subject: Re: [PATCH v2 4/4] usb: Add APIs to access host registers from
> Tegra
> > PHY
> >
> > On Thu, 17 Jan 2013, Venu Byravarasu wrote:
> >
> > > As Tegra PHY driver need to access one of the Host registers,
> > > added few APIs to ehci tegra driver.
> > >
> > > Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> > > ---
> > > delta from v1:
> > > Taken care of RWC bits, while accessing PORTSC register.
> > >
> > >  drivers/usb/host/ehci-tegra.c     |   70
> > ++++++++++++++++++++++++++++++++++++-
> > >  drivers/usb/phy/tegra_usb_phy.c   |   51 +++++++--------------------
> > >  include/linux/usb/tegra_usb_phy.h |    6 +++
> > >  3 files changed, 88 insertions(+), 39 deletions(-)
> > >
> > > diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> > > index 55a9cde..6bbf66a 100644
> > > --- a/drivers/usb/host/ehci-tegra.c
> > > +++ b/drivers/usb/host/ehci-tegra.c
> > > @@ -2,7 +2,7 @@
> > >   * EHCI-compliant USB host controller driver for NVIDIA Tegra SoCs
> > >   *
> > >   * Copyright (C) 2010 Google, Inc.
> > > - * Copyright (C) 2009 NVIDIA Corporation
> > > + * Copyright (C) 2009 - 2013 NVIDIA Corporation
> > >   *
> > >   * This program is free software; you can redistribute it and/or modify it
> > >   * under the terms of the GNU General Public License as published by the
> > > @@ -33,6 +33,16 @@
> > >  #define TEGRA_USB2_BASE			0xC5004000
> > >  #define TEGRA_USB3_BASE			0xC5008000
> > >
> > > +/* PORTSC registers */
> > > +#define USB_PORTSC1			0x184
> > > +#define USB_PORTSC1_PTS(x)	(((x) & 0x3) << 30)
> > > +#define USB_PORTSC1_PHCD	(1 << 23)
> > > +#define USB_PORTSC1_WKOC	(1 << 22)
> > > +#define USB_PORTSC1_WKDS	(1 << 21)
> > > +#define USB_PORTSC1_WKCN	(1 << 20)
> > > +#define USB_PORTSC1_PEC		(1 << 3)
> > > +#define USB_PORTSC1_CSC		(1 << 1)
> >
> > Why redefine these values when they are already defined in
> > include/linux/usb/ehci_defs.h?
> 
> Agreed. Will remove all above defines except PHCD & PTS, as these two
> fields are added by tegra SOC to PORTSC.
> 
> >
> > > @@ -605,6 +615,53 @@ static const struct dev_pm_ops
> > tegra_ehci_pm_ops = {
> > >
> > >  #endif
> > >
> > > +/* Bits of PORTSC1, which will get cleared by writing 1 into them */
> > > +#define TEGRA_PORTSC_RWC_BITS (USB_PORTSC1_CSC |
> > USB_PORTSC1_PEC)
> >
> > Likewise for this.  Not to mention that you forgot to include the
> > overcurrent-change bit.
> 
> As OCC bit is "not supported" by Tegra20 SOC, did not include it.
> Should I still add this, to be compliant with EHCI spec?
> Based on your comments, I can update the patch and send for review.

Any ways, as we're just adding OCC for proper RWC treatment, I don't
see any harm in adding it to the list.
Hence will update the patch with two changes mentioned by Alan. 

> 
> >
> > Alan Stern

