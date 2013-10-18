Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab3JRVP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 17:15:57 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45290 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab3JRVPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 17:15:54 -0400
Message-ID: <1382130952.3284.43.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Date: Fri, 18 Oct 2013 14:15:52 -0700
In-Reply-To: <20131018201133.GD4019@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <20131012172124.GA18241@gmail.com>
	 <20131014202854.GH26880@hmsreliant.think-freely.org>
	 <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
	 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131017003421.GA31470@hmsreliant.think-freely.org>
	 <1381974128.2045.144.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131018165034.GC4019@hmsreliant.think-freely.org>
	 <1382116835.3284.23.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131018201133.GD4019@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-18 at 16:11 -0400, Neil Horman wrote:

> #define BUFSIZ_ORDER 4
> #define BUFSIZ ((2 << BUFSIZ_ORDER) * (1024*1024*2))
> static int __init csum_init_module(void)
> {
> 	int i;
> 	__wsum sum = 0;
> 	struct timespec start, end;
> 	u64 time;
> 	struct page *page;
> 	u32 offset = 0;
> 
> 	page = alloc_pages((GFP_TRANSHUGE & ~__GFP_MOVABLE), BUFSIZ_ORDER);

Not sure what you are doing here, but its not correct.

You have a lot of variations in your results, I suspect a NUMA affinity
problem.

You can try the following code, and use taskset to make sure you run
this on a cpu on node 0

#define BUFSIZ 2*1024*1024
#define NBPAGES 16

static int __init csum_init_module(void)
{
        int i;
        __wsum sum = 0;
        u64 start, end;
	void *base, *addrs[NBPAGES];
        u32 rnd, offset;

	memset(addrs, 0, sizeof(addrs));
	for (i = 0; i < NBPAGES; i++) {
		addrs[i] = kmalloc_node(BUFSIZ, GFP_KERNEL, 0);
		if (!addrs[i])
			goto out;
	}

        local_bh_disable();
        pr_err("STARTING ITERATIONS on cpu %d\n", smp_processor_id());
        start = ktime_to_ns(ktime_get());
        
        for (i = 0; i < 100000; i++) {
		rnd = prandom_u32();
		base = addrs[rnd % NBPAGES];
		rnd /= NBPAGES;
		offset = rnd % (BUFSIZ - 1500);
                offset &= ~1U;
                sum = csum_partial_opt(base + offset, 1500, sum);
        }
        end = ktime_to_ns(ktime_get());
        local_bh_enable();

        pr_err("COMPLETED 100000 iterations of csum %x in %llu nanosec\n", sum, end - start);

out:
	for (i = 0; i < NBPAGES; i++)
		kfree(addrs[i]);

        return 0;
}

static void __exit csum_cleanup_module(void)
{
        return;
}



