Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaKGOEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:04:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaKGOEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:04:31 -0500
Date: Fri, 7 Nov 2014 15:04:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: roland@hack.frob.com, linux@arm.linux.org.uk, will.deacon@arm.com,
        dsaxena@linaro.org, keescook@chromium.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
Message-ID: <20141107140405.GA30156@redhat.com>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07, AKASHI Takahiro wrote:
>
> --- a/arch/arm/kernel/ptrace.c
> +++ b/arch/arm/kernel/ptrace.c
> @@ -853,11 +853,6 @@ long arch_ptrace(struct task_struct *child, long request,
>  				       datap);
>  			break;
>  
> -		case PTRACE_SET_SYSCALL:
> -			task_thread_info(child)->syscall = data;
> -			ret = 0;
> -			break;
> -
>  #ifdef CONFIG_CRUNCH
>  		case PTRACE_GETCRUNCHREGS:
>  			ret = ptrace_getcrunchregs(child, datap);
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 54e7522..d7048fa 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -1001,6 +1001,12 @@ int ptrace_request(struct task_struct *child, long request,
>  		break;
>  	}
>  #endif
> +
> +#ifdef PTRACE_SET_SYSCALL
> +	case PTRACE_SET_SYSCALL:
> +		ret = syscall_set_nr(child, task_pt_regs(child), data);
> +		break;
> +#endif

I too do not understand why it makes sense to move PTRACE_SET_SYSCALL into
the common kernel/ptrace.c.

To me the fact that PTRACE_SET_SYSCALL can be undefined and syscall_set_nr()
is very much arch-dependant (but most probably trivial) means that this code
should live in arch_ptrace().

In any case, I think it doesn't make sense to pass task_pt_regs(child), this
helper can do this itself if it needs struct pt_regs.

Oleg.

