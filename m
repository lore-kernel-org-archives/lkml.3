Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab3JDOdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:33:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50067 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754650Ab3JDOdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:33:51 -0400
Date: Fri, 4 Oct 2013 15:33:48 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>, Paul Walmsley <paul@pwsan.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Mark A. Greer" <mgreer@animalcreek.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/9] ARM: dts: Add AES data and documentation for
 AM33XX
Message-ID: <20131004143348.GJ6999@e106331-lin.cambridge.arm.com>
References: <1380553986-15910-1-git-send-email-joelf@ti.com>
 <1380553986-15910-5-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380553986-15910-5-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 04:13:01PM +0100, Joel Fernandes wrote:
> From: "Mark A. Greer" <mgreer@animalcreek.com>
> 
> Add the generic AM33XX AES module's device tree data and
> enable it for the am335x-evm, am335x-evmsk, and am335x-bone
> platforms.  Also add Documentation file describing the data
> for the AES module.
> 
> [joelf@ti.com: Dropped interrupt-parent propert]
> 
> CC: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> ---
>  .../devicetree/bindings/crypto/omap-aes.txt        | 34 ++++++++++++++++++++++
>  arch/arm/boot/dts/am335x-bone.dts                  |  4 +++
>  arch/arm/boot/dts/am335x-evm.dts                   |  4 +++
>  arch/arm/boot/dts/am335x-evmsk.dts                 |  4 +++
>  arch/arm/boot/dts/am33xx.dtsi                      | 10 +++++++
>  5 files changed, 56 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/omap-aes.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/omap-aes.txt b/Documentation/devicetree/bindings/crypto/omap-aes.txt
> new file mode 100644
> index 0000000..4bb1e27
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/omap-aes.txt
> @@ -0,0 +1,34 @@
> +OMAP SoC AES crypto Module
> +
> +Required properties:
> +
> +- compatible : Should contain entries for this and backward compatible
> +  AES versions:
> +  - "ti,omap2-aes" for OMAP2.
> +  - "ti,omap3-aes" for OMAP3.
> +  - "ti,omap4-aes" for OMAP4 and AM33XX.
> +  Note that the OMAP2 and 3 versions are compatible (OMAP3 supports
> +  more algorithms) but they are incompatible with OMAP4.
> +- ti,hwmods: Name of the hwmod associated with the AES odule
> +- reg : Offset and length of the register set for the module
> +- interrupt-parent : the phandle for the interrupt controller that
> +  services interrupts for this module.
> +- interrupts : the interrupt number for the AES odule.

Similar comments to the SHAM module here:

* s/interrupt number/interrupt-specifier/
* Drop interrupt-parent.
* s/AES odule/AES module/

> +
> +Optional properties:
> +- dmas: DMA specifier for tx and rx dma. See the DMA client binding,
> +	Documentation/devicetree/bindings/dma/dma.txt

s/DMA specifier/DMA specifiers/

> +- dma-names: DMA request names. Should be '"tx", "rx"' if dma is present.

Nit: I'd prefer 'Should include "tx" and "rx" if present' -- I hope the
driver's requesting these by name rather than relying on a specific
ordering (it makes future expansion and optional components far easier
to handle sanely).

> +
> +Example:
> +	/* AM335x */
> +	aes: aes@53500000 {
> +		compatible = "ti,omap4-aes";
> +		ti,hwmods = "aes";
> +		reg = <0x53500000 0xa0>;
> +		interrupt-parent = <&intc>;
> +		interrupts = <102>;
> +		dmas = <&edma 6
> +			&edma 5>;
> +		dma-names = "tx", "rx";
> +	};

Minor nit, but for consistency could you bracket the DMAs individually:

		dmas = <&edma 6>,
		       <&edma 5>;

> diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
> index 8a9802e..94ee427 100644
> --- a/arch/arm/boot/dts/am335x-bone.dts
> +++ b/arch/arm/boot/dts/am335x-bone.dts
> @@ -23,3 +23,7 @@
>  &sham {
>  	status = "okay";
>  };
> +
> +&aes {
> +	status = "okay";
> +};
> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
> index d59e51c..86463fa 100644
> --- a/arch/arm/boot/dts/am335x-evm.dts
> +++ b/arch/arm/boot/dts/am335x-evm.dts
> @@ -526,3 +526,7 @@
>  &sham {
>  	status = "okay";
>  };
> +
> +&aes {
> +	status = "okay";
> +};
> diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
> index d45a330..f577e65 100644
> --- a/arch/arm/boot/dts/am335x-evmsk.dts
> +++ b/arch/arm/boot/dts/am335x-evmsk.dts
> @@ -428,3 +428,7 @@
>  &sham {
>  	status = "okay";
>  };
> +
> +&aes {
> +	status = "okay";
> +};
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 299710b..0daa1b2 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -719,5 +719,15 @@
>  			dmas = <&edma 36>;
>  			dma-names = "rx";
>  		};
> +
> +		aes: aes@53500000 {
> +			compatible = "ti,omap4-aes";
> +			ti,hwmods = "aes";
> +			reg = <0x53500000 0xa0>;
> +			interrupts = <102>;
> +			dmas = <&edma 6
> +				&edma 5>;

Bracketing here too, please.

Cheers,
Mark.

> +			dma-names = "tx", "rx";
> +		};
>  	};
>  };
> -- 
> 1.8.1.2
> 
> 
