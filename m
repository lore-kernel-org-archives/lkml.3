Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaGLQti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 12:49:38 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:58914 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaGLQth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 12:49:37 -0400
Date: Sat, 12 Jul 2014 12:49:30 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        "Gabbay, Oded" <Oded.Gabbay@amd.com>,
        "oded.gabbay@gmail.com" <oded.gabbay@gmail.com>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 00/83] AMD HSA kernel driver
Message-ID: <20140712164928.GA5301@gmail.com>
References: <1405028727-5276-1-git-send-email-oded.gabbay@amd.com>
 <20140710222423.GA14219@gmail.com>
 <019CCE693E457142B37B791721487FD91809E4C2@storexdag01.amd.com>
 <20140711211850.GU1870@gmail.com>
 <53C0FEE1.50206@amd.com>
 <20140712111032.GV17271@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140712111032.GV17271@phenom.ffwll.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 01:10:32PM +0200, Daniel Vetter wrote:
> On Sat, Jul 12, 2014 at 11:24:49AM +0200, Christian König wrote:
> > Am 11.07.2014 23:18, schrieb Jerome Glisse:
> > >On Thu, Jul 10, 2014 at 10:51:29PM +0000, Gabbay, Oded wrote:
> > >>On Thu, 2014-07-10 at 18:24 -0400, Jerome Glisse wrote:
> > >>>On Fri, Jul 11, 2014 at 12:45:27AM +0300, Oded Gabbay wrote:
> > >>>>  This patch set implements a Heterogeneous System Architecture
> > >>>>(HSA) driver
> > >>>>  for radeon-family GPUs.
> > >>>This is just quick comments on few things. Given size of this, people
> > >>>will need to have time to review things.
> > >>>>  HSA allows different processor types (CPUs, DSPs, GPUs, etc..) to
> > >>>>share
> > >>>>  system resources more effectively via HW features including
> > >>>>shared pageable
> > >>>>  memory, userspace-accessible work queues, and platform-level
> > >>>>atomics. In
> > >>>>  addition to the memory protection mechanisms in GPUVM and
> > >>>>IOMMUv2, the Sea
> > >>>>  Islands family of GPUs also performs HW-level validation of
> > >>>>commands passed
> > >>>>  in through the queues (aka rings).
> > >>>>  The code in this patch set is intended to serve both as a sample
> > >>>>driver for
> > >>>>  other HSA-compatible hardware devices and as a production driver
> > >>>>for
> > >>>>  radeon-family processors. The code is architected to support
> > >>>>multiple CPUs
> > >>>>  each with connected GPUs, although the current implementation
> > >>>>focuses on a
> > >>>>  single Kaveri/Berlin APU, and works alongside the existing radeon
> > >>>>kernel
> > >>>>  graphics driver (kgd).
> > >>>>  AMD GPUs designed for use with HSA (Sea Islands and up) share
> > >>>>some hardware
> > >>>>  functionality between HSA compute and regular gfx/compute (memory,
> > >>>>  interrupts, registers), while other functionality has been added
> > >>>>  specifically for HSA compute  (hw scheduler for virtualized
> > >>>>compute rings).
> > >>>>  All shared hardware is owned by the radeon graphics driver, and
> > >>>>an interface
> > >>>>  between kfd and kgd allows the kfd to make use of those shared
> > >>>>resources,
> > >>>>  while HSA-specific functionality is managed directly by kfd by
> > >>>>submitting
> > >>>>  packets into an HSA-specific command queue (the "HIQ").
> > >>>>  During kfd module initialization a char device node (/dev/kfd) is
> > >>>>created
> > >>>>  (surviving until module exit), with ioctls for queue creation &
> > >>>>management,
> > >>>>  and data structures are initialized for managing HSA device
> > >>>>topology.
> > >>>>  The rest of the initialization is driven by calls from the radeon
> > >>>>kgd at
> > >>>>  the following points :
> > >>>>  - radeon_init (kfd_init)
> > >>>>  - radeon_exit (kfd_fini)
> > >>>>  - radeon_driver_load_kms (kfd_device_probe, kfd_device_init)
> > >>>>  - radeon_driver_unload_kms (kfd_device_fini)
> > >>>>  During the probe and init processing per-device data structures
> > >>>>are
> > >>>>  established which connect to the associated graphics kernel
> > >>>>driver. This
> > >>>>  information is exposed to userspace via sysfs, along with a
> > >>>>version number
> > >>>>  allowing userspace to determine if a topology change has occurred
> > >>>>while it
> > >>>>  was reading from sysfs.
> > >>>>  The interface between kfd and kgd also allows the kfd to request
> > >>>>buffer
> > >>>>  management services from kgd, and allows kgd to route interrupt
> > >>>>requests to
> > >>>>  kfd code since the interrupt block is shared between regular
> > >>>>  graphics/compute and HSA compute subsystems in the GPU.
> > >>>>  The kfd code works with an open source usermode library
> > >>>>("libhsakmt") which
> > >>>>  is in the final stages of IP review and should be published in a
> > >>>>separate
> > >>>>  repo over the next few days.
> > >>>>  The code operates in one of three modes, selectable via the
> > >>>>sched_policy
> > >>>>  module parameter :
> > >>>>  - sched_policy=0 uses a hardware scheduler running in the MEC
> > >>>>block within
> > >>>>  CP, and allows oversubscription (more queues than HW slots)
> > >>>>  - sched_policy=1 also uses HW scheduling but does not allow
> > >>>>  oversubscription, so create_queue requests fail when we run out
> > >>>>of HW slots
> > >>>>  - sched_policy=2 does not use HW scheduling, so the driver
> > >>>>manually assigns
> > >>>>  queues to HW slots by programming registers
> > >>>>  The "no HW scheduling" option is for debug & new hardware bringup
> > >>>>only, so
> > >>>>  has less test coverage than the other options. Default in the
> > >>>>current code
> > >>>>  is "HW scheduling without oversubscription" since that is where
> > >>>>we have the
> > >>>>  most test coverage but we expect to change the default to "HW
> > >>>>scheduling
> > >>>>  with oversubscription" after further testing. This effectively
> > >>>>removes the
> > >>>>  HW limit on the number of work queues available to applications.
> > >>>>  Programs running on the GPU are associated with an address space
> > >>>>through the
> > >>>>  VMID field, which is translated to a unique PASID at access time
> > >>>>via a set
> > >>>>  of 16 VMID-to-PASID mapping registers. The available VMIDs
> > >>>>(currently 16)
> > >>>>  are partitioned (under control of the radeon kgd) between current
> > >>>>  gfx/compute and HSA compute, with each getting 8 in the current
> > >>>>code. The
> > >>>>  VMID-to-PASID mapping registers are updated by the HW scheduler
> > >>>>when used,
> > >>>>  and by driver code if HW scheduling is not being used.
> > >>>>  The Sea Islands compute queues use a new "doorbell" mechanism
> > >>>>instead of the
> > >>>>  earlier kernel-managed write pointer registers. Doorbells use a
> > >>>>separate BAR
> > >>>>  dedicated for this purpose, and pages within the doorbell
> > >>>>aperture are
> > >>>>  mapped to userspace (each page mapped to only one user address
> > >>>>space).
> > >>>>  Writes to the doorbell aperture are intercepted by GPU hardware,
> > >>>>allowing
> > >>>>  userspace code to safely manage work queues (rings) without
> > >>>>requiring a
> > >>>>  kernel call for every ring update.
> > >>>>  First step for an application process is to open the kfd device.
> > >>>>Calls to
> > >>>>  open create a kfd "process" structure only for the first thread
> > >>>>of the
> > >>>>  process. Subsequent open calls are checked to see if they are
> > >>>>from processes
> > >>>>  using the same mm_struct and, if so, don't do anything. The kfd
> > >>>>per-process
> > >>>>  data lives as long as the mm_struct exists. Each mm_struct is
> > >>>>associated
> > >>>>  with a unique PASID, allowing the IOMMUv2 to make userspace
> > >>>>process memory
> > >>>>  accessible to the GPU.
> > >>>>  Next step is for the application to collect topology information
> > >>>>via sysfs.
> > >>>>  This gives userspace enough information to be able to identify
> > >>>>specific
> > >>>>  nodes (processors) in subsequent queue management calls.
> > >>>>Application
> > >>>>  processes can create queues on multiple processors, and
> > >>>>processors support
> > >>>>  queues from multiple processes.
> > >>>I am not a fan to use sysfs to discover topoly.
> > >>>>  At this point the application can create work queues in userspace
> > >>>>memory and
> > >>>>  pass them through the usermode library to kfd to have them mapped
> > >>>>onto HW
> > >>>>  queue slots so that commands written to the queues can be
> > >>>>executed by the
> > >>>>  GPU. Queue operations specify a processor node, and so the bulk
> > >>>>of this code
> > >>>>  is device-specific.
> > >>>>  Written by John Bridgman <John.Bridgman@amd.com>
> > >>>So general comment is you need to collapse many patches things like
> > >>>58 fixing
> > >>>kernel style should be collapsed ie fix all previous patch that have
> > >>>broken
> > >>>style.
> > >>>Even worse is thing like 71, removing code you just added few patch
> > >>>earlier
> > >>>in the patchset.
> > >>Not quite, the code was added on patch 11.
> > >>
> > >>>This means that if i start reviewing following
> > >>>patch order
> > >>>i might spend time on code that is later deleted/modified/fixed ie
> > >>>time i
> > >>>spend understanding and reading some code might be just wasted.
> > >>Quick answer is that you are of course right, but having said that, I
> > >>think it would be not simple at all to do that squashing.
> > >>I squashed what I could, and probably I can do a little more (like
> > >>58), but the major problem is that one of the main modules of the
> > >>driver - the scheduler (QCM) - was completely re-written (patches
> > >>46-53). Therefore, from patch 1 to 53, we use the old scheduler code
> > >>and from 54 we use the new QCM (and the old scheduler code was
> > >>completely remove at 71). So I could maybe squash 71 into 54, but that
> > >>won't help you much, I think.
> > >>
> > >>So, the current advice I can give is to completely ignore the
> > >>following files because they do not exist in the final commit:
> > >>- kfd_sched_cik_static.c (stopped using in 54)
> > >>- kfd_registers.c (stopped using in 81 because we moved all register
> > >>writes to radeon)
> > >>- kfd_hw_pointer_store.c (alive from 46 to 67)
> > >>- kfd_hw_pointer_store.h (alive from 46 to 67)
> > >>
> > >>         Oded
> > >Ok i try but this is driving me crazy, i am jungling btw full applied
> > >patchset and individual patch going back and forth trying to find which
> > >patch is the one i want to comment on. Not even mentioning that after
> > >that people would need to ack bad patch just because they know a latter
> > >good patch fix the badness.
> > >
> > >This patchset can be reduced to less then 10 big patches. I would first
> > >do core patches that touch core things like iommu and are preparatory
> > >to the patchset. Then kfd patches that do not touch anything in radeon
> > >but implement the skeleton and core infrastructure. Then radeon specific
> > >patches.
> > >
> > >This lead me to the design, all the core kfd helper should be in hsa
> > >directory, and should be helper, while all specific bits to radeon
> > >should most likely be part of the radeon gfx kernel module. I am not
> > >against a radeon_kfd but realy i do not see the point. There should
> > >be a hsa.ko like there is a drm.ko.
> > 
> > Yeah totally agree with Jerome here.
> > 
> > Maybe I can explain a bit further what the difference in the design is.
> > First of all for other good examples see not only the DRM infrastructure,
> > but also V4L or other Linux driver subsystems as well.
> > 
> > In those subsystems it's not the helper functions that control the driver,
> > but instead the driver that controls the helper functions. E.g. if HSA wants
> > to be a new subsystem with a standardized IOCTL interface it should provide
> > functions that assists drivers with implementing the interface instead of
> > implementing it themselves and then trying to talk to the drivers for
> > necessary resources/operations.
> > 
> > Coming back to the structure of the patches one of the very first patches
> > should be the IOCTL definition a driver needs to implement to be HSA
> > conform.
> > 
> > I think it would be a good idea to split out changes to core structures like
> > IOMMU in it's own separately submitted patches, only with the notice that
> > this functionality is needed by the following "core HSA" and "HSA for
> > radeon" patchsets.
> 
> Hm, so the hsa part is a completely new driver/subsystem, not just an
> additional ioctl tacked onto radoen? The history of drm is littered with
> "generic" ioctls that turned out to be useful for exactly one driver.
> Which is why _all_ the command submission is now done with driver-private
> ioctls.
> 
> I'd be quite a bit surprised if that suddenly works differently, so before
> we bless a generic hsa interface I really want to see some implementation
> from a different vendor (i.e. nvdidia or intel) using the same ioctls.
> Otherwise we just repeat history and I'm not terribly inclined to keep on
> cleanup up cruft forever - one drm legacy is enough ;-)
> 
> Jesse is the guy from our side to talk to about this.
> -Daniel

I am not worried about that side, the hsa foundation has pretty strict
guidelines on what is hsa compliant hardware ie the hw needs to understand
the pm4 packet format of radeon (well small subset of it). But of course
this require hsa compliant hardware and from member i am guessing ARM Mali,
ImgTech, Qualcomm, ... so unless Intel and NVidia joins hsa you will not
see it for those hardware.

So yes for once same ioctl would apply to different hardware. The only things
that is different is the shader isa. The hsafoundation site has some pdf
explaining all that but someone thought that slideshare would be a good idea
personnaly i would not register to any of the website just to get the pdf.

So to sumup i am ok with having a new device file that present uniform set
of ioctl. It would actualy be lot easier for userspace, just open this fix
device file and ask for list of compliant hardware.

Then radeon kernel driver would register itself as a provider. So all ioctl
decoding marshalling would be share which makes sense.

Cheers,
Jérôme Glisse
