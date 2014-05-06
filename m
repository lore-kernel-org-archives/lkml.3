Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934442AbaEFIXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:23:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41297 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934235AbaEFIXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:23:00 -0400
Message-ID: <53689BDF.5030208@ti.com>
Date: Tue, 6 May 2014 13:52:55 +0530
From: sourav <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sourav Poddar <sourav.poddar@ti.com>, <tony@atomide.com>
CC: <bcousson@baylibre.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: [Resend/PATCH] arm: dts: am43x-epos: Add qspi device.
References: <1398692550-31758-1-git-send-email-sourav.poddar@ti.com>
In-Reply-To: <1398692550-31758-1-git-send-email-sourav.poddar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Monday 28 April 2014 07:12 PM, Sourav Poddar wrote:
> This patch adds qspi nodes for am43xx SOC devices.
>
> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>

This patch has been posted many times before.
If this patch looks OK, can it be picked?
> ---
> Note,
> checpatch gives 1 warning on flash compatible string
> "mx66l51235l". This flash is supported in m25p80 driver and
> the driver is used for other flash devices also. Hence, each
> flash compatible is not described in[1], but a genric example
> is shown using spansion flash device.
> [1]:
> Documentation/devicetree/bindings/mtd/m25p80.txt
>
>   arch/arm/boot/dts/am4372.dtsi        |   11 ++++++
>   arch/arm/boot/dts/am43x-epos-evm.dts |   63 ++++++++++++++++++++++++++++++++++
>   2 files changed, 74 insertions(+)
>
> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
> index 36d523a..49633ff 100644
> --- a/arch/arm/boot/dts/am4372.dtsi
> +++ b/arch/arm/boot/dts/am4372.dtsi
> @@ -735,6 +735,17 @@
>   			#size-cells =<1>;
>   			status = "disabled";
>   		};
> +
> +		qspi: qspi@47900000 {
> +			compatible = "ti,am4372-qspi";
> +			reg =<0x47900000 0x100>;
> +			#address-cells =<1>;
> +			#size-cells =<0>;
> +			ti,hwmods = "qspi";
> +			interrupts =<0 138 0x4>;
> +			num-cs =<4>;
> +			status = "disabled";
> +		};
>   	};
>   };
>
> diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
> index 167dbc8..25cd07c 100644
> --- a/arch/arm/boot/dts/am43x-epos-evm.dts
> +++ b/arch/arm/boot/dts/am43x-epos-evm.dts
> @@ -138,6 +138,17 @@
>   				0x160 (PIN_INPUT | MUX_MODE7) /* spi0_cs1.gpio0_6 */
>   			>;
>   		};
> +
> +		qspi1_default: qspi1_default {
> +			pinctrl-single,pins =<
> +				0x7c (PIN_INPUT_PULLUP | MUX_MODE3)
> +				0x88 (PIN_INPUT_PULLUP | MUX_MODE2)
> +				0x90 (PIN_INPUT_PULLUP | MUX_MODE3)
> +				0x94 (PIN_INPUT_PULLUP | MUX_MODE3)
> +				0x98 (PIN_INPUT_PULLUP | MUX_MODE3)
> +				0x9c (PIN_INPUT_PULLUP | MUX_MODE3)
> +			>;
> +		};
>   	};
>
>   	matrix_keypad: matrix_keypad@0 {
> @@ -367,3 +378,55 @@
>   	pinctrl-0 =<&spi1_pins>;
>   	status = "okay";
>   };
> +
> +&qspi {
> +	status = "okay";
> +	pinctrl-names = "default";
> +	pinctrl-0 =<&qspi1_default>;
> +
> +	spi-max-frequency =<48000000>;
> +	m25p80@0 {
> +		compatible = "mx66l51235l";
> +		spi-max-frequency =<48000000>;
> +		reg =<0>;
> +		spi-cpol;
> +		spi-cpha;
> +		spi-tx-bus-width =<1>;
> +		spi-rx-bus-width =<4>;
> +		#address-cells =<1>;
> +		#size-cells =<1>;
> +
> +		/* MTD partition table.
> +		 * The ROM checks the first 512KiB
> +		 * for a valid file to boot(XIP).
> +		 */
> +		partition@0 {
> +			label = "QSPI.U_BOOT";
> +			reg =<0x00000000 0x000080000>;
> +		};
> +		partition@1 {
> +			label = "QSPI.U_BOOT.backup";
> +			reg =<0x00080000 0x00080000>;
> +		};
> +		partition@2 {
> +			label = "QSPI.U-BOOT-SPL_OS";
> +			reg =<0x00100000 0x00010000>;
> +		};
> +		partition@3 {
> +			label = "QSPI.U_BOOT_ENV";
> +			reg =<0x00110000 0x00010000>;
> +		};
> +		partition@4 {
> +			label = "QSPI.U-BOOT-ENV.backup";
> +			reg =<0x00120000 0x00010000>;
> +		};
> +		partition@5 {
> +			label = "QSPI.KERNEL";
> +			reg =<0x00130000 0x0800000>;
> +		};
> +		partition@6 {
> +			label = "QSPI.FILESYSTEM";
> +			reg =<0x00930000 0x36D0000>;
> +		};
> +	};
> +};

