Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbbAZLqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:46:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:6573 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbbAZLqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:46:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,468,1418112000"; 
   d="scan'208";a="656496378"
Date: Mon, 26 Jan 2015 13:46:10 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] usb: dwc3: add ULPI interface support
Message-ID: <20150126114610.GA28539@kuha.fi.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-7-git-send-email-heikki.krogerus@linux.intel.com>
 <20150123162443.GH8585@saruman.tx.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123162443.GH8585@saruman.tx.rr.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 10:24:43AM -0600, Felipe Balbi wrote:
> On Fri, Jan 23, 2015 at 05:12:56PM +0200, Heikki Krogerus wrote:
> > +int dwc3_ulpi_init(struct dwc3 *dwc)
> > +{
> > +	u32 reg;
> > +
> > +	/* First check USB2 PHY interface type */
> > +	switch (DWC3_GHWPARAMS3_HSPHY_IFC(dwc->hwparams.hwparams3)) {
> > +	case DWC3_GHWPARAMS3_HSPHY_IFC_UTMI_ULPI:
> > +		/* Select ULPI Interface */
> > +		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
> > +		reg |= DWC3_GUSB2PHYCFG_ULPI_UTMI;
> > +		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
> > +		/* FALLTHROUGH */
> > +	case DWC3_GHWPARAMS3_HSPHY_IFC_ULPI:
> > +		break;
> > +	default:
> > +		return 0;
> > +	}
> > +
> > +	/* Register the interface */
> > +	dwc->ulpi = ulpi_register_interface(dwc->dev, &dwc3_ulpi);
> > +	if (IS_ERR(dwc->ulpi)) {
> 
> so, this will only build and link if DWC3_ULPI is enabled, in case of
> error you return early...
> 
> > +		dev_err(dwc->dev, "failed to register ULPI interface");
> > +		return PTR_ERR(dwc->ulpi);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +void dwc3_ulpi_exit(struct dwc3 *dwc)
> > +{
> > +	if (dwc->ulpi) {
> 
> ... looks like this branch is unnecessary.

We can't do that, or distros that select DWC3_ULPI option can only use
dwc3 with hardware that really has ULPI PHY. So I guess we'll drop the
DWC3_ULPI option and build the dwc3 ulpi support always if ULPI bus is
enabled. OK?


Thanks,

-- 
heikki
