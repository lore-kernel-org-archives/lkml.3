Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3JRQvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 12:51:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40931 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3JRQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 12:51:14 -0400
Date: Fri, 18 Oct 2013 12:50:34 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131018165034.GC4019@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <20131012172124.GA18241@gmail.com>
 <20131014202854.GH26880@hmsreliant.think-freely.org>
 <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
 <20131017003421.GA31470@hmsreliant.think-freely.org>
 <1381974128.2045.144.camel@edumazet-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381974128.2045.144.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Your benchmark uses a single 4K page, so data is _super_ hot in cpu
> caches.
> ( prefetch should give no speedups, I am surprised it makes any
> difference)
> 
> Try now with 32 huges pages, to get 64 MBytes of working set.
> 
> Because in reality we never csum_partial() data in cpu cache.
> (Unless the NIC preloaded the data into cpu cache before sending the
> interrupt)
> 
> Really, if Sebastien got a speed up, it means that something fishy was
> going on, like :
> 
> - A copy of data into some area of memory, prefilling cpu caches
> - csum_partial() done while data is hot in cache.
> 
> This is exactly a "should not happen" scenario, because the csum in this
> case should happen _while_ doing the copy, for 0 ns.
> 
> 
> 
> 


So, I took your suggestion, and modified my test module to allocate 32 huge
pages instead of a single 4k page.  I've attached the module changes and the
results below.  Contrary to your assertion above, results came out the same as
in my first run.  See below:

base results:
80381491
85279536
99537729
80398029
121385411
109478429
85369632
99242786
80250395
98170542

AVG=939 ns

prefetch only results:
86803812
101891541
85762713
95866956
102316712
93529111
90473728
79374183
93744053
90075501

AVG=919 ns

parallel only results:
68994797
63503221
64298412
63784256
75350022
66398821
77776050
79158271
91006098
67822318

AVG=718 ns

both prefetch and parallel results:
68852213
77536525
63963560
67255913
76169867
80418081
63485088
62386262
75533808
57731705

AVG=693 ns


So based on these, it seems that your assertion that prefetching is the key to
speedup here isn't quite correct.  Either that or the testing continues to be
invalid.  I'm going to try to do some of ingos microbenchmarking just to see if
that provides any further details.  But any other thoughts about what might be
going awry are appreciated.

My module code:



#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/netdevice.h>
#include <linux/etherdevice.h>
#include <linux/init.h>
#include <linux/moduleparam.h>
#include <linux/rtnetlink.h>
#include <net/rtnetlink.h>
#include <linux/u64_stats_sync.h>

static char *buf;

#define BUFSIZ_ORDER 4
#define BUFSIZ ((2 << BUFSIZ_ORDER) * (1024*1024*2))
static int __init csum_init_module(void)
{
	int i;
	__wsum sum = 0;
	struct timespec start, end;
	u64 time;
	struct page *page;
	u32 offset = 0;

	page = alloc_pages((GFP_TRANSHUGE & ~__GFP_MOVABLE), BUFSIZ_ORDER);
	if (!page) {
		printk(KERN_CRIT "NO MEMORY FOR ALLOCATION");
		return -ENOMEM;
	}
	buf = page_address(page); 

	
	printk(KERN_CRIT "INITALIZING BUFFER\n");

	preempt_disable();
	printk(KERN_CRIT "STARTING ITERATIONS\n");
	getnstimeofday(&start);
	
	for(i=0;i<100000;i++) {
		sum = csum_partial(buf+offset, PAGE_SIZE, sum);
		offset = (offset < BUFSIZ-PAGE_SIZE) ? offset+PAGE_SIZE  : 0;
	}
	getnstimeofday(&end);
	preempt_enable();
	if ((unsigned long)start.tv_nsec > (unsigned long)end.tv_nsec)
		time = (ULONG_MAX - (unsigned long)end.tv_nsec) + (unsigned long)start.tv_nsec;
	else 
		time = (unsigned long)end.tv_nsec - (unsigned long)start.tv_nsec;

	printk(KERN_CRIT "COMPLETED 100000 iterations of csum in %llu nanosec\n", time);
	__free_pages(page, BUFSIZ_ORDER);
	return 0;


}

static void __exit csum_cleanup_module(void)
{
	return;
}

module_init(csum_init_module);
module_exit(csum_cleanup_module);
MODULE_LICENSE("GPL");
