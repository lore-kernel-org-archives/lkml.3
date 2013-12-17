Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab3LQBbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 20:31:05 -0500
Received: from seketeli.net ([91.121.166.71]:38245 "EHLO ms.seketeli.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab3LQBbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 20:31:03 -0500
Date: Tue, 17 Dec 2013 02:31:00 +0100
From: Apelete Seketeli <apelete@seketeli.net>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 3/3] usb: musb: fix setting JZ4740 gadget periphal mode
 on reset
Message-ID: <20131217013100.GX4581@hermes>
References: <1386992918-1531-1-git-send-email-apelete@seketeli.net>
 <1386992918-1531-4-git-send-email-apelete@seketeli.net>
 <20131216212056.GE12896@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216212056.GE12896@saruman.home>
X-Operating-System: Debian GNU/Linux jessie/sid
X-URL: http://apelete.seketeli.fr
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-Dec-13, Felipe Balbi wrote:
> On Sat, Dec 14, 2013 at 04:48:38AM +0100, Apelete Seketeli wrote:
> > JZ4740 USB Device Controller is not OTG compatible and does not have DEVCTL
> > register in silicon.
> > 
> > During ethernet-over-usb transactions, on reset, musb driver tries to
> > read from DEVCTL and consequently sets device as host (A-Device)
> > instead of peripheral (B-Device), which makes it a composite device to
> > the USB gadget driver.
> > This induces a kernel panic during power down where the USB gadget
> > driver does a null pointer dereference when trying to access the
> > composite device configuration.
> > 
> > On reset, do not rely on DEVCTL value for setting gadget peripheral
> > mode: hardcode it instead to B-Device.
> > 
> > Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
> > ---
> >  drivers/usb/musb/musb_gadget.c |    9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
> > index 32fb057..b4bea7a 100644
> > --- a/drivers/usb/musb/musb_gadget.c
> > +++ b/drivers/usb/musb/musb_gadget.c
> > @@ -2119,6 +2119,14 @@ __acquires(musb->lock)
> >  	/* Normal reset, as B-Device;
> >  	 * or else after HNP, as A-Device
> >  	 */
> > +#if defined(CONFIG_USB_MUSB_JZ4740) || defined(CONFIG_USB_MUSB_JZ4740_MODULE)
> 
> NAK, no ifdefs in this driver. Pass a quirk flag through platform_data
> or something similar.

I get that, makes sense to me, but problem is the driver has to read a
valid value from DEVCTL hardware register when musb_g_reset() is
called, and I do not see how this can be achieved through
platform_data.

Is it ok to use ifdefs in musb_regs.h to add specific hardware
register indexes for JZ4740 instead ?
I am actually thinking about fooling the musb driver into reading a
valid value from another register instead of DEVCTL.

Cheers.
-- 
        Apelete
