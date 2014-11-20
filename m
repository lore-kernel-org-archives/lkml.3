Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbaKTQrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:47:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbaKTQra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:47:30 -0500
Date: Thu, 20 Nov 2014 18:47:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Petr Mladek <pmladek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Jeff Epler <jepler@unpythonic.net>, Jiri Kosina <jkosina@suse.cz>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] virtio_balloon: Convert "vballoon" kthread into a
 workqueue
Message-ID: <20141120164711.GA7495@redhat.com>
References: <1416499397-16669-1-git-send-email-pmladek@suse.cz>
 <20141120160746.GI14877@htj.dyndns.org>
 <20141120162543.GA7466@redhat.com>
 <20141120162624.GA7479@redhat.com>
 <20141120162935.GK14877@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120162935.GK14877@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 11:29:35AM -0500, Tejun Heo wrote:
> On Thu, Nov 20, 2014 at 06:26:24PM +0200, Michael S. Tsirkin wrote:
> > On Thu, Nov 20, 2014 at 06:25:43PM +0200, Michael S. Tsirkin wrote:
> > > On Thu, Nov 20, 2014 at 11:07:46AM -0500, Tejun Heo wrote:
> > > > On Thu, Nov 20, 2014 at 05:03:17PM +0100, Petr Mladek wrote:
> > > > ...
> > > > > @@ -476,7 +460,6 @@ static void virtballoon_remove(struct virtio_device *vdev)
> > > > >  {
> > > > >  	struct virtio_balloon *vb = vdev->priv;
> > > > >  
> > > > > -	kthread_stop(vb->thread);
> > > > >  	remove_common(vb);
> > > > >  	kfree(vb);
> > > > >  }
> > > > 
> > > > Shouldn't the work item be flushed before removal is complete?
> > > 
> > > In fact, flushing it won't help because it can requeue itself, right?
> 
> There's cancel_work_sync() to stop the self-requeueing ones.

What happens if queue_work runs while cancel_work_sync is in progress?
Does it fail to queue?

> > From that POV a dedicated WQ kept it simple.
> 
> A dedicated wq doesn't do anything for that.  You can't shut down a
> workqueue with a pending work item on it.  destroy_workqueue() will
> try to drain the target wq, warn if it doesn't finish in certain
> number of iterations and just keep trying indefinitely.
> 
> Thanks.

Right, so eventually we'll stop requeueuing and it will succeed?

> -- 
> tejun
