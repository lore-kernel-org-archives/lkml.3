Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab3KUFOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 00:14:05 -0500
Received: from ozlabs.org ([203.10.76.45]:52983 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3KUFOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 00:14:01 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 5/5] params: improve standard definitions
In-Reply-To: <1384623151-31302-6-git-send-email-felipe.contreras@gmail.com>
References: <1384623151-31302-1-git-send-email-felipe.contreras@gmail.com> <1384623151-31302-6-git-send-email-felipe.contreras@gmail.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 21 Nov 2013 12:13:35 +1030
Message-ID: <878uwibkc8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Contreras <felipe.contreras@gmail.com> writes:
> We are repeating the functionality of kstrtol in param_set_long, and the
> same for kstrtoint. We can get rid of the extra code by using the right
> functions.
>
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

Thanks, they're new since this code was written.  I didn't know about them...

Applied!
Rusty.

> ---
>  kernel/params.c | 25 +++++++++----------------
>  1 file changed, 9 insertions(+), 16 deletions(-)
>
> diff --git a/kernel/params.c b/kernel/params.c
> index c00d5b5..48e1a81 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -227,17 +227,10 @@ int parse_args(const char *doing,
>  }
>  
>  /* Lazy bastard, eh? */
> -#define STANDARD_PARAM_DEF(name, type, format, tmptype, strtolfn)      	\
> +#define STANDARD_PARAM_DEF(name, type, format, strtolfn)      		\
>  	int param_set_##name(const char *val, const struct kernel_param *kp) \
>  	{								\
> -		tmptype l;						\
> -		int ret;						\
> -									\
> -		ret = strtolfn(val, 0, &l);				\
> -		if (ret < 0 || ((type)l != l))				\
> -			return ret < 0 ? ret : -EINVAL;			\
> -		*((type *)kp->arg) = l;					\
> -		return 0;						\
> +		return strtolfn(val, 0, (type *)kp->arg);		\
>  	}								\
>  	int param_get_##name(char *buffer, const struct kernel_param *kp) \
>  	{								\
> @@ -253,13 +246,13 @@ int parse_args(const char *doing,
>  	EXPORT_SYMBOL(param_ops_##name)
>  
>  
> -STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", unsigned long, kstrtoul);
> -STANDARD_PARAM_DEF(short, short, "%hi", long, kstrtol);
> -STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, kstrtoul);
> -STANDARD_PARAM_DEF(int, int, "%i", long, kstrtol);
> -STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, kstrtoul);
> -STANDARD_PARAM_DEF(long, long, "%li", long, kstrtol);
> -STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, kstrtoul);
> +STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", kstrtou8);
> +STANDARD_PARAM_DEF(short, short, "%hi", kstrtos16);
> +STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", kstrtou16);
> +STANDARD_PARAM_DEF(int, int, "%i", kstrtoint);
> +STANDARD_PARAM_DEF(uint, unsigned int, "%u", kstrtouint);
> +STANDARD_PARAM_DEF(long, long, "%li", kstrtol);
> +STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", kstrtoul);
>  
>  int param_set_charp(const char *val, const struct kernel_param *kp)
>  {
> -- 
> 1.8.4.2+fc1
