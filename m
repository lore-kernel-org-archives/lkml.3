Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbaDCBD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 21:03:57 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:55846
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933036AbaDCBDz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 21:03:55 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "linux@roeck-us.net" <linux@roeck-us.net>, "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv3 2/2] watchdog: imx2_wdt: convert to use regmap API.
Thread-Topic: [PATCHv3 2/2] watchdog: imx2_wdt: convert to use regmap API.
Thread-Index: AQHPTWt2/DuGeyiECkOkCEkEXFil95r+TmKAgADHW2A=
Date: Thu, 3 Apr 2014 01:03:52 +0000
Message-ID: <8fff50f44ac44155b1b2c062985d08fc@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1396327598-28535-1-git-send-email-Li.Xiubo@freescale.com>
 <1396327598-28535-3-git-send-email-Li.Xiubo@freescale.com>
 <20140402130812.GD8558@dragon>
In-Reply-To: <20140402130812.GD8558@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(199002)(189002)(51704005)(93136001)(81686001)(93516002)(86362001)(85852003)(51856001)(19580395003)(80976001)(95416001)(2656002)(94316002)(97186001)(95666003)(56816005)(90146001)(81816001)(87266001)(97336001)(19580405001)(46102001)(92566001)(87936001)(74706001)(85306002)(83072002)(76482001)(54356001)(99286001)(4396001)(49866001)(47976001)(47446002)(81342001)(98676001)(33646001)(74316001)(76786001)(54316002)(56776001)(76796001)(76576001)(65816001)(74502001)(50986001)(53806001)(74662001)(69226001)(20776003)(74366001)(74876001)(83322001)(81542001)(31966008)(47736001)(66066001)(63696002)(79102001)(99396002)(77982001)(80022001)(59766001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:809CF0D0.87E25190.7FF707E4.82D71270.20397;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCHv3 2/2] watchdog: imx2_wdt: convert to use regmap API.
> 
> On Tue, Apr 01, 2014 at 12:46:38PM +0800, Xiubo Li wrote:
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > Cc: Guenter Roeck <linux@roeck-us.net>
> 
> We should probably have some commit log to explain why we need to move
> to use regmap API.
>

Well, yes, I will send V4 series to do the explaination.

Thanks :)

BRs
Xiubo
 
> Shawn
> 
> > ---
> >  drivers/watchdog/imx2_wdt.c | 50 +++++++++++++++++++++++++++++-------------
> ---
> >  1 file changed, 32 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> > index 1795922..76fa724 100644
> > --- a/drivers/watchdog/imx2_wdt.c
> > +++ b/drivers/watchdog/imx2_wdt.c
> > @@ -31,6 +31,7 @@
> >  #include <linux/module.h>
> >  #include <linux/moduleparam.h>
> >  #include <linux/platform_device.h>
> > +#include <linux/regmap.h>
> >  #include <linux/timer.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/watchdog.h>
> > @@ -61,7 +62,7 @@
> >
> >  static struct {
> >  	struct clk *clk;
> > -	void __iomem *base;
> > +	struct regmap *regmap;
> >  	unsigned timeout;
> >  	unsigned long status;
> >  	struct timer_list timer;	/* Pings the watchdog when closed */
> > @@ -87,7 +88,9 @@ static const struct watchdog_info imx2_wdt_info = {
> >
> >  static inline void imx2_wdt_setup(void)
> >  {
> > -	u16 val = __raw_readw(imx2_wdt.base + IMX2_WDT_WCR);
> > +	u32 val;
> > +
> > +	regmap_read(imx2_wdt.regmap, IMX2_WDT_WCR, &val);
> >
> >  	/* Suspend timer in low power mode, write once-only */
> >  	val |= IMX2_WDT_WCR_WDZST;
> > @@ -100,17 +103,17 @@ static inline void imx2_wdt_setup(void)
> >  	/* Set the watchdog's Time-Out value */
> >  	val |= WDOG_SEC_TO_COUNT(imx2_wdt.timeout);
> >
> > -	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
> > +	regmap_write(imx2_wdt.regmap, IMX2_WDT_WCR, val);
> >
> >  	/* enable the watchdog */
> >  	val |= IMX2_WDT_WCR_WDE;
> > -	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
> > +	regmap_write(imx2_wdt.regmap, IMX2_WDT_WCR, val);
> >  }
> >
> >  static inline void imx2_wdt_ping(void)
> >  {
> > -	__raw_writew(IMX2_WDT_SEQ1, imx2_wdt.base + IMX2_WDT_WSR);
> > -	__raw_writew(IMX2_WDT_SEQ2, imx2_wdt.base + IMX2_WDT_WSR);
> > +	regmap_write(imx2_wdt.regmap, IMX2_WDT_WSR, IMX2_WDT_SEQ1);
> > +	regmap_write(imx2_wdt.regmap, IMX2_WDT_WSR, IMX2_WDT_SEQ2);
> >  }
> >
> >  static void imx2_wdt_timer_ping(unsigned long arg)
> > @@ -143,12 +146,8 @@ static void imx2_wdt_stop(void)
> >
> >  static void imx2_wdt_set_timeout(int new_timeout)
> >  {
> > -	u16 val = __raw_readw(imx2_wdt.base + IMX2_WDT_WCR);
> > -
> > -	/* set the new timeout value in the WSR */
> > -	val &= ~IMX2_WDT_WCR_WT;
> > -	val |= WDOG_SEC_TO_COUNT(new_timeout);
> > -	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
> > +	regmap_update_bits(imx2_wdt.regmap, IMX2_WDT_WCR, IMX2_WDT_WCR_WT,
> > +			   WDOG_SEC_TO_COUNT(new_timeout));
> >  }
> >
> >  static int imx2_wdt_open(struct inode *inode, struct file *file)
> > @@ -181,7 +180,7 @@ static long imx2_wdt_ioctl(struct file *file, unsigned
> int cmd,
> >  	void __user *argp = (void __user *)arg;
> >  	int __user *p = argp;
> >  	int new_value;
> > -	u16 val;
> > +	u32 val;
> >
> >  	switch (cmd) {
> >  	case WDIOC_GETSUPPORT:
> > @@ -192,7 +191,7 @@ static long imx2_wdt_ioctl(struct file *file, unsigned
> int cmd,
> >  		return put_user(0, p);
> >
> >  	case WDIOC_GETBOOTSTATUS:
> > -		val = __raw_readw(imx2_wdt.base + IMX2_WDT_WRSR);
> > +		regmap_read(imx2_wdt.regmap, IMX2_WDT_WRSR, &val);
> >  		new_value = val & IMX2_WDT_WRSR_TOUT ? WDIOF_CARDRESET : 0;
> >  		return put_user(new_value, p);
> >
> > @@ -255,15 +254,30 @@ static struct miscdevice imx2_wdt_miscdev = {
> >  	.fops = &imx2_wdt_fops,
> >  };
> >
> > +static struct regmap_config imx2_wdt_regmap_config = {
> > +	.reg_bits = 16,
> > +	.reg_stride = 2,
> > +	.val_bits = 16,
> > +	.max_register = 0x8,
> > +};
> > +
> >  static int __init imx2_wdt_probe(struct platform_device *pdev)
> >  {
> > -	int ret;
> >  	struct resource *res;
> > +	void __iomem *base;
> > +	int ret;
> >
> >  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > -	imx2_wdt.base = devm_ioremap_resource(&pdev->dev, res);
> > -	if (IS_ERR(imx2_wdt.base))
> > -		return PTR_ERR(imx2_wdt.base);
> > +	base = devm_ioremap_resource(&pdev->dev, res);
> > +	if (IS_ERR(base))
> > +		return PTR_ERR(base);
> > +
> > +	imx2_wdt.regmap = devm_regmap_init_mmio_clk(&pdev->dev, NULL, base,
> > +						    &imx2_wdt_regmap_config);
> > +	if (IS_ERR(imx2_wdt.regmap)) {
> > +		dev_err(&pdev->dev, "regmap init failed\n");
> > +		return PTR_ERR(imx2_wdt.regmap);
> > +	}
> >
> >  	imx2_wdt.clk = devm_clk_get(&pdev->dev, NULL);
> >  	if (IS_ERR(imx2_wdt.clk)) {
> > --
> > 1.8.4
> >
> >

