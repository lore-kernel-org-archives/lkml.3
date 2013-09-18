Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab3IRKsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:48:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39786 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3IRKsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:48:51 -0400
Date: Wed, 18 Sep 2013 12:48:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch 6/6] preempt: Make PREEMPT_ACTIVE generic
Message-ID: <20130918104835.GH9326@twins.programming.kicks-ass.net>
References: <20130917082838.218329307@infradead.org>
 <20130917182350.449685712@linutronix.de>
 <20130917183629.090698799@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130917183629.090698799@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 06:53:09PM -0000, Thomas Gleixner wrote:
> No point in having this bit defined by architecture.
> 
> Index: linux-2.6/include/linux/preempt_mask.h
> ===================================================================
> --- linux-2.6.orig/include/linux/preempt_mask.h
> +++ linux-2.6/include/linux/preempt_mask.h
> @@ -17,10 +17,11 @@
>   * there are a few palaeontologic drivers which reenable interrupts in
>   * the handler, so we need more than one bit here.
>   *
> - * PREEMPT_MASK: 0x000000ff
> - * SOFTIRQ_MASK: 0x0000ff00
> - * HARDIRQ_MASK: 0x000f0000
> - *     NMI_MASK: 0x00100000
> + * PREEMPT_MASK:	0x000000ff
> + * SOFTIRQ_MASK:	0x0000ff00
> + * HARDIRQ_MASK:	0x000f0000
> + *     NMI_MASK:	0x00100000
> + * PREEMPT_ACTIVE:	0x00200000
>   */
>  #define PREEMPT_BITS	8
>  #define SOFTIRQ_BITS	8
> @@ -46,15 +47,9 @@
>  
>  #define SOFTIRQ_DISABLE_OFFSET	(2 * SOFTIRQ_OFFSET)
>  
> -#ifndef PREEMPT_ACTIVE
>  #define PREEMPT_ACTIVE_BITS	1
>  #define PREEMPT_ACTIVE_SHIFT	(NMI_SHIFT + NMI_BITS)
>  #define PREEMPT_ACTIVE	(__IRQ_MASK(PREEMPT_ACTIVE_BITS) << PREEMPT_ACTIVE_SHIFT)
> -#endif
> -
> -#if PREEMPT_ACTIVE < (1 << (NMI_SHIFT + NMI_BITS))
> -#error PREEMPT_ACTIVE is too low!
> -#endif
>  
>  #define hardirq_count()	(preempt_count() & HARDIRQ_MASK)
>  #define softirq_count()	(preempt_count() & SOFTIRQ_MASK)

I get:

 init/init_task.c:26:4: error: ‘PREEMPT_ACTIVE’ undeclared here (not in a function)

Because for some obscure reason sched.h doesn't actually include enough.

The below cures things:

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -22,6 +22,7 @@ struct sched_param {
 #include <linux/errno.h>
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
+#include <linux/preempt_mask.h>
 
 #include <asm/page.h>
 #include <asm/ptrace.h>

