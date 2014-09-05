Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbaIELWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:22:30 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:54489 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbaIELW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:22:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Richter <rric@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/4] arm64, thunder: Add initial dts for Cavium Thunder SoC
Date: Fri, 05 Sep 2014 13:21:48 +0200
Message-ID: <5017180.kZRPNE71Sv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409903205-2762-3-git-send-email-rric@kernel.org>
References: <1409903205-2762-1-git-send-email-rric@kernel.org> <1409903205-2762-3-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1h2dZ5z6R+ZZxGrcEb2eiqFkeC6dMIoR2gQ702Lwx/N
 I6wKuT9rhyUNCFJPWbossax9iSv0oSs6CQhIjwFyOxqmXZvGpj
 YV5fcF0hlbR9eKZOeS2jiN0Jy77rL2EftsKYwAzu2Cho3FbOJC
 Jd05g3jX4LTCy6saoLaiCXKuEmy+oQc5oO//Kb7GfCKUoZTpP5
 yKRX9aPUUrO1CRMNQKvZDGMUVx6jRB5BGwnvTJcfQMC09dAxGy
 HWCXl7fxlhk8k2rKmq2jykN3UuBx+KK0TxCYiLaA/3mb7/7JVz
 l8Pn23kU7YNdtU/q1yGXe7TI+Q3j60AKYWpbuoaaRI6p1vMYyj
 OC0/3+Xy4k4dgMmX1aRc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 09:46:43 Robert Richter wrote:
> diff --git a/arch/arm64/boot/dts/thunder-88xx.dts b/arch/arm64/boot/dts/thunder-88xx.dts
> new file mode 100644
> index 000000000000..4cc1d059d2d9
> --- /dev/null
> +++ b/arch/arm64/boot/dts/thunder-88xx.dts

Most people end up having a soc.dtsi file and a board.dsi file including
the former and adding the machine-specific properties.

It is likely that you will end up needing the same, so you might want to
start that way.

> +/ {
> +	model = "Cavium ThunderX CN88XX Family";
> +	compatible = "cavium,thunder-88xx";

As mentioned by Mark already, you should not include 'xx' in the
compatible string, but instead use the real soc ID.

Normally, each SoC has some slight differences anyway, so you would
override these in the specialized dtsi file.

The "model" property should go into the board specific file.

> +	interrupt-parent = <&gic0>;
> +	#address-cells = <2>;
> +	#size-cells = <2>;
> +
> +	aliases {
> +		serial0 = &uaa0;
> +		serial1 = &uaa1;
> +	};
> +
> +	psci {
> +		compatible = "arm,psci-0.2";
> +		method = "smc";
> +	};

The aliases node should go into the board file as well, since it's
possible that e.g. the first uart is not connected and you need
something like

	aliases {
		serial0 = &uaa1;
	};

The psci node (according to a discussion we just had for the freescale
dts files) should ideally get filled out by the boot loader that
implements the psci code, to ensure the version matches.

> +
> +	memory@00000000 {
> +		device_type = "memory";
> +		reg = <0x0 0x00000000 0x0 0x80000000>;
> +	};

memory should also go into the board specific file, or get filled by
the boot loader if it is detected at boot time and user serviceable.

I assume that your machines have NUMA properties, in that case it
makes sense to split up the memory device nodes by topology. I think
there are some standard properties to describe the topology further,
but I don't remember how it's done at the moment.

> +	soc {
> +		compatible = "simple-bus";
> +		#address-cells = <2>;
> +		#size-cells = <2>;
> +		ranges;
> +
> +		refclk50mhz: refclk50mhz {
> +			compatible = "fixed-clock";
> +			#clock-cells = <0>;
> +			clock-frequency = <50000000>;
> +			clock-output-names = "refclk50mhz";
> +		};

If the reference clock is generated outside of the SoC, I would put the device
node for it on the top level.

	Arnd
