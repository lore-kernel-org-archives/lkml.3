Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaHYItm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:49:42 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:33703 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbaHYItk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:49:40 -0400
Message-ID: <1408956570.1629.2.camel@iivanov-dev>
Subject: Re: [PATCH RESEND] usb: chipidea: msm: Use USB PHY API to control
 PHY state
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: Peter Chen <Peter.Chen@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tim Bird <tbird20d@gmail.com>, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Aug 2014 11:49:30 +0300
In-Reply-To: <20140819190643.GF22003@saruman.home>
References: <1408094479-13857-1-git-send-email-iivanov@mm-sol.com>
	 <20140819190643.GF22003@saruman.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-19 at 14:06 -0500, Felipe Balbi wrote:
> On Fri, Aug 15, 2014 at 12:21:19PM +0300, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > PHY drivers keep track of the current state of the hardware,
> > so don't change PHY settings under it.
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> 
> looks correct to me from a PHY API perspective, so:
> 
> Acked-by: Felipe Balbi <balbi@ti.com>
> 

Thanks.

> However, it doesn't look like msm_phy_init() is equivalent to the lines
> removes. Care to comment ?
> 

What I have to actually do is just add phy_init(). No need to remove
controller reinitialization. Tested and is working. Will post 2 new
patches shortly. 

Regards,
Ivan

> > ---
> >  drivers/usb/chipidea/ci_hdrc_msm.c | 9 ++-------
> >  1 file changed, 2 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
> > index d72b9d2..81de834 100644
> > --- a/drivers/usb/chipidea/ci_hdrc_msm.c
> > +++ b/drivers/usb/chipidea/ci_hdrc_msm.c
> > @@ -20,13 +20,11 @@
> >  static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
> >  {
> >  	struct device *dev = ci->gadget.dev.parent;
> > -	int val;
> >  
> >  	switch (event) {
> >  	case CI_HDRC_CONTROLLER_RESET_EVENT:
> >  		dev_dbg(dev, "CI_HDRC_CONTROLLER_RESET_EVENT received\n");
> > -		writel(0, USB_AHBBURST);
> > -		writel(0, USB_AHBMODE);
> > +		usb_phy_init(ci->transceiver);
> >  		break;
> >  	case CI_HDRC_CONTROLLER_STOPPED_EVENT:
> >  		dev_dbg(dev, "CI_HDRC_CONTROLLER_STOPPED_EVENT received\n");
> > @@ -34,10 +32,7 @@ static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
> >  		 * Put the transceiver in non-driving mode. Otherwise host
> >  		 * may not detect soft-disconnection.
> >  		 */
> > -		val = usb_phy_io_read(ci->transceiver, ULPI_FUNC_CTRL);
> > -		val &= ~ULPI_FUNC_CTRL_OPMODE_MASK;
> > -		val |= ULPI_FUNC_CTRL_OPMODE_NONDRIVING;
> > -		usb_phy_io_write(ci->transceiver, val, ULPI_FUNC_CTRL);
> > +		usb_phy_notify_disconnect(ci->transceiver, USB_SPEED_UNKNOWN);
> >  		break;
> >  	default:
> >  		dev_dbg(dev, "unknown ci_hdrc event\n");
> > -- 
> > 1.8.3.2
> > 
> 


