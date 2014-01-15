Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaAORlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:41:08 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36078 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbaAORlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:41:05 -0500
Date: Wed, 15 Jan 2014 17:40:33 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Carino <marc.ceeeee@gmail.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 7/7] ARM: brcmstb: dts: add a reference DTS for
 Broadcom 7445
Message-ID: <20140115174033.GM25824@e106331-lin.cambridge.arm.com>
References: <1389743333-16741-1-git-send-email-marc.ceeeee@gmail.com>
 <1389743333-16741-8-git-send-email-marc.ceeeee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389743333-16741-8-git-send-email-marc.ceeeee@gmail.com>
Thread-Topic: [PATCH v3 7/7] ARM: brcmstb: dts: add a reference DTS for
 Broadcom 7445
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 11:48:53PM +0000, Marc Carino wrote:
> Add a sample DTS which will allow bootup of a board populated
> with the BCM7445 chip.
> 
> Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  arch/arm/boot/dts/brcmstb-7445.dts |  104 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 104 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/boot/dts/brcmstb-7445.dts
> 
> diff --git a/arch/arm/boot/dts/brcmstb-7445.dts b/arch/arm/boot/dts/brcmstb-7445.dts
> new file mode 100644
> index 0000000..cbe73b4
> --- /dev/null
> +++ b/arch/arm/boot/dts/brcmstb-7445.dts
> @@ -0,0 +1,104 @@
> +/dts-v1/;
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	#address-cells = <0x1>;
> +	#size-cells = <0x1>;

I see that there are some Xen patches floating around for the B15, so
presumably you have LPAE (and therefore can have physical addresses
wider than 32-bits).

Are all peripherals and memory in the bottom 4GB of the physical address
space? If not, I'd recommend you bump #address-cells (and #size-cells)
to <2> now, or you'll need to rewrite half the DT to add currently
missing peripherals...

Also, unless you're writing an address or mask it's usually nicer to
have the value in decimal rather than hex. Please could you get rid of
the 0x prefix on the #address-cells, #size-cells, #clock-cells values?

It's a minor issue, but it's nicer for humans to read...

> +	model = "Broadcom STB (7445)";
> +	compatible = "brcm,brcmstb-7445";
> +	interrupt-parent = <&gic>;
> +
> +	chosen {};
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x0 0x40000000 0x40000000 0x40000000 0x80000000 0x40000000>;
> +	};

As a general note, where you have list properties, please bracket
elements individually (here and elsewhere) so it's possible to read,
e.g:

	reg = <0x00000000 0x40000000>,
	      <0x40000000 0x40000000>,
	      <0x80000000 0x40000000>;

In this case, the memory is contiguous, so you can describe it with one
reg entry:

	reg = <0x0 0xc0000000>;

> +
> +	cpupll: cpupll@0 {
> +		#clock-cells = <0x0>;
> +		compatible = "fixed-clock";
> +		clock-frequency = <1500000000>;
> +	};

The unit-address (the "@0") should go, as this doesn't have a reg entry.
same for the cpu-clk-div@0 node below:

> +
> +	cpuclk: cpu-clk-div@0 {
> +		#clock-cells = <0x0>;
> +		compatible = "brcm,brcmstb-cpu-clk-div";
> +		reg = <0xf03e257c 0x4>;
> +		clocks = <&cpupll>;
> +		div-table = <0x0 0x1 0x11 0x2 0x12 0x4 0x13 0x8 0x14 0x10>;
> +	};

The unit-address here should be f03e257c (or 0,f03e257c if you move to
#address-cells = <2>).

Is this binding documented anywhere? It doesn't seem to be added in this
series, and grep on mainline gave me nothing...

> +
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			compatible = "brcm,brahma15";

I think this string should change, as mentioned in my cpu binding
patch comments.

> +			operating-points = <0x16e360 0x0
> +					    0x0b71b0 0x0
> +					    0x05b8d8 0x0
> +					    0x02dc6c 0x0
> +					    0x016e36 0x0>;

These might be easier to read in decimal...

> +			clocks = <&cpuclk>;
> +			device_type = "cpu";
> +			reg = <0>;
> +			clock-frequency = <1500000000>;
> +		};
> +
> +		cpu@1 {
> +			compatible = "brcm,brahma15";
> +			device_type = "cpu";
> +			reg = <1>;
> +			clock-frequency = <1500000000>;
> +		};
> +
> +		cpu@2 {
> +			compatible = "brcm,brahma15";
> +			device_type = "cpu";
> +			reg = <2>;
> +			clock-frequency = <1500000000>;
> +		};
> +
> +		cpu@3 {
> +			compatible = "brcm,brahma15";
> +			device_type = "cpu";
> +			reg = <3>;
> +			clock-frequency = <1500000000>;
> +		};
> +	};
> +
> +	gic: interrupt-controller@ffd00000 {
> +		compatible = "brcm,brahma15-gic", "arm,cortex-a15-gic";
> +		reg = <0xffd01000 0x1000
> +		       0xffd02000 0x2000>;

I see you have Xen patches, and therefore presumably have a GIC with
virtualization features. Could you add the missing reg entries for the
virtual control and virtual cpu interface registers please?

Cheers,
Mark.
