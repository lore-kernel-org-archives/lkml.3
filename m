Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaFYDBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 23:01:06 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39699 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaFYDBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 23:01:04 -0400
Message-ID: <53AA3B6B.1040103@kernel.dk>
Date: Tue, 24 Jun 2014 21:00:59 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-mq: run hw queue asynchronously in blk_mq_start_hw_queues
References: <1403621588-25109-1-git-send-email-tom.leiming@gmail.com> <CACVXFVMWDBEhRhKQ1V2O9sWbAdQNb_RM0Nz_BA7Cn7P_OrvndQ@mail.gmail.com>
In-Reply-To: <CACVXFVMWDBEhRhKQ1V2O9sWbAdQNb_RM0Nz_BA7Cn7P_OrvndQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030200000606090706060501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030200000606090706060501
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-06-24 20:42, Ming Lei wrote:
> On Tue, Jun 24, 2014 at 10:53 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>>  From API view, it isn't good to run all hw queues synchronously
>> in one context, since it isn't correct for multi hw queue case.
>>
>> So this patch adds 'async' parameter to blk_mq_start_hw_queue(),
>> and make blk_mq_start_hw_queues() to run hw queues asynchronously
>> at default.
>
> BTW, without the change, it is easy to trigger the WARN_ON() in
> __blk_mq_run_hw_queue().

Why not just have it call blk_mq_run_hw_queue()? Pass in async == false, 
but let the cpumask logic sort out if we need to force an async run.

-- 
Jens Axboe


--------------030200000606090706060501
Content-Type: text/x-patch;
 name="start.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="start.patch"

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0ef2dc7f01bf..ad69ef657e85 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -878,7 +878,7 @@ void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx)
 	clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
 
 	preempt_disable();
-	__blk_mq_run_hw_queue(hctx);
+	blk_mq_run_hw_queue(hctx, false);
 	preempt_enable();
 }
 EXPORT_SYMBOL(blk_mq_start_hw_queue);

--------------030200000606090706060501--
