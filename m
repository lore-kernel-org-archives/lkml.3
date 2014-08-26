Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbaHZJmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:42:13 -0400
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:53546 "EHLO
	smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753887AbaHZJmL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:42:11 -0400
Date: Tue, 26 Aug 2014 05:42:09 -0400 (EDT)
Subject: Re: [PATCH v2] ARM: apq8064: Add pinmux and i2c pinctrl nodes
From: kiran.padwal@smartplayin.com
To: "=?utf-8?Q?Andreas_F=C3=A4rber?=" <afaerber@suse.de>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        davidb@codeaurora.org, devicetree@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <53F4C085.5060101@suse.de>
References: <1408536133-13824-1-git-send-email-kiran.padwal@smartplayin.com> 
 <53F4C085.5060101@suse.de>
Message-ID: <1409046129.71143501@apps.rackspace.com>
X-Mailer: webmail7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wednesday, August 20, 2014 11:36am, "Andreas Färber" <afaerber@suse.de> said:

> Hi,
> 
> Am 20.08.2014 14:02, schrieb Kiran Padwal:
>> This patch adds pinmux and i2c pinctrl DT node for IFC6410 board.
>> It also adds necessary DT support for i2c eeprom which is present on
>> IFC6410.
>>
>> Tested on IFC6410 board.
>>
>> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
>> ---
>> Chages since v1:
>> 	- Renamed pinmux phandle "qcom_pinmux" to "tlmm_pinmux".
>> 	- Updated pinmux interrupt.
>>
>>  arch/arm/boot/dts/qcom-apq8064-ifc6410.dts |   29 ++++++++++++++
>>  arch/arm/boot/dts/qcom-apq8064.dtsi        |   59 ++++++++++++++++++++++++++++
>>  2 files changed, 88 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
>> b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
>> index 7c2441d..d52ac3c 100644
>> --- a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
>> +++ b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
>> @@ -5,6 +5,15 @@
>>  	compatible = "qcom,apq8064-ifc6410", "qcom,apq8064";
>>
>>  	soc {
>> +		pinmux@800000 {
>> +			i2c1_pins: i2c1_pinmux {
> 
> Is there a requirement to have "_pinmux" in the subnode of the "pinmux"
> node? Otherwise use just "i2c1"? I notice because the general convention
> seems to be dashes rather than underscores for node names.

Ok, I will change it to i2c1.

> 
>> +				mux {
>> +					pins = "gpio20", "gpio21";
>> +					function = "gsbi1";
>> +				};
>> +			};
>> +		};
>> +
>>  		gsbi@16600000 {
>>  			status = "ok";
>>  			qcom,mode = <GSBI_PROT_I2C_UART>;
>> @@ -12,5 +21,25 @@
>>  				status = "ok";
>>  			};
>>  		};
>> +
>> +		gsbi1: gsbi@12440000 {
>> +			qcom,mode = <GSBI_PROT_I2C>;
>> +			status = "ok";
> 
> Usually the overridden status property goes first, as seen on the
> previous gsbi node.
> 
> Further, its canonical value is "okay" (although in practice anything
> other than "disabled" should work), so suggest you adopt it for your new
> nodes.
> 
> Also, you already provide a label "gsbi1" to this node in the .dtsi
> below, so you don't need to do it here again.
> Some architectures prefer in such a case that in the .dts the node is
> referenced as &gsbi1 {...}; below the root node in alphabetical order
> rather than duplicating the full /soc/foo@bar hierarchy.

Indeed, I'll change on v3.

> 
>> +
>> +			i2c1: i2c@12460000 {
> 
> Suggest to move the i2c1 label to the .dtsi. Then optionally same could
> be done here as outlined for gsbi1.

Indeed, I'll change on v3.

> 
>> +				status = "ok";
> 
> "okay".

Ok.

> 
>> +
>> +				clock-frequency = <200000>;
>> +
>> +				pinctrl-0 = <&i2c1_pins>;
>> +				pinctrl-names = "default";
>> +
>> +				eeprom: eeprom@52 {
>> +					compatible = "atmel,24c128";
>> +					reg = <0x52>;
>> +					pagesize = <32>;
>> +				};
>> +			};
>> +		};
>>  	};
>>  };
>> diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi
>> b/arch/arm/boot/dts/qcom-apq8064.dtsi
>> index 92bf793..bb2ccde 100644
>> --- a/arch/arm/boot/dts/qcom-apq8064.dtsi
>> +++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
>> @@ -70,6 +70,17 @@
>>  		ranges;
>>  		compatible = "simple-bus";
>>
>> +		tlmm_pinmux: pinmux@800000 {
>> +			compatible = "qcom,apq8064-pinctrl";
>> +			reg = <0x800000 0x4000>;
>> +
>> +			gpio-controller;
>> +			#gpio-cells = <2>;
>> +			interrupt-controller;
>> +			#interrupt-cells = <2>;
>> +			interrupts = <0 16 0x4>;
> 
> s/0x4/IRQ_TYPE_LEVEL_HIGH/?

Indeed, I'll change on v3.

> 
>> +		};
>> +
>>  		intc: interrupt-controller@2000000 {
>>  			compatible = "qcom,msm-qgic2";
>>  			interrupt-controller;
>> @@ -133,6 +144,54 @@
>>  			regulator;
>>  		};
>>
>> +		gsbi1: gsbi@12440000 {
>> +			compatible = "qcom,gsbi-v1.0.0";
>> +			reg = <0x12440000 0x100>;
>> +			clocks = <&gcc GSBI1_H_CLK>;
>> +			clock-names = "iface";
>> +			#address-cells = <1>;
>> +			#size-cells = <1>;
>> +			ranges;
>> +			status = "disabled";
>> +
>> +			i2c@12460000 {
>> +				compatible = "qcom,i2c-qup-v1.1.1";
>> +				reg = <0x12460000 0x1000>;
>> +				interrupts = <0 194 0>;
> 
> The trailing 0 might be IRQ_TYPE_NONE?

Indeed, I'll change on v3.

> 
>> +
>> +				clocks = <&gcc GSBI1_QUP_CLK>, <&gcc GSBI1_H_CLK>;
>> +				clock-names = "core", "iface";
>> +				status = "disabled";
> 
> I'd guess this is redundant since the parent is already disabled?

Indeed, I'll change on v3.

> 
>> +
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +			};
>> +		};
>> +
>> +		gsbi2: gsbi@12480000 {
>> +			compatible = "qcom,gsbi-v1.0.0";
>> +			reg = <0x12480000 0x100>;
>> +			clocks = <&gcc GSBI2_H_CLK>;
>> +			clock-names = "iface";
>> +			#address-cells = <1>;
>> +			#size-cells = <1>;
>> +			ranges;
>> +			status = "disabled";
>> +
>> +			i2c@124a0000 {
>> +				compatible = "qcom,i2c-qup-v1.1.1";
>> +				reg = <0x124a0000 0x1000>;
>> +				interrupts = <0 196 0>;
> 
> Again, IRQ_TYPE_NONE possibly?

Indeed, I'll change on v3.
Thanks.

> 
> Cheers,
> Andreas
> 
>> +
>> +				clocks = <&gcc GSBI2_QUP_CLK>, <&gcc GSBI2_H_CLK>;
>> +				clock-names = "core", "iface";
>> +				status = "disabled";
>> +
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +			};
>> +		};
>> +
>>  		gsbi7: gsbi@16600000 {
>>  			status = "disabled";
>>  			compatible = "qcom,gsbi-v1.0.0";
> 
> --
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
> GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
> 


