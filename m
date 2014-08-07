Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbaHGOio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:38:44 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:41286 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488AbaHGOim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:38:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5ACj6ER3tUMS8XsnigT=-zs4TZFmobbtmTN-+LWJFLt4Q@mail.gmail.com>
References: <C4A61A5CA4AD2246942F4BA6F20ACB80435655E9@ALVA-EXMB04.alv.autoliv.int>
	<20140626151424.GT32514@n2100.arm.linux.org.uk>
	<20140627112151.GF32514@n2100.arm.linux.org.uk>
	<3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int>
	<20140627163108.GP32514@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int>
	<20140806095012.GN30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int>
	<20140806125550.GO30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int>
	<20140807121248.GY30282@n2100.arm.linux.org.uk>
	<CAOMZO5ACj6ER3tUMS8XsnigT=-zs4TZFmobbtmTN-+LWJFLt4Q@mail.gmail.com>
Date: Thu, 7 Aug 2014 11:38:40 -0300
Message-ID: <CAOMZO5BZdnzOuD9CcMv3bXsryT-j1A_bAjF6EAj_=BQTuxn45A@mail.gmail.com>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
From: Fabio Estevam <festevam@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Troy Kisky <troy.kisky@boundarydevices.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 11:20 AM, Fabio Estevam <festevam@gmail.com> wrote:

> On a imx6q sabreauto I also get:
>
> 151:          0          0          0          0       GIC 151  2188000.ethernet
> 166:       4577          0          0          0  gpio-mxc   6  2188000.ethernet
>
> and the GPIO1_6 interrupt comes from this commit:
>
> commit bc20a5d6da718f9d60da0a78f70c653c1cd16af3
> Author: Troy Kisky <troy.kisky@boundarydevices.com>
> Date:   Fri Dec 20 11:47:12 2013 -0700
>
>     ARM: dts: imx6qdl-sabreauto: use GPIO_6 for FEC interrupt.
>
>     This works around a hardware bug.
>
>     Signed-off-by: Troy Kisky <troy.kisky@boundarydevices.com>
>     Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

Actually a more descriptive commit log can be found here:

commit 6261c4c8f13eb91f733e8ba6d67c409a2e841667
Author: Troy Kisky <troy.kisky@boundarydevices.com>
Date:   Fri Dec 20 11:47:11 2013 -0700

    ARM: dts: imx6qdl-sabrelite: use GPIO_6 for FEC interrupt.

    This works around a hardware bug.
    From "Chip Errata for the i.MX 6Dual/6Quad"

    ERR006687 ENET: Only the ENET wake-up interrupt request can wake the
    system from Wait mode.

    The ENET block generates many interrupts. Only one of these interrupt lines
    is connected to the General Power Controller (GPC) block, but a logical OR
    of all of the ENET interrupts is connected to the General
Interrupt Controller
    (GIC). When the system enters Wait mode, a normal RX Done or TX
Done does not
    wake up the system because the GPC cannot see this interrupt. This impacts
    performance of the ENET block because its interrupts are serviced only when
    the chip exits Wait mode due to an interrupt from some other wake-up source.

    Before this patch, ping times of a Sabre Lite board are quite
    random:
    ping 192.168.0.13 -i.5 -c5
    PING 192.168.0.13 (192.168.0.13) 56(84) bytes of data.
    64 bytes from 192.168.0.13: icmp_req=1 ttl=64 time=15.7 ms
    64 bytes from 192.168.0.13: icmp_req=2 ttl=64 time=14.4 ms
    64 bytes from 192.168.0.13: icmp_req=3 ttl=64 time=13.4 ms
    64 bytes from 192.168.0.13: icmp_req=4 ttl=64 time=12.4 ms
    64 bytes from 192.168.0.13: icmp_req=5 ttl=64 time=11.4 ms

    === 192.168.0.13 ping statistics ===
    5 packets transmitted, 5 received, 0% packet loss, time 2004ms
    rtt min/avg/max/mdev = 11.431/13.501/15.746/1.508 ms
    ____________________________________________________
    After this patch:

    ping 192.168.0.13 -i.5 -c5
    PING 192.168.0.13 (192.168.0.13) 56(84) bytes of data.
    64 bytes from 192.168.0.13: icmp_req=1 ttl=64 time=0.120 ms
    64 bytes from 192.168.0.13: icmp_req=2 ttl=64 time=0.175 ms
    64 bytes from 192.168.0.13: icmp_req=3 ttl=64 time=0.169 ms
    64 bytes from 192.168.0.13: icmp_req=4 ttl=64 time=0.168 ms
    64 bytes from 192.168.0.13: icmp_req=5 ttl=64 time=0.172 ms

    === 192.168.0.13 ping statistics ===
    5 packets transmitted, 5 received, 0% packet loss, time 1999ms
    rtt min/avg/max/mdev = 0.120/0.160/0.175/0.026 ms
    ____________________________________________________

    Also, apply same change to imx6qdl-nitrogen6x.

    This change may not be appropriate for all boards.
    Sabre Lite uses GPIO6 as a power down output for a ov5642
    camera. As this expansion board does not yet work with mainline,
    this is not yet a conflict. It would be nice to have an alternative
    fix for boards where this is a problem.

    For example Sabre SD uses GPIO6 for I2C3_SDA. It also
    has long ping times currently. But cannot use this fix
    without giving up a touchscreen.

    Its ping times are also random.

    ping 192.168.0.19 -i.5 -c5
    PING 192.168.0.19 (192.168.0.19) 56(84) bytes of data.
    64 bytes from 192.168.0.19: icmp_req=1 ttl=64 time=16.0 ms
    64 bytes from 192.168.0.19: icmp_req=2 ttl=64 time=15.4 ms
    64 bytes from 192.168.0.19: icmp_req=3 ttl=64 time=14.4 ms
    64 bytes from 192.168.0.19: icmp_req=4 ttl=64 time=13.4 ms
    64 bytes from 192.168.0.19: icmp_req=5 ttl=64 time=12.4 ms

    === 192.168.0.19 ping statistics ---
    5 packets transmitted, 5 received, 0% packet loss, time 2003ms
    rtt min/avg/max/mdev = 12.451/14.369/16.057/1.316 ms

    Signed-off-by: Troy Kisky <troy.kisky@boundarydevices.com>
    CC: Ranjani Vaidyanathan <ra5478@freescale.com>
    Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

,but I am wondering if we should also do:

--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -66,6 +66,7 @@
        pinctrl-0 = <&pinctrl_enet>;
        phy-mode = "rgmii";
        interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
+                             <&intc 0 118 IRQ_TYPE_LEVEL_HIGH>,
                              <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
        status = "okay";
 };
@@ -226,7 +227,7 @@
                                MX6QDL_PAD_RGMII_RD2__RGMII_RD2         0x1b0b0
                                MX6QDL_PAD_RGMII_RD3__RGMII_RD3         0x1b0b0
                                MX6QDL_PAD_RGMII_RX_CTL__RGMII_RX_CTL   0x1b0b0
-                               MX6QDL_PAD_GPIO_6__ENET_IRQ             0x000b1
+                               MX6QDL_PAD_GPIO_6__ENET_IRQ
 0x400000b1

Since the Workaround for erratum ERR006687 states that the SION bit
needs to be used:

"All of the interrupts can be selected by MUX and output to pad GPIO6.
If GPIO6 is selected to
output ENET interrupts and GPIO6 SION is set, the resulting GPIO
interrupt will wake the system
from Wait mode."
