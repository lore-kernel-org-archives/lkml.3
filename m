Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaJTSRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:17:47 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:58298 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaJTSRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:17:45 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Huang Rui <ray.huang@amd.com>, Felipe Balbi <balbi@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 16/16] usb: dwc3: enable usb suspend phy
Thread-Topic: [PATCH v2 16/16] usb: dwc3: enable usb suspend phy
Thread-Index: AQHP6ejVABuz6r2rwkO/f/VpUelcr5w0130A///F7HCAAHn0gIAEDZAAgAAFdICAACSKUA==
Date: Mon, 20 Oct 2014 18:17:42 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844E3C35@US01WEMBX2.internal.synopsys.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-17-git-send-email-ray.huang@amd.com>
 <20141017145942.GL26260@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E3423@US01WEMBX2.internal.synopsys.com>
 <20141017184819.GX26260@saruman> <20141020084153.GD24357@hr-slim.amd.com>
 <20141020090124.GE24357@hr-slim.amd.com>
In-Reply-To: <20141020090124.GE24357@hr-slim.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9KIHr17026320

> From: Huang Rui [mailto:ray.huang@amd.com]
> Sent: Monday, October 20, 2014 2:01 AM
> 
> On Mon, Oct 20, 2014 at 04:41:54PM +0800, Huang Rui wrote:
> > On Fri, Oct 17, 2014 at 01:48:19PM -0500, Felipe Balbi wrote:
> > > Hi,
> > >
> > > On Fri, Oct 17, 2014 at 06:41:04PM +0000, Paul Zimmerman wrote:
> > > > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > > > Sent: Friday, October 17, 2014 8:00 AM
> > > > >
> > > > > On Fri, Oct 17, 2014 at 04:53:41PM +0800, Huang Rui wrote:
> > > > > > AMD NL needs to suspend usb3 ss phy, but this doesn't enable on simulation
> > > > > > board.
> > > > > >
> > > > > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > > > > ---
> > > > > >  drivers/usb/dwc3/core.c          | 7 ++++++-
> > > > > >  drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
> > > > > >  drivers/usb/dwc3/platform_data.h | 1 +
> > > > > >  3 files changed, 9 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > > > > > index 3ccfe41..4a98696 100644
> > > > > > --- a/drivers/usb/dwc3/core.c
> > > > > > +++ b/drivers/usb/dwc3/core.c
> > > > > > @@ -395,6 +395,9 @@ static void dwc3_phy_setup(struct dwc3 *dwc)
> > > > > >  	if (dwc->quirks & DWC3_QUIRK_TX_DEEPH)
> > > > > >  		reg |= DWC3_GUSB3PIPECTL_TX_DEEPH(1);
> > > > > >
> > > > > > +	if (dwc->quirks & DWC3_QUIRK_SUSPHY)
> > > > >
> > > > > should be:
> > > > >
> > > > > 	if (!dwc->suspend_usb3_phy_quirk)
> > > > >
> > > > > > +		reg |= DWC3_GUSB3PIPECTL_SUSPHY;
> > > > >
> > > > > IIRC, databook asks us to set that bit anyway, so the quirk is disabling
> > > > > that bit. Am I missing something ? Paul ?
> > > >
> > > > It looks to me that Huang's patch is enabling that bit, not disabling
> > > > it.
> > >
> > > right, but that's what's actually quirky right ? IIRC, Databook asks us
> > > to set usb2 and usb3 suspend phy bits and we're just not doing it.
> > >
> > > > Currently the driver does not set either DWC3_GUSB3PIPECTL_SUSPHY or
> > > > DWC3_GUSB2PHYCFG_SUSPHY (unless it has been added by that big patch
> > > > series you just posted). According to the databook, both of those
> > > > bits should be set to 1 after the core initialization has completed.
> > >
> > > there you go. So unless that quirk bit flag is set, we're safe of
> > > setting SUSPHY bit for everybody.
> > >
> >
> 
> I read the databook again, below words (DWC3_GUSB3PIPECTL_SUSPHY) is
> copied from databook:
> 
> For DRD/OTG configurations, it is recommended that this bit is set toâ€˜
> 0â€™ during coreConsultant configuration. If it is set to â€™1â€™, then the
> application should clear this bit after power-on reset. Application
> needs to set it to â€™1â€™ after the core initialization is completed.
> For all other configurations, this bit can be set to â€™1â€™ during core
> configuration.
> 
> I see it's recommended to set '0' if on DRD/OTG configuration.

No, it's recommended to set it to '0' during coreConsultant
configuration. This is a part of the synthesis process, i.e. when
building the RTL for the SoC. This determines what the default value
of the bit will be when the core is reset. At runtime it is still
recommended to set it to '1' when in device mode, after the core
initialization is completed.

-- 
Paul

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
