Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbaGVOv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:51:27 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:59705 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbaGVOvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:51:25 -0400
Message-ID: <1406040662.28520.8.camel@iivanov-dev>
Subject: Re: [PATCH RESEND v2 1/4] pinctrl: Update Qualcomm pm8xxx GPIO
 parameters definitions
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Tue, 22 Jul 2014 17:51:02 +0300
In-Reply-To: <1405626085-14069-1-git-send-email-iivanov@mm-sol.com>
References: <1405610748-7583-5-git-send-email-iivanov@mm-sol.com>
	 <1405626085-14069-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-17 at 22:41 +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> Available 'power-source' labels differ between chips.
> Use just VIN0-VIN14 in the input source names.
> 
> PM8018, PM8038, PM8058, PM8917, PM8921 pin controller hardware
> support only one function 'gpio'. Currently GPIO's will
> support only 'normal' mode. Rest of the modes will be added
> later, if needed.
> 
> We can not use generic drive-strength because Qualcomm hardware
> define those values as low, medium and high. Use qcom,strength
> for this.
> 
> We can not use generic bias-pull-up because Qualcomm hardware
> define those values in uA's. Use qcom,pull-up for this.
> 
> Add qcom,pm8941-gpio and qcom,pma8084-gpio to chips, which
> support these DT bindings.
> 

Hi Bjorn,  

Are you ok with these changes? I plan to send next version which
adds parsing code for new "qcom,strength" and "qcom,pull-up".

Regards,
Ivan


> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  .../bindings/pinctrl/qcom,pm8xxx-gpio.txt          | 97 +++++++++++-----------
>  drivers/pinctrl/pinctrl-pm8xxx-gpio.c              | 34 ++++----
>  include/dt-bindings/pinctrl/qcom,pm8xxx-gpio.h     | 33 ++++----
>  3 files changed, 81 insertions(+), 83 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,pm8xxx-gpio.txt b/Documentation/devicetree/bindings/pinctrl/qcom,pm8xxx-gpio.txt
> index 0035dd8..f17580a 100644
> --- a/Documentation/devicetree/bindings/pinctrl/qcom,pm8xxx-gpio.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/qcom,pm8xxx-gpio.txt
> @@ -12,6 +12,8 @@ Qualcomm.
>  			"qcom,pm8058-gpio"
>  			"qcom,pm8917-gpio"
>  			"qcom,pm8921-gpio"
> +			"qcom,pm8941-gpio"
> +			"qcom,pma8084-gpio"
>  
>  - reg:
>  	Usage: required
> @@ -74,20 +76,14 @@ to specify in a pin configuration subnode:
>  			gpio1-gpio40 for pm8058
>  			gpio1-gpio38 for pm8917
>  			gpio1-gpio44 for pm8921
> +			gpio1-gpio36 for pm8941
> +			gpio1-gpio22 for pma8084
>  
>  - function:
> -	Usage: optional
> +	Usage: mandatory
>  	Value type: <string>
>  	Definition: Specify the alternative function to be configured for the
> -		    specified pins.  Valid values are:
> -			"normal",
> -			"paired",
> -			"func1",
> -			"func2",
> -			"dtest1",
> -			"dtest2",
> -			"dtest3",
> -			"dtest4"
> +		    specified pins.  Valid values is: "gpio"
>  
>  - bias-disable:
>  	Usage: optional
> @@ -99,18 +95,6 @@ to specify in a pin configuration subnode:
>  	Value type: <none>
>  	Definition: The specified pins should be configued as pull down.
>  
> -- bias-pull-up:
> -	Usage: optional
> -	Value type: <u32> (optional)
> -	Definition: The specified pins should be configued as pull up. An
> -		    optional argument can be used to configure the strength.
> -		    Valid values are; as defined in
> -		    <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
> -		    1: 30uA			(PM8XXX_GPIO_PULL_UP_30)
> -		    2: 1.5uA			(PM8XXX_GPIO_PULL_UP_1P5)
> -		    3: 31.5uA			(PM8XXX_GPIO_PULL_UP_31P5)
> -		    4: 1.5uA + 30uA boost	(PM8XXX_GPIO_PULL_UP_1P5_30)
> -
>  - bias-high-impedance:
>  	Usage: optional
>  	Value type: <none>
> @@ -139,47 +123,37 @@ to specify in a pin configuration subnode:
>  	Definition: Selects the power source for the specified pins. Valid
>  		    power sources are, as defined in
>  		    <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
> -			0: bb (PM8XXX_GPIO_VIN_BB)
> +			0: bb (PM8XXX_GPIO_VIN0)
>  				valid for pm8038, pm8058, pm8917, pm8921
> -			1: ldo2 (PM8XXX_GPIO_VIN_L2)
> +			1: ldo2 (PM8XXX_GPIO_VIN1)
>  				valid for pm8018, pm8038, pm8917,pm8921
> -			2: ldo3 (PM8XXX_GPIO_VIN_L3)
> +			2: ldo3 (PM8XXX_GPIO_VIN2)
>  				valid for pm8038, pm8058, pm8917, pm8921
> -			3: ldo4 (PM8XXX_GPIO_VIN_L4)
> +			3: ldo4 (PM8XXX_GPIO_VIN3)
>  				valid for pm8018, pm8917, pm8921
> -			4: ldo5 (PM8XXX_GPIO_VIN_L5)
> +			4: ldo5 (PM8XXX_GPIO_VIN4)
>  				valid for pm8018, pm8058
> -			5: ldo6 (PM8XXX_GPIO_VIN_L6)
> +			5: ldo6 (PM8XXX_GPIO_VIN5)
>  				valid for pm8018, pm8058
> -			6: ldo7 (PM8XXX_GPIO_VIN_L7)
> +			6: ldo7 (PM8XXX_GPIO_VIN6)
>  				valid for pm8058
> -			7: ldo8 (PM8XXX_GPIO_VIN_L8)
> +			7: ldo8 (PM8XXX_GPIO_VIN7)
>  				valid for pm8018
> -			8: ldo11 (PM8XXX_GPIO_VIN_L11)
> +			8: ldo11 (PM8XXX_GPIO_VIN8)
>  				valid for pm8038
> -			9: ldo14 (PM8XXX_GPIO_VIN_L14)
> +			9: ldo14 (PM8XXX_GPIO_VIN9)
>  				valid for pm8018
> -			10: ldo15 (PM8XXX_GPIO_VIN_L15)
> +			10: ldo15 (PM8XXX_GPIO_VIN10)
>  				valid for pm8038, pm8917, pm8921
> -			11: ldo17 (PM8XXX_GPIO_VIN_L17)
> +			11: ldo17 (PM8XXX_GPIO_VIN11)
>  				valid for pm8038, pm8917, pm8921
> -			12: smps3 (PM8XXX_GPIO_VIN_S3)
> +			12: smps3 (PM8XXX_GPIO_VIN12)
>  				valid for pm8018, pm8058
> -			13: smps4 (PM8XXX_GPIO_VIN_S4)
> +			13: smps4 (PM8XXX_GPIO_VIN13)
>  				valid for pm8921
> -			14: vph (PM8XXX_GPIO_VIN_VPH)
> +			14: vph (PM8XXX_GPIO_VIN14)
>  				valid for pm8018, pm8038, pm8058, pm8917 pm8921
>  
> -- drive-strength:
> -	Usage: optional
> -	Value type: <u32>
> -	Definition: Selects the drive strength for the specified pins. Value
> -		    drive strengths are:
> -			0: no	(PM8XXX_GPIO_STRENGTH_NO)
> -			1: high	(PM8XXX_GPIO_STRENGTH_HIGH)
> -			2: medium	(PM8XXX_GPIO_STRENGTH_MED)
> -			3: low	(PM8XXX_GPIO_STRENGTH_LOW)
> -
>  - drive-push-pull:
>  	Usage: optional
>  	Value type: <none>
> @@ -190,6 +164,28 @@ to specify in a pin configuration subnode:
>  	Value type: <none>
>  	Definition: The specified pins are configured in open-drain mode.
>  
> +- qcom,pull-up:
> +	Usage: optional
> +	Value type: <u32>
> +	Definition: The specified pins should be configued as pull up. An
> +		    optional argument can be used to configure the strength.
> +		    Valid values are as defined in
> +		    <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
> +		    1: 30uA			(PM8XXX_GPIO_PULL_UP_30)
> +		    2: 1.5uA			(PM8XXX_GPIO_PULL_UP_1P5)
> +		    3: 31.5uA			(PM8XXX_GPIO_PULL_UP_31P5)
> +		    4: 1.5uA + 30uA boost	(PM8XXX_GPIO_PULL_UP_1P5_30)
> +
> +- qcom,strength:
> +	Usage: optional
> +	Value type: <u32>
> +	Definition: Selects the drive strength for the specified pins.
> +		    Valid values are as defined in
> +		    <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
> +			0: no	(PM8XXX_GPIO_STRENGTH_NO)
> +			1: high	(PM8XXX_GPIO_STRENGTH_HIGH)
> +			2: medium	(PM8XXX_GPIO_STRENGTH_MED)
> +			3: low	(PM8XXX_GPIO_STRENGTH_LOW)
>  
>  Example:
>  
> @@ -218,13 +214,14 @@ Example:
>  		pm8921_gpio_keys: gpio-keys {
>  			volume-keys {
>  				pins = "gpio20", "gpio21";
> -				function = "normal";
> +				function = "gpio";
>  
>  				input-enable;
>  				bias-pull-up;
>  				drive-push-pull;
> -				drive-strength = <PM8XXX_GPIO_STRENGTH_NO>;
> -				power-source = <PM8XXX_GPIO_VIN_S4>;
> +
> +				power-source = <PM8XXX_GPIO_VIN13>;
> +				qcom,strength = <PM8XXX_GPIO_STRENGTH_NO>;
>  			};
>  		};
>  	};
> diff --git a/drivers/pinctrl/pinctrl-pm8xxx-gpio.c b/drivers/pinctrl/pinctrl-pm8xxx-gpio.c
> index 5aaf914..68feb2f 100644
> --- a/drivers/pinctrl/pinctrl-pm8xxx-gpio.c
> +++ b/drivers/pinctrl/pinctrl-pm8xxx-gpio.c
> @@ -95,9 +95,7 @@ static const char * const pm8xxx_gpio_groups[PM8XXX_MAX_GPIOS] = {
>  };
>  
>  static const char * const pm8xxx_gpio_functions[] = {
> -	"normal", "paired",
> -	"func1", "func2",
> -	"dtest1", "dtest2", "dtest3", "dtest4",
> +	"gpio",
>  };
>  
>  static int pm8xxx_gpio_read(struct pm8xxx_gpio *pctrl, int pin, int bank)
> @@ -622,9 +620,9 @@ static int pm8xxx_gpio_populate(struct pm8xxx_gpio *pctrl)
>  static const struct pm8xxx_gpio_data pm8018_gpio_data = {
>  	.ngpio = 6,
>  	.power_sources = (int[]) {
> -		PM8XXX_GPIO_VIN_L4, PM8XXX_GPIO_VIN_L14, PM8XXX_GPIO_VIN_S3,
> -		PM8XXX_GPIO_VIN_L6, PM8XXX_GPIO_VIN_L2, PM8XXX_GPIO_VIN_L5,
> -		PM8XXX_GPIO_VIN_L8, PM8XXX_GPIO_VIN_VPH
> +		PM8XXX_GPIO_VIN3, PM8XXX_GPIO_VIN9, PM8XXX_GPIO_VIN12,
> +		PM8XXX_GPIO_VIN5, PM8XXX_GPIO_VIN1, PM8XXX_GPIO_VIN4,
> +		PM8XXX_GPIO_VIN7, PM8XXX_GPIO_VIN14
>  	},
>  	.npower_sources = 8,
>  };
> @@ -632,9 +630,9 @@ static const struct pm8xxx_gpio_data pm8018_gpio_data = {
>  static const struct pm8xxx_gpio_data pm8038_gpio_data = {
>  	.ngpio = 12,
>  	.power_sources = (int[]) {
> -		PM8XXX_GPIO_VIN_VPH, PM8XXX_GPIO_VIN_BB, PM8XXX_GPIO_VIN_L11,
> -		PM8XXX_GPIO_VIN_L15, PM8XXX_GPIO_VIN_L4, PM8XXX_GPIO_VIN_L3,
> -		PM8XXX_GPIO_VIN_L17
> +		PM8XXX_GPIO_VIN14, PM8XXX_GPIO_VIN0, PM8XXX_GPIO_VIN8,
> +		PM8XXX_GPIO_VIN10, PM8XXX_GPIO_VIN3, PM8XXX_GPIO_VIN2,
> +		PM8XXX_GPIO_VIN11
>  	},
>  	.npower_sources = 7,
>  };
> @@ -642,18 +640,18 @@ static const struct pm8xxx_gpio_data pm8038_gpio_data = {
>  static const struct pm8xxx_gpio_data pm8058_gpio_data = {
>  	.ngpio = 40,
>  	.power_sources = (int[]) {
> -		PM8XXX_GPIO_VIN_VPH, PM8XXX_GPIO_VIN_BB, PM8XXX_GPIO_VIN_S3,
> -		PM8XXX_GPIO_VIN_L3, PM8XXX_GPIO_VIN_L7, PM8XXX_GPIO_VIN_L6,
> -		PM8XXX_GPIO_VIN_L5, PM8XXX_GPIO_VIN_L2
> +		PM8XXX_GPIO_VIN14, PM8XXX_GPIO_VIN0, PM8XXX_GPIO_VIN12,
> +		PM8XXX_GPIO_VIN2, PM8XXX_GPIO_VIN6, PM8XXX_GPIO_VIN5,
> +		PM8XXX_GPIO_VIN4, PM8XXX_GPIO_VIN1
>  	},
>  	.npower_sources = 8,
>  };
>  static const struct pm8xxx_gpio_data pm8917_gpio_data = {
>  	.ngpio = 38,
>  	.power_sources = (int[]) {
> -		PM8XXX_GPIO_VIN_VPH, PM8XXX_GPIO_VIN_BB, PM8XXX_GPIO_VIN_S4,
> -		PM8XXX_GPIO_VIN_L15, PM8XXX_GPIO_VIN_L4, PM8XXX_GPIO_VIN_L3,
> -		PM8XXX_GPIO_VIN_L17
> +		PM8XXX_GPIO_VIN14, PM8XXX_GPIO_VIN0, PM8XXX_GPIO_VIN13,
> +		PM8XXX_GPIO_VIN10, PM8XXX_GPIO_VIN3, PM8XXX_GPIO_VIN2,
> +		PM8XXX_GPIO_VIN11
>  	},
>  	.npower_sources = 7,
>  };
> @@ -661,9 +659,9 @@ static const struct pm8xxx_gpio_data pm8917_gpio_data = {
>  static const struct pm8xxx_gpio_data pm8921_gpio_data = {
>  	.ngpio = 44,
>  	.power_sources = (int[]) {
> -		PM8XXX_GPIO_VIN_VPH, PM8XXX_GPIO_VIN_BB, PM8XXX_GPIO_VIN_S4,
> -		PM8XXX_GPIO_VIN_L15, PM8XXX_GPIO_VIN_L4, PM8XXX_GPIO_VIN_L3,
> -		PM8XXX_GPIO_VIN_L17
> +		PM8XXX_GPIO_VIN14, PM8XXX_GPIO_VIN0, PM8XXX_GPIO_VIN13,
> +		PM8XXX_GPIO_VIN10, PM8XXX_GPIO_VIN3, PM8XXX_GPIO_VIN2,
> +		PM8XXX_GPIO_VIN11
>  	},
>  	.npower_sources = 7,
>  };
> diff --git a/include/dt-bindings/pinctrl/qcom,pm8xxx-gpio.h b/include/dt-bindings/pinctrl/qcom,pm8xxx-gpio.h
> index 6b66fff..564fd05 100644
> --- a/include/dt-bindings/pinctrl/qcom,pm8xxx-gpio.h
> +++ b/include/dt-bindings/pinctrl/qcom,pm8xxx-gpio.h
> @@ -5,27 +5,30 @@
>  #ifndef _DT_BINDINGS_PINCTRL_QCOM_PM8XXX_GPIO_H
>  #define _DT_BINDINGS_PINCTRL_QCOM_PM8XXX_GPIO_H
>  
> +/* To be used with "qcom,pull-up = <>" */
>  #define PM8XXX_GPIO_PULL_UP_30		1
>  #define PM8XXX_GPIO_PULL_UP_1P5		2
>  #define PM8XXX_GPIO_PULL_UP_31P5	3
>  #define PM8XXX_GPIO_PULL_UP_1P5_30	4
>  
> -#define PM8XXX_GPIO_VIN_BB		0
> -#define PM8XXX_GPIO_VIN_L2		1
> -#define PM8XXX_GPIO_VIN_L3		2
> -#define PM8XXX_GPIO_VIN_L4		3
> -#define PM8XXX_GPIO_VIN_L5		4
> -#define PM8XXX_GPIO_VIN_L6		5
> -#define PM8XXX_GPIO_VIN_L7		6
> -#define PM8XXX_GPIO_VIN_L8		7
> -#define PM8XXX_GPIO_VIN_L11		8
> -#define PM8XXX_GPIO_VIN_L14		9
> -#define PM8XXX_GPIO_VIN_L15		10
> -#define PM8XXX_GPIO_VIN_L17		11
> -#define PM8XXX_GPIO_VIN_S3		12
> -#define PM8XXX_GPIO_VIN_S4		13
> -#define PM8XXX_GPIO_VIN_VPH		14
> +/* power-source */
> +#define PM8XXX_GPIO_VIN0		0
> +#define PM8XXX_GPIO_VIN1		1
> +#define PM8XXX_GPIO_VIN2		2
> +#define PM8XXX_GPIO_VIN3		3
> +#define PM8XXX_GPIO_VIN4		4
> +#define PM8XXX_GPIO_VIN5		5
> +#define PM8XXX_GPIO_VIN6		6
> +#define PM8XXX_GPIO_VIN7		7
> +#define PM8XXX_GPIO_VIN8		8
> +#define PM8XXX_GPIO_VIN9		9
> +#define PM8XXX_GPIO_VIN10		10
> +#define PM8XXX_GPIO_VIN11		11
> +#define PM8XXX_GPIO_VIN12		12
> +#define PM8XXX_GPIO_VIN13		13
> +#define PM8XXX_GPIO_VIN14		14
>  
> +/* To be used with "qcom,strength = <>" */
>  #define	PM8XXX_GPIO_STRENGTH_NO		0
>  #define	PM8XXX_GPIO_STRENGTH_HIGH	1
>  #define	PM8XXX_GPIO_STRENGTH_MED	2


