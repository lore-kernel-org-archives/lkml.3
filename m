Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab3IFWb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 18:31:29 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:40170 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab3IFWb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 18:31:28 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: behanw@converseincode.com
Cc: linux@arm.linux.org.uk, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mark Charlebois <charlebm@gmail.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH 2/5] arm: LLVMLinux: use current_stack_pointer for percpu
References: <1378502899-1241-1-git-send-email-behanw@converseincode.com>
	<1378502899-1241-3-git-send-email-behanw@converseincode.com>
Date: Fri, 06 Sep 2013 23:31:26 +0100
In-Reply-To: <1378502899-1241-3-git-send-email-behanw@converseincode.com>
	(behanw@converseincode.com's message of "Fri, 6 Sep 2013 17:28:08
	-0400")
Message-ID: <yw1xioyd1t1d.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

behanw@converseincode.com writes:

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

This doesn't do quite the same thing.  The existing code pretends to
read something from the stack in order to create a barrier of some
sort.  Your new code stores the value of the stack pointer to a location
on the stack for consumption by the "Q" memory constraint.  This store
is not necessary and should preferably be avoided.

-- 
Måns Rullgård
mans@mansr.com
