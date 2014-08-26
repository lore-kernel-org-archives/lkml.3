Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaHZRzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:55:40 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39615 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507AbaHZRzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:55:38 -0400
Date: Tue, 26 Aug 2014 18:55:26 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 5/6] arm64: add SIGSYS siginfo for compat task
Message-ID: <20140826175526.GF23445@arm.com>
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org>
 <1408611405-8943-6-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408611405-8943-6-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 09:56:44AM +0100, AKASHI Takahiro wrote:
> SIGSYS is primarily used in secure computing to notify tracer.
> This patch allows signal handler on compat task to get correct information
> with SA_SYSINFO specified when this signal is delivered.
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  arch/arm64/include/asm/compat.h |    7 +++++++
>  arch/arm64/kernel/signal32.c    |    8 ++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
> index 253e33b..c877915 100644
> --- a/arch/arm64/include/asm/compat.h
> +++ b/arch/arm64/include/asm/compat.h
> @@ -205,6 +205,13 @@ typedef struct compat_siginfo {
>  			compat_long_t _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
>  			int _fd;
>  		} _sigpoll;
> +
> +		/* SIGSYS */
> +		struct {
> +			compat_uptr_t _call_addr; /* calling user insn */
> +			int _syscall;	/* triggering system call number */
> +			unsigned int _arch;	/* AUDIT_ARCH_* of syscall */
> +		} _sigsys;
>  	} _sifields;
>  } compat_siginfo_t;
>  
> diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
> index 1b9ad02..aa550d6 100644
> --- a/arch/arm64/kernel/signal32.c
> +++ b/arch/arm64/kernel/signal32.c
> @@ -186,6 +186,14 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from)
>  		err |= __put_user(from->si_uid, &to->si_uid);
>  		err |= __put_user((compat_uptr_t)(unsigned long)from->si_ptr, &to->si_ptr);
>  		break;
> +#ifdef __ARCH_SIGSYS
> +	case __SI_SYS:
> +		err |= __put_user((compat_uptr_t)(unsigned long)
> +				from->si_call_addr, &to->si_call_addr);
> +		err |= __put_user(from->si_syscall, &to->si_syscall);
> +		err |= __put_user(from->si_arch, &to->si_arch);
> +		break;
> +#endif

I think you should drop this #ifdef. We care about whether arch/arm/ defines
__ARCH_SIGSYS, not whether arm64 defines it (they both happen to define it
anyway).

Will
