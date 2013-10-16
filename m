Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249Ab3JPQZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:25:01 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:51853 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589Ab3JPQY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:24:58 -0400
MIME-Version: 1.0
In-Reply-To: <201310161525.r9GFPZI5006238@localhost.localdomain>
References: <201310161525.r9GFPZI5006238@localhost.localdomain>
Date: Wed, 16 Oct 2013 11:24:57 -0500
Message-ID: <CAL_JsqLSOy0OqEm4C1sCMSJnZ3O6Zsizpk_NJFxLij6LfyYK4A@mail.gmail.com>
Subject: Re: [PATCH] WAN: Adding support for Infineon PEF2256 E1 chipset
From: Rob Herring <robherring2@gmail.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, jerome.chantelauze@c-s.fr
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 10:25 AM, Christophe Leroy
<christophe.leroy@c-s.fr> wrote:
> The patch adds WAN support for Infineon PEF2256 E1 Chipset.
>
> Signed-off-by: Jerome Chantelauze <jerome.chantelauze@c-s.fr>
> Acked-by: Christophe Leroy <christophe.leroy@c-s.fr>

[snip]

> diff -urN a/Documentation/devicetree/bindings/net/pef2256.txt b/Documentation/devicetree/bindings/net/pef2256.txt
> --- a/Documentation/devicetree/bindings/net/pef2256.txt 1970-01-01 01:00:00.000000000 +0100
> +++ b/Documentation/devicetree/bindings/net/pef2256.txt 2013-10-13 15:05:42.000000000 +0200
> @@ -0,0 +1,29 @@
> +* Wan on Infineon pef2256 E1 controller
> +
> +Required properties:
> +- compatible: Should be "infineon,pef2256"
> +- reg: Address and length of the register set for the device
> +- interrupts: Should contain interrupts
> +
> +Optional properties:
> +- data-rate: Data rate on the system highway.
> +  Supported values are: 2, 4, 8, 16.
> +  8 if not defined.

What are the units? Specify them in the property name.

> +- channel-phase: First time slot transmission channel phase.
> +  Supported values are: 0, 1, 2, 3, 4, 5, 6, 7.
> +  0 if not defined.

This description basically tells me nothing.

> +- rising-edge-sync-pulse: rising edge synchronous pulse.
> +  Supported values are: "receive", "transmit".
> +  "transmit" if not defined.

Are receive and transmit mutually exclusive? If so, then wouldn't a
single property like "rx-rising-edge-sync-pulse" be sufficient.

> +
> +Examples:
> +
> +       e1-wan@4,2000000 {
> +               compatible = "infineon,pef2256";
> +               reg = <4 0x2000000 0xFF>;
> +               interrupts = <8 1>;
> +               interrupt-parent = <&PIC>;
> +               data-rate = <4>;
> +               channel-phase = <1>;
> +               rising-edge-sync-pulse = "transmit";
> +       };
> diff -urN a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
> --- a/drivers/net/wan/Makefile  1970-01-01 01:00:00.000000000 +0100
> +++ b/drivers/net/wan/Makefile  2013-10-13 13:05:01.000000000 +0200
> @@ -22,6 +22,7 @@
>  obj-$(CONFIG_COSA)             += cosa.o
>  obj-$(CONFIG_FARSYNC)          += farsync.o
>  obj-$(CONFIG_DSCC4)             += dscc4.o
> +obj-$(CONFIG_PEF2256)           += pef2256.o
>  obj-$(CONFIG_X25_ASY)          += x25_asy.o
>
>  obj-$(CONFIG_LANMEDIA)         += lmc/
> diff -urN a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
> --- a/drivers/net/wan/Kconfig   1970-01-01 01:00:00.000000000 +0100
> +++ b/drivers/net/wan/Kconfig   2013-10-13 13:05:01.000000000 +0200
> @@ -266,6 +266,16 @@
>           To compile this driver as a module, choose M here: the
>           module will be called farsync.
>
> +config PEF2256
> +       tristate "PEF2256 support"
> +       depends on HDLC && OF && SYSFS

It would be better if this can build without OF selected.

Rob
