Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaCaESk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 00:18:40 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:13890
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751032AbaCaESi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 00:18:38 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Guenter Roeck <linux@roeck-us.net>, "wim@iguana.be" <wim@iguana.be>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 2/2] watchdog: imx2_wdt: Add big-endian support
Thread-Topic: [PATCHv2 2/2] watchdog: imx2_wdt: Add big-endian support
Thread-Index: AQHPSKDVcbPU6SPqA024POxEUieEfpr6ko0AgAAGE3A=
Date: Mon, 31 Mar 2014 04:18:33 +0000
Message-ID: <28375308b05f4cf4bc7d1559f2524c1b@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395800500-22655-1-git-send-email-Li.Xiubo@freescale.com>
 <1395800500-22655-3-git-send-email-Li.Xiubo@freescale.com>
 <5338E1E8.4030700@roeck-us.net>
In-Reply-To: <5338E1E8.4030700@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0167DB5752
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(24454002)(377454003)(479174003)(51704005)(95666003)(4396001)(93136001)(19300405004)(2201001)(92566001)(56816005)(83072002)(85852003)(56776001)(95416001)(87936001)(97186001)(53806001)(93516002)(86362001)(2656002)(87266001)(47736001)(94316002)(31966008)(50986001)(94946001)(85306002)(47976001)(97336001)(54356001)(15202345003)(80976001)(49866001)(90146001)(47446002)(74502001)(79102001)(77982001)(59766001)(46102001)(81686001)(80022001)(65816001)(20776003)(99286001)(33646001)(81542001)(66066001)(63696002)(15975445006)(81342001)(76482001)(74706001)(83322001)(19580405001)(19580395003)(74316001)(74876001)(81816001)(74366001)(76576001)(54316002)(76796001)(98676001)(24736002)(562404015);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:B0EF41F0.3231D610.7FF79724.6D4FE70.203C0;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Subject: Re: [PATCHv2 2/2] watchdog: imx2_wdt: Add big-endian support
> 
> On 03/25/2014 07:21 PM, Xiubo Li wrote:
> > For the platforms that this IP driver now supports:
> > SoC        CPU        Watchdog     Need 'big-endian'?
> > ------------------------------------------------------
> > Vybird     little     little       No
> > LS1        little     big          Yes
> > LS2        little     little       No
> > IMX+       little     little       No
> >
> > So for the LS1 SoCs, we need to do the big endianness converting.
> >
> > And this will also support the following case, for example:
> > SoC        CPU        Watchdog     Need 'big-endian'?
> > ------------------------------------------------------
> > PowerPC    big        big          Yes
> >
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > Cc: Guenter Roeck <linux@roeck-us.net>
> 
> Is this patch intended to solve the problem generically ?
> 
> http://www.spinics.net/lists/kernel/msg1714375.html
>

It's actually the following ones first, which will support 16-bits
Values for regmap-mmio:

https://patchwork.kernel.org/patch/3896321/
https://patchwork.kernel.org/patch/3896331/
https://patchwork.kernel.org/patch/3901021/

And the then the following one, which will support the LE endian:
http://www.spinics.net/lists/kernel/msg1714375.html


Thanks :)

BRs
Xiubo




 
> Guenter
> 
> > ---
> >   drivers/watchdog/imx2_wdt.c | 40 +++++++++++++++++++++++++++++++---------
> >   1 file changed, 31 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> > index 1795922..32f8874 100644
> > --- a/drivers/watchdog/imx2_wdt.c
> > +++ b/drivers/watchdog/imx2_wdt.c
> > @@ -30,6 +30,7 @@
> >   #include <linux/miscdevice.h>
> >   #include <linux/module.h>
> >   #include <linux/moduleparam.h>
> > +#include <linux/of.h>
> >   #include <linux/platform_device.h>
> >   #include <linux/timer.h>
> >   #include <linux/uaccess.h>
> > @@ -64,9 +65,26 @@ static struct {
> >   	void __iomem *base;
> >   	unsigned timeout;
> >   	unsigned long status;
> > +	bool big_endian;
> >   	struct timer_list timer;	/* Pings the watchdog when closed */
> >   } imx2_wdt;
> >
> > +static inline u16 imx2_wdt_readw(void __iomem *addr)
> > +{
> > +	if (imx2_wdt.big_endian)
> > +		return ioread16be(addr);
> > +	else
> > +		return ioread16(addr);
> > +}
> > +
> > +static inline void imx2_wdt_writew(u16 val, void __iomem *addr)
> > +{
> > +	if (imx2_wdt.big_endian)
> > +		iowrite16be(val, addr);
> > +	else
> > +		iowrite16(val, addr);
> > +}
> > +
> >   static struct miscdevice imx2_wdt_miscdev;
> >
> >   static bool nowayout = WATCHDOG_NOWAYOUT;
> > @@ -87,7 +105,7 @@ static const struct watchdog_info imx2_wdt_info = {
> >
> >   static inline void imx2_wdt_setup(void)
> >   {
> > -	u16 val = __raw_readw(imx2_wdt.base + IMX2_WDT_WCR);
> > +	u16 val = imx2_wdt_readw(imx2_wdt.base + IMX2_WDT_WCR);
> >
> >   	/* Suspend timer in low power mode, write once-only */
> >   	val |= IMX2_WDT_WCR_WDZST;
> > @@ -100,17 +118,17 @@ static inline void imx2_wdt_setup(void)
> >   	/* Set the watchdog's Time-Out value */
> >   	val |= WDOG_SEC_TO_COUNT(imx2_wdt.timeout);
> >
> > -	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
> > +	imx2_wdt_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
> >
> >   	/* enable the watchdog */
> >   	val |= IMX2_WDT_WCR_WDE;
> > -	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
> > +	imx2_wdt_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
> >   }
> >
> >   static inline void imx2_wdt_ping(void)
> >   {
> > -	__raw_writew(IMX2_WDT_SEQ1, imx2_wdt.base + IMX2_WDT_WSR);
> > -	__raw_writew(IMX2_WDT_SEQ2, imx2_wdt.base + IMX2_WDT_WSR);
> > +	imx2_wdt_writew(IMX2_WDT_SEQ1, imx2_wdt.base + IMX2_WDT_WSR);
> > +	imx2_wdt_writew(IMX2_WDT_SEQ2, imx2_wdt.base + IMX2_WDT_WSR);
> >   }
> >
> >   static void imx2_wdt_timer_ping(unsigned long arg)
> > @@ -143,12 +161,12 @@ static void imx2_wdt_stop(void)
> >
> >   static void imx2_wdt_set_timeout(int new_timeout)
> >   {
> > -	u16 val = __raw_readw(imx2_wdt.base + IMX2_WDT_WCR);
> > +	u16 val = imx2_wdt_readw(imx2_wdt.base + IMX2_WDT_WCR);
> >
> >   	/* set the new timeout value in the WSR */
> >   	val &= ~IMX2_WDT_WCR_WT;
> >   	val |= WDOG_SEC_TO_COUNT(new_timeout);
> > -	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
> > +	imx2_wdt_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
> >   }
> >
> >   static int imx2_wdt_open(struct inode *inode, struct file *file)
> > @@ -192,7 +210,7 @@ static long imx2_wdt_ioctl(struct file *file, unsigned
> int cmd,
> >   		return put_user(0, p);
> >
> >   	case WDIOC_GETBOOTSTATUS:
> > -		val = __raw_readw(imx2_wdt.base + IMX2_WDT_WRSR);
> > +		val = imx2_wdt_readw(imx2_wdt.base + IMX2_WDT_WRSR);
> >   		new_value = val & IMX2_WDT_WRSR_TOUT ? WDIOF_CARDRESET : 0;
> >   		return put_user(new_value, p);
> >
> > @@ -257,8 +275,12 @@ static struct miscdevice imx2_wdt_miscdev = {
> >
> >   static int __init imx2_wdt_probe(struct platform_device *pdev)
> >   {
> > -	int ret;
> > +	struct device_node *np = pdev->dev.of_node;
> >   	struct resource *res;
> > +	int ret;
> > +
> > +	if (np)
> > +		imx2_wdt.big_endian = of_property_read_bool(np, "big-endian");
> >
> >   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >   	imx2_wdt.base = devm_ioremap_resource(&pdev->dev, res);
> >
> 
> 

