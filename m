Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbaDIKsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:48:36 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:34393 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758351AbaDIKse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:48:34 -0400
Message-ID: <5345257D.6040102@gmail.com>
Date: Wed, 09 Apr 2014 13:48:29 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Matei Oprea <eu@opreamatei.ro>, jbottomley@parallels.com
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Subject: Re: [PATCH] scsi: lpfc: lpfc_init: use kcalloc for allocating memory
References: <1396989746-29647-1-git-send-email-eu@opreamatei.ro>
In-Reply-To: <1396989746-29647-1-git-send-email-eu@opreamatei.ro>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 11:42 PM, Matei Oprea wrote:
> It's easier to use kcalloc for allocating arrays. While at it
> also remove useless casting value.
> 
> Signed-off-by: Matei Oprea <eu@opreamatei.ro>
> Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 635eeb3..1528f34 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4742,12 +4742,14 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
>  			phba->cfg_sg_seg_cnt = LPFC_DEFAULT_MENLO_SG_SEG_CNT;
>  	}
>  
> -	if (!phba->sli.ring)
> -		phba->sli.ring = (struct lpfc_sli_ring *)
> -			kzalloc(LPFC_SLI3_MAX_RING *
> -			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
> -	if (!phba->sli.ring)
> -		return -ENOMEM;
> +	if (unlikely(!phba->sli.ring)) {

As Joe Perches said this one is not unlikely, it might or it might not
depending on state.

> +		phba->sli.ring = kcalloc(LPFC_SLI3_MAX_RING,
> +				sizeof(struct lpfc_sli_ring),
> +				GFP_KERNEL);
> +
> +		if (!phba->sli.ring)

but this one is unlikely. This is the error path so we want
the hot path to be decoded by the CPU.

> +			return -ENOMEM;
> +	}
>  
>  	/*
>  	 * Since lpfc_sg_seg_cnt is module parameter, the sg_dma_buf_size
> 

Cheers
Boaz

