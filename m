Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab3FTRqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 13:46:51 -0400
Received: from mail1.windriver.com ([147.11.146.13]:47862 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279Ab3FTRqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 13:46:47 -0400
Date: Thu, 20 Jun 2013 13:46:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg KH <greg@kroah.com>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Status of __cpuinit removal
Message-ID: <20130620174659.GA17945@windriver.com>
References: <519AA53F.1020107@zytor.com>
 <20130520231203.GA21682@kroah.com>
 <20130528092038.GC32068@gmail.com>
 <CAP=VYLo047g+U3GJhkObJtNPubFNpHuGUJAF7oOh_7dPtSFd9A@mail.gmail.com>
 <20130612005605.GA7469@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130612005605.GA7469@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As some of you are probably aware, a decision to remove __cpuinit and
variants was made, since the cost/complexity outweighs the amount of
memory reclaim that it provides.  Details of that decision are at:

	https://lkml.org/lkml/2013/5/20/589

It seems that the suggestion to do this was partly motivated by the
fix in commit 5e427ec2 ("x86: Fix bit corruption at CPU resume time").
It is a good example of the nasty type of bugs that can be created
with improper use of the various types of __init prefixes.

I have created a patch queue against the latest linux-next tree (Jun20)
that removes all the variants of __cpuinit and the asm __CPUINIT variants,
and the surrounding infrastructure for section handling of it.  There
are no Kconfig changes; this is complex enough.  We can independently
revisit later whether keeping CPU_HOTPLUG makes sense or not.

I have done this in 33 commits.  I decided against a giant monolithic
patch for several reasons:

	-the devinit removal does stub out the macros as an early separate
	 step, so I do the same for this change (see 78d86c213f28).

	-nobody reviews giant patches, and I want arch maintainers and
	 the like to have a chance to check things over on their own
	 lists with only the chunk they care about presented to them.

	-arch maintainers and the like have the chance to carry their
	 chunk in their own queue, if they anticipate a lot of churn.
	 The mips tree has already done this.  Otherwise they can leave
	 the patch with me.

	-if the arch is in a sustaining/legacy/maintenance mode, then
	 it makes sense for me to keep/carry the patch, but I welcome
	 reviews and Ack'd-by: additions.  The parisc patch is like this.

	-this isn't a cosmetic sed operation; for example the SPARC
	 code has early trampoline code as cpuinit; I don't want to
	 assume my changes are inert out of ignorance, and then inflict
	 silent boot death bugs on SPARC due to some implicit address
	 location expecations ; hence why I want them to check/review.

I'm treating it as a git repo of commits (i.e. linux-stable workflow):

     git://git.kernel.org/pub/scm/linux/kernel/git/paulg/cpuinit-delete.git

It is a queue of patches just like stable queues, and is done against the
linux-next tree of June 20th, and I will refresh it as necessary.

Here is how I envision next steps; note this is only what I envision as
being efficient; if folks request a different/better approach, then great.

 -------------------------------------------------------------------
 --add appropriate maintainer CC: to patches in the patch queue and mail
   out remaining patches to people/lists for review (some are already
   out, like arm, mips, powerpc, ia64, alpha, ....)

 --ask Stephen Rothwell to add the patch queue to the tail of linux-next.

 --get the 1st two commits (i.e. disable __cpuinit ; see the __devinit
   equivalent in 78d86c213f28) in the tree at the beginning of merge window

 --drop arch/maintainer patches from my queue as they get reviewed and
   added to their respective owner's queues.

 --get the main bulk of the __cpuinit removals in at the end of the merge
   window, or even perhaps just after rc1 is tagged (I have no preference).

 --delete the stubbed out __cpuinit macros once it is clear the tree is
   100% clear of users. (parallel to __devinit commit 54b956b90360).
 -------------------------------------------------------------------

This change sounded straightforward, but like always, these kind of tree-wide
cleanups seem to have hidden complications, and hence why I'd like to have
people do some review.  Some notes of interest along the way:

-care needs to be taken in deletion of __CPUINIT from asm files, since
 in some cases these were paired with __FINIT, or an equivalent ".previous"
 Most times they were standalone, but checking was required.

-I've realigned multi line function call arguments so that 2nd and
 subsequent lines have their 1st arg align with the 1st arg of the 1st
 line (obviously just scripting deleting __cpuinit from the 1st line
 doesn't achieve that) -- let me know if I accidentally missed any.

-generally speaking I have been responsive to cosmetic changes that
 checkpatch.pl nags about (for example struct * foo vs. struct *foo)
 but I have ignored checkpatch where it asked for changes that may
 have real code/runtime impact (e.g. "dont use volatile") etc.

-x86 had a lurking bug with mismatched sections that only showed up
 after deleting __cpuinit (already in tip/urgent)

-Ralf mentioned that there are probably some #include <linux/init.h>
 that no longer need to exist; I'll save that audit for another day.

The below pseudo-pull-request will show the scope of changes against
the linux-next tree from today.  It is a real branch that people
can pull and build/test against if they are interested in doing so.
Or, just pull the patch queue and apply them yourself, if you prefer.

Thanks for reading this far and thanks for any feedback.
Paul.
--

The following changes since commit 849aa58856855ae73d9654b2e675f2c7a6ad4c9b:

  Add linux-next specific files for 20130620 (2013-06-20 18:18:48 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git cpuinit-Jun20

for you to fetch changes up to 34a7f01fff995394e2fb4db31e026051db6bb188:

  block: delete __cpuinit usage from all block files (2013-06-20 13:10:52 -0400)

----------------------------------------------------------------
Paul Gortmaker (33):
      x86: fix section mismatch on load_ucode_ap
      init.h: remove __cpuinit sections from the kernel
      modpost: remove all traces of cpuinit/cpuexit sections
      alpha: delete __cpuinit usage from all users
      powerpc: delete __cpuinit usage from all users
      parisc: delete __cpuinit usage from all users
      ia64: delete __cpuinit usage from all ia64 users
      arm: delete __cpuinit/__CPUINIT usage from all ARM users
      sparc: delete __cpuinit/__CPUINIT usage from all users
      arm64: delete __cpuinit usage from all users
      arc: delete __cpuinit usage from all arc files
      blackfin: delete __cpuinit usage from all blackfin files
      s390: delete __cpuinit usage from all s390 files
      sh: delete __cpuinit usage from all sh files
      tile: delete __cpuinit usage from all tile files
      metag: delete __cpuinit usage from all metag files
      cris: delete __cpuinit usage from all cris files
      frv: delete __cpuinit usage from all frv files
      hexagon: delete __cpuinit usage from all hexagon files
      m32r: delete __cpuinit usage from all m32r files
      openrisc: delete __cpuinit usage from all openrisc files
      xtensa: delete __cpuinit usage from all xtensa files
      score: delete __cpuinit usage from all score files
      x86: delete __cpuinit usage from all x86 files
      clocksource+irqchip: delete __cpuinit usage from all related files
      cpufreq: delete __cpuinit usage from all cpufreq files
      hwmon: delete __cpuinit usage from all hwmon files
      acpi: delete __cpuinit usage from all acpi files
      net: delete __cpuinit usage from all net files
      rcu: delete __cpuinit usage from all rcu files
      kernel: delete __cpuinit usage from all core kernel files
      drivers: delete __cpuinit usage from all remaining drivers files
      block: delete __cpuinit usage from all block files

 Documentation/cpu-hotplug.txt                 |  6 +--
 arch/alpha/kernel/smp.c                       | 10 ++---
 arch/alpha/kernel/traps.c                     |  4 +-
 arch/arc/include/asm/irq.h                    |  2 +-
 arch/arc/kernel/irq.c                         |  2 +-
 arch/arc/kernel/setup.c                       | 10 ++---
 arch/arc/kernel/smp.c                         |  4 +-
 arch/arc/kernel/time.c                        |  6 +--
 arch/arc/mm/cache_arc700.c                    |  4 +-
 arch/arc/mm/tlb.c                             |  4 +-
 arch/arm/common/mcpm_platsmp.c                |  4 +-
 arch/arm/include/asm/arch_timer.h             |  2 +-
 arch/arm/kernel/head-common.S                 |  1 -
 arch/arm/kernel/head.S                        |  1 -
 arch/arm/kernel/hw_breakpoint.c               |  4 +-
 arch/arm/kernel/perf_event_cpu.c              |  6 +--
 arch/arm/kernel/psci_smp.c                    |  3 +-
 arch/arm/kernel/smp.c                         | 18 ++++----
 arch/arm/kernel/smp_twd.c                     |  6 +--
 arch/arm/lib/delay.c                          |  2 +-
 arch/arm/mach-exynos/headsmp.S                |  2 -
 arch/arm/mach-exynos/platsmp.c                |  4 +-
 arch/arm/mach-highbank/platsmp.c              |  2 +-
 arch/arm/mach-imx/platsmp.c                   |  2 +-
 arch/arm/mach-msm/headsmp.S                   |  2 -
 arch/arm/mach-msm/platsmp.c                   |  6 +--
 arch/arm/mach-msm/timer.c                     |  4 +-
 arch/arm/mach-mvebu/coherency.c               |  2 +-
 arch/arm/mach-mvebu/headsmp.S                 |  2 -
 arch/arm/mach-mvebu/platsmp.c                 |  5 +--
 arch/arm/mach-omap2/omap-headsmp.S            |  2 -
 arch/arm/mach-omap2/omap-mpuss-lowpower.c     |  2 +-
 arch/arm/mach-omap2/omap-smp.c                |  4 +-
 arch/arm/mach-omap2/omap-wakeupgen.c          |  4 +-
 arch/arm/mach-prima2/headsmp.S                |  2 -
 arch/arm/mach-prima2/platsmp.c                |  4 +-
 arch/arm/mach-shmobile/headsmp-scu.S          |  1 -
 arch/arm/mach-shmobile/headsmp.S              |  2 -
 arch/arm/mach-shmobile/smp-emev2.c            |  2 +-
 arch/arm/mach-shmobile/smp-r8a7779.c          |  2 +-
 arch/arm/mach-shmobile/smp-sh73a0.c           |  2 +-
 arch/arm/mach-socfpga/headsmp.S               |  1 -
 arch/arm/mach-socfpga/platsmp.c               |  2 +-
 arch/arm/mach-spear/generic.h                 |  2 +-
 arch/arm/mach-spear/platsmp.c                 |  4 +-
 arch/arm/mach-tegra/platsmp.c                 |  4 +-
 arch/arm/mach-tegra/pm.c                      |  2 +-
 arch/arm/mach-ux500/platsmp.c                 |  4 +-
 arch/arm/mach-zynq/common.h                   |  2 +-
 arch/arm/mach-zynq/headsmp.S                  |  2 -
 arch/arm/mach-zynq/platsmp.c                  |  6 +--
 arch/arm/mm/proc-arm1020.S                    |  2 -
 arch/arm/mm/proc-arm1020e.S                   |  2 -
 arch/arm/mm/proc-arm1022.S                    |  2 -
 arch/arm/mm/proc-arm1026.S                    |  3 --
 arch/arm/mm/proc-arm720.S                     |  2 -
 arch/arm/mm/proc-arm740.S                     |  2 -
 arch/arm/mm/proc-arm7tdmi.S                   |  2 -
 arch/arm/mm/proc-arm920.S                     |  2 -
 arch/arm/mm/proc-arm922.S                     |  2 -
 arch/arm/mm/proc-arm925.S                     |  2 -
 arch/arm/mm/proc-arm926.S                     |  2 -
 arch/arm/mm/proc-arm940.S                     |  2 -
 arch/arm/mm/proc-arm946.S                     |  2 -
 arch/arm/mm/proc-arm9tdmi.S                   |  2 -
 arch/arm/mm/proc-fa526.S                      |  2 -
 arch/arm/mm/proc-feroceon.S                   |  2 -
 arch/arm/mm/proc-mohawk.S                     |  2 -
 arch/arm/mm/proc-sa110.S                      |  2 -
 arch/arm/mm/proc-sa1100.S                     |  2 -
 arch/arm/mm/proc-v6.S                         |  2 -
 arch/arm/mm/proc-v7-2level.S                  |  4 --
 arch/arm/mm/proc-v7-3level.S                  |  4 --
 arch/arm/mm/proc-v7.S                         |  2 -
 arch/arm/mm/proc-xsc3.S                       |  2 -
 arch/arm/mm/proc-xscale.S                     |  2 -
 arch/arm/plat-versatile/platsmp.c             |  6 +--
 arch/arm64/include/asm/arch_timer.h           |  2 +-
 arch/arm64/kernel/debug-monitors.c            |  6 +--
 arch/arm64/kernel/hw_breakpoint.c             |  4 +-
 arch/arm64/kernel/smp.c                       |  8 ++--
 arch/blackfin/kernel/perf_event.c             |  2 +-
 arch/blackfin/kernel/setup.c                  |  4 +-
 arch/blackfin/mach-bf561/smp.c                |  6 +--
 arch/blackfin/mach-common/cache-c.c           |  4 +-
 arch/blackfin/mach-common/ints-priority.c     |  2 +-
 arch/blackfin/mach-common/smp.c               |  8 ++--
 arch/cris/arch-v32/kernel/smp.c               |  2 +-
 arch/frv/kernel/setup.c                       |  2 +-
 arch/hexagon/kernel/setup.c                   |  2 +-
 arch/hexagon/kernel/smp.c                     |  4 +-
 arch/ia64/kernel/acpi.c                       |  4 +-
 arch/ia64/kernel/err_inject.c                 |  8 ++--
 arch/ia64/kernel/mca.c                        | 12 ++---
 arch/ia64/kernel/numa.c                       |  4 +-
 arch/ia64/kernel/palinfo.c                    |  4 +-
 arch/ia64/kernel/salinfo.c                    |  4 +-
 arch/ia64/kernel/setup.c                      | 10 ++---
 arch/ia64/kernel/smpboot.c                    |  8 ++--
 arch/ia64/kernel/topology.c                   | 18 ++++----
 arch/ia64/mm/contig.c                         |  3 +-
 arch/ia64/mm/discontig.c                      |  2 +-
 arch/ia64/mm/numa.c                           |  2 +-
 arch/ia64/sn/kernel/setup.c                   |  8 ++--
 arch/ia64/xen/hypervisor.c                    |  2 +-
 arch/m32r/kernel/smpboot.c                    |  2 +-
 arch/metag/kernel/perf/perf_event.c           |  6 +--
 arch/metag/kernel/smp.c                       | 16 +++----
 arch/metag/kernel/traps.c                     |  2 +-
 arch/openrisc/kernel/setup.c                  |  2 +-
 arch/parisc/kernel/firmware.c                 | 14 +++---
 arch/parisc/kernel/hardware.c                 |  2 +-
 arch/parisc/kernel/processor.c                |  6 +--
 arch/parisc/kernel/smp.c                      |  8 ++--
 arch/powerpc/include/asm/rtas.h               |  4 +-
 arch/powerpc/include/asm/vdso.h               |  2 +-
 arch/powerpc/kernel/cacheinfo.c               | 36 ++++++++-------
 arch/powerpc/kernel/rtas.c                    |  4 +-
 arch/powerpc/kernel/smp.c                     |  4 +-
 arch/powerpc/kernel/sysfs.c                   |  6 +--
 arch/powerpc/kernel/time.c                    |  1 -
 arch/powerpc/kernel/vdso.c                    |  2 +-
 arch/powerpc/mm/44x_mmu.c                     |  6 +--
 arch/powerpc/mm/hash_utils_64.c               |  2 +-
 arch/powerpc/mm/mmu_context_nohash.c          |  6 +--
 arch/powerpc/mm/numa.c                        |  7 ++-
 arch/powerpc/mm/tlb_nohash.c                  |  2 +-
 arch/powerpc/perf/core-book3s.c               |  4 +-
 arch/powerpc/platforms/44x/currituck.c        |  4 +-
 arch/powerpc/platforms/44x/iss4xx.c           |  4 +-
 arch/powerpc/platforms/85xx/smp.c             |  6 +--
 arch/powerpc/platforms/powermac/smp.c         |  2 +-
 arch/powerpc/platforms/powernv/smp.c          |  2 +-
 arch/s390/kernel/cache.c                      | 15 +++----
 arch/s390/kernel/perf_cpum_cf.c               |  4 +-
 arch/s390/kernel/processor.c                  |  2 +-
 arch/s390/kernel/smp.c                        | 17 ++++---
 arch/s390/kernel/sysinfo.c                    |  2 +-
 arch/s390/kernel/vtime.c                      |  6 +--
 arch/s390/mm/fault.c                          |  4 +-
 arch/score/mm/tlb-score.c                     |  2 +-
 arch/sh/kernel/cpu/init.c                     | 18 ++++----
 arch/sh/kernel/cpu/sh2/probe.c                |  2 +-
 arch/sh/kernel/cpu/sh2a/probe.c               |  2 +-
 arch/sh/kernel/cpu/sh3/probe.c                |  2 +-
 arch/sh/kernel/cpu/sh4/probe.c                |  2 +-
 arch/sh/kernel/cpu/sh4a/smp-shx3.c            |  6 +--
 arch/sh/kernel/cpu/sh5/probe.c                |  2 +-
 arch/sh/kernel/perf_event.c                   |  4 +-
 arch/sh/kernel/process.c                      |  2 +-
 arch/sh/kernel/setup.c                        |  2 +-
 arch/sh/kernel/smp.c                          |  8 ++--
 arch/sh/kernel/traps_32.c                     |  2 +-
 arch/sh/kernel/traps_64.c                     |  2 +-
 arch/sh/mm/tlb-sh5.c                          |  2 +-
 arch/sparc/kernel/ds.c                        | 11 ++---
 arch/sparc/kernel/entry.h                     |  2 +-
 arch/sparc/kernel/hvtramp.S                   |  1 -
 arch/sparc/kernel/irq_64.c                    |  5 ++-
 arch/sparc/kernel/leon_smp.c                  | 10 ++---
 arch/sparc/kernel/mdesc.c                     | 34 +++++++-------
 arch/sparc/kernel/smp_32.c                    | 20 ++++-----
 arch/sparc/kernel/smp_64.c                    |  9 ++--
 arch/sparc/kernel/sun4d_smp.c                 |  6 +--
 arch/sparc/kernel/sun4m_smp.c                 |  6 +--
 arch/sparc/kernel/sysfs.c                     |  4 +-
 arch/sparc/kernel/trampoline_32.S             |  3 --
 arch/sparc/kernel/trampoline_64.S             |  2 -
 arch/sparc/mm/init_64.c                       |  2 +-
 arch/sparc/mm/srmmu.c                         | 12 ++---
 arch/tile/kernel/irq.c                        |  2 +-
 arch/tile/kernel/messaging.c                  |  2 +-
 arch/tile/kernel/setup.c                      | 12 ++---
 arch/tile/kernel/smpboot.c                    |  8 ++--
 arch/tile/kernel/time.c                       |  2 +-
 arch/x86/include/asm/cpu.h                    |  2 +-
 arch/x86/include/asm/microcode.h              |  4 +-
 arch/x86/include/asm/microcode_intel.h        |  4 +-
 arch/x86/include/asm/mmconfig.h               |  4 +-
 arch/x86/include/asm/mpspec.h                 |  2 +-
 arch/x86/include/asm/numa.h                   |  6 +--
 arch/x86/include/asm/prom.h                   |  2 +-
 arch/x86/include/asm/smp.h                    |  2 +-
 arch/x86/kernel/acpi/boot.c                   |  6 +--
 arch/x86/kernel/apic/apic.c                   | 30 ++++++-------
 arch/x86/kernel/apic/apic_numachip.c          |  2 +-
 arch/x86/kernel/apic/es7000_32.c              |  2 +-
 arch/x86/kernel/apic/numaq_32.c               |  2 +-
 arch/x86/kernel/apic/x2apic_cluster.c         |  2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c            | 14 +++---
 arch/x86/kernel/cpu/amd.c                     | 33 +++++++-------
 arch/x86/kernel/cpu/centaur.c                 | 26 +++++------
 arch/x86/kernel/cpu/common.c                  | 64 +++++++++++++--------------
 arch/x86/kernel/cpu/cyrix.c                   | 40 ++++++++---------
 arch/x86/kernel/cpu/hypervisor.c              |  2 +-
 arch/x86/kernel/cpu/intel.c                   | 30 ++++++-------
 arch/x86/kernel/cpu/intel_cacheinfo.c         | 55 +++++++++++------------
 arch/x86/kernel/cpu/mcheck/mce.c              | 23 +++++-----
 arch/x86/kernel/cpu/mcheck/mce_amd.c          | 14 +++---
 arch/x86/kernel/cpu/mcheck/therm_throt.c      |  9 ++--
 arch/x86/kernel/cpu/perf_event.c              |  2 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c      |  2 +-
 arch/x86/kernel/cpu/perf_event_amd_uncore.c   | 31 +++++++------
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 20 ++++-----
 arch/x86/kernel/cpu/rdrand.c                  |  2 +-
 arch/x86/kernel/cpu/scattered.c               |  4 +-
 arch/x86/kernel/cpu/topology.c                |  2 +-
 arch/x86/kernel/cpu/transmeta.c               |  6 +--
 arch/x86/kernel/cpu/umc.c                     |  2 +-
 arch/x86/kernel/cpu/vmware.c                  |  2 +-
 arch/x86/kernel/cpuid.c                       |  7 ++-
 arch/x86/kernel/devicetree.c                  |  2 +-
 arch/x86/kernel/head_32.S                     |  1 -
 arch/x86/kernel/i387.c                        |  8 ++--
 arch/x86/kernel/irq_32.c                      |  2 +-
 arch/x86/kernel/kvm.c                         | 10 ++---
 arch/x86/kernel/kvmclock.c                    |  2 +-
 arch/x86/kernel/microcode_core.c              |  2 +-
 arch/x86/kernel/microcode_core_early.c        |  6 +--
 arch/x86/kernel/microcode_intel_early.c       | 26 +++++------
 arch/x86/kernel/mmconf-fam10h_64.c            | 12 ++---
 arch/x86/kernel/msr.c                         |  6 +--
 arch/x86/kernel/process.c                     |  2 +-
 arch/x86/kernel/setup.c                       |  2 +-
 arch/x86/kernel/smpboot.c                     | 28 ++++++------
 arch/x86/kernel/tboot.c                       |  6 +--
 arch/x86/kernel/tsc.c                         |  4 +-
 arch/x86/kernel/tsc_sync.c                    | 18 ++++----
 arch/x86/kernel/vsyscall_64.c                 |  6 +--
 arch/x86/kernel/x86_init.c                    |  4 +-
 arch/x86/kernel/xsave.c                       |  4 +-
 arch/x86/mm/mmio-mod.c                        |  4 +-
 arch/x86/mm/numa.c                            | 12 ++---
 arch/x86/mm/numa_emulation.c                  | 12 ++---
 arch/x86/mm/setup_nx.c                        |  4 +-
 arch/x86/pci/amd_bus.c                        |  8 ++--
 arch/x86/platform/ce4100/ce4100.c             |  2 +-
 arch/x86/platform/mrst/mrst.c                 |  4 +-
 arch/x86/xen/enlighten.c                      |  6 +--
 arch/x86/xen/setup.c                          |  6 +--
 arch/x86/xen/smp.c                            | 12 ++---
 arch/x86/xen/spinlock.c                       |  2 +-
 arch/x86/xen/xen-ops.h                        |  2 +-
 arch/xtensa/kernel/time.c                     |  2 +-
 block/blk-iopoll.c                            |  6 +--
 block/blk-softirq.c                           |  6 +--
 drivers/acpi/acpi_processor.c                 |  2 +-
 drivers/acpi/processor_core.c                 |  8 ++--
 drivers/acpi/processor_driver.c               |  8 ++--
 drivers/acpi/processor_idle.c                 |  6 +--
 drivers/base/cpu.c                            |  2 +-
 drivers/base/topology.c                       | 10 ++---
 drivers/clocksource/arm_arch_timer.c          |  8 ++--
 drivers/clocksource/exynos_mct.c              |  4 +-
 drivers/clocksource/metag_generic.c           |  6 +--
 drivers/clocksource/time-armada-370-xp.c      |  4 +-
 drivers/clocksource/timer-marco.c             |  4 +-
 drivers/cpufreq/cpufreq.c                     |  4 +-
 drivers/cpufreq/cpufreq_stats.c               |  4 +-
 drivers/cpufreq/dbx500-cpufreq.c              |  2 +-
 drivers/cpufreq/intel_pstate.c                |  4 +-
 drivers/cpufreq/longhaul.c                    |  6 +--
 drivers/cpufreq/longhaul.h                    | 26 +++++------
 drivers/cpufreq/longrun.c                     |  8 ++--
 drivers/cpufreq/omap-cpufreq.c                |  2 +-
 drivers/cpufreq/powernow-k7.c                 |  8 ++--
 drivers/cpufreq/powernow-k8.c                 |  6 +--
 drivers/hwmon/coretemp.c                      | 39 ++++++++--------
 drivers/hwmon/via-cputemp.c                   |  8 ++--
 drivers/irqchip/irq-gic.c                     |  6 +--
 drivers/oprofile/timer_int.c                  |  4 +-
 drivers/xen/xen-acpi-cpuhotplug.c             |  2 +-
 include/asm-generic/vmlinux.lds.h             | 12 -----
 include/linux/cpu.h                           |  2 +-
 include/linux/init.h                          | 19 ++++----
 include/linux/perf_event.h                    |  2 +-
 init/calibrate.c                              | 13 +++---
 kernel/cpu.c                                  |  6 +--
 kernel/events/core.c                          |  4 +-
 kernel/fork.c                                 |  2 +-
 kernel/hrtimer.c                              |  6 +--
 kernel/printk.c                               |  2 +-
 kernel/profile.c                              |  2 +-
 kernel/rcutorture.c                           |  6 +--
 kernel/rcutree.c                              |  6 +--
 kernel/rcutree.h                              |  4 +-
 kernel/rcutree_plugin.h                       |  6 +--
 kernel/relay.c                                |  2 +-
 kernel/sched/core.c                           | 12 ++---
 kernel/sched/fair.c                           |  2 +-
 kernel/smp.c                                  |  2 +-
 kernel/smpboot.c                              |  2 +-
 kernel/softirq.c                              |  8 ++--
 kernel/time/tick-sched.c                      |  2 +-
 kernel/timer.c                                | 10 ++---
 kernel/workqueue.c                            |  4 +-
 lib/Kconfig.debug                             |  2 +-
 lib/earlycpio.c                               |  2 +-
 lib/percpu_counter.c                          |  2 +-
 mm/memcontrol.c                               |  2 +-
 mm/page-writeback.c                           |  4 +-
 mm/slab.c                                     | 10 ++---
 mm/slub.c                                     |  4 +-
 mm/vmstat.c                                   |  6 +--
 net/core/flow.c                               |  4 +-
 net/iucv/iucv.c                               |  2 +-
 scripts/mod/modpost.c                         | 52 ++++------------------
 307 files changed, 895 insertions(+), 1036 deletions(-)
