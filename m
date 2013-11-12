Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab3KLUiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:38:02 -0500
Received: from smtprelay0231.hostedemail.com ([216.40.44.231]:56771 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752335Ab3KLUhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:37:55 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2553:2559:2562:2828:2904:2918:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3871:3872:3873:3874:4321:5007:7652:7903:9108:10004:10400:10848:11232:11658:11914:12043:12291:12295:12296:12517:12519:12555:12663:12683:12740:13146:13230,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wool43_61dc5cca2f204
X-Filterd-Recvd-Size: 3681
Message-ID: <1384288681.3665.22.camel@joe-AO722>
Subject: Re: [Fwd: Re: [PATCH v2 2/2] x86: add prefetching to do_csum]
From: Joe Perches <joe@perches.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: netdev <netdev@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 12 Nov 2013 12:38:01 -0800
In-Reply-To: <20131112195005.GD19780@hmsreliant.think-freely.org>
References: <1384220542.4771.23.camel@joe-AO722>
	 <20131112171239.GC19780@hmsreliant.think-freely.org>
	 <1384277615.3665.10.camel@joe-AO722>
	 <20131112195005.GD19780@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 14:50 -0500, Neil Horman wrote:
> On Tue, Nov 12, 2013 at 09:33:35AM -0800, Joe Perches wrote:
> > On Tue, 2013-11-12 at 12:12 -0500, Neil Horman wrote:
[]
> > > So, the numbers are correct now that I returned my hardware to its previous
> > > interrupt affinity state, but the trend seems to be the same (namely that there
> > > isn't a clear one).  We seem to find peak performance around a readahead of 2
> > > cachelines, but its very small (about 3%), and its inconsistent (larger set
> > > sizes fall to either side of that stride).  So I don't see it as a clear win.  I
> > > still think we should probably scrap the readahead for now, just take the perf
> > > bits, and revisit this when we can use the vector instructions or the
> > > independent carry chain instructions to improve this more consistently.
> > > 
> > > Thoughts
> > 
> > Perhaps a single prefetch, not of the first addr but of
> > the addr after PREFETCH_STRIDE would work best but only
> > if length is > PREFETCH_STRIDE.
> > 
> > I'd try:
> > 
> > 	if (len > PREFETCH_STRIDE)
> > 		prefetch(buf + PREFETCH_STRIDE);
> > 	while (count64) {
> > 		etc...
> > 	}
> > 
> > I still don't know how much that impacts very short lengths.
> > Can you please add a 20 byte length to your tests?
> Sure, I modified the code so that we only prefetched 2 cache lines ahead, but
> only if the overall length of the input buffer is more than 2 cache lines.
> Below are the results (all counts are the average of 1000000 iterations of the
> csum operation, as previous tests were, I just omitted that column).
> 
> len	set	cycles/byte	cycles/byte	improvement
> 		no prefetch	prefetch
> ===========================================================
> 20B	64MB	45.014989	44.402432	1.3%
> 20B	128MB	44.900317	46.146447	-2.7%
> 20B	256MB	45.303223	48.193623	-6.3%
> 20B	512MB	45.615301	44.486872	2.2%
[]
> I'm still left thinking we should just abandon the prefetch at this point and
> keep the perf code until we have new instructions to help us with this further,
> unless you see something I dont.

I tend to agree but perhaps the 3% performance
increase with a prefetch for longer lengths is
actually significant and desirable.

It doesn't seem you've done the test I suggested
where prefetch is done only for
"len > PREFETCH_STRIDE".

Is it ever useful to do a prefetch of the
address/data being accessed by the next
instruction?

Anyway, thanks for doing all the work.

Joe

