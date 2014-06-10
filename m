Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226AbaFJClh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 22:41:37 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43052 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349AbaFJClf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 22:41:35 -0400
Message-ID: <5396705D.5020507@kernel.dk>
Date: Mon, 09 Jun 2014 20:41:33 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Junxiao Bi <junxiao.bi@oracle.com>
CC: andi@lisas.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] block: make nr_requests tunable for loop
References: <1402367460-5305-1-git-send-email-junxiao.bi@oracle.com>
In-Reply-To: <1402367460-5305-1-git-send-email-junxiao.bi@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-09 20:31, Junxiao Bi wrote:
> commit 7b5a3522 (loop: Limit the number of requests in the bio list) limit
> the request number in loop queue to not over 128. Since the "request_fn" of
> loop device is null, the requests number is not allowed tuned. Make it tunable
> from sysfs can improve performance.
>
> The following test is done on a machine with 512M memory. The backend of
> /dev/loop1 is a nfs file.
>
> [root@bijx mnt]# cat /sys/block/loop0/queue/nr_requests
> 128
> [root@bijx mnt]# dd if=/dev/zero of=/dev/loop0 bs=1M count=5000
> 5000+0 records in
> 5000+0 records out
> 5242880000 bytes (5.2 GB) copied, 501.572 s, 10.5 MB/s
> [root@bijx mnt]#
> [root@bijx mnt]# echo 1024 > /sys/block/loop0/queue/nr_requests
> [root@bijx mnt]# cat /sys/block/loop0/queue/nr_requests
> 1024
> [root@bijx mnt]# dd if=/dev/zero of=/dev/loop0 bs=1M count=5000
> 5000+0 records in
> 5000+0 records out
> 5242880000 bytes (5.2 GB) copied, 464.481 s, 11.3 MB/s
>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>   block/blk-core.c  |    6 ++++++
>   block/blk-sysfs.c |    9 +++------
>   2 files changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 40d6548..58c4bd4 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -851,6 +851,12 @@ int blk_update_nr_requests(struct request_queue *q, unsigned int nr)
>   	q->nr_requests = nr;
>   	blk_queue_congestion_threshold(q);
>
> +	/* for loop device, return after set its nr_requests */
> +	if (!q->request_fn) {
> +		spin_unlock_irq(q->queue_lock);
> +		return 0;
> +	}

It'd be prettier to split this differently - something ala:

if (request_fn)
         blk_update_congestion_thresholds(q);

But I think you have a larger issue here... For the request lists, we 
update the congestion thresholds and wakeup anyone waiting, if we need 
to. There's no way to do that for loop, since the waitqueue is internal 
to loop.

-- 
Jens Axboe

