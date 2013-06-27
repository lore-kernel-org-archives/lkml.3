Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab3F0GOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:14:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38757 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab3F0GOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:14:22 -0400
Date: Thu, 27 Jun 2013 08:14:16 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, George Cherian <george.cherian@ti.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: dwc3: core: continue probe even if usb3 phy is
 not available
Message-ID: <20130627061416.GI3523@pengutronix.de>
References: <1372238954-29047-1-git-send-email-george.cherian@ti.com>
 <20130626101647.GT12640@arwen.pp.htv.fi>
 <51CAD977.6040309@ti.com>
 <20130626121210.GA12640@arwen.pp.htv.fi>
 <874nclghu2.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nclghu2.fsf@ashishki-desk.ger.corp.intel.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:10:38 up 13 days, 18:20, 21 users,  load average: 0.04, 0.03,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 03:46:45PM +0300, Alexander Shishkin wrote:
> Felipe Balbi <balbi@ti.com> writes:
> 
> > On Wed, Jun 26, 2013 at 05:37:19PM +0530, George Cherian wrote:
> >> On 6/26/2013 3:46 PM, Felipe Balbi wrote:
> >> >Hi,
> >> >
> >> >On Wed, Jun 26, 2013 at 02:59:14PM +0530, George Cherian wrote:
> >> >>There can be configurations in which DWC3 is hoooked up only to USB2 PHY.
> >> >>In such cases we should not return -EPROBE_DEFER, rather continue probe
> >> >>even if there is no USB3 PHY.
> >> >>
> >> >>Signed-off-by: George Cherian <george.cherian@ti.com>
> >> >>---
> >> >>  drivers/usb/dwc3/core.c | 31 ++++++++++++++++++++++++-------
> >> >>  1 file changed, 24 insertions(+), 7 deletions(-)
> >> >>
> >> >>diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> >> >>index c35d49d..d5e6f3e 100644
> >> >>--- a/drivers/usb/dwc3/core.c
> >> >>+++ b/drivers/usb/dwc3/core.c
> >> >>@@ -100,7 +100,9 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
> >> >>  	dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
> >> >>  	usb_phy_init(dwc->usb2_phy);
> >> >>-	usb_phy_init(dwc->usb3_phy);
> >> >>+
> >> >>+	if (dwc->usb3_phy)
> >> >>+		usb_phy_init(dwc->usb3_phy);
> >> >I would feel more comfortable if you would move our maximum_speed module
> >> >parameter to DT with a property such as:
> >> >
> >> >snps,maximum_speed = "highspeed";
> >> >
> >> >then on driver you could:
> >> okay
> >> >ret = of_property_read_string(np, "snps,maximum_speed", &maximum_speed);
> >> >if (ret < 0)
> >> >	bailout();
> >> >
> >> >if (strncmp(maximum_speed, "superspeed", 10) == 0) {
> >> >	/* grab USB3 PHY, return EPROBE_DEFER if not found */
> >> >	grab_usb3_phy();
> >> >}
> >> >
> >> >if ((strncmp(maximum_speed, "highspeed", 9) == 0) ||
> >> >	(strncmp(maximum_speed, "fullspeed", 9) == 0) ||
> >> >	(strncmp(maximum_speed, "lowspeed", 8) == 0)) {
> >> >	/* grab USB2 PHY, return EPROBE_DEFER if not found */
> >> >	grab_usb2_phy();
> >> >}
> >> >
> >> >this way, we depend solely on setting maximum_speed to highspeed for
> >> >AM437x :-)
> >> In dra7xx one instance is superspeed and one instance highspeed.
> >
> > right, but in DT you will define both instances and each instance will
> > have a seaparate snps,maximum_speed attribute :-)
> >
> > I'm now considering if we should make maximum_speed a generic attribute,
> > Kishon ? Alex ? Alan ?
> >
> > anyone else needs such thing ?
> 
> We have a force-full-speed attibute for chipidea on the way. This
> maximum_speed looks like a more generic alternative. Michael, what say
> you?

The maximum_speed attribute sounds more reasonable. I will change my
patch to it.

Regards,
Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
