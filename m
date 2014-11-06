Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaKFNlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:41:08 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:38369 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKFNlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:41:04 -0500
Message-ID: <545B7A6D.8040208@acm.org>
Date: Thu, 06 Nov 2014 14:41:01 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <Elliott@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-mq: Avoid that I/O hangs in bt_get()
References: <54328A97.3030201@acm.org> <5432D414.4060408@kernel.dk> <5432E524.90407@kernel.dk> <5433A85E.2070207@acm.org>
In-Reply-To: <5433A85E.2070207@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/14 10:46, Bart Van Assche wrote:
> Thanks for looking into this. I can't reproduce the I/O lockup after
> having reverted my patch and after having applied your patch. In the
> test I ran fio was started with the following command-line options:
>
> fio --bs=512 --ioengine=libaio --rw=randread --buffered=0 --numjobs=12
> --iodepth=128 --iodepth_batch=64 --iodepth_batch_complete=64 --thread
> --norandommap --loops=2147483648 --runtime=3600 --group_reporting
> --gtod_reduce=1 --name=/dev/sdo --filename=/dev/sdo --invalidate=1
>
> This job was run on a system with 12 CPU threads and against a SCSI
> initiator driver for which the number of hardware contexts had been set
> to 6. Queue depth per hardware queue was set to 127:
> $ cat /sys/class/scsi_host/host10/can_queue
> 127

(replying to my own e-mail)

Hello Jens,

With kernel 3.18-rc3 and with can_queue=62 I can trigger a hang in 
bt_get() easily. The four call traces reported by echo w > 
/proc/sysrq-trigger are as follows:

Call Trace:
  [<ffffffff813d60ac>] io_schedule+0x9c/0x130
  [<ffffffff811b41bf>] bt_get+0xef/0x180
  [<ffffffff811b450f>] blk_mq_get_tag+0x9f/0xd0
  [<ffffffff811b09c6>] __blk_mq_alloc_request+0x16/0x1f0
  [<ffffffff811b1da3>] blk_mq_map_request+0x123/0x130
  [<ffffffff811b31c9>] blk_mq_make_request+0x69/0x280
  [<ffffffff811a8420>] generic_make_request+0xc0/0x110
  [<ffffffff811a84d4>] submit_bio+0x64/0x130
  [<ffffffff81147848>] do_blockdev_direct_IO+0x1dc8/0x2da0
  [<ffffffff81148867>] __blockdev_direct_IO+0x47/0x50
  [<ffffffff811435c9>] blkdev_direct_IO+0x49/0x50
  [<ffffffff810c8ce6>] generic_file_read_iter+0x546/0x610
  [<ffffffff81143962>] blkdev_read_iter+0x32/0x40
  [<ffffffff81155358>] aio_run_iocb+0x1f8/0x400
  [<ffffffff811562c1>] do_io_submit+0x121/0x490
  [<ffffffff8115663b>] SyS_io_submit+0xb/0x10
  [<ffffffff813d9612>] system_call_fastpath+0x12/0x17

Please let me know if you need more information.

Bart.
