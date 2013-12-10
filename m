Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3LJWMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:12:00 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:40132 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3LJWL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:11:58 -0500
MIME-Version: 1.0
In-Reply-To: <20131111233152.GR15154@atomide.com>
References: <1381784555-18344-1-git-send-email-marek@goldelico.com>
	<1381784555-18344-2-git-send-email-marek@goldelico.com>
	<20131111164917.GN15154@atomide.com>
	<CAAfyv37LRb_Q=UZVgtKdOAz_r6_qThewAU90W7nrqHdB5fDA_g@mail.gmail.com>
	<20131111233152.GR15154@atomide.com>
Date: Tue, 10 Dec 2013 23:11:57 +0100
Message-ID: <CAAfyv36MaVqrmQxpqDu-ciO9GNJK3pJkFZohEvd1BOLOWWEOhw@mail.gmail.com>
Subject: Re: [PATCH 1/3] arm: omap2: Export devconf1 bypass and acbias.
From: Belisko Marek <marek.belisko@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        NeilBrown <neilb@suse.de>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Tue, Nov 12, 2013 at 12:31 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Belisko Marek <marek.belisko@gmail.com> [131111 14:01]:
>> Hi Tony,
>>
>> On Mon, Nov 11, 2013 at 5:49 PM, Tony Lindgren <tony@atomide.com> wrote:
>> > * Marek Belisko <marek@goldelico.com> [131014 14:11]:
>> >> devconf1 reg access is localized only in mach-omap2 and we need to export
>> >> updating of devconf1 from omapdss venc driver (bypass and acbias bits).
>> >> Add simple api call which update only necessary bits.
>> > ...
>> >
>> >> +void update_bypass_acbias(bool bypass, bool acbias)
>> >> +{
>> >> +#ifdef CONFIG_ARCH_OMAP3
>> >> +     int val = omap_ctrl_readl(OMAP343X_CONTROL_DEVCONF1);
>> >> +
>> >> +     if (bypass)
>> >> +             val |= OMAP2_TVOUTBYPASS;
>> >> +     else
>> >> +             val &= ~OMAP2_TVOUTBYPASS;
>> >> +
>> >> +     if (acbias)
>> >> +             val |= OMAP2_TVACEN;
>> >> +     else
>> >> +             val &= ~OMAP2_TVACEN;
>> >> +
>> >> +     omap_ctrl_writel(val, OMAP343X_CONTROL_DEVCONF1);
>> >> +#endif
>> >
>> > If this is truly a pinmux, you could already access this
>> > using pinctrl-single,bits device tree driver.
>> >
>> > But I guess that won't work yet, so it's best to set this
>> > up as a separate driver like we've done for the USB PHY
>> > registers.
>>
>> Can you please point me to that driver directly? I cannot see benefit
>> of new driver as as it will be only dummy driver
>> with export_symbol_gpl of upper function. Can it sit then in dss
>> directory or somewhere else? Thanks.
>
> You can take a look at drivers/usb/phy/phy-omap-control.c.
>
> Then there's a device tree using example for control_devconf0 in
> Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt.
>
> Looks like CONTROL_DEVCONF1 contains a bunch of misc registers,
> and arch/arm/mach-omap2/hsmmc.c seems to be tinkering with it too.
>
> It would be best to set it up as omap-ctrl.c driver under drivers
> somewhere with few functions exported for DSS and MMC drivers.
I create small dummy driver based on phy-omap-control which can be
used but before sending patch (with more updates) I would like to get
some feedback if my direction is correct.
diff --git a/drivers/misc/omap-ctrl.c b/drivers/misc/omap-ctrl.c
new file mode 100644
index 0000000..ca2e576
--- /dev/null
+++ b/drivers/misc/omap-ctrl.c
@@ -0,0 +1,84 @@
+/*
+ * omap-ctrl.c - The part of omap control module.
+ *
+ * Copyright (C) 2013 Goldelico GmbH
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Author: Marek Belisko <marek@goldelico.com>
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+
+static u32 __iomem *devconf1;
+
+void omap_ctrl_tvoutbypass(int on)
+{
+    int val = readl(devconf1);
+
+    if (on)
+       val |= BIT(18);
+    else
+       val &= ~BIT(18);
+
+    writel(val, devconf1);
+}
+EXPORT_SYMBOL_GPL(omap_ctrl_tvoutbypass);
+
+
+void omap_ctrl_acen(int on)
+{
+    int val = readl(devconf1);
+
+    if (on)
+       val |= BIT(11);
+    else
+       val &= ~BIT(11);
+
+    writel(val, devconf1);
+}
+EXPORT_SYMBOL_GPL(omap_ctrl_acen);
+
+
+static int omap_ctrl_probe(struct platform_device *pdev)
+{
+    struct resource *res;
+
+    res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+       "devconf1");
+    devconf1 = devm_ioremap_resource(
+       &pdev->dev, res);
+    if (IS_ERR(devconf1))
+       return PTR_ERR(devconf1);
+
+    return 0;
+}
+
+struct platform_driver omap_ctrl_driver = {
+    .probe = omap_ctrl_probe,
+    .driver = {
+    .name = "omap-ctrl",
+    .owner = THIS_MODULE,
+    },
+};
+
+static int __init omap_ctrl_init(void)
+{
+    return platform_driver_register(&omap_ctrl_driver);
+}
+subsys_initcall(omap_ctrl_init);
+
+static void __exit omap_ctrl_exit(void)
+{
+    platform_driver_unregister(&omap_ctrl_driver);
+}

I use that driver with platform device in board file with proper
resources and it works fine. It could be easily added also DT
bindings.
Also you mention somewhere in drivers (but I think misc isn't right
place for that). Any opinion on that? Thanks for feedback.

>
> The reason why it should be a separate driver is that the system
> control module can live a separate runtime PM life from the
> drivers using the CONTROL_DEVCONF register bits.
>
> Regards,
>
> Tony

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
