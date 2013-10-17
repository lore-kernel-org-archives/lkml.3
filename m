Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab3JQO6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:58:31 -0400
Received: from c60.cesmail.net ([216.154.195.49]:19639 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757166Ab3JQO63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:58:29 -0400
Date: Thu, 17 Oct 2013 10:58:24 -0400
From: Pavel Roskin <proski@gnu.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: never write to the userspace more data than the
 caller wants
Message-ID: <20131017105824.74960f34@IRBT4585>
In-Reply-To: <20131017122647.GC6862@nuc-i3427.alporthouse.com>
References: <20131017001235.3077.92963.stgit@IRBT4585>
	<20131017122647.GC6862@nuc-i3427.alporthouse.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013 13:26:47 +0100
Chris Wilson <chris@chris-wilson.co.uk> wrote:

> On Wed, Oct 16, 2013 at 08:12:35PM -0400, Pavel Roskin wrote:
> > The amount of data wanted by the userspace caller is encoded in the
> > ioctl number.  Generic drm ioctls were ignoring it.
> > 
> > As a result, Intel Xorg driver didn't work for i386 userspace on
> > x86_64 kernel on some systems.  sizeof(struct
> > drm_mode_get_connector) is 76 bytes on i686 and 80 bytes on x86_64
> > due to the tail alignment (the data positions match).  The
> > userspace was using the 4 bytes after the structure to hold the
> > result of the ioctl.  Since drm_ioctl() was copying 80 bytes
> > instead of 76, it was clobbering that data.
> > 
> > A workaround has been committed to xf86-video-intel.
> > 
> > Signed-off-by: Pavel Roskin <proski@gnu.org>
> > Cc: stable@vger.kernel.org
> 
> Similar patch:
> http://lists.freedesktop.org/archives/dri-devel/2013-October/047412.html
> -Chris

Wow, it's great that you also thought about it!

Your patch does almost the same thing.  There is one difference.  If
the userspace requests more data than the kernel needs, your patch would
trust the userspace and set usize to whatever the user wants.  It would
set asize to the same value, allocating more memory than the driver
wants, up to 16383 bytes.  I don't think it's a good idea for
performance reasons.  My patch would decrease usize rather than increase
asize.

The code for driver-specific ioctls could be fixed too, it's just not
so urgent as fixing a real bug.

That said, I have no format objection against your patch.  It would be
great to have that bug fixed.

-- 
Regards,
Pavel Roskin
