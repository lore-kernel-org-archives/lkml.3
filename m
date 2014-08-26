Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927AbaHZHyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:54:20 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:47192 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaHZHyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:54:18 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 26 Aug 2014 16:55:11 +0900
From: Minchan Kim <minchan@kernel.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, juno.choi@lge.com,
        seungho1.park@lge.com, Luigi Semenzato <semenzato@google.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Dan Streetman <ddstreet@ieee.org>, ds2horner@gmail.com
Subject: Re: [PATCH v5 3/4] zram: zram memory size limitation
Message-ID: <20140826075511.GI11319@bbox>
References: <1408925156-11733-1-git-send-email-minchan@kernel.org>
 <1408925156-11733-4-git-send-email-minchan@kernel.org>
 <20140826073730.GA1975@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140826073730.GA1975@js1304-P5Q-DELUXE>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Joonsoo,

On Tue, Aug 26, 2014 at 04:37:30PM +0900, Joonsoo Kim wrote:
> On Mon, Aug 25, 2014 at 09:05:55AM +0900, Minchan Kim wrote:
> > @@ -513,6 +540,14 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  		ret = -ENOMEM;
> >  		goto out;
> >  	}
> > +
> > +	if (zram->limit_pages &&
> > +		zs_get_total_pages(meta->mem_pool) > zram->limit_pages) {
> > +		zs_free(meta->mem_pool, handle);
> > +		ret = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> >  	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_WO);
> 
> Hello,
> 
> I don't follow up previous discussion, so I could be wrong.
> Why this enforcement should be here?
> 
> I think that this has two problems.
> 1) alloc/free happens unnecessarilly if we have used memory over the
> limitation.

True but firstly, I implemented the logic in zsmalloc, not zram but
as I described in cover-letter, it's not a requirement of zsmalloc
but zram so it should be in there. If every user want it in future,
then we could move the function into zsmalloc. That's what we
concluded in previous discussion.

Another idea is we could call zs_get_total_pages right before zs_malloc
but the problem is we cannot know how many of pages are allocated
by zsmalloc in advance.
IOW, zram should be blind on zsmalloc's internal.

About alloc/free cost once if it is over the limit,
I don't think it's important to consider.
Do you have any scenario in your mind to consider alloc/free cost
when the limit is over?

> 2) Even if this request doesn't do new allocation, it could be failed
> due to other's allocation. There is time gap between allocation and
> free, so legimate user who want to use preallocated zsmalloc memory
> could also see this condition true and then he will be failed.

Yeb, we already discussed that. :)
Such false positive shouldn't be a severe problem if we can keep a
promise that zram user cannot exceed mem_limit.

> 
> Thanks.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
