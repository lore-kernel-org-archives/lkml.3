Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015Ab3BSTxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:53:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933770Ab3BSTxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:53:45 -0500
Message-ID: <1361303610.2801.218.camel@bling.home>
Subject: Re: [PATCH] iommu: making IOMMU sysfs nodes API public
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Date: Tue, 19 Feb 2013 12:53:30 -0700
In-Reply-To: <51231231.1040908@ozlabs.ru>
References: <1360628713.3248.8.camel@bling.home>
	    <1360642004-7419-1-git-send-email-aik@ozlabs.ru>
	   <1360645643.3248.91.camel@bling.home> <511A54DC.9030908@ozlabs.ru>
	  <1360689304.3248.154.camel@bling.home> <5121C709.80007@ozlabs.ru>
	 <1361251440.2801.142.camel@bling.home> <51231231.1040908@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-19 at 16:48 +1100, Alexey Kardashevskiy wrote:
> On 19/02/13 16:24, Alex Williamson wrote:
> > On Mon, 2013-02-18 at 17:15 +1100, Alexey Kardashevskiy wrote:
> >> On 13/02/13 04:15, Alex Williamson wrote:
> >>> On Wed, 2013-02-13 at 01:42 +1100, Alexey Kardashevskiy wrote:
> >>>> On 12/02/13 16:07, Alex Williamson wrote:
> >>>>> On Tue, 2013-02-12 at 15:06 +1100, Alexey Kardashevskiy wrote:
> >>>>>> Having this patch in a tree, adding new nodes in sysfs
> >>>>>> for IOMMU groups is going to be easier.
> >>>>>>
> >>>>>> The first candidate for this change is a "dma-window-size"
> >>>>>> property which tells a size of a DMA window of the specific
> >>>>>> IOMMU group which can be used later for locked pages accounting.
> >>>>>
> >>>>> I'm still churning on this one; I'm nervous this would basically creat
> >>>>> a /proc free-for-all under /sys/kernel/iommu_group/$GROUP/ where any
> >>>>> iommu driver can add random attributes.  That can get ugly for
> >>>>> userspace.
> >>>>
> >>>> Is not it exactly what sysfs is for (unlike /proc)? :)
> >>>
> >>> Um, I hope it's a little more thought out than /proc.
> >>>
> >>>>> On the other hand, for the application of userspace knowing how much
> >>>>> memory to lock for vfio use of a group, it's an appealing location to
> >>>>> get that information.  Something like libvirt would already be poking
> >>>>> around here to figure out which devices to bind.  Page limits need to be
> >>>>> setup prior to use through vfio, so sysfs is more convenient than
> >>>>> through vfio ioctls.
> >>>>
> >>>> True. DMA window properties do not change since boot so sysfs is the right
> >>>> place to expose them.
> >>>>
> >>>>> But then is dma-window-size just a vfio requirement leaking over into
> >>>>> iommu groups?  Can we allow iommu driver based attributes without giving
> >>>>> up control of the namespace?  Thanks,
> >>>>
> >>>> Who are you asking these questions? :)
> >>>
> >>> Anyone, including you.  Rather than dropping misc files in sysfs to
> >>> describe things about the group, I think the better solution in your
> >>> case might be a link from the group to an existing sysfs directory
> >>> describing the PE.  I believe your PE is rooted in a PCI bridge, so that
> >>> presumably already has a representation in sysfs.  Can the aperture size
> >>> be determined from something in sysfs for that bridge already?  I'm just
> >>> not ready to create a grab bag of sysfs entries for a group yet.
> >>> Thanks,
> >>
> >>
> >> At the moment there is no information neither in sysfs nor
> >> /proc/device-tree about the dma-window. And adding a sysfs entry per PE
> >> (powerpc partitionable end-point which is often a PHB but not always) just
> >> for VFIO is quite heavy.
> >
> > How do you learn the window size and PE extents in the host kernel?
> 
> 
> When the ppc64 code does PCI scan, it creates iommu_table structs per PE. 
> When new PE (i.e. new iommu_table) is discovered I call iommu_group_alloc() 
> and iommu_group_set_iommudata() to link iommu_group with iommu_table. These 
> iommu_table structs have DMA window properties.
> 
> 
> >> We could add a ppc64 subfolder under /sys/kernel/iommu/xxx/ and put the
> >> "dma-window" property there. And replace it with a symlink when and if we
> >> add something for PE later. Would work?
> >
> > To be clear, you're suggesting /sys/kernel/iommu_groups/$GROUP/xxx/,
> > right?  A subfolder really only limits the scope of the mess, so it's
> > not much improvement.
> 
> You suggested some symlink to some ppc64 or pci tree in sysfs, it is not 
> that different.
> 
> > What does the interface look like to make those
> > subfolders?
> 
> int iommu_group_create_platform_file(struct iommu_group *group,
>                       struct iommu_group_attribute *attr)
> 
> and that's it.
> 
> > The problem we're trying to solve is this call flow:
> >
> > containerfd = open("/dev/vfio/vfio");
> > ioctl(containerfd, VFIO_GET_API_VERSION);
> > ioctl(containerfd, VFIO_CHECK_EXTENSION, ...);
> > groupfd = open("/dev/vfio/$GROUP");
> > ioctl(groupfd, VFIO_GROUP_GET_STATUS);
> > ioctl(groupfd, VFIO_GROUP_SET_CONTAINER, &containerfd);
> >
> > You wanted to lock all the memory for the DMA window here, before we can
> > call VFIO_IOMMU_GET_INFO, but does it need to happen there?  We still
> > have a MAP_DMA hook.  We could do it all on the first mapping.  It also
> > has a flags field that could augment the behavior to trigger page
> > locking.  Adding the window size to sysfs seems more readily convenient,
> > but is it so hard for userspace to open the files and call a couple
> > ioctls to get far enough to call IOMMU_GET_INFO?  I'm unconvinced the
> > clutter in sysfs more than just a quick fix.  Thanks,
> 
> 
> I thought the problem is that we want to let user set correct rlimit before 
> running QEMU, no? We do not change rlimit from QEMU.

Sure, but nothing stops userspace from doing this same thing.  Userspace
might already want to open the group and call GET_STATUS on it to make
sure it's usable.  If we look at the complexity of parsing an unmanaged
namespace in sysfs vs opening a couple of character devices and a
handful of ioctls to get a table of info about the iommu, what's the
difference?  Sysfs is easier to script but it's also duplicating an
interface that we already have elsewhere.  vfio is the one locking
pages, so it's the one imposing the locked memory requirement, not iommu
groups.  IMHO, sysfs is attractive because it makes scripting easy, but
it's not the right place for it.  Thanks,

Alex

