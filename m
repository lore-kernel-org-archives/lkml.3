Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab3CATAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:00:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58275 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab3CAS77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 13:59:59 -0500
Message-ID: <5130FA2E.9010502@zytor.com>
Date: Fri, 01 Mar 2013 10:57:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 2/5] signal x86: Clear RF EFLAGS bit for signal handler
References: <1362161512-16803-1-git-send-email-jolsa@redhat.com> <1362161512-16803-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1362161512-16803-3-git-send-email-jolsa@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 10:11 AM, Jiri Olsa wrote:
> Clearing RF EFLAGS bit for signal handler. The reason is,
> that this flag is set by debug exception code to prevent
> the recursive exception entry.
> 
> Leaving it set for signal handler might prevent debug
> exception of the signal handler itself.
> 
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index b6fe116..e273571 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -726,6 +726,13 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
>  	regs->flags &= ~X86_EFLAGS_DF;
>  
>  	/*
> +	 * Clear RF when entering the signal handler, because
> +	 * it might disable possible debug exception from the
> +	 * signal handler.
> +	 */
> +	regs->flags &= ~X86_EFLAGS_RF;
> +
> +	/*
>  	 * Clear TF when entering the signal handler, but
>  	 * notify any tracer that was single-stepping it.
>  	 * The tracer may want to single-step inside the
> 

Makes sense.  However, can you combine all the flags-clearing into one
statement while you are at it?

	-hpa

