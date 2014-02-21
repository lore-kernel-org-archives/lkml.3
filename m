Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaBUE4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 23:56:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49079 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbaBUE4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 23:56:34 -0500
Message-ID: <5306DC49.4060603@zytor.com>
Date: Thu, 20 Feb 2014 20:55:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: behanw@converseincode.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, peterz@infradead.org, ak@linux.intel.com,
        oleg@redhat.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: LLVMLinux: Reimplement current_stack_pointer without
 register usage.
References: <1392957882-24105-1-git-send-email-behanw@converseincode.com>
In-Reply-To: <1392957882-24105-1-git-send-email-behanw@converseincode.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems like really deep magic when looking at it... at the very 
least, this needs to be very carefully commented, including why it works 
on the various platforms.

How much does this actually affect the output?  I only see three uses of 
current_stack_pointer:

/* how to get the thread information struct from C */
static inline struct thread_info *current_thread_info(void)
{
         return (struct thread_info *)
                 (current_stack_pointer & ~(THREAD_SIZE - 1));
}

... here we need the mov anyway, because we have to then AND it with a 
mask, which we obviously can't do inside the stack pointer.

kernel/irq_32.c:        irqctx->tinfo.previous_esp = current_stack_pointer;

(two times)

Here we are moving it into a memory variable anyway, which the "=g" 
constraint should allow.

So I see no evidence this is more efficient in any way.

	-hpa


On 02/20/2014 08:44 PM, behanw@converseincode.com wrote:
> From: Behan Webster <behanw@converseincode.com>
>
> Use asm to make the globally named register work again for gcc and clang.
> Much more efficient than copying the stack pointer to a variable and back again.
>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> ---
>   arch/x86/include/asm/thread_info.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
> index e1940c0..e27ccc1 100644
> --- a/arch/x86/include/asm/thread_info.h
> +++ b/arch/x86/include/asm/thread_info.h
> @@ -163,10 +163,10 @@ struct thread_info {
>    */
>   #ifndef __ASSEMBLY__
>
> -#define current_stack_pointer ({		\
> -	unsigned long sp;			\
> -	asm("mov %%esp,%0" : "=g" (sp));	\
> -	sp;					\
> +#define current_stack_pointer ({			\
> +	register unsigned long sp asm("esp") __used;	\
> +	asm("" : "=r" (sp));				\
> +	sp;						\
>   })
>
>   /* how to get the thread information struct from C */
>

