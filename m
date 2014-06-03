Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbaFCUql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:46:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbaFCUqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:46:40 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] block,scsi: convert and handle ERR_PTR from blk_get_request
References: <1401396529-17275-1-git-send-email-joe.lawrence@stratus.com>
	<1401396529-17275-3-git-send-email-joe.lawrence@stratus.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 03 Jun 2014 16:07:01 -0400
In-Reply-To: <1401396529-17275-3-git-send-email-joe.lawrence@stratus.com> (Joe
	Lawrence's message of "Thu, 29 May 2014 16:48:49 -0400")
Message-ID: <x49mwdtvjtm.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Lawrence <joe.lawrence@stratus.com> writes:

> diff --git a/block/bsg.c b/block/bsg.c
> index 420a5a9..2b1c322 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -271,8 +271,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
>  	 * map scatter-gather elements separately and string them to request
>  	 */
>  	rq = blk_get_request(q, rw, GFP_KERNEL);
> -	if (!rq)
> -		return ERR_PTR(-ENOMEM);
> +	if (IS_ERR(rq))
> +		return rq;
>  	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, bd, has_write_perm);
>  	if (ret)
>  		goto out;
> @@ -284,8 +284,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
>  		}
>  
>  		next_rq = blk_get_request(q, READ, GFP_KERNEL);
> -		if (!next_rq) {
> -			ret = -ENOMEM;
> +		if (IS_ERR(next_rq)) {
> +			ret = PTR_ERR(rq);

ITYM ret = PTR_ERR(next_rq), right?

> diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> index 084062b..1cf4019 100644
> --- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> +++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> @@ -117,7 +117,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
>  
>  retry:
>  	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
> -	if (!req)
> +	if (IS_ERR(req))
>  		return SCSI_DH_RES_TEMP_UNAVAIL;
>  

Don't we have an opportunity here to differentiate between enomem and
eio?  I have no idea what the right SCSI_DH error would be, I'm just
asking the question.

>  	req->cmd_type = REQ_TYPE_BLOCK_PC;
> @@ -247,7 +247,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
>  	struct request *req;
>  
>  	req = blk_get_request(h->sdev->request_queue, WRITE, GFP_ATOMIC);
> -	if (!req)
> +	if (IS_ERR(req))
>  		return SCSI_DH_RES_TEMP_UNAVAIL;

Same goes here.

Cheers,
Jeff
