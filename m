Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab3J2BUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:20:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63008 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757040Ab3J2BUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:20:19 -0400
Date: Mon, 28 Oct 2013 18:19:43 -0700
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/6] ARM: Add Krait L2 accessor functions
Message-ID: <20131029011942.GG4763@kartoffel>
References: <1383006690-6754-1-git-send-email-sboyd@codeaurora.org>
 <1383006690-6754-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1383006690-6754-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 12:31:27AM +0000, Stephen Boyd wrote:
> Qualcomm's Krait CPUs have a handful of L2 cache controller
> registers that live behind a cp15 based indirection register.
> First you program the indirection register (l2cpselr) to point
> the L2 'window' register (l2cpdr) at what you want to read/write.
> Then you read/write the 'window' register to do what you want.
> The l2cpselr register is not banked per-cpu so we must lock
> around accesses to it to prevent other CPUs from re-pointing
> l2cpdr underneath us.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/common/Kconfig                   |  3 ++
>  arch/arm/common/Makefile                  |  1 +
>  arch/arm/common/krait-l2-accessors.c      | 52 +++++++++++++++++++++++++++++++
>  arch/arm/include/asm/krait-l2-accessors.h | 20 ++++++++++++
>  4 files changed, 76 insertions(+)
>  create mode 100644 arch/arm/common/krait-l2-accessors.c
>  create mode 100644 arch/arm/include/asm/krait-l2-accessors.h

[...]

> +void set_l2_indirect_reg(u32 addr, u32 val)
> +{
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&krait_l2_lock, flags);
> +
> +	asm volatile ("mcr p15, 3, %0, c15, c0, 6" : : "r" (addr));
> +	isb();
> +	asm volatile ("mcr p15, 3, %0, c15, c0, 7" : : "r" (val));
> +	isb();
> +
> +	raw_spin_unlock_irqrestore(&krait_l2_lock, flags);
> +}
> +EXPORT_SYMBOL(set_l2_indirect_reg);

It might be worth commmenting inline as to what register each of these is
accessing. Inevitably the commit message will become harder to find and
associate with the code over time.

Similarly for get_l2_indirect_reg.

Thanks,
Mark.
