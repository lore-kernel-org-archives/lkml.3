Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbaEHUOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:14:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46649 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbaEHUOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:14:20 -0400
Date: Fri, 9 May 2014 00:14:14 +0400
From: Paul Fertser <fercerpav@gmail.com>
To: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
Cc: "balbi@ti.com" <balbi@ti.com>, "LeoLi@freescale.com" <LeoLi@freescale.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: fsl: check vbus presence on probe
Message-ID: <20140508201414.GC3876@home.lan>
References: <1398329653-29968-1-git-send-email-fercerpav@gmail.com> <20140430160625.GF23679@saruman.home> <20140430192745.GI3876@home.lan> <20140430201202.GF3839@saruman.home> <2cd9b3e31cce467e9a79d7aabd63604b@BL2PR03MB579.namprd03.prod.outlook.com> <59ef67eabf72450f988638edbbe1cd47@BL2PR03MB579.namprd03.prod.outlook.com> <20140508153845.GA3876@home.lan> <2d0cb4d1c8d7499ea6382cbb4c34c8d8@BL2PR03MB579.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d0cb4d1c8d7499ea6382cbb4c34c8d8@BL2PR03MB579.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 06:42:53PM +0000, suresh.gupta@freescale.com wrote:
> > > And Host might be attach after system bootup or after driver
> > > initialization. So putting this check in probe will not help much.
> > 
> > If the host is attached after the driver was initialised, the interrupt
> > will trigger and the driver will get notified that VBUS appeared and
> > everything will go smooth, at least that's how it should work (I do not
> > have any board handy to real-life check that, but AFAICT that's the
> > intent of the current code).
> 
> If is go through the code flow starting from usb_composite_probe the sequence is
> usb_composite_probe->usb_gadget_probe_driver->udc_bind_to_driver->
> udc_bind_to_driver->usb_gadget_udc_start->fsl_udc_start->usbcmd=RUN
> udc_bind_to_driver->usb_gadget_connect->fsl_pullup
> 
> The function fsl_pullup make usbcmd=STOP if my fix is not there and if controller 
> is stopped we do not get any interrupt. 

Are you really sure we can't get async VBUS state change notifications
until controller has USB_CMD_RUN_STOP bit set (and the same bit
actually controls internal 1.5k dataline pullup)? If yes, I guess it
means we need to check VBUS state _every_ time we set that bit to sync
the vbus_active variable with the actual hardware state (unless an
external OTG PHY is used and VBUS pad state is irrelevant)?

> > I actually do not have any iMX demoboards at all, I've only got some
> > custom-designed i.MX25 boards where I can't control VBUS, it's
> > permanently pulled up.
> > 
> > But I was fixing the problem that was clearly, 100% reproducibly
> > happening when VBUS was applied before the interrupt was configured. So
> 
> Wait a minute, are you using OTG. If your VBUS is permanently pulled up, that 
> means you are only Gadget(I might miss something) then why you use OTG mode.

I'm using FSL_USB2_DR_DEVICE mode (FSL_USB2_PHY_UTMI phy_mode), so the
OTG controller should always work in the device mode only.

> > what exactly do you mean here? Do you mean this check I've added doesn't
> > fix the bug? Or do you mean this bug should be fixed somehow else? Or do
> 
> What expertly my concern is, probe is not proper place to check VBUS valid.
> I think we should wait to hear what Balbi has to say. 

Yes, I hope he can understand both of us :)

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
