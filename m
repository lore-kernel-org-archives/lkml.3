Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab3FJJoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:44:32 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:64979 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3FJJoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:44:30 -0400
MIME-Version: 1.0
In-Reply-To: <1370382160-7576-1-git-send-email-taysom@chromium.org>
References: <1370382160-7576-1-git-send-email-taysom@chromium.org>
Date: Mon, 10 Jun 2013 11:44:29 +0200
Message-ID: <CAPDyKFq-h_FDNMc-3rvcknBkGhWd13KDLnHhwBrcX4Rfc0qWGQ@mail.gmail.com>
Subject: Re: [PATCH] drivers: mmc: reordered shutdown sequence in mmc_bld_remove_req
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Paul Taysom <taysom@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Namjae Jeon <linkinjeon@gmail.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        sonny@chromium.org, olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2013 23:42, Paul Taysom <taysom@chromium.org> wrote:
> We had a multi-partition SD-Card with two ext2 file systems. The partition
> table was getting overwritten by a race between the card removal and
> the unmount of the 2nd ext2 partition.
>
> What was observed:
> 1. Suspend/resume would call to remove the device. The clearing
>    of the device information is done asynchronously.
> 2. A request is made to unmount the file system (this is called
>    after the removal has started).
> 3. The remapping table was cleared by the asynchronous part of
>    the device removal.
> 4. A write request to the super block (block 0 of the partition)
>    was sent down and instead of being remapped to the partition
>    offset, it was remapped to block 0 of the device which is where
>    the partition table is located.
> 5. Write was queued and written resulting in the overwriting
>    of the partition table with the ext2 super block.
> 6. The mmc_queue is cleaned up.

Hi Paul,

An interesting bug you found here. My impression is that this is
something that should be addressed through the blk layer, somehow.

Have you considered that this is not only a problem for SD cards, but
for other block device drivers as well. I believe it is common to call
del_gendisk before blk_cleanup_queue, which in principle is what you
want to change.

>
> The mmc card device driver used to access SD cards, was calling del_gendisk
> before calling mmc_cleanup-queue. The comment in the mmc_blk_remove_req
> code indicated that it expected del_gendisk to block all further requests
> from being queued but it doesn't. The mmc driver uses the presences of the
> mmc_queue to determine if the request should be queued.
>
> The fix was to clean up the mmc_queue before the rest of the
> the delete partition code is called.
>
> This prevents the overwriting of the partition table.
>
> However, the umount gets an error trying to write the super block.
> The umount should be issued before the device is removed but that
> is not always possible. The umount is still needed to cleanup other
> data structures.

So this clearly indicates to me that this is not the complete
solution, even if it solves the most serious problem for this bug.

I think it would be good to get a blk device maintainer's input to
this discussion.

Kind regards
Ulf Hansson

>
> Addresses the problem described in http://crbug.com/240815
>
> Signed-off-by: Paul Taysom <taysom@chromium.org>
> ---
>  drivers/mmc/card/block.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index dd27b07..a79f113 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -2158,6 +2158,14 @@ static void mmc_blk_remove_req(struct mmc_blk_data *md)
>         struct mmc_card *card;
>
>         if (md) {
> +               /*
> +                * Flush remaining requests and free queues. It
> +                * is freeing the queue that stops new requests
> +                * from being accepted.
> +                */
> +               mmc_cleanup_queue(&md->queue);
> +               if (md->flags & MMC_BLK_PACKED_CMD)
> +                       mmc_packed_clean(&md->queue);
>                 card = md->queue.card;
>                 if (md->disk->flags & GENHD_FL_UP) {
>                         device_remove_file(disk_to_dev(md->disk), &md->force_ro);
> @@ -2166,14 +2174,8 @@ static void mmc_blk_remove_req(struct mmc_blk_data *md)
>                                 device_remove_file(disk_to_dev(md->disk),
>                                         &md->power_ro_lock);
>
> -                       /* Stop new requests from getting into the queue */
>                         del_gendisk(md->disk);
>                 }
> -
> -               /* Then flush out any already in there */
> -               mmc_cleanup_queue(&md->queue);
> -               if (md->flags & MMC_BLK_PACKED_CMD)
> -                       mmc_packed_clean(&md->queue);
>                 mmc_blk_put(md);
>         }
>  }
> --
> 1.8.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
