Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbaGVPmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:42:50 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:37213 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049AbaGVPms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:42:48 -0400
Date: Tue, 22 Jul 2014 11:42:44 -0400
From: Tejun Heo <tj@kernel.org>
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        haokexin@gmail.com, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/2] libata: Fix scsi_host can_queue issue in ata_qc_new()
Message-ID: <20140722154244.GJ13851@htj.dyndns.org>
References: <1406040619-1722-1-git-send-email-qiudayu@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406040619-1722-1-git-send-email-qiudayu@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(cc'ing Dan)

On Tue, Jul 22, 2014 at 10:50:19AM -0400, Mike Qiu wrote:
> The can_queue in scsi_host can be more than ATA_MAX_QUEUE (32),
> for example, in ipr, it can be 100 or more.
> 
> Also, some drivers, like ipr driver, haven't filled the field
> scsi_host in ata_port, and will lead a call trace, so add
> check for that.
> 
> Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
> ---
>  drivers/ata/libata-core.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 259d879..a5b9c70 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -4734,7 +4734,10 @@ static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
>  	struct ata_queued_cmd *qc = NULL;
>  	unsigned int i, tag, max_queue;
>  
> -	max_queue = ap->scsi_host->can_queue;
> +	if (ap->scsi_host && ap->scsi_host->can_queue <= ATA_MAX_QUEUE)
> +		max_queue = ap->scsi_host->can_queue;
> +	else
> +		max_queue = ATA_MAX_QUEUE;
>  
>  	/* no command while frozen */
>  	if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
> @@ -6109,16 +6112,6 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
>  {
>  	int i, rc;
>  
> -	/*
> -	 * The max queue supported by hardware must not be greater than
> -	 * ATA_MAX_QUEUE.
> -	 */
> -	if (sht->can_queue > ATA_MAX_QUEUE) {
> -		dev_err(host->dev, "BUG: the hardware max queue is too large\n");
> -		WARN_ON(1);
> -		return -EINVAL;
> -	}
> -

So, ummm, I really don't like that we're adding the conditionals to
the hot path (yeah, its implementation is slow but still).  Maybe we
need to store the chosen queue depth after all?  Dan?

Thanks.

-- 
tejun
