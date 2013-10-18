Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab3JRPNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:13:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:54930 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab3JRPNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:13:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,523,1378882800"; 
   d="scan'208";a="413297483"
Date: Fri, 18 Oct 2013 09:13:49 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Matias Bjorling <m@bjorling.me>
cc: axboe@kernel.dk, willy@linux.intel.com, keith.busch@intel.com,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH 3/3] NVMe: Convert to blk-mq
In-Reply-To: <1382102062-22270-4-git-send-email-m@bjorling.me>
Message-ID: <alpine.LRH.2.03.1310180837140.4763@AMR>
References: <1382102062-22270-1-git-send-email-m@bjorling.me> <1382102062-22270-4-git-send-email-m@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013, Matias Bjorling wrote:
> The nvme driver implements itself as a bio-based driver. This primarily
> because of high lock congestion for high-performance nvm devices. To
> remove the congestion within the traditional block layer, a multi-queue
> block layer is being implemented.
>
> This patch converts the current bio-based approach to work with the
> request-based approach found in the multi-queue block layer. This means
> that bio responsibility is moved from the driver, into the block layer.
> In return the block layer packs request structures and submit them to
> the nvme  according to the features/limits of nvme hardware.
>
> The patch consists of:
> * Initialization of multi-queue data structures
> * Conversion of bio function call into request function calls.
> * Separate cmdid patchs for admin and normal queues.
> * Bio splits according to NOT_VIRT_MERGEABLE are assumed to be handled
>   by blk-mq.
> * Uses the timeout framework blk-mq where possible.
>
> Signed-off-by: Matias Bjorling <m@bjorling.me>
> ---
> drivers/block/nvme-core.c | 765 +++++++++++++++++++++++-----------------------
> drivers/block/nvme-scsi.c |  39 +--
> include/linux/nvme.h      |   7 +-
> 3 files changed, 385 insertions(+), 426 deletions(-)
>
> diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
> index e99a30a..36bf45c 100644
> --- a/drivers/block/nvme-core.c
> +++ b/drivers/block/nvme-core.c

[snip]

> -static void nvme_start_io_acct(struct bio *bio)
> +static void nvme_start_io_acct(struct request *rq)
> {
> -	struct gendisk *disk = bio->bi_bdev->bd_disk;
> -	const int rw = bio_data_dir(bio);
> +	struct gendisk *disk = rq->rq_disk;
> +	const int rw = rq_data_dir(rq);
> 	int cpu = part_stat_lock();
> 	part_round_stats(cpu, &disk->part0);
> 	part_stat_inc(cpu, &disk->part0, ios[rw]);
> -	part_stat_add(cpu, &disk->part0, sectors[rw], bio_sectors(bio));
> +	part_stat_add(cpu, &disk->part0, sectors[rw], blk_rq_sectors(rq));
> 	part_inc_in_flight(&disk->part0, rw);
> 	part_stat_unlock();
> }
>
> -static void nvme_end_io_acct(struct bio *bio, unsigned long start_time)
> +static void nvme_end_io_acct(struct request *rq, unsigned long start_time)
> {
> -	struct gendisk *disk = bio->bi_bdev->bd_disk;
> -	const int rw = bio_data_dir(bio);
> +	struct gendisk *disk = rq->rq_disk;
> +	const int rw = rq_data_dir(rq);
> 	unsigned long duration = jiffies - start_time;
> 	int cpu = part_stat_lock();
> 	part_stat_add(cpu, &disk->part0, ticks[rw], duration);
> @@ -342,23 +370,26 @@ static void nvme_end_io_acct(struct bio *bio, unsigned long start_time)
> 	part_stat_unlock();
> }

I think you can remove the io accounting, right? These were added here
because the diskstats are not updated in the block layer for bio-based
block drivers.

> @@ -715,32 +606,47 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
> 		dma_dir = DMA_FROM_DEVICE;
> 	}
>
> -	result = nvme_map_bio(nvmeq, iod, bio, dma_dir, psegs);
> -	if (result <= 0)
> +	if (nvme_map_rq(nvmeq, iod, rq, dma_dir))
> 		goto free_cmdid;
> -	length = result;
>
> -	cmnd->rw.command_id = cmdid;
> +	length = blk_rq_bytes(rq);
> +
> +	cmnd->rw.command_id = rq->tag;

The command ids have to be unique on a submission queue. Since each
namespace's blk-mq has its own 'tags' used as command ids here but share
submission queues, what's stopping the tags for commands sent to namespace
1 from clashing with tags for namespace 2?

I think this would work better if one blk-mq was created per device
rather than namespace. It would fix the tag problem above and save a
lot of memory potentially wasted on millions of requests allocated that
can't be used.

Do you know how/if this is planned to work with scsi? Will there be one
blk-mq per LUN or per host controller?
