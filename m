Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679AbaLBQz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:55:59 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:43313 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaLBQz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:55:57 -0500
Date: Tue, 2 Dec 2014 16:55:56 +0000
From: Will Deacon <will.deacon@arm.com>
To: Mitchel Humpherys <mitchelh@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Wagantall <mattw@codeaurora.org>
Subject: Re: [PATCH RESEND v8] iopoll: Introduce memory-mapped IO polling
 macros
Message-ID: <20141202165556.GH9917@arm.com>
References: <1416860092-11620-1-git-send-email-mitchelh@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416860092-11620-1-git-send-email-mitchelh@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 08:14:52PM +0000, Mitchel Humpherys wrote:
> From: Matt Wagantall <mattw@codeaurora.org>
> 
> It is sometimes necessary to poll a memory-mapped register until its value
> satisfies some condition. Introduce a family of convenience macros that do
> this. Tight-looping, sleeping, and timing out can all be accomplished using
> these macros.
> 
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Matt Wagantall <mattw@codeaurora.org>
> Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
> ---
> This patch was originally part of a series [1] for adding support for IOMMU
> address translations through an ARM SMMU hardware register.  The other
> patch in the series (the one that actually uses these macros and implements
> said hardware address translations) was Ack'd by the driver maintainer
> there (Will Deacon) so I've pulled this patch out to avoid resending an
> already Ack'd patch over and over again.
> 
> In short, please see [1] for previous discussion and the first user of
> these macros.
> 
> This patch has been resent previously here [2], here [3], and here [4] on
> 2014-10-30, 2014-11-06, and 2014-11-17, respectively.  It has not changed
> since [2] and has not received any comments since [1] on 2014-10-19.
> Thanks to everyone who has taken a look at this.
> 
> [1] http://thread.gmane.org/gmane.linux.kernel.iommu/7140
> [2] http://thread.gmane.org/gmane.linux.kernel/1818213
> [3] http://thread.gmane.org/gmane.linux.kernel/1823422
> [4] http://thread.gmane.org/gmane.linux.kernel.iommu/7394

Did this ever get queued? It would be pretty useful for a bunch of drivers
that seem to copy-paste this sort of code.

If it helps:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will

> Changes since v7:
>   - sorted helper macros by size (b, w, l, q)
>   - removed some of the more esoteric (or flat-out bogus) helper macros
> ---
>  include/linux/iopoll.h | 140 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 140 insertions(+)
>  create mode 100644 include/linux/iopoll.h
> 
> diff --git a/include/linux/iopoll.h b/include/linux/iopoll.h
> new file mode 100644
> index 0000000000..bd161dae2d
> --- /dev/null
> +++ b/include/linux/iopoll.h
> @@ -0,0 +1,140 @@
> +/*
> + * Copyright (c) 2012-2014 The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef _LINUX_IOPOLL_H
> +#define _LINUX_IOPOLL_H
> +
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/hrtimer.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/io.h>
> +
> +/**
> + * readx_poll_timeout - Periodically poll an address until a condition is met or a timeout occurs
> + * @op: accessor function (takes @addr as its only argument)
> + * @addr: Address to poll
> + * @val: Variable to read the value into
> + * @cond: Break condition (usually involving @val)
> + * @sleep_us: Maximum time to sleep between reads in us (0 tight-loops)
> + * @timeout_us: Timeout in us, 0 means never timeout
> + *
> + * Returns 0 on success and -ETIMEDOUT upon a timeout. In either
> + * case, the last read value at @addr is stored in @val. Must not
> + * be called from atomic context if sleep_us or timeout_us are used.
> + *
> + * When available, you'll probably want to use one of the specialized
> + * macros defined below rather than this macro directly.
> + */
> +#define readx_poll_timeout(op, addr, val, cond, sleep_us, timeout_us)	\
> +({ \
> +	ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
> +	might_sleep_if(sleep_us); \
> +	for (;;) { \
> +		(val) = op(addr); \
> +		if (cond) \
> +			break; \
> +		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
> +			(val) = op(addr); \
> +			break; \
> +		} \
> +		if (sleep_us) \
> +			usleep_range((sleep_us >> 2) + 1, sleep_us); \
> +	} \
> +	(cond) ? 0 : -ETIMEDOUT; \
> +})
> +
> +/**
> + * readx_poll_timeout_atomic - Periodically poll an address until a condition is met or a timeout occurs
> + * @op: accessor function (takes @addr as its only argument)
> + * @addr: Address to poll
> + * @val: Variable to read the value into
> + * @cond: Break condition (usually involving @val)
> + * @delay_us: Time to udelay between reads in us (0 tight-loops)
> + * @timeout_us: Timeout in us, 0 means never timeout
> + *
> + * Returns 0 on success and -ETIMEDOUT upon a timeout. In either
> + * case, the last read value at @addr is stored in @val.
> + *
> + * When available, you'll probably want to use one of the specialized
> + * macros defined below rather than this macro directly.
> + */
> +#define readx_poll_timeout_atomic(op, addr, val, cond, delay_us, timeout_us) \
> +({ \
> +	ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
> +	for (;;) { \
> +		(val) = op(addr); \
> +		if (cond) \
> +			break; \
> +		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
> +			(val) = op(addr); \
> +			break; \
> +		} \
> +		if (delay_us) \
> +			udelay(delay_us);	\
> +	} \
> +	(cond) ? 0 : -ETIMEDOUT; \
> +})
> +
> +
> +#define readb_poll_timeout(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout(readb, addr, val, cond, delay_us, timeout_us)
> +
> +#define readb_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout_atomic(readb, addr, val, cond, delay_us, timeout_us)
> +
> +#define readw_poll_timeout(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout(readw, addr, val, cond, delay_us, timeout_us)
> +
> +#define readw_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout_atomic(readw, addr, val, cond, delay_us, timeout_us)
> +
> +#define readl_poll_timeout(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout(readl, addr, val, cond, delay_us, timeout_us)
> +
> +#define readl_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout_atomic(readl, addr, val, cond, delay_us, timeout_us)
> +
> +#define readq_poll_timeout(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout(readq, addr, val, cond, delay_us, timeout_us)
> +
> +#define readq_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout_atomic(readq, addr, val, cond, delay_us, timeout_us)
> +
> +#define readb_relaxed_poll_timeout(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout(readb_relaxed, addr, val, cond, delay_us, timeout_us)
> +
> +#define readb_relaxed_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout_atomic(readb_relaxed, addr, val, cond, delay_us, timeout_us)
> +
> +#define readw_relaxed_poll_timeout(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout(readw_relaxed, addr, val, cond, delay_us, timeout_us)
> +
> +#define readw_relaxed_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout_atomic(readw_relaxed, addr, val, cond, delay_us, timeout_us)
> +
> +#define readl_relaxed_poll_timeout(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout(readl_relaxed, addr, val, cond, delay_us, timeout_us)
> +
> +#define readl_relaxed_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout_atomic(readl_relaxed, addr, val, cond, delay_us, timeout_us)
> +
> +#define readq_relaxed_poll_timeout(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout(readq_relaxed, addr, val, cond, delay_us, timeout_us)
> +
> +#define readq_relaxed_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
> +	readx_poll_timeout_atomic(readq_relaxed, addr, val, cond, delay_us, timeout_us)
> +
> +#endif /* _LINUX_IOPOLL_H */
> -- 
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
> 
