Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaHPIG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 04:06:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59147 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaHPIGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 04:06:25 -0400
MIME-Version: 1.0
In-Reply-To: <53EE3312.2070108@kernel.dk>
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
	<1408031441-31156-5-git-send-email-ming.lei@canonical.com>
	<53EE3312.2070108@kernel.dk>
Date: Sat, 16 Aug 2014 15:49:27 +0800
Message-ID: <CACVXFVNDeWSv7-ggM5T1mOG5chBobfFueJwbAgLLMxrmfWc_3w@mail.gmail.com>
Subject: Re: [PATCH v1 4/9] blk-mq: introduce init_flush_rq_fn callback in 'blk_mq_ops'
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/14, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/14/2014 09:50 AM, Ming Lei wrote:
>> Currently pdu of the flush rq is simlpy copied from another rq,
>> it isn't enough to initialize pointer field well, so introduce
>> the callback for driver to handle the case easily.
>
> This is the only patch I don't really like. Can't we make do with
> calling ->init_request() for this instead of having to add another
> (weird) hook?

I considered ->init_request() before, but looks there are some problems:

- from API view, both 'hctx_idx' and 'request_idx' parameter don't make
sense for flush rq since it beongs to request queue instead of any one
of hctx

- init_request()/exit_request() are weird too, since they will be called
for queuing every flush req, and they should have been called one
shot

- it is called before queuing each flush req, and might introduce a bit cost
unnecessarily if init_request does lots of stuff

- using init_request may break some current drivers(like scsi)

Now I feel ->init_flush_rq() isn't good too, how about introducing
prepare_flush_rq() and unprepare_flush_rq()? And they can be
lightweight and have document benefit at least.

Thanks,
-- 
Ming Lei
