Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaCQEjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 00:39:33 -0400
Received: from ozlabs.org ([203.10.76.45]:36990 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbaCQEjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 00:39:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: behanw@converseincode.com, khali@linux-fr.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: Re: [PATCH v3] module: LLVMLinux: Remove unused function warning from __param_check macro
In-Reply-To: <1394573091-4705-1-git-send-email-behanw@converseincode.com>
References: <87y50hw9go.fsf@rustcorp.com.au> <1394573091-4705-1-git-send-email-behanw@converseincode.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 17 Mar 2014 13:17:52 +1030
Message-ID: <87d2hltuav.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

behanw@converseincode.com writes:
> From: Mark Charlebois <charlebm@gmail.com>
>
> This code makes a compile time type check that is optimized away. Clang
> complains that it generates an unused function:

Thanks, applied.

Cheers,
Rusty.

>
> linux/kernel/panic.c:471:1: warning: unused function '__check_panic'
>       [-Wunused-function]
> core_param(panic, panic_timeout, int, 0644);
> ^
> linux/moduleparam.h:283:2: note: expanded from macro
>       'core_param'
>         param_check_##type(name, &(var));                               \
>         ^
> <scratch space>:87:1: note: expanded from here
> param_check_int
> ^
> linux/moduleparam.h:369:34: note: expanded from macro
>       'param_check_int'
> #define param_check_int(name, p) __param_check(name, p, int)
>                                  ^
> linux/moduleparam.h:349:22: note: expanded from macro
>       '__param_check'
>         static inline type *__check_##name(void) { return(p); }
>                             ^
> <scratch space>:88:1: note: expanded from here
> __check_panic
>
> GCC won't complain for a static inline function but would if it was just
> a static function.
>
> Adding the unused attribute to the function declaration removes the warning.
> Per request from Rusty Russell it is marked as __always_unused as the code
> is meant to be optimized away.
>
> This code works for both GCC and clang.
>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> ---
>  include/linux/moduleparam.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index c3eb102..175f699 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -346,7 +346,7 @@ static inline void destroy_params(const struct kernel_param *params,
>  /* The macros to do compile-time type checking stolen from Jakub
>     Jelinek, who IIRC came up with this idea for the 2.4 module init code. */
>  #define __param_check(name, p, type) \
> -	static inline type *__check_##name(void) { return(p); }
> +	static inline type __always_unused *__check_##name(void) { return(p); }
>  
>  extern struct kernel_param_ops param_ops_byte;
>  extern int param_set_byte(const char *val, const struct kernel_param *kp);
> -- 
> 1.8.3.2
