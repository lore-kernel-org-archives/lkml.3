Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaIZMOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:14:35 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43883 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754345AbaIZMOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:14:34 -0400
Date: Fri, 26 Sep 2014 13:14:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, leoli@freescale.com,
        Jason.Jin@freescale.com, Zhuoyu.Zhang@freescale.com
Subject: Re: [PATCH 3/3] arm: pm: add deep sleep support for LS1
Message-ID: <20140926121427.GO5182@n2100.arm.linux.org.uk>
References: <1411730703-25836-1-git-send-email-chenhui.zhao@freescale.com> <1411730703-25836-4-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411730703-25836-4-git-send-email-chenhui.zhao@freescale.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 07:25:03PM +0800, Chenhui Zhao wrote:
> +static int ls1_start_deepsleep(unsigned long addr)
> +{
> +	ls1_do_deepsleep(addr);
> +
> +	return 0;
> +}
...
> +	cpu_suspend(SRAM_CODE_BASE_PHY, ls1_start_deepsleep);

What's the point of this function?  Why can't ls1_do_deepsleep() just
return zero?

> +/*
> + * r0: the physical entry address of SRAM code
> + *
> + */
> +ENTRY(ls1_do_deepsleep)
> +	mov	r13, r0
> +
> +	/* flush cache */
> +	bl	v7_flush_dcache_all

Please explain the purpose of this call via a comment in the code.

The generic code will have saved the CPU state, and will have called
flush_cache_louis() to flush the caches to the point of unification.

The only data which will have been loaded into the cache between that
point is the stack for the return from __cpu_suspend_save, and
speculative prefetches.

So, the only reason I can gather is that you need to flush data from
lower levels of the cache below the point of unification.

> +
> +	/* disable cache, C bit in SCTLR */
> +	mrc	p15, 0, r0, c1, c0, 0
> +	bic	r0, r0, #(1 << 2)
> +	mcr	p15, 0, r0, c1, c0, 0
> +	isb
> +
> +	/* disable coherency, SMP bit in ACTLR */
> +	mrc	p15, 0, r0, c1, c0, 1
> +	bic	r0, r0, #(1 << 6)
> +	mcr	p15, 0, r0, c1, c0, 1
> +	isb
> +	dsb
> +
> +	/* disable MMU, M bit in SCTLR */
> +	mrc	p15, 0, r0, c1, c0, 0
> +	bic	r0, r0, #1
> +	mcr	p15, 0, r0, c1, c0, 0
> +	isb
> +
> +	/* jump to sram code using physical address */
> +	bx	r13

This looks extremely fragile.  You are running in virtual space, and you
turn the MMU off.  You are reliant on the MMU still being on for the
following instructions to already be in the pipeline.  That's not a
very good assumption to make (we've made it in the past and it breaks
every so often when things change, eg when the code is no longer laid
out how we expect.)

You need to disable the MMU safely, which means using the identity map
page tables and executing code in the identity map region.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
