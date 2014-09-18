Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbaIRBdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 21:33:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37011 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983AbaIRBdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 21:33:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140917164850.GB18472@lst.de>
References: <1410947278-15733-1-git-send-email-ming.lei@canonical.com>
	<1410947278-15733-3-git-send-email-ming.lei@canonical.com>
	<20140917164850.GB18472@lst.de>
Date: Thu, 18 Sep 2014 09:33:35 +0800
Message-ID: <CACVXFVOsHO28yTQN8uPgOgtrTjrs52Le01wChxdYyjeBr0ZcOQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] blk-mq: remove unnecessary blk_clear_rq_complete()
From: Ming Lei <ming.lei@canonical.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ming Lei <ming.lei@canoical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 12:48 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Wed, Sep 17, 2014 at 05:47:58PM +0800, Ming Lei wrote:
>> From: Ming Lei <ming.lei@canoical.com>
>>
>> This patch removes two unnecessary blk_clear_rq_complete(),
>> the REQ_ATOM_COMPLETE flag is cleared inside blk_mq_start_request(),
>> so:
>>
>>       - The blk_clear_rq_complete() in blk_flush_restore_request()
>>       needn't because the request will be freed later, and clearing
>>       it here may open a small race window with timeout.
>
> This one is defintively correct, blk_mq_end_io should take care of this.
>
>>       - The blk_clear_rq_complete() in blk_mq_requeue_request() isn't
>>       necessary too, even though REQ_ATOM_STARTED is cleared in
>>       __blk_mq_requeue_request(), in theory it still may cause a small
>>       race window with timeout since the two clear_bit() may be
>>       reordered.
>
> Why yo you think it's not nessecary?  The request is not in the drivers

The COMPLETED flag will be cleared in blk_mq_start_request(), so
it needn't to be cleared here, and it is a bit early and might cause
a tiny race window.

> hand at this point, so it should not be marked started.  Maybe I'm missing
> something, but this sounds like it could very likely cause regressions.

The STARTED flag has been cleared in __blk_mq_requeue_request(),
I mean the COMPLETED flag, consider the following situation:

- one req is queued to driver, and the req is completed from
the device just before its timeout expired
- the driver checks the result and finds it need to requeue for some reason
- blk_mq_requeue_request() is called to requeue the req
- COMPLETED is cleared before clearing STARTED because of
writes reorder
- timeout just comes between the two writes
- then the request may be completed another time because of timeout

Thanks,
