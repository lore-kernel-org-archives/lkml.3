Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaKLPuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:50:11 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:51877 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaKLPuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:50:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Nov 2014 16:51:16 +0100
From: Stefan Agner <stefan@agner.ch>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: kernel@pengutronix.de, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: dts: vf-colibri: add USB regulators
In-Reply-To: <20141111141228.GB2704@dragon>
References: <1415106430-6271-1-git-send-email-stefan@agner.ch>
 <1415106430-6271-4-git-send-email-stefan@agner.ch>
 <20141111141228.GB2704@dragon>
Message-ID: <0bb62bdfc866f75977d01070d228ed4c@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Nov 12 16:50:02 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 546381aa12819513571417
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-11 15:12, Shawn Guo wrote:
> On Tue, Nov 04, 2014 at 02:07:10PM +0100, Stefan Agner wrote:
>> Add structure of USB supply logic. Especially, the USB hosts power
>> enable regulator is needed to control VBUS supply.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> ---
>>  arch/arm/boot/dts/vf-colibri-eval-v3.dtsi | 45 ++++++++++++++++++++++++++++++-
>>  arch/arm/boot/dts/vf-colibri.dtsi         | 12 +++++++++
>>  2 files changed, 56 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
>> index 80e8fbc..eb4ca50 100644
>> --- a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
>> +++ b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
>> @@ -11,6 +11,41 @@
>>  	chosen {
>>  		bootargs = "console=ttyLP0,115200";
>>  	};
>> +
>> +	regulators {
>> +		compatible = "simple-bus";
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +
>> +		sys_5v0_reg: regulator@1 {
>> +			compatible = "regulator-fixed";
>> +			reg = <1>;
> 
> The numbering generally starts from 0 instead of 1.
> 
>> +			regulator-name = "5v0";
>> +			regulator-min-microvolt = <5000000>;
>> +			regulator-max-microvolt = <5000000>;
>> +			regulator-always-on;
>> +		};
>> +
>> +		usbc_vbus_reg: regulator@2 {
>> +			compatible = "regulator-fixed";
>> +			reg = <2>;
>> +			regulator-name = "usbc_vbus";
>> +			regulator-min-microvolt = <5000000>;
>> +			regulator-max-microvolt = <5000000>;
>> +			vin-supply = <&sys_5v0_reg>;
>> +		};
>> +
>> +		/* USBH_PEN */
>> +		usbh_vbus_reg: regulator@3 {
>> +			compatible = "regulator-fixed";
>> +			reg = <3>;
>> +			regulator-name = "usbh_vbus";
>> +			regulator-min-microvolt = <5000000>;
>> +			regulator-max-microvolt = <5000000>;
>> +			gpio = <&gpio3 19 GPIO_ACTIVE_LOW>;
>> +			vin-supply = <&sys_5v0_reg>;
>> +		};
>> +	};
>>  };
>>
>>  &bl {
>> @@ -51,4 +86,12 @@
>>
>>  &uart2 {
>>  	status = "okay";
>> -};
>> \ No newline at end of file
>> +};
>> +
>> +&usbdev0 {
>> +	vbus-supply = <&usbc_vbus_reg>;
>> +};
>> +
>> +&usbh1 {
>> +	vbus-supply = <&usbh_vbus_reg>;
>> +};
>> diff --git a/arch/arm/boot/dts/vf-colibri.dtsi b/arch/arm/boot/dts/vf-colibri.dtsi
>> index 2371760..79ccfe2 100644
>> --- a/arch/arm/boot/dts/vf-colibri.dtsi
>> +++ b/arch/arm/boot/dts/vf-colibri.dtsi
>> @@ -163,5 +163,17 @@
>>  				VF610_PAD_PTD3__UART2_CTS		0x21a1
>>  			>;
>>  		};
>> +
>> +		pinctrl_usbh1_ext: gpio_usb_vbus {
>> +			fsl,pins = <
>> +				VF610_PAD_PTD4__GPIO_83			0x22ed
> 
> We used to know the GPIO usage by looking for the phandle reference to
> the node.  But it doesn't work for VF610 case now.
> 
> I guess this is for usbh_vbus_reg usage?  It would be nice to have a
> comment telling the usage of the GPIO.

Yeah its true, its assign is not required for Vybird. However, we could
assign them anyway, it would even enforce correct pin setup from
Startup... This would then make a comment superfluous. What do you
think?


> 
>> +			>;
>> +		};
>> +
>> +		pinctrl_usbdev0_ext: gpio_usb_cdet {
>> +			fsl,pins = <
>> +				VF610_PAD_PTC29__GPIO_102		0x22ed
> 
> How is this one used?

This is not yet used. It is more or less the OTG-ID pin, but on 3.3V
level. We use that on the Colibri standard to switch between Host/Device
mode, however a driver which uses that GPIO is still outstanding. I can
also leave that away for now, if you prefer....

--
Stefan

> 
> Shawn
> 
>> +			>;
>> +		};
>>  	};
>>  };
>> --
>> 2.1.3
>>

