Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab3GFK0u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 06:26:50 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38000 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab3GFK0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 06:26:48 -0400
Message-ID: <51D7F0E6.2000008@kernel.org>
Date: Sat, 06 Jul 2013 11:26:46 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Shawn Guo <shawn.guo@linaro.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv3 2/3] ARM: mxs: cfa10049: Switch bus i2c1 to bitbanging
References: <1372094699-3832-1-git-send-email-alexandre.belloni@free-electrons.com> <1372094699-3832-3-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1372094699-3832-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 06:24 PM, Alexandre Belloni wrote:
> From: Maxime Ripard <maxime.ripard@free-electrons.com>
> 
> The ADCs connected to this bus have been experiencing some timeout
> issues when using the iMX28 i2c controller. Switching back to bitbanging
> solves this.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

As there are no disadvantages in taking the driver through IIO and these changes
through the appropriate arch trees, I'd not propose to take these through IIO
(even when the discussion is done) unless specifically asked to.

Jonathan
> ---
>  arch/arm/boot/dts/imx28-cfa10049.dts | 108 +++++++++++++++++++++--------------
>  1 file changed, 65 insertions(+), 43 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx28-cfa10049.dts b/arch/arm/boot/dts/imx28-cfa10049.dts
> index 05ae549..d3758c2 100644
> --- a/arch/arm/boot/dts/imx28-cfa10049.dts
> +++ b/arch/arm/boot/dts/imx28-cfa10049.dts
> @@ -139,6 +139,17 @@
>  					fsl,pull-up = <0>; /* 0 will enable the keeper */
>  				};
>  
> +				i2c1_pins_cfa10049: i2c1@0 {
> +					reg = <0>;
> +					fsl,pinmux-ids = <
> +						0x3103 /* MX28_PAD_PWM0__GPIO */
> +						0x3113 /* MX28_PAD_PWM1__I2C1_SDA */
> +					>;
> +					fsl,drive-strength = <1>;
> +					fsl,voltage = <1>;
> +					fsl,pull-up = <1>;
> +				};
> +
>  				fiq_pins_cfa10049: fiq@0 {
>  					reg = <0>;
>  					fsl,pinmux-ids = <
> @@ -199,49 +210,6 @@
>  				status = "okay";
>  			};
>  
> -			i2c1: i2c@8005a000 {
> -				pinctrl-names = "default";
> -				pinctrl-0 = <&i2c1_pins_a>;
> -				status = "okay";
> -			};
> -
> -			i2cmux {
> -				compatible = "i2c-mux-gpio";
> -				#address-cells = <1>;
> -				#size-cells = <0>;
> -				mux-gpios = <&gpio1 22 0 &gpio1 23 0>;
> -				i2c-parent = <&i2c1>;
> -
> -				i2c@0 {
> -					reg = <0>;
> -				};
> -
> -				i2c@1 {
> -					reg = <1>;
> -				};
> -
> -				i2c@2 {
> -					reg = <2>;
> -				};
> -
> -				i2c@3 {
> -					reg = <3>;
> -					#address-cells = <1>;
> -					#size-cells = <0>;
> -
> -					pca9555: pca9555@20 {
> -						compatible = "nxp,pca9555";
> -						interrupt-parent = <&gpio2>;
> -						interrupts = <19 0x2>;
> -						gpio-controller;
> -						#gpio-cells = <2>;
> -						interrupt-controller;
> -						#interrupt-cells = <2>;
> -						reg = <0x20>;
> -					};
> -				};
> -			};
> -
>  			usbphy1: usbphy@8007e000 {
>  				status = "okay";
>  			};
> @@ -366,6 +334,60 @@
>  		rotary-encoder,relative-axis;
>  	};
>  
> +	i2c1gpio: i2c@0 {
> +		compatible = "i2c-gpio";
> +		pinctrl-0 = <&i2c1_pins_cfa10049>;
> +		pinctrl-names = "default";
> +		gpios = <
> +			&gpio3 17 0 /* sda */
> +			&gpio3 16 0 /* scl */
> +			 >;
> +		i2c-gpio,delay-us = <2>;	/* ~100 kHz */
> +	};
> +
> +	i2cmux {
> +		compatible = "i2c-mux-gpio";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		mux-gpios = <&gpio1 22 0 &gpio1 23 0>;
> +		i2c-parent = <&i2c1gpio>;
> +
> +		i2c@0 {
> +			reg = <0>;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		i2c@1 {
> +			reg = <1>;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		i2c@2 {
> +			reg = <2>;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		i2c@3 {
> +			reg = <3>;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			pca9555: pca9555@20 {
> +				compatible = "nxp,pca9555";
> +				interrupt-parent = <&gpio2>;
> +				interrupts = <19 0x2>;
> +				gpio-controller;
> +				#gpio-cells = <2>;
> +				interrupt-controller;
> +				#interrupt-cells = <2>;
> +				reg = <0x20>;
> +			};
> +		};
> +	};
> +
>  	backlight {
>  		compatible = "pwm-backlight";
>  		pwms = <&pwm 3 5000000>;
> 
