Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbaKTQ3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:29:40 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:58281 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbaKTQ3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:29:39 -0500
Date: Thu, 20 Nov 2014 11:29:35 -0500
From: Tejun Heo <tj@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Petr Mladek <pmladek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Jeff Epler <jepler@unpythonic.net>, Jiri Kosina <jkosina@suse.cz>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] virtio_balloon: Convert "vballoon" kthread into a
 workqueue
Message-ID: <20141120162935.GK14877@htj.dyndns.org>
References: <1416499397-16669-1-git-send-email-pmladek@suse.cz>
 <20141120160746.GI14877@htj.dyndns.org>
 <20141120162543.GA7466@redhat.com>
 <20141120162624.GA7479@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120162624.GA7479@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 06:26:24PM +0200, Michael S. Tsirkin wrote:
> On Thu, Nov 20, 2014 at 06:25:43PM +0200, Michael S. Tsirkin wrote:
> > On Thu, Nov 20, 2014 at 11:07:46AM -0500, Tejun Heo wrote:
> > > On Thu, Nov 20, 2014 at 05:03:17PM +0100, Petr Mladek wrote:
> > > ...
> > > > @@ -476,7 +460,6 @@ static void virtballoon_remove(struct virtio_device *vdev)
> > > >  {
> > > >  	struct virtio_balloon *vb = vdev->priv;
> > > >  
> > > > -	kthread_stop(vb->thread);
> > > >  	remove_common(vb);
> > > >  	kfree(vb);
> > > >  }
> > > 
> > > Shouldn't the work item be flushed before removal is complete?
> > 
> > In fact, flushing it won't help because it can requeue itself, right?

There's cancel_work_sync() to stop the self-requeueing ones.

> From that POV a dedicated WQ kept it simple.

A dedicated wq doesn't do anything for that.  You can't shut down a
workqueue with a pending work item on it.  destroy_workqueue() will
try to drain the target wq, warn if it doesn't finish in certain
number of iterations and just keep trying indefinitely.

Thanks.

-- 
tejun
