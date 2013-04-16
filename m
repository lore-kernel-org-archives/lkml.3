Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935189Ab3DPBFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 21:05:31 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53552 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934863Ab3DPBF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 21:05:29 -0400
Date: Tue, 16 Apr 2013 03:05:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/6] signal x86: Propage RF EFLAGS bit throught the
 signal restore call
Message-ID: <20130416010524.GH17561@somewhere.redhat.com>
References: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
 <1362940871-24486-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362940871-24486-2-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 07:41:06PM +0100, Jiri Olsa wrote:
> Adding RF EFLAGS bit to be restored on return from signal from
> the original register context before the signal was entered.
> 
> This will prevent the RF flag to disappear when returning
> from exception due to the signal handler being executed.

So that happens if, say, we get a breakpoint exception and then we
run a signal handler before returning to the ip that triggered the
breakpoint?

[...]
> --- a/arch/x86/include/asm/sighandling.h
> +++ b/arch/x86/include/asm/sighandling.h
> @@ -7,10 +7,10 @@
>  
>  #include <asm/processor-flags.h>
>  
> -#define __FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
> +#define FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
>  			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
>  			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
> -			 X86_EFLAGS_CF)
> +			 X86_EFLAGS_CF | X86_EFLAGS_RF)
>  
>  void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
>  
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index 6956299..9df4c0b 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -43,12 +43,6 @@
>  
>  #include <asm/sigframe.h>
>  
> -#ifdef CONFIG_X86_32
> -# define FIX_EFLAGS	(__FIX_EFLAGS | X86_EFLAGS_RF)
> -#else
> -# define FIX_EFLAGS	__FIX_EFLAGS
> -#endif

So, I'm a bit confused here. Why was that only hapenning in X86_64?

> -
>  #define COPY(x)			do {			\
>  	get_user_ex(regs->x, &sc->x);			\
>  } while (0)
> -- 
> 1.7.11.7
> 
