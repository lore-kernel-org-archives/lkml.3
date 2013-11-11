Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3KKOhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:37:24 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:58407 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab3KKOhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:37:18 -0500
Message-ID: <1384180569.23605.21.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH 4/4] usb: chipidea: msm: Use USB PHY API to control PHY
 state
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        davidb@codeaurora.org, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Nov 2013 16:36:09 +0200
In-Reply-To: <20131111135931.GB21746@shlinux1.ap.freescale.net>
References: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
	 <1384176937-1658-5-git-send-email-iivanov@mm-sol.com>
	 <20131111135931.GB21746@shlinux1.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Peter,

On Mon, 2013-11-11 at 21:59 +0800, Peter Chen wrote: 
> On Mon, Nov 11, 2013 at 03:35:37PM +0200, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > PHY drivers keep track of the current state of the hardware,
> > so don't change PHY settings under it.
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> >  drivers/usb/chipidea/ci_hdrc_msm.c |    9 ++-------
> >  1 file changed, 2 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
> > index e9624f3..338b209 100644
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
> 
> It will reset the PHY,  but your comment is "don't change PHY settings under it"

:-). This function is exported by PHY drivers, so they will know how
to handle this change.

> 
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
> 
> Where you have implemented .notify_disconnect?
> I have not found it at your phy driver.

Yep, I will post PHY driver changes shortly. Meanwhile this should
not break existing board file based platforms, because not of them
could be compiled (HTC Dream, Halibut Board) and DT based platforms 
are sill work in progress.

Regards,
Ivan


