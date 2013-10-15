Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3JOHCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:02:25 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:52917 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab3JOHCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:02:23 -0400
Message-ID: <1381820463.29983.10.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v3 01/13] usb: phy: msm: Move mach depndend code to
 platform data
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, jackp@codeaurora.org, mgautam@codeaurora.org,
        dsegal@codeaurora.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 15 Oct 2013 10:01:03 +0300
In-Reply-To: <20131014225207.GD7446@radagast>
References: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
	 <1381764280-28420-2-git-send-email-iivanov@mm-sol.com>
	 <20131014225207.GD7446@radagast>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 17:52 -0500, Felipe Balbi wrote: 
> Hi,
> 
> On Mon, Oct 14, 2013 at 06:24:28PM +0300, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > This patch fix compilation error and is an intermediate step
> > before the addition of DeviceTree support for newer targets.
> > 
> > Cc: David Brown <davidb@codeaurora.org>
> > Cc: Daniel Walker <dwalker@fifo99.com>
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> >  arch/arm/mach-msm/board-msm7x30.c |   35 +++++++++++++++++++++++++++++++++++
> >  arch/arm/mach-msm/board-qsd8x50.c |   35 +++++++++++++++++++++++++++++++++++
> >  drivers/usb/phy/phy-msm-usb.c     |   34 ++++++++++++++--------------------
> >  include/linux/usb/msm_hsusb.h     |    3 +++
> >  4 files changed, 87 insertions(+), 20 deletions(-)
> > 
> > diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
> > index f9af5a4..46de789 100644
> > --- a/arch/arm/mach-msm/board-msm7x30.c
> > +++ b/arch/arm/mach-msm/board-msm7x30.c
> > @@ -30,6 +30,7 @@
> >  #include <asm/memory.h>
> >  #include <asm/setup.h>
> >  
> > +#include <mach/clk.h>
> >  #include <mach/msm_iomap.h>
> >  #include <mach/dma.h>
> >  
> > @@ -60,10 +61,44 @@ static int hsusb_phy_init_seq[] = {
> >  	-1
> >  };
> >  
> > +static int hsusb_link_clk_reset(struct clk *link_clk, bool assert)
> > +{
> > +	int ret;
> > +
> > +	if (assert) {
> > +		ret = clk_reset(link_clk, CLK_RESET_ASSERT);
> > +		if (ret)
> > +			pr_err("usb hs_clk assert failed\n");
> > +	} else {
> > +		ret = clk_reset(link_clk, CLK_RESET_DEASSERT);
> > +		if (ret)
> > +			pr_err("usb hs_clk deassert failed\n");
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int hsusb_phy_clk_reset(struct clk *phy_clk)
> > +{
> > +	int ret;
> > +
> > +	ret = clk_reset(phy_clk, CLK_RESET_ASSERT);
> > +	if (ret) {
> > +		pr_err("usb phy clk assert failed\n");
> > +		return ret;
> > +	}
> > +	usleep_range(10000, 12000);
> > +	ret = clk_reset(phy_clk, CLK_RESET_DEASSERT);
> > +	if (ret)
> > +		pr_err("usb phy clk deassert failed\n");
> > +	return ret;
> > +}
> > +
> >  static struct msm_otg_platform_data msm_otg_pdata = {
> >  	.phy_init_seq		= hsusb_phy_init_seq,
> >  	.mode                   = USB_PERIPHERAL,
> >  	.otg_control		= OTG_PHY_CONTROL,
> > +	.link_clk_reset		= hsusb_link_clk_reset,
> > +	.phy_clk_reset		= hsusb_phy_clk_reset,
> >  };
> >  
> >  struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
> > diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
> > index 5f933bc..9169ec3 100644
> > --- a/arch/arm/mach-msm/board-qsd8x50.c
> > +++ b/arch/arm/mach-msm/board-qsd8x50.c
> > @@ -31,6 +31,7 @@
> >  #include <mach/irqs.h>
> >  #include <mach/sirc.h>
> >  #include <mach/vreg.h>
> > +#include <mach/clk.h>
> >  #include <linux/platform_data/mmc-msm_sdcc.h>
> >  
> >  #include "devices.h"
> > @@ -81,10 +82,44 @@ static int hsusb_phy_init_seq[] = {
> >  	-1
> >  };
> >  
> > +static int hsusb_link_clk_reset(struct clk *link_clk, bool assert)
> > +{
> > +	int ret;
> > +
> > +	if (assert) {
> > +		ret = clk_reset(link_clk, CLK_RESET_ASSERT);
> > +		if (ret)
> > +			pr_err("usb hs_clk assert failed\n");
> > +	} else {
> > +		ret = clk_reset(link_clk, CLK_RESET_DEASSERT);
> > +		if (ret)
> > +			pr_err("usb hs_clk deassert failed\n");
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int hsusb_phy_clk_reset(struct clk *phy_clk)
> > +{
> > +	int ret;
> > +
> > +	ret = clk_reset(phy_clk, CLK_RESET_ASSERT);
> > +	if (ret) {
> > +		pr_err("usb phy clk assert failed\n");
> > +		return ret;
> > +	}
> > +	usleep_range(10000, 12000);
> > +	ret = clk_reset(phy_clk, CLK_RESET_DEASSERT);
> > +	if (ret)
> > +		pr_err("usb phy clk deassert failed\n");
> > +	return ret;
> > +}
> > +
> >  static struct msm_otg_platform_data msm_otg_pdata = {
> >  	.phy_init_seq		= hsusb_phy_init_seq,
> >  	.mode                   = USB_PERIPHERAL,
> >  	.otg_control		= OTG_PHY_CONTROL,
> > +	.link_clk_reset		= hsusb_link_clk_reset,
> > +	.phy_clk_reset		= hsusb_phy_clk_reset,
> >  };
> >  
> >  static struct platform_device *devices[] __initdata = {
> > diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> > index e9d4cd9..118798d 100644
> > --- a/drivers/usb/phy/phy-msm-usb.c
> > +++ b/drivers/usb/phy/phy-msm-usb.c
> > @@ -40,8 +40,6 @@
> >  #include <linux/usb/msm_hsusb_hw.h>
> >  #include <linux/regulator/consumer.h>
> >  
> > -#include <mach/clk.h>
> > -
> >  #define MSM_USB_BASE	(motg->regs)
> >  #define DRIVER_NAME	"msm_otg"
> >  
> > @@ -308,33 +306,29 @@ static void ulpi_init(struct msm_otg *motg)
> >  
> >  static int msm_otg_link_clk_reset(struct msm_otg *motg, bool assert)
> >  {
> > -	int ret;
> > +	int ret = 0;
> > +
> > +	if (!motg->pdata->link_clk_reset)
> > +		return ret;
> > +
> > +	ret = motg->pdata->link_clk_reset(motg->clk, assert);
> > +	if (ret)
> > +		dev_err(motg->phy.dev, "usb link clk reset failed\n");
> >  
> > -	if (assert) {
> > -		ret = clk_reset(motg->clk, CLK_RESET_ASSERT);
> > -		if (ret)
> > -			dev_err(motg->phy.dev, "usb hs_clk assert failed\n");
> > -	} else {
> > -		ret = clk_reset(motg->clk, CLK_RESET_DEASSERT);
> > -		if (ret)
> > -			dev_err(motg->phy.dev, "usb hs_clk deassert failed\n");
> > -	}
> >  	return ret;
> >  }
> >  
> >  static int msm_otg_phy_clk_reset(struct msm_otg *motg)
> >  {
> > -	int ret;
> > +	int ret = 0;
> >  
> > -	ret = clk_reset(motg->phy_reset_clk, CLK_RESET_ASSERT);
> > -	if (ret) {
> > -		dev_err(motg->phy.dev, "usb phy clk assert failed\n");
> > +	if (!motg->pdata->phy_clk_reset)
> >  		return ret;
> > -	}
> > -	usleep_range(10000, 12000);
> > -	ret = clk_reset(motg->phy_reset_clk, CLK_RESET_DEASSERT);
> > +
> > +	ret = motg->pdata->phy_clk_reset(motg->phy_reset_clk);
> >  	if (ret)
> > -		dev_err(motg->phy.dev, "usb phy clk deassert failed\n");
> > +		dev_err(motg->phy.dev, "usb phy clk assert failed\n");
> 
> seems like you're doing more than *just* fixing the build error. Which
> build error do you get ?

clk_reset() is defined only in mach code which is not available in 
multi platform builds. But you are right, probably I have to mention
that some error messages are also changed. 

With this change driver will loss ability to reset PHY and LINk
controllers on newer targets, but I don't think it is functional 
on them right now (driver resources are not defined on these
boards). I am planing to add reset framework support to driver in
order to support them.

Regards,
Ivan


