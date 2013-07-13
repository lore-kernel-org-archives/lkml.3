Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab3GMFPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 01:15:11 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:42483 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3GMFPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 01:15:07 -0400
Message-ID: <1373692812.7397.625.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        Jens Axboe <axboe@kernel.dk>
Date: Fri, 12 Jul 2013 22:20:12 -0700
In-Reply-To: <20130712074559.GA8727@dhcp-26-207.brq.redhat.com>
References: <cover.1369155164.git.agordeev@redhat.com>
	 <20130521235003.GE6985@mtj.dyndns.org>
	 <20130522143923.GD19383@dhcp-26-207.brq.redhat.com>
	 <20130522170305.GD9563@kernel.dk>
	 <20130711102630.GA11133@dhcp-26-207.brq.redhat.com>
	 <1373583637.7397.370.camel@haakon3.risingtidesystems.com>
	 <20130712074559.GA8727@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 09:46 +0200, Alexander Gordeev wrote:
> On Thu, Jul 11, 2013 at 04:00:37PM -0700, Nicholas A. Bellinger wrote:
> > On Thu, 2013-07-11 at 12:26 +0200, Alexander Gordeev wrote:
> > > On Wed, May 22, 2013 at 07:03:05PM +0200, Jens Axboe wrote:
> > > > On Wed, May 22 2013, Alexander Gordeev wrote:
> > > > > On Wed, May 22, 2013 at 08:50:03AM +0900, Tejun Heo wrote:
> > > > > > Hmmmmmm..... I'd normally apply this patch but block layer is just
> > > > > > growing multi-queue support and libata is likely to be converted to mq
> > > > > > in foreseeable future, so I'm a bit hesitant to make irq handling more
> > > > > > sophiscated right now.  Would you be interested in looking into
> > > > > > converting libata to blk mq support?  I'm pretty sure it'd yield far
> > > > > > better outcome if done properly.
> > > > > 
> > > > > I am not committing, but will look into it, sure.
> > > > 
> > > > Would be most awesome, I'm sure Nic would not mind a bit of help on the
> > > > SCSI/libata side :-)
> > > 
> > > Hi Nicholas,
> > > 
> > > Could you please clarify the status of SCSI MQ support? Is it usable now?
> > > 
> > 
> > Hi Alexander,
> > 
> > Thanks for taking a look.  I've not made further progress in the last
> > weeks on scsi-mq, but am still using virtio-scsi + scsi-mq <->
> > vhost-scsi + per-cpu-ida for quite a bit for benchmarking purposes.
> 
> Thanks for the clarification, Nicholas.
> 
> > > I tried git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git,
> > > but it does not appear working without (at least) changes below to SCSI lib:
> > > 
> > 
> > The only scsi-mq LLD conversions so far have been to virtio-scsi +
> > scsi_debug to nop REQ_TYPE_FS.
> 
> I see. Do you think the changes I made is a right way to go?
> 
> I had to make it to avoid a NULL-pointer assignent and make BIO bounce
> buffers work, but I do not really understand the mixture of old and
> new code ( neither in fact :) )
> 

Hi Alexander,

Comments below.

> > Just so I understand, your patch below is required in order to make what
> > LLD function with scsi-mq..?
> 
> ata_piix
> 

<nod>

> > 
> > Thanks!
> > 
> > --nab
> > 
> > > Thanks!
> > > 
> > > diff --git a/drivers/scsi/scsi-mq.c b/drivers/scsi/scsi-mq.c
> > > index ca6ff67..d8cc7a4 100644
> > > --- a/drivers/scsi/scsi-mq.c
> > > +++ b/drivers/scsi/scsi-mq.c
> > > @@ -155,6 +155,7 @@ void scsi_mq_done(struct scsi_cmnd *sc)
> > >  static struct blk_mq_ops scsi_mq_ops = {
> > >  	.queue_rq	= scsi_mq_queue_rq,
> > >  	.map_queue	= blk_mq_map_queue,
> > > +	.timeout	= scsi_times_out,
> > >  	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
> > >  	.free_hctx	= blk_mq_free_single_hw_queue,
> > >  };

So your actually triggering a blk-mq timeout with ata_piix..?

> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index 65360db..33aa373 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -283,7 +283,10 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
> > >  	/*
> > >  	 * head injection *required* here otherwise quiesce won't work
> > >  	 */
> > > -	blk_execute_rq(req->q, NULL, req, 1);
> > > +	if (q->mq_ops)
> > > +		blk_mq_execute_rq(req->q, req);
> > > +	else
> > > +		blk_execute_rq(req->q, NULL, req, 1);
> > >  

The scsi_execute() -> REQ_TYPE_BLOCK_RQ special case (scsi_scan +
scsi_ioctl) has a small issue preventing it's conversion to use
blk_mq_execute_rq().

Namely that scsi_execute_cmd() currently expects to be able to check for
the existence of req->errors + req->resid_len *after*
blk_mq_execute_rq() -> blk_mq_finish_request() -> blk_mq_free_request()
has been called to mark the pre-allocated struct request as free for
blk-mq re-use.

That is why scsi-mq still uses blk_execute_rq() for this reason, and
this will need be addressed in order to safely use blk_mq_execute_rq()
in the above context.

> > >  	/*
> > >  	 * Some devices (USB mass-storage in particular) may transfer
> > > @@ -298,12 +301,8 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
> > >  		*resid = req->resid_len;
> > >  	ret = req->errors;
> > >   out:
> > > -	if (q->mq_ops) {
> > > -		printk("scsi_execute(): Calling blk_mq_free_request >>>\n");
> > > -		blk_mq_free_request(req);
> > > -	} else {
> > > +	if (!q->mq_ops)
> > >  		blk_put_request(req);
> > > -	}
> > >  

Do you have an OOPs backtrace handy to post w/o the last two changes in
place..?

Also, just a heads up that so far I've been using IDE (/dev/hdX) for the
root-device in order to make scsi-mq debugging safer and easier.

I *very* much recommend doing the same if at all possible for ata_piix
scsi-mq development + testing, as you'll want to be very careful when
using a real file-system on top of this early alpha code.

--nab

