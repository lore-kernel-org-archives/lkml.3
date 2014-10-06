Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaJFR2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 13:28:55 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45067 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaJFR2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:28:52 -0400
Date: Mon, 6 Oct 2014 10:28:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: atull@opensource.altera.com
Cc: jdelvare@suse.de, lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v5 1/4] hwmon: ltc2978: device tree bindings documentation
Message-ID: <20141006172845.GA21902@roeck-us.net>
References: <1412275071-6417-1-git-send-email-atull@opensource.altera.com>
 <1412275071-6417-2-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412275071-6417-2-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 01:37:48PM -0500, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Add device tree bindings documentation for ltc2978.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> ---
> v2: clean whitespace
> ---
>  .../devicetree/bindings/hwmon/ltc2978.txt          |   41 ++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/hwmon/ltc2978.txt
> 
> diff --git a/Documentation/devicetree/bindings/hwmon/ltc2978.txt b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
> new file mode 100644
> index 0000000..b2d9c4d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
> @@ -0,0 +1,41 @@
> +ltc2978
> +
> +Required properties:
> + - compatible: one of: ltc2974, ltc2977, ltc2978, ltc3880, ltc3883, ltm4676
> + - reg: I2C address
> +
> +Optional properties:
> + Name of the optional regulator subnode must be "regulators".

This is currently a problem. The regulator core trats it as mandatory,
meaning I get error messages such as

ltc2978 5-005e: Failed to find regulator container node

if not specified. We'll have to sort out with the regulator core how this should
be handled.

> +  - #address-cells must be 1.
> +  - #size-cells must be 0.
> +

Checking this out, those do not seem to be necessary.

> + For each regulator:
> +  - reg: regulator number

This does not seem to be necessary either.

> +  - regulator-compatible: must be vout_en<regulator number> such as vout_en3
> +    valid range is:
> +      ltc2977, ltc2978 : vout_en0 - vout_en7
> +      ltc2974          : vout_en0 - vout_en3
> +      ltc3880, ltm4676 : vout_en0 - vout_en1
> +      ltc3883          : vout_en0 only

Besides the unnecessary _en, this is a problem if there is more than one
supported chip in the system, if DEBUG_FS is enabled, and if names are not
specified in the devicetree file. I get a lot of error messages in a
system with a large number of LTC2978 chips.

vout3: Failed to create debugfs directory
vout4: Failed to create debugfs directory
vout5: Failed to create debugfs directory
vout6: Failed to create debugfs directory
vout7: Failed to create debugfs directory
vout2: Failed to create debugfs directory
vout3: Failed to create debugfs directory

and so on (40+ times in my system). We will have to find a solution for this
problem.

I also get

vout7: no parameters

for each regulator which is a bit annoying with 50+ of those regulators
in the system.

Guenter

> +  - regulator-name: arbitrary name for regulator
> +
> +Example:
> +ltc2978@5e {
> +	compatible = "ltc2978";
> +	reg = <0x5e>;
> +	regulators {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		vdacp0_reg: regulator@0 {
> +			reg = <0>;
> +			regulator-compatible = "vout_en0";
> +			regulator-name = "FPGA-2.5V";
> +		};
> +		vdacp2_reg: regulator@2 {
> +			reg = <2>;
> +			regulator-compatible = "vout_en2";
> +			regulator-name = "FPGA-1.5V";
> +		};
> +	};
> +};
> -- 
> 1.7.9.5
> 
