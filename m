Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaCZCYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 22:24:09 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:2569
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755327AbaCZCYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 22:24:03 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Guenter Roeck <linux@roeck-us.net>, "wim@iguana.be" <wim@iguana.be>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] watchdog: imx2_wdt: Add big-endian support
Thread-Topic: [PATCH 2/2] watchdog: imx2_wdt: Add big-endian support
Thread-Index: AQHPSBPPLNCo5BpyWk60CNctoCO3d5rynk+AgAAB2jA=
Date: Wed, 26 Mar 2014 02:23:59 +0000
Message-ID: <aad28f70810b4f4b9086ba65e21327a2@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395740132-21396-1-git-send-email-Li.Xiubo@freescale.com>
 <1395740132-21396-3-git-send-email-Li.Xiubo@freescale.com>
 <533234DB.1030705@roeck-us.net>
In-Reply-To: <533234DB.1030705@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(24454002)(377454003)(51704005)(479174003)(65816001)(81542001)(92566001)(2201001)(98676001)(74876001)(90146001)(97336001)(51856001)(79102001)(97186001)(87266001)(76576001)(87936001)(63696002)(54356001)(93136001)(74706001)(85306002)(20776003)(74366001)(47446002)(69226001)(31966008)(19580405001)(74316001)(94946001)(19580395003)(83072002)(95666003)(94316002)(95416001)(4396001)(80976001)(53806001)(50986001)(59766001)(46102001)(85852003)(80022001)(2656002)(33646001)(81342001)(81816001)(66066001)(83322001)(54316002)(56776001)(86362001)(93516002)(74662001)(76482001)(81686001)(47736001)(77982001)(74502001)(49866001)(47976001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:B0FFF2F4.A0F29010.BFF7B764.2D4DE30.2047F;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCH 2/2] watchdog: imx2_wdt: Add big-endian support
> 
> On 03/25/2014 02:35 AM, Xiubo Li wrote:
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> 
> There is no explanation for this patch in the headline.
> 
> Ultimately there are four cases
> 	CPU	HW
> 	little	little
This case for most IMX* and Vybird and the LS2 SoCs.



> 	little	 big
This case for LS1 SoC.



> 	big	little
Actually, this case hasn't ever occurs for this IP, but maybe in the
Feature, not now.



> 	big	big
This case maybe for the PowrPC SoCs.



> Current code handles big/big as well as little/little, and you are adding
> little/big to the list of supported combinations. Questions are
> 1) which combinations are possible ?
> 2) is big/little a combination which needs to be handled as well ?
> 

Yes, I originally intended to use the Regmap APIs, but it couldn't support
The 16bit registers accessing now, and also won't support the [bit  little]
case too.

So now this driver will only support the following three cases:
CPU        IP
Little     little
Little     big
Big        big

If there hasn't any other problems, I will resend this patches adding this
Information.



> The "big-endians" property is new and will have to be approved by the
> DT maintainers. If in fact needed, I would suggest to use "big-endian"
> as this seems to be more common.
>

Yes, There has other IP driver has been accepted by DT maintainers. So
After this I will send the DT patches to them.

 
Thanks very much,

Best Regards,
Xiubo



> Guenter
> 
> 
> >   drivers/watchdog/imx2_wdt.c | 40 +++++++++++++++++++++++++++++++---------
> >   1 file changed, 31 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> > index 1795922..c410981 100644
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
> > +		imx2_wdt.big_endian = of_property_read_bool(np, "big-endians");
> >
> >   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >   	imx2_wdt.base = devm_ioremap_resource(&pdev->dev, res);
> >
> 
> 

