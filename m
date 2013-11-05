Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3KECin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 21:38:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:29732 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab3KECil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 21:38:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="403665359"
Message-ID: <52785A5F.4060001@intel.com>
Date: Tue, 05 Nov 2013 10:39:27 +0800
From: Aaron Lu <aaron.lu@intel.com>
Organization: Intel, Shanghai, PRC
MIME-Version: 1.0
To: Phillip Susi <psusi@ubuntu.com>, linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] libata: avoid waking disk to check power
References: <1383612780-6591-1-git-send-email-psusi@ubuntu.com> <1383612780-6591-2-git-send-email-psusi@ubuntu.com>
In-Reply-To: <1383612780-6591-2-git-send-email-psusi@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+linux-ide

On 11/05/2013 08:53 AM, Phillip Susi wrote:
> When a disk is in SLEEP mode it can not respond to commands,
> including the CHECK POWER command.  Instead of waking up the
> sleeping disk, fake the reply to the CHECK POWER command to
> indicate the disk is in standby mode.  This prevents udisks
> from waking up sleeping disks when it polls to see if they
> are awake or not before trying to read their smart status.

If the disk entered sleep mode due to runtime PM, then udisks can easily
tell by checking the device's runtime status and not send out the query.

But if the disk entered sleep mode due to other reason, the patch may be
necessary. So what's your scenario?

Best regards,
Aaron

> 
> Signed-off-by: Phillip Susi <psusi@ubuntu.com>
> ---
>  drivers/ata/libata-core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 83b1a9f..573d151 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5084,6 +5084,13 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
>  
>  	/* if device is sleeping, schedule reset and abort the link */
>  	if (unlikely(qc->dev->flags & ATA_DFLAG_SLEEPING)) {
> +		if (unlikely(qc->tf.command == ATA_CMD_CHK_POWER))
> +		{
> +			/* fake reply to avoid waking drive */
> +			qc->result_tf.nsect = 0;
> +			ata_qc_complete(qc);
> +			return;
> +		}
>  		link->eh_info.action |= ATA_EH_RESET;
>  		ata_ehi_push_desc(&link->eh_info, "waking up from sleep");
>  		ata_link_abort(link);
> 

