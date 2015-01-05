Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbbAEGlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 01:41:03 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42441 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbbAEGlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 01:41:00 -0500
Date: Mon, 5 Jan 2015 08:40:57 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, Peter Chen <Peter.Chen@freescale.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH RFC] usb: chipidea: add support for usb_phy in generic
 usb2
Message-ID: <20150105064056.GV2481@sapphire.tkos.co.il>
References: <1f6e0195fcb215d8378db66bdd67900e57b9d290.1420351491.git.baruch@tkos.co.il>
 <54AA2397.5000708@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AA2397.5000708@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On Mon, Jan 05, 2015 at 11:09:35AM +0530, Kishon Vijay Abraham I wrote:
> On Sunday 04 January 2015 11:58 AM, Baruch Siach wrote:
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---
> >  drivers/usb/chipidea/ci_hdrc_usb2.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > I'm sending this as RFC as I'm not sure this is the right thing to do. There
> > seems to be a move away from USB specific PHY drivers towards the generic PHY
> > framework (drivers/phy). The trouble is that my PHY is similar to the mxs PHY
> > (phy-mxs-usb.c), and like mxs I need the notify_connect/notify_disconnect
> > callbacks. This functionality is not available is the generic PHY
> > framework. Having support for both 'usb-phy' and 'phy' properties (as dwc3
> > seems to do) is particularly bad, since the distinction between the two is a
> > Linux implementation detail that has nothing to do with hardware description.
> > 
> > So my questions are:
> > 
> >    1. Is there a plan to add notifications support to the generic PHY?
> > 
> >    2. If not, what are my options?
> 
> extcon framework has notification support. I feel your driver should use the
> extcon framework along with phy framework.

Currently USB PHY notifications are not going through the extcon framework. 
struct usb_phy includes its own notify_connect/notify_disconnect callbacks 
(see include/linux/usb/phy.h). Do you think USB should use extcon instead? USB 
PHY notifies carry the USB interface speed information, while extcon notifies 
seems to only carry boolean cable state.

> Adding extcon support in the generic PHY framework is something I have not
> thought through in detail.

Thanks,
baruch

> > diff --git a/drivers/usb/chipidea/ci_hdrc_usb2.c 
> > b/drivers/usb/chipidea/ci_hdrc_usb2.c
> > index 45844c951788..cc3aeb781a57 100644
> > --- a/drivers/usb/chipidea/ci_hdrc_usb2.c
> > +++ b/drivers/usb/chipidea/ci_hdrc_usb2.c
> > @@ -35,11 +35,16 @@ static int ci_hdrc_usb2_probe(struct platform_device *pdev)
> >  	struct device *dev = &pdev->dev;
> >  	struct ci_hdrc_usb2_priv *priv;
> >  	struct ci_hdrc_platform_data *ci_pdata = dev_get_platdata(dev);
> > +	struct usb_phy *usb_phy;
> >  	int ret;
> >  
> >  	if (!ci_pdata)
> >  		ci_pdata = &ci_default_pdata;
> >  
> > +	usb_phy = devm_usb_get_phy_by_phandle(&pdev->dev, "usb-phy", 0);
> > +	if (!IS_ERR(usb_phy))
> > +		ci_pdata->usb_phy = usb_phy;
> > +
> >  	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> >  	if (!priv)
> >  		return -ENOMEM;
> > 

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
