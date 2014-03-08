Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaCHA2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 19:28:25 -0500
Received: from g2t2353.austin.hp.com ([15.217.128.52]:32774 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaCHA2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 19:28:23 -0500
Message-ID: <1394238498.11969.22.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 6/7] x86: mm: set TLB flush tunable to sane value
From: Davidlohr Bueso <davidlohr@hp.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        ak@linux.intel.com, kirill.shutemov@linux.intel.com, mgorman@suse.de,
        alex.shi@linaro.org, x86@kernel.org, linux-mm@kvack.org,
        dave.hansen@linux.intel.com
Date: Fri, 07 Mar 2014 16:28:18 -0800
In-Reply-To: <5319FEA1.50107@sr71.net>
References: <20140306004519.BBD70A1A@viggo.jf.intel.com>
		 <20140306004529.5510B23D@viggo.jf.intel.com>
	 <1394157304.2555.21.camel@buesod1.americas.hpqcorp.net>
	 <5319FEA1.50107@sr71.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 09:15 -0800, Dave Hansen wrote:
> On 03/06/2014 05:55 PM, Davidlohr Bueso wrote:
> > On Wed, 2014-03-05 at 16:45 -0800, Dave Hansen wrote:
> >> From: Dave Hansen <dave.hansen@linux.intel.com>
> >>
> >> Now that we have some shiny new tracepoints, we can actually
> >> figure out what the heck is going on.
> >>
> >> During a kernel compile, 60% of the flush_tlb_mm_range() calls
> >> are for a single page.  It breaks down like this:
> > 
> > It would be interesting to see similar data for opposite workloads with
> > more random access patterns. That's normally when things start getting
> > fun in the tlb world.
> 
> First of all, thanks for testing.  It's much appreciated!
> 
> Any suggestions for opposite workloads?

I was actually thinking of ebizzy as well.

> I've seen this tunable have really heavy effects on ebizzy.  It fits
> almost entirely within the itlb and if we are doing full flushes, it
> eats the itlb and increases the misses about 10x.  Even putting this
> tunable above 500 pages (which is pretty insane) didn't help it.

Interesting, I didn't expect the misses to be as severe. So I guess what
you say is that this issue is seen even with how we currently have
things.


> Things that thrash the TLB don't really care if someone invalidates
> their TLB since they're thrashing it anyway.

That's a really good point.

> I've had a really hard time finding workloads that _care_ or are
> affected by small changes in this tunable.  That's one of the reasons I
> tried to simplify it: it's just not worth the complexity.

I agree, since we aren't seeing much performance differences anyway I
guess it simply doesn't matter. I can see it perhaps as a factor for
virtualized workloads in the pre-tagged tlb era but not so much
nowadays. In any case I've also asked a colleague to see if he can
produce any interesting results with this patchset on his kvm workloads
but don't expect much surprises.

So all in all I definitely like this cleanup, and things are simplified
significantly without any apparent performance hits. The justification
for the ceiling being 33 seems pretty prudent, and heck, it can be
modified anyway by users. An additional suggestion would be to comment
this magic number, in the code.

Thanks,
Davidlohr

