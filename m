Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab3GAWaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:30:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab3GAWaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:30:17 -0400
Date: Mon, 1 Jul 2013 15:30:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>, Aaron Lu <aaron.lu@intel.com>,
        Jens Axboe <axboe@kernel.dk>, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Fix possible sleep in invalid context
Message-Id: <20130701153015.9842a0b2d291e01105d853d0@linux-foundation.org>
In-Reply-To: <1372717451.2385.58.camel@dabdike>
References: <1372692515-31969-1-git-send-email-sthumma@codeaurora.org>
	<20130701151712.f453745bc0c587f449cc3214@linux-foundation.org>
	<1372717451.2385.58.camel@dabdike>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Jul 2013 15:24:11 -0700 James Bottomley <James.Bottomley@hansenpartnership.com> wrote:

> > --- a/block/blk-core.c~block-fix-possible-sleep-in-invalid-context-fix
> > +++ a/block/blk-core.c
> > @@ -3159,15 +3159,14 @@ EXPORT_SYMBOL(blk_pre_runtime_resume);
> >   */
> >  void blk_post_runtime_resume(struct request_queue *q, int err)
> >  {
> > +	spin_lock_irq(q->queue_lock);
> >  	if (!err) {
> > -		spin_lock_irq(q->queue_lock);
> >  		q->rpm_status = RPM_ACTIVE;
> >  		__blk_run_queue(q);
> >  		pm_runtime_mark_last_busy(q->dev);
> >  		spin_unlock_irq(q->queue_lock);
> >  		pm_request_autosuspend(q->dev);
> >  	} else {
> > -		spin_lock_irq(q->queue_lock);
> >  		q->rpm_status = RPM_SUSPENDED;
> >  		spin_unlock_irq(q->queue_lock);
> >  	}
> > _
> > 
> > 
> > I wonder if we actually need locking around that second write to
> > q->rpm_status.
> 
> Shouldn't: it's an int, which makes it a 32 bit quantity we believe to
> have atomic write properties on every platform.

Yes, but.  If there's some other code path which does:

	spin_lock(queue_lock);
	x = q->rpm_status;
	...
	y = q->rpm_status;
	...
	<assumes x == y>
	spin_unlock(queue_lock);

then it blows up if we make the suggested change.  Stranger things have
happened...

