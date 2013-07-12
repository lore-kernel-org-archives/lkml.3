Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab3GLHo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:44:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab3GLHo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:44:28 -0400
Date: Fri, 12 Jul 2013 09:46:00 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Message-ID: <20130712074559.GA8727@dhcp-26-207.brq.redhat.com>
References: <cover.1369155164.git.agordeev@redhat.com>
 <20130521235003.GE6985@mtj.dyndns.org>
 <20130522143923.GD19383@dhcp-26-207.brq.redhat.com>
 <20130522170305.GD9563@kernel.dk>
 <20130711102630.GA11133@dhcp-26-207.brq.redhat.com>
 <1373583637.7397.370.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373583637.7397.370.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 04:00:37PM -0700, Nicholas A. Bellinger wrote:
> On Thu, 2013-07-11 at 12:26 +0200, Alexander Gordeev wrote:
> > On Wed, May 22, 2013 at 07:03:05PM +0200, Jens Axboe wrote:
> > > On Wed, May 22 2013, Alexander Gordeev wrote:
> > > > On Wed, May 22, 2013 at 08:50:03AM +0900, Tejun Heo wrote:
> > > > > Hmmmmmm..... I'd normally apply this patch but block layer is just
> > > > > growing multi-queue support and libata is likely to be converted to mq
> > > > > in foreseeable future, so I'm a bit hesitant to make irq handling more
> > > > > sophiscated right now.  Would you be interested in looking into
> > > > > converting libata to blk mq support?  I'm pretty sure it'd yield far
> > > > > better outcome if done properly.
> > > > 
> > > > I am not committing, but will look into it, sure.
> > > 
> > > Would be most awesome, I'm sure Nic would not mind a bit of help on the
> > > SCSI/libata side :-)
> > 
> > Hi Nicholas,
> > 
> > Could you please clarify the status of SCSI MQ support? Is it usable now?
> > 
> 
> Hi Alexander,
> 
> Thanks for taking a look.  I've not made further progress in the last
> weeks on scsi-mq, but am still using virtio-scsi + scsi-mq <->
> vhost-scsi + per-cpu-ida for quite a bit for benchmarking purposes.

Thanks for the clarification, Nicholas.

> > I tried git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git,
> > but it does not appear working without (at least) changes below to SCSI lib:
> > 
> 
> The only scsi-mq LLD conversions so far have been to virtio-scsi +
> scsi_debug to nop REQ_TYPE_FS.

I see. Do you think the changes I made is a right way to go?

I had to make it to avoid a NULL-pointer assignent and make BIO bounce
buffers work, but I do not really understand the mixture of old and
new code ( neither in fact :) )

> Just so I understand, your patch below is required in order to make what
> LLD function with scsi-mq..?

ata_piix

> 
> Thanks!
> 
> --nab
> 
> > Thanks!
> > 
> > diff --git a/drivers/scsi/scsi-mq.c b/drivers/scsi/scsi-mq.c
> > index ca6ff67..d8cc7a4 100644
> > --- a/drivers/scsi/scsi-mq.c
> > +++ b/drivers/scsi/scsi-mq.c
> > @@ -155,6 +155,7 @@ void scsi_mq_done(struct scsi_cmnd *sc)
> >  static struct blk_mq_ops scsi_mq_ops = {
> >  	.queue_rq	= scsi_mq_queue_rq,
> >  	.map_queue	= blk_mq_map_queue,
> > +	.timeout	= scsi_times_out,
> >  	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
> >  	.free_hctx	= blk_mq_free_single_hw_queue,
> >  };
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 65360db..33aa373 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -283,7 +283,10 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
> >  	/*
> >  	 * head injection *required* here otherwise quiesce won't work
> >  	 */
> > -	blk_execute_rq(req->q, NULL, req, 1);
> > +	if (q->mq_ops)
> > +		blk_mq_execute_rq(req->q, req);
> > +	else
> > +		blk_execute_rq(req->q, NULL, req, 1);
> >  
> >  	/*
> >  	 * Some devices (USB mass-storage in particular) may transfer
> > @@ -298,12 +301,8 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
> >  		*resid = req->resid_len;
> >  	ret = req->errors;
> >   out:
> > -	if (q->mq_ops) {
> > -		printk("scsi_execute(): Calling blk_mq_free_request >>>\n");
> > -		blk_mq_free_request(req);
> > -	} else {
> > +	if (!q->mq_ops)
> >  		blk_put_request(req);
> > -	}
> >  
> >  	return ret;
> >  }
> > 
> > 
> > > And personally, can't wait to run it on the laptop! That's right, I
> > > alpha test on the laptop.
> > > 
> > > -- 
> > > Jens Axboe
> > > 
> > 
> 
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
