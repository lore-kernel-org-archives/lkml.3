Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761763Ab3JQAef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 20:34:35 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46520 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760375Ab3JQAed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 20:34:33 -0400
Date: Wed, 16 Oct 2013 20:34:21 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131017003421.GA31470@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <20131012172124.GA18241@gmail.com>
 <20131014202854.GH26880@hmsreliant.think-freely.org>
 <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 03:18:47PM -0700, Eric Dumazet wrote:
> On Mon, 2013-10-14 at 14:19 -0700, Eric Dumazet wrote:
> > On Mon, 2013-10-14 at 16:28 -0400, Neil Horman wrote:
> > 
> > > So, early testing results today.  I wrote a test module that, allocated a 4k
> > > buffer, initalized it with random data, and called csum_partial on it 100000
> > > times, recording the time at the start and end of that loop.  Results on a 2.4
> > > GHz Intel Xeon processor:
> > > 
> > > Without patch: Average execute time for csum_partial was 808 ns
> > > With patch: Average execute time for csum_partial was 438 ns
> > 
> > Impressive, but could you try again with data out of cache ?
> 
> So I tried your patch on a GRE tunnel and got following results on a
> single TCP flow. (short result : no visible difference)
> 
> 

So I went to reproduce these results, but was unable to (due to the fact that I
only have a pretty jittery network to do testing accross at the moment with
these devices).  So instead I figured that I would go back to just doing
measurements with the module that I cobbled together (operating under the
assumption that it would give me accurate, relatively jitter free results (I've
attached the module code for reference below).  My results show slightly
different behavior:

Base results runs:
89417240
85170397
85208407
89422794
91645494
103655144
86063791
75647774
83502921
85847372
AVG = 875 ns

Prefetch only runs:
70962849
77555099
81898170
68249290
72636538
83039294
78561494
83393369
85317556
79570951
AVG = 781 ns

Parallel addition only runs:
42024233
44313064
48304416
64762297
42994259
41811628
55654282
64892958
55125582
42456403
AVG = 510 ns


Both prefetch and parallel addition:
41329930
40689195
61106622
46332422
49398117
52525171
49517101
61311153
43691814
49043084
AVG = 494 ns


For reference, each of the above large numbers is the number of nanoseconds
taken to compute the checksum of a 4kb buffer 100000 times.  To get my average
results, I ran the test in a loop 10 times, averaged them, and divided by
100000.


Based on these, prefetching is obviously a a good improvement, but not as good
as parallel execution, and the winner by far is doing both.

Thoughts?

Neil



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

static int __init csum_init_module(void)
{
	int i;
	__wsum sum = 0;
	struct timespec start, end;
	u64 time;

	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);

	if (!buf) {
		printk(KERN_CRIT "UNABLE TO ALLOCATE A BUFFER OF %lu bytes\n", PAGE_SIZE);
		return -ENOMEM;
	}

	printk(KERN_CRIT "INITALIZING BUFFER\n");
	get_random_bytes(buf, PAGE_SIZE);

	preempt_disable();
	printk(KERN_CRIT "STARTING ITERATIONS\n");
	getnstimeofday(&start);

	for(i=0;i<100000;i++)
		sum = csum_partial(buf, PAGE_SIZE, sum);
	getnstimeofday(&end);
	preempt_enable();
	if (start.tv_nsec > end.tv_nsec)
		time = (ULLONG_MAX - end.tv_nsec) + start.tv_nsec;
	else 
		time = end.tv_nsec - start.tv_nsec;

	printk(KERN_CRIT "COMPLETED 100000 iterations of csum in %llu nanosec\n", time);
	kfree(buf);
	return 0;


}

static void __exit csum_cleanup_module(void)
{
	return;
}

module_init(csum_init_module);
module_exit(csum_cleanup_module);
MODULE_LICENSE("GPL");

