Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647Ab3BHDEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 22:04:43 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55141 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759533Ab3BHDEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 22:04:42 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "hs@denx.de" <hs@denx.de>, "Porter, Matt" <mporter@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: RE: [PATCH V2 2/2] ARM: davinci: restart: fix wdt to machine
 restart with DT
Thread-Topic: [PATCH V2 2/2] ARM: davinci: restart: fix wdt to machine
 restart with DT
Thread-Index: AQHOBB5eXz/GNrK7h0ef7Zn3FGCAOJhuWeSAgADoAjA=
Date: Fri, 8 Feb 2013 03:04:08 +0000
Message-ID: <F3DBB1B3EF102E4994C89758CFCA32412C59EA@DBDE01.ent.ti.com>
References: <1360123204-9978-1-git-send-email-anilkumar.v@ti.com>
 <1360123204-9978-3-git-send-email-anilkumar.v@ti.com> <5113EF59.80508@ti.com>
In-Reply-To: <5113EF59.80508@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1834laA001068

Hi Sekhar,

Thanks for the review.

On Thu, Feb 07, 2013 at 23:45:53, Nori, Sekhar wrote:
> 
> On 2/6/2013 9:30 AM, Kumar, Anil wrote:
> > In non DT case da8xx_register_watchdog() is called to register platform device
> > "da8xx_wdt_device" by board file. But in DT case it is not called and wdt
> > device get registered via wdt DT node.
> > 
> > Currently code is passing platform device "da8xx_wdt_device" in
> > "davinci_watchdog_reset" function in both DT and non DT case and that
> > leads to crash in DT boot.
> > 
> > Update restart function to make it generic DaVinci machine restart
> 
> s/DaVinci/da8xx. Also, subject can simply be "ARM: davinci: da850 DT:
> add support for machine reboot" since reboot never worked with DT
> before, "fix" isn't really appropriate.

ok

> 
> > in case of DT and non DT boot.
> > 
> > Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
> > ---
> > :100644 100644 2d5502d... 1df68fd... M	arch/arm/mach-davinci/devices-da8xx.c
> > :100644 100644 700d311... ef9f70e... M	arch/arm/mach-davinci/include/mach/da8xx.h
> >  arch/arm/mach-davinci/devices-da8xx.c      |   14 ++++++++++++--
> >  arch/arm/mach-davinci/include/mach/da8xx.h |    1 -
> >  2 files changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
> > index 2d5502d..1df68fd 100644
> > --- a/arch/arm/mach-davinci/devices-da8xx.c
> > +++ b/arch/arm/mach-davinci/devices-da8xx.c
> > @@ -359,7 +359,7 @@ static struct resource da8xx_watchdog_resources[] = {
> >  	},
> >  };
> >  
> > -struct platform_device da8xx_wdt_device = {
> > +static struct platform_device da8xx_wdt_device = {
> 
> Making of da8xx_wdt_device static should find a mention in description.

Ok, 
I made da8xx_wdt_device structure static as it is used only
in file. I will update description for this.

> 
> >  	.name		= "watchdog",
> >  	.id		= -1,
> >  	.num_resources	= ARRAY_SIZE(da8xx_watchdog_resources),
> > @@ -368,7 +368,17 @@ struct platform_device da8xx_wdt_device = {
> >  
> >  void da8xx_restart(char mode, const char *cmd)
> >  {
> > -	davinci_watchdog_reset(&da8xx_wdt_device);
> > +	struct device *dev = NULL;
> > +	struct platform_device *wdt_device = NULL;
> 
> No need to initialize these variables here.

Ok,
I think no need to define wdt_device, can be used as

davinci_watchdog_reset(to_platform_device(dev));

> 
> > +
> > +	dev = bus_find_device_by_name(&platform_bus_type, NULL, "watchdog");
> > +	if (!dev) {
> > +		pr_err("wdt device not found to machine reboot\n");
> 
> Rather: "%s: failed to find watchdog device", __func__

ok
Thanks,
Anil
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
