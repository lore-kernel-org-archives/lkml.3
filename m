Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaIEB1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 21:27:00 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:50245 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaIEB07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 21:26:59 -0400
Date: Thu, 4 Sep 2014 20:26:54 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] blk-mq: Cleanup blk_mq_tag_busy() and
 blk_mq_tag_idle()
Message-ID: <20140904202654.27f1d9e0@as>
In-Reply-To: <54077B91.5040408@kernel.dk>
References: <cover.1409775956.git.agordeev@redhat.com>
	<1860c570e5efa8ece323a7ba20f3597bd5e99d25.1409775956.git.agordeev@redhat.com>
	<54077B91.5040408@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep 2014 14:35:29 -0600
Jens Axboe <axboe@kernel.dk> wrote:

> On 09/03/2014 02:33 PM, Alexander Gordeev wrote:
<snip>
> > diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
> > index 6206ed1..795ec3f 100644
> > --- a/block/blk-mq-tag.h
> > +++ b/block/blk-mq-tag.h
> > @@ -66,23 +66,22 @@ enum {
> >  	BLK_MQ_TAG_MAX		= BLK_MQ_TAG_FAIL - 1,
> >  };
> >  
> > -extern bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *);
> > +extern void __blk_mq_tag_busy(struct blk_mq_hw_ctx *);
> >  extern void __blk_mq_tag_idle(struct blk_mq_hw_ctx *);
> >  
> >  static inline bool blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
> >  {
> > -	if (!(hctx->flags & BLK_MQ_F_TAG_SHARED))
> > -		return false;
> > -
> > -	return __blk_mq_tag_busy(hctx);
> > +	if (hctx->flags & BLK_MQ_F_TAG_SHARED) {
> > +		__blk_mq_tag_busy(hctx);
> > +		return true;
> > +	}
> > +	return false;
> >  }
> 
> The normal/fast path here is the flag NOT being set, which is why it
> was coded that way to put the fast path inline.
> 
> >  
> >  static inline void blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
> >  {
> > -	if (!(hctx->flags & BLK_MQ_F_TAG_SHARED))
> > -		return;
> > -
> > -	__blk_mq_tag_idle(hctx);
> > +	if (hctx->flags & BLK_MQ_F_TAG_SHARED)
> > +		__blk_mq_tag_idle(hctx);
> >  }
> 
> Ditto

Shouldn't it just add unlikely() then? That way it's obvious what the
common case is, instead of relying on convoluted code.
