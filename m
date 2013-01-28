Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3A1Li7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:38:59 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:4372 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab3A1Lix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:38:53 -0500
X-IronPort-AV: E=Sophos;i="4.84,551,1355097600"; 
   d="scan'208";a="5029071"
Message-ID: <5106634A.2000308@citrix.com>
Date: Mon, 28 Jan 2013 11:38:50 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>, <stable@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blkback: Check for insane amounts
 of request on the ring.
References: <1359135152-30688-1-git-send-email-konrad.wilk@oracle.com>	<1359135152-30688-4-git-send-email-konrad.wilk@oracle.com> <20130125184323.GC1384@phenom.dumpdata.com>
In-Reply-To: <20130125184323.GC1384@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/01/13 18:43, Konrad Rzeszutek Wilk wrote:
> 
> Check that the ring does not have an insane amount of requests
> (more than there could fit on the ring).
[...]
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
[...]
> @@ -415,8 +415,12 @@ int xen_blkif_schedule(void *arg)
>  		blkif->waiting_reqs = 0;
>  		smp_mb(); /* clear flag *before* checking for work */
>  
> -		if (do_block_io_op(blkif))
> +		rc = do_block_io_op(blkif);
> +		if (rc > 0)
>  			blkif->waiting_reqs = 1;
> +		if (rc == -EACCES)
> +			wait_event_interruptible(blkif->shutdown_wq,
> +						 kthread_should_stop());

So if this happens then the backend silently stops processing any
further requests?  I think it should print an error and disconnect from
the front end.

David
