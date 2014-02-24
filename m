Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaBXSxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:53:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35110 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaBXSxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:53:41 -0500
Message-ID: <530B952D.2000006@wwwdotorg.org>
Date: Mon, 24 Feb 2014 11:53:33 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
CC: devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: add device tree for SHIELD
References: <1393237593-28121-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1393237593-28121-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 03:26 AM, Alexandre Courbot wrote:
> Add a device tree for NVIDIA SHIELD. The set of enabled features is
> still minimal with no display option (although HDMI should be easy
> to get to work) and USB requiring external power.

You could add a simple-framebuffer node for now, I think?

> diff --git a/arch/arm/boot/dts/tegra114-roth.dts b/arch/arm/boot/dts/tegra114-roth.dts

> +	memory {
> +		reg = <0x80000000 0x79600000>;

It might be worth a comment here pointing out that the rest of RAM is
reserved for some carveouts/..., or at least that these values are set
this way in order to match what the bootloader usually passes to
downstream kernels in the command-line?

> +	i2c@7000d000 {

> +		palmas: pmic@58 {
> +			compatible = "ti,palmas";
> +			reg = <0x58>;
> +			interrupts = <0 86 IRQ_TYPE_LEVEL_HIGH>;
> +			ti,irq-externally-inverted;

Unfortunately, the patch I sent to document/implement that last property
hasn't yet been ack'd/applied, so I'll hold off applying this until it has.

> +	/* Wifi */
> +	sdhci@78000000 {
> +		status = "okay";
> +		bus-width = <4>;
> +		broken-cd;
> +		keep-power-in-suspend;
> +		cap-sdio-irq;

Is non-removable better than broken-cd, or are they entirely unrelated?

Should we add broken-cd and/or cap-sdio-irq to the SDIO WiFi on other
boards (Springbank, Ventana, Cardhu)?

> +	usb-phy@7d000000 {
> +		status = "okay";
> +		nvidia,xcvr-setup = <7>;
> +		nvidia,xcvr-lsfslew = <2>;
> +		nvidia,xcvr-lsrslew = <2>;
> +		interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
> +		dr_mode = "otg";

While opt is probably accurate, we don't actually support otg upstream,
but only host. While the DT is supposed to represent HW rather than
SW/OS details, I've tried to avoid putting otg into the DT, since I'm
not sure that the DT binding for otg is stable, since we can't test it,
whereas host probably is. Still, this is a pretty minor detail, and we
can ignore that if you want ("otg" evidently /works/ fine on Seaboard,
so it's OK if you keep this).
