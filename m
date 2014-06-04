Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaFDStE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:49:04 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:46854 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaFDStC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:49:02 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        "Yang,Wei" <Wei.Yang@windriver.com>
CC: Peter Chen <Peter.Chen@freescale.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        "Felipe Balbi" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] USB:gadget: Fix a warning while loading
 g_mass_storage
Thread-Topic: [PATCH v1] USB:gadget: Fix a warning while loading
 g_mass_storage
Thread-Index: AQHPfw+CHIykYfVqlUeQGtcdMkWQpptf7RCAgACwf4CAAAb3gIAAGVEAgACy/AD//9d94A==
Date: Wed, 4 Jun 2014 18:48:56 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844B24EF@US01WEMBX2.internal.synopsys.com>
References: <538E8F70.2010600@windriver.com>
 <Pine.LNX.4.44L0.1406040953400.15745-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1406040953400.15745-100000@netrider.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Alan Stern
> Sent: Wednesday, June 04, 2014 6:57 AM
> 
> On Wed, 4 Jun 2014, Yang,Wei wrote:
> 
> > On 06/04/2014 09:45 AM, Peter Chen wrote:
> > >
> > >> commit d18f7116a5ddb8263fe62b05ad63e5ceb5875791
> > >> Author: Robert Baldyga <r.baldyga@samsung.com>
> > >> Date:   Thu Nov 21 13:49:18 2013 +0100
> > >>
> > >>       usb: gadget: s3c-hsotg: fix disconnect handling
> > >>
> > >>       This patch moves s3c_hsotg_disconnect function call from USBSusp
> > >> interrupt
> > >>       handler to SET_ADDRESS request handler.
> > >>
> > > It is a little strange we call gadget's disconnect at SET_ADDRESS?
> > > How the udc calls gadget driver the disconnection has happened when
> > > the usb cable is disconnected from the host?
> > >
> > > Usually, we call gadget's disconnect at two situations
> > >
> > > - udc's reset handler if udc's speed is not UNKNOWN, it is usually happened
> > > when the host sends reset after enumeration.
> > > - udc's disconnect handler, it is usually happened when the usb cable
> > > is disconnected from host.
> >
> > Hmm, usually the two situations, but according to the commit log, s3c
> > hsotg does not support Disconnected interrupt for device mode,
> > so the second situation does not happen for s3c hsotg, therefore, he has
> > to disconnect the connection before it is connected again.
> 
> Why does he need to do that?  Why not just skip the disconnect
> notification if the hardware can't detect a disconnect?
> 
> It makes no sense at all to call a disconnect handler from within the
> SET_ADDRESS routine.

FWIW, here is the section from the DWC2 databook that describes how a
disconnect should be handled for the device:

When OTG_MODE is set to 0, 1, or 3, the device disconnect flow is as
follows:
	1. When the USB cable is unplugged or when the VBUS is switched
	   off by the Host, the Device core triggers GINTSTS.OTGInt
	   [bit 2] interrupt bit.
	2. When the device application detects GINTSTS.OTGInt interrupt,
	   it checks that the GOTGINT.SesEndDet (Session End Detected)
	   bit is set to 1'b1.

When OTG_MODE is set to 2 or 4, the device disconnect flow is as
follows:
	1. When the USB cable is unplugged or when the VBUS is switched
	   off by the Host, the Device core triggers GINTSTS.USBRst
	   [bit 12] interrupt bit.
	2. When the device application detects GINTSTS.USBRst, the
	   application sets a timeout check for SET ADDRESS Control Xfer
	   from Host.
	3. If application does not receive SET ADDRESS Control Xfer from
	   Host before the timeout period, it is treated as a device
	   disconnection.

OTG_MODE is a configuration parameter that is set when the core is
built. From this discussion, it sounds like the s3c-hsotg core is
built for either mode 2 or 4. So SET ADDRESS should be involved, but
not in the way the driver is currently doing it.

Unfortunately I don't have the s3c-hsotg hardware, so I can't work on this
myself.

-- 
Paul

