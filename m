Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3IFW2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 18:28:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53695 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab3IFW2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 18:28:21 -0400
Date: Fri, 6 Sep 2013 23:22:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: behanw@converseincode.com
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Mark Charlebois <charlebm@gmail.com>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] arm: LLVMLinux: use current_stack_pointer for
	percpu
Message-ID: <20130906222243.GS6617@n2100.arm.linux.org.uk>
References: <1378502899-1241-1-git-send-email-behanw@converseincode.com> <1378502899-1241-3-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378502899-1241-3-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 05:28:08PM -0400, behanw@converseincode.com wrote:
> From: Behan Webster <behanw@converseincode.com>
> 
> The existing code uses named registers to get the value of the stack pointer.
> The new current_stack_pointer macro is more readable and allows for a central
> portable implementation of how to get the stack pointer with ASM.  This change
> supports being able to compile the kernel with both gcc and Clang.
> 
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
> ---
>  arch/arm/include/asm/percpu.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/percpu.h b/arch/arm/include/asm/percpu.h
> index 209e650..629a975 100644
> --- a/arch/arm/include/asm/percpu.h
> +++ b/arch/arm/include/asm/percpu.h
> @@ -30,14 +30,14 @@ static inline void set_my_cpu_offset(unsigned long off)
>  static inline unsigned long __my_cpu_offset(void)
>  {
>  	unsigned long off;
> -	register unsigned long *sp asm ("sp");
> +	unsigned long sp = current_stack_pointer;
>  
>  	/*
>  	 * Read TPIDRPRW.
>  	 * We want to allow caching the value, so avoid using volatile and
>  	 * instead use a fake stack read to hazard against barrier().
>  	 */
> -	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (off) : "Q" (*sp));
> +	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (off) : "Q" (sp));

This looks like it's breaking what's going on here.  With the original
code, we're passing the contents of the word at the stack pointer into
the assembly via a "Q" constraint.  After this change, we're passing
the _value_ of the stack pointer.

Also, if you read the comment, it's certainly wrong.
