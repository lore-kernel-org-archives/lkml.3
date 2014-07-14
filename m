Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaGNIsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:48:13 -0400
Received: from pegasos-out.vodafone.de ([80.84.1.38]:33451 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaGNIsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:48:08 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jul 2014 04:48:08 EDT
X-Spam-Flag: NO
X-Spam-Score: -0.045
Authentication-Results: rohrpostix1.prod.vfnet.de (amavisd-new); dkim=pass
	header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de A8BFF2613C1
X-DKIM: OpenDKIM Filter v2.0.2 smtp-01.vodafone.de 8DDEFF3589
Message-ID: <53C396D3.9000600@vodafone.de>
Date: Mon, 14 Jul 2014 10:37:39 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>,
        "Bridgman, John" <John.Bridgman@amd.com>
CC: "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Gabbay, Oded" <Oded.Gabbay@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH 00/83] AMD HSA kernel driver
References: <1405028727-5276-1-git-send-email-oded.gabbay@amd.com> <20140710222423.GA14219@gmail.com> <019CCE693E457142B37B791721487FD91809E4C2@storexdag01.amd.com> <20140711211850.GU1870@gmail.com> <019CCE693E457142B37B791721487FD9180A193B@storexdag01.amd.com> <20140713035535.GB5301@gmail.com> <D89D60253BB73A4E8C62F9FD18A939CA0103C0EB@storexdag02.amd.com> <20140713164901.GB10624@gmail.com>
In-Reply-To: <20140713164901.GB10624@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I vote for HSA module that expose ioctl and is an intermediary with the
> kernel driver that handle the hardware. This gives a single point for
> HSA hardware and yes this enforce things for any hardware manufacturer.
> I am more than happy to tell them that this is it and nothing else if
> they want to get upstream.
I think we should still discuss this single point of entry a bit more.

Just to make it clear the plan is to expose all physical HSA capable 
devices through a single /dev/hsa device node to userspace.

While this obviously makes device enumeration much easier it's still a 
quite hard break with Unix traditions. Essentially we now expose all 
devices of one kind though a single device node instead of creating 
independent nodes for each physical or logical device.

What makes it even worse is that we want to expose different drivers 
though the same device node.

Because of this any effort of a system administrator to limit access to 
HSA is reduced to an on/off decision. It's simply not possible any more 
to apply simple file system access semantics to individual hardware devices.

Just imaging you are an administrator with a bunch of different compute 
cards in a system and you want to restrict access of one off them 
because it's faulty or has a security problem or something like this. Or 
you have several hardware device and want to assign each of them a 
distinct container.

Just some thoughts,
Christian.

Am 13.07.2014 18:49, schrieb Jerome Glisse:
> On Sun, Jul 13, 2014 at 03:34:12PM +0000, Bridgman, John wrote:
>>> From: Jerome Glisse [mailto:j.glisse@gmail.com]
>>> Sent: Saturday, July 12, 2014 11:56 PM
>>> To: Gabbay, Oded
>>> Cc: linux-kernel@vger.kernel.org; Bridgman, John; Deucher, Alexander;
>>> Lewycky, Andrew; joro@8bytes.org; akpm@linux-foundation.org; dri-
>>> devel@lists.freedesktop.org; airlied@linux.ie; oded.gabbay@gmail.com
>>> Subject: Re: [PATCH 00/83] AMD HSA kernel driver
>>>
>>> On Sat, Jul 12, 2014 at 09:55:49PM +0000, Gabbay, Oded wrote:
>>>> On Fri, 2014-07-11 at 17:18 -0400, Jerome Glisse wrote:
>>>>> On Thu, Jul 10, 2014 at 10:51:29PM +0000, Gabbay, Oded wrote:
>>>>>>   On Thu, 2014-07-10 at 18:24 -0400, Jerome Glisse wrote:
>>>>>>>   On Fri, Jul 11, 2014 at 12:45:27AM +0300, Oded Gabbay wrote:
>>>>>>>>    This patch set implements a Heterogeneous System
>>>>>>>> Architecture
>>>>>>>>   (HSA) driver
>>>>>>>>    for radeon-family GPUs.
>>>>>>>   This is just quick comments on few things. Given size of this,
>>>>>>> people  will need to have time to review things.
>>>>>>>>    HSA allows different processor types (CPUs, DSPs, GPUs,
>>>>>>>> etc..) to
>>>>>>>>   share
>>>>>>>>    system resources more effectively via HW features including
>>>>>>>> shared pageable
>>>>>>>>    memory, userspace-accessible work queues, and platform-level
>>>>>>>> atomics. In
>>>>>>>>    addition to the memory protection mechanisms in GPUVM and
>>>>>>>> IOMMUv2, the Sea
>>>>>>>>    Islands family of GPUs also performs HW-level validation of
>>>>>>>> commands passed
>>>>>>>>    in through the queues (aka rings).
>>>>>>>>    The code in this patch set is intended to serve both as a
>>>>>>>> sample  driver for
>>>>>>>>    other HSA-compatible hardware devices and as a production
>>>>>>>> driver  for
>>>>>>>>    radeon-family processors. The code is architected to support
>>>>>>>> multiple CPUs
>>>>>>>>    each with connected GPUs, although the current
>>>>>>>> implementation  focuses on a
>>>>>>>>    single Kaveri/Berlin APU, and works alongside the existing
>>>>>>>> radeon  kernel
>>>>>>>>    graphics driver (kgd).
>>>>>>>>    AMD GPUs designed for use with HSA (Sea Islands and up)
>>>>>>>> share  some hardware
>>>>>>>>    functionality between HSA compute and regular gfx/compute
>>>>>>>> (memory,
>>>>>>>>    interrupts, registers), while other functionality has been
>>>>>>>> added
>>>>>>>>    specifically for HSA compute  (hw scheduler for virtualized
>>>>>>>> compute rings).
>>>>>>>>    All shared hardware is owned by the radeon graphics driver,
>>>>>>>> and  an interface
>>>>>>>>    between kfd and kgd allows the kfd to make use of those
>>>>>>>> shared  resources,
>>>>>>>>    while HSA-specific functionality is managed directly by kfd
>>>>>>>> by  submitting
>>>>>>>>    packets into an HSA-specific command queue (the "HIQ").
>>>>>>>>    During kfd module initialization a char device node
>>>>>>>> (/dev/kfd) is
>>>>>>>>   created
>>>>>>>>    (surviving until module exit), with ioctls for queue
>>>>>>>> creation &  management,
>>>>>>>>    and data structures are initialized for managing HSA device
>>>>>>>> topology.
>>>>>>>>    The rest of the initialization is driven by calls from the
>>>>>>>> radeon  kgd at
>>>>>>>>    the following points :
>>>>>>>>    - radeon_init (kfd_init)
>>>>>>>>    - radeon_exit (kfd_fini)
>>>>>>>>    - radeon_driver_load_kms (kfd_device_probe, kfd_device_init)
>>>>>>>>    - radeon_driver_unload_kms (kfd_device_fini)
>>>>>>>>    During the probe and init processing per-device data
>>>>>>>> structures  are
>>>>>>>>    established which connect to the associated graphics kernel
>>>>>>>> driver. This
>>>>>>>>    information is exposed to userspace via sysfs, along with a
>>>>>>>> version number
>>>>>>>>    allowing userspace to determine if a topology change has
>>>>>>>> occurred  while it
>>>>>>>>    was reading from sysfs.
>>>>>>>>    The interface between kfd and kgd also allows the kfd to
>>>>>>>> request  buffer
>>>>>>>>    management services from kgd, and allows kgd to route
>>>>>>>> interrupt  requests to
>>>>>>>>    kfd code since the interrupt block is shared between regular
>>>>>>>>    graphics/compute and HSA compute subsystems in the GPU.
>>>>>>>>    The kfd code works with an open source usermode library
>>>>>>>>   ("libhsakmt") which
>>>>>>>>    is in the final stages of IP review and should be published
>>>>>>>> in a  separate
>>>>>>>>    repo over the next few days.
>>>>>>>>    The code operates in one of three modes, selectable via the
>>>>>>>> sched_policy
>>>>>>>>    module parameter :
>>>>>>>>    - sched_policy=0 uses a hardware scheduler running in the
>>>>>>>> MEC  block within
>>>>>>>>    CP, and allows oversubscription (more queues than HW slots)
>>>>>>>>    - sched_policy=1 also uses HW scheduling but does not allow
>>>>>>>>    oversubscription, so create_queue requests fail when we run
>>>>>>>> out  of HW slots
>>>>>>>>    - sched_policy=2 does not use HW scheduling, so the driver
>>>>>>>> manually assigns
>>>>>>>>    queues to HW slots by programming registers
>>>>>>>>    The "no HW scheduling" option is for debug & new hardware
>>>>>>>> bringup  only, so
>>>>>>>>    has less test coverage than the other options. Default in
>>>>>>>> the  current code
>>>>>>>>    is "HW scheduling without oversubscription" since that is
>>>>>>>> where  we have the
>>>>>>>>    most test coverage but we expect to change the default to
>>>>>>>> "HW  scheduling
>>>>>>>>    with oversubscription" after further testing. This
>>>>>>>> effectively  removes the
>>>>>>>>    HW limit on the number of work queues available to
>>>>>>>> applications.
>>>>>>>>    Programs running on the GPU are associated with an address
>>>>>>>> space  through the
>>>>>>>>    VMID field, which is translated to a unique PASID at access
>>>>>>>> time  via a set
>>>>>>>>    of 16 VMID-to-PASID mapping registers. The available VMIDs
>>>>>>>> (currently 16)
>>>>>>>>    are partitioned (under control of the radeon kgd) between
>>>>>>>> current
>>>>>>>>    gfx/compute and HSA compute, with each getting 8 in the
>>>>>>>> current  code. The
>>>>>>>>    VMID-to-PASID mapping registers are updated by the HW
>>>>>>>> scheduler  when used,
>>>>>>>>    and by driver code if HW scheduling is not being used.
>>>>>>>>    The Sea Islands compute queues use a new "doorbell"
>>>>>>>> mechanism  instead of the
>>>>>>>>    earlier kernel-managed write pointer registers. Doorbells
>>>>>>>> use a  separate BAR
>>>>>>>>    dedicated for this purpose, and pages within the doorbell
>>>>>>>> aperture are
>>>>>>>>    mapped to userspace (each page mapped to only one user
>>>>>>>> address  space).
>>>>>>>>    Writes to the doorbell aperture are intercepted by GPU
>>>>>>>> hardware,  allowing
>>>>>>>>    userspace code to safely manage work queues (rings) without
>>>>>>>> requiring a
>>>>>>>>    kernel call for every ring update.
>>>>>>>>    First step for an application process is to open the kfd
>>>>>>>> device.
>>>>>>>>   Calls to
>>>>>>>>    open create a kfd "process" structure only for the first
>>>>>>>> thread  of the
>>>>>>>>    process. Subsequent open calls are checked to see if they
>>>>>>>> are  from processes
>>>>>>>>    using the same mm_struct and, if so, don't do anything. The
>>>>>>>> kfd  per-process
>>>>>>>>    data lives as long as the mm_struct exists. Each mm_struct
>>>>>>>> is  associated
>>>>>>>>    with a unique PASID, allowing the IOMMUv2 to make userspace
>>>>>>>> process memory
>>>>>>>>    accessible to the GPU.
>>>>>>>>    Next step is for the application to collect topology
>>>>>>>> information  via sysfs.
>>>>>>>>    This gives userspace enough information to be able to
>>>>>>>> identify  specific
>>>>>>>>    nodes (processors) in subsequent queue management calls.
>>>>>>>>   Application
>>>>>>>>    processes can create queues on multiple processors, and
>>>>>>>> processors support
>>>>>>>>    queues from multiple processes.
>>>>>>>   I am not a fan to use sysfs to discover topoly.
>>>>>>>>    At this point the application can create work queues in
>>>>>>>> userspace  memory and
>>>>>>>>    pass them through the usermode library to kfd to have them
>>>>>>>> mapped  onto HW
>>>>>>>>    queue slots so that commands written to the queues can be
>>>>>>>> executed by the
>>>>>>>>    GPU. Queue operations specify a processor node, and so the
>>>>>>>> bulk  of this code
>>>>>>>>    is device-specific.
>>>>>>>>    Written by John Bridgman <John.Bridgman@amd.com>
>>>>>>>   So general comment is you need to collapse many patches things
>>>>>>> like
>>>>>>>   58 fixing
>>>>>>>   kernel style should be collapsed ie fix all previous patch that
>>>>>>> have  broken  style.
>>>>>>>   Even worse is thing like 71, removing code you just added few
>>>>>>> patch  earlier  in the patchset.
>>>>>>   Not quite, the code was added on patch 11.
>>>>>>>   This means that if i start reviewing following  patch order  i
>>>>>>> might spend time on code that is later deleted/modified/fixed ie
>>>>>>> time i  spend understanding and reading some code might be just
>>>>>>> wasted.
>>>>>>   Quick answer is that you are of course right, but having said
>>>>>> that, I
>>>>>>   think it would be not simple at all to do that squashing.
>>>>>>   I squashed what I could, and probably I can do a little more (like
>>>>>>   58), but the major problem is that one of the main modules of the
>>>>>>   driver - the scheduler (QCM) - was completely re-written (patches
>>>>>>   46-53). Therefore, from patch 1 to 53, we use the old scheduler
>>>>>> code
>>>>>>   and from 54 we use the new QCM (and the old scheduler code was
>>>>>>   completely remove at 71). So I could maybe squash 71 into 54, but
>>>>>> that
>>>>>>   won't help you much, I think.
>>>>>>   So, the current advice I can give is to completely ignore the
>>>>>>   following files because they do not exist in the final commit:
>>>>>>   - kfd_sched_cik_static.c (stopped using in 54)
>>>>>>   - kfd_registers.c (stopped using in 81 because we moved all
>>>>>> register
>>>>>>   writes to radeon)
>>>>>>   - kfd_hw_pointer_store.c (alive from 46 to 67)
>>>>>>   - kfd_hw_pointer_store.h (alive from 46 to 67)
>>>>>>           Oded
>>>>> Ok i try but this is driving me crazy, i am jungling btw full applied
>>>>> patchset and individual patch going back and forth trying to find
>>>>> which
>>>>> patch is the one i want to comment on. Not even mentioning that after
>>>>> that people would need to ack bad patch just because they know a
>>>>> latter
>>>>> good patch fix the badness.
>>>>>
>>>>> This patchset can be reduced to less then 10 big patches. I would
>>>>> first
>>>>> do core patches that touch core things like iommu and are preparatory
>>>>> to the patchset. Then kfd patches that do not touch anything in
>>>>> radeon
>>>>> but implement the skeleton and core infrastructure. Then radeon
>>>>> specific
>>>>> patches.
>>>> Hi Jerome,
>>>> I thought about what you said and I would like to make a suggestion. I
>>>> believe I can restructure the patchset into 10-20 patches, organized
>>>> logically and will be easier to review.
>>>>
>>>> The downside is that you will lose all references to the current
>>>> patchset and hence, all the review work you (and other people) have
>>>> done so far will be somewhat wasted. Also, the entire git history of
>>>> the driver development will be lost (at least externally).
>>> This history does not matter much.
>>>
>>>> John suggested something a bit different in the email thread of PATCH
>>>> 07/83. He said to squash everything from patch 2 to 54 (including 71)
>>>> and leave the remaining patches as they were, with maybe some
>>>> additional small squashing.
>>>>
>>>> Please tell me which option do you prefer:
>>>>
>>>> A. Continue with the review of the current patchset.
>>>> B. Go with my suggestion.
>>>> C. Go with John's suggestion.
>>>>
>>>> I'm going tomorrow (Sunday) to prepare options B & C, but I need your
>>>> input before publishing anything. So, if you could reply by Monday
>>>> morning my time, that would be great as it will allow me to publish
>>>> (if chosen) the new set by Monday morning, EST.
>>>>
>>>> And thanks again for the time you dedicate to this review. This is
>>>> highly appreciated.
>>>>
>>>>          Oded
>>> Squashing patch together will not be enough, what really needs to happen
>>> is a hsa module like drm module and radeon module registering itself into
>>> this hsa module.
>> Hi Jerome;
>>
>> Agree completely that this needs to end up as a cross-vendor core framework, but our HSAF partners are not ready to focus on standardizing the low-level implementation this point. That left us with two options -- (a) push out a framework now in the hope that other vendors would use it in the future (not a trivial thing given the wide range of hardware that can be used), or (b) push out a minimal driver with only the IOCTLs we felt could be maintained going forward, while (and this is the important part) making sure we avoided code and/or interfaces which would get in the way of making a standard "core HSA" framework in the future. Our feeling was that option (b) had a much greater chance of success and much lower risk of codifying things in the kernel which ended up not being used in the future.
>>
>> Sorry for not including this in the initial writeup -- it was getting too long already but maybe this wasn't the right thing to leave out.
>>
>> The current implementation (specifically the interface between kfd and kgd) is designed to support multiple gfx drivers for AMD hardware, and we tried to avoid any IOCTLs which would need to be replaced with multi-vendor-under-a-single-framework IOCTLs in the future, so I think we are meeting the abstract goal of not pushing something upstream that will leave litter in the kernel we all get stuck with later... in fact I really do believe this approach has the lowest risk of doing that.
>>
>> That said, at minimum we should probably identify points in the code where a "core vs HW-specific" break would live, and comment that in the code so we have an RFC of sorts for that but without trying to implement and upstream a framework in advance of sufficient cross-vendor participation.
>>
>> Would something like that be sufficient for now ?
>>
>> Thanks,
>> JB
> So i need to go over hsa specific once more but from memory doorbell, ring
> buffer with pm4 packet format are mandatory and thus the same ioctl can be
> use to setup this no matter what hardware is behind.
>
> I would rather avoid having temporary ioctl. Common ioctl can be designed
> with enough flexibilities for future change. First field of each ioctl can
> be a version field describing a structure version.
>
> I can understand the reluctance to enforce some framework to not bother
> your partner but this is the Linux kernel, and if hardware manufacturer
> wants to have their hardware supported they will have to abide by what
> ever rules the kernel community decide.
>
> I vote for HSA module that expose ioctl and is an intermediary with the
> kernel driver that handle the hardware. This gives a single point for
> HSA hardware and yes this enforce things for any hardware manufacturer.
> I am more than happy to tell them that this is it and nothing else if
> they want to get upstream.
>
> Cheers,
> Jérôme
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

