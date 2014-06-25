Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbaFYWy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:54:57 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43087 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755226AbaFYWyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:54:46 -0400
Date: Wed, 25 Jun 2014 23:54:34 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 2/2] ARM: EXYNOS: Add support for firmware-assisted
	suspend/resume
Message-ID: <20140625225434.GN32514@n2100.arm.linux.org.uk>
References: <1403713114-18923-1-git-send-email-t.figa@samsung.com> <1403713114-18923-3-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403713114-18923-3-git-send-email-t.figa@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 06:18:34PM +0200, Tomasz Figa wrote:
> +static int exynos_suspend(void)
> +{
> +	/* Save Power control and Diagnostic registers */
> +	asm ("mrc p15, 0, %0, c15, c0, 0\n"
> +		"mrc p15, 0, %1, c15, c0, 1\n"
> +		: "=r" (cp15_power), "=r" (cp15_diag) : : "cc");
> +
> +	writel(EXYNOS_SLEEP_MAGIC, sysram_ns_base_addr + EXYNOS_BOOT_FLAG);
> +	writel(virt_to_phys(cpu_resume),
> +		sysram_ns_base_addr + EXYNOS_BOOT_ADDR);
> +
> +	return cpu_suspend(0, exynos_cpu_suspend);
> +}
> +
> +static int exynos_resume(void)
> +{
> +	exynos_smc(SMC_CMD_C15RESUME, cp15_power, cp15_diag, 0);

I am told that these two registers are not expected to change value
once the MMU is on.  This presents something of a problem where the
secure monitor is involved, because what that means is that this
really needs to be done before we get to C code.

OMAP has similar issues where it needs to restore the L2 cache
setup via SMC calls before the MMU is enabled, and they deal with
this via some hand-crafted assembly code which runs prior to calling
into cpu_resume.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
