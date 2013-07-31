Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983Ab3GaHQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 03:16:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59536 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab3GaHQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 03:16:32 -0400
Date: Wed, 31 Jul 2013 00:16:30 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Arpit Goel <B44344@freescale.com>
Cc: linux@arm.linux.org.uk, takata@linux-m32r.org, philb@gnu.org,
        geert@linux-m68k.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, linux390@de.ibm.com, davem@davemloft.net,
        rob.herring@calxeda.com, arnd@arndb.de, swarren@nvidia.com,
        john.stultz@linaro.org, jesper.nilsson@axis.com,
        gregkh@linuxfoundation.org, sam@ravnborg.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-m68k@vger.kernel.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, mattw@codeaurora.org
Subject: Re: [PATCH 2/2] Convert PowerPC macro spin_event_timeout() to
 architecture independent macro
Message-ID: <20130731071630.GI8868@codeaurora.org>
References: <1375187900-17582-1-git-send-email-B44344@freescale.com>
 <1375187900-17582-3-git-send-email-B44344@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375187900-17582-3-git-send-email-B44344@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Arpit Goel wrote:
> This patch ports PowerPC implementation of spin_event_timeout() for generic
> use. Architecture specific implementation can be added to asm/delay.h, which
> will override the generic linux implementation.
> 
> Signed-off-by: Arpit Goel <B44344@freescale.com>
> ---

We use something similar internally but it's tied specifically to
readl.

>  
> +#ifndef spin_event_timeout
> +/**
> + * spin_event_timeout - spin until a condition gets true or a timeout elapses
> + * @condition: a C expression to evalate
> + * @timeout: timeout, in microseconds
> + * @delay: the number of microseconds to delay between each evaluation of
> + *         @condition
> + *
> + * The process spins until the condition evaluates to true (non-zero) or the
> + * timeout elapses.  The return value of this macro is the value of
> + * @condition when the loop terminates. This allows you to determine the cause
> + * of the loop terminates.  If the return value is zero, then you know a
> + * timeout has occurred.
> + *
> + * This primary purpose of this macro is to poll on a hardware register
> + * until a status bit changes.  The timeout ensures that the loop still
> + * terminates even if the bit never changes.  The delay is for devices that
> + * need a delay in between successive reads.
> + *
> + * gcc will optimize out the if-statement if @delay is a constant.
> + *
> + * This is copied from PowerPC based spin_event_timeout() implementation
> + * and modified for generic usecase.
> + */
> +#define spin_event_timeout(condition, timeout, delay)		\
> +({								\
> +	typeof(condition) __ret;				\
> +	unsigned long __loops = timeout/USECS_PER_JIFFY;	\
> +	unsigned long __start = jiffies;			\
> +	while (!(__ret = (condition)) &&			\
> +		time_before(jiffies, __start + __loops + 1))	\
> +		if (delay)					\
> +			udelay(delay);				\
> +		else						\
> +			schedule();				\
> +	if (!__ret)						\
> +		__ret = (condition);				\
> +	__ret;							\
> +})

What do you do here if jiffies aren't incrementing (i.e
interrupts are disabled). The time_before() check won't work
there and it would be nice if we were able to use this in such
situations. I think powerpc gets around this by reading the
hardware timer directly?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
