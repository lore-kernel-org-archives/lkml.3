Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423707Ab3FVDp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 23:45:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423471Ab3FVDp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 23:45:56 -0400
Message-ID: <1371872746.30572.152.camel@ul30vt.home>
Subject: Re: [PATCH] vfio: Limit group opens
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Fri, 21 Jun 2013 21:45:46 -0600
In-Reply-To: <51C5171F.70001@ozlabs.ru>
References: <20130621211144.8237.7370.stgit@bling.home>
	   <51C4FAF4.5090509@ozlabs.ru> <1371864389.30572.142.camel@ul30vt.home>
	  <51C50F98.9020301@ozlabs.ru> <1371869848.30572.148.camel@ul30vt.home>
	 <51C5171F.70001@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-22 at 13:16 +1000, Alexey Kardashevskiy wrote:
> On 06/22/2013 12:57 PM, Alex Williamson wrote:
> > On Sat, 2013-06-22 at 12:44 +1000, Alexey Kardashevskiy wrote:
> >> On 06/22/2013 11:26 AM, Alex Williamson wrote:
> >>> On Sat, 2013-06-22 at 11:16 +1000, Alexey Kardashevskiy wrote:
> >>>> Cool, thanks!
> >>>>
> >>>> So we will need only this (to be called from KVM), and that will be it, right?
> >>>
> >>> For what?  This is not the external lock you're looking for.  As I've
> >>> mentioned, the file can only hold the group, but that doesn't give you
> >>> any guarantee that the group is protected by the IOMMU.  Thanks,
> >>
> >>
> >> I am confused, sorry :) With this patch, a group fd cannot be reopened if
> >> already opened, and this is the only way for user space to take control
> >> over a group. If it is not an external lock, then what is it? And all I
> >> have to do now is to verify that the group fd passed to KVM is correct and
> >> I am happy. Who and how can break anything (group? KVM?) now?
> > 
> > By that logic all a user needs to do is open() a group and they they're
> > free to pass the fd to KVM, right?  But the IOMMU protection isn't
> > enabled until the user calls SET_CONTAINER and SET_IOMMU, so you'd be
> > giving KVM access to the IOMMU that the user hasn't enabled.  The group
> > may still have devices attached to host drivers.  Likewise, a user need
> > only call UNSET_CONTAINER to teardown the IOMMU protection.  At that
> > point a device could be re-bound to host drivers, thus making it unsafe
> > for KVM to be directly poking the IOMMU.
> > 
> > This patch is just a bug fix for inconsistent behavior.  Thanks,
> 
> Oh. Thanks for the detailed explanation, I was missing this one.
> 
> Yeah. Looks like we need some other brand new lock now... Something like a
> notifier from VFIO to KVM to inform KVM that it can or cannot use the group
> now (on VFIO_IOMMU_ENABLE/VFIO_IOMMU_DISABLE or some new ioctls) so KVM
> would not touch the group in not allowed.
> 
> typedef int notifier_fn(bool enable);
> int vfio_group_iommu_id_from_file(struct file *filep, notifier_fn fn);
> 
> ?

I don't think we need either a new lock or a notifier.  If we do as Ben
suggested and allow KVM to keep the group active then the requirements
are pretty much identical to having an open vfio device file descriptor.
This is why I suggested container_users.  I think the code I proposed
will work, it just needs a few more conditions tested when the external
user is added to make sure the group is iommu protected.  Thanks,

Alex

