Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbaIEBaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 21:30:18 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58503 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaIEBaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 21:30:16 -0400
Message-ID: <5409122A.7020703@kernel.dk>
Date: Thu, 04 Sep 2014 19:30:18 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chuck Ebbert <cebbert.lkml@gmail.com>
CC: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] blk-mq: Cleanup blk_mq_tag_busy() and blk_mq_tag_idle()
References: <cover.1409775956.git.agordeev@redhat.com>	<1860c570e5efa8ece323a7ba20f3597bd5e99d25.1409775956.git.agordeev@redhat.com>	<54077B91.5040408@kernel.dk> <20140904202654.27f1d9e0@as>
In-Reply-To: <20140904202654.27f1d9e0@as>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 07:26 PM, Chuck Ebbert wrote:
> On Wed, 03 Sep 2014 14:35:29 -0600
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 09/03/2014 02:33 PM, Alexander Gordeev wrote:
> <snip>
>>> diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
>>> index 6206ed1..795ec3f 100644
>>> --- a/block/blk-mq-tag.h
>>> +++ b/block/blk-mq-tag.h
>>> @@ -66,23 +66,22 @@ enum {
>>>  	BLK_MQ_TAG_MAX		= BLK_MQ_TAG_FAIL - 1,
>>>  };
>>>  
>>> -extern bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *);
>>> +extern void __blk_mq_tag_busy(struct blk_mq_hw_ctx *);
>>>  extern void __blk_mq_tag_idle(struct blk_mq_hw_ctx *);
>>>  
>>>  static inline bool blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
>>>  {
>>> -	if (!(hctx->flags & BLK_MQ_F_TAG_SHARED))
>>> -		return false;
>>> -
>>> -	return __blk_mq_tag_busy(hctx);
>>> +	if (hctx->flags & BLK_MQ_F_TAG_SHARED) {
>>> +		__blk_mq_tag_busy(hctx);
>>> +		return true;
>>> +	}
>>> +	return false;
>>>  }
>>
>> The normal/fast path here is the flag NOT being set, which is why it
>> was coded that way to put the fast path inline.
>>
>>>  
>>>  static inline void blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
>>>  {
>>> -	if (!(hctx->flags & BLK_MQ_F_TAG_SHARED))
>>> -		return;
>>> -
>>> -	__blk_mq_tag_idle(hctx);
>>> +	if (hctx->flags & BLK_MQ_F_TAG_SHARED)
>>> +		__blk_mq_tag_idle(hctx);
>>>  }
>>
>> Ditto
> 
> Shouldn't it just add unlikely() then? That way it's obvious what the
> common case is, instead of relying on convoluted code.

It's a common construct. Besides, if you find a flag-not-set check
convoluted, then I hope you are not programming anything I use. That's a
bit of a straw man, imho.

-- 
Jens Axboe

