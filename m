Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaDWNU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:20:29 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:59591 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbaDWNUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:20:24 -0400
Message-ID: <1398259168.4724.217.camel@iivanov-dev>
Subject: Re: [PATCH 1/2] mfd: pm8x41: add support for Qualcomm 8x41 PMICs
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Wed, 23 Apr 2014 16:19:28 +0300
In-Reply-To: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
References: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tue, 2014-04-22 at 17:31 -0700, Courtney Cavin wrote:
> From: Josh Cartwright <joshc@codeaurora.org>
> 
> The Qualcomm 8941 and 8841 PMICs are components used with the Snapdragon
> 800 series SoC family.  This driver exists largely as a glue mfd component,
> it exists to be an owner of an SPMI regmap for children devices
> described in device tree.
> 

Thanks. This is exactly what I have planed to do :-)

> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
> ---
>  drivers/mfd/Kconfig  | 13 +++++++++++
>  drivers/mfd/Makefile |  1 +
>  drivers/mfd/pm8x41.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 77 insertions(+)
>  create mode 100644 drivers/mfd/pm8x41.c
> 

<snip>

> +
> +static int pm8x41_probe(struct spmi_device *sdev)
> +{
> +	struct regmap *regmap;
> +
> +	regmap = devm_regmap_init_spmi_ext(sdev, &pm8x41_regmap_config);
> +	if (IS_ERR(regmap)) {
> +		dev_dbg(&sdev->dev, "regmap creation failed.\n");
> +		return PTR_ERR(regmap);
> +	}
> +
> +	return of_platform_populate(sdev->dev.of_node, NULL, NULL, &sdev->dev);

I think that this will not going to work. For example in this particular
case, both controllers have "qcom,qpnp-revid" peripheral which is
located at offset 0x100.

And the result is:

[    0.963944] sysfs: cannot create duplicate filename '/bus/platform/devices/100.revid'

DT looks like this:

spmi {
	compatible = "qcom,spmi-pmic-arb";
	reg-names = "core", "intr", "cnfg";
	reg = <0xfc4cf000 0x1000>,
	      <0xfc4cb000 0x1000>,
	      <0xfc4ca000 0x1000>;

	interrupt-names = "periph_irq";
	interrupts = <0 190 0>;

	qcom,ee = <0>;
	qcom,channel = <0>;

	#address-cells = <2>;
	#size-cells = <0>;

	interrupt-controller;
	#interrupt-cells = <4>;

	pm8941@0 {
		compatible = "qcom,pm8941";
		reg = <0x0 SPMI_USID>;

		#address-cells = <1>;
		#size-cells = <0>;

		revid@100 {
			compatible = "qcom,qpnp-revid";
			reg = <0x100 0x100>;
		};
	};

	pm8841@4 {
		compatible = "qcom,pm8941";
		reg = <0x4 SPMI_USID>;

		#address-cells = <1>;
		#size-cells = <0>;

		revid@100 {
			compatible = "qcom,qpnp-revid";
			reg = <0x100 0x100>;
		};
	};
};

Any suggestions?

Thanks, 
Ivan

