Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab3HGHbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:31:55 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17367 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354Ab3HGHby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:31:54 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-2f-5201f7e8f082
Message-id: <1375860711.17079.16.camel@AMDC1943>
Subject: Re: [RFC PATCH 1/4] zbud: use page ref counter for zbud pages
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Bob Liu <bob.liu@oracle.com>
Date: Wed, 07 Aug 2013 09:31:51 +0200
In-reply-to: <20130806185104.GD5765@medulla.variantweb.net>
References: <1375771361-8388-1-git-send-email-k.kozlowski@samsung.com>
 <1375771361-8388-2-git-send-email-k.kozlowski@samsung.com>
 <20130806185104.GD5765@medulla.variantweb.net>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xK7ovvjMGGczdoWExZ/0aNouNM9az
	WnSdmspicbbpDbvF5V1z2CzurfnParH2yF12i8nvnjFaHNq3it1iXvtLVgcuj02fJrF7nJjx
	m8XjwaHNLB4fn95i8ejbsorRY/Ppao/Pm+QC2KO4bFJSczLLUov07RK4Ms79uMJUcE6g4tWJ
	A4wNjCd4uhg5OSQETCTOrD3FCmGLSVy4t56ti5GLQ0hgKaPE3olbmSGcz4wSp5feBqri4OAV
	MJA43i4M0iAs4Cbx6sxsdhCbTcBYYvPyJWwgtoiAvkT37BVgvcwCj5kkLp9pBCtiEVCVuNXw
	GMzmFLCW2HLyPCPEgi2MEpNeL2ICSTALqEtMmreIGeIkJYnd7Z3sEHF5ic1r3oLFeQUEJX5M
	vscygVFgFpKWWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJDK+7GBcfMzq
	EKMAB6MSD2+FGGOQEGtiWXFl7iFGCQ5mJRFekfdAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYw2
	YoLOUqK/f2otvHd1k18ez857dW9fdsn7eF5qMmru5OCdWMt417Xh4e51H/567dqyO7b2Y4H3
	2ier5Uvj/jIeYt20MyVaziBU5P1106VJs1ziE5iSblas2L69cs3+4Au1BQmxn6sdfO2e7zu2
	/TPHPxe3fAaxa7d2iHdx/9SL8dx15emNt1OVWIozEg21mIuKEwGzsSaJagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On wto, 2013-08-06 at 13:51 -0500, Seth Jennings wrote:
> I like the idea.  I few things below.  Also agree with Bob the
> s/rebalance/adjust/ for rebalance_lists().
OK.

> s/else if/if/ since the if above returns if true.
Sure.

> > +		/* zbud_free() or zbud_alloc() */
> > +		int freechunks = num_free_chunks(zhdr);
> > +		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
> > +	} else {
> > +		/* zbud_alloc() */
> > +		list_add(&zhdr->buddy, &pool->buddied);
> > +	}
> > +	/* Add/move zbud page to beginning of LRU */
> > +	if (!list_empty(&zhdr->lru))
> > +		list_del(&zhdr->lru);
> 
> We don't want to reinsert to the LRU list if we have called zbud_free()
> on a zbud page that previously had two buddies.  This code causes the
> zbud page to move to the front of the LRU list which is not what we want.

Right, I'll fix it.


> > @@ -326,10 +370,10 @@ found:
> >  void zbud_free(struct zbud_pool *pool, unsigned long handle)
> >  {
> >  	struct zbud_header *zhdr;
> > -	int freechunks;
> > 
> >  	spin_lock(&pool->lock);
> >  	zhdr = handle_to_zbud_header(handle);
> > +	BUG_ON(zhdr->last_chunks == 0 && zhdr->first_chunks == 0);
> 
> Not sure we need this.  Maybe, at most, VM_BUG_ON()?

Actually it is somehow a leftover after debugging so I don't mind
removing it completely.


> > @@ -411,11 +438,24 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
> >  		return -EINVAL;
> >  	}
> >  	for (i = 0; i < retries; i++) {
> > +		if (list_empty(&pool->lru)) {
> > +			/*
> > +			 * LRU was emptied during evict calls in previous
> > +			 * iteration but put_zbud_page() returned 0 meaning
> > +			 * that someone still holds the page. This may
> > +			 * happen when some other mm mechanism increased
> > +			 * the page count.
> > +			 * In such case we succedded with reclaim.
> > +			 */
> > +			return 0;
> > +		}
> >  		zhdr = list_tail_entry(&pool->lru, struct zbud_header, lru);
> > +		BUG_ON(zhdr->first_chunks == 0 && zhdr->last_chunks == 0);
> 
> Again here.
I agree.


Thanks for comments,
Krzysztof


