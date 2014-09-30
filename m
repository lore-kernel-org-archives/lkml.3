Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaI3Nsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:48:31 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50978 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750780AbaI3Ns3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:48:29 -0400
From: Sudeep Holla <sudeep.holla@arm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v5 00/11] drivers: cacheinfo support
Date: Tue, 30 Sep 2014 14:48:21 +0100
Message-Id: <1412084912-2767-1-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds a generic cacheinfo support similar to topology. The
implementation is based on x86 cacheinfo support. Currently x86, powerpc,
ia64 and s390 have their own implementations. While adding similar support
to ARM and ARM64, here is the attempt to make it generic quite similar to
topology info support. It also adds the missing ABI documentation for
the cacheinfo sysfs which is already being used.

It moves all the existing different implementations on x86, ia64, powerpc
and s390 to use the generic cacheinfo infrastructure introduced here.
These changes on non-ARM platforms are only compile tested and tested on x86.

This series also adds support for ARM and ARM64 architectures based on
the generic support.

The code can be fetched from:
 git://linux-arm.org/linux-skn cacheinfo

Changes v4->v5:
	- Refactoring of cpumask show_map updated as per PeterZ's suggestion
	- ARM64 code rebased/reworked to use/extend the cachetype helpers
	- Added tested/acked/reviewed-by tags received so far

Changes v3->v4:
        - since userspace tools can't handle class and bus with same name,
          removed creating new cpu class and reused existing cpu bus with
          new cpu_device_create function
        - (no changes in the arch specific port)

Changes v2->v3:
        - Added {allocation,write}_policy instead of single attributes sysfs
          (attributes retained on ia64 privately as it was used only on that)
        - factored out show_cpumap into separate helper in cpumask.h
        - populate cpu_{map,list} for non-DT system if they are not populated
          by arch specific callbacks
        - removed use of sysfs *_show callback in cache_attrs_is_visible
        - all the review comments from Stephen Boyd implemented

Changes v1->v2:
        - removed custom device_{add,remove}_attrs, using is_visible callback
          instead(suggested by GregKH)
        - arm64: changes as per MarkR review comments
        - Moved smp_call_function_single to architectures using it(arm, arm64,
          x86) (suggested by Stephen Boyd)
        - arm (mostly changes as per RMK's review comments)
                - fixed to allow v7 + v6 build
                - l2 cache changes to remove extra structure
                - populated CTR for few StrongARM CPU's not implementing CTR

Regards,
Sudeep

[v1] https://lkml.org/lkml/2014/6/25/603
[v2] https://lkml.org/lkml/2014/7/25/467
[v3] https://lkml.org/lkml/2014/8/21/175
[v4] https://lkml.org/lkml/2014/9/3/588


Sudeep Holla (11):
  cpumask: factor out show_cpumap into separate helper function
  topology: replace custom attribute macros with standard DEVICE_ATTR*
  drivers: base: add cpu_device_create to support per-cpu devices
  drivers: base: support cpu cache information interface to userspace
    via sysfs
  ia64: move cacheinfo sysfs to generic cacheinfo infrastructure
  s390: move cacheinfo sysfs to generic cacheinfo infrastructure
  x86: move cacheinfo sysfs to generic cacheinfo infrastructure
  powerpc: move cacheinfo sysfs to generic cacheinfo infrastructure
  ARM64: kernel: add support for cpu cache information
  ARM: kernel: add support for cpu cache information
  ARM: kernel: add outer cache support for cacheinfo implementation

 Documentation/ABI/testing/sysfs-devices-system-cpu |  47 ++
 arch/arm/include/asm/outercache.h                  |   9 +
 arch/arm/kernel/Makefile                           |   1 +
 arch/arm/kernel/cacheinfo.c                        | 294 ++++++++
 arch/arm/mm/Kconfig                                |  13 +
 arch/arm/mm/cache-l2x0.c                           |  35 +-
 arch/arm/mm/cache-tauros2.c                        |  36 +
 arch/arm/mm/cache-xsc3l2.c                         |  17 +
 arch/arm64/include/asm/cachetype.h                 |  29 +-
 arch/arm64/kernel/Makefile                         |   2 +-
 arch/arm64/kernel/cacheinfo.c                      | 128 ++++
 arch/arm64/kernel/cpuinfo.c                        |  12 -
 arch/ia64/kernel/topology.c                        | 421 +++--------
 arch/powerpc/kernel/cacheinfo.c                    | 812 +++------------------
 arch/powerpc/kernel/cacheinfo.h                    |   8 -
 arch/powerpc/kernel/sysfs.c                        |  12 +-
 arch/s390/kernel/cache.c                           | 388 +++-------
 arch/x86/kernel/cpu/intel_cacheinfo.c              | 709 +++++-------------
 arch/x86/kernel/cpu/perf_event_amd_iommu.c         |   5 +-
 arch/x86/kernel/cpu/perf_event_amd_uncore.c        |   6 +-
 arch/x86/kernel/cpu/perf_event_intel_rapl.c        |   6 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |   6 +-
 drivers/acpi/acpi_pad.c                            |   8 +-
 drivers/base/Makefile                              |   2 +-
 drivers/base/cacheinfo.c                           | 541 ++++++++++++++
 drivers/base/cpu.c                                 |  59 +-
 drivers/base/node.c                                |  14 +-
 drivers/base/topology.c                            |  71 +-
 drivers/pci/pci-sysfs.c                            |  39 +-
 include/linux/bitmap.h                             |   3 +
 include/linux/cacheinfo.h                          | 100 +++
 include/linux/cpu.h                                |   4 +
 include/linux/cpumask.h                            |  17 +
 lib/bitmap.c                                       |  29 +
 34 files changed, 1880 insertions(+), 2003 deletions(-)
 create mode 100644 arch/arm/kernel/cacheinfo.c
 create mode 100644 arch/arm64/kernel/cacheinfo.c
 delete mode 100644 arch/powerpc/kernel/cacheinfo.h
 create mode 100644 drivers/base/cacheinfo.c
 create mode 100644 include/linux/cacheinfo.h

-- 
1.9.1

