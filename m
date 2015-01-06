Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbbAFRsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:48:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:17017 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932337AbbAFRsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:48:40 -0500
Date: Tue, 6 Jan 2015 12:48:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Anton Blanchard <anton@samba.org>
Cc: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au,
        mmarek@suse.cz, akpm@linux-foundation.org, jbaron@akamai.com,
        peterz@infradead.org, liuj97@gmail.com, mingo@kernel.org,
        mgorman@suse.de, linuxppc-dev@lists.ozlabs.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] jump_label: Allow jump labels to be used in assembly
Message-ID: <20150106174822.GA29629@home.goodmis.org>
References: <1420539628-17875-1-git-send-email-anton@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420539628-17875-1-git-send-email-anton@samba.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 09:20:27PM +1100, Anton Blanchard wrote:
> To use jump labels in assembly we need the HAVE_JUMP_LABEL define,
> so we select a fallback version if the toolchain does not support
> them.
> 
> Modify linux/jump_label.h so it can be included by assembly files.
> We also need to add -DCC_HAVE_ASM_GOTO to KBUILD_AFLAGS.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
>  Makefile                   |  1 +
>  include/linux/jump_label.h | 21 +++++++++++++++++----
>  2 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index ef748e1..7b83c3f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -774,6 +774,7 @@ KBUILD_ARFLAGS := $(call ar-option,D)
>  # check for 'asm goto'
>  ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
>  	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
> +	KBUILD_AFLAGS += -DCC_HAVE_ASM_GOTO
>  endif
>  
>  include $(srctree)/scripts/Makefile.extrawarn
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> index 98f923b6..f4de473 100644
> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -45,6 +45,12 @@
>   * same as using STATIC_KEY_INIT_FALSE.
>   */
>  
> +#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
> +# define HAVE_JUMP_LABEL
> +#endif
> +
> +#ifndef __ASSEMBLY__
> +
>  #include <linux/types.h>
>  #include <linux/compiler.h>
>  #include <linux/bug.h>
> @@ -55,7 +61,7 @@ extern bool static_key_initialized;
>  				    "%s used before call to jump_label_init", \
>  				    __func__)
>  
> -#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
> +#ifdef HAVE_JUMP_LABEL
>  
>  struct static_key {
>  	atomic_t enabled;
> @@ -66,13 +72,18 @@ struct static_key {
>  #endif
>  };
>  
> -# include <asm/jump_label.h>
> -# define HAVE_JUMP_LABEL
>  #else
>  struct static_key {
>  	atomic_t enabled;
>  };
> -#endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
> +#endif	/* HAVE_JUMP_LABEL */
> +#endif /* __ASSEMBLY__ */
> +
> +#ifdef HAVE_JUMP_LABEL
> +#include <asm/jump_label.h>
> +#endif

Have you tested this on other archs? Because just looking at x86, it doesn't
seem that asm/jump_label.h can handle being called in assembly.

-- Steve

> +
> +#ifndef __ASSEMBLY__
>  
>  enum jump_label_type {
>  	JUMP_LABEL_DISABLE = 0,
> @@ -203,3 +214,5 @@ static inline bool static_key_enabled(struct static_key *key)
>  }
>  
>  #endif	/* _LINUX_JUMP_LABEL_H */
> +
> +#endif /* __ASSEMBLY__ */
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
