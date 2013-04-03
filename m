Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643Ab3DCN3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:29:51 -0400
Received: from us02smtp2.synopsys.com ([198.182.60.77]:44833 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094Ab3DCN3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:29:50 -0400
Message-ID: <515C2EC0.4090904@synopsys.com>
Date: Wed, 3 Apr 2013 18:59:36 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] Add implicit barriers to irqsave/restore class of functions
References: <20130403130340.GA13826@ab42.lan> <1364994622-14110-1-git-send-email-christian.ruppert@abilis.com>
In-Reply-To: <1364994622-14110-1-git-send-email-christian.ruppert@abilis.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

On 04/03/2013 06:40 PM, Christian Ruppert wrote:
> This patch adds implicit memory barriers to irqsave/restore functions of
> the ARC architecture port in line with what is done in other architectures.
>
> It seems to fix several seemingly unrelated issues in our platform but for
> the moment it is insufficiently tested (and might even be incomplete).
> Please comment.

I think this is not needed. Semantically we need barrier for spinlocks, not irq
save/restore - although spin locks are one of the primary users of irq
save/restore API.

So repeating what Thomas already said, the barrier already exists for
PREEMPT_COUNT, we need to make sure they are present for !PREEMPT_COUNT.

-Vineet

> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> ---
>  arch/arc/include/asm/irqflags.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arc/include/asm/irqflags.h b/arch/arc/include/asm/irqflags.h
> index ccd8480..c8147d1 100644
> --- a/arch/arc/include/asm/irqflags.h
> +++ b/arch/arc/include/asm/irqflags.h
> @@ -39,7 +39,7 @@ static inline long arch_local_irq_save(void)
>  	"	flag.nz %0		\n"
>  	: "=r"(temp), "=r"(flags)
>  	: "n"((STATUS_E1_MASK | STATUS_E2_MASK))
> -	: "cc");
> +	: "memory", "cc");
>  
>  	return flags;
>  }
> @@ -53,7 +53,7 @@ static inline void arch_local_irq_restore(unsigned long flags)
>  	__asm__ __volatile__(
>  	"	flag %0			\n"
>  	:
> -	: "r"(flags));
> +	: "r"(flags) : "memory");
>  }
>  
>  /*
> @@ -73,7 +73,7 @@ static inline void arch_local_irq_disable(void)
>  	"	and %0, %0, %1		\n"
>  	"	flag %0			\n"
>  	: "=&r"(temp)
> -	: "n"(~(STATUS_E1_MASK | STATUS_E2_MASK)));
> +	: "n"(~(STATUS_E1_MASK | STATUS_E2_MASK)) : "memory");
>  }
>  
>  /*
> @@ -85,7 +85,7 @@ static inline long arch_local_save_flags(void)
>  
>  	__asm__ __volatile__(
>  	"	lr  %0, [status32]	\n"
> -	: "=&r"(temp));
> +	: "=&r"(temp) : : "memory");
>  
>  	return temp;
>  }

