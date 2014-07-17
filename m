Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649AbaGQN5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:57:47 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:49210
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933594AbaGQN5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:57:42 -0400
X-WSS-ID: 0N8V040-07-E4P-02
X-M-MSG: 
Message-ID: <53C7D645.3070607@amd.com>
Date: Thu, 17 Jul 2014 16:57:25 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        "Alex Deucher" <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-mm <linux-mm@kvack.org>
Subject: [PATCH v2 00/25] AMDKFD kernel driver
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(101416001)(65816999)(84676001)(87266999)(92566001)(83072002)(20776003)(102836001)(68736004)(31966008)(65956001)(76482001)(46102001)(54356999)(106466001)(15975445006)(95666004)(97736001)(50986999)(92726001)(80022001)(47776003)(33656002)(65806001)(21056001)(81342001)(79102001)(86362001)(85306003)(59896001)(64706001)(74502001)(87936001)(229853001)(36756003)(81542001)(77982001)(85852003)(4396001)(15202345003)(50466002)(107046002)(64126003)(19580405001)(83322001)(44976005)(19580395003)(105586002)(74662001)(99396002)(83506001)(23676002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB041;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to cc mailing list on cover letter. Sorry.

As a continuation to the existing discussion, here is a v2 patch series 
restructured with a cleaner history and no totally-different-early-versions of 
the code.

Instead of 83 patches, there are now a total of 25 patches, where 5 of them
are modifications to radeon driver and 18 of them include only amdkfd code.
There is no code going away or even modified between patches, only added.

The driver was renamed from radeon_kfd to amdkfd and moved to reside under
drm/radeon/amdkfd. This move was done to emphasize the fact that this driver is 
an AMD-only driver at this point. Having said that, we do foresee a generic hsa 
framework being implemented in the future and in that case, we will adjust 
amdkfd to work within that framework.

As the amdkfd driver should support multiple AMD gfx drivers, we want to keep it 
as a seperate driver from radeon. Therefore, the amdkfd code is contained in its 
own folder. The amdkfd folder was put under the radeon folder because the only 
AMD gfx driver in the Linux kernel at this point
is the radeon driver. Having said that, we will probably need to move it (maybe 
to be directly under drm) after we integrate with additional AMD gfx drivers.

For people who like to review using git, the v2 patch set is located at:
http://cgit.freedesktop.org/~gabbayo/linux/log/?h=kfd-next-3.17-v2

Written by Oded Gabbayh <oded.gabbay@amd.com>

Original Cover Letter:

This patch set implements a Heterogeneous System Architecture (HSA) driver for 
radeon-family GPUs.
HSA allows different processor types (CPUs, DSPs, GPUs, etc..) to share system 
resources more effectively via HW features including shared pageable memory, 
userspace-accessible work queues, and platform-level atomics. In addition to the 
memory protection mechanisms in GPUVM and IOMMUv2, the Sea Islands family of 
GPUs also performs HW-level validation of commands passed in through the queues 
(aka rings).

The code in this patch set is intended to serve both as a sample driver for 
other HSA-compatible hardware devices and as a production driver for 
radeon-family processors. The code is architected to support multiple CPUs each 
with connected GPUs, although the current implementation focuses on a single 
Kaveri/Berlin APU, and works alongside the existing radeon kernel graphics 
driver (kgd).
AMD GPUs designed for use with HSA (Sea Islands and up) share some hardware 
functionality between HSA compute and regular gfx/compute (memory, interrupts, 
registers), while other functionality has been added specifically for HSA 
compute  (hw scheduler for virtualized compute rings). All shared hardware is 
owned by the radeon graphics driver, and an interface between kfd and kgd allows 
the kfd to make use of those shared resources, while HSA-specific functionality 
is managed directly by kfd by submitting packets into an HSA-specific command 
queue (the "HIQ").

During kfd module initialization a char device node (/dev/kfd) is created 
(surviving until module exit), with ioctls for queue creation & management, and 
data structures are initialized for managing HSA device topology.
The rest of the initialization is driven by calls from the radeon kgd at the 
following points :

- radeon_init (kfd_init)
- radeon_exit (kfd_fini)
- radeon_driver_load_kms (kfd_device_probe, kfd_device_init)
- radeon_driver_unload_kms (kfd_device_fini)

During the probe and init processing per-device data structures are established 
which connect to the associated graphics kernel driver. This information is 
exposed to userspace via sysfs, along with a version number allowing userspace 
to determine if a topology change has occurred while it was reading from sysfs.
The interface between kfd and kgd also allows the kfd to request buffer 
management services from kgd, and allows kgd to route interrupt requests to kfd 
code since the interrupt block is shared between regular graphics/compute and 
HSA compute subsystems in the GPU.

The kfd code works with an open source usermode library ("libhsakmt") which is 
in the final stages of IP review and should be published in a separate repo over 
the next few days.
The code operates in one of three modes, selectable via the sched_policy module 
parameter :

- sched_policy=0 uses a hardware scheduler running in the MEC block within CP, 
and allows oversubscription (more queues than HW slots)
- sched_policy=1 also uses HW scheduling but does not allow oversubscription, so 
create_queue requests fail when we run out of HW slots
- sched_policy=2 does not use HW scheduling, so the driver manually assigns 
queues to HW slots by programming registers

The "no HW scheduling" option is for debug & new hardware bringup only, so has 
less test coverage than the other options. Default in the current code is "HW 
scheduling without oversubscription" since that is where we have the most test 
coverage but we expect to change the default to "HW scheduling with 
oversubscription" after further testing. This effectively removes the HW limit 
on the number of work queues available to applications.

Programs running on the GPU are associated with an address space through the 
VMID field, which is translated to a unique PASID at access time via a set of 16 
VMID-to-PASID mapping registers. The available VMIDs (currently 16) are 
partitioned (under control of the radeon kgd) between current gfx/compute and 
HSA compute, with each getting 8 in the current code. The VMID-to-PASID mapping 
registers are updated by the HW scheduler when used, and by driver code if HW 
scheduling is not being used.
The Sea Islands compute queues use a new "doorbell" mechanism instead of the 
earlier kernel-managed write pointer registers. Doorbells use a separate BAR 
dedicated for this purpose, and pages within the doorbell aperture are mapped to 
userspace (each page mapped to only one user address space). Writes to the 
doorbell aperture are intercepted by GPU hardware, allowing userspace code to 
safely manage work queues (rings) without requiring a kernel call for every ring 
update.
First step for an application process is to open the kfd device. Calls to open 
create a kfd "process" structure only for the first thread of the process. 
Subsequent open calls are checked to see if they are from processes using the 
same mm_struct and, if so, don't do anything. The kfd per-process data lives as 
long as the mm_struct exists. Each mm_struct is associated with a unique PASID, 
allowing the IOMMUv2 to make userspace process memory accessible to the GPU.
Next step is for the application to collect topology information via sysfs. This 
gives userspace enough information to be able to identify specific nodes 
(processors) in subsequent queue management calls. Application processes can 
create queues on multiple processors, and processors support queues from 
multiple processes.
At this point the application can create work queues in userspace memory and 
pass them through the usermode library to kfd to have them mapped onto HW queue 
slots so that commands written to the queues can be executed by the GPU. Queue 
operations specify a processor node, and so the bulk of this code is 
device-specific.
Written by John Bridgman <John.Bridgman@amd.com>


Alexey Skidanov (1):
   amdkfd: Implement the Get Process Aperture IOCTL

Andrew Lewycky (3):
   amdkfd: Add basic modules to amdkfd
   amdkfd: Add interrupt handling module
   amdkfd: Implement the Set Memory Policy IOCTL

Ben Goz (8):
   amdkfd: Add queue module
   amdkfd: Add mqd_manager module
   amdkfd: Add kernel queue module
   amdkfd: Add module parameter of scheduling policy
   amdkfd: Add packet manager module
   amdkfd: Add process queue manager module
   amdkfd: Add device queue manager module
   amdkfd: Implement the create/destroy/update queue IOCTLs

Evgeny Pinchuk (3):
   amdkfd: Add topology module to amdkfd
   amdkfd: Implement the Get Clock Counters IOCTL
   amdkfd: Implement the PMC Acquire/Release IOCTLs

Oded Gabbay (10):
   mm: Add kfd_process pointer to mm_struct
   drm/radeon: reduce number of free VMIDs and pipes in KV
   drm/radeon/cik: Don't touch int of pipes 1-7
   drm/radeon: Report doorbell configuration to amdkfd
   drm/radeon: adding synchronization for GRBM GFX
   drm/radeon: Add radeon <--> amdkfd interface
   Update MAINTAINERS and CREDITS files with amdkfd info
   amdkfd: Add IOCTL set definitions of amdkfd
   amdkfd: Add amdkfd skeleton driver
   amdkfd: Add binding/unbinding calls to amd_iommu driver

  CREDITS                                            |    7 +
  MAINTAINERS                                        |   10 +
  drivers/gpu/drm/radeon/Kconfig                     |    2 +
  drivers/gpu/drm/radeon/Makefile                    |    3 +
  drivers/gpu/drm/radeon/amdkfd/Kconfig              |   10 +
  drivers/gpu/drm/radeon/amdkfd/Makefile             |   14 +
  drivers/gpu/drm/radeon/amdkfd/cik_mqds.h           |  185 +++
  drivers/gpu/drm/radeon/amdkfd/cik_regs.h           |  220 ++++
  drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c       |  123 ++
  drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c        |  518 +++++++++
  drivers/gpu/drm/radeon/amdkfd/kfd_crat.h           |  294 +++++
  drivers/gpu/drm/radeon/amdkfd/kfd_device.c         |  254 ++++
  .../drm/radeon/amdkfd/kfd_device_queue_manager.c   |  985 ++++++++++++++++
  .../drm/radeon/amdkfd/kfd_device_queue_manager.h   |  101 ++
  drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c       |  264 +++++
  drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c      |  161 +++
  drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c   |  305 +++++
  drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h   |   66 ++
  drivers/gpu/drm/radeon/amdkfd/kfd_module.c         |  131 +++
  drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.c    |  291 +++++
  drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.h    |   54 +
  drivers/gpu/drm/radeon/amdkfd/kfd_packet_manager.c |  488 ++++++++
  drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c          |   97 ++
  drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h    |  682 +++++++++++
  drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h    |  107 ++
  drivers/gpu/drm/radeon/amdkfd/kfd_priv.h           |  466 ++++++++
  drivers/gpu/drm/radeon/amdkfd/kfd_process.c        |  405 +++++++
  .../drm/radeon/amdkfd/kfd_process_queue_manager.c  |  343 ++++++
  drivers/gpu/drm/radeon/amdkfd/kfd_queue.c          |  109 ++
  drivers/gpu/drm/radeon/amdkfd/kfd_topology.c       | 1207 ++++++++++++++++++++
  drivers/gpu/drm/radeon/amdkfd/kfd_topology.h       |  168 +++
  drivers/gpu/drm/radeon/amdkfd/kfd_vidmem.c         |   96 ++
  drivers/gpu/drm/radeon/cik.c                       |  154 +--
  drivers/gpu/drm/radeon/cik_reg.h                   |   65 ++
  drivers/gpu/drm/radeon/cikd.h                      |   51 +-
  drivers/gpu/drm/radeon/radeon.h                    |    9 +
  drivers/gpu/drm/radeon/radeon_device.c             |   32 +
  drivers/gpu/drm/radeon/radeon_drv.c                |    5 +
  drivers/gpu/drm/radeon/radeon_kfd.c                |  566 +++++++++
  drivers/gpu/drm/radeon/radeon_kfd.h                |  119 ++
  drivers/gpu/drm/radeon/radeon_kms.c                |    7 +
  include/linux/mm_types.h                           |   14 +
  include/uapi/linux/kfd_ioctl.h                     |  133 +++
  43 files changed, 9226 insertions(+), 95 deletions(-)
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/Kconfig
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/Makefile
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/cik_mqds.h
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/cik_regs.h
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_crat.h
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device.c
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.c
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.h
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_module.c
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.c
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.h
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_packet_manager.c
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_process.c
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_queue.c
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_topology.c
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_topology.h
  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_vidmem.c
  create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.c
  create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.h
  create mode 100644 include/uapi/linux/kfd_ioctl.h

-- 
1.9.1

