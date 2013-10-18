Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab3JRUL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 16:11:57 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43640 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab3JRUL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 16:11:56 -0400
Date: Fri, 18 Oct 2013 16:11:34 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131018201133.GD4019@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <20131012172124.GA18241@gmail.com>
 <20131014202854.GH26880@hmsreliant.think-freely.org>
 <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
 <20131017003421.GA31470@hmsreliant.think-freely.org>
 <1381974128.2045.144.camel@edumazet-glaptop.roam.corp.google.com>
 <20131018165034.GC4019@hmsreliant.think-freely.org>
 <1382116835.3284.23.camel@edumazet-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382116835.3284.23.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 10:20:35AM -0700, Eric Dumazet wrote:
> On Fri, 2013-10-18 at 12:50 -0400, Neil Horman wrote:
> > > 
> 
> > 	for(i=0;i<100000;i++) {
> > 		sum = csum_partial(buf+offset, PAGE_SIZE, sum);
> > 		offset = (offset < BUFSIZ-PAGE_SIZE) ? offset+PAGE_SIZE  : 0;
> > 	}
> 
> Please replace this by random accesses, and use the more standard 1500
> length.
> 
> offset = prandom_u32() % (BUFSIZ - 1500);
> offset &= ~1U;
> 
> sum = csum_partial(buf + offset, 1500, sum);
> 
> You are basically doing sequential accesses, so prefetch should
> be automatically done by cpu itself.
> 
> Thanks !
> 
> 
> 

Sure, you got it!  Results below.  However, they continue to bear out that
parallel execution beats prefetch only execution, and both is better than either
one.

base results:
53156647
59670931
62839770
44842780
39297190
44905905
53300688
53287805
39436951
43021730

AVG=493 ns

prefetch-only results:
40337434
51986404
43509199
53128857
52973171
53520649
53536338
50325466
44864664
47908398

AVG=492 ns


parallel-only results:
52157183
44496511
36180011
38298368
36258099
43263531
45365519
54116344
62529241
63118224

AVG = 475 ns


both prefetch and parallel:
44317078
44526464
45761272
44477906
34868814
44637904
49478309
49718417
58681403
58304972

AVG = 474 ns


Heres the code I was using



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
		sum = csum_partial(buf+offset, 1500, sum);
		offset = prandom_u32() % (BUFSIZ - 1500);
		offset &= ~1U;
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

