Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaIOI7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 04:59:00 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56893 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753430AbaIOI67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 04:58:59 -0400
Date: Mon, 15 Sep 2014 09:58:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        lauraa@codeaurora.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, santosh.shilimkar@ti.com, tony@atomide.com,
        drake@endlessm.com, Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, loeliger@gmail.com
Subject: Re: [PATCH v4 5/7] ARM: EXYNOS: Add .write_sec outer cache
	callback for L2C-310
Message-ID: <20140915085845.GC12379@n2100.arm.linux.org.uk>
References: <1409062680-15906-1-git-send-email-t.figa@samsung.com> <1409062680-15906-6-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409062680-15906-6-git-send-email-t.figa@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 04:17:58PM +0200, Tomasz Figa wrote:
> Exynos4 SoCs equipped with an L2C-310 cache controller and running under
> secure firmware require certain registers of aforementioned IP to be
> accessed only from secure mode. This means that SMC calls are required
> for certain register writes. To handle this, an implementation of
> .write_sec and .configure callbacks is provided by this patch.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  arch/arm/mach-exynos/firmware.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
> index f5e626d..554b350 100644
> --- a/arch/arm/mach-exynos/firmware.c
> +++ b/arch/arm/mach-exynos/firmware.c
> @@ -17,6 +17,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/cputype.h>
>  #include <asm/firmware.h>
> +#include <asm/hardware/cache-l2x0.h>
>  #include <asm/suspend.h>
>  
>  #include <mach/map.h>
> @@ -120,6 +121,31 @@ static const struct firmware_ops exynos_firmware_ops = {
>  	.resume			= exynos_resume,
>  };
>  
> +static void exynos_l2_write_sec(unsigned long val, unsigned reg)
> +{
> +	switch (reg) {
> +	case L2X0_CTRL:
> +		if (val & L2X0_CTRL_EN)
> +			exynos_smc(SMC_CMD_L2X0INVALL, 0, 0, 0);

If we're calling this with the cache already enabled, presumably you're
doing this to cover the case where we're disabling the cache.

1. Do you really want to *invalidate* the L2 cache, discarding its
   contents?
2. Don't you think that... if you needed something like this here, then
   it could be a defficiency in the common code?

If (2) doesn't apply, then should be a comment here why this is needed.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
