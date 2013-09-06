Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750887Ab3IFIvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 04:51:07 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:46997 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3IFIvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 04:51:04 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH] ARM: OMAP2+: am335x-bone*: add DT for BeagleBone Black
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <50E637BB-5A62-477C-B943-9687BC3488BC@dominion.thruhere.net>
Date: Fri, 6 Sep 2013 10:51:01 +0200
Cc: <linux-omap@vger.kernel.org>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <olof@lixom.net>
Content-Transfer-Encoding: 7BIT
Message-Id: <A83CF7D5-0A26-4740-9F4D-51E5C1592EEF@dominion.thruhere.net>
References: <1378449204-8601-1-git-send-email-koen@dominion.thruhere.net> <52297CCF.3090200@ti.com> <50E637BB-5A62-477C-B943-9687BC3488BC@dominion.thruhere.net>
To: George Cherian <george.cherian@ti.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 6 sep. 2013, om 09:10 heeft Koen Kooi <koen@dominion.thruhere.net> het volgende geschreven:

> 
> Op 6 sep. 2013, om 08:57 heeft George Cherian <george.cherian@ti.com> het volgende geschreven:
> 
>> On 9/6/2013 12:03 PM, Koen Kooi wrote:
>>> The BeagleBone Black is basically a regular BeagleBone with eMMC and HDMI added,
>>> so create a common dtsi both can use. MMC support for AM335x still isn't in, so
>>> only the LDO change has been added.
>>> 
>>> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
>>> ---
>>> .../{am335x-bone.dts => am335x-bone-common.dtsi}   |   3 -
>>> arch/arm/boot/dts/am335x-bone.dts                  | 256 +--------------------
>>> arch/arm/boot/dts/am335x-boneblack.dts             |  18 ++
>>> 3 files changed, 19 insertions(+), 258 deletions(-)
>>> copy arch/arm/boot/dts/{am335x-bone.dts => am335x-bone-common.dtsi} (99%)
>>> create mode 100644 arch/arm/boot/dts/am335x-boneblack.dts
>> How did you test am335x-boneblack.dtb? where are the Makefile changes for boneblack?
> 
> Ah, I missed the makefile in my commit. I have a bunch of other patches on top to make more stuff work.
> 
> [..]
> 
>>> 
>>> --- /dev/null
>>> +++ b/arch/arm/boot/dts/am335x-boneblack.dts
>>> @@ -0,0 +1,18 @@
>>> +/*
>>> + * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>> +/dts-v1/;
>>> +
>>> +#include "am33xx.dtsi"
>> Why cant we add am33xx.dtsi  in am335x-bone-common.dtsi ?
> 
> That didn't work when I tried it. It did work before the preprocessor changes when using /include/
> 
>>> +#include "am335x-bone-common.dtsi"
>>> +
>>> +&ldo3_reg {
>>> +	regulator-min-microvolt = <1800000>;
>>> +	regulator-max-microvolt = <1800000>;
>>> +	regulator-always-on;
>>> +};
>>> +
>> With this ldo values mmc was not working for me on Boneblack.
>> got it working with
>> 
>> &ldo3_reg {
>> 	regulator-min-microvolt = <1800000>;
>> 	regulator-max-microvolt = <3300000>;
>> 	regulator-always-on;
>> };
> 
> That LDO is shared, the other consumer will get fried if you use 3.3V. I forget if it's DDR3 or HDMI.

On the black the LDOs changed, so for mmc (which (*$)@()$@) still isn't in mainline) you need:

diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
index e76d575..ae90a30 100644
--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -362,6 +362,13 @@
                        regulator-always-on;
                };
        };
+
+       vmmcsd_fixed: fixedregulator@0 {
+               compatible = "regulator-fixed";
+               regulator-name = "vmmcsd_fixed";
+               regulator-min-microvolt = <3300000>;
+               regulator-max-microvolt = <3300000>;
+       };
 };
 
 &cpsw_emac0 {
diff --git a/arch/arm/boot/dts/am335x-boneblack.dts b/arch/arm/boot/dts/am335x-boneblack.dts
index b4237fc..e092a61 100644
--- a/arch/arm/boot/dts/am335x-boneblack.dts
+++ b/arch/arm/boot/dts/am335x-boneblack.dts
@@ -16,7 +16,12 @@
        regulator-always-on;
 };
 
-&mmc2 {
+&mmc1 { 
+       vmmc-supply = <&vmmcsd_fixed>;
+};
+
+&mmc2 { 
+       vmmc-supply = <&vmmcsd_fixed>;
        pinctrl-names = "default";
        pinctrl-0 = <&emmc_pins>;
        vmmc-supply = <&ldo3_reg>;


