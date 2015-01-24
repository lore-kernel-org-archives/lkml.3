Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbbAXODq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:03:46 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:46079 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbbAXODn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:03:43 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHSET] bitmap, cpumask, nodemask: implement %*pb[l] to format bitmaps directly from printf family of functions
Date: Sat, 24 Jan 2015 09:03:06 -0500
Message-Id: <1422108218-25398-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

bitmap implements two variants of scnprintf functions to format a
bitmap into a string and cpumask and nodemask wrap them to provide
equivalent interfaces.  The scnprintf family of functions require a
string buffer as an output target which complicates code paths which
just want to print out the mask through printk for informational or
debug purposes as they have to worry about how large the buffer should
be and whether it's too large to allocate on stack.

Neither cpumask or nodemask provides a guildeline on how large the
target buffer should be forcing users come up with their own solutions
- some allocate an arbitrarily sized buffer which is small enough to
allocate on stack but may be too short in corner cases, other come up
with a custom upper limit calculation considering the output format,
some allocate the buffer dynamically while one resorted to using lock
to synchronize access to a static buffer.

This is an artificial problem which is being solved repeatedly for no
benefit.  In a lot of cases, the output area already exists and can be
targeted directly making the intermediate buffer unnecessary.  This
patchset teaches printf family of functions how to format bitmaps and
replace the dedicated formatting functions with it.

Pointer formatting is extended to cover bitmap formatting.  It uses
the field width for the number of bits instead of precision.  The
format used is '%*pb[l]', with the optional trailing 'l' specifying
list format instead of hex masks.  For more details, please see 0002.

This patchset contains the following 32 patches.

 0001-cpumask-always-use-nr_cpu_ids-in-formatting-and-pars.patch
 0002-lib-vsprintf-implement-bitmap-printing-through-pb-l.patch
 0003-cpumask-nodemask-implement-cpumask-nodemask_pr_args.patch
 0004-bitmap-use-pb-l-to-print-bitmaps-including-cpumasks-.patch
 0005-mips-use-pb-l-to-print-bitmaps-including-cpumasks-an.patch
 0006-powerpc-use-pb-l-to-print-bitmaps-including-cpumasks.patch
 0007-s390-use-pb-l-to-print-bitmaps-including-cpumasks-an.patch
 0008-tile-use-pb-l-to-print-bitmaps-including-cpumasks-an.patch
 0009-x86-use-pb-l-to-print-bitmaps-including-cpumasks-and.patch
 0010-ia64-use-pb-l-to-print-bitmaps-including-cpumasks-an.patch
 0011-xtensa-use-pb-l-to-print-bitmaps-including-cpumasks-.patch
 0012-arm-use-pb-l-to-print-bitmaps-including-cpumasks-and.patch
 0013-cpuset-use-pb-l-to-print-bitmaps-including-cpumasks-.patch
 0014-rcu-use-pb-l-to-print-bitmaps-including-cpumasks-and.patch
 0015-sched-use-pb-l-to-print-bitmaps-including-cpumasks-a.patch
 0016-time-use-pb-l-to-print-bitmaps-including-cpumasks-an.patch
 0017-percpu-use-pb-l-to-print-bitmaps-including-cpumasks-.patch
 0018-workqueue-use-pb-l-to-format-bitmaps-including-cpuma.patch
 0019-tracing-use-pb-l-to-print-bitmaps-including-cpumasks.patch
 0020-net-use-pb-l-to-print-bitmaps-including-cpumasks-and.patch
 0021-wireless-use-pb-l-to-print-bitmaps-including-cpumask.patch
 0022-input-use-pb-l-to-print-bitmaps-including-cpumasks-a.patch
 0023-scsi-use-pb-l-to-print-bitmaps-including-cpumasks-an.patch
 0024-usb-use-pb-l-to-print-bitmaps-including-cpumasks-and.patch
 0025-drivers-base-use-pb-l-to-print-bitmaps-including-cpu.patch
 0026-slub-use-pb-l-to-print-bitmaps-including-cpumasks-an.patch
 0027-mm-use-pb-l-to-print-bitmaps-including-cpumasks-and-.patch
 0028-padata-use-pb-l-to-print-bitmaps-including-cpumasks-.patch
 0029-proc-use-pb-l-to-print-bitmaps-including-cpumasks-an.patch
 0030-irq-use-pb-l-to-print-bitmaps-including-cpumasks-and.patch
 0031-profile-use-pb-l-to-print-bitmaps-including-cpumasks.patch
 0032-bitmap-cpumask-nodemask-remove-dedicated-formatting-.patch

0001 removes inconsistency in cpumask formatting and parsing.

0002 implements '%*pb[l]' formatting.

0003 implements cpumask/nodemask_pr_args() macros.

0004-0031 convert existing users of the dedicated formatting functions
to use '%*pb[l]'.

0032 removes the dedicated formatting functions.

If we can agree on this approach, it'd be best to route 0001-0003
through mainline ASAP and then route the rest through respective
susbsystems.

The patchset is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-bitmap-print

diffstat follows.  Around -300 LOC.

 arch/ia64/kernel/topology.c                    |    6 -
 arch/mips/netlogic/common/smp.c                |   13 +--
 arch/powerpc/kernel/cacheinfo.c                |   15 +--
 arch/powerpc/sysdev/xics/ics-opal.c            |    6 -
 arch/powerpc/sysdev/xics/ics-rtas.c            |    7 -
 arch/s390/kernel/cache.c                       |    9 +-
 arch/tile/kernel/hardwall.c                    |    5 -
 arch/tile/kernel/proc.c                        |    5 -
 arch/tile/kernel/setup.c                       |   13 +--
 arch/tile/mm/homecache.c                       |   12 +-
 arch/tile/mm/init.c                            |   18 +---
 arch/x86/kernel/cpu/intel_cacheinfo.c          |   26 ++----
 arch/x86/mm/numa.c                             |    6 -
 arch/x86/platform/uv/uv_nmi.c                  |   25 +-----
 arch/xtensa/kernel/setup.c                     |    7 -
 drivers/base/cpu.c                             |    2 
 drivers/base/node.c                            |    3 
 drivers/bus/arm-cci.c                          |    4 
 drivers/input/keyboard/atkbd.c                 |    4 
 drivers/input/keyboard/gpio_keys.c             |    2 
 drivers/net/ethernet/tile/tilegx.c             |    5 -
 drivers/net/ethernet/tile/tilepro.c            |    5 -
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |   23 +----
 drivers/net/wireless/ath/carl9170/debug.c      |   24 +----
 drivers/scsi/scsi_debug.c                      |    6 -
 drivers/usb/host/whci/debug.c                  |    7 -
 drivers/usb/wusbcore/reservation.c             |    5 -
 drivers/usb/wusbcore/wa-rpipe.c                |    5 -
 drivers/usb/wusbcore/wusbhc.c                  |    7 -
 drivers/uwb/drp.c                              |    2 
 drivers/uwb/uwb-debug.c                        |   16 +--
 fs/proc/array.c                                |   10 --
 fs/seq_file.c                                  |   32 -------
 include/linux/bitmap.h                         |    7 -
 include/linux/cpumask.h                        |   49 +++---------
 include/linux/nodemask.h                       |   41 +++-------
 include/linux/seq_buf.h                        |    3 
 include/linux/seq_file.h                       |   25 ------
 kernel/cpuset.c                                |   42 ++--------
 kernel/irq/proc.c                              |   11 --
 kernel/padata.c                                |   11 --
 kernel/profile.c                               |    3 
 kernel/rcu/tree_plugin.h                       |    5 -
 kernel/sched/core.c                            |   10 --
 kernel/sched/stats.c                           |   11 --
 kernel/time/tick-sched.c                       |   11 --
 kernel/trace/trace.c                           |    6 -
 kernel/trace/trace_seq.c                       |    2 
 kernel/workqueue.c                             |    5 -
 lib/bitmap.c                                   |  102 -------------------------
 lib/seq_buf.c                                  |   36 --------
 lib/vsprintf.c                                 |   94 +++++++++++++++++++++++
 mm/mempolicy.c                                 |    7 -
 mm/percpu.c                                    |    6 -
 mm/slub.c                                      |   20 +---
 net/core/net-sysfs.c                           |   28 +-----
 net/core/sysctl_net_core.c                     |    2 
 57 files changed, 288 insertions(+), 584 deletions(-)

--
tejun
