Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaF2UrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 16:47:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaF2UrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 16:47:05 -0400
Date: Sun, 29 Jun 2014 23:47:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Brian Lane <bcl@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, John McCutchan <john@johnmccutchan.com>,
        Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: virt_blk BUG: sleeping function called from invalid context
Message-ID: <20140629204710.GB11100@redhat.com>
References: <CA+5PVA4h2hQJLrAm4eEZ8oUgGiAjq2y5eAyBcJWxK_FiQXnuQg@mail.gmail.com>
 <20140629082637.GA23942@redhat.com>
 <20140629193222.GA7030@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140629193222.GA7030@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 09:32:22PM +0200, Christoph Hellwig wrote:
> On Sun, Jun 29, 2014 at 11:26:37AM +0300, Michael S. Tsirkin wrote:
> > On Fri, Jun 27, 2014 at 07:57:38AM -0400, Josh Boyer wrote:
> > > Hi All,
> > > 
> > > We've had a report[1] of the virt_blk driver causing a lot of spew
> > > because it's calling a sleeping function from an invalid context.  The
> > > backtrace is below.  This is with kernel v3.16-rc2-69-gd91d66e88ea9.
> > 
> > Hi Jens, pls see below - it looks like the call to blk_mq_end_io
> > from IRQ context is causing the issue.
> > IIUC you switched virtio to this from __blk_end_request_all in
> > 
> > commit 1cf7e9c68fe84248174e998922b39e508375e7c1
> >     virtio_blk: blk-mq support
> > 
> > Is this always safe?
> > I note that at least one other driver is doing this:
> > drivers/block/mtip32xx/mtip32xx.c
> 
> Just like __blk_end_request_all blk_mq_end_io is supposed to be called
> from irq context.  The problem is that the MD bio end_io handler is calling
> a sleeping function.  Not sure if that's a bug in MD though given the
> kernfs symbols in the all trace and the recent churn in that area.

My understanding is this:

bitmap_endwrite -> calls sysfs_notify_dirent_safe under spinlock
 -> calls kernfs_notify which takes a mutex.

So I am guessing it is this commit:

commit d911d98748018f7c8facc035ba39c30f5cce6f9c
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Apr 9 11:07:31 2014 -0400

    kernfs: make kernfs_notify() trigger inotify events too

Tejun, what do you think?

Josh, Brian, could you try reverting that commit to see if it helps?

-- 
MST
