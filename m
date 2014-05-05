Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799AbaEEOPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:15:34 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:51681 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbaEEOPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:15:32 -0400
Date: Mon, 5 May 2014 10:15:30 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: linux@arm.linux.org.uk, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: put_user: fix possible data corruption in
 put_user
In-Reply-To: <1399270438-26181-1-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.LFD.2.11.1405050950410.980@knanqh.ubzr>
References: <1399270438-26181-1-git-send-email-a.ryabinin@samsung.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2014, Andrey Ryabinin wrote:

> According to arm procedure call standart r2 register is call-cloberred.
> So after the result of x expression was put into r2 any following
> function call in p may overwrite r2. To fix this, the result of p
> expression must be saved to the temporary variable before the
> assigment x expression to __r2.

As subtle as it is, this appears to be exact.

However ...

> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>  arch/arm/include/asm/uaccess.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
> index 12c3a5d..4b584ac 100644
> --- a/arch/arm/include/asm/uaccess.h
> +++ b/arch/arm/include/asm/uaccess.h
> @@ -171,8 +171,9 @@ extern int __put_user_8(void *, unsigned long long);
>  #define __put_user_check(x,p)							\
>  	({								\
>  		unsigned long __limit = current_thread_info()->addr_limit - 1; \
> +		const typeof(*(p)) __user *tmp_p = (p);			\

Please use __tmp_p here rather than tmp_p as this could conflict with a 
variable of the same name in the calling context.  After that change you 
may add:

Reviewed-by: Nicolas Pitre <nico@linaro.org>

... and add "Cc: stable@vger.kernel.org" as well.

I confirm that, with this patch, the generated assembly from the test 
case is identical except for the added initialization of r2 which is 
optimized away otherwise.

Looking at all the other occurrences of register specified variables, 
they appear safe. We already encountered this issue as illustrated by 
commit 98d4ded60b but apparently failed to see the possibility for the 
same problem to occur elsewhere at the time.

>  		register const typeof(*(p)) __r2 asm("r2") = (x);	\
> -		register const typeof(*(p)) __user *__p asm("r0") = (p);\
> +		register const typeof(*(p)) __user *__p asm("r0") = tmp_p; \
>  		register unsigned long __l asm("r1") = __limit;		\
>  		register int __e asm("r0");				\
>  		switch (sizeof(*(__p))) {				\
> -- 
> 1.8.3.2
> 
