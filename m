Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaIBLSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:18:20 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:48151 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaIBLSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:18:18 -0400
Date: Tue, 2 Sep 2014 12:18:12 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org,
        lee.jones@linaro.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, peppe.cavallaro@st.com
Subject: Re: [PATCH v4 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3
 HC
Message-ID: <20140902111812.GA28857@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1406734091-16202-1-git-send-email-peter.griffin@linaro.org>
 <1406734091-16202-2-git-send-email-peter.griffin@linaro.org>
 <20140820180850.GV24500@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820180850.GV24500@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

Sorry for the delay in replying to this mail, I've been trying to get answers to the suspend/resume
questions you had.

> > +config USB_DWC3_ST
> > +	tristate "STMicroelectronics Platforms"
> > +	depends on ARCH_STI && OF
> > +	default USB_DWC3_HOST
> 
> this seems wrong as USB_DWC3_{HOST,GADGET,DUAL_ROLE} are booleans and
> USB_DWC3_ST is a tristate. Better to stick with defaulting to USB_DWC3
> instead like all the others.

Ok will fix.

> > +static inline void st_dwc3_writel(void __iomem *base, u32 offset, u32 value)
> > +{
> > +	writel_relaxed(value, base + offset);
> 
> why relaxed ?

The writel and readl implementations on ARM are quite expensive.

The writel, does a memory barrier, and also a outer_sync(), which involves taking a spinlock, and draining the cache store buffers.
The readl also does a memory barrier.

These barriers / cache operations are unnecessary here as the peripheral memory has been ioremap'ed as device memory, and
it is only one device we are writing to, so the writel/readl_relaxed variants are good enough as the ARM arch guarentees they
will arrive in program order.

There is some more info about this here http://permalink.gmane.org/gmane.linux.ports.arm.kernel/117658

Note: It's only possible when we know the driver is not being used on other architectures which may have different constraints.
However for this driver, we know this IP (st glue logic) has only been used on ARM based SoC's.

> 
> > +}
> > +
> > +/**
> > + * st_dwc3_drd_init: program the port
> > + * @dwc3_data: driver private structure
> > + * Description: this function is to program the port as either host or device
> > + * according to the static configuration passed from devicetree.
> > + * OTG and dual role are not yet supported!
> > + */
> > +static int st_dwc3_drd_init(struct st_dwc3 *dwc3_data)
> > +{
> > +	u32 val;
> > +	int err;
> > +
> > +	err = regmap_read(dwc3_data->regmap, dwc3_data->syscfg_reg_off, &val);
> > +	if (err)
> > +		return err;
> > +
> > +	switch (dwc3_data->dr_mode) {
> > +	case USB_DR_MODE_PERIPHERAL:
> > +		val |= USB_SET_PORT_DEVICE;
> > +		dev_dbg(dwc3_data->dev, "Configuring as Device\n");
> > +		break;
> > +
> > +	case USB_DR_MODE_HOST:
> > +		val &= USB_HOST_DEFAULT_MASK;
> 
> are you missing a ~ here ? Also, shouldn't you mask off the bits before
> this switch ?

Yes your right, good spot! In the next iteration I've defined macros for the bits in
this control register and explitcitly set/clear them for both cases, also adding a comment regarding
the USB3_DELAY_VBUSVALID bit.

By chance host mode still worked with this bug present as the reset value of the register on 
this SoC is OK to have working host mode.

> 
> > +		dev_dbg(dwc3_data->dev, "Configuring as Host\n");
> > +		break;
> > +
> > +	default:
> > +		dev_err(dwc3_data->dev, "Unsupported mode of operation %d\n",
> > +			dwc3_data->dr_mode);
> > +		return -EINVAL;
> > +	}
> > +
> > +	return regmap_write(dwc3_data->regmap, dwc3_data->syscfg_reg_off, val);
> > +}
> > +
> > +/**
> > + * st_dwc3_init: init the controller via glue logic
> > + * @dwc3_data: driver private structure
> > + */
> > +static void st_dwc3_init(struct st_dwc3 *dwc3_data)
> > +{
> > +
> 
> this blank line isn't necessary.

Ok, removed in next iteration

<snip>

> > +
> > +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "syscfg-reg");
> > +	if (!res) {
> > +		ret = -ENXIO;
> > +		goto undo_platform_dev_alloc;
> > +	}
> > +
> > +	dwc3_data->syscfg_reg_off = res->start;
> > +
> > +	dev_dbg(&pdev->dev, "glue-logic addr 0x%p, syscfg-reg offset 0x%x\n",
> > +		dwc3_data->glue_base, dwc3_data->syscfg_reg_off);
> 
> looks like this message would be more of a dev_vdbg().

Ok, changed to dev_vdbg in next iteration

<snip>

> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static int st_dwc3_suspend(struct device *dev)
> > +{
> > +	struct st_dwc3 *dwc3_data = dev_get_drvdata(dev);
> > +
> > +	reset_control_assert(dwc3_data->rstc_pwrdn);
> > +	reset_control_assert(dwc3_data->rstc_rst);
> 
> Two questions:
> 
> 1) how would you handle the case when this device is a wakeup source ?

I've confirmed with ST the usb3 IP can't be a wakeup source on this SoC.

> 2) when resuming, wouldn't you have to reinitialize the entire core ?

I asked ST to test this, as a full working suspend / resume setup involves some firmware for the
standby controller which I don't currently have access to (and it is only with the SBC running that all
power will be removed from this part of the SoC). They have confirmed that the usb3 port works after a suspend / resume
and devices are correctly enumerated etc after a resume with the code as it was submitted.

What I did notice though after re-reading it, is that we are not re-configuring the ST glue logic registers
on a resume. So the controller could end up with the vbus mux configured differently. So in the next iteration I've
fixed this, and call st_dwc3_drd_init and st_dwc3_init in the resume path.

Although ST confirmed that suspend / resume works with or without this change applied.

regards,

Peter.



