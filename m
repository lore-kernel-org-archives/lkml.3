Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaGAVH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:07:29 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:43746 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaGAVH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:07:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-sh@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v7] media: vb2: Take queue or device lock in mmap-related vb2 ioctl handlers
Date: Tue, 01 Jul 2014 23:08:22 +0200
Message-ID: <2051293.PjTd9YAWz0@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53AAFF9B.5000403@oracle.com>
References: <201308061239.27188.hverkuil@xs4all.nl> <537F5315.8030705@xs4all.nl> <53AAFF9B.5000403@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2014 12:58:03 Sasha Levin wrote:
> Ping?

Hans, I've replied to your previous e-mail with

I'm of course fine with a different way to solve the race condition, if we can 
find a good one. Do you already know how you would like to solve this ?

> On 05/23/2014 09:54 AM, Hans Verkuil wrote:
> > Hi Laurent,
> > 
> > This patch caused a circular locking dependency as reported by Sasha
> > Levin:
> > 
> > https://lkml.org/lkml/2014/5/5/366
> > 
> > The reason is that copy_to/from_user is called in video_usercopy() with
> > the
> > core lock held. The copy functions can fault which takes the mmap_sem. If
> > it was just video_usercopy() then it would be fairly easy to solve this,
> > but the copy_to_/from_user functions are also called from read and write
> > and they can be used in other unexpected places.
> > 
> > I'm not sure if vb2_fop_get_unmapped_area() is a problem. I suspect (but
> > I'm not sure) that when that one is called the mmap_sem isn't taken, in
> > which case taking the lock is fine.
> > 
> > But taking the lock in vb2_fop_mmap() does cause lockdep problems.
> > 
> > Ideally I would like to drop taking that lock in vb2_fop_mmap and resolve
> > the race condition that it intended to fix in a different way.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > On 08/06/2013 10:10 PM, Laurent Pinchart wrote:
> >> The vb2_fop_mmap() and vb2_fop_get_unmapped_area() functions are plug-in
> >> implementation of the mmap() and get_unmapped_area() file operations
> >> that calls vb2_mmap() and vb2_get_unmapped_area() on the queue
> >> associated with the video device. Neither the
> >> vb2_fop_mmap/vb2_fop_get_unmapped_area nor the
> >> v4l2_mmap/vb2_get_unmapped_area functions in the V4L2 core take any
> >> lock, leading to race conditions between mmap/get_unmapped_area and
> >> other buffer-related ioctls such as VIDIOC_REQBUFS.
> >> 
> >> Fix it by taking the queue or device lock around the vb2_mmap() and
> >> vb2_get_unmapped_area() calls.
> >> 
> >> Signed-off-by: Laurent Pinchart
> >> <laurent.pinchart+renesas@ideasonboard.com>
> >> ---
> >> 
> >>  drivers/media/v4l2-core/videobuf2-core.c | 18 ++++++++++++++++--
> >>  1 file changed, 16 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> >> b/drivers/media/v4l2-core/videobuf2-core.c index 9fc4bab..c9b50c7 100644
> >> --- a/drivers/media/v4l2-core/videobuf2-core.c
> >> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> >> @@ -2578,8 +2578,15 @@ EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
> >>  int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
> >>  {
> >>  	struct video_device *vdev = video_devdata(file);
> >> +	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock :
> >> vdev->lock;
> >> +	int err;
> >> 
> >> -	return vb2_mmap(vdev->queue, vma);
> >> +	if (lock && mutex_lock_interruptible(lock))
> >> +		return -ERESTARTSYS;
> >> +	err = vb2_mmap(vdev->queue, vma);
> >> +	if (lock)
> >> +		mutex_unlock(lock);
> >> +	return err;
> >>  }
> >>  EXPORT_SYMBOL_GPL(vb2_fop_mmap);
> >> 
> >> @@ -2685,8 +2692,15 @@ unsigned long vb2_fop_get_unmapped_area(struct
> >> file *file, unsigned long addr,>> 
> >>  		unsigned long len, unsigned long pgoff, unsigned long flags)
> >>  {
> >>  	struct video_device *vdev = video_devdata(file);
> >> +	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock :
> >> vdev->lock;
> >> +	int ret;
> >> 
> >> -	return vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
> >> +	if (lock && mutex_lock_interruptible(lock))
> >> +		return -ERESTARTSYS;
> >> +	ret = vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
> >> +	if (lock)
> >> +		mutex_unlock(lock);
> >> +	return ret;
> >> 
> >>  }
> >>  EXPORT_SYMBOL_GPL(vb2_fop_get_unmapped_area);
> >>  #endif

-- 
Regards,

Laurent Pinchart

