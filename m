Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbaE2QTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:19:44 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46449 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611AbaE2QTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:19:42 -0400
Message-ID: <53875E17.6010406@linaro.org>
Date: Thu, 29 May 2014 17:19:35 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: devicetree: bindings: Add Qualcomm RPM DT binding
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com> <1401211721-19712-2-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1401211721-19712-2-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On 27/05/14 18:28, Bjorn Andersson wrote:
> Add binding for the Qualcomm Resource Power Manager (RPM) found in 8660, 8960
> and 8064 based devices. The binding currently describes the rpm itself and the
> regulator subnodes.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>   Documentation/devicetree/bindings/mfd/qcom,rpm.txt | 284 +++++++++++++++++++++
>   include/dt-bindings/mfd/qcom_rpm.h                 | 142 +++++++++++
>   2 files changed, 426 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/mfd/qcom,rpm.txt
>   create mode 100644 include/dt-bindings/mfd/qcom_rpm.h
>
> diff --git a/Documentation/devicetree/bindings/mfd/qcom,rpm.txt b/Documentation/devicetree/bindings/mfd/qcom,rpm.txt
> new file mode 100644
> index 0000000..3908a5d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/qcom,rpm.txt
> @@ -0,0 +1,284 @@
> +Qualcomm Resource Power Manager (RPM)
> +
> +This driver is used to interface with the Resource Power Manager (RPM) found in
> +various Qualcomm platforms. The RPM allows each component in the system to vote
> +for state of the system resources, such as clocks, regulators and bus
> +frequencies.
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be one of:
> +		    "qcom,rpm-apq8064"
> +		    "qcom,rpm-msm8660"
> +		    "qcom,rpm-msm8960"
> +
> +- reg:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: two entries specifying the RPM's message ram and ipc register
> +
> +- reg-names:
> +	Usage: required
> +	Value type: <string-array>
> +	Definition: must contain the following, in order:
> +		    "msg_ram"
> +		    "ipc"

+1 for kumar's comment.

cant enforce the order here. should fix it in the driver.

> +
> +- interrupts:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: three entries specifying the RPM's:
> +		    1. acknowledgement interrupt
> +		    2. error interrupt
> +		    3. wakeup interrupt
> +
> +- interrupt-names:
> +	Usage: required
> +	Value type: <string-array>
> +	Definition: must be the three strings "ack", "err" and "wakeup", in order
> +
> +- #address-cells:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: must be 1
> +
> +- #size-cells:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: must be 0
> +
> +
> += SUBDEVICES
> +
> +The RPM exposes resources to its subnodes. The below bindings specify the set
> +of valid subnodes that can operate on these resources.

Why should these devices be on sub nodes?

Any reason not to implement it like this,

rpm: rpm@108000 {
	compatible = "qcom,rpm-msm8960";
	reg = <0x108000 0x1000 0x2011008 0x4>;

	interrupts = <0 19 0>, <0 21 0>, <0 22 0>;
	interrupt-names = "ack", "err", "wakeup";
};

pm8921_s1: pm8921-s1 {
	compatible = "qcom,rpm-pm8921-smps";
	
	regulator-min-microvolt = <1225000>;
	regulator-max-microvolt = <1225000>;
	regulator-always-on;

	qcom,rpm = <&rpm QCOM_RPM_PM8921_S1>;
	qcom,switch-mode-frequency = <3200000>;
	qcom,hpm-threshold = <100000>;
};

This would simplify the driver code too and handle the interface neatly 
then depending on device hierarchy.
rpm would be a interface library to the clients. Makes the drivers more 
independent, and re-usable if we do this way.

??


> +
> +== Switch-mode Power Supply regulator
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be one of:
> +		    "qcom,rpm-pm8058-smps"
> +		    "qcom,rpm-pm8901-ftsmps"
> +		    "qcom,rpm-pm8921-smps"
> +		    "qcom,rpm-pm8921-ftsmps"
> +
> +- reg:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: resource as defined in <dt-bindings/mfd/qcom_rpm.h>
> +
> +- qcom,switch-mode-frequency:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: Frequency (Hz) of the switch-mode power supply;
> +		    must be one of:
> +		    19200000, 9600000, 6400000, 4800000, 3840000, 3200000,
> +		    2740000, 2400000, 2130000, 1920000, 1750000, 1600000,
> +		    1480000, 1370000, 1280000, 1200000
> +
> +- qcom,hpm-threshold:
> +	Usage: optional
> +	Value type: <u32>
> +	Definition: indicates the breaking point at which the regulator should
> +	            switch to high power mode
> +
> +- qcom,load-bias:
> +	Usage: optional
> +	Value type: <u32>
> +	Definition: specifies a base load on the specific regulator
> +
> +- qcom,boot-load:
> +	Usage: optional
> +	Value type: <u32>
> +	Definition: specifies the configured load on boot for the specific
> +	            regulator
> +

[...
> +- qcom,force-mode-none:
> +	Usage: optional (default if no other qcom,force-mode is specified)
> +	Value type: <empty>
> +	Defintion: indicates that the regulator should not be forced to any
> +	           particular mode
> +
> +- qcom,force-mode-lpm:
> +	Usage: optional
> +	Value type: <empty>
> +	Definition: indicates that the regulator should be forced to operate in
> +	            low-power-mode
> +
> +- qcom,force-mode-auto:
> +	Usage: optional (only available for 8960/8064)
> +	Value type: <empty>
> +	Definition: indicates that the regulator should be automatically pick
> +	            operating mode
> +
> +- qcom,force-mode-hpm:
> +	Usage: optional (only available for 8960/8064)
> +	Value type: <empty>
> +	Definition: indicates that the regulator should be forced to operate in
> +	            high-power-mode
> +
> +- qcom,force-mode-bypass: (only for 8960/8064)
> +	Usage: optional (only available for 8960/8064)
> +	Value type: <empty>
> +	Definition: indicates that the regulator should be forced to operate in
> +	            bypass mode
> +
...]

Probably qcom,force-mode:
	Usage: optional.
	Value type: <string>
	Definition: must be one of:
	"none"
	"lpm"
	"auto"
	"hpm"
	"bypass"

Makes it much simpler, as they seems to be mutually exclusive. simillar 
comments apply to other bindings too.


[...
> +- qcom,power-mode-hysteretic:
> +	Usage: optional
> +	Value type: <empty>
> +	Definition: indicates that the power supply should operate in hysteretic
> +		    mode (defaults to qcom,power-mode-pwm if not specified)
> +
> +- qcom,power-mode-pwm:
> +	Usage: optional
> +	Value type: <empty>
> +	Definition: indicates that the power supply should operate in pwm mode
> +
...]

Probably qcom,power-mode:
	Usage: optional.
	Value type: <string>
	Definition: must be one of:
	"pwm"
	"hysteretic"


Makes it much simpler, as they seems to be mutually exclusive. simillar 
comments apply to other bindings too.




Thanks,
srini
> +Standard regulator bindings are used inside switch mode power supply subnodes.
> +Check Documentation/devicetree/bindings/regulator/regulator.txt for more
> +details.
> +
> +== Low-dropout regulator
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be one of:
> +		    "qcom,rpm-pm8058-pldo"
> +		    "qcom,rpm-pm8058-nldo"
> +		    "qcom,rpm-pm8901-pldo"
> +		    "qcom,rpm-pm8901-nldo"
> +		    "qcom,rpm-pm8921-pldo"
> +		    "qcom,rpm-pm8921-nldo"
> +		    "qcom,rpm-pm8921-nldo1200"
> +
> +- reg:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: resource as defined in <dt-bindings/mfd/qcom_rpm.h>
> +
> +- qcom,hpm-threshold:
> +	Usage: optional
> +	Value type: <u32>
> +	Definition: indicates the breaking point at which the regulator should
> +	            switch to high power mode
> +
> +- qcom,load-bias:
> +	Usage: optional
> +	Value type: <u32>
> +	Definition: specifies a base load on the specific regulator
> +
> +- qcom,boot-load:
> +	Usage: optional
> +	Value type: <u32>
> +	Definition: specifies the configured load on boot for the specific
> +	            regulator
> +
> +- qcom,force-mode-none:
> +	Usage: optional (default if no other qcom,force-mode is specified)
> +	Value type: <empty>
> +	Defintion: indicates that the regulator should not be forced to any
> +	           particular mode
> +
> +- qcom,force-mode-lpm:
> +	Usage: optional
> +	Value type: <empty>
> +	Definition: indicates that the regulator should be forced to operate in
> +	            low-power-mode
> +
> +- qcom,force-mode-auto:
> +	Usage: optional (only available for 8960/8064)
> +	Value type: <empty>
> +	Definition: indicates that the regulator should be automatically pick
> +	            operating mode
> +
> +- qcom,force-mode-hpm:
> +	Usage: optional (only available for 8960/8064)
> +	Value type: <empty>
> +	Definition: indicates that the regulator should be forced to operate in
> +	            high-power-mode
> +
> +- qcom,force-mode-bypass: (only for 8960/8064)
> +	Usage: optional (only available for 8960/8064)
> +	Value type: <empty>
> +	Definition: indicates that the regulator should be forced to operate in
> +	            bypass mode
> +
> +Standard regulator bindings are used inside switch low-dropout regulator
> +subnodes.  Check Documentation/devicetree/bindings/regulator/regulator.txt for
> +more details.
> +
> +== Negative Charge Pump
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be one of:
> +		    "qcom,rpm-pm8058-ncp"
> +		    "qcom,rpm-pm8921-ncp"
> +		    "qcom,rpm-pm8921-nldo1200"
> +
> +- reg:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: resource as defined in <dt-bindings/mfd/qcom_rpm.h>
> +
> +- qcom,switch-mode-frequency:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: Frequency (Hz) of the swith mode power supply;
> +		    must be one of:
> +		    19200000, 9600000, 6400000, 4800000, 3840000, 3200000,
> +		    2740000, 2400000, 2130000, 1920000, 1750000, 1600000,
> +		    1480000, 1370000, 1280000, 1200000
> +
> +Standard regulator bindings are used inside negative charge pump regulator
> +subnodes.  Check Documentation/devicetree/bindings/regulator/regulator.txt for
> +more details.
> +
> +== Switch
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be one of:
> +		    "qcom,rpm-pm8058-switch"
> +		    "qcom,rpm-pm8901-switch"
> +		    "qcom,rpm-pm8921-switch"
> +
> +- reg:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: resource as defined in <dt-bindings/mfd/qcom_rpm.h>
> +
> +
> += EXAMPLE
> +
> +	#include <dt-bindings/mfd/qcom_rpm.h>
> +
> +	rpm@108000 {
> +		compatible = "qcom,rpm-msm8960";
> +		reg = <0x108000 0x1000 0x2011008 0x4>;
> +
> +		interrupts = <0 19 0>, <0 21 0>, <0 22 0>;
> +		interrupt-names = "ack", "err", "wakeup";
> +
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		pm8921_s1: pm8921-s1 {
> +			compatible = "qcom,rpm-pm8921-smps";
> +			reg = <QCOM_RPM_PM8921_S1>;
> +
> +			regulator-min-microvolt = <1225000>;
> +			regulator-max-microvolt = <1225000>;
> +			regulator-always-on;
> +
> +			qcom,switch-mode-frequency = <3200000>;
> +			qcom,hpm-threshold = <100000>;
> +		};
> +	};

...
