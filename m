Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab3FROx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:53:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45484 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932076Ab3FROx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:53:27 -0400
Date: Tue, 18 Jun 2013 10:53:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Roger Quadros <rogerq@ti.com>, Chao Xie <chao.xie@marvell.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <xiechao.mail@gmail.com>
Subject: Re: [PATCH] USB: initialize or shutdown PHY when add or remove host
 controller
In-Reply-To: <20130618082428.GF5461@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1306181046180.1157-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013, Felipe Balbi wrote:

> HI,
> 
> On Tue, Jun 18, 2013 at 11:23:59AM +0300, Roger Quadros wrote:
> > On 06/18/2013 11:01 AM, Felipe Balbi wrote:
> > > Hi,
> > > 
> > > On Tue, Jun 18, 2013 at 03:15:01AM -0400, Chao Xie wrote:
> > >> Some controller need software to initialize PHY before add
> > >> host controller, and shut down PHY after remove host controller.
> > >> Add the generic code for these controllers so they do not need
> > >> do it in its own host controller driver.
> > >>
> > >> Signed-off-by: Chao Xie <chao.xie@marvell.com>
> > >> ---
> > >>  drivers/usb/core/hcd.c |   19 ++++++++++++++++++-
> > >>  1 files changed, 18 insertions(+), 1 deletions(-)
> > >>
> > >> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> > >> index d53547d..b26196b 100644
> > >> --- a/drivers/usb/core/hcd.c
> > >> +++ b/drivers/usb/core/hcd.c
> > >> @@ -43,6 +43,7 @@
> > >>  
> > >>  #include <linux/usb.h>
> > >>  #include <linux/usb/hcd.h>
> > >> +#include <linux/usb/phy.h>
> > >>  
> > >>  #include "usb.h"
> > >>  
> > >> @@ -2531,12 +2532,22 @@ int usb_add_hcd(struct usb_hcd *hcd,
> > >>  	 */
> > >>  	set_bit(HCD_FLAG_RH_RUNNING, &hcd->flags);
> > >>  
> > >> +	/* Initialize the PHY before other hardware operation. */
> > >> +	if (hcd->phy) {
> > > 
> > > this looks wrong for two reasons:
> > > 
> > > a) you're not grabbing the PHY here.
> > > 
> > > 	You can't just assume another entity grabbed your PHY for you.
> > 
> > Isn't that done in the controller drivers e.g. ehci-fsl.c, ohci-omap, etc?
> 
> right, and what I'm saying is that it should all be re-factored into
> ehci-hcd core :-)
> 
> > If the controllers don't want HCD core to manage the PHY they can just set it
> > to some error code.
> 
> they shouldn't have the choice, otherwise it'll be a bit of a PITA to
> maintain the code. ehci core tries to grab the PHY, if it's not there,
> try to continue anyway. Assume it's not needed.

Felipe, are all these issues straightened out to your satisfaction?  I
can't tell from the email thread.

Looking through the EHCI glue source files, there appears to be a 
variety of different ways of getting the PHY.  It's not at all clear 
that they can be moved into the ehci-hcd core (or even better, the USB 
core -- which is what Chao is trying to do).

Given that the glue module has to be responsible for getting the PHY,
it should also be responsible for error checking.  So the code added to
hcd.c doesn't need to apply an IS_ERR check; it can simply assume that
if hcd->phy is NULL then either there is no software-controllable PHY
or else the HCD doesn't want the core to manage it.

Alan Stern

