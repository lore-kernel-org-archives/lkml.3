Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3KTSzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:55:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:61245 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab3KTSzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:55:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="411951100"
Date: Wed, 20 Nov 2013 10:54:57 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 7/7] preempt: Take away preempt_enable_no_resched() from
 modules
Message-ID: <20131120105457.04f6e51e@ultegra>
In-Reply-To: <20131120162736.760865926@infradead.org>
References: <20131120160450.072555619@infradead.org>
	<20131120162736.760865926@infradead.org>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013 17:04:57 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> Discourage drivers/modules to be creative with preemption.
> 
> Sadly all is implemented in macros and inline so if they want to do
> evil they still can, but at least try and discourage some.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: lenb@kernel.org
> Cc: rjw@rjwysocki.net
> Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> Cc: Chris Leech <christopher.leech@intel.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: rui.zhang@intel.com
> Cc: jacob.jun.pan@linux.intel.com
> Cc: Mike Galbraith <bitbucket@online.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: hpa@zytor.com
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  include/linux/preempt.h |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> --- a/include/linux/preempt.h
> +++ b/include/linux/preempt.h
> @@ -64,7 +64,11 @@ do { \
>  } while (0)
>  
>  #else
> -#define preempt_enable() preempt_enable_no_resched()
> +#define preempt_enable() \
> +do { \
> +	barrier(); \
> +	preempt_count_dec(); \
> +} while (0)
>  #define preempt_check_resched() do { } while (0)
>  #endif
>  
> @@ -126,6 +130,16 @@ do { \
>  #define preempt_fold_need_resched() do { } while (0)
>  #endif
>  
> +#ifdef MODULE
> +/*
> + * Modules have no business playing preemption tricks.
> + */
> +#undef sched_preempt_enable_no_resched
> +#undef preempt_enable_no_resched
> +#undef preempt_enable_no_resched_notrace
> +#undef preempt_check_resched
> +#endif
> +
>  #ifdef CONFIG_PREEMPT_NOTIFIERS
>  
>  struct preempt_notifier;
> 
> 

run into a couple of compile issues.

1)
include/linux/rcupdate.h: In function ‘rcu_read_unlock_sched_notrace’:
include/linux/rcupdate.h:889:2: error: implicit declaration of function
‘preempt_enable_no_resched_notrace’ [-Werror=implicit-function-declaration]

2)
In file included from drivers/cpufreq/acpi-cpufreq.c:41:0:
include/linux/uaccess.h: In function ‘pagefault_enable’:
include/linux/uaccess.h:34:2: error: implicit declaration of function
‘preempt_check_resched’ [-Werror=implicit-function-declaration]

1) happens when CONFIG_PREEMPT is not set, perhaps add a dummy function?
2) I am not sure if we should take pagefault_enable away from modules
