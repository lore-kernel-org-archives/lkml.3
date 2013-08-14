Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab3HNK6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:58:46 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:47640 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329Ab3HNK6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:58:43 -0400
Date: Wed, 14 Aug 2013 12:58:38 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "Samuel Ortiz (sameo@linux.intel.com)" <sameo@linux.intel.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] Documentation: dt: bindings: add LP3943 bindings
Message-ID: <20130814105837.GB14228@ulmo>
References: <A874F61F95741C4A9BA573A70FE3998F82E849ED@DQHE06.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E849ED@DQHE06.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 30, 2013 at 12:42:29AM +0000, Kim, Milo wrote:
[...]
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-lp3943.txt b/Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
[...]
> +Required properties:
> +  - compatible: "ti,lp3943-gpio"
> +  - gpio-controller: device node as a GPIO controller

"Marks the device node as a GPIO controller"?

> +  - #gpio-cells: Should be two.

"Should be 2"?

[...]
> +		gpios = <&gpioex 9 1>;	/* active-low */
[...]
> +		gpios = <&gpioex 10 1>;	/* active-low */

If you use the defines as Lee suggested, then you don't need these
comments either.

> diff --git a/Documentation/devicetree/bindings/mfd/lp3943.txt b/Documentation/devicetree/bindings/mfd/lp3943.txt
> new file mode 100644
> index 0000000..ef62784
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/lp3943.txt
> @@ -0,0 +1,33 @@
> +TI/National Semiconductor LP3943 MFD driver
> +
> +Required properties:
> +  - compatible: "ti,lp3943"
> +  - reg: I2C slave address (u8). 0x60 ~ 0x67

u8 is a Linux specific and implementation detail. I think it's safe to
assume that everybody knows that I2C slave addresses are 7 bits (and
you even provide a valid range), so just drop the "(u8)".

> +lp3943@60 {
> +	compatible = "ti,lp3943";
> +	reg = <0x60>;
> +
> +	gpioex: gpio {
> +		compatible = "ti,lp3943-gpio";
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +	};
> +
> +	pwm3943: pwm {
> +		compatible = "ti,lp3943-pwm";
> +		#pwm-cells = <3>;
> +		ti,pwm0 = < 8 9 10 >;

This should probably be written as "<8 9 10>" for consistency.

> diff --git a/Documentation/devicetree/bindings/pwm/pwm-lp3943.txt b/Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
[...]
> +Required properties:
> +  - compatible: "ti,lp3943-pwm"
> +  - #pwm-cells: Should be three.

"Should be three"? Although since as I mentioned the chip doesn't
support polarity inversion, this should now be "2".

> +    1) index of PWM controller
> +       0 = PWM 0, 1 = PWM 1
> +    2) PWM signal period in nanoseconds
> +       min = 6250, max = 1600000
> +    3) bitmask of optional PWM polarity flags
> +       0 = normal, 1 = inversed

All of this can probably go away. The new way of doing this is to
reference the standard bindings document using something like the below:

  - #pwm-cells: Should be 2. See pwm.txt in this directory for a
                description of the cells format.

Since you have a restriction on the minimum and maximum period lengths,
you could add something like:

                Note that this hardware limits the period length to the
                range 6250-1600000.

> +  - ti,pwm0 or ti,pwm1: Output pin number(s) for PWM port 0 or 1.

"PWM port" -> "PWM channel"

> +    0 = invalid
> +    1 = output 0
> +    2 = output 1
> +    .
> +    .
> +    16 = output 15

I thought I read that this is now a 1:1 mapping?

> +Example:
> +PWM 0 is for RGB LED brightness control
> +PWM 1 is for brightness control of LP8557 backlight device
> +
> +&i2c3 {
> +	lp3943@60 {
> +		compatible = "ti,lp3943";
> +		reg = <0x60>;
> +
> +		/*
> +		 * PWM 0 : output 7, 8 and 9
> +		 * PWM 1 : output 15
> +		 */
> +		pwm3943: pwm {
> +			compatible = "ti,lp3943-pwm";
> +			#pwm-cells = <3>;
> +			ti,pwm0 = < 8 9 10 >;

And here as well: "< 8 9 10 >" -> "<8 9 10>".

Thierry

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC2LdAAoJEN0jrNd/PrOhQREQALBcwc3VWnoLmGF99/1x6AjR
1Z0eBljhKBg70Oes2pXpykGTOqLe0DrksyBqZgNCwJeWYeQ2gZM9SgJV6eFb9uA3
p+DJpWbVZODSg80tozdyGW9RTIu50j6eORZ05LhStbvg+kLMEYuK/VfT2CKZauIc
/Y8znzppYGFQpv0tYpdFp3779gwlb8VmcGvqa8s7C/phncgn56MydWsQwAtV2FRA
CMwPKybF6F8MxoZp3s6LBHFMEbAVGhb1PxNl9P1YVXWsij1VG+1TPWP5SpTjA3y4
qF1KUw/eja2sMdDJnQ3ma5jpZ94GBbp+nLOjhC7QfVI9D/n1oF6xrnpjfNlExObi
e9p9h92u5vdEZ2SmIJsnTRuWwF9wlsm/QnHXJFzV7AL8p0swtO6HuwyJAVCc733w
tpsz2Z6W/K4bgtQx/rFFQabCUp8C9zWIJG/NfXd2EYqh0f70aN76jAqLFv8XKD3j
Jd1VJ3Y8DBoXXPvnkJFvSYeXP0zb7MgLc/TwbboNMsq8pc6hBSDFQa+9I/zZr0o6
NXG+IXMKZwwBysq+Th8OMBlc6xRiF976THPtZ6AhRjPP8Xa8GiOlSmzR9uvq7XnL
zUZdjaFJr04Rm32SuZq2acGveZmtFKM80etYTjAahhIM/KTG4u+CdJM1dFBGybx7
C45UNzwORLnh/x/OfzuQ
=5Pgq
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
