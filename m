Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935AbaKCFDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 00:03:31 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:53410 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaKCFD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 00:03:29 -0500
MIME-Version: 1.0
In-Reply-To: <1414933255-3795-1-git-send-email-richard@nod.at>
References: <1414933255-3795-1-git-send-email-richard@nod.at>
Date: Mon, 3 Nov 2014 13:03:28 +0800
Message-ID: <CACVXFVP9K6t-u-sjBQ57r_9kzu-yGdLLGYyX2d+ryJBSxMkAJQ@mail.gmail.com>
Subject: Re: [PATCH] UBI: Block: Add blk-mq support
From: Ming Lei <tom.leiming@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@fb.com>,
        dedekind1@gmail.com, ezequiel.garcia@free-electrons.com,
        David Woodhouse <dwmw2@infradead.org>, computersforpeace@gmail.com,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2014 at 9:00 PM, Richard Weinberger <richard@nod.at> wrote:
> Convert the driver to blk-mq.

It is always helpful to include some performance comparison data(
randrw, rw) between blk-mq and non-mq.

>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/block.c | 241 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 143 insertions(+), 98 deletions(-)
>
> diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
> index 8876c7d..aac956a 100644
> --- a/drivers/mtd/ubi/block.c
> +++ b/drivers/mtd/ubi/block.c
> @@ -42,11 +42,12 @@
>  #include <linux/list.h>
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> -#include <linux/vmalloc.h>
>  #include <linux/mtd/ubi.h>
>  #include <linux/workqueue.h>
>  #include <linux/blkdev.h>
> +#include <linux/blk-mq.h>
>  #include <linux/hdreg.h>
> +#include <linux/scatterlist.h>
>  #include <asm/div64.h>
>
>  #include "ubi-media.h"
> @@ -61,12 +62,25 @@
>  /* Maximum number of comma-separated items in the 'block=' parameter */
>  #define UBIBLOCK_PARAM_COUNT 2
>
> +#define UBIBLOCK_SG_COUNT 64
> +
>  struct ubiblock_param {
>         int ubi_num;
>         int vol_id;
>         char name[UBIBLOCK_PARAM_LEN+1];
>  };
>
> +struct ubiblock_pdu {
> +       struct request *req;
> +       sector_t req_sec;
> +       int req_len;
> +       struct ubiblock *dev;
> +       struct work_struct work;
> +       int sglist_pos;
> +       int sgpage_pos;
> +       struct scatterlist sglist[UBIBLOCK_SG_COUNT];
> +};
> +
>  /* Numbers of elements set in the @ubiblock_param array */
>  static int ubiblock_devs __initdata;
>
> @@ -84,11 +98,10 @@ struct ubiblock {
>         struct request_queue *rq;
>
>         struct workqueue_struct *wq;
> -       struct work_struct work;
>
>         struct mutex dev_mutex;
> -       spinlock_t queue_lock;
>         struct list_head list;
> +       struct blk_mq_tag_set tag_set;
>  };
>
>  /* Linked list of all ubiblock instances */
> @@ -181,28 +194,53 @@ static struct ubiblock *find_dev_nolock(int ubi_num, int vol_id)
>         return NULL;
>  }
>
> -static int ubiblock_read_to_buf(struct ubiblock *dev, char *buffer,
> -                               int leb, int offset, int len)
> +static int ubiblock_read_to_sg(struct ubiblock_pdu *pdu, int leb,
> +                               int leb_offset, int len)
>  {
> +       int to_read;
>         int ret;
> +       struct scatterlist *sg;
> +       struct ubiblock *dev = pdu->dev;
> +
> +       for (;;) {
> +               sg = &pdu->sglist[pdu->sglist_pos];
> +               if (len < sg->length - pdu->sgpage_pos)
> +                       to_read = len;
> +               else
> +                       to_read = sg->length - pdu->sgpage_pos;
> +
> +               ret = ubi_read(dev->desc, leb, sg_virt(sg) + pdu->sgpage_pos,
> +                              leb_offset, to_read);
> +               if (ret < 0)
> +                       goto out;
>
> -       ret = ubi_read(dev->desc, leb, buffer, offset, len);
> -       if (ret) {
> -               ubi_err("%s: error %d while reading from LEB %d (offset %d, "
> -                       "length %d)", dev->gd->disk_name, ret, leb, offset,
> -                       len);
> -               return ret;
> +               leb_offset += to_read;
> +               len -= to_read;
> +               if (!len) {
> +                       pdu->sgpage_pos += to_read;
> +                       if (pdu->sgpage_pos == sg->length) {
> +                               pdu->sglist_pos++;
> +                               pdu->sgpage_pos = 0;
> +                       }
> +
> +                       break;
> +               }
> +
> +               pdu->sglist_pos++;
> +               pdu->sgpage_pos = 0;
>         }
> -       return 0;
> +
> +out:
> +       return ret;
>  }
>
> -static int ubiblock_read(struct ubiblock *dev, char *buffer,
> -                        sector_t sec, int len)
> +static int ubiblock_read(struct ubiblock_pdu *pdu)
>  {
>         int ret, leb, offset;
> -       int bytes_left = len;
> -       int to_read = len;
> -       u64 pos = sec << 9;
> +       int bytes_left = pdu->req_len;
> +       int to_read = pdu->req_len;
> +       struct ubiblock *dev = pdu->dev;
> +       u64 pos = pdu->req_sec << 9;
>
>         /* Get LEB:offset address to read from */
>         offset = do_div(pos, dev->leb_size);
> @@ -216,11 +254,10 @@ static int ubiblock_read(struct ubiblock *dev, char *buffer,
>                 if (offset + to_read > dev->leb_size)
>                         to_read = dev->leb_size - offset;
>
> -               ret = ubiblock_read_to_buf(dev, buffer, leb, offset, to_read);
> -               if (ret)
> +               ret = ubiblock_read_to_sg(pdu, leb, offset, to_read);
> +               if (ret < 0)
>                         return ret;
>
> -               buffer += to_read;
>                 bytes_left -= to_read;
>                 to_read = bytes_left;
>                 leb += 1;
> @@ -229,79 +266,6 @@ static int ubiblock_read(struct ubiblock *dev, char *buffer,
>         return 0;
>  }
>
> -static int do_ubiblock_request(struct ubiblock *dev, struct request *req)
> -{
> -       int len, ret;
> -       sector_t sec;
> -
> -       if (req->cmd_type != REQ_TYPE_FS)
> -               return -EIO;
> -
> -       if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
> -           get_capacity(req->rq_disk))
> -               return -EIO;
> -
> -       if (rq_data_dir(req) != READ)
> -               return -ENOSYS; /* Write not implemented */
> -
> -       sec = blk_rq_pos(req);
> -       len = blk_rq_cur_bytes(req);
> -
> -       /*
> -        * Let's prevent the device from being removed while we're doing I/O
> -        * work. Notice that this means we serialize all the I/O operations,
> -        * but it's probably of no impact given the NAND core serializes
> -        * flash access anyway.
> -        */
> -       mutex_lock(&dev->dev_mutex);
> -       ret = ubiblock_read(dev, bio_data(req->bio), sec, len);
> -       mutex_unlock(&dev->dev_mutex);
> -
> -       return ret;
> -}
> -
> -static void ubiblock_do_work(struct work_struct *work)
> -{
> -       struct ubiblock *dev =
> -               container_of(work, struct ubiblock, work);
> -       struct request_queue *rq = dev->rq;
> -       struct request *req;
> -       int res;
> -
> -       spin_lock_irq(rq->queue_lock);
> -
> -       req = blk_fetch_request(rq);
> -       while (req) {
> -
> -               spin_unlock_irq(rq->queue_lock);
> -               res = do_ubiblock_request(dev, req);
> -               spin_lock_irq(rq->queue_lock);
> -
> -               /*
> -                * If we're done with this request,
> -                * we need to fetch a new one
> -                */
> -               if (!__blk_end_request_cur(req, res))
> -                       req = blk_fetch_request(rq);
> -       }
> -
> -       spin_unlock_irq(rq->queue_lock);
> -}
> -
> -static void ubiblock_request(struct request_queue *rq)
> -{
> -       struct ubiblock *dev;
> -       struct request *req;
> -
> -       dev = rq->queuedata;
> -
> -       if (!dev)
> -               while ((req = blk_fetch_request(rq)) != NULL)
> -                       __blk_end_request_all(req, -ENODEV);
> -       else
> -               queue_work(dev->wq, &dev->work);
> -}
> -
>  static int ubiblock_open(struct block_device *bdev, fmode_t mode)
>  {
>         struct ubiblock *dev = bdev->bd_disk->private_data;
> @@ -375,6 +339,67 @@ static const struct block_device_operations ubiblock_ops = {
>         .getgeo = ubiblock_getgeo,
>  };
>
> +static void ubiblock_do_work(struct work_struct *work)
> +{
> +       int ret;
> +       struct ubiblock_pdu *pdu = container_of(work, struct ubiblock_pdu, work);
> +
> +       ret = ubiblock_read(pdu);
> +       blk_mq_end_request(pdu->req, ret ?: 0);
> +}
> +
> +static int ubiblock_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req,
> +                            bool last)
> +{
> +       int ret;
> +       struct ubiblock *dev = hctx->queue->queuedata;
> +       struct ubiblock_pdu *pdu = blk_mq_rq_to_pdu(req);
> +
> +       if (req->cmd_type != REQ_TYPE_FS)
> +               return BLK_MQ_RQ_QUEUE_ERROR;
> +
> +       if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
> +           get_capacity(req->rq_disk))
> +               return BLK_MQ_RQ_QUEUE_ERROR;
> +
> +       if (rq_data_dir(req) != READ)
> +               return BLK_MQ_RQ_QUEUE_ERROR; /* Write not implemented */
> +
> +       pdu->req = req;

The above line can be moved into ubiblock_init_request().

> +       pdu->req_sec = blk_rq_pos(req);
> +       pdu->req_len = blk_rq_bytes(req);

The above two can be retrieved from 'req' directly, so looks they
can be removed from pdu.

> +       pdu->dev = dev;

Same with pdu->req.

> +       pdu->sglist_pos = 0;
> +       pdu->sgpage_pos = 0;
> +
> +       blk_mq_start_request(req);
> +       ret = blk_rq_map_sg(hctx->queue, req, pdu->sglist);
> +       BUG_ON(ret > UBIBLOCK_SG_COUNT);

You need to tell the limit to bio layer via blk_queue_max_segments(),
otherwise it is easy to trigger the BUG_ON().

> +
> +       INIT_WORK(&pdu->work, ubiblock_do_work);

Same with pdu->req.

> +       queue_work(dev->wq, &pdu->work);
> +
> +       return BLK_MQ_RQ_QUEUE_OK;
> +}
> +
> +static int ubiblock_init_request(void *data, struct request *req,
> +                                unsigned int hctx_idx,
> +                                unsigned int request_idx,
> +                                unsigned int numa_node)
> +{
> +       struct ubiblock_pdu *pdu = blk_mq_rq_to_pdu(req);
> +
> +       sg_init_table(pdu->sglist, UBIBLOCK_SG_COUNT);
> +
> +       return 0;
> +}
> +
> +static struct blk_mq_ops ubiblock_mq_ops = {
> +       .queue_rq       = ubiblock_queue_rq,
> +       .init_request   = ubiblock_init_request,
> +       .map_queue      = blk_mq_map_queue,
> +};
> +
>  int ubiblock_create(struct ubi_volume_info *vi)
>  {
>         struct ubiblock *dev;
> @@ -418,12 +443,25 @@ int ubiblock_create(struct ubi_volume_info *vi)
>         set_capacity(gd, disk_capacity);
>         dev->gd = gd;
>
> -       spin_lock_init(&dev->queue_lock);
> -       dev->rq = blk_init_queue(ubiblock_request, &dev->queue_lock);
> +       dev->tag_set.ops = &ubiblock_mq_ops;
> +       dev->tag_set.queue_depth = 64;
> +       dev->tag_set.numa_node = NUMA_NO_NODE;
> +       dev->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
> +       dev->tag_set.cmd_size = sizeof(struct ubiblock_pdu);
> +       dev->tag_set.driver_data = dev;
> +       dev->tag_set.nr_hw_queues = 1;
> +
> +       ret = blk_mq_alloc_tag_set(&dev->tag_set);
> +       if (ret) {
> +               ubi_err("block: blk_mq_alloc_tag_set failed");
> +               goto out_put_disk;
> +       }
> +
> +       dev->rq = blk_mq_init_queue(&dev->tag_set);
>         if (!dev->rq) {
> -               ubi_err("block: blk_init_queue failed");
> +               ubi_err("block: blk_mq_init_queue failed");
>                 ret = -ENODEV;
> -               goto out_put_disk;
> +               goto out_free_tags;
>         }
>
>         dev->rq->queuedata = dev;
> @@ -438,7 +476,6 @@ int ubiblock_create(struct ubi_volume_info *vi)
>                 ret = -ENOMEM;
>                 goto out_free_queue;
>         }
> -       INIT_WORK(&dev->work, ubiblock_do_work);
>
>         mutex_lock(&devices_mutex);
>         list_add_tail(&dev->list, &ubiblock_devices);
> @@ -452,6 +489,8 @@ int ubiblock_create(struct ubi_volume_info *vi)
>
>  out_free_queue:
>         blk_cleanup_queue(dev->rq);
> +out_free_tags:
> +       blk_mq_free_tag_set(&dev->tag_set);
>  out_put_disk:
>         put_disk(dev->gd);
>  out_free_dev:
> @@ -464,6 +503,7 @@ static void ubiblock_cleanup(struct ubiblock *dev)
>  {
>         del_gendisk(dev->gd);
>         blk_cleanup_queue(dev->rq);
> +       blk_mq_free_tag_set(&dev->tag_set);
>         ubi_msg("%s released", dev->gd->disk_name);
>         put_disk(dev->gd);
>  }
> @@ -491,6 +531,9 @@ int ubiblock_remove(struct ubi_volume_info *vi)
>         list_del(&dev->list);
>         mutex_unlock(&devices_mutex);
>
> +       /* Make sure that no further work is queued */
> +       blk_mq_stop_hw_queues(dev->rq);
> +

The above change can be avoided by putting destroy_workqueue()
into or after ubiblock_cleanup()

>         /* Flush pending work and stop this workqueue */
>         destroy_workqueue(dev->wq);
>
> @@ -621,6 +664,8 @@ static void ubiblock_remove_all(void)
>         struct ubiblock *dev;
>
>         list_for_each_entry_safe(dev, next, &ubiblock_devices, list) {
> +               /* Make sure that no further work is queued */
> +               blk_mq_stop_hw_queues(dev->rq);
>                 /* Flush pending work and stop workqueue */
>                 destroy_workqueue(dev->wq);

Same with above.


Thanks,
-- 
Ming Lei
