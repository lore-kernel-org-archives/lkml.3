Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaJ1RxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:53:17 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57909 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbaJ1RxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:53:16 -0400
Message-ID: <544FD7FC.8070005@cs.wisc.edu>
Date: Tue, 28 Oct 2014 12:53:00 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Chandra Seetharaman <sekharan@us.ibm.com>,
        Hannes Reinecke <hare@suse.de>
CC: Sean Stewart <Sean.Stewart@netapp.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] scsi: handle more device handler setup/teardown in
 common code
References: <1413734404-1426-1-git-send-email-hch@lst.de> <1413734404-1426-7-git-send-email-hch@lst.de>
In-Reply-To: <1413734404-1426-7-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2014 11:00 AM, Christoph Hellwig wrote:
> -static int rdac_bus_attach(struct scsi_device *sdev)
> +static struct scsi_dh_data *rdac_bus_attach(struct scsi_device *sdev)
>  {
>  	struct rdac_dh_data *h;
> -	unsigned long flags;
>  	int err;
>  	char array_name[ARRAY_LABEL_LEN];
>  	char array_id[UNIQUE_ID_LEN];
>  
>  	h = kzalloc(sizeof(*h) , GFP_KERNEL);
> -	if (!h) {
> -		sdev_printk(KERN_ERR, sdev, "%s: Attach failed\n",
> -			    RDAC_NAME);
> -		return -ENOMEM;
> -	}
> -
> -	h->dh_data.scsi_dh = &rdac_dh;
> +	if (!h)
> +		return ERR_PTR(-ENOMEM);
>  	h->lun = UNINITIALIZED_LUN;
>  	h->state = RDAC_STATE_ACTIVE;
>  
> @@ -876,15 +856,10 @@ static int rdac_bus_attach(struct scsi_device *sdev)
>  	if (err != SCSI_DH_OK)
>  		goto clean_ctlr;
>  
> -	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> -	sdev->scsi_dh_data = &h->dh_data;
> -	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> -
>  	sdev_printk(KERN_NOTICE, sdev,
>  		    "%s: LUN %d (%s) (%s)\n",
>  		    RDAC_NAME, h->lun, mode[(int)h->mode],
>  		    lun_state[(int)h->lun_state]);
> -
>  	return 0;

Was this supposed to return a "struct scsi_dh_data *" instead of zero here?
