Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaJTGBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:01:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbaJTGBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:01:22 -0400
Message-ID: <5444A530.3080204@suse.de>
Date: Mon, 20 Oct 2014 08:01:20 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Chandra Seetharaman <sekharan@us.ibm.com>,
        Mike Christie <michaelc@cs.wisc.edu>
CC: Sean Stewart <Sean.Stewart@netapp.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] scsi_dh: get module reference outside of device handler
References: <1413734404-1426-1-git-send-email-hch@lst.de> <1413734404-1426-2-git-send-email-hch@lst.de>
In-Reply-To: <1413734404-1426-2-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2014 05:59 PM, Christoph Hellwig wrote:
> We need to grab a reference to the module before calling the attach
> routines to avoid a small race vs module removal.  It also cleans up
> the code significantly as a side effect.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/device_handler/scsi_dh.c       | 31 ++++++++++++++++++++---------
>  drivers/scsi/device_handler/scsi_dh_alua.c  |  4 ----
>  drivers/scsi/device_handler/scsi_dh_emc.c   |  4 ----
>  drivers/scsi/device_handler/scsi_dh_hp_sw.c |  4 ----
>  drivers/scsi/device_handler/scsi_dh_rdac.c  |  4 ----
>  5 files changed, 22 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
> index 33e422e..1a8dbf3 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -102,23 +102,36 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
>  
>  	if (sdev->scsi_dh_data) {
>  		if (sdev->scsi_dh_data->scsi_dh != scsi_dh)
> -			err = -EBUSY;
> -		else
> -			kref_get(&sdev->scsi_dh_data->kref);
> -	} else if (scsi_dh->attach) {
> +			return -EBUSY;
> +
> +		kref_get(&sdev->scsi_dh_data->kref);
> +		return 0;
> +	}
> +
> +	if (scsi_dh->attach) {
> +		if (!try_module_get(scsi_dh->module))
> +			return -EINVAL;
> +
>  		err = scsi_dh->attach(sdev);
> -		if (!err) {
> -			kref_init(&sdev->scsi_dh_data->kref);
> -			sdev->scsi_dh_data->sdev = sdev;
> +		if (err) {
> +			module_put(scsi_dh->module);
> +			return err;
>  		}
> +
> +		kref_init(&sdev->scsi_dh_data->kref);
> +		sdev->scsi_dh_data->sdev = sdev;
>  	}
>  	return err;
>  }
>  
>  static void __detach_handler (struct kref *kref)
>  {
> -	struct scsi_dh_data *scsi_dh_data = container_of(kref, struct scsi_dh_data, kref);
> -	scsi_dh_data->scsi_dh->detach(scsi_dh_data->sdev);
> +	struct scsi_dh_data *scsi_dh_data =
> +		container_of(kref, struct scsi_dh_data, kref);
> +	struct scsi_device_handler *scsi_dh = scsi_dh_data->scsi_dh;
> +
> +	scsi_dh->detach(scsi_dh_data->sdev);
> +	module_put(scsi_dh->module);
>  }
>  
>  /*
Is it guaranteed that you cannot call ->attach() for devices which
already have a device_handler attached?
You've skipped the case

scsi_dh != sdev->scsi_dh_data->scsi_dh

IE someone called 'attach()' on a device which already has a
different device_handler attached to it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
