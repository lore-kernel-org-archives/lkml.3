Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3JTV3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 17:29:46 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58279 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3JTV3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 17:29:45 -0400
Date: Sun, 20 Oct 2013 17:29:10 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131020212910.GA3387@neilslaptop.think-freely.org>
References: <20131012172124.GA18241@gmail.com>
 <20131014202854.GH26880@hmsreliant.think-freely.org>
 <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
 <20131017003421.GA31470@hmsreliant.think-freely.org>
 <1381974128.2045.144.camel@edumazet-glaptop.roam.corp.google.com>
 <20131018165034.GC4019@hmsreliant.think-freely.org>
 <1382116835.3284.23.camel@edumazet-glaptop.roam.corp.google.com>
 <20131018201133.GD4019@hmsreliant.think-freely.org>
 <1382130952.3284.43.camel@edumazet-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382130952.3284.43.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 02:15:52PM -0700, Eric Dumazet wrote:
> On Fri, 2013-10-18 at 16:11 -0400, Neil Horman wrote:
> 
> > #define BUFSIZ_ORDER 4
> > #define BUFSIZ ((2 << BUFSIZ_ORDER) * (1024*1024*2))
> > static int __init csum_init_module(void)
> > {
> > 	int i;
> > 	__wsum sum = 0;
> > 	struct timespec start, end;
> > 	u64 time;
> > 	struct page *page;
> > 	u32 offset = 0;
> > 
> > 	page = alloc_pages((GFP_TRANSHUGE & ~__GFP_MOVABLE), BUFSIZ_ORDER);
> 
> Not sure what you are doing here, but its not correct.
> 
Why not?  You asked for a test with 32 hugepages, so I allocated 32 hugepages.

> You have a lot of variations in your results, I suspect a NUMA affinity
> problem.
> 
I do have some variation, you're correct, but I don't think its a numa issue

> You can try the following code, and use taskset to make sure you run
> this on a cpu on node 0
> 
I did run this with taskset to do exactly that (hence my comment above).  I'll
be glad to run your variant on monday morning though and provide results.


Best
Neil


> #define BUFSIZ 2*1024*1024
> #define NBPAGES 16
> 
> static int __init csum_init_module(void)
> {
>         int i;
>         __wsum sum = 0;
>         u64 start, end;
> 	void *base, *addrs[NBPAGES];
>         u32 rnd, offset;
> 
> 	memset(addrs, 0, sizeof(addrs));
> 	for (i = 0; i < NBPAGES; i++) {
> 		addrs[i] = kmalloc_node(BUFSIZ, GFP_KERNEL, 0);
> 		if (!addrs[i])
> 			goto out;
> 	}
> 
>         local_bh_disable();
>         pr_err("STARTING ITERATIONS on cpu %d\n", smp_processor_id());
>         start = ktime_to_ns(ktime_get());
>         
>         for (i = 0; i < 100000; i++) {
> 		rnd = prandom_u32();
> 		base = addrs[rnd % NBPAGES];
> 		rnd /= NBPAGES;
> 		offset = rnd % (BUFSIZ - 1500);
>                 offset &= ~1U;
>                 sum = csum_partial_opt(base + offset, 1500, sum);
>         }
>         end = ktime_to_ns(ktime_get());
>         local_bh_enable();
> 
>         pr_err("COMPLETED 100000 iterations of csum %x in %llu nanosec\n", sum, end - start);
> 
> out:
> 	for (i = 0; i < NBPAGES; i++)
> 		kfree(addrs[i]);
> 
>         return 0;
> }
> 
> static void __exit csum_cleanup_module(void)
> {
>         return;
> }
> 
> 
> 
> 
