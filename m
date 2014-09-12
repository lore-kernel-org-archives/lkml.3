Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaILEHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 00:07:01 -0400
Received: from ozlabs.org ([103.22.144.67]:38709 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbaILEHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 00:07:00 -0400
Message-ID: <1410494817.17540.4.camel@concordia>
Subject: Re: [PATCH v3 3/3] sched: BUG when stack end location is over
 written
From: Michael Ellerman <mpe@ellerman.id.au>
To: Aaron Tomlin <atomlin@redhat.com>
Cc: peterz@infradead.org, dzickus@redhat.com, jcastillo@redhat.com,
        riel@redhat.com, x86@kernel.org, akpm@linux-foundation.org,
        minchan@kernel.org, mingo@kernel.com, bmr@redhat.com,
        prarit@redhat.com, oleg@redhat.com, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mingo@redhat.com,
        aneesh.kumar@linux.vnet.ibm.com, akpm@google.com, jgh@redhat.com,
        linuxppc-dev@lists.ozlabs.org, tglx@linutronix.de, pzijlstr@redhat.com
Date: Fri, 12 Sep 2014 14:06:57 +1000
In-Reply-To: <1410450088-18236-4-git-send-email-atomlin@redhat.com>
References: <1410255749-2956-1-git-send-email-atomlin@redhat.com>
	 <1410450088-18236-1-git-send-email-atomlin@redhat.com>
	 <1410450088-18236-4-git-send-email-atomlin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 16:41 +0100, Aaron Tomlin wrote:
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index a285900..2a8280a 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -824,6 +824,18 @@ config SCHEDSTATS
>  	  application, you can say N to avoid the very slight overhead
>  	  this adds.
>  
> +config SCHED_STACK_END_CHECK
> +	bool "Detect stack corruption on calls to schedule()"
> +	depends on DEBUG_KERNEL
> +	default y

Did you really mean default y?

Doing so means it will be turned on more or less everywhere, which defeats the
purpose of having a config option in the first place.

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index ec1a286..0b70b73 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2660,6 +2660,9 @@ static noinline void __schedule_bug(struct task_struct *prev)
>   */
>  static inline void schedule_debug(struct task_struct *prev)
>  {
> +#ifdef CONFIG_SCHED_STACK_END_CHECK
> +	BUG_ON(unlikely(task_stack_end_corrupted(prev)))
> +#endif

If this was my code I'd make you put that in a static inline.

cheers



