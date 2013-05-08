Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3EHWlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 18:41:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab3EHWlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 18:41:37 -0400
Date: Wed, 8 May 2013 15:41:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: athorlton@sgi.com
Cc: linux-kernel@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Kuo <rkuo@codeaurora.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>, Robin Holt <holt@sgi.com>
Subject: Re: [patch 1/2] dump_stack: serialize the output from dump_stack()
Message-Id: <20130508154135.6a954bc4424050c607bc8378@linux-foundation.org>
In-Reply-To: <20130508210144.090393535@asylum.americas.sgi.com>
References: <20130508210144.090393535@asylum.americas.sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 May 2013 16:01:03 -0500 athorlton@sgi.com wrote:

> These patches fix up issues with interspersed output from multiple
> simultaneous calls to warn or dump_stack on multi-cpu systems.
> References: <20130508210102.898396979@asylum.americas.sgi.com>
> Content-Disposition: inline; filename=dump-stack-serialize.patch
> 
> This patch adds functionality to serialize the output from dump_stack() to 
> avoid mangling of the output when dump_stack is called simultaneously from
> multiple cpus.
> 
> ...
>
> The original discussion regarding this patch can be found in this thread:
> [PATCH] x86: Avoid intermixing cpu dump_stack output on multi-processor systems

If there was anything useful or interesting in that discussion then it
should be included in this patch's changelog, please.  Don't send
everyone off hunting for emails.  Email to which they can't reply in
the context of this thread...

> +++ linux/lib/dump_stack.c
> @@ -7,6 +7,8 @@
>  #include <linux/export.h>
>  #include <linux/sched.h>
>  
> +static atomic_t dump_lock = ATOMIC_INIT(-1);
> +
>  /**
>   * dump_stack - dump the current task information and its stack trace
>   *
> @@ -14,7 +16,30 @@
>   */
>  void dump_stack(void)
>  {
> +	int was_locked;
> +	int old;
> +	int cpu;
> +
> +	preempt_disable();
> +
> +retry:
> +	cpu = smp_processor_id();
> +	old = atomic_cmpxchg(&dump_lock, -1, cpu);
> +	if (old == -1) {
> +		was_locked = 0;
> +	} else if (old == cpu) {
> +		was_locked = 1;
> +	} else {
> +		cpu_relax();
> +		goto retry;
> +	}
> +
>  	dump_stack_print_info(KERN_DEFAULT);
>  	show_stack(NULL, NULL);
> +
> +	if (!was_locked)
> +		atomic_set(&dump_lock, -1);
> +
> +	preempt_enable();

This would benefit from a comment explaining what it's doing and why. 
"Permit this cpu to perform nested stack dumps while serialising
against other CPUs".

The patch adds a load of goop which is unneeded on uniprocessor
kernels.  I guess a non-messy way of avoiding that is to just have two
versions of dump_stack() in this file.

It would be prudent to toss some more #includes in there.  For
atomic_foo() and cpu_relax(), for example.

