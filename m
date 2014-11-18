Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaKRPyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:54:06 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:53542 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbaKRPyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:54:03 -0500
Date: Tue, 18 Nov 2014 15:53:57 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2 -next] mfd: dln2: a couple endian fixes
Message-ID: <20141118155357.GC13959@x1>
References: <20141113103607.GB17038@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141113103607.GB17038@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, Dan Carpenter wrote:

> Sparse catches a couple endian bugs.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Not tested.

Applied until someone screams.

> diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
> index 3101e5e..babf7b6 100644
> --- a/drivers/mfd/dln2.c
> +++ b/drivers/mfd/dln2.c
> @@ -437,6 +437,7 @@ static int _dln2_transfer(struct dln2_dev *dln2, u16 handle, u16 cmd,
>  	struct device *dev = &dln2->interface->dev;
>  	const unsigned long timeout = DLN2_USB_TIMEOUT * HZ / 1000;
>  	struct dln2_mod_rx_slots *rxs = &dln2->mod_rx_slots[handle];
> +	int size;
>  
>  	spin_lock(&dln2->disconnect_lock);
>  	if (!dln2->disconnect)
> @@ -476,8 +477,9 @@ static int _dln2_transfer(struct dln2_dev *dln2, u16 handle, u16 cmd,
>  
>  	/* if we got here we know that the response header has been checked */
>  	rsp = rxc->urb->transfer_buffer;
> +	size = le16_to_cpu(rsp->hdr.size);
>  
> -	if (rsp->hdr.size < sizeof(*rsp)) {
> +	if (size < sizeof(*rsp)) {
>  		ret = -EPROTO;
>  		goto out_free_rx_slot;
>  	}
> @@ -494,8 +496,8 @@ static int _dln2_transfer(struct dln2_dev *dln2, u16 handle, u16 cmd,
>  		goto out_free_rx_slot;
>  	}
>  
> -	if (*ibuf_len > rsp->hdr.size - sizeof(*rsp))
> -		*ibuf_len = rsp->hdr.size - sizeof(*rsp);
> +	if (*ibuf_len > size - sizeof(*rsp))
> +		*ibuf_len = size - sizeof(*rsp);
>  
>  	memcpy(ibuf, rsp + 1, *ibuf_len);
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
