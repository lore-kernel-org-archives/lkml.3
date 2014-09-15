Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaIOQC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:02:27 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:50719 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbaIOQCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:02:25 -0400
Message-ID: <54170DA6.6050001@mm-sol.com>
Date: Mon, 15 Sep 2014 19:02:46 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
CC: Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH RESEND] thermal: Add QPNP PMIC temperature alarm driver
References: <1410793383-30097-1-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1410793383-30097-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/15/2014 06:03 PM, Ivan T. Ivanov wrote:
> Add support for the temperature alarm peripheral found inside
> Qualcomm plug-and-play (QPNP) PMIC chips.  The temperature alarm
> peripheral outputs a pulse on an interrupt line whenever the
> thermal over temperature stage value changes.  Implement an ISR
> to manage this interrupt.
> 
> Register a thermal zone device in sysfs with mulitple trip points

s/mulitple/multiple/

> corresponding to the physical threshold temperatures between over
> temperature stages.  The temperature reported by this thermal
> zone device should reflect the actual PMIC die temperature if an
> ADC is present on the given PMIC.  If no ADC is present, then the
> reported temperature should be estimated from the over
> temperature stage value.
> 
> Send a notification to userspace via sysfs_notify() whenever the
> over temperature stage value changes.
> 
> Cc: David Collins <collinsd@codeaurora.org>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  .../bindings/thermal/qpnp-temp-alarm.txt           |  27 ++
>  drivers/thermal/Kconfig                            |  12 +
>  drivers/thermal/Makefile                           |   1 +
>  drivers/thermal/qpnp-temp-alarm.c                  | 519 +++++++++++++++++++++
>  4 files changed, 559 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/thermal/qpnp-temp-alarm.txt
>  create mode 100644 drivers/thermal/qpnp-temp-alarm.c
> 
> diff --git a/Documentation/devicetree/bindings/thermal/qpnp-temp-alarm.txt b/Documentation/devicetree/bindings/thermal/qpnp-temp-alarm.txt
> new file mode 100644
> index 0000000..7eecb74
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/qpnp-temp-alarm.txt
> @@ -0,0 +1,27 @@
> +Qualcomm QPNP PMIC Temperature Alarm
> +
> +QPNP temperature alarm peripherals are found inside of Qualcomm PMIC chips
> +that utilize the Qualcomm SPMI implementation. These peripherals provide an
> +interrupt signal and status register to identify high PMIC die temperature.
> +
> +Required properties:
> +- compatible:      Should contain "qcom,qpnp-temp-alarm".
> +- reg:             Specifies the SPMI address temperature alarm device.

SPMI address _of_ the temperature alarm device?

> +- interrupts:      PMIC temperature alarm interrupt
> +
> +Optional properties:
> +- label:           A string used as a descriptive name for this thermal
> +                   device. This name should be 19 characters or less.
> +- io-channels:     Should contain IIO channel specifier
> +- io-channel-names: "thermal". The ADC channel for temperature reading.

Maybe can be rephrased better such as:
- io-channel-names: should contain "thermal" for the temperature reading ADC channel

> +
> +Example:
> +
> +	thermal-alarm@2400 {
> +		compatible = "qcom,qpnp-temp-alarm";
> +		reg = <0x2400>;
> +		interrupts = <0 0x24 0 IRQ_TYPE_EDGE_RISING>;
> +		label = "pm8941_tz";
> +		io-channels = <&pm8941_vadc VADC_DIE_TEMP>;
> +		io-channel-names = "thermal";
> +	};

Maybe describe the trip points in the DT?

> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index 693208e..7371cf9 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -248,4 +248,16 @@ depends on ARCH_STI && OF
>  source "drivers/thermal/st/Kconfig"
>  endmenu
>  
> +config QPNP_TEMP_ALARM
> +	tristate "Qualcomm QPNP Temperature Alarm"
> +	depends on OF && REGMAP_SPMI

Seems to depend on IIO too.

> +	help
> +	  This enables a thermal sysfs driver for Qualcomm plug-and-play (QPNP)
> +	  PMIC devices. It shows up in sysfs as a thermal zone with multiple
> +	  trip points. The temperature reported by the thermal zone reflects the
> +	  real time die temperature if an ADC is present or an estimate of the
> +	  temperature based upon the over temperature stage value. Enabling the
> +	  thermal zone device via the mode file results in shifting PMIC over
> +	  temperature shutdown control from hardware to software.
> +
[..]

BR,
Georgi
