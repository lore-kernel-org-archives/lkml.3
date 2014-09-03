Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbaICUnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:43:15 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34104 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbaICUnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:43:14 -0400
Message-ID: <54077D61.3030707@kernel.dk>
Date: Wed, 03 Sep 2014 14:43:13 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] blk-mq: Fix formula to calculate fair share of tags
References: <cover.1409775956.git.agordeev@redhat.com> <e8d8cf4c5c0491eabb6d1dba6fd44a3964837132.1409775956.git.agordeev@redhat.com>
In-Reply-To: <e8d8cf4c5c0491eabb6d1dba6fd44a3964837132.1409775956.git.agordeev@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 02:33 PM, Alexander Gordeev wrote:
> Fair share of tags is number of tags diveded on number
> of users. Not sure why it is different.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-mq-tag.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index d1eb579..1b9c949 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -127,7 +127,7 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
>  	/*
>  	 * Allow at least some tags
>  	 */
> -	depth = max((bt->depth + users - 1) / users, 4U);
> +	depth = max(bt->depth / users, 4U);
>  	return atomic_read(&hctx->nr_active) < depth;

It's normal rounding, you'll round down otherwise. Say you have a tag
depth of 31 (SATA), and 4 active users. Your change would make that 7
tags per user, leaving 3 idle. If you round up, you end up with 8 tags
instead. That will potentially just leave some sleeping for a new tag,
but at least you'll exhaust the space.

-- 
Jens Axboe

