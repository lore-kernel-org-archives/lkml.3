Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaGNGRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:17:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbaGNGRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:17:14 -0400
Message-ID: <53C375E8.8090901@suse.de>
Date: Mon, 14 Jul 2014 08:17:12 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com,
        apw@canonical.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
CC: stable@vger.kernel.org
Subject: Re: [PATCH 6/7] drivers: scsi: storvsc: Set srb_flags in all cases
References: <1405183684-23928-1-git-send-email-kys@microsoft.com> <1405183712-23967-1-git-send-email-kys@microsoft.com> <1405183712-23967-6-git-send-email-kys@microsoft.com>
In-Reply-To: <1405183712-23967-6-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2014 06:48 PM, K. Y. Srinivasan wrote:
> Correctly set SRB flags for all valid I/O directions. Some IHV drivers on the
> Windows host require this. The host validates the command and SRB flags
> prior to passing the command down to native driver stack.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/scsi/storvsc_drv.c |   12 +++++-------
>   1 files changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 3516761..9342ba4 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1599,26 +1599,24 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
>   	vm_srb = &cmd_request->vstor_packet.vm_srb;
>   	vm_srb->win8_extension.time_out_value = 60;
>
> +	vm_srb->win8_extension.srb_flags |=
> +		(SRB_FLAGS_QUEUE_ACTION_ENABLE |
> +		SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
>
>   	/* Build the SRB */
>   	switch (scmnd->sc_data_direction) {
>   	case DMA_TO_DEVICE:
>   		vm_srb->data_in = WRITE_TYPE;
>   		vm_srb->win8_extension.srb_flags |= SRB_FLAGS_DATA_OUT;
> -		vm_srb->win8_extension.srb_flags |=
> -			(SRB_FLAGS_QUEUE_ACTION_ENABLE |
> -			SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
>   		break;
>   	case DMA_FROM_DEVICE:
>   		vm_srb->data_in = READ_TYPE;
>   		vm_srb->win8_extension.srb_flags |= SRB_FLAGS_DATA_IN;
> -		vm_srb->win8_extension.srb_flags |=
> -			(SRB_FLAGS_QUEUE_ACTION_ENABLE |
> -			SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
>   		break;
>   	default:
>   		vm_srb->data_in = UNKNOWN_TYPE;
> -		vm_srb->win8_extension.srb_flags = 0;
> +		vm_srb->win8_extension.srb_flags |= (SRB_FLAGS_DATA_IN |
> +						     SRB_FLAGS_DATA_OUT);
>   		break;
>   	}
>
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
