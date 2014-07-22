Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbaGVO67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:58:59 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49601 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbaGVO64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:58:56 -0400
Message-ID: <53CE7C29.6050908@linux.vnet.ibm.com>
Date: Tue, 22 Jul 2014 22:58:49 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        zhenghch@cn.ibm.com, haokexin@gmail.com
Subject: Re: [PATCH 2/2] libata: Fix NULL pointer of scsi_host in ata_port
References: <1406040688-1762-1-git-send-email-qiudayu@linux.vnet.ibm.com>
In-Reply-To: <1406040688-1762-1-git-send-email-qiudayu@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072214-9574-0000-0000-0000002A3F00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Wendy, Brian King, Stephen]


On 07/22/2014 10:51 PM, Mike Qiu wrote:
> In ata_sas_port_alloc(), it haven't initialized scsi_host field in
> ata_port, although scsi_host is in parameters list and unused in this
> function.
>
> With commit 1871ee134b73 ("libata: support the ata host which implements a queue depth less than 32")
> ata_qc_new() try to use scsi_host, while it
> is a NULL pointer for ipr IOA and error message shows below:
>
> Unable to handle kernel paging request for data at address 0x00000114
> Faulting instruction address: 0xc0000000005c2580
> Oops: Kernel access of bad area, sig: 11 [#1]
> ...
> NIP [c0000000005c2580] .ata_qc_new_init+0x30/0x1f0
> LR [c0000000005c9384] .ata_scsi_translate+0x44/0x230
> Call Trace:
> 0xc0000003ad332280 (unreliable)
> .ata_scsi_translate+0x44/0x230
> .ipr_queuecommand+0x2e0/0x780 [ipr]
> .scsi_dispatch_cmd+0xec/0x400
> .scsi_request_fn+0x52c/0x670
> .__blk_run_queue+0x5c/0x80
> .blk_execute_rq_nowait+0xf8/0x1c0
> .blk_execute_rq+0x88/0x150
> .scsi_execute+0xf0/0x1f0
> .scsi_execute_req_flags+0xc4/0x170
> .scsi_probe_and_add_lun+0x2d4/0xe00
> .__scsi_scan_target+0x1a4/0x790
> .scsi_scan_channel.part.3+0x80/0xc0
> .scsi_scan_host_selected+0x1a0/0x240
> .do_scan_async+0x30/0x210
> .async_run_entry_fn+0x78/0x1c0
> .process_one_work+0x1c4/0x4a0
> .worker_thread+0x184/0x600
> .kthread+0x10c/0x130
> .ret_from_kernel_thread+0x58/0x7c
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
>
>   	return ap;
>   }

