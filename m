Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3A1PpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:45:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44609 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3A1PpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:45:07 -0500
Date: Mon, 28 Jan 2013 10:44:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>, stable@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blkback: Check for insane amounts of
 request on the ring.
Message-ID: <20130128154450.GG4838@konrad-lan.dumpdata.com>
References: <1359135152-30688-1-git-send-email-konrad.wilk@oracle.com>
 <1359135152-30688-4-git-send-email-konrad.wilk@oracle.com>
 <20130125184323.GC1384@phenom.dumpdata.com>
 <5106634A.2000308@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5106634A.2000308@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 11:38:50AM +0000, David Vrabel wrote:
> On 25/01/13 18:43, Konrad Rzeszutek Wilk wrote:
> > 
> > Check that the ring does not have an insane amount of requests
> > (more than there could fit on the ring).
> [...]
> > --- a/drivers/block/xen-blkback/blkback.c
> > +++ b/drivers/block/xen-blkback/blkback.c
> [...]
> > @@ -415,8 +415,12 @@ int xen_blkif_schedule(void *arg)
> >  		blkif->waiting_reqs = 0;
> >  		smp_mb(); /* clear flag *before* checking for work */
> >  
> > -		if (do_block_io_op(blkif))
> > +		rc = do_block_io_op(blkif);
> > +		if (rc > 0)
> >  			blkif->waiting_reqs = 1;
> > +		if (rc == -EACCES)
> > +			wait_event_interruptible(blkif->shutdown_wq,
> > +						 kthread_should_stop());
> 
> So if this happens then the backend silently stops processing any
> further requests?  I think it should print an error and disconnect from
> the front end.

I was not sure what it should print?

"Frontend provided bogus ring requests. Halting ring processing"?

It does eventually disconnect from the front-end as the XenBus enters
the Disconnect phase. It seemed the strike the balance - so that if
the frontend negotiates again the ring can start again and penalize
the frontend for giving bogus data.

> 
> David
