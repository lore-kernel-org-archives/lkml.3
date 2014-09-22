Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaIVLQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 07:16:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58985 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbaIVLQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 07:16:37 -0400
Date: Mon, 22 Sep 2014 04:16:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, JBottomley@Parallels.com,
        Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH][SCSI] mpt2sas: fix undefined reference to `__udivdi3'
 compilation errors
Message-ID: <20140922111633.GA31327@infradead.org>
References: <1411109247-18184-1-git-send-email-Sreekanth.Reddy@avagotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411109247-18184-1-git-send-email-Sreekanth.Reddy@avagotech.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.  Can I get a quick second review?

On Fri, Sep 19, 2014 at 12:17:27PM +0530, Sreekanth Reddy wrote:
> This patch will fix the below compilation errors on i386 ARCH
> 
> drivers/built-in.o: In function `_scsih_qcmd':
> mpt2sas_scsih.c:(.text+0x1e7b56): undefined reference to `__udivdi3'
> mpt2sas_scsih.c:(.text+0x1e7b8a): undefined reference to `__umoddi3'
> 
> Used sector_div() API to fix above compilation errors.
> 
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index 992a224..c80ed04 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -3860,7 +3860,7 @@ _scsih_setup_direct_io(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
>  	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
>  	u16 smid)
>  {
> -	sector_t v_lba, p_lba, stripe_off, stripe_unit, column, io_size;
> +	sector_t v_lba, p_lba, stripe_off, column, io_size;
>  	u32 stripe_sz, stripe_exp;
>  	u8 num_pds, cmd = scmd->cmnd[0];
>  
> @@ -3888,9 +3888,9 @@ _scsih_setup_direct_io(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
>  
>  	num_pds = raid_device->num_pds;
>  	p_lba = v_lba >> stripe_exp;
> -	stripe_unit = p_lba / num_pds;
> -	column = p_lba % num_pds;
> -	p_lba = (stripe_unit << stripe_exp) + stripe_off;
> +	column = sector_div(p_lba, num_pds);
> +	p_lba = (p_lba << stripe_exp) + stripe_off;
> +
>  	mpi_request->DevHandle = cpu_to_le16(raid_device->pd_handle[column]);
>  
>  	if (cmd == READ_10 || cmd == WRITE_10)
> -- 
> 2.0.2
> 
---end quoted text---
