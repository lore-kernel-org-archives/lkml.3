Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaJTGES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:04:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbaJTGER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:04:17 -0400
Message-ID: <5444A5E0.3080006@suse.de>
Date: Mon, 20 Oct 2014 08:04:16 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Chandra Seetharaman <sekharan@us.ibm.com>,
        Mike Christie <michaelc@cs.wisc.edu>
CC: Sean Stewart <Sean.Stewart@netapp.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] scsi: device handlers must have attach and detach
 methods
References: <1413734404-1426-1-git-send-email-hch@lst.de> <1413734404-1426-5-git-send-email-hch@lst.de>
In-Reply-To: <1413734404-1426-5-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2014 06:00 PM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/device_handler/scsi_dh.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
> index 1a8dbf3..d8a8aac 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -108,19 +108,17 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
>  		return 0;
>  	}
>  
> -	if (scsi_dh->attach) {
> -		if (!try_module_get(scsi_dh->module))
> -			return -EINVAL;
> -
> -		err = scsi_dh->attach(sdev);
> -		if (err) {
> -			module_put(scsi_dh->module);
> -			return err;
> -		}
> +	if (!try_module_get(scsi_dh->module))
> +		return -EINVAL;
>  
> -		kref_init(&sdev->scsi_dh_data->kref);
> -		sdev->scsi_dh_data->sdev = sdev;
> +	err = scsi_dh->attach(sdev);
> +	if (err) {
> +		module_put(scsi_dh->module);
> +		return err;
>  	}
> +
> +	kref_init(&sdev->scsi_dh_data->kref);
> +	sdev->scsi_dh_data->sdev = sdev;
>  	return err;
>  }
>  
> @@ -154,7 +152,7 @@ static void scsi_dh_handler_detach(struct scsi_device *sdev,
>  	if (!scsi_dh)
>  		scsi_dh = sdev->scsi_dh_data->scsi_dh;
>  
> -	if (scsi_dh && scsi_dh->detach)
> +	if (scsi_dh)
>  		kref_put(&sdev->scsi_dh_data->kref, __detach_handler);
>  }
>  
> @@ -343,6 +341,9 @@ int scsi_register_device_handler(struct scsi_device_handler *scsi_dh)
>  	if (get_device_handler(scsi_dh->name))
>  		return -EBUSY;
>  
> +	if (!scsi_dh->attach || !scsi_dh->detach)
> +		return -EINVAL;
> +
>  	spin_lock(&list_lock);
>  	list_add(&scsi_dh->list, &scsi_dh_list);
>  	spin_unlock(&list_lock);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
