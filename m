Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaHERvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 13:51:45 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:37031 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbaHERvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 13:51:44 -0400
Date: Tue, 5 Aug 2014 13:51:39 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
        Alexander Deucher <alexdeucher@gmail.com>, Andrew.Lewycky@amd.com,
        michel.daenzer@amd.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 00/23] AMDKFD Kernel Driver
Message-ID: <20140805175138.GB2863@gmail.com>
References: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 06:30:28PM +0300, Oded Gabbay wrote:
> Hi,
> Here is the v3 patch set of amdkfd.
> 
> This version contains changes and fixes to code, as agreed on during the review
> of the v2 patch set.
> 
> The major changes are:
> 
> - There are two new module parameters: # of processes and # of queues per 
>   process. The defaults, as agreed on in the v2 review, are 32 and 128 
>   respectively. This sets the default amount of GART address space that amdkfd
>   requires to 3.5MB (3MB for userspace queues mqds and 0.5MB for other stuff,
>   such as mqd for kernel queue, hpd for pipelines, etc.)
>   
> - All the GART address space usage of amdkfd is done inside a single contiguous
>   buffer that is allocated from system memory, and pinned to the start of the 
>   GART during the startup of amdkfd (which is just after the startup of 
>   radeon). The management of this buffer is done by the radeon sa manager. 
>   This buffer is not evict-able.
>   
> - Mapping of doorbells is initiated by the userspace lib (by mmap syscall), 
>   instead of initiating it from inside an ioctl (using vm_mmap).
>   
> - Removed ioctls for exclusive access to performance counters
>   
> - Added documentation about the QCM (Queue Control Management), apertures and
>   interfaces between amdkfd and radeon.
> 
> Two important notes:
> 
> - The topology patch has not been changed. Look at 
>   http://lists.freedesktop.org/archives/dri-devel/2014-July/065042.html
>   for my response. I also put my answer as an explanation in the commit msg
>   of the patch.
>   
> - There are still some minor code style issues I need to fix. I didn't want
>   to delay v3 any further but I will publish either v4 with those fixes,
>   or just relevant patches if the whole patch set will be merged.
> 
> For people who like to review using git, the v3 patch set is located at:
> http://cgit.freedesktop.org/~gabbayo/linux/log/?h=kfd-next-3.17-v3
> 
> In addition, I would like to announce that we have uploaded the userspace lib
> that accompanies amdkfd. That lib is called "libhsakmt" and you can view it at:
> http://cgit.freedesktop.org/~gabbayo/libhsakmt

Not commenting on the patchset yet, will try to find sometime in my non work
hour to do that. But the userspace you released are just a libdrm like thing
and this is not what we mean by we need to have userspace that shows how the
kernel api is use.

So this library is nothing but a wrapper and have allmost no value for any
serious review of the kernel api.

To be clear, when we ask for open source userspace that shows how things are
suppose to be use we are thinking something like mesa but in this case most
likely something like an open source opencl implementation on top of that
kernel api.


Btw this library code remind me of VHDL ... thought code style for userspace
library is anybody choice.

Cheers,
Jérôme

> 
> Alexey Skidanov (1):
>   amdkfd: Implement the Get Process Aperture IOCTL
> 
> Andrew Lewycky (3):
>   amdkfd: Add basic modules to amdkfd
>   amdkfd: Add interrupt handling module
>   amdkfd: Implement the Set Memory Policy IOCTL
> 
> Ben Goz (8):
>   amdkfd: Add queue module
>   amdkfd: Add mqd_manager module
>   amdkfd: Add kernel queue module
>   amdkfd: Add module parameter of scheduling policy
>   amdkfd: Add packet manager module
>   amdkfd: Add process queue manager module
>   amdkfd: Add device queue manager module
>   amdkfd: Implement the create/destroy/update queue IOCTLs
> 
> Evgeny Pinchuk (2):
>   amdkfd: Add topology module to amdkfd
>   amdkfd: Implement the Get Clock Counters IOCTL
> 
> Oded Gabbay (9):
>   drm/radeon: reduce number of free VMIDs and pipes in KV
>   drm/radeon/cik: Don't touch int of pipes 1-7
>   drm/radeon: Report doorbell configuration to amdkfd
>   drm/radeon: adding synchronization for GRBM GFX
>   drm/radeon: Add radeon <--> amdkfd interface
>   Update MAINTAINERS and CREDITS files with amdkfd info
>   amdkfd: Add IOCTL set definitions of amdkfd
>   amdkfd: Add amdkfd skeleton driver
>   amdkfd: Add binding/unbinding calls to amd_iommu driver
> 
>  CREDITS                                            |    7 +
>  MAINTAINERS                                        |   10 +
>  drivers/gpu/drm/radeon/Kconfig                     |    2 +
>  drivers/gpu/drm/radeon/Makefile                    |    3 +
>  drivers/gpu/drm/radeon/amdkfd/Kconfig              |   10 +
>  drivers/gpu/drm/radeon/amdkfd/Makefile             |   14 +
>  drivers/gpu/drm/radeon/amdkfd/cik_regs.h           |  220 ++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c       |  350 ++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c        |  511 +++++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_crat.h           |  294 +++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_device.c         |  300 +++++
>  .../drm/radeon/amdkfd/kfd_device_queue_manager.c   |  989 ++++++++++++++++
>  .../drm/radeon/amdkfd/kfd_device_queue_manager.h   |  144 +++
>  drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c       |  236 ++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c      |  161 +++
>  drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c   |  330 ++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h   |   66 ++
>  drivers/gpu/drm/radeon/amdkfd/kfd_module.c         |  147 +++
>  drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.c    |  305 +++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.h    |   88 ++
>  drivers/gpu/drm/radeon/amdkfd/kfd_packet_manager.c |  495 ++++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c          |   95 ++
>  drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h    |  682 +++++++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h    |  107 ++
>  drivers/gpu/drm/radeon/amdkfd/kfd_priv.h           |  560 +++++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_process.c        |  347 ++++++
>  .../drm/radeon/amdkfd/kfd_process_queue_manager.c  |  346 ++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_queue.c          |   85 ++
>  drivers/gpu/drm/radeon/amdkfd/kfd_topology.c       | 1207 ++++++++++++++++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_topology.h       |  168 +++
>  drivers/gpu/drm/radeon/cik.c                       |  154 +--
>  drivers/gpu/drm/radeon/cik_reg.h                   |   65 ++
>  drivers/gpu/drm/radeon/cikd.h                      |   53 +-
>  drivers/gpu/drm/radeon/radeon.h                    |   10 +
>  drivers/gpu/drm/radeon/radeon_device.c             |   32 +
>  drivers/gpu/drm/radeon/radeon_drv.c                |    5 +
>  drivers/gpu/drm/radeon/radeon_kfd.c                |  525 +++++++++
>  drivers/gpu/drm/radeon/radeon_kfd.h                |  177 +++
>  drivers/gpu/drm/radeon/radeon_kms.c                |    7 +
>  include/uapi/linux/kfd_ioctl.h                     |  126 ++
>  40 files changed, 9338 insertions(+), 95 deletions(-)
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/Kconfig
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/Makefile
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/cik_regs.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_crat.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_module.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_packet_manager.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_process.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_queue.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_topology.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_topology.h
>  create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.c
>  create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.h
>  create mode 100644 include/uapi/linux/kfd_ioctl.h
> 
> -- 
> 1.9.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
