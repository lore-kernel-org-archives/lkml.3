Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbaGWChr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:37:47 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:51389 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbaGWChn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:37:43 -0400
Message-ID: <53CF1FEF.7050704@linux.vnet.ibm.com>
Date: Wed, 23 Jul 2014 10:37:35 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        haokexin@gmail.com
Subject: Re: [PATCH 2/2] libata: Fix NULL pointer of scsi_host in ata_port
References: <1406040688-1762-1-git-send-email-qiudayu@linux.vnet.ibm.com>
In-Reply-To: <1406040688-1762-1-git-send-email-qiudayu@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072302-8878-0000-0000-000000226351
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 10:51 PM, Mike Qiu wrote:
> In ata_sas_port_alloc(), it haven't initialized scsi_host field in
> ata_port, although scsi_host is in parameters list and unused in this
> function.
>
> With commit 1871ee134b73 ("libata: support the ata host which implements a queue depth less than 32")
> ata_qc_new() try to use scsi_host, while it
> is a NULL pointer for ipr IOA and error message shows below:
...
>
> While scsi_host is unused in ata_sas_port_alloc(), better to set it
> in ata_sas_port_alloc() instead of in driver.
>
> Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
> ---
>   drivers/ata/libata-scsi.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 0586f66..a472b6f 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -4070,6 +4070,7 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
>   	ap->flags |= port_info->flags;
>   	ap->ops = port_info->port_ops;
>   	ap->cbl = ATA_CBL_SATA;
> +	ap->scsi_host = shost;

What about my patch itself, ata_sas_port_alloc() has "shot" in 
parameters list, but unused.

Maybe better to set ap->scsi_host here, it is very convenient, and 
drivers, like ipr, may forget to set this field, otherwise "shot" need 
to be removed from parameters list I think.

Thanks,
Mike
>   	return ap;
>   }

