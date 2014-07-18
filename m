Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbaGRHLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:11:23 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:41811 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbaGRHLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:11:21 -0400
Date: Fri, 18 Jul 2014 08:11:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, peter.griffin+familyguy@linaro.org
Subject: Re: [RFC PATCH] usb: dwc3: core: allow vendor drivers to check probe
 status
Message-ID: <20140718071115.GH30888@lee--X1>
References: <1405617213-27360-1-git-send-email-lee.jones@linaro.org>
 <20140717172045.GM10459@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140717172045.GM10459@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Felipe Balbi wrote:

> Hi,
> 
> On Thu, Jul 17, 2014 at 06:13:33PM +0100, Lee Jones wrote:
> > This patch provides mechanism for subordinate devices to check
> > whether the DWC3 core probed successfully or otherwise.  Useful
> > if PHYs are required to configure controllers, but aren't yet
> > available.  The DWC3 core driver will defer probe if PHYs are
> > unavailable, however subordinate DWC3 drivers currently do not
> > have any visibility or means to check status - until now.
> 
> what's a subordinate DWC3 driver ?
> 
> > Another way to do this would be to *_phy_get*(), but if every
> > driver did this it would create a high level of code
> > duplication.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/usb/dwc3/core.c | 12 ++++++++++++
> >  drivers/usb/dwc3/core.h |  1 +
> >  2 files changed, 13 insertions(+)
> > 
> > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > index eb69eb9..171ca52 100644
> > --- a/drivers/usb/dwc3/core.c
> > +++ b/drivers/usb/dwc3/core.c
> > @@ -47,6 +47,14 @@
> >  
> >  /* -------------------------------------------------------------------------- */
> >  
> > +static bool is_enabled = false;
> > +
> > +int dwc3_is_enabled(void)
> > +{
> > +	return is_enabled;
> > +}
> > +EXPORT_SYMBOL(dwc3_is_enabled);
> 
> no, no, no, no. Let me try that again, hello no! You _do_ realise there
> are systems with more than one dwc3 instance, right ? And this is the
> most fragile possible way of doing this.
> 
> You never explained what's a dwc3 subordinate driver, you don't show any
> example of how this would be used and why/where does the PHY need to
> poke into DWC3. Why isn't probe defer enough for you ? Which platform
> are you working on ? what is the problem that you're trying to solve ?
> 
> From this patch, all I can is NAK this patch with no mercy, sorry.

That's okay, I knew this was going to happen hence the RFC status of
the patch.  In the DT case, I describe 'subordinate devices' as are
drivers which register the DWC3 core using of_platform_populate(), 
so, for now:

  drivers/usb/dwc3/dwc3-exynos.c
  drivers/usb/dwc3/dwc3-keystone.c
  drivers/usb/dwc3/dwc3-omap.c

We're attempting to use the same process; however, at the moment we are
suffering with a 'boot order' issue.  If the PHYs aren't up and we
attempt to configure through the glue-layer our board locks up.  
Presumably waiting for a read to return, forever.  Whist the core does
the correct thing i.e. -EPROBE_DEFER, we (dwc3-st.c) have no way of
checking the return status of dwc3_probe().  As mentioned in the
commit message, another way of ensuring the PHYs are available is to
request them, but this would mean an awful lot of code duplication.

In your opinion, what's the best way to handle this?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
