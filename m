Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab3AKRlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:41:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34896 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3AKRlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:41:06 -0500
Date: Fri, 11 Jan 2013 12:40:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Cc: viro@ZenIV.linux.org.uk, david.vrabel@citrix.com,
        stefano.stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: oopsable race in xen-gntdev [PATCH 0/3]
Message-ID: <20130111174053.GD26287@phenom.dumpdata.com>
References: <20121221201824.GA31554@phenom.dumpdata.com>
 <1357167433-16874-1-git-send-email-dgdegra@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357167433-16874-1-git-send-email-dgdegra@tycho.nsa.gov>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 05:57:10PM -0500, Daniel De Graaf wrote:
> On 12/21/2012 03:18 PM, Konrad Rzeszutek Wilk wrote:
> > On Sat, Dec 15, 2012 at 06:12:11PM +0000, Al Viro wrote:
> >> 	1) find_vma() is *not* safe without ->mmap_sem and its result may
> >> very well be freed just as it's returned to caller.  IOW,
> >> gntdev_ioctl_get_offset_for_vaddr() is racy and may end up with
> >> dereferencing freed memory.
> 
> I agree, this one should be fixed by taking mmap_sem in
> gntdev_ioctl_get_offset_for_vaddr. Iterating the grant_map list here
> will not work under HVM, where map->vma is not filled in.
> 
> >> 	2) gntdev_vma_close() is putting NULL into map->vma with only
> >> ->mmap_sem held by caller.  Things like
> >>                 if (!map->vma)
> >>                         continue;
> >>                 if (map->vma->vm_start >= end)
> >>                         continue;
> >>                 if (map->vma->vm_end <= start)
> >> done with just priv->lock held are racy.
> >>
> >> 	I'm not familiar with the code, but it looks like we need to
> >> protect gntdev_vma_close() guts with the same spinlock and probably
> >> hold ->mmap_sem shared around the "find_vma()+get to map->{index,count}"
> >> in the ioctl.  Or replace the logics in ioctl with search through the
> >> list of grant_map under the same spinlock...
> >>
> >> 	Comments?
> 
> Although I don't think the mmu notifier is ever called without mmap_sem
> on this particular device file (we map only with VM_DONTCOPY and other
> paths like truncate generally aren't triggered), it's probably best not
> to rely on that behavior, so adding the spinlock in gntdev_vma_close
> seems to be the best solution.
> 
> > Hey Al,
> > 
> > Thank you for your analysis.

Are you OK with the patches or have comments about them? Thanks.

> > 
> > CC-ing Daniel, David and Stefano. I recall we had some priv->lock movement
> > in the past and there is also interaction with another piece of code - 
> > the balloon code so we better be circumspect of not blowing up.
> > 
> > Al, it is around holidays and folks are mostly gone - so this will take
> > a bit of time to get sorted out.
> 
> While I was digging in this code, I found a related bug in
> mn_invl_range_start: if gntdev_ioctl_unmap_grant_ref is called on
> a range before unmapping it, the entry is removed from priv->maps and
> the later call to mn_invl_range_start won't find it to do the unmapping.
> This could be fixed by using find_vma, but I don't think there's a safe
> way to do that from inside the mmu notifier, so instead I created a list
> of these unlinked but still mapped pages.
> 
> The third patch is a fix to an unrelated bug that I found while testing
> the fixes in the other two patches.
> 
> [PATCH 1/3] xen/gntdev: fix unsafe vma access
> [PATCH 2/3] xen/gntdev: correctly unmap unlinked maps in mmu
> [PATCH 3/3] xen/gntdev: remove erronous use of copy_to_user
