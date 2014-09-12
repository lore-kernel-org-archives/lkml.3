Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaILK6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:58:51 -0400
Received: from smtp.citrix.com ([66.165.176.89]:36166 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbaILK6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:58:50 -0400
X-IronPort-AV: E=Sophos;i="5.04,512,1406592000"; 
   d="scan'208";a="170897164"
Message-ID: <5412D1E7.2080801@citrix.com>
Date: Fri, 12 Sep 2014 11:58:47 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Arianna Avanzini <avanzini.arianna@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
CC: <hch@infradead.org>, <bob.liu@oracle.com>, <felipe.franciosi@citrix.com>,
        <axboe@fb.com>
Subject: Re: [PATCH RFC v2 5/5] xen, blkback: negotiate of the number of block
 rings with the frontend
References: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com> <1410479844-2864-6-git-send-email-avanzini.arianna@gmail.com>
In-Reply-To: <1410479844-2864-6-git-send-email-avanzini.arianna@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/14 00:57, Arianna Avanzini wrote:
> This commit lets the backend driver advertise the number of available
> hardware queues; it also implements gathering from the frontend driver
> the number of rings actually available for mapping.
[...]
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -477,6 +477,34 @@ static void xen_vbd_free(struct xen_vbd *vbd)
>  	vbd->bdev = NULL;
>  }
>  
> +static int xen_advertise_hw_queues(struct xen_blkif *blkif,
> +				   struct request_queue *q)
> +{
> +	struct xen_vbd *vbd = &blkif->vbd;
> +	struct xenbus_transaction xbt;
> +	int err;
> +
> +	if (q && q->mq_ops)
> +		vbd->nr_supported_hw_queues = q->nr_hw_queues;
> +
> +	err = xenbus_transaction_start(&xbt);
> +	if (err) {
> +		BUG_ON(!blkif->be);

This BUG_ON() isn't useful.

> +		xenbus_dev_fatal(blkif->be->dev, err, "starting transaction (hw queues)");
> +		return err;
> +	}
> +
> +	err = xenbus_printf(xbt, blkif->be->dev->nodename, "nr_supported_hw_queues", "%u",
> +			    blkif->vbd.nr_supported_hw_queues);
> +	if (err)
> +		xenbus_dev_error(blkif->be->dev, err, "writing %s/nr_supported_hw_queues",
> +				 blkif->be->dev->nodename);
> +
> +	xenbus_transaction_end(xbt, 0);

Transactions are expensive and not needed to write a single key.

Can you use the same key names as netback (multi-queue-max-queues I
think)? I don't see why we can't use a common set of key names for this.

See interface/io/netif.h for full set of keys VIFs use.

David
