Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbaHGOUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:20:41 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:54322 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502AbaHGOUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:20:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140807121248.GY30282@n2100.arm.linux.org.uk>
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
Date: Thu, 7 Aug 2014 11:20:38 -0300
Message-ID: <CAOMZO5ACj6ER3tUMS8XsnigT=-zs4TZFmobbtmTN-+LWJFLt4Q@mail.gmail.com>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
From: Fabio Estevam <festevam@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 9:12 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

> Hmm, I'm slightly confused.  On my iMX6Q, I have:
>
> 150:     581754          0          0          0       GIC 150  2188000.ethernet
> 151:          0          0          0          0       GIC 151  2188000.ethernet

Same here on a mx6qsabresd.

> In the DT file, we have:
>
>                         fec: ethernet@02188000 {
>                                 compatible = "fsl,imx6q-fec";
>                                 reg = <0x02188000 0x4000>;
>                                 interrupts-extended =
>                                         <&intc 0 118 IRQ_TYPE_LEVEL_HIGH>,
>                                         <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
>                                 clocks = <&clks 117>, <&clks 117>, <&clks 190>;
>                                 clock-names = "ipg", "ahb", "ptp";
>                                 status = "disabled";
>                         };
>
> which, for the gic, would be 118 + 32 (first SPI) = 150, 119 + 32 = 151.
> Yet you seem to have nothing registered against GIC 150, instead having
> an interrupt against GPIO 6.
>
> This seems very odd, and as this is an on-SoC device, I don't see why
> you would want to bind the interrupts for the FEC device any differently
> to standard platforms.
>
> This could well be the cause of your stalls.
>
> What's GPIO 6 used for on your board?

On a imx6q sabreauto I also get:

151:          0          0          0          0       GIC 151  2188000.ethernet
166:       4577          0          0          0  gpio-mxc   6  2188000.ethernet

and the GPIO1_6 interrupt comes from this commit:

commit bc20a5d6da718f9d60da0a78f70c653c1cd16af3
Author: Troy Kisky <troy.kisky@boundarydevices.com>
Date:   Fri Dec 20 11:47:12 2013 -0700

    ARM: dts: imx6qdl-sabreauto: use GPIO_6 for FEC interrupt.

    This works around a hardware bug.

    Signed-off-by: Troy Kisky <troy.kisky@boundarydevices.com>
    Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
