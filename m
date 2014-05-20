Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbaETDU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 23:20:28 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:43822 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaETDU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 23:20:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140519151824.GA21762@lst.de>
References: <1400511950-18522-1-git-send-email-tom.leiming@gmail.com>
	<20140519151824.GA21762@lst.de>
Date: Tue, 20 May 2014 11:20:25 +0800
Message-ID: <CACVXFVNprzhEpXGKze=A4T2b-y35vXRxRTOUqpywu+Et=t37Kw@mail.gmail.com>
Subject: Re: [PATCH] block: mq flush: fix race between IPI handler and mq
 flush worker
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 11:18 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, May 19, 2014 at 11:05:50PM +0800, Ming Lei wrote:
>> Another simple fix is to disable ipi for flush request, but looks
>> this one should be better.
>
> I think the first thing is to bite the bullet and sort out and document
> the various unions in struct request for real.

Considered the problem can be reproduced easily and cause
data loss on kvm-guest, I hope fix can be seen in 3.15. Also
it should be backported to 3.14 because someone may
enable ctx->ipi_redirect.

Thinking it further, looks the patch is fine:

- sizeof(call_single_data) and sizeof(work_struct) is very close
and both are not small, so it is reasonable to put the two in
one union for saving request space

- the conflict on the two structures just happens with flush
requests because rq->requeue_work is only used to queue
flush requests

- in the flush sequence, the conflict won't happen on request
with data, so it only happens with completing and queueing
PREFLUSH/POSTFLUSH request.

Any comments and suggestions?


Thanks,
-- 
Ming Lei
