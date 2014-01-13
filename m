Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaAMLQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:16:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59045 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaAMLQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:16:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@karo-electronics.de>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Subject: Re: [PATCH 2/2] pwm: imx: support polarity inversion
Date: Mon, 13 Jan 2014 12:13:58 +0100
Message-ID: <11504930.fjG2AZiQ4e@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1389608988-10981-3-git-send-email-LW@KARO-electronics.de>
References: <1389608988-10981-1-git-send-email-LW@KARO-electronics.de> <1389608988-10981-3-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:BcqipejqR5xWE7uoB+qRgLdvyzfhf32ASfhOIovKtWk
 9nCR3Msfx+bioMJ8f3hk6sXKuvN4+2+iyn7qcI2dUpnuiRzPZG
 BStBSFBzCkjn4QimEpoh1Vbo9Ttl0jaDds30f/8mCORQ+nawyo
 eDeGC0PYbqjZoewHWr106Z7vLM7wY6vZw3XT6XF4Sl6dZsEu6u
 zrbnijscBjCBTfzkibQ6augukJr3djmtbloqStf7/AHF2ezwqY
 l0SknhYMbYXRTLddazPHfvtq1yg3VqJ5b5TK3vuxpOgKV0DbMM
 7x34BmLnTWUnJYS3AhsW3mrFhf1zoOP8bAYiAv5/lMYU7s2w+V
 u7PqPA5YoTSJuRCSuTmU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 January 2014 11:29:48 Lothar Waßmann wrote:

> diff --git a/arch/arm/boot/dts/imx50.dtsi b/arch/arm/boot/dts/imx50.dtsi
> index 01c0499..e3647a8 100644
> --- a/arch/arm/boot/dts/imx50.dtsi
> +++ b/arch/arm/boot/dts/imx50.dtsi
> @@ -273,7 +273,7 @@
>  			};
>  
>  			pwm1: pwm@53fb4000 {
> -				#pwm-cells = <2>;
> +				#pwm-cells = <3>;
>  				compatible = "fsl,imx50-pwm", "fsl,imx27-pwm";
>  				reg = <0x53fb4000 0x4000>;
>  				clocks = <&clks IMX5_CLK_PWM1_IPG_GATE>,
...
> @@ -271,6 +293,13 @@ static int imx_pwm_probe(struct platform_device *pdev)
>  		return PTR_ERR(imx->mmio_base);
>  
>  	data = of_id->data;
> +	if (data->output_polarity) {
> +		dev_info(&pdev->dev, "PWM supports inversion\n");
> +		imx_pwm_ops.set_polarity = imx_pwm_set_polarity;
> +		imx->chip.of_xlate = of_pwm_xlate_with_flags;
> +		imx->chip.of_pwm_n_cells = 3;
> +	}
> +
>  	imx->config = data->config;
>  	imx->set_enable = data->set_enable;

This looks like you are breaking compatibility with the binding,
which requires #pwm-cells to be <2>. You can extend the binding
to allow both <2> and <3>, but then you have to not only document
that change in the binding, but also ensure that the pwm driver
is able to use either variant.

	Arnd
