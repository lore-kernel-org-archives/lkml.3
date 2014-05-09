Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbaEILSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:18:14 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:59960 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbaEILSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:18:10 -0400
Date: Fri, 9 May 2014 15:18:02 +0400
From: Paul Fertser <fercerpav@gmail.com>
To: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
Cc: "balbi@ti.com" <balbi@ti.com>, "LeoLi@freescale.com" <LeoLi@freescale.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: fsl: check vbus presence on probe
Message-ID: <20140509111802.GD3876@home.lan>
References: <1398329653-29968-1-git-send-email-fercerpav@gmail.com> <20140430160625.GF23679@saruman.home> <20140430192745.GI3876@home.lan> <20140430201202.GF3839@saruman.home> <2cd9b3e31cce467e9a79d7aabd63604b@BL2PR03MB579.namprd03.prod.outlook.com> <59ef67eabf72450f988638edbbe1cd47@BL2PR03MB579.namprd03.prod.outlook.com> <20140508153845.GA3876@home.lan> <2d0cb4d1c8d7499ea6382cbb4c34c8d8@BL2PR03MB579.namprd03.prod.outlook.com> <20140508201414.GC3876@home.lan> <568714bf56b0449d8c0893e99e960657@BY2PR03MB588.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <568714bf56b0449d8c0893e99e960657@BY2PR03MB588.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 09, 2014 at 09:07:00AM +0000, suresh.gupta@freescale.com wrote:
> > Are you really sure we can't get async VBUS state change notifications
> > until controller has USB_CMD_RUN_STOP bit set (and the same bit actually
> > controls internal 1.5k dataline pullup)? If yes, I guess it means we need
> > to check VBUS state _every_ time we set that bit to sync the vbus_active
> > variable with the actual hardware state (unless an external OTG PHY is
> > used and VBUS pad state is irrelevant)?
> 
> There will be no interrupts if USB_CMD_RUN_STOP is not set but
> status get change.  I doubt, my previous patch
> (252455c40316009cc791f00338ee2e367d2d2739) make any difference in
> your device working.  Can you please remove my patch and check
> either your device work or not.

I wasn't using your patch actually as I'm running 3.10 + OpenWrt
patches, not current kernel HEAD.

Will there be no interrupts without CMD_RUN_STOP as well even if an
external PHY/transceiver is used? How do you expect
fsl_vbus_session(..., 1) to ever get called then?

> We are using two different configs(yours OTG and mine gadget only)
> that why I did not face the issue.

How do you tell I'm using OTG config and what does it mean given I'm
using FSL_USB2_DR_DEVICE? And I'm not using any external OTG
transceiver. And if you're using "gadget-only" config (what does it
actually mean?) what and when was actually setting vbus_active=1 for
you?

And BTW, I looked through all the places USB_CMD_RUN_STOP is set and
it looks like a real mess. E.g. why do you call dr_controller_run
unconditionally (without external transceiver) from fsl_udc_start()
and thus set CMD_RUN_STOP in there when afaict the gadget framework
expects you to activate the pull up only after fsl_pullup (via
usb_gadget_connect) is called? What and when is supposed to initialise
interrupts when an external transceiver is used? Was "OTG mode" (which
I'm not using afaict) tested ever at all? How can it work given the
current code? If it's not possible to track VBUS state changes in
"stop" mode why aren't you checking it explicitly every time after
entering "run" mode?

So far the current fsl_udc_core.c code looks like a broken omap_udc.c
copycat to me. Don't you think everything that deals with external PHY
should be removed first, then all the init/deinit/start/stop carefully
reviewed, restructured, reordered according to the gadget framework
requirements, common parts factored out, tested on different hardware,
then external transceiver support reintroduced in a clean and obvious
manner?

Given the history of your patches I see on patchwork, no, you do not
think so. I admit I'm not nearly an expert in Linux UDC/gadget
framework but your responses so far are confusing me to no end.

Balbi, as a stop-gap measure I will try to test and send a v2 patch
that would sense VBUS at the end of dr_controller_run(). I should
also probably send another one marking the driver BROKEN in Kconfig :/

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
