Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbaFPV6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:58:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54490 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524AbaFPV6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:58:50 -0400
Message-ID: <539F6897.7080306@wwwdotorg.org>
Date: Mon, 16 Jun 2014 15:58:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com,
        tj@kernel.org, pdeschrijver@nvidia.com
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/9] ARM: tegra: Add SATA and SATA power to Jetson TK1
 device tree
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com> <1401881559-18469-4-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1401881559-18469-4-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 05:32 AM, Mikko Perttunen wrote:
> This enables the integrated SATA controller on the Tegra124 system-on-chip
> on the Jetson TK1 board and adds regulators for the onboard Molex connector
> commonly used to power SATA devices. The regulators are marked always-on
> since they can be used for other purposes than powering SATA devices.

> diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts

> +	sata@0,70020000 {

> +		target-supply = <&vdd_5v0_sata>;

   	regulators {

> +		/* Molex power connector */
> +		vdd_5v0_sata: regulator@13 {
> +			compatible = "regulator-fixed";
> +			reg = <13>;
> +			regulator-name = "+5V_SATA";
> +			regulator-min-microvolt = <5000000>;
> +			regulator-max-microvolt = <5000000>;
> +			gpio = <&gpio TEGRA_GPIO(EE, 2) GPIO_ACTIVE_HIGH>;
> +			enable-active-high;
> +			vin-supply = <&vdd_5v0_sys>;
> +			regulator-always-on;
> +		};

Why is this always-on, considering that the SATA node references this,
and presumably the driver explicitly enables this regulator?

> +
> +		vdd_12v0_sata: regulator@14 {
> +			compatible = "regulator-fixed";
> +			reg = <14>;
> +			regulator-name = "+12V_SATA";
> +			regulator-min-microvolt = <12000000>;
> +			regulator-max-microvolt = <12000000>;
> +			gpio = <&gpio TEGRA_GPIO(EE, 2) GPIO_ACTIVE_HIGH>;
> +			enable-active-high;
> +			vin-supply = <&vdd_mux>;
> +			regulator-always-on;
> +		};
>  	};

If there are two regulators required for the SATA devices, shouldn't the
SATA node's target-supply property reference them both? Well, I suppose
there'd need to be target-5v-supply and target-12v-supply properties,
since each regulator property can only reference a single supply, IIRC.
I think the DT binding needs to be updated for this.
