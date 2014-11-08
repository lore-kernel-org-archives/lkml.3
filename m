Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaKHSiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:38:18 -0500
Received: from mail-bn1bon0115.outbound.protection.outlook.com ([157.56.111.115]:56557
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753914AbaKHSiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:38:16 -0500
X-WSS-ID: 0NEQH3G-08-GBU-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH v5 00/24] AMDKFD Kernel Driver
Date: Sat, 8 Nov 2014 20:37:21 +0200
Message-ID: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(11905935001)(199003)(229853001)(77156002)(46102003)(87936001)(77096003)(4396001)(48376002)(20776003)(95666004)(64706001)(92566001)(105586002)(93916002)(86362001)(50986999)(101416001)(33646002)(102836001)(62966003)(21056001)(87286001)(50226001)(31966008)(104166001)(89996001)(44976005)(19580395003)(107046002)(15202345003)(88136002)(53416004)(68736004)(47776003)(120916001)(15395725005)(50466002)(84676001)(36756003)(15975445006)(106466001)(97736003)(92726001)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0201MB1075;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0201MB1075;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0201MB1075;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0201MB1075;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Here is the v5 patch set of amdkfd.

This version is released several days ahead of the release of AMD's HSA Runtime 
library as Open Source. Coupled with the modification that Thomas Stellard 
did for the r600 LLVM back-end, AMD will be effectively releasing a _complete_ 
userspace Open Source stack/solution for running HSA applications using 
kernels written in OpenCL C99 on top of amdkfd.

Because of the above, I inserted some new code into this version, in addition
to various small fixes and changes.

- The new features in this version are:

  * Adding support for HSA Architected Queue Language (AQL) packets.
    These packets provides a standardised packet format for 
    Heterogeneous Queuing (hQ) - meaning that application developers won't 
    need to worry about which vendor they're dealing with when building hQ 
    support into their software.
    
    Adding this support was necessary because the HSA RT library works with
    AQL queues by default
    
  * Create a new folder /drm/amd, and moving the amdkfd folder into it, so it 
    is now located at /drm/amd/amdkfd.
    This change was done in preparation for the upstreaming of the new amdgpu
    driver. Once amdgpu driver is upstreamed, amdkfd will work with both 
    drivers (radeon and amdgpu), so we decided to put all of AMD's code into
    a single shared folder (/drm/amd).
    
  * Implemented the Get Version IOCTL (new patch, 24/24), which returns 
    the version number of the interface of amdkfd, so that the HSA RT will be
    able to recognize which amdkfd version it uses.
    
- The important fixes in this version are:
    
  * Using delayed function call during the tear down of kfd process object.
    This change was made due to request of the IOMMU maintainer. He NAKed 
    a patch where I made it possible to call amd_iommu_unbind_pasid() 
    from an mmu_notifier_release call-back. Therefore, I was forced to find 
    a different solution.

  * Adding support for 32-bit userspace, by padding the IOCTLs' structures to 
    be 64-bit aligned.
    
  * Update the format of mqd structure to match the latest Kaveri firmware.
  
  * Set default sched_policy to Hardware Scheduling as it is now supported
    correctly by the latest firmware

The method for building & running kernel programs involves offline 
compilation of a .cl source file, using clang plus a version of the r600 LLVM 
back end which Tom has modified so that a HW ISA binary file is generated. 
That binary file will then be imported into the HSAIL RT using 
the hsa_code_unit_load() API function in the HSA RT, and can then be used 
in compute operations initiated via calls to the HSAIL RT API and writes 
to userspace queues.

The HSA RT communicates with the amdkfd through the libhsakmt userspace 
library (equivalent of libdrm). That library is already open sourced.

AMD will supply a fully working application (port of the MatrixMultiplication 
application), both .cl file and .c file. The .cl file can be compiled with 
the above mentioned method and the application will load it and submit it 
through the HSA RT queues. 
This application is already ready and I am waiting for an IP approval to
release it. I expect it to be released next week. Once that happens, I will 
publish the link to download the application's source code and instructions 
on how to run it.

For people who like to review using git, the v5 patch set is located at:
http://cgit.freedesktop.org/~gabbayo/linux/?h=amdkfd-v5

The libhsakmt library is located at:
http://cgit.freedesktop.org/~gabbayo/libhsakmt

The modified r600 LLVM compiler is located at:
https://github.com/tstellarAMD/llvm/tree/hsa

The HSA RT library is located at:
https://github.com/HSAFoundation/HSA-Runtime-Reference-Source

As of this time, this link is still private as the HSA RT team is waiting for
a final IP approval. I expect this approval to arrive sometime next week, which 
at that time, this link will be made public. I wlll send an update when that 
occurs.

Link to v4 cover letter:
http://lwn.net/Articles/613057/

Link to v3 cover letter:
http://lwn.net/Articles/607730/

Link to v2 cover letter:
http://lists.freedesktop.org/archives/dri-devel/2014-July/064011.html

Link to v1 cover letter (contains explanation on HSA and this driver):
http://lwn.net/Articles/605153/

Any comment / review is appreciated.

    - Oded

Alexey Skidanov (1):
  amdkfd: Implement the Get Process Aperture IOCTL

Andrew Lewycky (2):
  amdkfd: Add interrupt handling module
  amdkfd: Implement the Set Memory Policy IOCTL

Ben Goz (7):
  amdkfd: Add queue module
  amdkfd: Add mqd_manager module
  amdkfd: Add kernel queue module
  amdkfd: Add module parameter of scheduling policy
  amdkfd: Add packet manager module
  amdkfd: Add process queue manager module
  amdkfd: Add device queue manager module

Evgeny Pinchuk (2):
  amdkfd: Add topology module to amdkfd
  amdkfd: Implement the Get Clock Counters IOCTL

Oded Gabbay (12):
  drm/radeon: reduce number of free VMIDs and pipes in KV
  drm/radeon/cik: Don't touch int of pipes 1-7
  drm/radeon: Report doorbell configuration to amdkfd
  drm/radeon: adding synchronization for GRBM GFX
  drm/radeon: Add radeon <--> amdkfd interface
  Update MAINTAINERS and CREDITS files with amdkfd info
  amdkfd: Add IOCTL set definitions of amdkfd
  amdkfd: Add amdkfd skeleton driver
  amdkfd: Add basic modules to amdkfd
  amdkfd: Add binding/unbinding calls to amd_iommu driver
  amdkfd: Implement the create/destroy/update queue IOCTLs
  amdkfd: Implement the Get Version IOCTL

 CREDITS                                            |    7 +
 MAINTAINERS                                        |   10 +
 drivers/gpu/drm/Kconfig                            |    2 +
 drivers/gpu/drm/Makefile                           |    1 +
 drivers/gpu/drm/amd/amdkfd/Kconfig                 |   10 +
 drivers/gpu/drm/amd/amdkfd/Makefile                |   14 +
 drivers/gpu/drm/amd/amdkfd/cik_regs.h              |  221 ++++
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  576 +++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_crat.h              |  294 +++++
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  307 +++++
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  | 1059 +++++++++++++++++
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.h  |  146 +++
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c          |  255 ++++
 drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c       |  355 ++++++
 drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c         |  176 +++
 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c      |  347 ++++++
 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.h      |   69 ++
 drivers/gpu/drm/amd/amdkfd/kfd_module.c            |  159 +++
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c       |  346 ++++++
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h       |   91 ++
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager.c    |  565 +++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_pasid.c             |   97 ++
 drivers/gpu/drm/amd/amdkfd/kfd_pm4_headers.h       |  405 +++++++
 drivers/gpu/drm/amd/amdkfd/kfd_pm4_opcodes.h       |  107 ++
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |  598 ++++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  415 +++++++
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |  342 ++++++
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |   85 ++
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          | 1235 ++++++++++++++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_topology.h          |  168 +++
 drivers/gpu/drm/amd/include/kgd_kfd_interface.h    |  185 +++
 drivers/gpu/drm/radeon/Makefile                    |    1 +
 drivers/gpu/drm/radeon/cik.c                       |  155 +--
 drivers/gpu/drm/radeon/cik_reg.h                   |  136 +++
 drivers/gpu/drm/radeon/cikd.h                      |   53 +-
 drivers/gpu/drm/radeon/radeon.h                    |   10 +
 drivers/gpu/drm/radeon/radeon_device.c             |   32 +
 drivers/gpu/drm/radeon/radeon_drv.c                |    5 +
 drivers/gpu/drm/radeon/radeon_kfd.c                |  563 +++++++++
 drivers/gpu/drm/radeon/radeon_kfd.h                |   47 +
 drivers/gpu/drm/radeon/radeon_kms.c                |    7 +
 include/uapi/linux/kfd_ioctl.h                     |  154 +++
 42 files changed, 9715 insertions(+), 95 deletions(-)
 create mode 100644 drivers/gpu/drm/amd/amdkfd/Kconfig
 create mode 100644 drivers/gpu/drm/amd/amdkfd/Makefile
 create mode 100644 drivers/gpu/drm/amd/amdkfd/cik_regs.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_crat.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_device.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_module.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_pasid.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_pm4_headers.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_pm4_opcodes.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_priv.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_process.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_queue.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_topology.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_topology.h
 create mode 100644 drivers/gpu/drm/amd/include/kgd_kfd_interface.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.h
 create mode 100644 include/uapi/linux/kfd_ioctl.h

-- 
2.1.0

