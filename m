Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaDXJFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:05:45 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47306 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755112AbaDXJFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:05:39 -0400
Date: Thu, 24 Apr 2014 10:04:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Anders Berg <anders.berg@lsi.com>
Cc: arnd@arndb.de, olof@lixom.net, mturquette@linaro.org, mark.rutland@arm.com,
        dbaryshkov@gmail.com, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] ARM: Add platform support for LSI AXM55xx SoC
Message-ID: <20140424090444.GF26756@n2100.arm.linux.org.uk>
References: <cover.1397552154.git.anders.berg@lsi.com> <80a2523d3e266ed12d5b70ac5518e963e47b27f4.1397552154.git.anders.berg@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80a2523d3e266ed12d5b70ac5518e963e47b27f4.1397552154.git.anders.berg@lsi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 02:06:10PM +0200, Anders Berg wrote:
> +	adr	r4, 2f
> +	ldmia	r4, {r5, r6}
> +	sub	r4, r4, r5
> +	add	r6, r6, r4
> +1:	ldr	r7, [r6]
> +	cmp	r7, r0
> +	wfene
> +	bne	1b
...
> +2:	.long	.
> +	.long	pen_release
> diff --git a/arch/arm/mach-axxia/platsmp.c b/arch/arm/mach-axxia/platsmp.c
...
> +/*
> + * Write pen_release in a way that is guaranteed to be visible to all
> + * observers, irrespective of whether they're taking part in coherency
> + * or not.  This is necessary for the hotplug code to work reliably.
> + */
> +static void write_pen_release(int val)
> +{
> +	pen_release = val;
> +	/* Make sure this store is visible to other CPUs */
> +	smp_wmb();
> +	__cpuc_flush_dcache_area((void *)&pen_release, sizeof(pen_release));
> +}

Do you /really/ need to do this pen_release thing on your platform?

> +static void __init axxia_smp_prepare_cpus(unsigned int max_cpus)
> +{
...
> +		/*
> +		 * Release all physical cpus when not in hyp mode since we
> +		 * might want to bring them online later.
> +		 *
> +		 * Also we need to get the execution into kernel code (it's
> +		 * currently executing in u-boot).  u-boot releases the cores
> +		 * from reset in hyp mode.
> +		 */
> +		if (!is_hyp_mode_available()) {
> +			if (cpu != 0) {
> +				u32 tmp = readl(syscon + 0x1010);
> +				writel(0xab, syscon + 0x1000);
> +				tmp &= ~(1 << cpu);
> +				writel(tmp, syscon + 0x1010);
> +			}

As this implies that you can control the release of each CPU from u-boot
individually.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
