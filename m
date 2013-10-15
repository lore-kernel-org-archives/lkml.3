Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304Ab3JOQVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:21:20 -0400
Received: from smtprelay0046.hostedemail.com ([216.40.44.46]:59299 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932510Ab3JOQVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:21:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:421:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2198:2199:2393:2559:2562:2828:2900:3138:3139:3140:3141:3142:3355:3622:3743:3834:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4560:4605:5007:6119:6691:7652:7809:7903:7904:8603:9121:10004:10394:10400:10848:11026:11232:11233:11473:11658:11914:12043:12296:12517:12519:12555:12740:13095:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cub15_a8967d9d6e27
X-Filterd-Recvd-Size: 3932
Message-ID: <1381854064.22110.16.camel@joe-AO722>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Date: Tue, 15 Oct 2013 09:21:04 -0700
In-Reply-To: <20131015074123.GB25493@gmail.com>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <20131012172124.GA18241@gmail.com>
	 <20131014202854.GH26880@hmsreliant.think-freely.org>
	 <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
	 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
	 <1381790278.16896.2.camel@joe-AO722>
	 <1381790686.2045.24.camel@edumazet-glaptop.roam.corp.google.com>
	 <1381790982.16896.7.camel@joe-AO722> <20131015074123.GB25493@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 09:41 +0200, Ingo Molnar wrote:
> * Joe Perches <joe@perches.com> wrote:
> 
> > On Mon, 2013-10-14 at 15:44 -0700, Eric Dumazet wrote:
> > > On Mon, 2013-10-14 at 15:37 -0700, Joe Perches wrote:
> > > > On Mon, 2013-10-14 at 15:18 -0700, Eric Dumazet wrote:
> > > > > attached patch brings much better results
> > > > > 
> > > > > lpq83:~# ./netperf -H 7.7.8.84 -l 10 -Cc
> > > > > MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 7.7.8.84 () port 0 AF_INET
> > > > > Recv   Send    Send                          Utilization       Service Demand
> > > > > Socket Socket  Message  Elapsed              Send     Recv     Send    Recv
> > > > > Size   Size    Size     Time     Throughput  local    remote   local   remote
> > > > > bytes  bytes   bytes    secs.    10^6bits/s  % S      % S      us/KB   us/KB
> > > > > 
> > > > >  87380  16384  16384    10.00      8043.82   2.32     5.34     0.566   1.304  
> > > > > 
> > > > > diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
> > > > []
> > > > > @@ -68,7 +68,8 @@ static unsigned do_csum(const unsigned char *buff, unsigned len)
> > > > >  			zero = 0;
> > > > >  			count64 = count >> 3;
> > > > >  			while (count64) { 
> > > > > -				asm("addq 0*8(%[src]),%[res]\n\t"
> > > > > +				asm("prefetch 5*64(%[src])\n\t"
> > > > 
> > > > Might the prefetch size be too big here?
> > > 
> > > To be effective, you need to prefetch well ahead of time.
> > 
> > No doubt.
> 
> So why did you ask then?
> 
> > > 5*64 seems common practice (check arch/x86/lib/copy_page_64.S)
> > 
> > 5 cachelines for some processors seems like a lot.
> 
> What processors would that be?

The ones where conservatism in L1 cache use is good
because there are multiple threads running concurrently.

> Most processors have hundreds of cachelines even in their L1 cache. 

And sometimes that many executable processes too.

> Thousands in the L2 cache, up to hundreds of thousands.

Irrelevant because prefetch doesn't apply there.

Ingo, Eric _showed_ that the prefetch is good here.
How about looking at a little optimization to the minimal
prefetch that gives that level of performance.

You could argue that prefetching PAGE_SIZE or larger
would be better still otherwise.

I suspect that using a smaller multiple of
L1_CACHE_BYTES like 2 or 3 would perform the same.

The last time it was looked at for copy_page_64.S was
quite awhile ago.  It looks like maybe 2003.


