Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab3JUTV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:21:29 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39972 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab3JUTV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:21:28 -0400
Date: Mon, 21 Oct 2013 15:21:16 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131021192116.GB4154@hmsreliant.think-freely.org>
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
> You have a lot of variations in your results, I suspect a NUMA affinity
> problem.
> 
> You can try the following code, and use taskset to make sure you run
> this on a cpu on node 0
> 
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


Ok, so I ran the above code on a single cpu using taskset, and set irq affinity
such that no interrupts (save for local ones), would occur on that cpu.  Note
that I had to convert csum_partial_opt to csum_partial, as the _opt variant
doesn't exist in my tree, nor do I see it in any upstream tree or in the history
anywhere.

base results:
53569916
43506025
43476542
44048436
45048042
48550429
53925556
53927374
53489708
53003915

AVG = 492 ns

prefetching only:
53279213
45518140
49585388
53176179
44071822
43588822
44086546
47507065
53646812
54469118

AVG = 488 ns


parallel alu's only:
46226844
44458101
46803498
45060002
46187624
37542946
45632866
46275249
45031141
46281204

AVG = 449 ns


both optimizations:
45708837
45631124
45697135
45647011
45036679
39418544
44481577
46820868
44496471
35523928

AVG = 438 ns


We continue to see a small savings in execution time with prefetching (4 ns, or
about 0.8%), a better savings with parallel alu execution (43 ns, or 8.7%), and
the best savings with both optimizations (54 ns, or 10.9%).  

These results, while they've changed as we've modified the test case slightly
have remained consistent in their sppedup ordinality.  Prefetching helps, but
not as much as using multiple alu's, and neither is as good as doing both
together.

Unless you see something else that I'm doing wrong here.  It seems like a win to
do both.

Regards
Neil



