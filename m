Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaGLJZF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 05:25:05 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:11376
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752074AbaGLJY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 05:24:58 -0400
X-WSS-ID: 0N8LE5I-07-54S-02
X-M-MSG: 
Message-ID: <53C0FEE1.50206@amd.com>
Date: Sat, 12 Jul 2014 11:24:49 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>, "Gabbay, Oded" <Oded.Gabbay@amd.com>
CC: "oded.gabbay@gmail.com" <oded.gabbay@gmail.com>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/83] AMD HSA kernel driver
References: <1405028727-5276-1-git-send-email-oded.gabbay@amd.com>
 <20140710222423.GA14219@gmail.com>
 <019CCE693E457142B37B791721487FD91809E4C2@storexdag01.amd.com>
 <20140711211850.GU1870@gmail.com>
In-Reply-To: <20140711211850.GU1870@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
X-Originating-IP: [10.224.155.37]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(377424004)(199002)(24454002)(51704005)(15202345003)(15975445006)(107046002)(85306003)(95666004)(92726001)(93886003)(65816999)(86362001)(83072002)(54356999)(83322001)(19580395003)(50466002)(106466001)(20776003)(77982001)(23756003)(47776003)(44976005)(85852003)(80022001)(74502001)(76482001)(74662001)(46102001)(99396002)(102836001)(83506001)(79102001)(50986999)(101416001)(92566001)(31966008)(68736004)(4396001)(105586002)(21056001)(64706001)(19580405001)(76176999)(64126003)(81342001)(97736001)(36756003)(33656002)(81542001)(87936001)(65956001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB037;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0270ED2845
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.07.2014 23:18, schrieb Jerome Glisse:
> On Thu, Jul 10, 2014 at 10:51:29PM +0000, Gabbay, Oded wrote:
>> On Thu, 2014-07-10 at 18:24 -0400, Jerome Glisse wrote:
>>> On Fri, Jul 11, 2014 at 12:45:27AM +0300, Oded Gabbay wrote:
>>>>   This patch set implements a Heterogeneous System Architecture
>>>> (HSA) driver
>>>>   for radeon-family GPUs.
>>>   
>>> This is just quick comments on few things. Given size of this, people
>>> will need to have time to review things.
>>>   
>>>>   HSA allows different processor types (CPUs, DSPs, GPUs, etc..) to
>>>> share
>>>>   system resources more effectively via HW features including
>>>> shared pageable
>>>>   memory, userspace-accessible work queues, and platform-level
>>>> atomics. In
>>>>   addition to the memory protection mechanisms in GPUVM and
>>>> IOMMUv2, the Sea
>>>>   Islands family of GPUs also performs HW-level validation of
>>>> commands passed
>>>>   in through the queues (aka rings).
>>>>   The code in this patch set is intended to serve both as a sample
>>>> driver for
>>>>   other HSA-compatible hardware devices and as a production driver
>>>> for
>>>>   radeon-family processors. The code is architected to support
>>>> multiple CPUs
>>>>   each with connected GPUs, although the current implementation
>>>> focuses on a
>>>>   single Kaveri/Berlin APU, and works alongside the existing radeon
>>>> kernel
>>>>   graphics driver (kgd).
>>>>   AMD GPUs designed for use with HSA (Sea Islands and up) share
>>>> some hardware
>>>>   functionality between HSA compute and regular gfx/compute (memory,
>>>>   interrupts, registers), while other functionality has been added
>>>>   specifically for HSA compute  (hw scheduler for virtualized
>>>> compute rings).
>>>>   All shared hardware is owned by the radeon graphics driver, and
>>>> an interface
>>>>   between kfd and kgd allows the kfd to make use of those shared
>>>> resources,
>>>>   while HSA-specific functionality is managed directly by kfd by
>>>> submitting
>>>>   packets into an HSA-specific command queue (the "HIQ").
>>>>   During kfd module initialization a char device node (/dev/kfd) is
>>>> created
>>>>   (surviving until module exit), with ioctls for queue creation &
>>>> management,
>>>>   and data structures are initialized for managing HSA device
>>>> topology.
>>>>   The rest of the initialization is driven by calls from the radeon
>>>> kgd at
>>>>   the following points :
>>>>   - radeon_init (kfd_init)
>>>>   - radeon_exit (kfd_fini)
>>>>   - radeon_driver_load_kms (kfd_device_probe, kfd_device_init)
>>>>   - radeon_driver_unload_kms (kfd_device_fini)
>>>>   During the probe and init processing per-device data structures
>>>> are
>>>>   established which connect to the associated graphics kernel
>>>> driver. This
>>>>   information is exposed to userspace via sysfs, along with a
>>>> version number
>>>>   allowing userspace to determine if a topology change has occurred
>>>> while it
>>>>   was reading from sysfs.
>>>>   The interface between kfd and kgd also allows the kfd to request
>>>> buffer
>>>>   management services from kgd, and allows kgd to route interrupt
>>>> requests to
>>>>   kfd code since the interrupt block is shared between regular
>>>>   graphics/compute and HSA compute subsystems in the GPU.
>>>>   The kfd code works with an open source usermode library
>>>> ("libhsakmt") which
>>>>   is in the final stages of IP review and should be published in a
>>>> separate
>>>>   repo over the next few days.
>>>>   The code operates in one of three modes, selectable via the
>>>> sched_policy
>>>>   module parameter :
>>>>   - sched_policy=0 uses a hardware scheduler running in the MEC
>>>> block within
>>>>   CP, and allows oversubscription (more queues than HW slots)
>>>>   - sched_policy=1 also uses HW scheduling but does not allow
>>>>   oversubscription, so create_queue requests fail when we run out
>>>> of HW slots
>>>>   - sched_policy=2 does not use HW scheduling, so the driver
>>>> manually assigns
>>>>   queues to HW slots by programming registers
>>>>   The "no HW scheduling" option is for debug & new hardware bringup
>>>> only, so
>>>>   has less test coverage than the other options. Default in the
>>>> current code
>>>>   is "HW scheduling without oversubscription" since that is where
>>>> we have the
>>>>   most test coverage but we expect to change the default to "HW
>>>> scheduling
>>>>   with oversubscription" after further testing. This effectively
>>>> removes the
>>>>   HW limit on the number of work queues available to applications.
>>>>   Programs running on the GPU are associated with an address space
>>>> through the
>>>>   VMID field, which is translated to a unique PASID at access time
>>>> via a set
>>>>   of 16 VMID-to-PASID mapping registers. The available VMIDs
>>>> (currently 16)
>>>>   are partitioned (under control of the radeon kgd) between current
>>>>   gfx/compute and HSA compute, with each getting 8 in the current
>>>> code. The
>>>>   VMID-to-PASID mapping registers are updated by the HW scheduler
>>>> when used,
>>>>   and by driver code if HW scheduling is not being used.
>>>>   The Sea Islands compute queues use a new "doorbell" mechanism
>>>> instead of the
>>>>   earlier kernel-managed write pointer registers. Doorbells use a
>>>> separate BAR
>>>>   dedicated for this purpose, and pages within the doorbell
>>>> aperture are
>>>>   mapped to userspace (each page mapped to only one user address
>>>> space).
>>>>   Writes to the doorbell aperture are intercepted by GPU hardware,
>>>> allowing
>>>>   userspace code to safely manage work queues (rings) without
>>>> requiring a
>>>>   kernel call for every ring update.
>>>>   First step for an application process is to open the kfd device.
>>>> Calls to
>>>>   open create a kfd "process" structure only for the first thread
>>>> of the
>>>>   process. Subsequent open calls are checked to see if they are
>>>> from processes
>>>>   using the same mm_struct and, if so, don't do anything. The kfd
>>>> per-process
>>>>   data lives as long as the mm_struct exists. Each mm_struct is
>>>> associated
>>>>   with a unique PASID, allowing the IOMMUv2 to make userspace
>>>> process memory
>>>>   accessible to the GPU.
>>>>   Next step is for the application to collect topology information
>>>> via sysfs.
>>>>   This gives userspace enough information to be able to identify
>>>> specific
>>>>   nodes (processors) in subsequent queue management calls.
>>>> Application
>>>>   processes can create queues on multiple processors, and
>>>> processors support
>>>>   queues from multiple processes.
>>>   
>>> I am not a fan to use sysfs to discover topoly.
>>>   
>>>>   At this point the application can create work queues in userspace
>>>> memory and
>>>>   pass them through the usermode library to kfd to have them mapped
>>>> onto HW
>>>>   queue slots so that commands written to the queues can be
>>>> executed by the
>>>>   GPU. Queue operations specify a processor node, and so the bulk
>>>> of this code
>>>>   is device-specific.
>>>>   Written by John Bridgman <John.Bridgman@amd.com>
>>>   
>>> So general comment is you need to collapse many patches things like
>>> 58 fixing
>>> kernel style should be collapsed ie fix all previous patch that have
>>> broken
>>> style.
>>>   
>>> Even worse is thing like 71, removing code you just added few patch
>>> earlier
>>> in the patchset.
>> Not quite, the code was added on patch 11.
>>
>>> This means that if i start reviewing following
>>> patch order
>>> i might spend time on code that is later deleted/modified/fixed ie
>>> time i
>>> spend understanding and reading some code might be just wasted.
>> Quick answer is that you are of course right, but having said that, I
>> think it would be not simple at all to do that squashing.
>> I squashed what I could, and probably I can do a little more (like
>> 58), but the major problem is that one of the main modules of the
>> driver - the scheduler (QCM) - was completely re-written (patches
>> 46-53). Therefore, from patch 1 to 53, we use the old scheduler code
>> and from 54 we use the new QCM (and the old scheduler code was
>> completely remove at 71). So I could maybe squash 71 into 54, but that
>> won't help you much, I think.
>>
>> So, the current advice I can give is to completely ignore the
>> following files because they do not exist in the final commit:
>> - kfd_sched_cik_static.c (stopped using in 54)
>> - kfd_registers.c (stopped using in 81 because we moved all register
>> writes to radeon)
>> - kfd_hw_pointer_store.c (alive from 46 to 67)
>> - kfd_hw_pointer_store.h (alive from 46 to 67)
>>
>>          Oded
> Ok i try but this is driving me crazy, i am jungling btw full applied
> patchset and individual patch going back and forth trying to find which
> patch is the one i want to comment on. Not even mentioning that after
> that people would need to ack bad patch just because they know a latter
> good patch fix the badness.
>
> This patchset can be reduced to less then 10 big patches. I would first
> do core patches that touch core things like iommu and are preparatory
> to the patchset. Then kfd patches that do not touch anything in radeon
> but implement the skeleton and core infrastructure. Then radeon specific
> patches.
>
> This lead me to the design, all the core kfd helper should be in hsa
> directory, and should be helper, while all specific bits to radeon
> should most likely be part of the radeon gfx kernel module. I am not
> against a radeon_kfd but realy i do not see the point. There should
> be a hsa.ko like there is a drm.ko.

Yeah totally agree with Jerome here.

Maybe I can explain a bit further what the difference in the design is. 
First of all for other good examples see not only the DRM 
infrastructure, but also V4L or other Linux driver subsystems as well.

In those subsystems it's not the helper functions that control the 
driver, but instead the driver that controls the helper functions. E.g. 
if HSA wants to be a new subsystem with a standardized IOCTL interface 
it should provide functions that assists drivers with implementing the 
interface instead of implementing it themselves and then trying to talk 
to the drivers for necessary resources/operations.

Coming back to the structure of the patches one of the very first 
patches should be the IOCTL definition a driver needs to implement to be 
HSA conform.

I think it would be a good idea to split out changes to core structures 
like IOMMU in it's own separately submitted patches, only with the 
notice that this functionality is needed by the following "core HSA" and 
"HSA for radeon" patchsets.

Regards,
Christian.

>
> Also i think it would be benefical to rename kfd to hsa because it is
> the most common name and the name that will bring valid hit with web
> search.
>
> Each of the patch should have a proper commit message that is not too
> cryptic without being too chatty either.
>
> Cheers,
> Jérôme
>
>>> I will come back with individual patch comments and also general
>>> remarks.
>>>   
>>> Cheers,
>>> Jérôme
>>>   
>>>   
>>>>   Alexey Skidanov (4):
>>>>     hsa/radeon: 32-bit processes support
>>>>     hsa/radeon: NULL pointer dereference bug workaround
>>>>     hsa/radeon: HSA64/HSA32 modes support
>>>>     hsa/radeon: Add local memory to topology
>>>>   Andrew Lewycky (3):
>>>>     hsa/radeon: Make binding of process to device permanent
>>>>     hsa/radeon: Implement hsaKmtSetMemoryPolicy
>>>>     mm: Change timing of notification to IOMMUs about a page to be
>>>>       invalidated
>>>>   Ben Goz (20):
>>>>     hsa/radeon: Add queue and hw_pointer_store modules
>>>>     hsa/radeon: Add support allocating kernel doorbells
>>>>     hsa/radeon: Add mqd_manager module
>>>>     hsa/radeon: Add kernel queue support for KFD
>>>>     hsa/radeon: Add module parameter of scheduling policy
>>>>     hsa/radeon: Add packet manager module
>>>>     hsa/radeon: Add process queue manager module
>>>>     hsa/radeon: Add device queue manager module
>>>>     hsa/radeon: Switch to new queue scheduler
>>>>     hsa/radeon: Add IOCTL for update queue
>>>>     hsa/radeon: Queue Management integration with Memory Management
>>>>     hsa/radeon: update queue fault handling
>>>>     hsa/radeon: fixing a bug to support 32b processes
>>>>     hsa/radeon: Fix number of pipes per ME
>>>>     hsa/radeon: Removing hw pointer store module
>>>>     hsa/radeon: Adding some error messages
>>>>     hsa/radeon: Fixing minor issues with kernel queues (DIQ)
>>>>     drm/radeon: Add register access functions to kfd2kgd interface
>>>>     hsa/radeon: Eliminating all direct register accesses
>>>>     drm/radeon: Remove lock functions from kfd2kgd interface
>>>>   Evgeny Pinchuk (9):
>>>>     hsa/radeon: fix the OEMID assignment in kfd_topology
>>>>     drm/radeon: extending kfd-kgd interface
>>>>     hsa/radeon: implementing IOCTL for clock counters
>>>>     drm/radeon: adding synchronization for GRBM GFX
>>>>     hsa/radeon: fixing clock counters bug
>>>>     drm/radeon: Extending kfd interface
>>>>     hsa/radeon: Adding max clock speeds to topology
>>>>     hsa/radeon: Alternating the source of max clock
>>>>     hsa/radeon: Exclusive access for perf. counters
>>>>   Michael Varga (1):
>>>>     hsa/radeon: debugging print statements
>>>>   Oded Gabbay (45):
>>>>     mm: Add kfd_process pointer to mm_struct
>>>>     drm/radeon: reduce number of free VMIDs and pipes in KV
>>>>     drm/radeon: Report doorbell configuration to kfd
>>>>     drm/radeon: Add radeon <--> kfd interface
>>>>     drm/radeon: Add kfd-->kgd interface to get virtual ram size
>>>>     drm/radeon: Add kfd-->kgd interfaces of memory
>>>> allocation/mapping
>>>>     drm/radeon: Add kfd-->kgd interface of locking srbm_gfx_cntl
>>>> register
>>>>     drm/radeon: Add calls to initialize and finalize kfd from radeon
>>>>     hsa/radeon: Add code base of hsa driver for AMD's GPUs
>>>>     hsa/radeon: Add initialization and unmapping of doorbell
>>>> aperture
>>>>     hsa/radeon: Add scheduler code
>>>>     hsa/radeon: Add kfd mmap handler
>>>>     hsa/radeon: Add 2 new IOCTL to kfd, CREATE_QUEUE and
>>>> DESTROY_QUEUE
>>>>     hsa/radeon: Update MAINTAINERS and CREDITS files
>>>>     hsa/radeon: Add interrupt handling module
>>>>     hsa/radeon: Add the isr function of the KFD scehduler
>>>>     hsa/radeon: Handle deactivation of queues using interrupts
>>>>     hsa/radeon: Enable interrupts in KFD scheduler
>>>>     hsa/radeon: Enable/Disable KFD interrupt module
>>>>     hsa/radeon: Add interrupt callback function to kgd2kfd interface
>>>>     hsa/radeon: Add kgd-->kfd interfaces for suspend and resume
>>>>     drm/radeon: Add calls to suspend and resume of kfd driver
>>>>     drm/radeon/cik: Don't touch int of pipes 1-7
>>>>     drm/radeon/cik: Call kfd isr function
>>>>     hsa/radeon: Fix memory size allocated for HPD
>>>>     hsa/radeon: Fix list of supported devices
>>>>     hsa/radeon: Fix coding style in cik_int.h
>>>>     hsa/radeon: Print ioctl commnad only in debug mode
>>>>     hsa/radeon: Print ISR info only in debug mode
>>>>     hsa/radeon: Workaround for a bug in amd_iommu
>>>>     hsa/radeon: Eliminate warnings in compilation
>>>>     hsa/radeon: Various kernel styling fixes
>>>>     hsa/radeon: Rearrange structures in kfd_ioctl.h
>>>>     hsa/radeon: change another pr_info to pr_debug
>>>>     hsa/radeon: Fix timeout calculation in sync_with_hw
>>>>     hsa/radeon: Update module information and version
>>>>     hsa/radeon: Update module version to 0.6.0
>>>>     hsa/radeon: Fix initialization of sh_mem registers
>>>>     hsa/radeon: Fix compilation warnings
>>>>     hsa/radeon: Remove old scheduler code
>>>>     hsa/radeon: Static analysis (smatch) fixes
>>>>     hsa/radeon: Check oversubscription before destroying runlist
>>>>     hsa/radeon: Don't verify cksum when parsing CRAT table
>>>>     hsa/radeon: Update module version to 0.6.1
>>>>     hsa/radeon: Update module version to 0.6.2
>>>>   Yair Shachar (1):
>>>>     hsa/radeon: Adding qcm fence return status
>>>>    CREDITS                                            |    7 +
>>>>    MAINTAINERS                                        |    8 +
>>>>    drivers/Kconfig                                    |    2 +
>>>>    drivers/gpu/Makefile                               |    1 +
>>>>    drivers/gpu/drm/radeon/Makefile                    |    1 +
>>>>    drivers/gpu/drm/radeon/cik.c                       |  156 +--
>>>>    drivers/gpu/drm/radeon/cikd.h                      |   51 +-
>>>>    drivers/gpu/drm/radeon/radeon.h                    |    9 +
>>>>    drivers/gpu/drm/radeon/radeon_device.c             |   32 +
>>>>    drivers/gpu/drm/radeon/radeon_drv.c                |    6 +
>>>>    drivers/gpu/drm/radeon/radeon_kfd.c                |  630
>>>> ++++++++++
>>>>    drivers/gpu/drm/radeon/radeon_kms.c                |    9 +
>>>>    drivers/gpu/hsa/Kconfig                            |   20 +
>>>>    drivers/gpu/hsa/Makefile                           |    1 +
>>>>    drivers/gpu/hsa/radeon/Makefile                    |   12 +
>>>>    drivers/gpu/hsa/radeon/cik_int.h                   |   50 +
>>>>    drivers/gpu/hsa/radeon/cik_mqds.h                  |  250 ++++
>>>>    drivers/gpu/hsa/radeon/cik_regs.h                  |  220 ++++
>>>>    drivers/gpu/hsa/radeon/kfd_aperture.c              |  123 ++
>>>>    drivers/gpu/hsa/radeon/kfd_chardev.c               |  530
>>>> +++++++++
>>>>    drivers/gpu/hsa/radeon/kfd_crat.h                  |  294 +++++
>>>>    drivers/gpu/hsa/radeon/kfd_device.c                |  244 ++++
>>>>    drivers/gpu/hsa/radeon/kfd_device_queue_manager.c  |  981
>>>> ++++++++++++++++
>>>>    drivers/gpu/hsa/radeon/kfd_device_queue_manager.h  |  101 ++
>>>>    drivers/gpu/hsa/radeon/kfd_doorbell.c              |  242 ++++
>>>>    drivers/gpu/hsa/radeon/kfd_interrupt.c             |  177 +++
>>>>    drivers/gpu/hsa/radeon/kfd_kernel_queue.c          |  305 +++++
>>>>    drivers/gpu/hsa/radeon/kfd_kernel_queue.h          |   66 ++
>>>>    drivers/gpu/hsa/radeon/kfd_module.c                |  130 +++
>>>>    drivers/gpu/hsa/radeon/kfd_mqd_manager.c           |  290 +++++
>>>>    drivers/gpu/hsa/radeon/kfd_mqd_manager.h           |   54 +
>>>>    drivers/gpu/hsa/radeon/kfd_packet_manager.c        |  488
>>>> ++++++++
>>>>    drivers/gpu/hsa/radeon/kfd_pasid.c                 |   97 ++
>>>>    drivers/gpu/hsa/radeon/kfd_pm4_headers.h           |  682
>>>> +++++++++++
>>>>    drivers/gpu/hsa/radeon/kfd_pm4_opcodes.h           |  107 ++
>>>>    drivers/gpu/hsa/radeon/kfd_priv.h                  |  475
>>>> ++++++++
>>>>    drivers/gpu/hsa/radeon/kfd_process.c               |  391 +++++++
>>>>    drivers/gpu/hsa/radeon/kfd_process_queue_manager.c |  343 ++++++
>>>>    drivers/gpu/hsa/radeon/kfd_queue.c                 |  109 ++
>>>>    drivers/gpu/hsa/radeon/kfd_scheduler.h             |   72 ++
>>>>    drivers/gpu/hsa/radeon/kfd_topology.c              | 1207
>>>> ++++++++++++++++++++
>>>>    drivers/gpu/hsa/radeon/kfd_topology.h              |  168 +++
>>>>    drivers/gpu/hsa/radeon/kfd_vidmem.c                |   97 ++
>>>>    include/linux/mm_types.h                           |   14 +
>>>>    include/linux/radeon_kfd.h                         |  106 ++
>>>>    include/uapi/linux/kfd_ioctl.h                     |  133 +++
>>>>    mm/rmap.c                                          |    8 +-
>>>>    47 files changed, 9402 insertions(+), 97 deletions(-)
>>>>    create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.c
>>>>    create mode 100644 drivers/gpu/hsa/Kconfig
>>>>    create mode 100644 drivers/gpu/hsa/Makefile
>>>>    create mode 100644 drivers/gpu/hsa/radeon/Makefile
>>>>    create mode 100644 drivers/gpu/hsa/radeon/cik_int.h
>>>>    create mode 100644 drivers/gpu/hsa/radeon/cik_mqds.h
>>>>    create mode 100644 drivers/gpu/hsa/radeon/cik_regs.h
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_aperture.c
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_chardev.c
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_crat.h
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_device.c
>>>>    create mode 100644
>>>> drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
>>>>    create mode 100644
>>>> drivers/gpu/hsa/radeon/kfd_device_queue_manager.h
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_doorbell.c
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_interrupt.c
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_kernel_queue.c
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_kernel_queue.h
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_module.c
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_mqd_manager.c
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_mqd_manager.h
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_packet_manager.c
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_pasid.c
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_pm4_headers.h
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_pm4_opcodes.h
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_priv.h
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_process.c
>>>>    create mode 100644
>>>> drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_queue.c
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_scheduler.h
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_topology.c
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_topology.h
>>>>    create mode 100644 drivers/gpu/hsa/radeon/kfd_vidmem.c
>>>>    create mode 100644 include/linux/radeon_kfd.h
>>>>    create mode 100644 include/uapi/linux/kfd_ioctl.h
>>>>   --
>>>>   1.9.1
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

