Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbaDIHY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:24:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:53012 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbaDIHYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:24:24 -0400
Message-ID: <1397028232.3671.131.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>
Date: Wed, 09 Apr 2014 17:23:52 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few more powerpc things for you.

So you'll find here the conversion of the two new firmware sysfs
interfaces to the new API for self-removing files that Greg and Tejun
introduced, so they can finally remove the old one.

I'm also reverting the hwmon driver for powernv. I shouldn't have merged
it, I got a bit carried away here. I hadn't realized it was never CCed
to the relevant maintainer(s) and list(s), and happens to have some
issues so I'm taking it out and it will come back via the proper
channels.

The rest is a bunch of LE fixes (argh, some of the new stuff was broken 
on LE, I really need to start testing LE myself !) and various random
fixes here and there.

Finally one bit that's not strictly a fix, which is the HVC OPAL change
to "kick" the HVC thread when the firmware tells us there is new
incoming data. I don't feel like waiting for this one, it's simple
enough, and it makes a big difference in console responsiveness which is
good for my nerves.

Cheers,
Ben.

The following changes since commit 18a1a7a1d862ae0794a0179473d08a414dd49234:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2014-04-06 08:11:57 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to cc4f265ad9a37bdb1846c45eebe454c382f31d67:

  powerpc/powernv Adapt opal-elog and opal-dump to new sysfs_remove_file_self (2014-04-09 13:51:50 +1000)

----------------------------------------------------------------
Aneesh Kumar K.V (1):
      powerpc/mm: NUMA pte should be handled via slow path in get_user_pages_fast()

Anton Blanchard (3):
      powerpc/powernv: Fix endian issues with OPAL async code
      powerpc/powernv: Fix endian issues with sensor code
      powerpc: Add lq/stq emulation

Benjamin Herrenschmidt (8):
      powerpc: Adjust CPU_FTR_SMT on all platforms
      powerpc: Make boot_cpuid common between 32 and 64-bit
      powerpc/prom: early_init_dt_scan_cpus() updates cpu features only once
      powerpc/ppc64: Gracefully handle early interrupts
      powerpc/ppc64: Do not turn AIL (reloc-on interrupts) too early
      powerpc/powernv: Add opal_notifier_unregister() and export to modules
      tty/hvc_opal: Kick the HVC thread on OPAL console events
      Revert "powerpc/powernv: hwmon driver for power values, fan rpm and temperature"

Greg Kurz (1):
      powerpc/le: Enable RTAS events support

Joe Perches (1):
      powerpc: Convert last uses of __FUNCTION__ to __func__

Joel Stanley (2):
      powerpc/powernv: Add OPAL message log interface
      powerpc/powernv: Add invalid OPAL call

Li Zhong (1):
      powerpc: Use of_node_init() for the fakenode in msi_bitmap.c

Mahesh Salgaonkar (1):
      powerpc/book3s: Fix mc_recoverable_range buffer overrun issue.

Michael Neuling (3):
      powerpc/tm: Disable IRQ in tm_recheckpoint
      powerpc: Remove dead code in sycall entry
      powerpc/opal: Add missing include

Michael Wang (1):
      power, sched: stop updating inside arch_update_cpu_topology() when nothing to be update

Monam Agarwal (1):
      arch/powerpc: Use RCU_INIT_POINTER(x, NULL) in platforms/cell/spu_syscalls.c

Stephen Chivers (1):
      powerpc: Correct emulated mtfsf instruction

Stewart Smith (1):
      powerpc/powernv Adapt opal-elog and opal-dump to new sysfs_remove_file_self

Tony Breeds (1):
      powerpc/le: Avoid creatng R_PPC64_TOCSAVE relocations for modules.

 arch/powerpc/Makefile                          |   1 +
 arch/powerpc/include/asm/emulated_ops.h        |   1 +
 arch/powerpc/include/asm/opal.h                |  19 +-
 arch/powerpc/include/asm/rtas.h                | 127 ++++--
 arch/powerpc/kernel/align.c                    |  52 ++-
 arch/powerpc/kernel/cpu_setup_power.S          |   2 -
 arch/powerpc/kernel/exceptions-64s.S           |   8 -
 arch/powerpc/kernel/paca.c                     |   3 +-
 arch/powerpc/kernel/process.c                  |  34 +-
 arch/powerpc/kernel/prom.c                     |  58 +--
 arch/powerpc/kernel/rtas.c                     |  15 +-
 arch/powerpc/kernel/rtasd.c                    |  24 +-
 arch/powerpc/kernel/setup-common.c             |   3 +
 arch/powerpc/kernel/setup_32.c                 |   2 -
 arch/powerpc/kernel/setup_64.c                 |  28 +-
 arch/powerpc/kernel/signal_32.c                |   2 +
 arch/powerpc/kernel/signal_64.c                |   2 +
 arch/powerpc/kernel/tm.S                       |   2 +-
 arch/powerpc/kernel/traps.c                    |   1 +
 arch/powerpc/math-emu/mtfsf.c                  |  58 ++-
 arch/powerpc/mm/gup.c                          |  13 +
 arch/powerpc/mm/numa.c                         |  15 +
 arch/powerpc/platforms/cell/spu_syscalls.c     |   2 +-
 arch/powerpc/platforms/powernv/Makefile        |   1 +
 arch/powerpc/platforms/powernv/opal-async.c    |   7 +-
 arch/powerpc/platforms/powernv/opal-dump.c     |   9 +-
 arch/powerpc/platforms/powernv/opal-elog.c     |   9 +-
 arch/powerpc/platforms/powernv/opal-msglog.c   | 120 ++++++
 arch/powerpc/platforms/powernv/opal-sensor.c   |   6 +-
 arch/powerpc/platforms/powernv/opal-sysparam.c |   4 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S |   1 +
 arch/powerpc/platforms/powernv/opal.c          |  59 ++-
 arch/powerpc/platforms/pseries/io_event_irq.c  |   6 +-
 arch/powerpc/platforms/pseries/nvram.c         |  11 +-
 arch/powerpc/platforms/pseries/ras.c           |  17 +-
 arch/powerpc/sysdev/msi_bitmap.c               |   2 +-
 drivers/hwmon/Kconfig                          |   8 -
 drivers/hwmon/Makefile                         |   1 -
 drivers/hwmon/ibmpowernv.c                     | 529 -------------------------
 drivers/tty/hvc/hvc_opal.c                     |  22 +-
 40 files changed, 546 insertions(+), 738 deletions(-)
 create mode 100644 arch/powerpc/platforms/powernv/opal-msglog.c
 delete mode 100644 drivers/hwmon/ibmpowernv.c


