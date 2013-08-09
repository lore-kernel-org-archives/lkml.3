Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934422Ab3HIQK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:10:29 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:58742 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933806Ab3HIQK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:10:26 -0400
Message-ID: <1376064558.7709.31.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [RFC 2/2] usb: dwc3: Add Qualcomm DWC3 glue layer driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        gregkh@linuxfoundation.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Date: Fri, 09 Aug 2013 19:09:18 +0300
In-Reply-To: <20130809132349.GC12041@radagast>
References: <1375789991-30041-1-git-send-email-iivanov@mm-sol.com>
	 <1375789991-30041-3-git-send-email-iivanov@mm-sol.com>
	 <20130809132349.GC12041@radagast>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

On Fri, 2013-08-09 at 16:23 +0300, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Aug 06, 2013 at 02:53:11PM +0300, Ivan T. Ivanov wrote:
> > diff --git a/drivers/usb/dwc3/dwc3-msm.c b/drivers/usb/dwc3/dwc3-msm.c
> > new file mode 100644
> > index 0000000..e509abc
> > --- /dev/null
> > +++ b/drivers/usb/dwc3/dwc3-msm.c
> > @@ -0,0 +1,175 @@
> > +#undef CONFIG_REGULATOR
> 
> why ??????
> 

1. This shows that driver is still not fully tested 
   Regulators support is still missing in the MSM
2. Helps me to load driver successfully. 

> > +static int dwc3_msm_probe(struct platform_device *pdev)
> > +{
> > +	struct device_node *node = pdev->dev.of_node;
> > +	struct dwc3_msm *mdwc;
> > +	struct resource *res;
> > +	void __iomem *tcsr;
> > +	int ret = 0;
> > +
> > +	dev_info(&pdev->dev, "MSM DWC3\n");
> 
> please don't. This is hardly necessary.

Sure, this will be removed.

> 
> > +	mdwc = devm_kzalloc(&pdev->dev, sizeof(*mdwc), GFP_KERNEL);
> > +	if (!mdwc) {
> > +		dev_err(&pdev->dev, "not enough memory\n");
> 
> this message isn't needed either

ok.

> 
> > +	/*
> > +	 * DWC3 Core requires its CORE CLK (aka master / bus clk) to
> > +	 * run at 125Mhz in SSUSB mode and >60MHZ for HSUSB mode.
> > +	 */
> > +	clk_set_rate(mdwc->core_clk, 125000000);
> 
> if this is dwc3's core clock, why don't we teach dwc3.ko about this
> requirement ? Just make sure to have it optional, since x86 and OMAP
> wouldn't need direct fiddling with the clocks.

I have to check whether DWC3 core or Qcom wrapper requires this clock.

> 
> > +	clk_prepare_enable(mdwc->core_clk);
> > +	clk_prepare_enable(mdwc->iface_clk);
> > +	clk_prepare_enable(mdwc->sleep_clk);
> > +	clk_prepare_enable(mdwc->utmi_clk);
> 
> do you really need to enable your clocks here ? Why don't you enable
> them on runtime_resume and disable on runtime_suspend ?

I will like to make it working first and then will improve
power management.

> 
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	tcsr = devm_ioremap_resource(&pdev->dev, res);
> > +	if (!tcsr) {
> > +		dev_dbg(&pdev->dev, "tcsr ioremap failed\n");
> 
> no need to ioremap, also you're likely leaking clocks and regulators
> enabled here.
> 
> Make sure to have something like:
> 
> 	if (!tcsr)
> 		goto err_disable_clocks;
> 
> 	/* TODO This has to be revised */\
> 
> 	[...]
> 

Sure.

> > +	} else {
> > +		/* TODO: This has to be revised */
> > +
> > +		/* Enable USB3 on the primary USB port. */
> > +		writel_relaxed(0x1, tcsr);
> > +		/*
> > +		 * Ensure that TCSR write is completed before
> > +		 * USB registers initialization.
> > +		 */
> > +		mb();
> 
> why don't you use writel() instead. It will add the memory barrier for
> you.

Ok.

Thanks
Ivan


