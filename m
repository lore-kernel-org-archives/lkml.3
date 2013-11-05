Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab3KENtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:49:33 -0500
Received: from dkim1.fusionio.com ([66.114.96.53]:52675 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab3KENtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:49:31 -0500
X-ASG-Debug-ID: 1383659370-03d6a54d18feb40001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
Date: Tue, 5 Nov 2013 08:49:28 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Kent Overstreet <kmo@daterainc.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <axboe@kernel.dk>, <hch@infradead.org>
Subject: Re: [PATCH 6/9] mtip32xx: handle arbitrary size bios
Message-ID: <20131105134928.GA27784@localhost.localdomain>
X-ASG-Orig-Subj: Re: [PATCH 6/9] mtip32xx: handle arbitrary size bios
References: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
 <1383608187-27368-7-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1383608187-27368-7-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1383659370
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.142073
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 03:36:24PM -0800, Kent Overstreet wrote:
> We get a measurable performance increase by handling this in the driver when
> we're already looping over the biovec, instead of handling it separately in
> generic_make_request() (or bio_add_page() originally)
> 
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> ---
>  drivers/block/mtip32xx/mtip32xx.c | 46 +++++++++++++--------------------------
>  1 file changed, 15 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
> index d4c669b..c5a7a96 100644
> --- a/drivers/block/mtip32xx/mtip32xx.c
> +++ b/drivers/block/mtip32xx/mtip32xx.c
> @@ -2648,24 +2648,6 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
>  }
>  
>  /*
> - * Release a command slot.
> - *
> - * @dd  Pointer to the driver data structure.
> - * @tag Slot tag
> - *
> - * return value
> - *      None
> - */
> -static void mtip_hw_release_scatterlist(struct driver_data *dd, int tag,
> -								int unaligned)
> -{
> -	struct semaphore *sem = unaligned ? &dd->port->cmd_slot_unal :
> -							&dd->port->cmd_slot;
> -	release_slot(dd->port, tag);
> -	up(sem);
> -}
> -
> -/*
>   * Obtain a command slot and return its associated scatter list.
>   *
>   * @dd  Pointer to the driver data structure.
> @@ -4016,21 +3998,22 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
>  
>  	sg = mtip_hw_get_scatterlist(dd, &tag, unaligned);
>  	if (likely(sg != NULL)) {
> -		if (unlikely((bio)->bi_vcnt > MTIP_MAX_SG)) {
> -			dev_warn(&dd->pdev->dev,
> -				"Maximum number of SGL entries exceeded\n");
> -			bio_io_error(bio);
> -			mtip_hw_release_scatterlist(dd, tag, unaligned);
> -			return;
> -		}
> -
>  		/* Create the scatter list for this bio. */
>  		bio_for_each_segment(bvec, bio, iter) {
> -			sg_set_page(&sg[nents],
> -					bvec.bv_page,
> -					bvec.bv_len,
> -					bvec.bv_offset);
> -			nents++;
> +			if (unlikely(nents == MTIP_MAX_SG)) {
> +				struct bio *split = bio_clone(bio, GFP_NOIO);
> +

Need to check for memory allocation failure here.  Thanks,

Josef
