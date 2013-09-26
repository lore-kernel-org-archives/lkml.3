Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3IZX7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 19:59:00 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:55542 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab3IZX67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 19:58:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Simon Horman <horms@verge.net.au>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH v2 5/5] ARM: shmobile: lager: (DEVEL) add CPUFreq support
Date: Fri, 27 Sep 2013 01:59:04 +0200
Message-ID: <1472582.vouUexCmlh@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1380216060-14506-6-git-send-email-g.liakhovetski@gmx.de>
References: <1380216060-14506-1-git-send-email-g.liakhovetski@gmx.de> <1380216060-14506-6-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

Thank you for the patch.

On Thursday 26 September 2013 19:21:00 Guennadi Liakhovetski wrote:
> The Lager board uses a DA9210 voltage regulator to supply DVFS power to the
> CA15 cores on the r8a7790 SoC. This patch adds CPUFreq support for that
> board using the cpufreq-cpu0 driver.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> ---
> 
> v2: added 'status = "okay";' to the i2c bus
> 
>  arch/arm/boot/dts/r8a7790-lager-reference.dts  |   33 +++++++++++++++++++++
>  arch/arm/mach-shmobile/board-lager-reference.c |    4 ++-
>  2 files changed, 36 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/r8a7790-lager-reference.dts
> b/arch/arm/boot/dts/r8a7790-lager-reference.dts index c462ef1..1ce0a97
> 100644
> --- a/arch/arm/boot/dts/r8a7790-lager-reference.dts
> +++ b/arch/arm/boot/dts/r8a7790-lager-reference.dts
> @@ -43,3 +43,36 @@
>  		};
>  	};
>  };
> +
> +&i2c3 {
> +	status = "okay";
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&i2c3_pins>;
> +
> +	vdd_dvfs: da9210@68 {
> +		compatible = "diasemi,da9210";
> +		reg = <0x68>;
> +
> +		regulator-min-microvolt = <900000>;
> +		regulator-max-microvolt = <1000000>;
> +		regulator-boot-on;
> +		regulator-always-on;
> +	};
> +};
> +
> +&cpu0 {
> +	cpu0-supply = <&vdd_dvfs>;
> +	operating-points = <
> +		/* kHz  uV - OPs unknown yet */
> +		1300000 1000000
> +		1000000  900000
> +	>;
> +	voltage-tolerance = <1>; /* 1% */
> +};
> +
> +&pfc {
> +	i2c3_pins: i2c3 {
> +		renesas,groups = "i2c3";
> +		renesas,function = "i2c3";
> +	};
> +};
> diff --git a/arch/arm/mach-shmobile/board-lager-reference.c
> b/arch/arm/mach-shmobile/board-lager-reference.c index 1a1a4a8..2bc8bae
> 100644
> --- a/arch/arm/mach-shmobile/board-lager-reference.c
> +++ b/arch/arm/mach-shmobile/board-lager-reference.c
> @@ -20,6 +20,7 @@
> 
>  #include <linux/init.h>
>  #include <linux/of_platform.h>
> +#include <linux/platform_device.h>
>  #include <mach/r8a7790.h>
>  #include <asm/mach/arch.h>
> 
> @@ -29,7 +30,8 @@ static void __init lager_add_standard_devices(void)
>  	r8a7790_clock_init();
> 
>  	r8a7790_add_dt_devices();
> -        of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +	platform_device_register_simple("cpufreq-cpu0", -1, NULL, 0);

Out of curiosity, could you explain how this cpufreq-cpu0 platform device gets 
associated with the cpu0 DT node ? The cpufreq-cpu0 driver requires a DT node 
(its probe function returns -ENOENT if pdev->dev.of_node is NULL), and I don't 
see how the of_node gets set as the platform device is registered through 
board code. I might of course be missing something obvious :-)

>  }
> 
>  static const char *lager_boards_compat_dt[] __initdata = {
-- 
Regards,

Laurent Pinchart

