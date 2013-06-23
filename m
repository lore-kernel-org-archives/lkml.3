Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab3FWJ2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 05:28:48 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:36517 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3FWJ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 05:28:44 -0400
Date: Sun, 23 Jun 2013 11:28:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: holt@sgi.com, travis@sgi.com, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 2/2] x86_64, mm: Reinsert the absent memory
Message-ID: <20130623092840.GB13445@gmail.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
 <1371831934-156971-3-git-send-email-nzimmer@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371831934-156971-3-git-send-email-nzimmer@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nathan Zimmer <nzimmer@sgi.com> wrote:

> The memory we set aside in the previous patch needs to be reinserted.
> We start this process via late_initcall so we will have multiple cpus to do
> the work.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org> 
> Cc: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/kernel/e820.c | 129 +++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/base/memory.c  |  83 +++++++++++++++++++++++++++++++
>  include/linux/memory.h |   5 ++
>  3 files changed, 217 insertions(+)
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 3752dc5..d31039d 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -23,6 +23,7 @@
>  
>  #ifdef CONFIG_DELAY_MEM_INIT
>  #include <linux/memory.h>
> +#include <linux/delay.h>
>  #endif
>  
>  #include <asm/e820.h>
> @@ -397,6 +398,22 @@ static u64 min_region_size;	/* min size of region to slice from */
>  static u64 pre_region_size;	/* multiply bsize for node low memory */
>  static u64 post_region_size;	/* multiply bsize for node high memory */
>  
> +static unsigned long add_absent_work_start_time;
> +static unsigned long add_absent_work_stop_time;
> +static unsigned int add_absent_job_count;
> +static atomic_t add_absent_work_count;
> +
> +struct absent_work {
> +	struct work_struct	work;
> +	struct absent_work	*next;
> +	atomic_t		busy;
> +	int			cpu;
> +	int			node;
> +	int			index;
> +};
> +static DEFINE_PER_CPU(struct absent_work, absent_work);
> +static struct absent_work *first_absent_work;

That's 4.5 GB/sec initialization speed - that feels a bit slow and the 
boot time effect should be felt on smaller 'a couple of gigabytes' desktop 
boxes as well. Do we know exactly where the 2 hours of boot time on a 32 
TB system is spent?

While you cannot profile the boot process (yet), you could try your 
delayed patch and run a "perf record -g" call-graph profiling of the 
late-time initialization routines. What does 'perf report' show?

Delayed initialization makes sense I guess because 32 TB is a lot of 
memory - I'm just wondering whether there's some low hanging fruits left 
in the mem init code, that code is certainly not optimized for 
performance.

Plus with a struct page size of around 64 bytes (?) 32 TB of RAM has 512 
GB of struct page arrays alone. Initializing those will take quite some 
time as well - and I suspect they are allocated via zeroing them first. If 
that memset() exists then getting rid of it might be a good move as well.

Yet another thing to consider would be to implement an initialization 
speedup of 3 orders of magnitude: initialize on the large page (2MB) 
grandularity and on-demand delay the initialization of the 4K granular 
struct pages [but still allocating them] - which I suspect are a good 
chunk of the overhead? That way we could initialize in 2MB steps and speed 
up the 2 hours bootup of 32 TB of RAM to 14 seconds...

[ The cost would be one more branch in the buddy allocator, to detect
  not-yet-initialized 2 MB chunks as we encounter them. Acceptable I 
  think. ]

Thanks,

	Ingo
