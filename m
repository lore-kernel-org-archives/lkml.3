Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbbAUM4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:56:36 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:38033 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbbAUM43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:56:29 -0500
Date: Wed, 21 Jan 2015 12:56:23 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 04/13] mtd: st_spi_fsm: Fetch boot device locations
 from DT match tables
Message-ID: <20150121125623.GB22024@x1>
References: <1418644760-18773-1-git-send-email-lee.jones@linaro.org>
 <1418644760-18773-5-git-send-email-lee.jones@linaro.org>
 <20150113045511.GO9759@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150113045511.GO9759@ld-irv-0074>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015, Brian Norris wrote:

> + devicetree
> 
> On Mon, Dec 15, 2014 at 11:59:11AM +0000, Lee Jones wrote:
> > To trim down on the amount of properties used by this driver and to conform
> > to the newly agreed method of acquiring syscfg registers/offsets, we now
> > obtain this information using match tables.
> > 
> > In the process we are deprecating the old generic compatible string and
> > providing 3 shiny new ones for each of the support platforms.  The
> > deprecated compatible string will be removed in due course.
> 
> I'm not sure how this agreement was done, but by default, we expect not
> to break backwards compatibility. This patch does just that.
> 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/mtd/devices/st_spi_fsm.c | 75 ++++++++++++++++++++++++++++++----------
> >  1 file changed, 57 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
> > index fac0fe9..d82394a 100644
> > --- a/drivers/mtd/devices/st_spi_fsm.c
> > +++ b/drivers/mtd/devices/st_spi_fsm.c
> > @@ -29,6 +29,21 @@
> >  #include "serial_flash_cmds.h"
> >  
> >  /*
> > + * FSM SPI Boot Mode Registers/Masks
> > + */
> > +#define STID127_SYSCON_BOOT_DEV_REG	0x0D8
> > +#define STID127_SYSCON_BOOT_DEV_SPI	0x068
> > +#define STID127_SYSCON_BOOT_DEV_MASK	0x07C
> > +
> > +#define STIH407_SYSCON_BOOT_DEV_REG	0x8C4
> > +#define STIH407_SYSCON_BOOT_DEV_SPI	0x068
> > +#define STIH407_SYSCON_BOOT_DEV_MASK	0x07C
> > +
> > +#define STIH416_SYSCON_BOOT_DEV_REG	0x958
> > +#define STIH416_SYSCON_BOOT_DEV_SPI	0x01A
> > +#define STIH416_SYSCON_BOOT_DEV_MASK	0x01F
> > +
> > +/*
> >   * FSM SPI Controller Registers
> >   */
> >  #define SPI_CLOCKDIV			0x0010
> > @@ -288,6 +303,12 @@ struct seq_rw_config {
> >  	uint8_t         dummy_cycles;   /* No. of DUMMY cycles */
> >  };
> >  
> > +struct stfsm_boot_dev {
> > +	uint32_t		reg;
> > +	uint32_t		spi;
> > +	uint32_t		mask;
> > +};
> > +
> >  /* SPI Flash Device Table */
> >  struct flash_info {
> >  	char            *name;
> > @@ -313,6 +334,24 @@ struct flash_info {
> >  	int             (*config)(struct stfsm *);
> >  };
> >  
> > +static struct stfsm_boot_dev stfsm_stid127_data = {
> > +	.reg  = STID127_SYSCON_BOOT_DEV_REG,
> > +	.spi  = STID127_SYSCON_BOOT_DEV_SPI,
> > +	.mask = STID127_SYSCON_BOOT_DEV_MASK,
> > +};
> > +
> > +static struct stfsm_boot_dev stfsm_stih407_data = {
> > +	.reg  = STIH407_SYSCON_BOOT_DEV_REG,
> > +	.spi  = STIH407_SYSCON_BOOT_DEV_SPI,
> > +	.mask = STIH407_SYSCON_BOOT_DEV_MASK,
> > +};
> > +
> > +static struct stfsm_boot_dev stfsm_stih416_data = {
> > +	.reg  = STIH416_SYSCON_BOOT_DEV_REG,
> > +	.spi  = STIH416_SYSCON_BOOT_DEV_SPI,
> > +	.mask = STIH416_SYSCON_BOOT_DEV_MASK,
> > +};
> > +
> >  static int stfsm_n25q_config(struct stfsm *fsm);
> >  static int stfsm_mx25_config(struct stfsm *fsm);
> >  static int stfsm_s25fl_config(struct stfsm *fsm);
> > @@ -1977,14 +2016,23 @@ static int stfsm_init(struct stfsm *fsm)
> >  	return 0;
> >  }
> >  
> > +static const struct of_device_id stfsm_match[] = {
> > +	{ .compatible = "st,spi-fsm" }, /* DEPRECATED */
> > +	{ .compatible = "st,stid127-spi-fsm", .data = &stfsm_stid127_data },
> > +	{ .compatible = "st,stih407-spi-fsm", .data = &stfsm_stih407_data },
> > +	{ .compatible = "st,stih416-spi-fsm", .data = &stfsm_stih416_data },
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(of, stfsm_match);
> > +
> >  static void stfsm_fetch_platform_configs(struct platform_device *pdev)
> >  {
> >  	struct stfsm *fsm = platform_get_drvdata(pdev);
> >  	struct device_node *np = pdev->dev.of_node;
> > +	const struct stfsm_boot_dev *boot_dev;
> > +	const struct of_device_id *match;
> >  	struct regmap *regmap;
> > -	uint32_t boot_device_reg;
> > -	uint32_t boot_device_spi;
> > -	uint32_t boot_device;     /* Value we read from *boot_device_reg */
> > +	uint32_t boot_device;    /* Value we read from the boot dev mode pins */
> >  	int ret;
> >  
> >  	/* Booting from SPI NOR Flash is the default */
> > @@ -1998,21 +2046,18 @@ static void stfsm_fetch_platform_configs(struct platform_device *pdev)
> >  
> >  	fsm->reset_por = of_property_read_bool(np, "st,reset-por");
> >  
> > -	/* Where in the syscon the boot device information lives */
> > -	ret = of_property_read_u32(np, "st,boot-device-reg", &boot_device_reg);
> > -	if (ret)
> > +	match = of_match_node(stfsm_match, np);
> > +	if (!match)
> >  		goto boot_device_fail;
> > +	boot_dev = match->data;
> >  
> > -	/* Boot device value when booted from SPI NOR */
> > -	ret = of_property_read_u32(np, "st,boot-device-spi", &boot_device_spi);
> > +	ret = regmap_read(regmap, boot_dev->reg, &boot_device);
> 
> 
> ^^^ NULL pointer dereference for any existing DTB that uses the
> "st,spi-fsm" compatible string. So I'll NAK this patch as-is. Either we
> need to completely drop the "deprecated" compatible property (what's the
> point binding to it, if we're going to OOPS on it anyway), or else we
> need to maintain both methods (at least for whatever deprecation period
> is deemed acceptable).

Great spot Brian.

So, as I explained in reply to the cover-letter, this driver isn't
being used in anger yet.  As the driver is still considered
in-progress I take the view that it's perfectly okay to remove the old
compatible string and not match on it at all.

I'll make the necessary changes and re-submit.

> >  	if (ret)
> >  		goto boot_device_fail;
> >  
> > -	ret = regmap_read(regmap, boot_device_reg, &boot_device);
> > -	if (ret)
> > -		goto boot_device_fail;
> > +	boot_device &= boot_dev->mask;
> >  
> > -	if (boot_device != boot_device_spi)
> > +	if (boot_device != boot_dev->spi)
> >  		fsm->booted_from_spi = false;
> >  
> >  	return;
> > @@ -2156,12 +2201,6 @@ static int stfsmfsm_resume(struct device *dev)
> >  
> >  static SIMPLE_DEV_PM_OPS(stfsm_pm_ops, stfsmfsm_suspend, stfsmfsm_resume);
> >  
> > -static const struct of_device_id stfsm_match[] = {
> > -	{ .compatible = "st,spi-fsm", },
> > -	{},
> > -};
> > -MODULE_DEVICE_TABLE(of, stfsm_match);
> > -
> >  static struct platform_driver stfsm_driver = {
> >  	.probe		= stfsm_probe,
> >  	.remove		= stfsm_remove,
> 
> Brian

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
