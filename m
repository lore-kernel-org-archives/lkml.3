Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab3JPGZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:25:47 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:51540 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3JPGZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:25:46 -0400
Date: Wed, 16 Oct 2013 08:25:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131016062541.GA21276@gmail.com>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <20131012172124.GA18241@gmail.com>
 <20131014202854.GH26880@hmsreliant.think-freely.org>
 <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
 <1381790278.16896.2.camel@joe-AO722>
 <1381790686.2045.24.camel@edumazet-glaptop.roam.corp.google.com>
 <1381790982.16896.7.camel@joe-AO722>
 <20131015074123.GB25493@gmail.com>
 <1381854064.22110.16.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381854064.22110.16.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Tue, 2013-10-15 at 09:41 +0200, Ingo Molnar wrote:
> > * Joe Perches <joe@perches.com> wrote:
> > 
> > > On Mon, 2013-10-14 at 15:44 -0700, Eric Dumazet wrote:
> > > > On Mon, 2013-10-14 at 15:37 -0700, Joe Perches wrote:
> > > > > On Mon, 2013-10-14 at 15:18 -0700, Eric Dumazet wrote:
> > > > > > attached patch brings much better results
> > > > > > 
> > > > > > lpq83:~# ./netperf -H 7.7.8.84 -l 10 -Cc
> > > > > > MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 7.7.8.84 () port 0 AF_INET
> > > > > > Recv   Send    Send                          Utilization       Service Demand
> > > > > > Socket Socket  Message  Elapsed              Send     Recv     Send    Recv
> > > > > > Size   Size    Size     Time     Throughput  local    remote   local   remote
> > > > > > bytes  bytes   bytes    secs.    10^6bits/s  % S      % S      us/KB   us/KB
> > > > > > 
> > > > > >  87380  16384  16384    10.00      8043.82   2.32     5.34     0.566   1.304  
> > > > > > 
> > > > > > diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
> > > > > []
> > > > > > @@ -68,7 +68,8 @@ static unsigned do_csum(const unsigned char *buff, unsigned len)
> > > > > >  			zero = 0;
> > > > > >  			count64 = count >> 3;
> > > > > >  			while (count64) { 
> > > > > > -				asm("addq 0*8(%[src]),%[res]\n\t"
> > > > > > +				asm("prefetch 5*64(%[src])\n\t"
> > > > > 
> > > > > Might the prefetch size be too big here?
> > > > 
> > > > To be effective, you need to prefetch well ahead of time.
> > > 
> > > No doubt.
> > 
> > So why did you ask then?
> > 
> > > > 5*64 seems common practice (check arch/x86/lib/copy_page_64.S)
> > > 
> > > 5 cachelines for some processors seems like a lot.
> > 
> > What processors would that be?
> 
> The ones where conservatism in L1 cache use is good because there are 
> multiple threads running concurrently.

What specific processor models would that be?

> > Most processors have hundreds of cachelines even in their L1 cache.
>
> And sometimes that many executable processes too.

Nonsense, this is an unrolled loop running in softirq context most of the 
time that does not get preempted.

> > Thousands in the L2 cache, up to hundreds of thousands.
> 
> Irrelevant because prefetch doesn't apply there.

What planet are you living on? Prefetch takes memory from L2->L1 memory 
just as much as it moves it cachelines from memory to the L2 cache. 

Especially in the usecase cited here there will be a second use of the 
data (when it's finally copied over into user-space), so the L2 cache size 
very much matters.

The prefetches here matter mostly to the packet being processed: the ideal 
size of the look-ahead window in csum_partial() is dictated by typical 
memory latencies and bandwidth. The amount of parallelism is limited by 
the number of carry bits we can maintain independently.

> Ingo, Eric _showed_ that the prefetch is good here. How about looking at 
> a little optimization to the minimal prefetch that gives that level of 
> performance.

Joe, instead of using a condescending tone in matters you clearly have 
very little clue about you might want to start doing some real kernel 
hacking in more serious kernel areas, beyond trivial matters such as 
printk strings, to gain a bit of experience and respect ...

Every word you uttered in this thread made it more likely for me to 
redirect you to /dev/null, permanently.

Thanks,

	Ingo
