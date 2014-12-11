Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965201AbaLKWSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:18:36 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:34817 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaLKWSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:18:34 -0500
Message-ID: <1418336302.1709.1.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] scsi: fix random memory corruption with scsi-mq + T10 PI
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Date: Thu, 11 Dec 2014 14:18:22 -0800
In-Reply-To: <54862444.3020901@cybernetics.com>
References: <54862444.3020901@cybernetics.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Mon, 2014-12-08 at 17:20 -0500, Tony Battersby wrote:
> This fixes random memory corruption triggered when all three of the
> following are true:
> 
> * scsi-mq enabled
> * T10 Protection Information (DIF) enabled
> * SCSI host with sg_tablesize > SCSI_MAX_SG_SEGMENTS (128)
> 
> The symptoms of this bug are unpredictable memory corruption, BUG()s,
> oopses, lockups, etc., any of which may appear to be completely
> unrelated to the root cause.
> 
> Cc: <stable@vger.kernel.org> # 3.17.x, 3.18.x
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> 
> ---
> 
> I encountered this problem with a QLogic QLE2672 FC HBA using qla2xxx.
> On my system, this would trigger BUG_ON(atomic_read(&bio->bi_remaining) <= 0)
> in bio_endio(), or a general protection fault in __sg_free_table()
> trying to free prot_sdb, or any number of other weird random problems.
> All of this was caused by cmd->prot_sdb pointing to the wrong memory.
> To see how the memory is allocated, refer to scsi_mq_setup_tags() in
> scsi_lib.c.
> 
> For inclusion in 3.19, 3.18.x, and 3.17.x.
> 
> --- linux-3.18.0/drivers/scsi/scsi_lib.c.orig	2014-12-08 16:23:28.000000000 -0500
> +++ linux-3.18.0/drivers/scsi/scsi_lib.c	2014-12-08 16:24:00.000000000 -0500
> @@ -1829,7 +1829,9 @@ static int scsi_mq_prep_fn(struct reques
>  
>  	if (scsi_host_get_prot(shost)) {
>  		cmd->prot_sdb = (void *)sg +
> -			shost->sg_tablesize * sizeof(struct scatterlist);
> +			min_t(unsigned int,
> +			      shost->sg_tablesize, SCSI_MAX_SG_SEGMENTS) *
> +			sizeof(struct scatterlist);
>  		memset(cmd->prot_sdb, 0, sizeof(struct scsi_data_buffer));
>  
>  		cmd->prot_sdb->table.sgl =
> 

Nice catch.

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>

Adding a CC' to MKP, and HCH so he can pick it up.

--nab

