Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaAULVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:21:12 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54540 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754042AbaAULVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:21:08 -0500
Date: Tue, 21 Jan 2014 11:20:04 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>,
        "patches@linaro.org" <patches@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Steve Capper <steve.capper@linaro.org>
Subject: Re: [PATCH] ARM64: perf: support dwarf unwinding in compat mode
Message-ID: <20140121112004.GH30706@mudshark.cambridge.arm.com>
References: <1389869123-5884-1-git-send-email-jean.pihet@linaro.org>
 <20140116115634.GE30257@mudshark.cambridge.arm.com>
 <CAFrcx1=eAHsGZDsedGvvNai7Vrnf5p8RKLGFPS+cn5yGp7UQJw@mail.gmail.com>
 <20140116125727.GI30257@mudshark.cambridge.arm.com>
 <CAFrcx1npWFs3=rooqiGKSv-p7ivcG1J7SCvcmsz-hd3waXBfdA@mail.gmail.com>
 <CAFrcx1=QWPFeuNDc0JatiykGnRuvPyOgwwCxnW7pSAiNa9RsxA@mail.gmail.com>
 <20140117100723.GB16003@mudshark.cambridge.arm.com>
 <CAFrcx1=53sUDjxa-DjuJUScxanhQJqAVA36RaYNo5-Dfegij7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1=53sUDjxa-DjuJUScxanhQJqAVA36RaYNo5-Dfegij7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 05:05:14PM +0000, Jean Pihet wrote:
> Hi Will,
> 
> Here is an updated version of the change, which uses compat_sp at only
> one place.
> The drawback is that compat_user_mode is checked when calling
> compat_user_stack_pointer, which seems unnecessary. Unfortunately the
> check is not optimized out by the complier as I could check with
> objdump -S.
> 
> What do you think?

I think that's cleaner and really wouldn't worry about the couple of extra
instructions.

Cheers,

Will

> diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
> index fda2704..e71f81f 100644
> --- a/arch/arm64/include/asm/compat.h
> +++ b/arch/arm64/include/asm/compat.h
> @@ -228,7 +228,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
>         return (u32)(unsigned long)uptr;
>  }
> 
> -#define compat_user_stack_pointer() (current_pt_regs()->compat_sp)
> +#define compat_user_stack_pointer() (user_stack_pointer(current_pt_regs()))
> 
>  static inline void __user *arch_compat_alloc_user_space(long len)
>  {
> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
> index fbb0020..86d5b54 100644
> --- a/arch/arm64/include/asm/ptrace.h
> +++ b/arch/arm64/include/asm/ptrace.h
> @@ -133,7 +133,7 @@ struct pt_regs {
>         (!((regs)->pstate & PSR_F_BIT))
> 
>  #define user_stack_pointer(regs) \
> -       ((regs)->sp)
> +       (!compat_user_mode(regs)) ? ((regs)->sp) : ((regs)->compat_sp)
> 
>  /*
>   * Are the current registers suitable for user mode? (used to maintain
