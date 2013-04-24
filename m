Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3DXPYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:24:46 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42775 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab3DXPYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:24:45 -0400
Date: Wed, 24 Apr 2013 17:24:37 +0200
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
Message-ID: <20130424152412.GB6993@somewhere>
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
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Vince Weaver <vincent.weaver@maine.edu>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  arch/x86/ia32/ia32_signal.c        | 2 --
>  arch/x86/include/asm/sighandling.h | 4 ++--
>  arch/x86/kernel/signal.c           | 6 ------
>  3 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
> index cf1a471..bccfca6 100644
> --- a/arch/x86/ia32/ia32_signal.c
> +++ b/arch/x86/ia32/ia32_signal.c
> @@ -34,8 +34,6 @@
>  #include <asm/sys_ia32.h>
>  #include <asm/smap.h>
>  
> -#define FIX_EFLAGS	__FIX_EFLAGS
> -
>  int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
>  {
>  	int err = 0;
> diff --git a/arch/x86/include/asm/sighandling.h b/arch/x86/include/asm/sighandling.h
> index beff97f..7a95816 100644
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

Does anybody know why we had RF not restored in x86-32?
