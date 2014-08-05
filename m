Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbaHERLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 13:11:21 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:39304 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbaHERLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 13:11:19 -0400
MIME-Version: 1.0
In-Reply-To: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
References: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
Date: Tue, 5 Aug 2014 19:11:18 +0200
Message-ID: <CANq1E4RNvJ=BeZSGhfZD1rsj+zY9Gm5-pu_24k+35viNDGEdkQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/23] AMDKFD Kernel Driver
From: David Herrmann <dh.herrmann@gmail.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <j.glisse@gmail.com>,
        Alexander Deucher <alexdeucher@gmail.com>, Andrew.Lewycky@amd.com,
        michel.daenzer@amd.com, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Aug 5, 2014 at 5:30 PM, Oded Gabbay <oded.gabbay@amd.com> wrote:
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

This patchset adds 10.000 lines and contains nearly 0 comments *why*
stuff is added. Seriously, it is almost impossible to understand what
you're doing. Can you please include a high-level introduction in the
[0/X] cover-letter and include it in every series you send? A
blog-post or something would also be fine. And yes, it's totally ok if
this is 10k lines of plain-text.

Lets start with the basics:

1) Why do you use kobject directly to expose the topology? Almost no
other driver does that, why do you use it in amdkfd instead of "struct
bus" and "struct device"? You totally lack uevent handling, sysfs
hierarchy integration and more. If you'd use existing infrastructue
instead of kobject directly, everything would work just fine.

2) What kind of topology is exposed? Is it nested? How deep? How many
items are usually expected? How does the sysfs tree (`tree
/sys/..../topology`) look like on your machine? For people without the
hardware it's nearly impossible to understand how this will look like.

3) How is the interface supposed to be used? I can see one global
char-dev where you can queue jobs by providing a GPU-ID. Why don't you
create one char-dev *per* available GPU just like all other interfaces
do? Why is this a separate thing instead of a drm_minor object that
can be added per device as a separate interface to KMS and
render-nodes? Where is the underlying "struct device" for those GPUs?

4) Why is the topology static? FWIW, you allow runtime modifications,
but I cannot see any notification mechanism for user-space? Again,
using existing driver-core would provide all that for free.

I really appreciate that you provided code instead of just ideas, but
please describe why you do things the way they are. And please provide
examples for people who do not have the hardware.

Thanks
David

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
