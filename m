Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3JJJTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 05:19:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40866 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3JJJTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 05:19:46 -0400
Date: Thu, 10 Oct 2013 10:19:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Airlie <airlied@linux.ie>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131010091920.GO25034@n2100.arm.linux.org.uk>
References: <20131007021118.GA27927@localhost> <20131007051038.GA9764@localhost> <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com> <20131007083505.GA22585@localhost> <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com> <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com> <20131008020918.GA1220@localhost> <20131008021452.GA6456@localhost> <20131008080625.GA25034@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1310100322040.14436@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1310100322040.14436@skynet.skynet.ie>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 03:23:45AM +0100, Dave Airlie wrote:
> 
> > I think David Arlie also needs a quiet talking to about how to use the
> > device model:
> > 
> > int drm_sysfs_device_add(struct drm_minor *minor)
> > {
> >         minor->kdev.release = drm_sysfs_device_release;
> > ...
> >         err = device_register(&minor->kdev);
> > }
> > 
> > static void drm_sysfs_device_release(struct device *dev)
> > {
> >         memset(dev, 0, sizeof(struct device));
> >         return;
> > }
> > 
> > Since when has that been acceptable in a release function?
> 
> Well the commit that added it had a reason that seems to cover some other 
> device model abuses, so maybe someone who actually understands the device 
> model (all 2 people) can review usage.

Please - there's more than two people who understand this stuff.

You appear to manage to understand the refcounting principle for things
like the DRM framebuffers, DRM buffer objects etc, and the driver model
(and kobjects in general) are no different.

I've just been reading the code around here little more, and hit the usb
implementation.  I don't see how USB drivers get cleaned up when they're
disconnected from the USB bus.  I see drm_unplug_dev() which gets called
on a USB disconnection (from udl/udl_drv.c) which effectively makes the
device unavailable, but I don't see anything which frees anything.  I see
nothing calling drm_put_dev() here.  How does the drm_device in this case
get freed?
