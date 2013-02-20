Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935856Ab3BTET6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:19:58 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:54417 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933954Ab3BTET4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:19:56 -0500
Message-ID: <51244F10.3000002@ozlabs.ru>
Date: Wed, 20 Feb 2013 15:20:32 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: David Gibson <david@gibson.dropbear.id.au>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: making IOMMU sysfs nodes API public
References: <1360628713.3248.8.camel@bling.home>   <1360642004-7419-1-git-send-email-aik@ozlabs.ru>   <1360645643.3248.91.camel@bling.home> <511A54DC.9030908@ozlabs.ru>   <1360689304.3248.154.camel@bling.home> <5121C709.80007@ozlabs.ru>   <1361251440.2801.142.camel@bling.home>   <20130219073853.GS21067@truffula.fritz.box>  <1361304711.2801.232.camel@bling.home> <51243567.5080602@ozlabs.ru> <1361332078.2801.275.camel@bling.home>
In-Reply-To: <1361332078.2801.275.camel@bling.home>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/02/13 14:47, Alex Williamson wrote:
> On Wed, 2013-02-20 at 13:31 +1100, Alexey Kardashevskiy wrote:
>> On 20/02/13 07:11, Alex Williamson wrote:
>>> On Tue, 2013-02-19 at 18:38 +1100, David Gibson wrote:
>>>> On Mon, Feb 18, 2013 at 10:24:00PM -0700, Alex Williamson wrote:
>>>>> On Mon, 2013-02-18 at 17:15 +1100, Alexey Kardashevskiy wrote:
>>>>>> On 13/02/13 04:15, Alex Williamson wrote:
>>>>>>> On Wed, 2013-02-13 at 01:42 +1100, Alexey Kardashevskiy wrote:
>>>>>>>> On 12/02/13 16:07, Alex Williamson wrote:
>>>>>>>>> On Tue, 2013-02-12 at 15:06 +1100, Alexey Kardashevskiy wrote:
>>>>>>>>>> Having this patch in a tree, adding new nodes in sysfs
>>>>>>>>>> for IOMMU groups is going to be easier.
>>>>>>>>>>
>>>>>>>>>> The first candidate for this change is a "dma-window-size"
>>>>>>>>>> property which tells a size of a DMA window of the specific
>>>>>>>>>> IOMMU group which can be used later for locked pages accounting.
>>>>>>>>>
>>>>>>>>> I'm still churning on this one; I'm nervous this would basically creat
>>>>>>>>> a /proc free-for-all under /sys/kernel/iommu_group/$GROUP/ where any
>>>>>>>>> iommu driver can add random attributes.  That can get ugly for
>>>>>>>>> userspace.
>>>>>>>>
>>>>>>>> Is not it exactly what sysfs is for (unlike /proc)? :)
>>>>>>>
>>>>>>> Um, I hope it's a little more thought out than /proc.
>>>>>>>
>>>>>>>>> On the other hand, for the application of userspace knowing how much
>>>>>>>>> memory to lock for vfio use of a group, it's an appealing location to
>>>>>>>>> get that information.  Something like libvirt would already be poking
>>>>>>>>> around here to figure out which devices to bind.  Page limits need to be
>>>>>>>>> setup prior to use through vfio, so sysfs is more convenient than
>>>>>>>>> through vfio ioctls.
>>>>>>>>
>>>>>>>> True. DMA window properties do not change since boot so sysfs is the right
>>>>>>>> place to expose them.
>>>>>>>>
>>>>>>>>> But then is dma-window-size just a vfio requirement leaking over into
>>>>>>>>> iommu groups?  Can we allow iommu driver based attributes without giving
>>>>>>>>> up control of the namespace?  Thanks,
>>>>>>>>
>>>>>>>> Who are you asking these questions? :)
>>>>>>>
>>>>>>> Anyone, including you.  Rather than dropping misc files in sysfs to
>>>>>>> describe things about the group, I think the better solution in your
>>>>>>> case might be a link from the group to an existing sysfs directory
>>>>>>> describing the PE.  I believe your PE is rooted in a PCI bridge, so that
>>>>>>> presumably already has a representation in sysfs.  Can the aperture size
>>>>>>> be determined from something in sysfs for that bridge already?  I'm just
>>>>>>> not ready to create a grab bag of sysfs entries for a group yet.
>>>>>>> Thanks,
>>>>>>
>>>>>>
>>>>>> At the moment there is no information neither in sysfs nor
>>>>>> /proc/device-tree about the dma-window. And adding a sysfs entry per PE
>>>>>> (powerpc partitionable end-point which is often a PHB but not always) just
>>>>>> for VFIO is quite heavy.
>>>>>
>>>>> How do you learn the window size and PE extents in the host kernel?
>>>>>
>>>>>> We could add a ppc64 subfolder under /sys/kernel/iommu/xxx/ and put the
>>>>>> "dma-window" property there. And replace it with a symlink when and if we
>>>>>> add something for PE later. Would work?
>>>>
>>>> Fwiw, I'd suggest a subfolder named for the type of IOMMU, rather than
>>>> "ppc64".
>>>>
>>>>> To be clear, you're suggesting /sys/kernel/iommu_groups/$GROUP/xxx/,
>>>>> right?  A subfolder really only limits the scope of the mess, so it's
>>>>> not much improvement.  What does the interface look like to make those
>>>>> subfolders?
>>>>>
>>>>> The problem we're trying to solve is this call flow:
>>>>>
>>>>> containerfd = open("/dev/vfio/vfio");
>>>>> ioctl(containerfd, VFIO_GET_API_VERSION);
>>>>> ioctl(containerfd, VFIO_CHECK_EXTENSION, ...);
>>>>> groupfd = open("/dev/vfio/$GROUP");
>>>>> ioctl(groupfd, VFIO_GROUP_GET_STATUS);
>>>>> ioctl(groupfd, VFIO_GROUP_SET_CONTAINER, &containerfd);
>>>>>
>>>>> You wanted to lock all the memory for the DMA window here, before we can
>>>>> call VFIO_IOMMU_GET_INFO, but does it need to happen there?  We still
>>>>> have a MAP_DMA hook.  We could do it all on the first mapping.
>>>>
>>>> MAP_DMA isn't quite enough, since the guest can also directly cause
>>>> mappings using hypercalls directly implemented in KVM.  I think it
>>>> would be feasible to lock on the first mapping (either via MAP_DMA, or
>>>> H_PUT_TCE) though it would be a bit ugly and require that the first
>>>> H_PUT_TCE always bounce out to virtual mode (Alexey, correct me if I'm
>>>> wrong here).  IIRC there is also a call to bind the vfio container to
>>>> a (qemu assigned) LIOBN, before the guest can use H_PUT_TCE directly,
>>>> so that might be another place we could do the lock.
>>>
>>> Somehow hypercall mappings have to be gated by the userspace setup,
>>> right?
>>
>>
>> There is a KVM ioctl (and a KVM capability) which hooks LIOBN (PCI bus ID)
>> with IOMMU ID. It basically creates an entry in the list of all LIOBNs and
>> when TCE call occurs, the host finds correct IOMMU group to pass this call to.
>>
>> It happens from spapr_register_vfio_container() in QEMU, i.e. after getting
>> DMA window properties but only if the host supports real mode TCE handling.
>>
>>
>>>>>    It also
>>>>> has a flags field that could augment the behavior to trigger page
>>>>> locking.
>>>>
>>>> I don't see how the flags help us - we can't have userspace choose to
>>>> skip the locked memory accounting.  Or are you suggesting a flag to
>>>> open the container in some sort of dummy mode where only GET_INFO is
>>>> possible, then re-open with the full locking?
>>>
>>> Sort of, I don't think it needs to be re-opened, but we had previously
>>> talked about some kind of enable and disable ioctl.  "enable" would be
>>> the logical place to lock pages, but then we probably got stuck in
>>> questions around what it means to enable an iommu generically.
>>
>> The other question is if a container is ready to work if I add just one
>> group? What happens when I add another one (not supported on ppc64 but
>> still)?
>
> This is also the problem with exposing a dma window under the group in
> sysfs.  Do I require the ability to lock the sum of the window, the
> largest window, what?  If we rely on the ioctls, userspace can figure
> out that they can't be combined and know it's the sum.  I'm not sure
> what your plans are around hotplug of a PHB though.
>
>> Having "enable" method and disabling new attachments when it is
>> "enabled" would keep my brain calm :)
>
> Now I'm not sure whether you're for or against it ;)


I am for introducing enable() ioctls :) Or even "lock" ioctl.


>>> So what
>>> if instead of a separate enable ioctl we had a flag on DMA_MAP that was
>>> defined as SET_WINDOW where iova and size are passed and specify the
>>> portion of the DMA window that userspace intends to use and which is
>>> therefore locked.  If you don't support subwindows, fine, just fail it.
>>> You could have a matching PUT_WINDOW on DMA_UNMAP if you wanted.
>>
>> DMA_MAP which does not do "map" but does "lock" or "set window"?
>> enable()/disable() look better.
>
> Sure, this is why we have a modular iommu interface, spapr can create an
> enable ioctl if necessary.  I think there are ways to use the
> DMA_MAP/UNMAP ioctl in ways that aren't a complete kludge though.
>
>>>>>    Adding the window size to sysfs seems more readily convenient,
>>>>> but is it so hard for userspace to open the files and call a couple
>>>>> ioctls to get far enough to call IOMMU_GET_INFO?  I'm unconvinced the
>>>>> clutter in sysfs more than just a quick fix.  Thanks,
>>>>
>>>> And finally, as Alexey points out, isn't the point here so we know how
>>>> much rlimit to give qemu?  Using ioctls we'd need a special tool just
>>>> to check the dma window sizes, which seems a bit hideous.
>>>
>>> Is it more hideous that using iommu groups to report a vfio imposed
>>> restriction?  Are a couple open files and a handful of ioctls worse than
>>> code to parse directory entries and the future maintenance of an
>>> unrestricted grab bag of sysfs entries?
>>
>> At the moment DMA32 window properties are static. So I can easily get rid
>> of VFIO_IOMMU_SPAPR_TCE_GET_INFO and be happy.
>
> Like, for instance, every PE always gets 512MB DMA window, fixed base
> address, not configurable, end of story?


Almost :) 1GB, starting at 0 (sometime at 2GB). Multiple PCI domains are 
supported on ppc64 so it does not make a problem as bus address spaces are 
separated. But yes, not flexible at all.


>> Ah, anyway, how do you see these ioctls to work on a user machine?
>> A separate tool which takes an iommu id, returns DMA window size and
>> adjusts rlimit?
>
> Sure, we need something that provides the function of libvirt and
> unbinds devices from host drivers, re-binds them to vfio-pci.  That tool
> needs to have permissions to manipulate groups, so we're just talking
> about whether it's stepping over the line for it to open the group and a
> container, associate them, and probe the iommu info vs reading a sysfs
> file.  Thanks,

So the Tool is going to be a part of libvirt but not kernel or qemu, right?
Then implementing "LOCK" (and call it after GET_INFO in QEMU and not call 
it from the Tool) should work fine.



-- 
Alexey
