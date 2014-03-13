Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaCMLUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:20:43 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:14998 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753574AbaCMLUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:20:42 -0400
Date: Thu, 13 Mar 2014 11:20:20 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Will Deacon <Will.Deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] arm64: Fix __addr_ok and __range_ok macros
Message-ID: <20140313112019.GD30339@arm.com>
References: <1394059289-3972-1-git-send-email-cov@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394059289-3972-1-git-send-email-cov@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 10:41:28PM +0000, Christopher Covington wrote:
> --- a/arch/arm64/include/asm/uaccess.h
> +++ b/arch/arm64/include/asm/uaccess.h
> @@ -66,12 +66,12 @@ static inline void set_fs(mm_segment_t fs)
>  #define segment_eq(a,b)	((a) == (b))
>  
>  /*
> - * Return 1 if addr < current->addr_limit, 0 otherwise.
> + * Return 1 if addr <= current->addr_limit, 0 otherwise.
>   */
>  #define __addr_ok(addr)							\
>  ({									\
>  	unsigned long flag;						\
> -	asm("cmp %1, %0; cset %0, lo"					\
> +	asm("cmp %1, %0; cset %0, ls"					\
>  		: "=&r" (flag)						\
>  		: "r" (addr), "0" (current_thread_info()->addr_limit)	\
>  		: "cc");						\

As Will said, this doesn't look right. Why do you need TASK_SIZE_64 to
be valid?

> @@ -83,7 +83,7 @@ static inline void set_fs(mm_segment_t fs)
>   * Returns 1 if the range is valid, 0 otherwise.
>   *
>   * This is equivalent to the following test:
> - * (u65)addr + (u65)size < (u65)current->addr_limit
> + * (u65)addr + (u65)size <= current->addr_limit
>   *
>   * This needs 65-bit arithmetic.
>   */
> @@ -91,7 +91,7 @@ static inline void set_fs(mm_segment_t fs)
>  ({									\
>  	unsigned long flag, roksum;					\
>  	__chk_user_ptr(addr);						\
> -	asm("adds %1, %1, %3; ccmp %1, %4, #2, cc; cset %0, cc"		\
> +	asm("adds %1, %1, %3; ccmp %1, %4, #3, cc; cset %0, ls"		\
>  		: "=&r" (flag), "=&r" (roksum)				\
>  		: "1" (addr), "Ir" (size),				\
>  		  "r" (current_thread_info()->addr_limit)		\

Just trying to understand: if adds does not set the C flag, we go on and
do the ccmp. If addr + size <= addr_limit, "cset ls" sets the flag
variable. If addr + size actually sets the C flag, we need to make sure
that "cset ls" doesn't trigger, which would mean to set C flag and clear
Z flag. So why do you change the ccmp flags from #2 to #3? It looks to
me like #2 is enough.

-- 
Catalin
