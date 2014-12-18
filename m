Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbaLRTvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 14:51:41 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48516 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751096AbaLRTvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 14:51:39 -0500
Date: Thu, 18 Dec 2014 20:51:32 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-pwm@vger.kernel.org
Subject: Re: randconfig build error with next-20141204, in drivers/pwm
Message-ID: <20141218205132.3025b1ef@bbrezillon>
In-Reply-To: <20141218094442.GA24383@ulmo>
References: <CA+r1Zhj2ugeO7yqfmnbmkF4xqmZiiSbvq0zVXDMXdfOYGiHcRg@mail.gmail.com>
	<20141218094442.GA24383@ulmo>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Thu, 18 Dec 2014 10:44:44 +0100
Thierry Reding <thierry.reding@gmail.com> wrote:

> On Thu, Dec 04, 2014 at 09:10:55AM -0700, Jim Davis wrote:
> > Building with the attached random configuration file,
> > 
> > ERROR: "____ilog2_NaN" [drivers/pwm/pwm-atmel-hlcdc.ko] undefined!  
> 
> This took a while to figure out. The attached patch fixes this build
> failure, though the driver should probably be fixed to avoid division by
> zero, just in case. Adding Boris for visibility.

Thanks for fixing this build issue. I'll propose a patch to prevent
this div by 0 from happening.

> 
> Thierry
> 
> From 7933af1d2e5f3941d934eec88f32f5547ee218c3 Mon Sep 17 00:00:00 2001
> From: Thierry Reding <thierry.reding@gmail.com>
> Date: Thu, 18 Dec 2014 10:09:42 +0100
> Subject: [PATCH] pwm: atmel-hlcdc: Depend on HAVE_CLK
> 
> The include/linux/clk.h header defines dummy implementations for the
> various clk_*() functions if HAVE_CLK is not selected to improve build
> coverage in randconfig builds.
> 
> The dummy implementation of clk_get_rate() returns 0, which causes the
> Atmel HLCDC PWM driver's atmel_hlcdc_pwm_config() implementation to end
> up calling:
> 
> 	do_div(clk_period_ns, 0)
> 
> On x86, do_div(n, base) will end up evaluating to this:
> 
> 	n >>= ilog2(base)
> 
> with base = 0, the implementation of ilog2() will call ____ilog2_NaN(),
> which is purposely undefined and results in a linker failure:
> 
> 	ERROR: "____ilog2_NaN" [drivers/pwm/pwm-atmel-hlcdc.ko] undefined!
> 
> The implementation of do_div() checks that base is a power of 2 before
> calling ilog2(). The compiler doesn't optimize this away, presumably
> because is_power_of_2() is an inline function and the compiler doesn't
> or can't inspect it closely enough. ilog2() being a macro it still ends
> up generating the ____ilog2_NaN() because of the constant 0.
> 
> The root of the problem is that the driver really should be checking
> before possibly dividing by zero. That should eventually be fixed, but
> for now just assume that the clock runs at a sensible frequency when
> available.
> 
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Thierry Reding <thierry.reding@gmail.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  drivers/pwm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index a3ecf5809634..468af1b4ca30 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -53,6 +53,7 @@ config PWM_ATMEL
>  config PWM_ATMEL_HLCDC_PWM
>  	tristate "Atmel HLCDC PWM support"
>  	depends on MFD_ATMEL_HLCDC
> +	depends on HAVE_CLK
>  	help
>  	  Generic PWM framework driver for the PWM output of the HLCDC
>  	  (Atmel High-end LCD Controller). This PWM output is mainly used



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
