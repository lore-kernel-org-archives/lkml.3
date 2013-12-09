Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146Ab3LISYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:24:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:51456 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab3LISYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:24:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,859,1378882800"; 
   d="scan'208";a="421801061"
Date: Mon, 9 Dec 2013 10:24:10 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Vikas Sajjan <vikas.sajjan@linaro.org>, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, vpalatin@chromium.org, jwerner@chromium.org,
        tianyu.lan@intel.com, burzalodowa@gmail.com,
        gregkh@linuxfoundation.org, gautam.vivek@samsung.com,
        dianders@chromium.org, balbi@ti.com, joshi@samsung.com
Subject: Re: [PATCH] USB: core: Add warm reset while reset-resuming
 SuperSpeed HUBs
Message-ID: <20131209182410.GA5220@xanatos>
References: <1386592158-12086-1-git-send-email-vikas.sajjan@linaro.org>
 <Pine.LNX.4.44L0.1312091019400.1439-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1312091019400.1439-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 10:24:52AM -0500, Alan Stern wrote:
> On Mon, 9 Dec 2013, Vikas Sajjan wrote:
> 
> > Does warm reset while activating SuperSpeed HUBs if the hub activate type
> > is HUB_RESET_RESUME.
> > 
> > When we do Suspend-to-RAM with (any one of the 16, 32, 64 Jetflash) transcend
> > USB 3.0 device connected on 3.0 port, during resume I noticed that the
> > XHCI controller has moved to sometimes RECOVERY, POLLING or INACTIVE STATE.
> > This behaviour is inconsistent and the connection with connected USB 3.0 device
> > on 3.0 port was LOST.

Does the device eventually re-connect on the USB port?  Or is warm reset
necessary to make the device connect?

Does the xHCI register restore complete after resume from S3, or is
power lost?  I'm trying to figure out whether xhci_reset is called
before your issue is triggered.

> > Doing warm reset while activating SuperSpeed HUBs if the hub
> > activate type is HUB_RESET_RESUME, gets the connected device to the stable state.
> > 
> > Reviewed at https://chromium-review.googlesource.com/#/c/177132/
> > 
> > Tested on exynos5420 and exynos5250 with Transcend Jetflash USB 3.0 device (8564:1000)

Is this issue specific to the particular USB device manufacturer
(Transcend)?  Does the same device lose connection on resume from S3
with other host controller vendors?  Have you seen this issue when the
USB 3.0 device is behind a USB 3.0 hub?

I ask because this sounds like a low-level link training issue that's
specific to the exynos host or USB device.  I would rather track down
which hardware is to blame than generically add a warm reset for all USB
3.0 devices.

> > rebased on Greg Kroah-Hartman's usb-next
> > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
> > 
> > Signed-off-by: Vikas Sajjan <vikas.sajjan@samsung.com>
> > ---
> >  drivers/usb/core/hub.c |   41 +++++++++++++++++++++++++----------------
> >  1 file changed, 25 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> > index a7c04e2..d8432b0 100644
> > --- a/drivers/usb/core/hub.c
> > +++ b/drivers/usb/core/hub.c
> 
> > @@ -1093,6 +1108,16 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
> >  		u16 portstatus, portchange;
> >  
> >  		portstatus = portchange = 0;
> > +
> > +		/* Some connected devices might be still in unknown state even
> > +		 * after reset-resume, a WARM_RESET gets the connected device
> > +		 * to the normal state.
> > +		 */
> > +		if (udev && hub_is_superspeed(hub->hdev) &&
> > +						type == HUB_RESET_RESUME)
> > +			hub_port_reset(hub, port1, NULL,
> > +						HUB_BH_RESET_TIME, true);
> 
> Please don't do this all the time to every attached port.  Do it only 
> when it is really needed.

Agreed.  Can we at least limit the warm reset to devices directly
attached to roothubs?  You can also change this code to get the port
status and only do the warm reset if the port link state is
USB_SS_PORT_LS_POLLING, USB_SS_PORT_LS_RX_DETECT, or
USB_SS_PORT_LS_SS_INACTIVE.

> Shouldn't you pass udev as the third argument?  If not, please explain
> why not.
> 
> Finally, I don't see why you put this in hub_activate().  Isn't it more 
> closely connected with the reset-resume procedure for the child device?

Sarah Sharp
