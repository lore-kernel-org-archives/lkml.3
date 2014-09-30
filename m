Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaI3FLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 01:11:31 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:9031 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbaI3FL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 01:11:29 -0400
Date: Mon, 29 Sep 2014 22:11:39 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 1/4] ARM: DT: apq8064: add rpm support
Message-ID: <20140930051138.GH28481@sonymobile.com>
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1411982092-7922-1-git-send-email-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411982092-7922-1-git-send-email-srinivas.kandagatla@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 29 Sep 02:14 PDT 2014, Srinivas Kandagatla wrote:

> This patch adds rpm node to apq8064 dt as rpm would be used by other
> devices for regulator support.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
>  arch/arm/boot/dts/qcom-apq8064.dtsi | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
> index b3154c0..9c2c8e6 100644
> --- a/arch/arm/boot/dts/qcom-apq8064.dtsi
> +++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
> @@ -3,6 +3,7 @@
>  #include "skeleton.dtsi"
>  #include <dt-bindings/clock/qcom,gcc-msm8960.h>
>  #include <dt-bindings/clock/qcom,mmcc-msm8960.h>
> +#include <dt-bindings/mfd/qcom-rpm.h>
>  #include <dt-bindings/soc/qcom,gsbi.h>
>  #include <dt-bindings/interrupt-controller/arm-gic.h>
>  
> @@ -246,6 +247,24 @@
>  			#reset-cells = <1>;
>  		};
>  
> +		apcs: syscon@2011000 {
> +			compatible = "syscon";
> +			reg = <0x2011000 0x1000>;
> +		};
> +
> +		rpm@108000 {
> +			compatible	= "qcom,rpm-apq8064";
> +			reg		= <0x108000 0x1000>;
> +			qcom,ipc = <&apcs 0x8 2>;

I don't like your indentation, but please stick with one way of doing it :)

> +
> +			interrupts	= <0 19 0>, <0 21 0>, <0 22 0>;
> +			interrupt-names = "ack", "err", "wakeup";
> +
> +			#address-cells	= <1>;
> +			#size-cells	= <0>;
> +

This part looks good.

But how about adding all the regulators here as well?
Like:

                        pm8921_l5: pm8921-l5 {
				compatible = "qcom,rpm-pm8921-pldo";
				reg = <QCOM_RPM_PM8921_LDO5>;
			};

			...

That way we can update the references from this file (while still allowing the
dts to override it if needed). I'm not sure if we should add some sane defaults
or just completely deferr specifying the voltage ranges to the dts. The benefit
of the latter is that the regulators not configured by the dts author will not
be accessible.

But simply listing all the nodes here would be nice and I dont see much reason
to postpone this work.

> +		};
> +
>  		/* Temporary fixed regulator */
>  		vsdcc_fixed: vsdcc-regulator {
>  			compatible = "regulator-fixed";

Regards,
Bjorn
