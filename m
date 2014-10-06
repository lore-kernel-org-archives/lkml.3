Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaJFM1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:27:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbaJFM1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:27:43 -0400
Date: Mon, 6 Oct 2014 15:31:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 06/16] virtio_blk: drop config_enable
Message-ID: <20141006123110.GA26815@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
 <1412525038-15871-7-git-send-email-mst@redhat.com>
 <20141006134229.45465bf7.cornelia.huck@de.ibm.com>
 <20141006120953.GA26549@redhat.com>
 <20141006142038.07ea01f0.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006142038.07ea01f0.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 02:20:38PM +0200, Cornelia Huck wrote:
> On Mon, 6 Oct 2014 15:09:53 +0300
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > On Mon, Oct 06, 2014 at 01:42:29PM +0200, Cornelia Huck wrote:
> > > On Sun, 5 Oct 2014 19:07:07 +0300
> > > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > 
> > > > Now that virtio core ensures config changes don't
> > > > arrive during probing, drop config_enable flag
> > > > in virtio blk.
> > > > On removal, flush is now sufficient to guarantee that
> > > > no change work is queued.
> > > > 
> > > > This help simplify the driver, and will allow
> > > > setting DRIVER_OK earlier without losing config
> > > > change notifications.
> > > > 
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > ---
> > > >  drivers/block/virtio_blk.c | 19 ++-----------------
> > > >  1 file changed, 2 insertions(+), 17 deletions(-)
> > > > 
> > > > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > > > index 0a58140..c8cf6a1 100644
> > > > --- a/drivers/block/virtio_blk.c
> > > > +++ b/drivers/block/virtio_blk.c
> > > 
> > > > @@ -772,9 +766,7 @@ static void virtblk_remove(struct virtio_device *vdev)
> > > >  	int refc;
> > > > 
> > > >  	/* Prevent config work handler from accessing the device. */
> > > 
> > > /* Common code ensures no further work will be queued. */
> > > 
> > > instead?
> > 
> > No, I think you missed the point:
> > this comment now refers to the flush below: flush is required to
> > ensure work handler is not running.
> > 
> > Agree?
> 
> I think we both mean the same thing.
> 
> Preventing the handler from access sounds to me more like "when the
> handler starts running, it is prevented from accessing the
> device" (like with setting config_enable, as the code did before). What
> I meant was "common code has already ensured that our work-queueing
> function will not be called, therefore flushing the workqueue is
> enough."
> 
> (same for net)

OK so I'll rewrite this to
	/* Make sure no work handler is accessing the device. */
?
I prefer not duplicating core guarantees in all devices.

-- 
MST
