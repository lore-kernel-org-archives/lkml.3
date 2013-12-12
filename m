Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab3LLEu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 23:50:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42911 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab3LLEuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 23:50:52 -0500
Message-ID: <52A94065.1050103@zytor.com>
Date: Wed, 11 Dec 2013 20:49:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
References: <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de>	 <20131211113839.GF21683@pd.tnic>	 <20131211115239.GA21999@twins.programming.kicks-ass.net>	 <1386764955.12005.60.camel@marge.simpson.net>	 <20131211124352.GB21999@twins.programming.kicks-ass.net>	 <20131211134048.GH21683@pd.tnic> <20131211145655.GB4510@gmail.com>	 <20131211164318.GA2480@laptop.programming.kicks-ass.net>	 <20131211175036.GC12431@gmail.com> <52A8F073.9040500@zytor.com>	 <20131211231425.GD8863@pd.tnic> <52A908DB.60902@zytor.com> <1386822357.6056.12.camel@marge.simpson.net>
In-Reply-To: <1386822357.6056.12.camel@marge.simpson.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 08:25 PM, Mike Galbraith wrote:
>  arch/x86/include/asm/mwait.h   |    4 ++--
>  arch/x86/kernel/cpu/common.c   |    7 ++++---
>  arch/x86/kernel/setup_percpu.c |    1 +
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/cpu/common.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/common.c
> +++ linux-2.6/arch/x86/kernel/cpu/common.c
> @@ -65,13 +65,14 @@ void __init setup_cpu_local_masks(void)
>  }
>  
>  /* allocate percpu area for mwait doorbell */
> -char __percpu *mwait_doorbell;
> +DEFINE_PER_CPU(char *, mwait_doorbell);
> +EXPORT_PER_CPU_SYMBOL(mwait_doorbell);
>  

Sorry, this is wrong.  This is NOT a percpu variable, it is a pointer to
a percpu allocation, but the variable itself is not a percpu variable.
This explains your boom.

>  void __init setup_mwait_doorbell(void)
>  {
>  	if (boot_cpu_has(X86_FEATURE_MWAIT)) {
> -		mwait_doorbell = __alloc_percpu(boot_cpu_data.clflush_size,
> -						boot_cpu_data.clflush_size);
> +		mwait_doorbell = __alloc_percpu(boot_cpu_data.x86_clflush_size,
> +						boot_cpu_data.x86_clflush_size);
>  
>  		if (!mwait_doorbell) {
>  			/* This should never happen... */

	-hpa


