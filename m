Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbbAHS7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:59:25 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:33017 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbbAHS7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:59:23 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Jan 2015 19:58:45 +0100
From: Stefan Agner <stefan@agner.ch>
To: fugang.duan@freescale.com
Cc: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>,
        linux-kernel@vger.kernel.org, luwei.zhou@freescale.com,
        LW@karo-electronics.de, Frank.Li@freescale.com, davem@davemloft.net,
        u.kleine-koenig@pengutronix.de, shawn.guo@linaro.org
Subject: RE: [PATCH] net: fec: Fix dual ethernet issue in VFxx
In-Reply-To: <BLUPR03MB3737C3BCB45CA74A4073E85F5470@BLUPR03MB373.namprd03.prod.outlook.com>
References: <1420552052-4697-1-git-send-email-bhuvanchandra.dv@toradex.com>
 <43ef2a336673e63b89abaf1a71df29e0@agner.ch>
 <BLUPR03MB373B990180F59D2515E9065F5460@BLUPR03MB373.namprd03.prod.outlook.com>
 <fe59d331ecef890284cd005ae62bc236@agner.ch>
 <BLUPR03MB3737C3BCB45CA74A4073E85F5470@BLUPR03MB373.namprd03.prod.outlook.com>
Message-ID: <971bb29592c6ff4e786a988d850e1956@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jan  8 19:57:51 2015
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 54aed32f12811666820877
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-08 04:33, fugang.duan@freescale.com wrote:
> From: Stefan Agner <stefan@agner.ch> Sent: Wednesday, January 07, 2015 6:30 PM
>> To: Duan Fugang-B38611
>> Cc: Bhuvanchandra DV; linux-kernel@vger.kernel.org; Zhou Luwei-B45643;
>> LW@karo-electronics.de; Li Frank-B20596; davem@davemloft.net
>> Subject: RE: [PATCH] net: fec: Fix dual ethernet issue in VFxx
>>
>> On 2015-01-07 03:11, fugang.duan@freescale.com wrote:
>> > From: Stefan Agner <stefan@agner.ch> Sent: Tuesday, January 06, 2015
>> > 10:52 PM
>> >> To: Bhuvanchandra DV
>> >> Cc: linux-kernel@vger.kernel.org; Zhou Luwei-B45643; LW@karo-
>> >> electronics.de; Li Frank-B20596; Duan Fugang-B38611;
>> >> davem@davemloft.net
>> >> Subject: Re: [PATCH] net: fec: Fix dual ethernet issue in VFxx
>> >>
>> >> Fwiw, this patch really touches many devices and disables the quirk
>> >> for some devices, but this is done by intent.
>> >>
>> >> The quirk FEC_QUIRK_ENET_MAC was active for i.MX28, i.MX6Q, Vybrid
>> >> (mvf600-fec) and i.MX6SX. However, the new quirk is only enabled for
>> >> i.MX28. i.MX6Q doesn't need the quirk since there is one FEC instance
>> >> only anyway. Vybrid and i.MX6SX have a MDIO bus for each instance.
>> >>
>> >> Acked-by: Stefan Agner <stefan@agner.ch>
>> >
>> > We cannot do it by adding a quirk.
>> > For Vybrid and i.MX6SX and later i.MX7 serial,  there have their own
>> > MDIO bus for each MAC.
>> > But, for board design, to save two pin (MDIO, MDC), MAC0 and MAC1
>> > share the MDIO bus. For example, i.MX6SX sdb/sabreai/arm2 boards did
>> > like this.
>>
>> Hm, so those board use a circumstance which was SoC specific back at
>> i.MX28 time. IMHO, "Out of luck" the shared MDIO bus is the first one
>> even for those boards, hence this SoC specific work around still works.
>> So I still think for the i.MX28 case, the quirk would be a viable
>> solution, but not for those boards, I agree.
>>
>> > So we must add one dts property to distinguish it, not a quirk.
>>
>> Just adding a property to the FEC instance who's MDIO bus is in use seems
>> somewhat archaic. There is a MDIO bus description for other SoC, do you
>> have in mind how this should look like for fec?
>>
>> --
>> Stefan

(added Uwe to CC since he added the device tree support for MDIO bus)

> In general,  MAC2 use MAC1 MDIO bus. Because MAC1 is registered
> firstly, then register MAC2.
> We can invent one property like "shared-mii-bus" for MAC1 to tell
> driver there have other MACs use itself mii bus.
> Of course, the property needs to add for MAC2 device node to tell
> driver it will share the MAC1 mii bus.

There is actually already lot of device tree support for MDIO bus
description in place (see of_mdiobus_register call in the fec_main
driver), just the device tree's do not make a lot use of it currently.

The vf610-twr.dts has both FEC enabled as well as the quirk is enabled
in the driver for Vybrid. I tested the Tower System Module TWR-SER2 with
Vybrid. This module has two ethernet PHY's, but _both_ are connected to
the first RMII's MDIO bus (FEC0). Thanks to the quirk, both ports work
fine.

As a side note: Don't be fooled that there are both MDIO buses available
on the elevator: The module makes use of the MDIO of the first RMII
signals only, see TWR-SER2 schematic.

I then disabled the quirk and altered the device tree (patch courtesy of
Bhuvan):

diff --git a/arch/arm/boot/dts/vf610-twr.dts
b/arch/arm/boot/dts/vf610-twr.dts
index a0f7621..876c80a 100644
--- a/arch/arm/boot/dts/vf610-twr.dts
+++ b/arch/arm/boot/dts/vf610-twr.dts
@@ -129,13 +129,28 @@
 
 &fec0 {
        phy-mode = "rmii";
+       phy-handle = <&ethphy0>;
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_fec0>;
        status = "okay";
+
+       fec0mdio: mdio {
+               #address-cells = <1>;
+               #size-cells = <0>;
+
+               ethphy0: ethernet-phy@0 {
+                       reg = <0>;
+               };
+
+               ethphy1: ethernet-phy@1 {
+                       reg = <1>;
+               };
+       };
 };
 
 &fec1 {
        phy-mode = "rmii";
+       phy-handle = <&ethphy1>;
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_fec1>;
        status = "okay";

This worked also fine! Hence we actually already have all device tree
support needed. For the case we try to solve (using the MDIO bus of each
RMII), a device tree like this should be sufficient:

&fec0 {
	phy-mode = "rmii";
	phy-handle = <&ethphy0>;
...

	fec0mdio: mdio {
		#address-cells = <1>;
		#size-cells = <0>;

		ethphy0: ethernet-phy@0 {
			reg = <0>;
		};
	};
};

&fec1 {
...
	phy-handle = <&ethphy1>;
...

	fec1mdio: mdio {
		#address-cells = <1>;
		#size-cells = <0>;

		ethphy1: ethernet-phy@1 {
			reg = <1>;
		};
	};
};

Unfortunately, the quirk FEC_QUIRK_ENET_MAC leads to fec_enet_mii_init
return early for the _second_ FEC. Even if the PHY's would be properly
described in dt, parsing is prevented by that quirk.

Hence my suggestion is this:
- Implement the FEC_QUIRK_SINGLE_MDIO and add it to as in this patch,
which makes the quirk always work for i.MX28 even without dt changes...
(backward compatible)
- Fix the Tower device tree using the patch above to make the Tower work
again
- i.MX6SX is similar to Vybrid in that regard, adding a patch similar to
the one above should make the SX boards work too
- i.MX6S/D/Q is not affected since only one FEC instance is available
- i.MX7 is not yet merged, so a proper device tree description can be
used upfront

This would break old device trees with newer kernels for i.MX6SX and
Vybrid.. The first is quite new, and the latter is not very widespread,
IMHO this would be acceptable. Also, the device tree just did not
describe the hardware completely. "Out of a luck" (just because the MDIO
quirk for the i.MX28 SoC is active for all SoC's)..., it currently
works...

Alternatively, we can add the FEC_QUIRK_SINGLE_MDIO quirk to driver_data
of imx6sx-fec and mvf600-fec. Then, check early if a MDIO bus
description is available. This would keep the current device tree's
working while having support to describe other boards in device tree's
in the future (something along these lines):

diff --git a/drivers/net/ethernet/freescale/fec_main.c
b/drivers/net/ethernet/freescale/fec_main.c
index 5ebdf8d..527eb3e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1952,7 +1952,8 @@ static int fec_enet_mii_init(struct
platform_device *pdev)
         * mdio interface in board design, and need to be configured by
         * fec0 mii_bus.
         */
-       if ((fep->quirks & FEC_QUIRK_ENET_MAC) && fep->dev_id > 0) {
+       node = of_get_child_by_name(pdev->dev.of_node, "mdio");
+       if (!node && fep->quirks & FEC_QUIRK_SINGLE_MDIO && fep->dev_id
> 0) {
                /* fec1 uses fec0 mii_bus */
                if (mii_cnt && fec0_mii_bus) {
                        fep->mii_bus = fec0_mii_bus;
@@ -2001,7 +2002,6 @@ static int fec_enet_mii_init(struct
platform_device *pdev)
        for (i = 0; i < PHY_MAX_ADDR; i++)
                fep->mii_bus->irq[i] = PHY_POLL;
 
-       node = of_get_child_by_name(pdev->dev.of_node, "mdio");
        if (node) {
                err = of_mdiobus_register(fep->mii_bus, node);
                of_node_put(node);


However, IMHO this would add a quirk to SoC's which actually are not
affected... Hence I would prefer to not add that quirk on those SoC's
and just break the (uncomplete) device tree's....

--
Stefan

