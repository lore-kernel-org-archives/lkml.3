Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaI2Nsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:48:54 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:61890 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbaI2Nsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:48:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: zhang.lyra@gmail.com
Cc: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org,
        broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com,
        pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com,
        robh+dt@kernel.org, will.deacon@arm.com, orsonzhai@gmail.com,
        geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
Subject: Re: [PATCH 2/6] arm64: Add DTS support for Spreadtrum's Shark64 SoC
Date: Mon, 29 Sep 2014 15:47:47 +0200
Message-ID: <4004425.NZAxCnE0qr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411992293-7729-3-git-send-email-zhang.lyra@gmail.com>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com> <1411992293-7729-3-git-send-email-zhang.lyra@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ULZd9+MpPRA5iVAB01SeipCfsFOM7w7wK3g0HzCETui
 yQ0enrt9QaCuClWwV8TXApUTntjdMO/6OYpl4rYqaLroN34QrA
 v5aMf/DladtbrH+M8A2U5tpPwdZt6OwoTsIYbHzRs33UpiDAQg
 ANPJ3eyxYdN1O+BsYDieYWg+zDAQt/Fp1PMABCuKxgAtquKl6g
 pqU8TYsNccLEIERDdzqhLtMp/hDh9HVJVr2gGoc4BprwUF44J3
 4HBKEpxitf1zPThHRjE198wjNvexewDlFoLm2x7t643zID5/FH
 w64givhQxSh80vXIhnAE3jMhyjNNn0EuiKKJIx4zZIXKJU0uSJ
 IxUn/M9hfJ3Ovv1zTWIk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 September 2014 20:04:49 zhang.lyra@gmail.com wrote:
> +
> +/memreserve/ 0x80000000 0x00010000;

Maybe add a comment explaining why it is reserved?

> +	chosen {
> +		bootargs = "earlycon=serial_sprd,0x70000000";
> +      };

Just remove this for now, the command line should really be set by the
boot loader, not hardcoded in the dts file.

IIRC, the earlycon=... syntax is not recommended on DT based systems,
better use the "stdout-path" syntax instead.

> +	cpus {
> +		#address-cells = <2>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			device_type = "cpu";
> +			compatible = "arm,armv8";
> +			reg = <0x0 0x0>;
> +			enable-method = "spin-table";
> +			cpu-release-addr = <0x0 0x8000fff8>;
> +		};

New platforms should avoid using "spin-table" method. Please
change the boot loader to implement PSCI if you can.

> +	memory@80000000 {
> +		device_type = "memory";
> +		reg = <0 0x80000000 0 0x20000000>;
> +	};
> +
> +	aliases {
> +		serial0 = &uart0;
> +		serial1 = &uart1;
> +	};

These two belong into a board-specific file. I'd suggest renaming this
file to sprd_shark64.dtsi (or whatever the SoC is called) and adding a
.dts file that includes this and sets the aliases and memory node
according to what the particular board has.

> +	intc:interrupt-controller@71400000 {
> +		compatible = "sprd,intc";
> +		#interrupt-cells = <0>;
> +		interrupt-controller;
> +		reg =	<0 0x71400000 0 0x1000>,
> +			<0 0x71500000 0 0x1000>,
> +			<0 0x71600000 0 0x1000>,
> +			<0 0x71700000 0 0x1000>;
> +	};

This interrupt controller does not have a binding, so please add at least
a documentation for the binding as well. The name should probably be more
specific that this. Also, explain why you have an interrupt controller
that has four memory regions but only one interrupt sink but no interrupt
source.

I assume this is a nested interrupt controller to which some internal
peripherals are connected?

> +	uart0: uart@70000000 {
> +		compatible = "sprd,serial";
> +		reg = <0 0x70000000 0 0x100>;
> +		interrupts = <0 2 0xf04>;
> +	};
> +
> +	uart1: uart@70100000 {
> +		compatible = "sprd,serial";
> +		reg = <0 0x70100000 0 0x100>;
> +		interrupts = <0 3 0xf04>;
> +	};

Please rename these to serial@70000000. Like the interrupt controller,
it would be good to have a more specific compatible string.
You may want to add a status="disabled" property in both these
nodes, and override them from the board.dts file for the ports that
are actually available.

	Arnd

