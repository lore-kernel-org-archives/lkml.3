Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab3KKPng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:43:36 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:48659 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab3KKPmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:42:23 -0500
Date: Mon, 11 Nov 2013 16:42:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v3.13
Message-ID: <20131111154216.GA11292@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

   # HEAD: e5137b50a0640009fd63a3e65c14bc6e1be8796a ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED

Main changes in this cycle are:

  - (much) improved CONFIG_NUMA_BALANCING support from Mel Gorman,
    Rik van Riel, Peter Zijlstra et al. Yay!

  - optimize preemption counter handling: merge the NEED_RESCHED flag into 
    the preempt_count variable, by Peter Zijlstra.

  - wait.h fixes and code reorganization from Peter Zijlstra

  - cfs_bandwidth fixes from Ben Segall

  - SMP load-balancer cleanups from Peter Zijstra

  - idle balancer improvements from Jason Low

  - other fixes and cleanups.

 Thanks,

	Ingo

------------------>
Ben Segall (4):
      sched: Fix race on toggling cfs_bandwidth_used
      sched: Fix cfs_bandwidth misuse of hrtimer_expires_remaining
      sched: Fix hrtimer_cancel()/rq->lock deadlock
      sched: Avoid throttle_cfs_rq() racing with period_timer stopping

Heiko Carstens (1):
      sched/wait: Fix __wait_event_interruptible_lock_irq_timeout()

Ingo Molnar (3):
      sched/wait: Clean up wait.h details a bit
      sched/numa: Add debugging
      x86: Apply the asm_volatile_goto() compiler quirk

Jason Low (3):
      sched: Reduce overestimating rq->avg_idle
      sched/balancing: Consider max cost of idle balance per sched domain
      sched/balancing: Periodically decay max cost of idle balance

Kamalesh Babulal (1):
      sched/fair: Fix trivial typos in comments

Li Bin (1):
      sched/rt: Fix task_tick_rt() comment

Mel Gorman (39):
      mm: numa: Document automatic NUMA balancing sysctls
      mm: numa: Do not account for a hinting fault if we raced
      mm: Wait for THP migrations to complete during NUMA hinting faults
      mm: Prevent parallel splits during THP migration
      mm: numa: Sanitize task_numa_fault() callsites
      mm: Close races between THP migration and PMD numa clearing
      mm: Account for a THP NUMA hinting update as one PTE update
      mm: Do not flush TLB during protection change if !pte_present && !migration_entry
      mm: Only flush TLBs if a transhuge PMD is modified for NUMA pte scanning
      mm: numa: Do not migrate or account for hinting faults on the zero page
      Revert "mm: sched: numa: Delay PTE scanning until a task is scheduled on a new node"
      sched/numa: Initialise numa_next_scan properly
      sched/numa: Set the scan rate proportional to the memory usage of the task being scanned
      sched/numa: Slow scan rate if no NUMA hinting faults are being recorded
      sched/numa: Track NUMA hinting faults on per-node basis
      sched/numa: Select a preferred node with the most numa hinting faults
      sched/numa: Update NUMA hinting faults once per scan
      sched/numa: Favour moving tasks towards the preferred node
      sched/numa: Resist moving tasks towards nodes with fewer hinting faults
      sched/numa: Reschedule task on preferred NUMA node once selected
      sched/numa: Add infrastructure for split shared/private accounting of NUMA hinting faults
      sched/numa: Check current->mm before allocating NUMA faults
      mm: numa: Scan pages with elevated page_mapcount
      sched/numa: Remove check that skips small VMAs
      sched/numa: Set preferred NUMA node based on number of private faults
      mm: numa: Limit NUMA scanning to migrate-on-fault VMAs
      sched/numa: Avoid overloading CPUs on a preferred NUMA node
      sched/numa: Retry migration of tasks to CPU on a preferred node
      sched/numa: Do not trap hinting faults for shared libraries
      mm: numa: Trap pmd hinting faults only if we would otherwise trap PTE faults
      sched/numa: Use a system-wide search to find swap/migration candidates
      sched/numa: Favor placing a task on the preferred node
      sched/numa: Report a NUMA task group ID
      mm: numa: Do not batch handle PMD pages
      sched/numa: Use group fault statistics in numa placement
      sched/numa: Prevent parallel updates to group stats during placement
      sched/numa: Take false sharing into account when adapting scan rate
      sched/numa: Remove the numa_balancing_scan_period_reset sysctl
      sched/numa: Use unsigned longs for numa group fault stats

Michael S. Tsirkin (1):
      sched: Micro-optimize by dropping unnecessary task_rq() calls

Michael wang (1):
      sched: Remove extra put_online_cpus() inside sched_setaffinity()

Oleg Nesterov (2):
      sched/wait: Add ___wait_cond_timeout() to wait_event*_timeout() too
      sched/wait: Introduce prepare_to_wait_event()

Paul Turner (1):
      sched: Guarantee new group-entities always have weight

Peter Zijlstra (52):
      sched/fair: Rewrite group_imb trigger
      sched/fair: Reduce local_group logic
      sched/fair: Fix group power_orig computation
      sched/fair: Rework and comment the group_capacity code
      sched/fair: Fix the group_capacity computation
      x86: Use asm goto to implement better modify_and_test() functions
      sched, rcu: Make RCU use resched_cpu()
      sched: Remove {set,clear}_need_resched
      sched, idle: Fix the idle polling state logic
      sched: Introduce preempt_count accessor functions
      sched: Add NEED_RESCHED to the preempt_count
      sched, arch: Create asm/preempt.h
      sched: Create more preempt_count accessors
      sched: Extract the basic add/sub preempt_count modifiers
      sched: Prepare for per-cpu preempt_count
      sched, x86: Provide a per-cpu preempt_count implementation
      sched, x86: Optimize the preempt_schedule() call
      sched: Revert need_resched() to look at TIF_NEED_RESCHED
      sched/wait: Make the signal_pending() checks consistent
      sched/wait: Change timeout logic
      sched/wait: Change the wait_exclusive control flow
      sched/wait: Introduce ___wait_event()
      sched/wait: Collapse __wait_event()
      sched/wait: Collapse __wait_event_timeout()
      sched/wait: Collapse __wait_event_interruptible()
      sched/wait: Collapse __wait_event_interruptible_timeout()
      sched/wait: Collapse __wait_event_interruptible_exclusive()
      sched/wait: Collapse __wait_event_lock_irq()
      sched/wait: Collapse __wait_event_interruptible_lock_irq()
      sched/wait: Collapse __wait_event_interruptible_lock_irq_timeout()
      sched/wait: Collapse __wait_event_interruptible_tty()
      sched/wait: Collapse __wait_event_killable()
      sched/wait: Collapse __wait_event_hrtimeout()
      sched/wait: Make the __wait_event*() interface more friendly
      MAINTAINERS, sched: Update file pattern
      sched/numa: Fix comments
      sched/numa: Mitigate chance that same task always updates PTEs
      sched/numa: Continue PTE scanning even if migrate rate limited
      stop_machine: Introduce stop_two_cpus()
      sched/numa: Introduce migrate_swap()
      mm: numa: Change page last {nid,pid} into {cpu,pid}
      sched/numa: Use {cpu, pid} to create task groups for shared faults
      mm: numa: Do not group on RO pages
      sched/numa: Avoid migrating tasks that are placed on their preferred node
      sched/numa: Reflow task_numa_group() to avoid a compiler warning
      sched/rt: Add missing rmb()
      sched: Fix race in migrate_swap_stop()
      sched: Remove get_online_cpus() usage
      sched: Move wait.c into kernel/sched/
      sched: Move wait code from core.c to wait.c
      sched: Move completion code from core.c to completion.c
      ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED

Preeti U Murthy (1):
      sched: Remove unnecessary iteration over sched domains to update nr_busy_cpus

Ramkumar Ramachandra (1):
      sched: Remove bogus parameter in structured comment

Rik van Riel (14):
      sched/numa: Do not migrate memory immediately after switching node
      sched/numa: Increment numa_migrate_seq when task runs in correct location
      sched/numa: Fix placement of workloads spread across multiple nodes
      mm: numa: Copy cpupid on page migration
      sched/numa: Stay on the same node if CLONE_VM
      sched/numa: Call task_numa_free() from do_execve()
      sched/numa: Decide whether to favour task or group weights based on swap candidate relationships
      sched/numa: Fix task or group comparison
      sched/numa: Be more careful about joining numa groups
      sched/numa: Adjust scan rate in task_numa_placement
      mm: numa: Revert temporarily disabling of NUMA migration
      sched/numa: Skip some page migrations after a shared fault
      sched/numa: Retry task_numa_migrate() periodically
      stop_machine: Fix race between stop_two_cpus() and stop_cpus()

Shawn Bohrer (1):
      sched/rt: Remove redundant nr_cpus_allowed test

Thierry Reding (1):
      sched/wait: Fix build breakage

Vaidyanathan Srinivasan (1):
      sched: Fix asymmetric scheduling for POWER7

Vladimir Davydov (1):
      sched/balancing: Prevent the reselection of a previous env.dst_cpu if some tasks are pinned


 Documentation/sysctl/kernel.txt    |   76 ++
 Documentation/trace/ftrace.txt     |    6 +-
 MAINTAINERS                        |    2 +
 arch/alpha/include/asm/Kbuild      |    1 +
 arch/arc/include/asm/Kbuild        |    1 +
 arch/arm/include/asm/Kbuild        |    1 +
 arch/arm64/include/asm/Kbuild      |    1 +
 arch/avr32/include/asm/Kbuild      |    1 +
 arch/blackfin/include/asm/Kbuild   |    1 +
 arch/c6x/include/asm/Kbuild        |    1 +
 arch/cris/include/asm/Kbuild       |    1 +
 arch/frv/include/asm/Kbuild        |    1 +
 arch/h8300/include/asm/Kbuild      |    1 +
 arch/hexagon/include/asm/Kbuild    |    1 +
 arch/ia64/include/asm/Kbuild       |    1 +
 arch/m32r/include/asm/Kbuild       |    1 +
 arch/m68k/include/asm/Kbuild       |    1 +
 arch/metag/include/asm/Kbuild      |    1 +
 arch/metag/include/asm/topology.h  |    2 +
 arch/microblaze/include/asm/Kbuild |    1 +
 arch/mips/include/asm/Kbuild       |    1 +
 arch/mips/kernel/rtlx.c            |   19 +-
 arch/mips/mm/init.c                |    5 +-
 arch/mn10300/include/asm/Kbuild    |    1 +
 arch/openrisc/include/asm/Kbuild   |    1 +
 arch/parisc/include/asm/Kbuild     |    1 +
 arch/powerpc/include/asm/Kbuild    |    1 +
 arch/s390/include/asm/Kbuild       |    1 +
 arch/score/include/asm/Kbuild      |    1 +
 arch/sh/include/asm/Kbuild         |    1 +
 arch/sparc/include/asm/Kbuild      |    1 +
 arch/tile/include/asm/Kbuild       |    1 +
 arch/um/include/asm/Kbuild         |    1 +
 arch/unicore32/include/asm/Kbuild  |    1 +
 arch/x86/include/asm/atomic.h      |   29 +-
 arch/x86/include/asm/atomic64_64.h |   28 +-
 arch/x86/include/asm/bitops.h      |   24 +-
 arch/x86/include/asm/calling.h     |   50 ++
 arch/x86/include/asm/local.h       |   28 +-
 arch/x86/include/asm/preempt.h     |  100 +++
 arch/x86/include/asm/rmwcc.h       |   41 ++
 arch/x86/include/asm/thread_info.h |    5 +-
 arch/x86/kernel/Makefile           |    2 +
 arch/x86/kernel/asm-offsets.c      |    1 -
 arch/x86/kernel/cpu/common.c       |    5 +
 arch/x86/kernel/entry_32.S         |    7 +-
 arch/x86/kernel/entry_64.S         |    4 +-
 arch/x86/kernel/i386_ksyms_32.c    |    7 +
 arch/x86/kernel/irq_32.c           |    4 -
 arch/x86/kernel/preempt.S          |   25 +
 arch/x86/kernel/process.c          |    6 +-
 arch/x86/kernel/process_32.c       |    8 +
 arch/x86/kernel/process_64.c       |    8 +
 arch/x86/kernel/traps.c            |    4 +-
 arch/x86/kernel/x8664_ksyms_64.c   |    7 +
 arch/xtensa/include/asm/Kbuild     |    1 +
 drivers/acpi/processor_idle.c      |   46 +-
 drivers/idle/intel_idle.c          |    2 +-
 fs/exec.c                          |    1 +
 fs/proc/array.c                    |    2 +
 include/asm-generic/preempt.h      |  105 +++
 include/linux/completion.h         |    2 +-
 include/linux/hardirq.h            |    8 +-
 include/linux/mempolicy.h          |    1 +
 include/linux/migrate.h            |    7 +-
 include/linux/mm.h                 |  118 ++-
 include/linux/mm_types.h           |   17 +-
 include/linux/page-flags-layout.h  |   28 +-
 include/linux/preempt.h            |  112 ++-
 include/linux/sched.h              |  167 ++++-
 include/linux/sched/sysctl.h       |    1 -
 include/linux/stop_machine.h       |    1 +
 include/linux/thread_info.h        |   17 +-
 include/linux/topology.h           |    6 +
 include/linux/tty.h                |   28 +-
 include/linux/uaccess.h            |    8 +-
 include/linux/wait.h               |  374 ++++------
 include/trace/events/sched.h       |    2 +-
 init/main.c                        |    2 +-
 kernel/Makefile                    |    2 +-
 kernel/bounds.c                    |    4 +
 kernel/context_tracking.c          |    2 +-
 kernel/cpu.c                       |   17 +
 kernel/cpu/idle.c                  |   16 +-
 kernel/fork.c                      |    5 +-
 kernel/rcutree.c                   |   15 +-
 kernel/sched/Makefile              |    1 +
 kernel/sched/completion.c          |  299 ++++++++
 kernel/sched/core.c                |  683 ++++++------------
 kernel/sched/debug.c               |   68 +-
 kernel/sched/fair.c                | 1397 ++++++++++++++++++++++++++++++------
 kernel/sched/features.h            |   19 +-
 kernel/sched/idle_task.c           |    2 +-
 kernel/sched/rt.c                  |   22 +-
 kernel/sched/sched.h               |   54 +-
 kernel/sched/stats.h               |   46 +-
 kernel/sched/stop_task.c           |    2 +-
 kernel/{ => sched}/wait.c          |  127 ++++
 kernel/softirq.c                   |   16 +-
 kernel/stop_machine.c              |  303 +++++---
 kernel/sysctl.c                    |   21 +-
 kernel/timer.c                     |    8 +-
 kernel/trace/trace.c               |    3 +-
 kernel/trace/trace.h               |    1 +
 kernel/trace/trace_output.c        |   19 +-
 lib/locking-selftest.c             |    2 +-
 lib/smp_processor_id.c             |    3 +-
 mm/huge_memory.c                   |   55 +-
 mm/memory.c                        |  139 ++--
 mm/mempolicy.c                     |   82 ++-
 mm/migrate.c                       |   30 +-
 mm/mm_init.c                       |   18 +-
 mm/mmzone.c                        |   14 +-
 mm/mprotect.c                      |   65 +-
 mm/page_alloc.c                    |    4 +-
 net/irda/af_irda.c                 |    5 +-
 net/netfilter/ipvs/ip_vs_sync.c    |    7 +-
 117 files changed, 3569 insertions(+), 1594 deletions(-)
 create mode 100644 arch/x86/include/asm/preempt.h
 create mode 100644 arch/x86/include/asm/rmwcc.h
 create mode 100644 arch/x86/kernel/preempt.S
 create mode 100644 include/asm-generic/preempt.h
 create mode 100644 kernel/sched/completion.c
 rename kernel/{ => sched}/wait.c (74%)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 9d4c1d1..4273b2d 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -355,6 +355,82 @@ utilize.
 
 ==============================================================
 
+numa_balancing
+
+Enables/disables automatic page fault based NUMA memory
+balancing. Memory is moved automatically to nodes
+that access it often.
+
+Enables/disables automatic NUMA memory balancing. On NUMA machines, there
+is a performance penalty if remote memory is accessed by a CPU. When this
+feature is enabled the kernel samples what task thread is accessing memory
+by periodically unmapping pages and later trapping a page fault. At the
+time of the page fault, it is determined if the data being accessed should
+be migrated to a local memory node.
+
+The unmapping of pages and trapping faults incur additional overhead that
+ideally is offset by improved memory locality but there is no universal
+guarantee. If the target workload is already bound to NUMA nodes then this
+feature should be disabled. Otherwise, if the system overhead from the
+feature is too high then the rate the kernel samples for NUMA hinting
+faults may be controlled by the numa_balancing_scan_period_min_ms,
+numa_balancing_scan_delay_ms, numa_balancing_scan_period_max_ms,
+numa_balancing_scan_size_mb, numa_balancing_settle_count sysctls and
+numa_balancing_migrate_deferred.
+
+==============================================================
+
+numa_balancing_scan_period_min_ms, numa_balancing_scan_delay_ms,
+numa_balancing_scan_period_max_ms, numa_balancing_scan_size_mb
+
+Automatic NUMA balancing scans tasks address space and unmaps pages to
+detect if pages are properly placed or if the data should be migrated to a
+memory node local to where the task is running.  Every "scan delay" the task
+scans the next "scan size" number of pages in its address space. When the
+end of the address space is reached the scanner restarts from the beginning.
+
+In combination, the "scan delay" and "scan size" determine the scan rate.
+When "scan delay" decreases, the scan rate increases.  The scan delay and
+hence the scan rate of every task is adaptive and depends on historical
+behaviour. If pages are properly placed then the scan delay increases,
+otherwise the scan delay decreases.  The "scan size" is not adaptive but
+the higher the "scan size", the higher the scan rate.
+
+Higher scan rates incur higher system overhead as page faults must be
+trapped and potentially data must be migrated. However, the higher the scan
+rate, the more quickly a tasks memory is migrated to a local node if the
+workload pattern changes and minimises performance impact due to remote
+memory accesses. These sysctls control the thresholds for scan delays and
+the number of pages scanned.
+
+numa_balancing_scan_period_min_ms is the minimum time in milliseconds to
+scan a tasks virtual memory. It effectively controls the maximum scanning
+rate for each task.
+
+numa_balancing_scan_delay_ms is the starting "scan delay" used for a task
+when it initially forks.
+
+numa_balancing_scan_period_max_ms is the maximum time in milliseconds to
+scan a tasks virtual memory. It effectively controls the minimum scanning
+rate for each task.
+
+numa_balancing_scan_size_mb is how many megabytes worth of pages are
+scanned for a given scan.
+
+numa_balancing_settle_count is how many scan periods must complete before
+the schedule balancer stops pushing the task towards a preferred node. This
+gives the scheduler a chance to place the task on an alternative node if the
+preferred node is overloaded.
+
+numa_balancing_migrate_deferred is how many page migrations get skipped
+unconditionally, after a page migration is skipped because a page is shared
+with other tasks. This reduces page migration overhead, and determines
+how much stronger the "move task near its memory" policy scheduler becomes,
+versus the "move memory near its task" memory management policy, for workloads
+with shared memory.
+
+==============================================================
+
 osrelease, ostype & version:
 
 # cat osrelease
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index ea2d35d..bd36598 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -655,7 +655,11 @@ explains which is which.
 		  read the irq flags variable, an 'X' will always
 		  be printed here.
 
-  need-resched: 'N' task need_resched is set, '.' otherwise.
+  need-resched:
+	'N' both TIF_NEED_RESCHED and PREEMPT_NEED_RESCHED is set,
+	'n' only TIF_NEED_RESCHED is set,
+	'p' only PREEMPT_NEED_RESCHED is set,
+	'.' otherwise.
 
   hardirq/softirq:
 	'H' - hard irq occurred inside a softirq.
diff --git a/MAINTAINERS b/MAINTAINERS
index 3438384..dcd69cb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7303,6 +7303,8 @@ S:	Maintained
 F:	kernel/sched/
 F:	include/linux/sched.h
 F:	include/uapi/linux/sched.h
+F:	kernel/wait.c
+F:	include/linux/wait.h
 
 SCORE ARCHITECTURE
 M:	Chen Liqin <liqin.linux@gmail.com>
diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index a6e85f44..f01fb50 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += clkdev.h
 
 generic-y += exec.h
 generic-y += trace_clock.h
+generic-y += preempt.h
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index d8dd660..5943f7f 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -46,3 +46,4 @@ generic-y += ucontext.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index 59ceae8..1a7024b 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -32,3 +32,4 @@ generic-y += termios.h
 generic-y += timex.h
 generic-y += trace_clock.h
 generic-y += unaligned.h
+generic-y += preempt.h
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 79a642d..519f89f 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -50,3 +50,4 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index fd79807..658001b 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -7,6 +7,7 @@ generic-y       += div64.h
 generic-y       += emergency-restart.h
 generic-y	+= exec.h
 generic-y       += futex.h
+generic-y	+= preempt.h
 generic-y       += irq_regs.h
 generic-y	+= param.h
 generic-y       += local.h
diff --git a/arch/blackfin/include/asm/Kbuild b/arch/blackfin/include/asm/Kbuild
index 127826f..f2b4347 100644
--- a/arch/blackfin/include/asm/Kbuild
+++ b/arch/blackfin/include/asm/Kbuild
@@ -44,3 +44,4 @@ generic-y += ucontext.h
 generic-y += unaligned.h
 generic-y += user.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index e49f918..fc0b3c3 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -56,3 +56,4 @@ generic-y += ucontext.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index c832545..b06caf6 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -11,3 +11,4 @@ generic-y += module.h
 generic-y += trace_clock.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index c5d7670..74742dc 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -2,3 +2,4 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
+generic-y += preempt.h
diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index 8ada3cf..7e0e721 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -6,3 +6,4 @@ generic-y += mmu.h
 generic-y += module.h
 generic-y += trace_clock.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 1da17ca..67c3450 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -53,3 +53,4 @@ generic-y += types.h
 generic-y += ucontext.h
 generic-y += unaligned.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index a3456f3..f93ee08 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -3,4 +3,5 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += kvm_para.h
 generic-y += trace_clock.h
+generic-y += preempt.h
 generic-y += vtime.h
\ No newline at end of file
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index bebdc36..2b58c5f 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += module.h
 generic-y += trace_clock.h
+generic-y += preempt.h
diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index 09d77a8..a5d27f2 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -31,3 +31,4 @@ generic-y += trace_clock.h
 generic-y += types.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/metag/include/asm/Kbuild b/arch/metag/include/asm/Kbuild
index 6ae0ccb..84d0c1d 100644
--- a/arch/metag/include/asm/Kbuild
+++ b/arch/metag/include/asm/Kbuild
@@ -52,3 +52,4 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/metag/include/asm/topology.h b/arch/metag/include/asm/topology.h
index 23f5118..8e9c0b3 100644
--- a/arch/metag/include/asm/topology.h
+++ b/arch/metag/include/asm/topology.h
@@ -26,6 +26,8 @@
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 	.nr_balance_failed	= 0,			\
+	.max_newidle_lb_cost	= 0,			\
+	.next_decay_max_lb_cost	= jiffies,		\
 }
 
 #define cpu_to_node(cpu)	((void)(cpu), 0)
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index d3c51a6..ce0bbf8 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += syscalls.h
+generic-y += preempt.h
diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index 454ddf9..1acbb8b 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -11,5 +11,6 @@ generic-y += sections.h
 generic-y += segment.h
 generic-y += serial.h
 generic-y += trace_clock.h
+generic-y += preempt.h
 generic-y += ucontext.h
 generic-y += xor.h
diff --git a/arch/mips/kernel/rtlx.c b/arch/mips/kernel/rtlx.c
index d763f11..2c12ea1 100644
--- a/arch/mips/kernel/rtlx.c
+++ b/arch/mips/kernel/rtlx.c
@@ -172,8 +172,9 @@ int rtlx_open(int index, int can_sleep)
 	if (rtlx == NULL) {
 		if( (p = vpe_get_shared(tclimit)) == NULL) {
 		    if (can_sleep) {
-			__wait_event_interruptible(channel_wqs[index].lx_queue,
-				(p = vpe_get_shared(tclimit)), ret);
+			ret = __wait_event_interruptible(
+					channel_wqs[index].lx_queue,
+					(p = vpe_get_shared(tclimit)));
 			if (ret)
 				goto out_fail;
 		    } else {
@@ -263,11 +264,10 @@ unsigned int rtlx_read_poll(int index, int can_sleep)
 	/* data available to read? */
 	if (chan->lx_read == chan->lx_write) {
 		if (can_sleep) {
-			int ret = 0;
-
-			__wait_event_interruptible(channel_wqs[index].lx_queue,
+			int ret = __wait_event_interruptible(
+				channel_wqs[index].lx_queue,
 				(chan->lx_read != chan->lx_write) ||
-				sp_stopping, ret);
+				sp_stopping);
 			if (ret)
 				return ret;
 
@@ -440,14 +440,13 @@ static ssize_t file_write(struct file *file, const char __user * buffer,
 
 	/* any space left... */
 	if (!rtlx_write_poll(minor)) {
-		int ret = 0;
+		int ret;
 
 		if (file->f_flags & O_NONBLOCK)
 			return -EAGAIN;
 
-		__wait_event_interruptible(channel_wqs[minor].rt_queue,
-					   rtlx_write_poll(minor),
-					   ret);
+		ret = __wait_event_interruptible(channel_wqs[minor].rt_queue,
+					   rtlx_write_poll(minor));
 		if (ret)
 			return ret;
 	}
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index e205ef5..1215617 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -124,7 +124,7 @@ void *kmap_coherent(struct page *page, unsigned long addr)
 
 	BUG_ON(Page_dcache_dirty(page));
 
-	inc_preempt_count();
+	pagefault_disable();
 	idx = (addr >> PAGE_SHIFT) & (FIX_N_COLOURS - 1);
 #ifdef CONFIG_MIPS_MT_SMTC
 	idx += FIX_N_COLOURS * smp_processor_id() +
@@ -193,8 +193,7 @@ void kunmap_coherent(void)
 	write_c0_entryhi(old_ctx);
 	EXIT_CRITICAL(flags);
 #endif
-	dec_preempt_count();
-	preempt_check_resched();
+	pagefault_enable();
 }
 
 void copy_user_highpage(struct page *to, struct page *from,
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index c5d7670..74742dc 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -2,3 +2,4 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
+generic-y += preempt.h
diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 195653e..7840562 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -67,3 +67,4 @@ generic-y += ucontext.h
 generic-y += user.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index ff4c9fa..a603b9e 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += word-at-a-time.h auxvec.h user.h cputime.h emergency-restart.h \
 	  div64.h irq_regs.h kdebug.h kvm_para.h local64.h local.h param.h \
 	  poll.h xor.h clkdev.h exec.h
 generic-y += trace_clock.h
+generic-y += preempt.h
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index 704e6f1..d8f9d2f 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -2,4 +2,5 @@
 generic-y += clkdev.h
 generic-y += rwsem.h
 generic-y += trace_clock.h
+generic-y += preempt.h
 generic-y += vtime.h
\ No newline at end of file
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index f313f9c..7a5288f 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -2,3 +2,4 @@
 
 generic-y += clkdev.h
 generic-y += trace_clock.h
+generic-y += preempt.h
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index e1c7bb9..f3414ad 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -4,3 +4,4 @@ header-y +=
 generic-y += clkdev.h
 generic-y += trace_clock.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/sh/include/asm/Kbuild b/arch/sh/include/asm/Kbuild
index 280bea9..231efbb 100644
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -34,3 +34,4 @@ generic-y += termios.h
 generic-y += trace_clock.h
 generic-y += ucontext.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index 7e4a97f..bf39066 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -16,3 +16,4 @@ generic-y += serial.h
 generic-y += trace_clock.h
 generic-y += types.h
 generic-y += word-at-a-time.h
+generic-y += preempt.h
diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index 664d6ad..22f3bd1 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -38,3 +38,4 @@ generic-y += termios.h
 generic-y += trace_clock.h
 generic-y += types.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index b30f34a..fdde187 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += hw_irq.h irq_regs.h kdebug.h percpu.h sections.h topology.h xor.h
 generic-y += ftrace.h pci.h io.h param.h delay.h mutex.h current.h exec.h
 generic-y += switch_to.h clkdev.h
 generic-y += trace_clock.h
+generic-y += preempt.h
diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm/Kbuild
index 89d8b6c..00045cb 100644
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -60,3 +60,4 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 722aa3b..da31c8b 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -6,6 +6,7 @@
 #include <asm/processor.h>
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
+#include <asm/rmwcc.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -76,12 +77,7 @@ static inline void atomic_sub(int i, atomic_t *v)
  */
 static inline int atomic_sub_and_test(int i, atomic_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
+	GEN_BINARY_RMWcc(LOCK_PREFIX "subl", v->counter, i, "%0", "e");
 }
 
 /**
@@ -118,12 +114,7 @@ static inline void atomic_dec(atomic_t *v)
  */
 static inline int atomic_dec_and_test(atomic_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "decl %0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
+	GEN_UNARY_RMWcc(LOCK_PREFIX "decl", v->counter, "%0", "e");
 }
 
 /**
@@ -136,12 +127,7 @@ static inline int atomic_dec_and_test(atomic_t *v)
  */
 static inline int atomic_inc_and_test(atomic_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "incl %0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
+	GEN_UNARY_RMWcc(LOCK_PREFIX "incl", v->counter, "%0", "e");
 }
 
 /**
@@ -155,12 +141,7 @@ static inline int atomic_inc_and_test(atomic_t *v)
  */
 static inline int atomic_add_negative(int i, atomic_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "addl %2,%0; sets %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
+	GEN_BINARY_RMWcc(LOCK_PREFIX "addl", v->counter, i, "%0", "s");
 }
 
 /**
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 0e1cbfc..3f065c9 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -72,12 +72,7 @@ static inline void atomic64_sub(long i, atomic64_t *v)
  */
 static inline int atomic64_sub_and_test(long i, atomic64_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "subq %2,%0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "er" (i), "m" (v->counter) : "memory");
-	return c;
+	GEN_BINARY_RMWcc(LOCK_PREFIX "subq", v->counter, i, "%0", "e");
 }
 
 /**
@@ -116,12 +111,7 @@ static inline void atomic64_dec(atomic64_t *v)
  */
 static inline int atomic64_dec_and_test(atomic64_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "decq %0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "m" (v->counter) : "memory");
-	return c != 0;
+	GEN_UNARY_RMWcc(LOCK_PREFIX "decq", v->counter, "%0", "e");
 }
 
 /**
@@ -134,12 +124,7 @@ static inline int atomic64_dec_and_test(atomic64_t *v)
  */
 static inline int atomic64_inc_and_test(atomic64_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "incq %0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "m" (v->counter) : "memory");
-	return c != 0;
+	GEN_UNARY_RMWcc(LOCK_PREFIX "incq", v->counter, "%0", "e");
 }
 
 /**
@@ -153,12 +138,7 @@ static inline int atomic64_inc_and_test(atomic64_t *v)
  */
 static inline int atomic64_add_negative(long i, atomic64_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "addq %2,%0; sets %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "er" (i), "m" (v->counter) : "memory");
-	return c;
+	GEN_BINARY_RMWcc(LOCK_PREFIX "addq", v->counter, i, "%0", "s");
 }
 
 /**
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 41639ce..6d76d09 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -14,6 +14,7 @@
 
 #include <linux/compiler.h>
 #include <asm/alternative.h>
+#include <asm/rmwcc.h>
 
 #if BITS_PER_LONG == 32
 # define _BITOPS_LONG_SHIFT 5
@@ -204,12 +205,7 @@ static inline void change_bit(long nr, volatile unsigned long *addr)
  */
 static inline int test_and_set_bit(long nr, volatile unsigned long *addr)
 {
-	int oldbit;
-
-	asm volatile(LOCK_PREFIX "bts %2,%1\n\t"
-		     "sbb %0,%0" : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
-
-	return oldbit;
+	GEN_BINARY_RMWcc(LOCK_PREFIX "bts", *addr, nr, "%0", "c");
 }
 
 /**
@@ -255,13 +251,7 @@ static inline int __test_and_set_bit(long nr, volatile unsigned long *addr)
  */
 static inline int test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
-	int oldbit;
-
-	asm volatile(LOCK_PREFIX "btr %2,%1\n\t"
-		     "sbb %0,%0"
-		     : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
-
-	return oldbit;
+	GEN_BINARY_RMWcc(LOCK_PREFIX "btr", *addr, nr, "%0", "c");
 }
 
 /**
@@ -314,13 +304,7 @@ static inline int __test_and_change_bit(long nr, volatile unsigned long *addr)
  */
 static inline int test_and_change_bit(long nr, volatile unsigned long *addr)
 {
-	int oldbit;
-
-	asm volatile(LOCK_PREFIX "btc %2,%1\n\t"
-		     "sbb %0,%0"
-		     : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
-
-	return oldbit;
+	GEN_BINARY_RMWcc(LOCK_PREFIX "btc", *addr, nr, "%0", "c");
 }
 
 static __always_inline int constant_test_bit(long nr, const volatile unsigned long *addr)
diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index 0fa6750..cb4c73b 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -48,6 +48,8 @@ For 32-bit we have the following conventions - kernel is built with
 
 #include <asm/dwarf2.h>
 
+#ifdef CONFIG_X86_64
+
 /*
  * 64-bit system call stack frame layout defines and helpers,
  * for assembly code:
@@ -192,3 +194,51 @@ For 32-bit we have the following conventions - kernel is built with
 	.macro icebp
 	.byte 0xf1
 	.endm
+
+#else /* CONFIG_X86_64 */
+
+/*
+ * For 32bit only simplified versions of SAVE_ALL/RESTORE_ALL. These
+ * are different from the entry_32.S versions in not changing the segment
+ * registers. So only suitable for in kernel use, not when transitioning
+ * from or to user space. The resulting stack frame is not a standard
+ * pt_regs frame. The main use case is calling C code from assembler
+ * when all the registers need to be preserved.
+ */
+
+	.macro SAVE_ALL
+	pushl_cfi %eax
+	CFI_REL_OFFSET eax, 0
+	pushl_cfi %ebp
+	CFI_REL_OFFSET ebp, 0
+	pushl_cfi %edi
+	CFI_REL_OFFSET edi, 0
+	pushl_cfi %esi
+	CFI_REL_OFFSET esi, 0
+	pushl_cfi %edx
+	CFI_REL_OFFSET edx, 0
+	pushl_cfi %ecx
+	CFI_REL_OFFSET ecx, 0
+	pushl_cfi %ebx
+	CFI_REL_OFFSET ebx, 0
+	.endm
+
+	.macro RESTORE_ALL
+	popl_cfi %ebx
+	CFI_RESTORE ebx
+	popl_cfi %ecx
+	CFI_RESTORE ecx
+	popl_cfi %edx
+	CFI_RESTORE edx
+	popl_cfi %esi
+	CFI_RESTORE esi
+	popl_cfi %edi
+	CFI_RESTORE edi
+	popl_cfi %ebp
+	CFI_RESTORE ebp
+	popl_cfi %eax
+	CFI_RESTORE eax
+	.endm
+
+#endif /* CONFIG_X86_64 */
+
diff --git a/arch/x86/include/asm/local.h b/arch/x86/include/asm/local.h
index 2d89e39..5b23e60 100644
--- a/arch/x86/include/asm/local.h
+++ b/arch/x86/include/asm/local.h
@@ -52,12 +52,7 @@ static inline void local_sub(long i, local_t *l)
  */
 static inline int local_sub_and_test(long i, local_t *l)
 {
-	unsigned char c;
-
-	asm volatile(_ASM_SUB "%2,%0; sete %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
+	GEN_BINARY_RMWcc(_ASM_SUB, l->a.counter, i, "%0", "e");
 }
 
 /**
@@ -70,12 +65,7 @@ static inline int local_sub_and_test(long i, local_t *l)
  */
 static inline int local_dec_and_test(local_t *l)
 {
-	unsigned char c;
-
-	asm volatile(_ASM_DEC "%0; sete %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
+	GEN_UNARY_RMWcc(_ASM_DEC, l->a.counter, "%0", "e");
 }
 
 /**
@@ -88,12 +78,7 @@ static inline int local_dec_and_test(local_t *l)
  */
 static inline int local_inc_and_test(local_t *l)
 {
-	unsigned char c;
-
-	asm volatile(_ASM_INC "%0; sete %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
+	GEN_UNARY_RMWcc(_ASM_INC, l->a.counter, "%0", "e");
 }
 
 /**
@@ -107,12 +92,7 @@ static inline int local_inc_and_test(local_t *l)
  */
 static inline int local_add_negative(long i, local_t *l)
 {
-	unsigned char c;
-
-	asm volatile(_ASM_ADD "%2,%0; sets %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
+	GEN_BINARY_RMWcc(_ASM_ADD, l->a.counter, i, "%0", "s");
 }
 
 /**
diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
new file mode 100644
index 0000000..8729723
--- /dev/null
+++ b/arch/x86/include/asm/preempt.h
@@ -0,0 +1,100 @@
+#ifndef __ASM_PREEMPT_H
+#define __ASM_PREEMPT_H
+
+#include <asm/rmwcc.h>
+#include <asm/percpu.h>
+#include <linux/thread_info.h>
+
+DECLARE_PER_CPU(int, __preempt_count);
+
+/*
+ * We mask the PREEMPT_NEED_RESCHED bit so as not to confuse all current users
+ * that think a non-zero value indicates we cannot preempt.
+ */
+static __always_inline int preempt_count(void)
+{
+	return __this_cpu_read_4(__preempt_count) & ~PREEMPT_NEED_RESCHED;
+}
+
+static __always_inline void preempt_count_set(int pc)
+{
+	__this_cpu_write_4(__preempt_count, pc);
+}
+
+/*
+ * must be macros to avoid header recursion hell
+ */
+#define task_preempt_count(p) \
+	(task_thread_info(p)->saved_preempt_count & ~PREEMPT_NEED_RESCHED)
+
+#define init_task_preempt_count(p) do { \
+	task_thread_info(p)->saved_preempt_count = PREEMPT_DISABLED; \
+} while (0)
+
+#define init_idle_preempt_count(p, cpu) do { \
+	task_thread_info(p)->saved_preempt_count = PREEMPT_ENABLED; \
+	per_cpu(__preempt_count, (cpu)) = PREEMPT_ENABLED; \
+} while (0)
+
+/*
+ * We fold the NEED_RESCHED bit into the preempt count such that
+ * preempt_enable() can decrement and test for needing to reschedule with a
+ * single instruction.
+ *
+ * We invert the actual bit, so that when the decrement hits 0 we know we both
+ * need to resched (the bit is cleared) and can resched (no preempt count).
+ */
+
+static __always_inline void set_preempt_need_resched(void)
+{
+	__this_cpu_and_4(__preempt_count, ~PREEMPT_NEED_RESCHED);
+}
+
+static __always_inline void clear_preempt_need_resched(void)
+{
+	__this_cpu_or_4(__preempt_count, PREEMPT_NEED_RESCHED);
+}
+
+static __always_inline bool test_preempt_need_resched(void)
+{
+	return !(__this_cpu_read_4(__preempt_count) & PREEMPT_NEED_RESCHED);
+}
+
+/*
+ * The various preempt_count add/sub methods
+ */
+
+static __always_inline void __preempt_count_add(int val)
+{
+	__this_cpu_add_4(__preempt_count, val);
+}
+
+static __always_inline void __preempt_count_sub(int val)
+{
+	__this_cpu_add_4(__preempt_count, -val);
+}
+
+static __always_inline bool __preempt_count_dec_and_test(void)
+{
+	GEN_UNARY_RMWcc("decl", __preempt_count, __percpu_arg(0), "e");
+}
+
+/*
+ * Returns true when we need to resched and can (barring IRQ state).
+ */
+static __always_inline bool should_resched(void)
+{
+	return unlikely(!__this_cpu_read_4(__preempt_count));
+}
+
+#ifdef CONFIG_PREEMPT
+  extern asmlinkage void ___preempt_schedule(void);
+# define __preempt_schedule() asm ("call ___preempt_schedule")
+  extern asmlinkage void preempt_schedule(void);
+# ifdef CONFIG_CONTEXT_TRACKING
+    extern asmlinkage void ___preempt_schedule_context(void);
+#   define __preempt_schedule_context() asm ("call ___preempt_schedule_context")
+# endif
+#endif
+
+#endif /* __ASM_PREEMPT_H */
diff --git a/arch/x86/include/asm/rmwcc.h b/arch/x86/include/asm/rmwcc.h
new file mode 100644
index 0000000..1ff990f
--- /dev/null
+++ b/arch/x86/include/asm/rmwcc.h
@@ -0,0 +1,41 @@
+#ifndef _ASM_X86_RMWcc
+#define _ASM_X86_RMWcc
+
+#ifdef CC_HAVE_ASM_GOTO
+
+#define __GEN_RMWcc(fullop, var, cc, ...)				\
+do {									\
+	asm_volatile_goto (fullop "; j" cc " %l[cc_label]"		\
+			: : "m" (var), ## __VA_ARGS__ 			\
+			: "memory" : cc_label);				\
+	return 0;							\
+cc_label:								\
+	return 1;							\
+} while (0)
+
+#define GEN_UNARY_RMWcc(op, var, arg0, cc) 				\
+	__GEN_RMWcc(op " " arg0, var, cc)
+
+#define GEN_BINARY_RMWcc(op, var, val, arg0, cc)			\
+	__GEN_RMWcc(op " %1, " arg0, var, cc, "er" (val))
+
+#else /* !CC_HAVE_ASM_GOTO */
+
+#define __GEN_RMWcc(fullop, var, cc, ...)				\
+do {									\
+	char c;								\
+	asm volatile (fullop "; set" cc " %1"				\
+			: "+m" (var), "=qm" (c)				\
+			: __VA_ARGS__ : "memory");			\
+	return c != 0;							\
+} while (0)
+
+#define GEN_UNARY_RMWcc(op, var, arg0, cc)				\
+	__GEN_RMWcc(op " " arg0, var, cc)
+
+#define GEN_BINARY_RMWcc(op, var, val, arg0, cc)			\
+	__GEN_RMWcc(op " %2, " arg0, var, cc, "er" (val))
+
+#endif /* CC_HAVE_ASM_GOTO */
+
+#endif /* _ASM_X86_RMWcc */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 2781119..c46a46b 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -28,8 +28,7 @@ struct thread_info {
 	__u32			flags;		/* low level flags */
 	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;		/* current CPU */
-	int			preempt_count;	/* 0 => preemptable,
-						   <0 => BUG */
+	int			saved_preempt_count;
 	mm_segment_t		addr_limit;
 	struct restart_block    restart_block;
 	void __user		*sysenter_return;
@@ -49,7 +48,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.flags		= 0,			\
 	.cpu		= 0,			\
-	.preempt_count	= INIT_PREEMPT_COUNT,	\
+	.saved_preempt_count = INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index a5408b9..9b0a34e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -36,6 +36,8 @@ obj-y			+= tsc.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
 
+obj-$(CONFIG_PREEMPT)	+= preempt.o
+
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 2861082..9f6b934 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -32,7 +32,6 @@ void common(void) {
 	OFFSET(TI_flags, thread_info, flags);
 	OFFSET(TI_status, thread_info, status);
 	OFFSET(TI_addr_limit, thread_info, addr_limit);
-	OFFSET(TI_preempt_count, thread_info, preempt_count);
 
 	BLANK();
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2793d1f..5223fe6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1095,6 +1095,9 @@ DEFINE_PER_CPU(char *, irq_stack_ptr) =
 
 DEFINE_PER_CPU(unsigned int, irq_count) __visible = -1;
 
+DEFINE_PER_CPU(int, __preempt_count) = INIT_PREEMPT_COUNT;
+EXPORT_PER_CPU_SYMBOL(__preempt_count);
+
 DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
 
 /*
@@ -1169,6 +1172,8 @@ void debug_stack_reset(void)
 
 DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
+DEFINE_PER_CPU(int, __preempt_count) = INIT_PREEMPT_COUNT;
+EXPORT_PER_CPU_SYMBOL(__preempt_count);
 DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index f0dcb0c..fd1bc1b 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -362,12 +362,9 @@ END(ret_from_exception)
 #ifdef CONFIG_PREEMPT
 ENTRY(resume_kernel)
 	DISABLE_INTERRUPTS(CLBR_ANY)
-	cmpl $0,TI_preempt_count(%ebp)	# non-zero preempt_count ?
-	jnz restore_all
 need_resched:
-	movl TI_flags(%ebp), %ecx	# need_resched set ?
-	testb $_TIF_NEED_RESCHED, %cl
-	jz restore_all
+	cmpl $0,PER_CPU_VAR(__preempt_count)
+	jnz restore_all
 	testl $X86_EFLAGS_IF,PT_EFLAGS(%esp)	# interrupts off (exception path) ?
 	jz restore_all
 	call preempt_schedule_irq
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b077f4c..1a2cc64 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1103,10 +1103,8 @@ retint_signal:
 	/* Returning to kernel space. Check if we need preemption */
 	/* rcx:	 threadinfo. interrupts off. */
 ENTRY(retint_kernel)
-	cmpl $0,TI_preempt_count(%rcx)
+	cmpl $0,PER_CPU_VAR(__preempt_count)
 	jnz  retint_restore_args
-	bt  $TIF_NEED_RESCHED,TI_flags(%rcx)
-	jnc  retint_restore_args
 	bt   $9,EFLAGS-ARGOFFSET(%rsp)	/* interrupts off? */
 	jnc  retint_restore_args
 	call preempt_schedule_irq
diff --git a/arch/x86/kernel/i386_ksyms_32.c b/arch/x86/kernel/i386_ksyms_32.c
index 0fa6912..05fd74f 100644
--- a/arch/x86/kernel/i386_ksyms_32.c
+++ b/arch/x86/kernel/i386_ksyms_32.c
@@ -37,3 +37,10 @@ EXPORT_SYMBOL(strstr);
 
 EXPORT_SYMBOL(csum_partial);
 EXPORT_SYMBOL(empty_zero_page);
+
+#ifdef CONFIG_PREEMPT
+EXPORT_SYMBOL(___preempt_schedule);
+#ifdef CONFIG_CONTEXT_TRACKING
+EXPORT_SYMBOL(___preempt_schedule_context);
+#endif
+#endif
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 4186755..3fe0663 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -100,9 +100,6 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 	irqctx->tinfo.task = curctx->tinfo.task;
 	irqctx->tinfo.previous_esp = current_stack_pointer;
 
-	/* Copy the preempt_count so that the [soft]irq checks work. */
-	irqctx->tinfo.preempt_count = curctx->tinfo.preempt_count;
-
 	if (unlikely(overflow))
 		call_on_stack(print_stack_overflow, isp);
 
@@ -131,7 +128,6 @@ void irq_ctx_init(int cpu)
 					       THREAD_SIZE_ORDER));
 	memset(&irqctx->tinfo, 0, sizeof(struct thread_info));
 	irqctx->tinfo.cpu		= cpu;
-	irqctx->tinfo.preempt_count	= HARDIRQ_OFFSET;
 	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
 
 	per_cpu(hardirq_ctx, cpu) = irqctx;
diff --git a/arch/x86/kernel/preempt.S b/arch/x86/kernel/preempt.S
new file mode 100644
index 0000000..ca7f0d5
--- /dev/null
+++ b/arch/x86/kernel/preempt.S
@@ -0,0 +1,25 @@
+
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
+#include <asm/asm.h>
+#include <asm/calling.h>
+
+ENTRY(___preempt_schedule)
+	CFI_STARTPROC
+	SAVE_ALL
+	call preempt_schedule
+	RESTORE_ALL
+	ret
+	CFI_ENDPROC
+
+#ifdef CONFIG_CONTEXT_TRACKING
+
+ENTRY(___preempt_schedule_context)
+	CFI_STARTPROC
+	SAVE_ALL
+	call preempt_schedule_context
+	RESTORE_ALL
+	ret
+	CFI_ENDPROC
+
+#endif
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c83516b..3fb8d95 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -391,9 +391,9 @@ static void amd_e400_idle(void)
 		 * The switch back from broadcast mode needs to be
 		 * called with interrupts disabled.
 		 */
-		 local_irq_disable();
-		 clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
-		 local_irq_enable();
+		local_irq_disable();
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
+		local_irq_enable();
 	} else
 		default_idle();
 }
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 884f98f..c2ec1aa 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -292,6 +292,14 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		set_iopl_mask(next->iopl);
 
 	/*
+	 * If it were not for PREEMPT_ACTIVE we could guarantee that the
+	 * preempt_count of all tasks was equal here and this would not be
+	 * needed.
+	 */
+	task_thread_info(prev_p)->saved_preempt_count = this_cpu_read(__preempt_count);
+	this_cpu_write(__preempt_count, task_thread_info(next_p)->saved_preempt_count);
+
+	/*
 	 * Now maybe handle debug registers and/or IO bitmaps
 	 */
 	if (unlikely(task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW_PREV ||
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index bb1dc51..45ab4d6 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -363,6 +363,14 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	this_cpu_write(old_rsp, next->usersp);
 	this_cpu_write(current_task, next_p);
 
+	/*
+	 * If it were not for PREEMPT_ACTIVE we could guarantee that the
+	 * preempt_count of all tasks was equal here and this would not be
+	 * needed.
+	 */
+	task_thread_info(prev_p)->saved_preempt_count = this_cpu_read(__preempt_count);
+	this_cpu_write(__preempt_count, task_thread_info(next_p)->saved_preempt_count);
+
 	this_cpu_write(kernel_stack,
 		  (unsigned long)task_stack_page(next_p) +
 		  THREAD_SIZE - KERNEL_STACK_OFFSET);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 8c8093b..729aa77 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -88,7 +88,7 @@ static inline void conditional_sti(struct pt_regs *regs)
 
 static inline void preempt_conditional_sti(struct pt_regs *regs)
 {
-	inc_preempt_count();
+	preempt_count_inc();
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_enable();
 }
@@ -103,7 +103,7 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 {
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_disable();
-	dec_preempt_count();
+	preempt_count_dec();
 }
 
 static int __kprobes
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index b014d94..0406819 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -66,3 +66,10 @@ EXPORT_SYMBOL(empty_zero_page);
 #ifndef CONFIG_PARAVIRT
 EXPORT_SYMBOL(native_load_gs_index);
 #endif
+
+#ifdef CONFIG_PREEMPT
+EXPORT_SYMBOL(___preempt_schedule);
+#ifdef CONFIG_CONTEXT_TRACKING
+EXPORT_SYMBOL(___preempt_schedule_context);
+#endif
+#endif
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index 1b98264..228d6ae 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -28,3 +28,4 @@ generic-y += termios.h
 generic-y += topology.h
 generic-y += trace_clock.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index f98dd00..c7414a5 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -119,17 +119,10 @@ static struct dmi_system_id processor_power_dmi_table[] = {
  */
 static void acpi_safe_halt(void)
 {
-	current_thread_info()->status &= ~TS_POLLING;
-	/*
-	 * TS_POLLING-cleared state must be visible before we
-	 * test NEED_RESCHED:
-	 */
-	smp_mb();
-	if (!need_resched()) {
+	if (!tif_need_resched()) {
 		safe_halt();
 		local_irq_disable();
 	}
-	current_thread_info()->status |= TS_POLLING;
 }
 
 #ifdef ARCH_APICTIMER_STOPS_ON_C3
@@ -737,6 +730,11 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 	if (unlikely(!pr))
 		return -EINVAL;
 
+	if (cx->entry_method == ACPI_CSTATE_FFH) {
+		if (current_set_polling_and_test())
+			return -EINVAL;
+	}
+
 	lapic_timer_state_broadcast(pr, cx, 1);
 	acpi_idle_do_entry(cx);
 
@@ -790,18 +788,9 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	if (unlikely(!pr))
 		return -EINVAL;
 
-	if (cx->entry_method != ACPI_CSTATE_FFH) {
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we test
-		 * NEED_RESCHED:
-		 */
-		smp_mb();
-
-		if (unlikely(need_resched())) {
-			current_thread_info()->status |= TS_POLLING;
+	if (cx->entry_method == ACPI_CSTATE_FFH) {
+		if (current_set_polling_and_test())
 			return -EINVAL;
-		}
 	}
 
 	/*
@@ -819,9 +808,6 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 
 	sched_clock_idle_wakeup_event(0);
 
-	if (cx->entry_method != ACPI_CSTATE_FFH)
-		current_thread_info()->status |= TS_POLLING;
-
 	lapic_timer_state_broadcast(pr, cx, 0);
 	return index;
 }
@@ -858,18 +844,9 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		}
 	}
 
-	if (cx->entry_method != ACPI_CSTATE_FFH) {
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we test
-		 * NEED_RESCHED:
-		 */
-		smp_mb();
-
-		if (unlikely(need_resched())) {
-			current_thread_info()->status |= TS_POLLING;
+	if (cx->entry_method == ACPI_CSTATE_FFH) {
+		if (current_set_polling_and_test())
 			return -EINVAL;
-		}
 	}
 
 	acpi_unlazy_tlb(smp_processor_id());
@@ -915,9 +892,6 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 
 	sched_clock_idle_wakeup_event(0);
 
-	if (cx->entry_method != ACPI_CSTATE_FFH)
-		current_thread_info()->status |= TS_POLLING;
-
 	lapic_timer_state_broadcast(pr, cx, 0);
 	return index;
 }
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index fa6964d..f116d66 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -359,7 +359,7 @@ static int intel_idle(struct cpuidle_device *dev,
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
-	if (!need_resched()) {
+	if (!current_set_polling_and_test()) {
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
diff --git a/fs/exec.c b/fs/exec.c
index 8875dd1..2ea437e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1547,6 +1547,7 @@ static int do_execve_common(const char *filename,
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
 	acct_update_integrals(current);
+	task_numa_free(current);
 	free_bprm(bprm);
 	if (displaced)
 		put_files_struct(displaced);
diff --git a/fs/proc/array.c b/fs/proc/array.c
index cbd0f1b..1bd2077 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -183,6 +183,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	seq_printf(m,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
+		"Ngid:\t%d\n"
 		"Pid:\t%d\n"
 		"PPid:\t%d\n"
 		"TracerPid:\t%d\n"
@@ -190,6 +191,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		"Gid:\t%d\t%d\t%d\t%d\n",
 		get_task_state(p),
 		task_tgid_nr_ns(p, ns),
+		task_numa_group_id(p),
 		pid_nr_ns(pid, ns),
 		ppid, tpid,
 		from_kuid_munged(user_ns, cred->uid),
diff --git a/include/asm-generic/preempt.h b/include/asm-generic/preempt.h
new file mode 100644
index 0000000..ddf2b42
--- /dev/null
+++ b/include/asm-generic/preempt.h
@@ -0,0 +1,105 @@
+#ifndef __ASM_PREEMPT_H
+#define __ASM_PREEMPT_H
+
+#include <linux/thread_info.h>
+
+/*
+ * We mask the PREEMPT_NEED_RESCHED bit so as not to confuse all current users
+ * that think a non-zero value indicates we cannot preempt.
+ */
+static __always_inline int preempt_count(void)
+{
+	return current_thread_info()->preempt_count & ~PREEMPT_NEED_RESCHED;
+}
+
+static __always_inline int *preempt_count_ptr(void)
+{
+	return &current_thread_info()->preempt_count;
+}
+
+/*
+ * We now loose PREEMPT_NEED_RESCHED and cause an extra reschedule; however the
+ * alternative is loosing a reschedule. Better schedule too often -- also this
+ * should be a very rare operation.
+ */
+static __always_inline void preempt_count_set(int pc)
+{
+	*preempt_count_ptr() = pc;
+}
+
+/*
+ * must be macros to avoid header recursion hell
+ */
+#define task_preempt_count(p) \
+	(task_thread_info(p)->preempt_count & ~PREEMPT_NEED_RESCHED)
+
+#define init_task_preempt_count(p) do { \
+	task_thread_info(p)->preempt_count = PREEMPT_DISABLED; \
+} while (0)
+
+#define init_idle_preempt_count(p, cpu) do { \
+	task_thread_info(p)->preempt_count = PREEMPT_ENABLED; \
+} while (0)
+
+/*
+ * We fold the NEED_RESCHED bit into the preempt count such that
+ * preempt_enable() can decrement and test for needing to reschedule with a
+ * single instruction.
+ *
+ * We invert the actual bit, so that when the decrement hits 0 we know we both
+ * need to resched (the bit is cleared) and can resched (no preempt count).
+ */
+
+static __always_inline void set_preempt_need_resched(void)
+{
+	*preempt_count_ptr() &= ~PREEMPT_NEED_RESCHED;
+}
+
+static __always_inline void clear_preempt_need_resched(void)
+{
+	*preempt_count_ptr() |= PREEMPT_NEED_RESCHED;
+}
+
+static __always_inline bool test_preempt_need_resched(void)
+{
+	return !(*preempt_count_ptr() & PREEMPT_NEED_RESCHED);
+}
+
+/*
+ * The various preempt_count add/sub methods
+ */
+
+static __always_inline void __preempt_count_add(int val)
+{
+	*preempt_count_ptr() += val;
+}
+
+static __always_inline void __preempt_count_sub(int val)
+{
+	*preempt_count_ptr() -= val;
+}
+
+static __always_inline bool __preempt_count_dec_and_test(void)
+{
+	return !--*preempt_count_ptr();
+}
+
+/*
+ * Returns true when we need to resched and can (barring IRQ state).
+ */
+static __always_inline bool should_resched(void)
+{
+	return unlikely(!*preempt_count_ptr());
+}
+
+#ifdef CONFIG_PREEMPT
+extern asmlinkage void preempt_schedule(void);
+#define __preempt_schedule() preempt_schedule()
+
+#ifdef CONFIG_CONTEXT_TRACKING
+extern asmlinkage void preempt_schedule_context(void);
+#define __preempt_schedule_context() preempt_schedule_context()
+#endif
+#endif /* CONFIG_PREEMPT */
+
+#endif /* __ASM_PREEMPT_H */
diff --git a/include/linux/completion.h b/include/linux/completion.h
index 3cd574d..22c33e3 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -5,7 +5,7 @@
  * (C) Copyright 2001 Linus Torvalds
  *
  * Atomic wait-for-completion handler data structures.
- * See kernel/sched/core.c for details.
+ * See kernel/sched/completion.c for details.
  */
 
 #include <linux/wait.h>
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 1e04106..d9cf963 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -33,7 +33,7 @@ extern void rcu_nmi_exit(void);
 #define __irq_enter()					\
 	do {						\
 		account_irq_enter_time(current);	\
-		add_preempt_count(HARDIRQ_OFFSET);	\
+		preempt_count_add(HARDIRQ_OFFSET);	\
 		trace_hardirq_enter();			\
 	} while (0)
 
@@ -49,7 +49,7 @@ extern void irq_enter(void);
 	do {						\
 		trace_hardirq_exit();			\
 		account_irq_exit_time(current);		\
-		sub_preempt_count(HARDIRQ_OFFSET);	\
+		preempt_count_sub(HARDIRQ_OFFSET);	\
 	} while (0)
 
 /*
@@ -62,7 +62,7 @@ extern void irq_exit(void);
 		lockdep_off();					\
 		ftrace_nmi_enter();				\
 		BUG_ON(in_nmi());				\
-		add_preempt_count(NMI_OFFSET + HARDIRQ_OFFSET);	\
+		preempt_count_add(NMI_OFFSET + HARDIRQ_OFFSET);	\
 		rcu_nmi_enter();				\
 		trace_hardirq_enter();				\
 	} while (0)
@@ -72,7 +72,7 @@ extern void irq_exit(void);
 		trace_hardirq_exit();				\
 		rcu_nmi_exit();					\
 		BUG_ON(!in_nmi());				\
-		sub_preempt_count(NMI_OFFSET + HARDIRQ_OFFSET);	\
+		preempt_count_sub(NMI_OFFSET + HARDIRQ_OFFSET);	\
 		ftrace_nmi_exit();				\
 		lockdep_on();					\
 	} while (0)
diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index da6716b..ea4d249 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -136,6 +136,7 @@ struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 
 struct mempolicy *get_vma_policy(struct task_struct *tsk,
 		struct vm_area_struct *vma, unsigned long addr);
+bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma);
 
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 8d3c57f..f5096b5 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -90,11 +90,12 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
-extern int migrate_misplaced_page(struct page *page, int node);
-extern int migrate_misplaced_page(struct page *page, int node);
+extern int migrate_misplaced_page(struct page *page,
+				  struct vm_area_struct *vma, int node);
 extern bool migrate_ratelimited(int node);
 #else
-static inline int migrate_misplaced_page(struct page *page, int node)
+static inline int migrate_misplaced_page(struct page *page,
+					 struct vm_area_struct *vma, int node)
 {
 	return -EAGAIN; /* can't migrate now */
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8b6e55e..81443d5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -581,11 +581,11 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
  * sets it, so none of the operations on it need to be atomic.
  */
 
-/* Page flags: | [SECTION] | [NODE] | ZONE | [LAST_NID] | ... | FLAGS | */
+/* Page flags: | [SECTION] | [NODE] | ZONE | [LAST_CPUPID] | ... | FLAGS | */
 #define SECTIONS_PGOFF		((sizeof(unsigned long)*8) - SECTIONS_WIDTH)
 #define NODES_PGOFF		(SECTIONS_PGOFF - NODES_WIDTH)
 #define ZONES_PGOFF		(NODES_PGOFF - ZONES_WIDTH)
-#define LAST_NID_PGOFF		(ZONES_PGOFF - LAST_NID_WIDTH)
+#define LAST_CPUPID_PGOFF	(ZONES_PGOFF - LAST_CPUPID_WIDTH)
 
 /*
  * Define the bit shifts to access each section.  For non-existent
@@ -595,7 +595,7 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 #define SECTIONS_PGSHIFT	(SECTIONS_PGOFF * (SECTIONS_WIDTH != 0))
 #define NODES_PGSHIFT		(NODES_PGOFF * (NODES_WIDTH != 0))
 #define ZONES_PGSHIFT		(ZONES_PGOFF * (ZONES_WIDTH != 0))
-#define LAST_NID_PGSHIFT	(LAST_NID_PGOFF * (LAST_NID_WIDTH != 0))
+#define LAST_CPUPID_PGSHIFT	(LAST_CPUPID_PGOFF * (LAST_CPUPID_WIDTH != 0))
 
 /* NODE:ZONE or SECTION:ZONE is used to ID a zone for the buddy allocator */
 #ifdef NODE_NOT_IN_PAGE_FLAGS
@@ -617,7 +617,7 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 #define ZONES_MASK		((1UL << ZONES_WIDTH) - 1)
 #define NODES_MASK		((1UL << NODES_WIDTH) - 1)
 #define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
-#define LAST_NID_MASK		((1UL << LAST_NID_WIDTH) - 1)
+#define LAST_CPUPID_MASK	((1UL << LAST_CPUPID_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
 static inline enum zone_type page_zonenum(const struct page *page)
@@ -661,51 +661,117 @@ static inline int page_to_nid(const struct page *page)
 #endif
 
 #ifdef CONFIG_NUMA_BALANCING
-#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
-static inline int page_nid_xchg_last(struct page *page, int nid)
+static inline int cpu_pid_to_cpupid(int cpu, int pid)
 {
-	return xchg(&page->_last_nid, nid);
+	return ((cpu & LAST__CPU_MASK) << LAST__PID_SHIFT) | (pid & LAST__PID_MASK);
 }
 
-static inline int page_nid_last(struct page *page)
+static inline int cpupid_to_pid(int cpupid)
 {
-	return page->_last_nid;
+	return cpupid & LAST__PID_MASK;
 }
-static inline void page_nid_reset_last(struct page *page)
+
+static inline int cpupid_to_cpu(int cpupid)
 {
-	page->_last_nid = -1;
+	return (cpupid >> LAST__PID_SHIFT) & LAST__CPU_MASK;
 }
-#else
-static inline int page_nid_last(struct page *page)
+
+static inline int cpupid_to_nid(int cpupid)
 {
-	return (page->flags >> LAST_NID_PGSHIFT) & LAST_NID_MASK;
+	return cpu_to_node(cpupid_to_cpu(cpupid));
 }
 
-extern int page_nid_xchg_last(struct page *page, int nid);
+static inline bool cpupid_pid_unset(int cpupid)
+{
+	return cpupid_to_pid(cpupid) == (-1 & LAST__PID_MASK);
+}
 
-static inline void page_nid_reset_last(struct page *page)
+static inline bool cpupid_cpu_unset(int cpupid)
 {
-	int nid = (1 << LAST_NID_SHIFT) - 1;
+	return cpupid_to_cpu(cpupid) == (-1 & LAST__CPU_MASK);
+}
 
-	page->flags &= ~(LAST_NID_MASK << LAST_NID_PGSHIFT);
-	page->flags |= (nid & LAST_NID_MASK) << LAST_NID_PGSHIFT;
+static inline bool __cpupid_match_pid(pid_t task_pid, int cpupid)
+{
+	return (task_pid & LAST__PID_MASK) == cpupid_to_pid(cpupid);
+}
+
+#define cpupid_match_pid(task, cpupid) __cpupid_match_pid(task->pid, cpupid)
+#ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
+static inline int page_cpupid_xchg_last(struct page *page, int cpupid)
+{
+	return xchg(&page->_last_cpupid, cpupid);
+}
+
+static inline int page_cpupid_last(struct page *page)
+{
+	return page->_last_cpupid;
+}
+static inline void page_cpupid_reset_last(struct page *page)
+{
+	page->_last_cpupid = -1;
 }
-#endif /* LAST_NID_NOT_IN_PAGE_FLAGS */
 #else
-static inline int page_nid_xchg_last(struct page *page, int nid)
+static inline int page_cpupid_last(struct page *page)
 {
-	return page_to_nid(page);
+	return (page->flags >> LAST_CPUPID_PGSHIFT) & LAST_CPUPID_MASK;
 }
 
-static inline int page_nid_last(struct page *page)
+extern int page_cpupid_xchg_last(struct page *page, int cpupid);
+
+static inline void page_cpupid_reset_last(struct page *page)
 {
-	return page_to_nid(page);
+	int cpupid = (1 << LAST_CPUPID_SHIFT) - 1;
+
+	page->flags &= ~(LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT);
+	page->flags |= (cpupid & LAST_CPUPID_MASK) << LAST_CPUPID_PGSHIFT;
+}
+#endif /* LAST_CPUPID_NOT_IN_PAGE_FLAGS */
+#else /* !CONFIG_NUMA_BALANCING */
+static inline int page_cpupid_xchg_last(struct page *page, int cpupid)
+{
+	return page_to_nid(page); /* XXX */
 }
 
-static inline void page_nid_reset_last(struct page *page)
+static inline int page_cpupid_last(struct page *page)
 {
+	return page_to_nid(page); /* XXX */
 }
-#endif
+
+static inline int cpupid_to_nid(int cpupid)
+{
+	return -1;
+}
+
+static inline int cpupid_to_pid(int cpupid)
+{
+	return -1;
+}
+
+static inline int cpupid_to_cpu(int cpupid)
+{
+	return -1;
+}
+
+static inline int cpu_pid_to_cpupid(int nid, int pid)
+{
+	return -1;
+}
+
+static inline bool cpupid_pid_unset(int cpupid)
+{
+	return 1;
+}
+
+static inline void page_cpupid_reset_last(struct page *page)
+{
+}
+
+static inline bool cpupid_match_pid(struct task_struct *task, int cpupid)
+{
+	return false;
+}
+#endif /* CONFIG_NUMA_BALANCING */
 
 static inline struct zone *page_zone(const struct page *page)
 {
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d9851ee..a3198e5 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -174,8 +174,8 @@ struct page {
 	void *shadow;
 #endif
 
-#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
-	int _last_nid;
+#ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
+	int _last_cpupid;
 #endif
 }
 /*
@@ -420,28 +420,15 @@ struct mm_struct {
 	 */
 	unsigned long numa_next_scan;
 
-	/* numa_next_reset is when the PTE scanner period will be reset */
-	unsigned long numa_next_reset;
-
 	/* Restart point for scanning and setting pte_numa */
 	unsigned long numa_scan_offset;
 
 	/* numa_scan_seq prevents two threads setting pte_numa */
 	int numa_scan_seq;
-
-	/*
-	 * The first node a task was scheduled on. If a task runs on
-	 * a different node than Make PTE Scan Go Now.
-	 */
-	int first_nid;
 #endif
 	struct uprobes_state uprobes_state;
 };
 
-/* first nid will either be a valid NID or one of these values */
-#define NUMA_PTE_SCAN_INIT	-1
-#define NUMA_PTE_SCAN_ACTIVE	-2
-
 static inline void mm_init_cpumask(struct mm_struct *mm)
 {
 #ifdef CONFIG_CPUMASK_OFFSTACK
diff --git a/include/linux/page-flags-layout.h b/include/linux/page-flags-layout.h
index 93506a1..da52366 100644
--- a/include/linux/page-flags-layout.h
+++ b/include/linux/page-flags-layout.h
@@ -38,10 +38,10 @@
  * The last is when there is insufficient space in page->flags and a separate
  * lookup is necessary.
  *
- * No sparsemem or sparsemem vmemmap: |       NODE     | ZONE |          ... | FLAGS |
- *         " plus space for last_nid: |       NODE     | ZONE | LAST_NID ... | FLAGS |
- * classic sparse with space for node:| SECTION | NODE | ZONE |          ... | FLAGS |
- *         " plus space for last_nid: | SECTION | NODE | ZONE | LAST_NID ... | FLAGS |
+ * No sparsemem or sparsemem vmemmap: |       NODE     | ZONE |             ... | FLAGS |
+ *      " plus space for last_cpupid: |       NODE     | ZONE | LAST_CPUPID ... | FLAGS |
+ * classic sparse with space for node:| SECTION | NODE | ZONE |             ... | FLAGS |
+ *      " plus space for last_cpupid: | SECTION | NODE | ZONE | LAST_CPUPID ... | FLAGS |
  * classic sparse no space for node:  | SECTION |     ZONE    | ... | FLAGS |
  */
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
@@ -62,15 +62,21 @@
 #endif
 
 #ifdef CONFIG_NUMA_BALANCING
-#define LAST_NID_SHIFT NODES_SHIFT
+#define LAST__PID_SHIFT 8
+#define LAST__PID_MASK  ((1 << LAST__PID_SHIFT)-1)
+
+#define LAST__CPU_SHIFT NR_CPUS_BITS
+#define LAST__CPU_MASK  ((1 << LAST__CPU_SHIFT)-1)
+
+#define LAST_CPUPID_SHIFT (LAST__PID_SHIFT+LAST__CPU_SHIFT)
 #else
-#define LAST_NID_SHIFT 0
+#define LAST_CPUPID_SHIFT 0
 #endif
 
-#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT+LAST_NID_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
-#define LAST_NID_WIDTH LAST_NID_SHIFT
+#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT+LAST_CPUPID_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
+#define LAST_CPUPID_WIDTH LAST_CPUPID_SHIFT
 #else
-#define LAST_NID_WIDTH 0
+#define LAST_CPUPID_WIDTH 0
 #endif
 
 /*
@@ -81,8 +87,8 @@
 #define NODE_NOT_IN_PAGE_FLAGS
 #endif
 
-#if defined(CONFIG_NUMA_BALANCING) && LAST_NID_WIDTH == 0
-#define LAST_NID_NOT_IN_PAGE_FLAGS
+#if defined(CONFIG_NUMA_BALANCING) && LAST_CPUPID_WIDTH == 0
+#define LAST_CPUPID_NOT_IN_PAGE_FLAGS
 #endif
 
 #endif /* _LINUX_PAGE_FLAGS_LAYOUT */
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index f5d4723..a3d9dc8 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -6,106 +6,95 @@
  * preempt_count (used for kernel preemption, interrupt count, etc.)
  */
 
-#include <linux/thread_info.h>
 #include <linux/linkage.h>
 #include <linux/list.h>
 
-#if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
-  extern void add_preempt_count(int val);
-  extern void sub_preempt_count(int val);
-#else
-# define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
-# define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
-#endif
-
-#define inc_preempt_count() add_preempt_count(1)
-#define dec_preempt_count() sub_preempt_count(1)
-
-#define preempt_count()	(current_thread_info()->preempt_count)
-
-#ifdef CONFIG_PREEMPT
-
-asmlinkage void preempt_schedule(void);
-
-#define preempt_check_resched() \
-do { \
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
-		preempt_schedule(); \
-} while (0)
-
-#ifdef CONFIG_CONTEXT_TRACKING
+/*
+ * We use the MSB mostly because its available; see <linux/preempt_mask.h> for
+ * the other bits -- can't include that header due to inclusion hell.
+ */
+#define PREEMPT_NEED_RESCHED	0x80000000
 
-void preempt_schedule_context(void);
+#include <asm/preempt.h>
 
-#define preempt_check_resched_context() \
-do { \
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
-		preempt_schedule_context(); \
-} while (0)
+#if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
+extern void preempt_count_add(int val);
+extern void preempt_count_sub(int val);
+#define preempt_count_dec_and_test() ({ preempt_count_sub(1); should_resched(); })
 #else
+#define preempt_count_add(val)	__preempt_count_add(val)
+#define preempt_count_sub(val)	__preempt_count_sub(val)
+#define preempt_count_dec_and_test() __preempt_count_dec_and_test()
+#endif
 
-#define preempt_check_resched_context() preempt_check_resched()
-
-#endif /* CONFIG_CONTEXT_TRACKING */
-
-#else /* !CONFIG_PREEMPT */
-
-#define preempt_check_resched()		do { } while (0)
-#define preempt_check_resched_context()	do { } while (0)
-
-#endif /* CONFIG_PREEMPT */
+#define __preempt_count_inc() __preempt_count_add(1)
+#define __preempt_count_dec() __preempt_count_sub(1)
 
+#define preempt_count_inc() preempt_count_add(1)
+#define preempt_count_dec() preempt_count_sub(1)
 
 #ifdef CONFIG_PREEMPT_COUNT
 
 #define preempt_disable() \
 do { \
-	inc_preempt_count(); \
+	preempt_count_inc(); \
 	barrier(); \
 } while (0)
 
 #define sched_preempt_enable_no_resched() \
 do { \
 	barrier(); \
-	dec_preempt_count(); \
+	preempt_count_dec(); \
 } while (0)
 
-#define preempt_enable_no_resched()	sched_preempt_enable_no_resched()
+#define preempt_enable_no_resched() sched_preempt_enable_no_resched()
 
+#ifdef CONFIG_PREEMPT
 #define preempt_enable() \
 do { \
-	preempt_enable_no_resched(); \
 	barrier(); \
-	preempt_check_resched(); \
+	if (unlikely(preempt_count_dec_and_test())) \
+		__preempt_schedule(); \
+} while (0)
+
+#define preempt_check_resched() \
+do { \
+	if (should_resched()) \
+		__preempt_schedule(); \
 } while (0)
 
-/* For debugging and tracer internals only! */
-#define add_preempt_count_notrace(val)			\
-	do { preempt_count() += (val); } while (0)
-#define sub_preempt_count_notrace(val)			\
-	do { preempt_count() -= (val); } while (0)
-#define inc_preempt_count_notrace() add_preempt_count_notrace(1)
-#define dec_preempt_count_notrace() sub_preempt_count_notrace(1)
+#else
+#define preempt_enable() preempt_enable_no_resched()
+#define preempt_check_resched() do { } while (0)
+#endif
 
 #define preempt_disable_notrace() \
 do { \
-	inc_preempt_count_notrace(); \
+	__preempt_count_inc(); \
 	barrier(); \
 } while (0)
 
 #define preempt_enable_no_resched_notrace() \
 do { \
 	barrier(); \
-	dec_preempt_count_notrace(); \
+	__preempt_count_dec(); \
 } while (0)
 
-/* preempt_check_resched is OK to trace */
+#ifdef CONFIG_PREEMPT
+
+#ifndef CONFIG_CONTEXT_TRACKING
+#define __preempt_schedule_context() __preempt_schedule()
+#endif
+
 #define preempt_enable_notrace() \
 do { \
-	preempt_enable_no_resched_notrace(); \
 	barrier(); \
-	preempt_check_resched_context(); \
+	if (unlikely(__preempt_count_dec_and_test())) \
+		__preempt_schedule_context(); \
 } while (0)
+#else
+#define preempt_enable_notrace() preempt_enable_no_resched_notrace()
+#endif
 
 #else /* !CONFIG_PREEMPT_COUNT */
 
@@ -115,10 +104,11 @@ do { \
  * that can cause faults and scheduling migrate into our preempt-protected
  * region.
  */
-#define preempt_disable()		barrier()
+#define preempt_disable()			barrier()
 #define sched_preempt_enable_no_resched()	barrier()
-#define preempt_enable_no_resched()	barrier()
-#define preempt_enable()		barrier()
+#define preempt_enable_no_resched()		barrier()
+#define preempt_enable()			barrier()
+#define preempt_check_resched()			do { } while (0)
 
 #define preempt_disable_notrace()		barrier()
 #define preempt_enable_no_resched_notrace()	barrier()
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e27baee..045b0d2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -22,6 +22,7 @@ struct sched_param {
 #include <linux/errno.h>
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
+#include <linux/preempt.h>
 
 #include <asm/page.h>
 #include <asm/ptrace.h>
@@ -427,6 +428,14 @@ struct task_cputime {
 		.sum_exec_runtime = 0,				\
 	}
 
+#define PREEMPT_ENABLED		(PREEMPT_NEED_RESCHED)
+
+#ifdef CONFIG_PREEMPT_COUNT
+#define PREEMPT_DISABLED	(1 + PREEMPT_ENABLED)
+#else
+#define PREEMPT_DISABLED	PREEMPT_ENABLED
+#endif
+
 /*
  * Disable preemption until the scheduler is running.
  * Reset by start_kernel()->sched_init()->init_idle().
@@ -434,7 +443,7 @@ struct task_cputime {
  * We include PREEMPT_ACTIVE to avoid cond_resched() from working
  * before the scheduler is active -- see should_resched().
  */
-#define INIT_PREEMPT_COUNT	(1 + PREEMPT_ACTIVE)
+#define INIT_PREEMPT_COUNT	(PREEMPT_DISABLED + PREEMPT_ACTIVE)
 
 /**
  * struct thread_group_cputimer - thread group interval timer counts
@@ -768,6 +777,7 @@ enum cpu_idle_type {
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
+#define SD_NUMA			0x4000	/* cross-node balancing */
 
 extern int __weak arch_sd_sibiling_asym_packing(void);
 
@@ -811,6 +821,10 @@ struct sched_domain {
 
 	u64 last_update;
 
+	/* idle_balance() stats */
+	u64 max_newidle_lb_cost;
+	unsigned long next_decay_max_lb_cost;
+
 #ifdef CONFIG_SCHEDSTATS
 	/* load_balance() stats */
 	unsigned int lb_count[CPU_MAX_IDLE_TYPES];
@@ -1029,6 +1043,8 @@ struct task_struct {
 	struct task_struct *last_wakee;
 	unsigned long wakee_flips;
 	unsigned long wakee_flip_decay_ts;
+
+	int wake_cpu;
 #endif
 	int on_rq;
 
@@ -1324,10 +1340,41 @@ struct task_struct {
 #endif
 #ifdef CONFIG_NUMA_BALANCING
 	int numa_scan_seq;
-	int numa_migrate_seq;
 	unsigned int numa_scan_period;
+	unsigned int numa_scan_period_max;
+	int numa_preferred_nid;
+	int numa_migrate_deferred;
+	unsigned long numa_migrate_retry;
 	u64 node_stamp;			/* migration stamp  */
 	struct callback_head numa_work;
+
+	struct list_head numa_entry;
+	struct numa_group *numa_group;
+
+	/*
+	 * Exponential decaying average of faults on a per-node basis.
+	 * Scheduling placement decisions are made based on the these counts.
+	 * The values remain static for the duration of a PTE scan
+	 */
+	unsigned long *numa_faults;
+	unsigned long total_numa_faults;
+
+	/*
+	 * numa_faults_buffer records faults per node during the current
+	 * scan window. When the scan completes, the counts in numa_faults
+	 * decay and these values are copied.
+	 */
+	unsigned long *numa_faults_buffer;
+
+	/*
+	 * numa_faults_locality tracks if faults recorded during the last
+	 * scan window were remote/local. The task scan period is adapted
+	 * based on the locality of the faults with different weights
+	 * depending on whether they were shared or private faults
+	 */
+	unsigned long numa_faults_locality[2];
+
+	unsigned long numa_pages_migrated;
 #endif /* CONFIG_NUMA_BALANCING */
 
 	struct rcu_head rcu;
@@ -1412,16 +1459,33 @@ struct task_struct {
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
+#define TNF_MIGRATED	0x01
+#define TNF_NO_GROUP	0x02
+#define TNF_SHARED	0x04
+#define TNF_FAULT_LOCAL	0x08
+
 #ifdef CONFIG_NUMA_BALANCING
-extern void task_numa_fault(int node, int pages, bool migrated);
+extern void task_numa_fault(int last_node, int node, int pages, int flags);
+extern pid_t task_numa_group_id(struct task_struct *p);
 extern void set_numabalancing_state(bool enabled);
+extern void task_numa_free(struct task_struct *p);
+
+extern unsigned int sysctl_numa_balancing_migrate_deferred;
 #else
-static inline void task_numa_fault(int node, int pages, bool migrated)
+static inline void task_numa_fault(int last_node, int node, int pages,
+				   int flags)
 {
 }
+static inline pid_t task_numa_group_id(struct task_struct *p)
+{
+	return 0;
+}
 static inline void set_numabalancing_state(bool enabled)
 {
 }
+static inline void task_numa_free(struct task_struct *p)
+{
+}
 #endif
 
 static inline struct pid *task_pid(struct task_struct *task)
@@ -1974,7 +2038,7 @@ extern void wake_up_new_task(struct task_struct *tsk);
 #else
  static inline void kick_process(struct task_struct *tsk) { }
 #endif
-extern void sched_fork(struct task_struct *p);
+extern void sched_fork(unsigned long clone_flags, struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
 extern void proc_caches_init(void);
@@ -2401,11 +2465,6 @@ static inline int signal_pending_state(long state, struct task_struct *p)
 	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
 }
 
-static inline int need_resched(void)
-{
-	return unlikely(test_thread_flag(TIF_NEED_RESCHED));
-}
-
 /*
  * cond_resched() and cond_resched_lock(): latency reduction via
  * explicit rescheduling in places that are safe. The return
@@ -2474,36 +2533,105 @@ static inline int tsk_is_polling(struct task_struct *p)
 {
 	return task_thread_info(p)->status & TS_POLLING;
 }
-static inline void current_set_polling(void)
+static inline void __current_set_polling(void)
 {
 	current_thread_info()->status |= TS_POLLING;
 }
 
-static inline void current_clr_polling(void)
+static inline bool __must_check current_set_polling_and_test(void)
+{
+	__current_set_polling();
+
+	/*
+	 * Polling state must be visible before we test NEED_RESCHED,
+	 * paired by resched_task()
+	 */
+	smp_mb();
+
+	return unlikely(tif_need_resched());
+}
+
+static inline void __current_clr_polling(void)
 {
 	current_thread_info()->status &= ~TS_POLLING;
-	smp_mb__after_clear_bit();
+}
+
+static inline bool __must_check current_clr_polling_and_test(void)
+{
+	__current_clr_polling();
+
+	/*
+	 * Polling state must be visible before we test NEED_RESCHED,
+	 * paired by resched_task()
+	 */
+	smp_mb();
+
+	return unlikely(tif_need_resched());
 }
 #elif defined(TIF_POLLING_NRFLAG)
 static inline int tsk_is_polling(struct task_struct *p)
 {
 	return test_tsk_thread_flag(p, TIF_POLLING_NRFLAG);
 }
-static inline void current_set_polling(void)
+
+static inline void __current_set_polling(void)
 {
 	set_thread_flag(TIF_POLLING_NRFLAG);
 }
 
-static inline void current_clr_polling(void)
+static inline bool __must_check current_set_polling_and_test(void)
+{
+	__current_set_polling();
+
+	/*
+	 * Polling state must be visible before we test NEED_RESCHED,
+	 * paired by resched_task()
+	 *
+	 * XXX: assumes set/clear bit are identical barrier wise.
+	 */
+	smp_mb__after_clear_bit();
+
+	return unlikely(tif_need_resched());
+}
+
+static inline void __current_clr_polling(void)
 {
 	clear_thread_flag(TIF_POLLING_NRFLAG);
 }
+
+static inline bool __must_check current_clr_polling_and_test(void)
+{
+	__current_clr_polling();
+
+	/*
+	 * Polling state must be visible before we test NEED_RESCHED,
+	 * paired by resched_task()
+	 */
+	smp_mb__after_clear_bit();
+
+	return unlikely(tif_need_resched());
+}
+
 #else
 static inline int tsk_is_polling(struct task_struct *p) { return 0; }
-static inline void current_set_polling(void) { }
-static inline void current_clr_polling(void) { }
+static inline void __current_set_polling(void) { }
+static inline void __current_clr_polling(void) { }
+
+static inline bool __must_check current_set_polling_and_test(void)
+{
+	return unlikely(tif_need_resched());
+}
+static inline bool __must_check current_clr_polling_and_test(void)
+{
+	return unlikely(tif_need_resched());
+}
 #endif
 
+static __always_inline bool need_resched(void)
+{
+	return unlikely(tif_need_resched());
+}
+
 /*
  * Thread group CPU time accounting.
  */
@@ -2545,6 +2673,11 @@ static inline unsigned int task_cpu(const struct task_struct *p)
 	return task_thread_info(p)->cpu;
 }
 
+static inline int task_node(const struct task_struct *p)
+{
+	return cpu_to_node(task_cpu(p));
+}
+
 extern void set_task_cpu(struct task_struct *p, unsigned int cpu);
 
 #else
diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index bf8086b..10d16c4f 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -47,7 +47,6 @@ extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
 extern unsigned int sysctl_numa_balancing_scan_delay;
 extern unsigned int sysctl_numa_balancing_scan_period_min;
 extern unsigned int sysctl_numa_balancing_scan_period_max;
-extern unsigned int sysctl_numa_balancing_scan_period_reset;
 extern unsigned int sysctl_numa_balancing_scan_size;
 extern unsigned int sysctl_numa_balancing_settle_count;
 
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 3b5e910..d2abbdb 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -28,6 +28,7 @@ struct cpu_stop_work {
 };
 
 int stop_one_cpu(unsigned int cpu, cpu_stop_fn_t fn, void *arg);
+int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *arg);
 void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 			 struct cpu_stop_work *work_buf);
 int stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg);
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index e7e0473..fddbe20 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -104,8 +104,21 @@ static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
 #define test_thread_flag(flag) \
 	test_ti_thread_flag(current_thread_info(), flag)
 
-#define set_need_resched()	set_thread_flag(TIF_NEED_RESCHED)
-#define clear_need_resched()	clear_thread_flag(TIF_NEED_RESCHED)
+static inline __deprecated void set_need_resched(void)
+{
+	/*
+	 * Use of this function in deprecated.
+	 *
+	 * As of this writing there are only a few users in the DRM tree left
+	 * all of which are wrong and can be removed without causing too much
+	 * grief.
+	 *
+	 * The DRM people are aware and are working on removing the last few
+	 * instances.
+	 */
+}
+
+#define tif_need_resched() test_thread_flag(TIF_NEED_RESCHED)
 
 #if defined TIF_RESTORE_SIGMASK && !defined HAVE_SET_RESTORE_SIGMASK
 /*
diff --git a/include/linux/topology.h b/include/linux/topology.h
index d3cf0d6..12ae6ce 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -106,6 +106,8 @@ int arch_update_cpu_topology(void);
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
 	.smt_gain		= 1178,	/* 15% */			\
+	.max_newidle_lb_cost	= 0,					\
+	.next_decay_max_lb_cost	= jiffies,				\
 }
 #endif
 #endif /* CONFIG_SCHED_SMT */
@@ -135,6 +137,8 @@ int arch_update_cpu_topology(void);
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
+	.max_newidle_lb_cost	= 0,					\
+	.next_decay_max_lb_cost	= jiffies,				\
 }
 #endif
 #endif /* CONFIG_SCHED_MC */
@@ -166,6 +170,8 @@ int arch_update_cpu_topology(void);
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
+	.max_newidle_lb_cost	= 0,					\
+	.next_decay_max_lb_cost	= jiffies,				\
 }
 #endif
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 64f8646..633cac7 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -672,31 +672,17 @@ static inline void tty_wait_until_sent_from_close(struct tty_struct *tty,
 #define wait_event_interruptible_tty(tty, wq, condition)		\
 ({									\
 	int __ret = 0;							\
-	if (!(condition)) {						\
-		__wait_event_interruptible_tty(tty, wq, condition, __ret);	\
-	}								\
+	if (!(condition))						\
+		__ret = __wait_event_interruptible_tty(tty, wq,		\
+						       condition);	\
 	__ret;								\
 })
 
-#define __wait_event_interruptible_tty(tty, wq, condition, ret)		\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		if (!signal_pending(current)) {				\
-			tty_unlock(tty);					\
+#define __wait_event_interruptible_tty(tty, wq, condition)		\
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
+			tty_unlock(tty);				\
 			schedule();					\
-			tty_lock(tty);					\
-			continue;					\
-		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+			tty_lock(tty))
 
 #ifdef CONFIG_PROC_FS
 extern void proc_tty_register_driver(struct tty_driver *);
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 5ca0951..9d8cf05 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -15,7 +15,7 @@
  */
 static inline void pagefault_disable(void)
 {
-	inc_preempt_count();
+	preempt_count_inc();
 	/*
 	 * make sure to have issued the store before a pagefault
 	 * can hit.
@@ -30,11 +30,7 @@ static inline void pagefault_enable(void)
 	 * the pagefault handler again.
 	 */
 	barrier();
-	dec_preempt_count();
-	/*
-	 * make sure we do..
-	 */
-	barrier();
+	preempt_count_dec();
 	preempt_check_resched();
 }
 
diff --git a/include/linux/wait.h b/include/linux/wait.h
index a67fc16..61939ba 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -1,7 +1,8 @@
 #ifndef _LINUX_WAIT_H
 #define _LINUX_WAIT_H
-
-
+/*
+ * Linux wait queue related types and methods
+ */
 #include <linux/list.h>
 #include <linux/stddef.h>
 #include <linux/spinlock.h>
@@ -13,27 +14,27 @@ typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int flags, v
 int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *key);
 
 struct __wait_queue {
-	unsigned int flags;
+	unsigned int		flags;
 #define WQ_FLAG_EXCLUSIVE	0x01
-	void *private;
-	wait_queue_func_t func;
-	struct list_head task_list;
+	void			*private;
+	wait_queue_func_t	func;
+	struct list_head	task_list;
 };
 
 struct wait_bit_key {
-	void *flags;
-	int bit_nr;
-#define WAIT_ATOMIC_T_BIT_NR -1
+	void			*flags;
+	int			bit_nr;
+#define WAIT_ATOMIC_T_BIT_NR	-1
 };
 
 struct wait_bit_queue {
-	struct wait_bit_key key;
-	wait_queue_t wait;
+	struct wait_bit_key	key;
+	wait_queue_t		wait;
 };
 
 struct __wait_queue_head {
-	spinlock_t lock;
-	struct list_head task_list;
+	spinlock_t		lock;
+	struct list_head	task_list;
 };
 typedef struct __wait_queue_head wait_queue_head_t;
 
@@ -84,17 +85,17 @@ extern void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct
 
 static inline void init_waitqueue_entry(wait_queue_t *q, struct task_struct *p)
 {
-	q->flags = 0;
-	q->private = p;
-	q->func = default_wake_function;
+	q->flags	= 0;
+	q->private	= p;
+	q->func		= default_wake_function;
 }
 
-static inline void init_waitqueue_func_entry(wait_queue_t *q,
-					wait_queue_func_t func)
+static inline void
+init_waitqueue_func_entry(wait_queue_t *q, wait_queue_func_t func)
 {
-	q->flags = 0;
-	q->private = NULL;
-	q->func = func;
+	q->flags	= 0;
+	q->private	= NULL;
+	q->func		= func;
 }
 
 static inline int waitqueue_active(wait_queue_head_t *q)
@@ -114,8 +115,8 @@ static inline void __add_wait_queue(wait_queue_head_t *head, wait_queue_t *new)
 /*
  * Used for wake-one threads:
  */
-static inline void __add_wait_queue_exclusive(wait_queue_head_t *q,
-					      wait_queue_t *wait)
+static inline void
+__add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	__add_wait_queue(q, wait);
@@ -127,23 +128,22 @@ static inline void __add_wait_queue_tail(wait_queue_head_t *head,
 	list_add_tail(&new->task_list, &head->task_list);
 }
 
-static inline void __add_wait_queue_tail_exclusive(wait_queue_head_t *q,
-					      wait_queue_t *wait)
+static inline void
+__add_wait_queue_tail_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	__add_wait_queue_tail(q, wait);
 }
 
-static inline void __remove_wait_queue(wait_queue_head_t *head,
-							wait_queue_t *old)
+static inline void
+__remove_wait_queue(wait_queue_head_t *head, wait_queue_t *old)
 {
 	list_del(&old->task_list);
 }
 
 void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key);
-void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr,
-			void *key);
+void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_bit(wait_queue_head_t *, void *, int);
@@ -170,27 +170,64 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 /*
  * Wakeup macros to be used to report events to the targets.
  */
-#define wake_up_poll(x, m)				\
+#define wake_up_poll(x, m)						\
 	__wake_up(x, TASK_NORMAL, 1, (void *) (m))
-#define wake_up_locked_poll(x, m)				\
+#define wake_up_locked_poll(x, m)					\
 	__wake_up_locked_key((x), TASK_NORMAL, (void *) (m))
-#define wake_up_interruptible_poll(x, m)			\
+#define wake_up_interruptible_poll(x, m)				\
 	__wake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))
 #define wake_up_interruptible_sync_poll(x, m)				\
 	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
 
-#define __wait_event(wq, condition) 					\
-do {									\
-	DEFINE_WAIT(__wait);						\
+#define ___wait_cond_timeout(condition)					\
+({									\
+	bool __cond = (condition);					\
+	if (__cond && !__ret)						\
+		__ret = 1;						\
+	__cond || !__ret;						\
+})
+
+#define ___wait_is_interruptible(state)					\
+	(!__builtin_constant_p(state) ||				\
+		state == TASK_INTERRUPTIBLE || state == TASK_KILLABLE)	\
+
+#define ___wait_event(wq, condition, state, exclusive, ret, cmd)	\
+({									\
+	__label__ __out;						\
+	wait_queue_t __wait;						\
+	long __ret = ret;						\
+									\
+	INIT_LIST_HEAD(&__wait.task_list);				\
+	if (exclusive)							\
+		__wait.flags = WQ_FLAG_EXCLUSIVE;			\
+	else								\
+		__wait.flags = 0;					\
 									\
 	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		long __int = prepare_to_wait_event(&wq, &__wait, state);\
+									\
 		if (condition)						\
 			break;						\
-		schedule();						\
+									\
+		if (___wait_is_interruptible(state) && __int) {		\
+			__ret = __int;					\
+			if (exclusive) {				\
+				abort_exclusive_wait(&wq, &__wait,	\
+						     state, NULL);	\
+				goto __out;				\
+			}						\
+			break;						\
+		}							\
+									\
+		cmd;							\
 	}								\
 	finish_wait(&wq, &__wait);					\
-} while (0)
+__out:	__ret;								\
+})
+
+#define __wait_event(wq, condition)					\
+	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
+			    schedule())
 
 /**
  * wait_event - sleep until a condition gets true
@@ -204,29 +241,17 @@ do {									\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  */
-#define wait_event(wq, condition) 					\
+#define wait_event(wq, condition)					\
 do {									\
-	if (condition)	 						\
+	if (condition)							\
 		break;							\
 	__wait_event(wq, condition);					\
 } while (0)
 
-#define __wait_event_timeout(wq, condition, ret)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		ret = schedule_timeout(ret);				\
-		if (!ret)						\
-			break;						\
-	}								\
-	if (!ret && (condition))					\
-		ret = 1;						\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define __wait_event_timeout(wq, condition, timeout)			\
+	___wait_event(wq, ___wait_cond_timeout(condition),		\
+		      TASK_UNINTERRUPTIBLE, 0, timeout,			\
+		      __ret = schedule_timeout(__ret))
 
 /**
  * wait_event_timeout - sleep until a condition gets true or a timeout elapses
@@ -248,28 +273,14 @@ do {									\
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
 	long __ret = timeout;						\
-	if (!(condition)) 						\
-		__wait_event_timeout(wq, condition, __ret);		\
+	if (!___wait_cond_timeout(condition))				\
+		__ret = __wait_event_timeout(wq, condition, timeout);	\
 	__ret;								\
 })
 
-#define __wait_event_interruptible(wq, condition, ret)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		if (!signal_pending(current)) {				\
-			schedule();					\
-			continue;					\
-		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define __wait_event_interruptible(wq, condition)			\
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
+		      schedule())
 
 /**
  * wait_event_interruptible - sleep until a condition gets true
@@ -290,31 +301,14 @@ do {									\
 ({									\
 	int __ret = 0;							\
 	if (!(condition))						\
-		__wait_event_interruptible(wq, condition, __ret);	\
+		__ret = __wait_event_interruptible(wq, condition);	\
 	__ret;								\
 })
 
-#define __wait_event_interruptible_timeout(wq, condition, ret)		\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		if (!signal_pending(current)) {				\
-			ret = schedule_timeout(ret);			\
-			if (!ret)					\
-				break;					\
-			continue;					\
-		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
-	}								\
-	if (!ret && (condition))					\
-		ret = 1;						\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define __wait_event_interruptible_timeout(wq, condition, timeout)	\
+	___wait_event(wq, ___wait_cond_timeout(condition),		\
+		      TASK_INTERRUPTIBLE, 0, timeout,			\
+		      __ret = schedule_timeout(__ret))
 
 /**
  * wait_event_interruptible_timeout - sleep until a condition gets true or a timeout elapses
@@ -337,15 +331,15 @@ do {									\
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
 	long __ret = timeout;						\
-	if (!(condition))						\
-		__wait_event_interruptible_timeout(wq, condition, __ret); \
+	if (!___wait_cond_timeout(condition))				\
+		__ret = __wait_event_interruptible_timeout(wq,		\
+						condition, timeout);	\
 	__ret;								\
 })
 
 #define __wait_event_hrtimeout(wq, condition, timeout, state)		\
 ({									\
 	int __ret = 0;							\
-	DEFINE_WAIT(__wait);						\
 	struct hrtimer_sleeper __t;					\
 									\
 	hrtimer_init_on_stack(&__t.timer, CLOCK_MONOTONIC,		\
@@ -356,25 +350,15 @@ do {									\
 				       current->timer_slack_ns,		\
 				       HRTIMER_MODE_REL);		\
 									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, state);			\
-		if (condition)						\
-			break;						\
-		if (state == TASK_INTERRUPTIBLE &&			\
-		    signal_pending(current)) {				\
-			__ret = -ERESTARTSYS;				\
-			break;						\
-		}							\
+	__ret = ___wait_event(wq, condition, state, 0, 0,		\
 		if (!__t.task) {					\
 			__ret = -ETIME;					\
 			break;						\
 		}							\
-		schedule();						\
-	}								\
+		schedule());						\
 									\
 	hrtimer_cancel(&__t.timer);					\
 	destroy_hrtimer_on_stack(&__t.timer);				\
-	finish_wait(&wq, &__wait);					\
 	__ret;								\
 })
 
@@ -428,33 +412,15 @@ do {									\
 	__ret;								\
 })
 
-#define __wait_event_interruptible_exclusive(wq, condition, ret)	\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait_exclusive(&wq, &__wait,			\
-					TASK_INTERRUPTIBLE);		\
-		if (condition) {					\
-			finish_wait(&wq, &__wait);			\
-			break;						\
-		}							\
-		if (!signal_pending(current)) {				\
-			schedule();					\
-			continue;					\
-		}							\
-		ret = -ERESTARTSYS;					\
-		abort_exclusive_wait(&wq, &__wait, 			\
-				TASK_INTERRUPTIBLE, NULL);		\
-		break;							\
-	}								\
-} while (0)
+#define __wait_event_interruptible_exclusive(wq, condition)		\
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 1, 0,		\
+		      schedule())
 
 #define wait_event_interruptible_exclusive(wq, condition)		\
 ({									\
 	int __ret = 0;							\
 	if (!(condition))						\
-		__wait_event_interruptible_exclusive(wq, condition, __ret);\
+		__ret = __wait_event_interruptible_exclusive(wq, condition);\
 	__ret;								\
 })
 
@@ -606,24 +572,8 @@ do {									\
 	 ? 0 : __wait_event_interruptible_locked(wq, condition, 1, 1))
 
 
-
-#define __wait_event_killable(wq, condition, ret)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_KILLABLE);		\
-		if (condition)						\
-			break;						\
-		if (!fatal_signal_pending(current)) {			\
-			schedule();					\
-			continue;					\
-		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define __wait_event_killable(wq, condition)				\
+	___wait_event(wq, condition, TASK_KILLABLE, 0, 0, schedule())
 
 /**
  * wait_event_killable - sleep until a condition gets true
@@ -644,26 +594,17 @@ do {									\
 ({									\
 	int __ret = 0;							\
 	if (!(condition))						\
-		__wait_event_killable(wq, condition, __ret);		\
+		__ret = __wait_event_killable(wq, condition);		\
 	__ret;								\
 })
 
 
 #define __wait_event_lock_irq(wq, condition, lock, cmd)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		spin_unlock_irq(&lock);					\
-		cmd;							\
-		schedule();						\
-		spin_lock_irq(&lock);					\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
+			    spin_unlock_irq(&lock);			\
+			    cmd;					\
+			    schedule();					\
+			    spin_lock_irq(&lock))
 
 /**
  * wait_event_lock_irq_cmd - sleep until a condition gets true. The
@@ -723,26 +664,12 @@ do {									\
 } while (0)
 
 
-#define __wait_event_interruptible_lock_irq(wq, condition,		\
-					    lock, ret, cmd)		\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		if (signal_pending(current)) {				\
-			ret = -ERESTARTSYS;				\
-			break;						\
-		}							\
-		spin_unlock_irq(&lock);					\
-		cmd;							\
-		schedule();						\
-		spin_lock_irq(&lock);					\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define __wait_event_interruptible_lock_irq(wq, condition, lock, cmd)	\
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
+		      spin_unlock_irq(&lock);				\
+		      cmd;						\
+		      schedule();					\
+		      spin_lock_irq(&lock))
 
 /**
  * wait_event_interruptible_lock_irq_cmd - sleep until a condition gets true.
@@ -772,10 +699,9 @@ do {									\
 #define wait_event_interruptible_lock_irq_cmd(wq, condition, lock, cmd)	\
 ({									\
 	int __ret = 0;							\
-									\
 	if (!(condition))						\
-		__wait_event_interruptible_lock_irq(wq, condition,	\
-						    lock, __ret, cmd);	\
+		__ret = __wait_event_interruptible_lock_irq(wq,		\
+						condition, lock, cmd);	\
 	__ret;								\
 })
 
@@ -804,39 +730,24 @@ do {									\
 #define wait_event_interruptible_lock_irq(wq, condition, lock)		\
 ({									\
 	int __ret = 0;							\
-									\
 	if (!(condition))						\
-		__wait_event_interruptible_lock_irq(wq, condition,	\
-						    lock, __ret, );	\
+		__ret = __wait_event_interruptible_lock_irq(wq,		\
+						condition, lock,);	\
 	__ret;								\
 })
 
 #define __wait_event_interruptible_lock_irq_timeout(wq, condition,	\
-						    lock, ret)		\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		if (signal_pending(current)) {				\
-			ret = -ERESTARTSYS;				\
-			break;						\
-		}							\
-		spin_unlock_irq(&lock);					\
-		ret = schedule_timeout(ret);				\
-		spin_lock_irq(&lock);					\
-		if (!ret)						\
-			break;						\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+						    lock, timeout)	\
+	___wait_event(wq, ___wait_cond_timeout(condition),		\
+		      TASK_INTERRUPTIBLE, 0, timeout,			\
+		      spin_unlock_irq(&lock);				\
+		      __ret = schedule_timeout(__ret);			\
+		      spin_lock_irq(&lock));
 
 /**
- * wait_event_interruptible_lock_irq_timeout - sleep until a condition gets true or a timeout elapses.
- *		The condition is checked under the lock. This is expected
- *		to be called with the lock taken.
+ * wait_event_interruptible_lock_irq_timeout - sleep until a condition gets
+ *		true or a timeout elapses. The condition is checked under
+ *		the lock. This is expected to be called with the lock taken.
  * @wq: the waitqueue to wait on
  * @condition: a C expression for the event to wait for
  * @lock: a locked spinlock_t, which will be released before schedule()
@@ -860,11 +771,10 @@ do {									\
 #define wait_event_interruptible_lock_irq_timeout(wq, condition, lock,	\
 						  timeout)		\
 ({									\
-	int __ret = timeout;						\
-									\
-	if (!(condition))						\
-		__wait_event_interruptible_lock_irq_timeout(		\
-					wq, condition, lock, __ret);	\
+	long __ret = timeout;						\
+	if (!___wait_cond_timeout(condition))				\
+		__ret = __wait_event_interruptible_lock_irq_timeout(	\
+					wq, condition, lock, timeout);	\
 	__ret;								\
 })
 
@@ -875,20 +785,18 @@ do {									\
  * We plan to remove these interfaces.
  */
 extern void sleep_on(wait_queue_head_t *q);
-extern long sleep_on_timeout(wait_queue_head_t *q,
-				      signed long timeout);
+extern long sleep_on_timeout(wait_queue_head_t *q, signed long timeout);
 extern void interruptible_sleep_on(wait_queue_head_t *q);
-extern long interruptible_sleep_on_timeout(wait_queue_head_t *q,
-					   signed long timeout);
+extern long interruptible_sleep_on_timeout(wait_queue_head_t *q, signed long timeout);
 
 /*
  * Waitqueues which are removed from the waitqueue_head at wakeup time
  */
 void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state);
+long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);
-void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait,
-			unsigned int mode, void *key);
+void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait, unsigned int mode, void *key);
 int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 
@@ -934,8 +842,8 @@ int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
  * One uses wait_on_bit() where one is waiting for the bit to clear,
  * but has no intention of setting it.
  */
-static inline int wait_on_bit(void *word, int bit,
-				int (*action)(void *), unsigned mode)
+static inline int
+wait_on_bit(void *word, int bit, int (*action)(void *), unsigned mode)
 {
 	if (!test_bit(bit, word))
 		return 0;
@@ -958,8 +866,8 @@ static inline int wait_on_bit(void *word, int bit,
  * One uses wait_on_bit_lock() where one is waiting for the bit to
  * clear with the intention of setting it, and when done, clearing it.
  */
-static inline int wait_on_bit_lock(void *word, int bit,
-				int (*action)(void *), unsigned mode)
+static inline int
+wait_on_bit_lock(void *word, int bit, int (*action)(void *), unsigned mode)
 {
 	if (!test_and_set_bit(bit, word))
 		return 0;
@@ -983,5 +891,5 @@ int wait_on_atomic_t(atomic_t *val, int (*action)(atomic_t *), unsigned mode)
 		return 0;
 	return out_of_line_wait_on_atomic_t(val, action, mode);
 }
-	
-#endif
+
+#endif /* _LINUX_WAIT_H */
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 2e7d994..613381b 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -100,7 +100,7 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
 	/*
 	 * For all intents and purposes a preempted task is a running task.
 	 */
-	if (task_thread_info(p)->preempt_count & PREEMPT_ACTIVE)
+	if (task_preempt_count(p) & PREEMPT_ACTIVE)
 		state = TASK_RUNNING | TASK_STATE_MAX;
 #endif
 
diff --git a/init/main.c b/init/main.c
index 63d3e8f..379090f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -693,7 +693,7 @@ int __init_or_module do_one_initcall(initcall_t fn)
 
 	if (preempt_count() != count) {
 		sprintf(msgbuf, "preemption imbalance ");
-		preempt_count() = count;
+		preempt_count_set(count);
 	}
 	if (irqs_disabled()) {
 		strlcat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
diff --git a/kernel/Makefile b/kernel/Makefile
index 1ce4755..b3d51e2 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -7,7 +7,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    sysctl.o sysctl_binary.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o task_work.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
-	    kthread.o wait.o sys_ni.o posix-cpu-timers.o mutex.o \
+	    kthread.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o groups.o lglock.o smpboot.o
diff --git a/kernel/bounds.c b/kernel/bounds.c
index 0c9b862..e8ca97b 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -10,6 +10,7 @@
 #include <linux/mmzone.h>
 #include <linux/kbuild.h>
 #include <linux/page_cgroup.h>
+#include <linux/log2.h>
 
 void foo(void)
 {
@@ -17,5 +18,8 @@ void foo(void)
 	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
 	DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
 	DEFINE(NR_PCG_FLAGS, __NR_PCG_FLAGS);
+#ifdef CONFIG_SMP
+	DEFINE(NR_CPUS_BITS, ilog2(CONFIG_NR_CPUS));
+#endif
 	/* End of constants */
 }
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 859c8df..e5f3917 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -120,7 +120,7 @@ void context_tracking_user_enter(void)
  * instead of preempt_schedule() to exit user context if needed before
  * calling the scheduler.
  */
-void __sched notrace preempt_schedule_context(void)
+asmlinkage void __sched notrace preempt_schedule_context(void)
 {
 	enum ctx_state prev_ctx;
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index d7f07a2..63aa50d 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -308,6 +308,23 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	}
 	smpboot_park_threads(cpu);
 
+	/*
+	 * By now we've cleared cpu_active_mask, wait for all preempt-disabled
+	 * and RCU users of this state to go away such that all new such users
+	 * will observe it.
+	 *
+	 * For CONFIG_PREEMPT we have preemptible RCU and its sync_rcu() might
+	 * not imply sync_sched(), so explicitly call both.
+	 */
+#ifdef CONFIG_PREEMPT
+	synchronize_sched();
+#endif
+	synchronize_rcu();
+
+	/*
+	 * So now all preempt/rcu users must observe !cpu_active().
+	 */
+
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index e695c0a..988573a 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -44,7 +44,7 @@ static inline int cpu_idle_poll(void)
 	rcu_idle_enter();
 	trace_cpu_idle_rcuidle(0, smp_processor_id());
 	local_irq_enable();
-	while (!need_resched())
+	while (!tif_need_resched())
 		cpu_relax();
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 	rcu_idle_exit();
@@ -92,8 +92,7 @@ static void cpu_idle_loop(void)
 			if (cpu_idle_force_poll || tick_check_broadcast_expired()) {
 				cpu_idle_poll();
 			} else {
-				current_clr_polling();
-				if (!need_resched()) {
+				if (!current_clr_polling_and_test()) {
 					stop_critical_timings();
 					rcu_idle_enter();
 					arch_cpu_idle();
@@ -103,9 +102,16 @@ static void cpu_idle_loop(void)
 				} else {
 					local_irq_enable();
 				}
-				current_set_polling();
+				__current_set_polling();
 			}
 			arch_cpu_idle_exit();
+			/*
+			 * We need to test and propagate the TIF_NEED_RESCHED
+			 * bit here because we might not have send the
+			 * reschedule IPI to idle tasks.
+			 */
+			if (tif_need_resched())
+				set_preempt_need_resched();
 		}
 		tick_nohz_idle_exit();
 		schedule_preempt_disabled();
@@ -129,7 +135,7 @@ void cpu_startup_entry(enum cpuhp_state state)
 	 */
 	boot_init_stack_canary();
 #endif
-	current_set_polling();
+	__current_set_polling();
 	arch_cpu_idle_prepare();
 	cpu_idle_loop();
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index 086fe73..c93be06 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -817,9 +817,6 @@ struct mm_struct *dup_mm(struct task_struct *tsk)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	mm->pmd_huge_pte = NULL;
 #endif
-#ifdef CONFIG_NUMA_BALANCING
-	mm->first_nid = NUMA_PTE_SCAN_INIT;
-#endif
 	if (!mm_init(mm, tsk))
 		goto fail_nomem;
 
@@ -1313,7 +1310,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
-	sched_fork(p);
+	sched_fork(clone_flags, p);
 
 	retval = perf_event_init_task(p);
 	if (retval)
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 32618b3..1dc9f36 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -898,6 +898,12 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	force_quiescent_state(rsp);  /* Kick them all. */
 }
 
+/*
+ * This function really isn't for public consumption, but RCU is special in
+ * that context switches can allow the state machine to make progress.
+ */
+extern void resched_cpu(int cpu);
+
 static void print_cpu_stall(struct rcu_state *rsp)
 {
 	int cpu;
@@ -927,7 +933,14 @@ static void print_cpu_stall(struct rcu_state *rsp)
 				     3 * rcu_jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
-	set_need_resched();  /* kick ourselves to get things going. */
+	/*
+	 * Attempt to revive the RCU machinery by forcing a context switch.
+	 *
+	 * A context switch would normally allow the RCU state machine to make
+	 * progress and it could be we're stuck in kernel space without context
+	 * switches for an entirely unreasonable amount of time.
+	 */
+	resched_cpu(smp_processor_id());
 }
 
 static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 54adcf3..7b62140 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -12,6 +12,7 @@ CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
 endif
 
 obj-y += core.o proc.o clock.o cputime.o idle_task.o fair.o rt.o stop_task.o
+obj-y += wait.o completion.o
 obj-$(CONFIG_SMP) += cpupri.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
new file mode 100644
index 0000000..a63f4dc
--- /dev/null
+++ b/kernel/sched/completion.c
@@ -0,0 +1,299 @@
+/*
+ * Generic wait-for-completion handler;
+ *
+ * It differs from semaphores in that their default case is the opposite,
+ * wait_for_completion default blocks whereas semaphore default non-block. The
+ * interface also makes it easy to 'complete' multiple waiting threads,
+ * something which isn't entirely natural for semaphores.
+ *
+ * But more importantly, the primitive documents the usage. Semaphores would
+ * typically be used for exclusion which gives rise to priority inversion.
+ * Waiting for completion is a typically sync point, but not an exclusion point.
+ */
+
+#include <linux/sched.h>
+#include <linux/completion.h>
+
+/**
+ * complete: - signals a single thread waiting on this completion
+ * @x:  holds the state of this particular completion
+ *
+ * This will wake up a single thread waiting on this completion. Threads will be
+ * awakened in the same order in which they were queued.
+ *
+ * See also complete_all(), wait_for_completion() and related routines.
+ *
+ * It may be assumed that this function implies a write memory barrier before
+ * changing the task state if and only if any tasks are woken up.
+ */
+void complete(struct completion *x)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&x->wait.lock, flags);
+	x->done++;
+	__wake_up_locked(&x->wait, TASK_NORMAL, 1);
+	spin_unlock_irqrestore(&x->wait.lock, flags);
+}
+EXPORT_SYMBOL(complete);
+
+/**
+ * complete_all: - signals all threads waiting on this completion
+ * @x:  holds the state of this particular completion
+ *
+ * This will wake up all threads waiting on this particular completion event.
+ *
+ * It may be assumed that this function implies a write memory barrier before
+ * changing the task state if and only if any tasks are woken up.
+ */
+void complete_all(struct completion *x)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&x->wait.lock, flags);
+	x->done += UINT_MAX/2;
+	__wake_up_locked(&x->wait, TASK_NORMAL, 0);
+	spin_unlock_irqrestore(&x->wait.lock, flags);
+}
+EXPORT_SYMBOL(complete_all);
+
+static inline long __sched
+do_wait_for_common(struct completion *x,
+		   long (*action)(long), long timeout, int state)
+{
+	if (!x->done) {
+		DECLARE_WAITQUEUE(wait, current);
+
+		__add_wait_queue_tail_exclusive(&x->wait, &wait);
+		do {
+			if (signal_pending_state(state, current)) {
+				timeout = -ERESTARTSYS;
+				break;
+			}
+			__set_current_state(state);
+			spin_unlock_irq(&x->wait.lock);
+			timeout = action(timeout);
+			spin_lock_irq(&x->wait.lock);
+		} while (!x->done && timeout);
+		__remove_wait_queue(&x->wait, &wait);
+		if (!x->done)
+			return timeout;
+	}
+	x->done--;
+	return timeout ?: 1;
+}
+
+static inline long __sched
+__wait_for_common(struct completion *x,
+		  long (*action)(long), long timeout, int state)
+{
+	might_sleep();
+
+	spin_lock_irq(&x->wait.lock);
+	timeout = do_wait_for_common(x, action, timeout, state);
+	spin_unlock_irq(&x->wait.lock);
+	return timeout;
+}
+
+static long __sched
+wait_for_common(struct completion *x, long timeout, int state)
+{
+	return __wait_for_common(x, schedule_timeout, timeout, state);
+}
+
+static long __sched
+wait_for_common_io(struct completion *x, long timeout, int state)
+{
+	return __wait_for_common(x, io_schedule_timeout, timeout, state);
+}
+
+/**
+ * wait_for_completion: - waits for completion of a task
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It is NOT
+ * interruptible and there is no timeout.
+ *
+ * See also similar routines (i.e. wait_for_completion_timeout()) with timeout
+ * and interrupt capability. Also see complete().
+ */
+void __sched wait_for_completion(struct completion *x)
+{
+	wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
+}
+EXPORT_SYMBOL(wait_for_completion);
+
+/**
+ * wait_for_completion_timeout: - waits for completion of a task (w/timeout)
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits for either a completion of a specific task to be signaled or for a
+ * specified timeout to expire. The timeout is in jiffies. It is not
+ * interruptible.
+ *
+ * Return: 0 if timed out, and positive (at least 1, or number of jiffies left
+ * till timeout) if completed.
+ */
+unsigned long __sched
+wait_for_completion_timeout(struct completion *x, unsigned long timeout)
+{
+	return wait_for_common(x, timeout, TASK_UNINTERRUPTIBLE);
+}
+EXPORT_SYMBOL(wait_for_completion_timeout);
+
+/**
+ * wait_for_completion_io: - waits for completion of a task
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It is NOT
+ * interruptible and there is no timeout. The caller is accounted as waiting
+ * for IO.
+ */
+void __sched wait_for_completion_io(struct completion *x)
+{
+	wait_for_common_io(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
+}
+EXPORT_SYMBOL(wait_for_completion_io);
+
+/**
+ * wait_for_completion_io_timeout: - waits for completion of a task (w/timeout)
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits for either a completion of a specific task to be signaled or for a
+ * specified timeout to expire. The timeout is in jiffies. It is not
+ * interruptible. The caller is accounted as waiting for IO.
+ *
+ * Return: 0 if timed out, and positive (at least 1, or number of jiffies left
+ * till timeout) if completed.
+ */
+unsigned long __sched
+wait_for_completion_io_timeout(struct completion *x, unsigned long timeout)
+{
+	return wait_for_common_io(x, timeout, TASK_UNINTERRUPTIBLE);
+}
+EXPORT_SYMBOL(wait_for_completion_io_timeout);
+
+/**
+ * wait_for_completion_interruptible: - waits for completion of a task (w/intr)
+ * @x:  holds the state of this particular completion
+ *
+ * This waits for completion of a specific task to be signaled. It is
+ * interruptible.
+ *
+ * Return: -ERESTARTSYS if interrupted, 0 if completed.
+ */
+int __sched wait_for_completion_interruptible(struct completion *x)
+{
+	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_INTERRUPTIBLE);
+	if (t == -ERESTARTSYS)
+		return t;
+	return 0;
+}
+EXPORT_SYMBOL(wait_for_completion_interruptible);
+
+/**
+ * wait_for_completion_interruptible_timeout: - waits for completion (w/(to,intr))
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits for either a completion of a specific task to be signaled or for a
+ * specified timeout to expire. It is interruptible. The timeout is in jiffies.
+ *
+ * Return: -ERESTARTSYS if interrupted, 0 if timed out, positive (at least 1,
+ * or number of jiffies left till timeout) if completed.
+ */
+long __sched
+wait_for_completion_interruptible_timeout(struct completion *x,
+					  unsigned long timeout)
+{
+	return wait_for_common(x, timeout, TASK_INTERRUPTIBLE);
+}
+EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
+
+/**
+ * wait_for_completion_killable: - waits for completion of a task (killable)
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It can be
+ * interrupted by a kill signal.
+ *
+ * Return: -ERESTARTSYS if interrupted, 0 if completed.
+ */
+int __sched wait_for_completion_killable(struct completion *x)
+{
+	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_KILLABLE);
+	if (t == -ERESTARTSYS)
+		return t;
+	return 0;
+}
+EXPORT_SYMBOL(wait_for_completion_killable);
+
+/**
+ * wait_for_completion_killable_timeout: - waits for completion of a task (w/(to,killable))
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits for either a completion of a specific task to be
+ * signaled or for a specified timeout to expire. It can be
+ * interrupted by a kill signal. The timeout is in jiffies.
+ *
+ * Return: -ERESTARTSYS if interrupted, 0 if timed out, positive (at least 1,
+ * or number of jiffies left till timeout) if completed.
+ */
+long __sched
+wait_for_completion_killable_timeout(struct completion *x,
+				     unsigned long timeout)
+{
+	return wait_for_common(x, timeout, TASK_KILLABLE);
+}
+EXPORT_SYMBOL(wait_for_completion_killable_timeout);
+
+/**
+ *	try_wait_for_completion - try to decrement a completion without blocking
+ *	@x:	completion structure
+ *
+ *	Return: 0 if a decrement cannot be done without blocking
+ *		 1 if a decrement succeeded.
+ *
+ *	If a completion is being used as a counting completion,
+ *	attempt to decrement the counter without blocking. This
+ *	enables us to avoid waiting if the resource the completion
+ *	is protecting is not available.
+ */
+bool try_wait_for_completion(struct completion *x)
+{
+	unsigned long flags;
+	int ret = 1;
+
+	spin_lock_irqsave(&x->wait.lock, flags);
+	if (!x->done)
+		ret = 0;
+	else
+		x->done--;
+	spin_unlock_irqrestore(&x->wait.lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(try_wait_for_completion);
+
+/**
+ *	completion_done - Test to see if a completion has any waiters
+ *	@x:	completion structure
+ *
+ *	Return: 0 if there are waiters (wait_for_completion() in progress)
+ *		 1 if there are no waiters.
+ *
+ */
+bool completion_done(struct completion *x)
+{
+	unsigned long flags;
+	int ret = 1;
+
+	spin_lock_irqsave(&x->wait.lock, flags);
+	if (!x->done)
+		ret = 0;
+	spin_unlock_irqrestore(&x->wait.lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(completion_done);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5ac63c9..1deccd7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -513,12 +513,11 @@ static inline void init_hrtick(void)
  * might also involve a cross-CPU call to trigger the scheduler on
  * the target CPU.
  */
-#ifdef CONFIG_SMP
 void resched_task(struct task_struct *p)
 {
 	int cpu;
 
-	assert_raw_spin_locked(&task_rq(p)->lock);
+	lockdep_assert_held(&task_rq(p)->lock);
 
 	if (test_tsk_need_resched(p))
 		return;
@@ -526,8 +525,10 @@ void resched_task(struct task_struct *p)
 	set_tsk_need_resched(p);
 
 	cpu = task_cpu(p);
-	if (cpu == smp_processor_id())
+	if (cpu == smp_processor_id()) {
+		set_preempt_need_resched();
 		return;
+	}
 
 	/* NEED_RESCHED must be visible before we test polling */
 	smp_mb();
@@ -546,6 +547,7 @@ void resched_cpu(int cpu)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
+#ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ_COMMON
 /*
  * In the semi idle case, use the nearest busy cpu for migrating timers
@@ -693,12 +695,6 @@ void sched_avg_update(struct rq *rq)
 	}
 }
 
-#else /* !CONFIG_SMP */
-void resched_task(struct task_struct *p)
-{
-	assert_raw_spin_locked(&task_rq(p)->lock);
-	set_tsk_need_resched(p);
-}
 #endif /* CONFIG_SMP */
 
 #if defined(CONFIG_RT_GROUP_SCHED) || (defined(CONFIG_FAIR_GROUP_SCHED) && \
@@ -767,14 +763,14 @@ static void set_load_weight(struct task_struct *p)
 static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	update_rq_clock(rq);
-	sched_info_queued(p);
+	sched_info_queued(rq, p);
 	p->sched_class->enqueue_task(rq, p, flags);
 }
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	update_rq_clock(rq);
-	sched_info_dequeued(p);
+	sched_info_dequeued(rq, p);
 	p->sched_class->dequeue_task(rq, p, flags);
 }
 
@@ -987,7 +983,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	 * ttwu() will sort out the placement.
 	 */
 	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
-			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
+			!(task_preempt_count(p) & PREEMPT_ACTIVE));
 
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -1017,6 +1013,107 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	__set_task_cpu(p, new_cpu);
 }
 
+static void __migrate_swap_task(struct task_struct *p, int cpu)
+{
+	if (p->on_rq) {
+		struct rq *src_rq, *dst_rq;
+
+		src_rq = task_rq(p);
+		dst_rq = cpu_rq(cpu);
+
+		deactivate_task(src_rq, p, 0);
+		set_task_cpu(p, cpu);
+		activate_task(dst_rq, p, 0);
+		check_preempt_curr(dst_rq, p, 0);
+	} else {
+		/*
+		 * Task isn't running anymore; make it appear like we migrated
+		 * it before it went to sleep. This means on wakeup we make the
+		 * previous cpu our targer instead of where it really is.
+		 */
+		p->wake_cpu = cpu;
+	}
+}
+
+struct migration_swap_arg {
+	struct task_struct *src_task, *dst_task;
+	int src_cpu, dst_cpu;
+};
+
+static int migrate_swap_stop(void *data)
+{
+	struct migration_swap_arg *arg = data;
+	struct rq *src_rq, *dst_rq;
+	int ret = -EAGAIN;
+
+	src_rq = cpu_rq(arg->src_cpu);
+	dst_rq = cpu_rq(arg->dst_cpu);
+
+	double_raw_lock(&arg->src_task->pi_lock,
+			&arg->dst_task->pi_lock);
+	double_rq_lock(src_rq, dst_rq);
+	if (task_cpu(arg->dst_task) != arg->dst_cpu)
+		goto unlock;
+
+	if (task_cpu(arg->src_task) != arg->src_cpu)
+		goto unlock;
+
+	if (!cpumask_test_cpu(arg->dst_cpu, tsk_cpus_allowed(arg->src_task)))
+		goto unlock;
+
+	if (!cpumask_test_cpu(arg->src_cpu, tsk_cpus_allowed(arg->dst_task)))
+		goto unlock;
+
+	__migrate_swap_task(arg->src_task, arg->dst_cpu);
+	__migrate_swap_task(arg->dst_task, arg->src_cpu);
+
+	ret = 0;
+
+unlock:
+	double_rq_unlock(src_rq, dst_rq);
+	raw_spin_unlock(&arg->dst_task->pi_lock);
+	raw_spin_unlock(&arg->src_task->pi_lock);
+
+	return ret;
+}
+
+/*
+ * Cross migrate two tasks
+ */
+int migrate_swap(struct task_struct *cur, struct task_struct *p)
+{
+	struct migration_swap_arg arg;
+	int ret = -EINVAL;
+
+	arg = (struct migration_swap_arg){
+		.src_task = cur,
+		.src_cpu = task_cpu(cur),
+		.dst_task = p,
+		.dst_cpu = task_cpu(p),
+	};
+
+	if (arg.src_cpu == arg.dst_cpu)
+		goto out;
+
+	/*
+	 * These three tests are all lockless; this is OK since all of them
+	 * will be re-checked with proper locks held further down the line.
+	 */
+	if (!cpu_active(arg.src_cpu) || !cpu_active(arg.dst_cpu))
+		goto out;
+
+	if (!cpumask_test_cpu(arg.dst_cpu, tsk_cpus_allowed(arg.src_task)))
+		goto out;
+
+	if (!cpumask_test_cpu(arg.src_cpu, tsk_cpus_allowed(arg.dst_task)))
+		goto out;
+
+	ret = stop_two_cpus(arg.dst_cpu, arg.src_cpu, migrate_swap_stop, &arg);
+
+out:
+	return ret;
+}
+
 struct migration_arg {
 	struct task_struct *task;
 	int dest_cpu;
@@ -1236,9 +1333,9 @@ out:
  * The caller (fork, wakeup) owns p->pi_lock, ->cpus_allowed is stable.
  */
 static inline
-int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
+int select_task_rq(struct task_struct *p, int cpu, int sd_flags, int wake_flags)
 {
-	int cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);
+	cpu = p->sched_class->select_task_rq(p, cpu, sd_flags, wake_flags);
 
 	/*
 	 * In order not to call set_task_cpu() on a blocking task we need
@@ -1330,12 +1427,13 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 
 	if (rq->idle_stamp) {
 		u64 delta = rq_clock(rq) - rq->idle_stamp;
-		u64 max = 2*sysctl_sched_migration_cost;
+		u64 max = 2*rq->max_idle_balance_cost;
+
+		update_avg(&rq->avg_idle, delta);
 
-		if (delta > max)
+		if (rq->avg_idle > max)
 			rq->avg_idle = max;
-		else
-			update_avg(&rq->avg_idle, delta);
+
 		rq->idle_stamp = 0;
 	}
 #endif
@@ -1396,6 +1494,14 @@ static void sched_ttwu_pending(void)
 
 void scheduler_ipi(void)
 {
+	/*
+	 * Fold TIF_NEED_RESCHED into the preempt_count; anybody setting
+	 * TIF_NEED_RESCHED remotely (for the first time) will also send
+	 * this IPI.
+	 */
+	if (tif_need_resched())
+		set_preempt_need_resched();
+
 	if (llist_empty(&this_rq()->wake_list)
 			&& !tick_nohz_full_cpu(smp_processor_id())
 			&& !got_nohz_idle_kick())
@@ -1513,7 +1619,7 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	if (p->sched_class->task_waking)
 		p->sched_class->task_waking(p);
 
-	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+	cpu = select_task_rq(p, p->wake_cpu, SD_BALANCE_WAKE, wake_flags);
 	if (task_cpu(p) != cpu) {
 		wake_flags |= WF_MIGRATED;
 		set_task_cpu(p, cpu);
@@ -1595,7 +1701,7 @@ int wake_up_state(struct task_struct *p, unsigned int state)
  *
  * __sched_fork() is basic setup used by init_idle() too:
  */
-static void __sched_fork(struct task_struct *p)
+static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 {
 	p->on_rq			= 0;
 
@@ -1619,16 +1725,24 @@ static void __sched_fork(struct task_struct *p)
 
 #ifdef CONFIG_NUMA_BALANCING
 	if (p->mm && atomic_read(&p->mm->mm_users) == 1) {
-		p->mm->numa_next_scan = jiffies;
-		p->mm->numa_next_reset = jiffies;
+		p->mm->numa_next_scan = jiffies + msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
 		p->mm->numa_scan_seq = 0;
 	}
 
+	if (clone_flags & CLONE_VM)
+		p->numa_preferred_nid = current->numa_preferred_nid;
+	else
+		p->numa_preferred_nid = -1;
+
 	p->node_stamp = 0ULL;
 	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
-	p->numa_migrate_seq = p->mm ? p->mm->numa_scan_seq - 1 : 0;
 	p->numa_scan_period = sysctl_numa_balancing_scan_delay;
 	p->numa_work.next = &p->numa_work;
+	p->numa_faults = NULL;
+	p->numa_faults_buffer = NULL;
+
+	INIT_LIST_HEAD(&p->numa_entry);
+	p->numa_group = NULL;
 #endif /* CONFIG_NUMA_BALANCING */
 }
 
@@ -1654,12 +1768,12 @@ void set_numabalancing_state(bool enabled)
 /*
  * fork()/clone()-time setup:
  */
-void sched_fork(struct task_struct *p)
+void sched_fork(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long flags;
 	int cpu = get_cpu();
 
-	__sched_fork(p);
+	__sched_fork(clone_flags, p);
 	/*
 	 * We mark the process as running here. This guarantees that
 	 * nobody will actually run it, and a signal or other external
@@ -1717,10 +1831,7 @@ void sched_fork(struct task_struct *p)
 #if defined(CONFIG_SMP)
 	p->on_cpu = 0;
 #endif
-#ifdef CONFIG_PREEMPT_COUNT
-	/* Want to start with kernel preemption disabled. */
-	task_thread_info(p)->preempt_count = 1;
-#endif
+	init_task_preempt_count(p);
 #ifdef CONFIG_SMP
 	plist_node_init(&p->pushable_tasks, MAX_PRIO);
 #endif
@@ -1747,7 +1858,7 @@ void wake_up_new_task(struct task_struct *p)
 	 *  - cpus_allowed can change in the fork path
 	 *  - any previously selected cpu might disappear through hotplug
 	 */
-	set_task_cpu(p, select_task_rq(p, SD_BALANCE_FORK, 0));
+	set_task_cpu(p, select_task_rq(p, task_cpu(p), SD_BALANCE_FORK, 0));
 #endif
 
 	/* Initialize new task's runnable average */
@@ -1838,7 +1949,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
 	trace_sched_switch(prev, next);
-	sched_info_switch(prev, next);
+	sched_info_switch(rq, prev, next);
 	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
@@ -1890,6 +2001,8 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
+		task_numa_free(prev);
+
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
@@ -2073,7 +2186,7 @@ void sched_exec(void)
 	int dest_cpu;
 
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
+	dest_cpu = p->sched_class->select_task_rq(p, task_cpu(p), SD_BALANCE_EXEC, 0);
 	if (dest_cpu == smp_processor_id())
 		goto unlock;
 
@@ -2215,7 +2328,7 @@ notrace unsigned long get_parent_ip(unsigned long addr)
 #if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
 				defined(CONFIG_PREEMPT_TRACER))
 
-void __kprobes add_preempt_count(int val)
+void __kprobes preempt_count_add(int val)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
@@ -2224,7 +2337,7 @@ void __kprobes add_preempt_count(int val)
 	if (DEBUG_LOCKS_WARN_ON((preempt_count() < 0)))
 		return;
 #endif
-	preempt_count() += val;
+	__preempt_count_add(val);
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Spinlock count overflowing soon?
@@ -2235,9 +2348,9 @@ void __kprobes add_preempt_count(int val)
 	if (preempt_count() == val)
 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 }
-EXPORT_SYMBOL(add_preempt_count);
+EXPORT_SYMBOL(preempt_count_add);
 
-void __kprobes sub_preempt_count(int val)
+void __kprobes preempt_count_sub(int val)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
@@ -2255,9 +2368,9 @@ void __kprobes sub_preempt_count(int val)
 
 	if (preempt_count() == val)
 		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
-	preempt_count() -= val;
+	__preempt_count_sub(val);
 }
-EXPORT_SYMBOL(sub_preempt_count);
+EXPORT_SYMBOL(preempt_count_sub);
 
 #endif
 
@@ -2430,6 +2543,7 @@ need_resched:
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
 	clear_tsk_need_resched(prev);
+	clear_preempt_need_resched();
 	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
@@ -2520,9 +2634,9 @@ asmlinkage void __sched notrace preempt_schedule(void)
 		return;
 
 	do {
-		add_preempt_count_notrace(PREEMPT_ACTIVE);
+		__preempt_count_add(PREEMPT_ACTIVE);
 		__schedule();
-		sub_preempt_count_notrace(PREEMPT_ACTIVE);
+		__preempt_count_sub(PREEMPT_ACTIVE);
 
 		/*
 		 * Check again in case we missed a preemption opportunity
@@ -2541,20 +2655,19 @@ EXPORT_SYMBOL(preempt_schedule);
  */
 asmlinkage void __sched preempt_schedule_irq(void)
 {
-	struct thread_info *ti = current_thread_info();
 	enum ctx_state prev_state;
 
 	/* Catch callers which need to be fixed */
-	BUG_ON(ti->preempt_count || !irqs_disabled());
+	BUG_ON(preempt_count() || !irqs_disabled());
 
 	prev_state = exception_enter();
 
 	do {
-		add_preempt_count(PREEMPT_ACTIVE);
+		__preempt_count_add(PREEMPT_ACTIVE);
 		local_irq_enable();
 		__schedule();
 		local_irq_disable();
-		sub_preempt_count(PREEMPT_ACTIVE);
+		__preempt_count_sub(PREEMPT_ACTIVE);
 
 		/*
 		 * Check again in case we missed a preemption opportunity
@@ -2575,393 +2688,6 @@ int default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,
 }
 EXPORT_SYMBOL(default_wake_function);
 
-/*
- * The core wakeup function. Non-exclusive wakeups (nr_exclusive == 0) just
- * wake everything up. If it's an exclusive wakeup (nr_exclusive == small +ve
- * number) then we wake all the non-exclusive tasks and one exclusive task.
- *
- * There are circumstances in which we can try to wake a task which has already
- * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
- * zero in this (rare) case, and we handle it by continuing to scan the queue.
- */
-static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
-			int nr_exclusive, int wake_flags, void *key)
-{
-	wait_queue_t *curr, *next;
-
-	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
-		unsigned flags = curr->flags;
-
-		if (curr->func(curr, mode, wake_flags, key) &&
-				(flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
-			break;
-	}
-}
-
-/**
- * __wake_up - wake up threads blocked on a waitqueue.
- * @q: the waitqueue
- * @mode: which threads
- * @nr_exclusive: how many wake-one or wake-many threads to wake up
- * @key: is directly passed to the wakeup function
- *
- * It may be assumed that this function implies a write memory barrier before
- * changing the task state if and only if any tasks are woken up.
- */
-void __wake_up(wait_queue_head_t *q, unsigned int mode,
-			int nr_exclusive, void *key)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_common(q, mode, nr_exclusive, 0, key);
-	spin_unlock_irqrestore(&q->lock, flags);
-}
-EXPORT_SYMBOL(__wake_up);
-
-/*
- * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
- */
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr)
-{
-	__wake_up_common(q, mode, nr, 0, NULL);
-}
-EXPORT_SYMBOL_GPL(__wake_up_locked);
-
-void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
-{
-	__wake_up_common(q, mode, 1, 0, key);
-}
-EXPORT_SYMBOL_GPL(__wake_up_locked_key);
-
-/**
- * __wake_up_sync_key - wake up threads blocked on a waitqueue.
- * @q: the waitqueue
- * @mode: which threads
- * @nr_exclusive: how many wake-one or wake-many threads to wake up
- * @key: opaque value to be passed to wakeup targets
- *
- * The sync wakeup differs that the waker knows that it will schedule
- * away soon, so while the target thread will be woken up, it will not
- * be migrated to another CPU - ie. the two threads are 'synchronized'
- * with each other. This can prevent needless bouncing between CPUs.
- *
- * On UP it can prevent extra preemption.
- *
- * It may be assumed that this function implies a write memory barrier before
- * changing the task state if and only if any tasks are woken up.
- */
-void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
-			int nr_exclusive, void *key)
-{
-	unsigned long flags;
-	int wake_flags = WF_SYNC;
-
-	if (unlikely(!q))
-		return;
-
-	if (unlikely(nr_exclusive != 1))
-		wake_flags = 0;
-
-	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_common(q, mode, nr_exclusive, wake_flags, key);
-	spin_unlock_irqrestore(&q->lock, flags);
-}
-EXPORT_SYMBOL_GPL(__wake_up_sync_key);
-
-/*
- * __wake_up_sync - see __wake_up_sync_key()
- */
-void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
-{
-	__wake_up_sync_key(q, mode, nr_exclusive, NULL);
-}
-EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
-
-/**
- * complete: - signals a single thread waiting on this completion
- * @x:  holds the state of this particular completion
- *
- * This will wake up a single thread waiting on this completion. Threads will be
- * awakened in the same order in which they were queued.
- *
- * See also complete_all(), wait_for_completion() and related routines.
- *
- * It may be assumed that this function implies a write memory barrier before
- * changing the task state if and only if any tasks are woken up.
- */
-void complete(struct completion *x)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&x->wait.lock, flags);
-	x->done++;
-	__wake_up_common(&x->wait, TASK_NORMAL, 1, 0, NULL);
-	spin_unlock_irqrestore(&x->wait.lock, flags);
-}
-EXPORT_SYMBOL(complete);
-
-/**
- * complete_all: - signals all threads waiting on this completion
- * @x:  holds the state of this particular completion
- *
- * This will wake up all threads waiting on this particular completion event.
- *
- * It may be assumed that this function implies a write memory barrier before
- * changing the task state if and only if any tasks are woken up.
- */
-void complete_all(struct completion *x)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&x->wait.lock, flags);
-	x->done += UINT_MAX/2;
-	__wake_up_common(&x->wait, TASK_NORMAL, 0, 0, NULL);
-	spin_unlock_irqrestore(&x->wait.lock, flags);
-}
-EXPORT_SYMBOL(complete_all);
-
-static inline long __sched
-do_wait_for_common(struct completion *x,
-		   long (*action)(long), long timeout, int state)
-{
-	if (!x->done) {
-		DECLARE_WAITQUEUE(wait, current);
-
-		__add_wait_queue_tail_exclusive(&x->wait, &wait);
-		do {
-			if (signal_pending_state(state, current)) {
-				timeout = -ERESTARTSYS;
-				break;
-			}
-			__set_current_state(state);
-			spin_unlock_irq(&x->wait.lock);
-			timeout = action(timeout);
-			spin_lock_irq(&x->wait.lock);
-		} while (!x->done && timeout);
-		__remove_wait_queue(&x->wait, &wait);
-		if (!x->done)
-			return timeout;
-	}
-	x->done--;
-	return timeout ?: 1;
-}
-
-static inline long __sched
-__wait_for_common(struct completion *x,
-		  long (*action)(long), long timeout, int state)
-{
-	might_sleep();
-
-	spin_lock_irq(&x->wait.lock);
-	timeout = do_wait_for_common(x, action, timeout, state);
-	spin_unlock_irq(&x->wait.lock);
-	return timeout;
-}
-
-static long __sched
-wait_for_common(struct completion *x, long timeout, int state)
-{
-	return __wait_for_common(x, schedule_timeout, timeout, state);
-}
-
-static long __sched
-wait_for_common_io(struct completion *x, long timeout, int state)
-{
-	return __wait_for_common(x, io_schedule_timeout, timeout, state);
-}
-
-/**
- * wait_for_completion: - waits for completion of a task
- * @x:  holds the state of this particular completion
- *
- * This waits to be signaled for completion of a specific task. It is NOT
- * interruptible and there is no timeout.
- *
- * See also similar routines (i.e. wait_for_completion_timeout()) with timeout
- * and interrupt capability. Also see complete().
- */
-void __sched wait_for_completion(struct completion *x)
-{
-	wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
-}
-EXPORT_SYMBOL(wait_for_completion);
-
-/**
- * wait_for_completion_timeout: - waits for completion of a task (w/timeout)
- * @x:  holds the state of this particular completion
- * @timeout:  timeout value in jiffies
- *
- * This waits for either a completion of a specific task to be signaled or for a
- * specified timeout to expire. The timeout is in jiffies. It is not
- * interruptible.
- *
- * Return: 0 if timed out, and positive (at least 1, or number of jiffies left
- * till timeout) if completed.
- */
-unsigned long __sched
-wait_for_completion_timeout(struct completion *x, unsigned long timeout)
-{
-	return wait_for_common(x, timeout, TASK_UNINTERRUPTIBLE);
-}
-EXPORT_SYMBOL(wait_for_completion_timeout);
-
-/**
- * wait_for_completion_io: - waits for completion of a task
- * @x:  holds the state of this particular completion
- *
- * This waits to be signaled for completion of a specific task. It is NOT
- * interruptible and there is no timeout. The caller is accounted as waiting
- * for IO.
- */
-void __sched wait_for_completion_io(struct completion *x)
-{
-	wait_for_common_io(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
-}
-EXPORT_SYMBOL(wait_for_completion_io);
-
-/**
- * wait_for_completion_io_timeout: - waits for completion of a task (w/timeout)
- * @x:  holds the state of this particular completion
- * @timeout:  timeout value in jiffies
- *
- * This waits for either a completion of a specific task to be signaled or for a
- * specified timeout to expire. The timeout is in jiffies. It is not
- * interruptible. The caller is accounted as waiting for IO.
- *
- * Return: 0 if timed out, and positive (at least 1, or number of jiffies left
- * till timeout) if completed.
- */
-unsigned long __sched
-wait_for_completion_io_timeout(struct completion *x, unsigned long timeout)
-{
-	return wait_for_common_io(x, timeout, TASK_UNINTERRUPTIBLE);
-}
-EXPORT_SYMBOL(wait_for_completion_io_timeout);
-
-/**
- * wait_for_completion_interruptible: - waits for completion of a task (w/intr)
- * @x:  holds the state of this particular completion
- *
- * This waits for completion of a specific task to be signaled. It is
- * interruptible.
- *
- * Return: -ERESTARTSYS if interrupted, 0 if completed.
- */
-int __sched wait_for_completion_interruptible(struct completion *x)
-{
-	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_INTERRUPTIBLE);
-	if (t == -ERESTARTSYS)
-		return t;
-	return 0;
-}
-EXPORT_SYMBOL(wait_for_completion_interruptible);
-
-/**
- * wait_for_completion_interruptible_timeout: - waits for completion (w/(to,intr))
- * @x:  holds the state of this particular completion
- * @timeout:  timeout value in jiffies
- *
- * This waits for either a completion of a specific task to be signaled or for a
- * specified timeout to expire. It is interruptible. The timeout is in jiffies.
- *
- * Return: -ERESTARTSYS if interrupted, 0 if timed out, positive (at least 1,
- * or number of jiffies left till timeout) if completed.
- */
-long __sched
-wait_for_completion_interruptible_timeout(struct completion *x,
-					  unsigned long timeout)
-{
-	return wait_for_common(x, timeout, TASK_INTERRUPTIBLE);
-}
-EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
-
-/**
- * wait_for_completion_killable: - waits for completion of a task (killable)
- * @x:  holds the state of this particular completion
- *
- * This waits to be signaled for completion of a specific task. It can be
- * interrupted by a kill signal.
- *
- * Return: -ERESTARTSYS if interrupted, 0 if completed.
- */
-int __sched wait_for_completion_killable(struct completion *x)
-{
-	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_KILLABLE);
-	if (t == -ERESTARTSYS)
-		return t;
-	return 0;
-}
-EXPORT_SYMBOL(wait_for_completion_killable);
-
-/**
- * wait_for_completion_killable_timeout: - waits for completion of a task (w/(to,killable))
- * @x:  holds the state of this particular completion
- * @timeout:  timeout value in jiffies
- *
- * This waits for either a completion of a specific task to be
- * signaled or for a specified timeout to expire. It can be
- * interrupted by a kill signal. The timeout is in jiffies.
- *
- * Return: -ERESTARTSYS if interrupted, 0 if timed out, positive (at least 1,
- * or number of jiffies left till timeout) if completed.
- */
-long __sched
-wait_for_completion_killable_timeout(struct completion *x,
-				     unsigned long timeout)
-{
-	return wait_for_common(x, timeout, TASK_KILLABLE);
-}
-EXPORT_SYMBOL(wait_for_completion_killable_timeout);
-
-/**
- *	try_wait_for_completion - try to decrement a completion without blocking
- *	@x:	completion structure
- *
- *	Return: 0 if a decrement cannot be done without blocking
- *		 1 if a decrement succeeded.
- *
- *	If a completion is being used as a counting completion,
- *	attempt to decrement the counter without blocking. This
- *	enables us to avoid waiting if the resource the completion
- *	is protecting is not available.
- */
-bool try_wait_for_completion(struct completion *x)
-{
-	unsigned long flags;
-	int ret = 1;
-
-	spin_lock_irqsave(&x->wait.lock, flags);
-	if (!x->done)
-		ret = 0;
-	else
-		x->done--;
-	spin_unlock_irqrestore(&x->wait.lock, flags);
-	return ret;
-}
-EXPORT_SYMBOL(try_wait_for_completion);
-
-/**
- *	completion_done - Test to see if a completion has any waiters
- *	@x:	completion structure
- *
- *	Return: 0 if there are waiters (wait_for_completion() in progress)
- *		 1 if there are no waiters.
- *
- */
-bool completion_done(struct completion *x)
-{
-	unsigned long flags;
-	int ret = 1;
-
-	spin_lock_irqsave(&x->wait.lock, flags);
-	if (!x->done)
-		ret = 0;
-	spin_unlock_irqrestore(&x->wait.lock, flags);
-	return ret;
-}
-EXPORT_SYMBOL(completion_done);
-
 static long __sched
 sleep_on_common(wait_queue_head_t *q, int state, long timeout)
 {
@@ -3598,13 +3324,11 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	struct task_struct *p;
 	int retval;
 
-	get_online_cpus();
 	rcu_read_lock();
 
 	p = find_process_by_pid(pid);
 	if (!p) {
 		rcu_read_unlock();
-		put_online_cpus();
 		return -ESRCH;
 	}
 
@@ -3661,7 +3385,6 @@ out_free_cpus_allowed:
 	free_cpumask_var(cpus_allowed);
 out_put_task:
 	put_task_struct(p);
-	put_online_cpus();
 	return retval;
 }
 
@@ -3706,7 +3429,6 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
 	unsigned long flags;
 	int retval;
 
-	get_online_cpus();
 	rcu_read_lock();
 
 	retval = -ESRCH;
@@ -3719,12 +3441,11 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
 		goto out_unlock;
 
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	cpumask_and(mask, &p->cpus_allowed, cpu_online_mask);
+	cpumask_and(mask, &p->cpus_allowed, cpu_active_mask);
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
 out_unlock:
 	rcu_read_unlock();
-	put_online_cpus();
 
 	return retval;
 }
@@ -3794,16 +3515,11 @@ SYSCALL_DEFINE0(sched_yield)
 	return 0;
 }
 
-static inline int should_resched(void)
-{
-	return need_resched() && !(preempt_count() & PREEMPT_ACTIVE);
-}
-
 static void __cond_resched(void)
 {
-	add_preempt_count(PREEMPT_ACTIVE);
+	__preempt_count_add(PREEMPT_ACTIVE);
 	__schedule();
-	sub_preempt_count(PREEMPT_ACTIVE);
+	__preempt_count_sub(PREEMPT_ACTIVE);
 }
 
 int __sched _cond_resched(void)
@@ -4186,7 +3902,7 @@ void init_idle(struct task_struct *idle, int cpu)
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
-	__sched_fork(idle);
+	__sched_fork(0, idle);
 	idle->state = TASK_RUNNING;
 	idle->se.exec_start = sched_clock();
 
@@ -4212,7 +3928,7 @@ void init_idle(struct task_struct *idle, int cpu)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
 	/* Set the preempt count _outside_ the spinlocks! */
-	task_thread_info(idle)->preempt_count = 0;
+	init_idle_preempt_count(idle, cpu);
 
 	/*
 	 * The idle tasks have their own, simple scheduling class:
@@ -4346,6 +4062,53 @@ fail:
 	return ret;
 }
 
+#ifdef CONFIG_NUMA_BALANCING
+/* Migrate current task p to target_cpu */
+int migrate_task_to(struct task_struct *p, int target_cpu)
+{
+	struct migration_arg arg = { p, target_cpu };
+	int curr_cpu = task_cpu(p);
+
+	if (curr_cpu == target_cpu)
+		return 0;
+
+	if (!cpumask_test_cpu(target_cpu, tsk_cpus_allowed(p)))
+		return -EINVAL;
+
+	/* TODO: This is not properly updating schedstats */
+
+	return stop_one_cpu(curr_cpu, migration_cpu_stop, &arg);
+}
+
+/*
+ * Requeue a task on a given node and accurately track the number of NUMA
+ * tasks on the runqueues
+ */
+void sched_setnuma(struct task_struct *p, int nid)
+{
+	struct rq *rq;
+	unsigned long flags;
+	bool on_rq, running;
+
+	rq = task_rq_lock(p, &flags);
+	on_rq = p->on_rq;
+	running = task_current(rq, p);
+
+	if (on_rq)
+		dequeue_task(rq, p, 0);
+	if (running)
+		p->sched_class->put_prev_task(rq, p);
+
+	p->numa_preferred_nid = nid;
+
+	if (running)
+		p->sched_class->set_curr_task(rq);
+	if (on_rq)
+		enqueue_task(rq, p, 0);
+	task_rq_unlock(rq, p, &flags);
+}
+#endif
+
 /*
  * migration_cpu_stop - this will be executed by a highprio stopper thread
  * and performs thread migration by bumping thread off CPU then
@@ -5119,6 +4882,9 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
 DEFINE_PER_CPU(struct sched_domain *, sd_llc);
 DEFINE_PER_CPU(int, sd_llc_size);
 DEFINE_PER_CPU(int, sd_llc_id);
+DEFINE_PER_CPU(struct sched_domain *, sd_numa);
+DEFINE_PER_CPU(struct sched_domain *, sd_busy);
+DEFINE_PER_CPU(struct sched_domain *, sd_asym);
 
 static void update_top_cache_domain(int cpu)
 {
@@ -5130,11 +4896,18 @@ static void update_top_cache_domain(int cpu)
 	if (sd) {
 		id = cpumask_first(sched_domain_span(sd));
 		size = cpumask_weight(sched_domain_span(sd));
+		rcu_assign_pointer(per_cpu(sd_busy, cpu), sd->parent);
 	}
 
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
 	per_cpu(sd_llc_size, cpu) = size;
 	per_cpu(sd_llc_id, cpu) = id;
+
+	sd = lowest_flag_domain(cpu, SD_NUMA);
+	rcu_assign_pointer(per_cpu(sd_numa, cpu), sd);
+
+	sd = highest_flag_domain(cpu, SD_ASYM_PACKING);
+	rcu_assign_pointer(per_cpu(sd_asym, cpu), sd);
 }
 
 /*
@@ -5654,6 +5427,7 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 					| 0*SD_SHARE_PKG_RESOURCES
 					| 1*SD_SERIALIZE
 					| 0*SD_PREFER_SIBLING
+					| 1*SD_NUMA
 					| sd_local_flags(level)
 					,
 		.last_balance		= jiffies,
@@ -6335,14 +6109,17 @@ void __init sched_init_smp(void)
 
 	sched_init_numa();
 
-	get_online_cpus();
+	/*
+	 * There's no userspace yet to cause hotplug operations; hence all the
+	 * cpu masks are stable and all blatant races in the below code cannot
+	 * happen.
+	 */
 	mutex_lock(&sched_domains_mutex);
 	init_sched_domains(cpu_active_mask);
 	cpumask_andnot(non_isolated_cpus, cpu_possible_mask, cpu_isolated_map);
 	if (cpumask_empty(non_isolated_cpus))
 		cpumask_set_cpu(smp_processor_id(), non_isolated_cpus);
 	mutex_unlock(&sched_domains_mutex);
-	put_online_cpus();
 
 	hotcpu_notifier(sched_domains_numa_masks_update, CPU_PRI_SCHED_ACTIVE);
 	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
@@ -6505,6 +6282,7 @@ void __init sched_init(void)
 		rq->online = 0;
 		rq->idle_stamp = 0;
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
+		rq->max_idle_balance_cost = sysctl_sched_migration_cost;
 
 		INIT_LIST_HEAD(&rq->cfs_tasks);
 
@@ -7277,7 +7055,12 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 
 	runtime_enabled = quota != RUNTIME_INF;
 	runtime_was_enabled = cfs_b->quota != RUNTIME_INF;
-	account_cfs_bandwidth_used(runtime_enabled, runtime_was_enabled);
+	/*
+	 * If we need to toggle cfs_bandwidth_used, off->on must occur
+	 * before making related changes, and on->off must occur afterwards
+	 */
+	if (runtime_enabled && !runtime_was_enabled)
+		cfs_bandwidth_usage_inc();
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->quota = quota;
@@ -7303,6 +7086,8 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 			unthrottle_cfs_rq(cfs_rq);
 		raw_spin_unlock_irq(&rq->lock);
 	}
+	if (runtime_was_enabled && !runtime_enabled)
+		cfs_bandwidth_usage_dec();
 out_unlock:
 	mutex_unlock(&cfs_constraints_mutex);
 
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 1965599..5c34d18 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/kallsyms.h>
 #include <linux/utsname.h>
+#include <linux/mempolicy.h>
 
 #include "sched.h"
 
@@ -137,6 +138,9 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 	SEQ_printf(m, "%15Ld %15Ld %15Ld.%06ld %15Ld.%06ld %15Ld.%06ld",
 		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
 #endif
+#ifdef CONFIG_NUMA_BALANCING
+	SEQ_printf(m, " %d", cpu_to_node(task_cpu(p)));
+#endif
 #ifdef CONFIG_CGROUP_SCHED
 	SEQ_printf(m, " %s", task_group_path(task_group(p)));
 #endif
@@ -159,7 +163,7 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 	read_lock_irqsave(&tasklist_lock, flags);
 
 	do_each_thread(g, p) {
-		if (!p->on_rq || task_cpu(p) != rq_cpu)
+		if (task_cpu(p) != rq_cpu)
 			continue;
 
 		print_task(m, rq, p);
@@ -225,6 +229,14 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			atomic_read(&cfs_rq->tg->runnable_avg));
 #endif
 #endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	SEQ_printf(m, "  .%-30s: %d\n", "tg->cfs_bandwidth.timer_active",
+			cfs_rq->tg->cfs_bandwidth.timer_active);
+	SEQ_printf(m, "  .%-30s: %d\n", "throttled",
+			cfs_rq->throttled);
+	SEQ_printf(m, "  .%-30s: %d\n", "throttle_count",
+			cfs_rq->throttle_count);
+#endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
@@ -345,7 +357,7 @@ static void sched_debug_header(struct seq_file *m)
 	cpu_clk = local_clock();
 	local_irq_restore(flags);
 
-	SEQ_printf(m, "Sched Debug Version: v0.10, %s %.*s\n",
+	SEQ_printf(m, "Sched Debug Version: v0.11, %s %.*s\n",
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
@@ -488,6 +500,56 @@ static int __init init_sched_debug_procfs(void)
 
 __initcall(init_sched_debug_procfs);
 
+#define __P(F) \
+	SEQ_printf(m, "%-45s:%21Ld\n", #F, (long long)F)
+#define P(F) \
+	SEQ_printf(m, "%-45s:%21Ld\n", #F, (long long)p->F)
+#define __PN(F) \
+	SEQ_printf(m, "%-45s:%14Ld.%06ld\n", #F, SPLIT_NS((long long)F))
+#define PN(F) \
+	SEQ_printf(m, "%-45s:%14Ld.%06ld\n", #F, SPLIT_NS((long long)p->F))
+
+
+static void sched_show_numa(struct task_struct *p, struct seq_file *m)
+{
+#ifdef CONFIG_NUMA_BALANCING
+	struct mempolicy *pol;
+	int node, i;
+
+	if (p->mm)
+		P(mm->numa_scan_seq);
+
+	task_lock(p);
+	pol = p->mempolicy;
+	if (pol && !(pol->flags & MPOL_F_MORON))
+		pol = NULL;
+	mpol_get(pol);
+	task_unlock(p);
+
+	SEQ_printf(m, "numa_migrations, %ld\n", xchg(&p->numa_pages_migrated, 0));
+
+	for_each_online_node(node) {
+		for (i = 0; i < 2; i++) {
+			unsigned long nr_faults = -1;
+			int cpu_current, home_node;
+
+			if (p->numa_faults)
+				nr_faults = p->numa_faults[2*node + i];
+
+			cpu_current = !i ? (task_node(p) == node) :
+				(pol && node_isset(node, pol->v.nodes));
+
+			home_node = (p->numa_preferred_nid == node);
+
+			SEQ_printf(m, "numa_faults, %d, %d, %d, %d, %ld\n",
+				i, node, cpu_current, home_node, nr_faults);
+		}
+	}
+
+	mpol_put(pol);
+#endif
+}
+
 void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 {
 	unsigned long nr_switches;
@@ -591,6 +653,8 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 		SEQ_printf(m, "%-45s:%21Ld\n",
 			   "clock-delta", (long long)(t1-t0));
 	}
+
+	sched_show_numa(p, m);
 }
 
 void proc_sched_set_task(struct task_struct *p)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c70201..df77c60 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -681,6 +681,8 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 #ifdef CONFIG_SMP
+static unsigned long task_h_load(struct task_struct *p);
+
 static inline void __update_task_entity_contrib(struct sched_entity *se);
 
 /* Give new task start runnable values to heavy its load in infant time */
@@ -818,11 +820,12 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 #ifdef CONFIG_NUMA_BALANCING
 /*
- * numa task sample period in ms
+ * Approximate time to scan a full NUMA task in ms. The task scan period is
+ * calculated based on the tasks virtual memory size and
+ * numa_balancing_scan_size.
  */
-unsigned int sysctl_numa_balancing_scan_period_min = 100;
-unsigned int sysctl_numa_balancing_scan_period_max = 100*50;
-unsigned int sysctl_numa_balancing_scan_period_reset = 100*600;
+unsigned int sysctl_numa_balancing_scan_period_min = 1000;
+unsigned int sysctl_numa_balancing_scan_period_max = 60000;
 
 /* Portion of address space to scan in MB */
 unsigned int sysctl_numa_balancing_scan_size = 256;
@@ -830,41 +833,810 @@ unsigned int sysctl_numa_balancing_scan_size = 256;
 /* Scan @scan_size MB every @scan_period after an initial @scan_delay in ms */
 unsigned int sysctl_numa_balancing_scan_delay = 1000;
 
-static void task_numa_placement(struct task_struct *p)
+/*
+ * After skipping a page migration on a shared page, skip N more numa page
+ * migrations unconditionally. This reduces the number of NUMA migrations
+ * in shared memory workloads, and has the effect of pulling tasks towards
+ * where their memory lives, over pulling the memory towards the task.
+ */
+unsigned int sysctl_numa_balancing_migrate_deferred = 16;
+
+static unsigned int task_nr_scan_windows(struct task_struct *p)
+{
+	unsigned long rss = 0;
+	unsigned long nr_scan_pages;
+
+	/*
+	 * Calculations based on RSS as non-present and empty pages are skipped
+	 * by the PTE scanner and NUMA hinting faults should be trapped based
+	 * on resident pages
+	 */
+	nr_scan_pages = sysctl_numa_balancing_scan_size << (20 - PAGE_SHIFT);
+	rss = get_mm_rss(p->mm);
+	if (!rss)
+		rss = nr_scan_pages;
+
+	rss = round_up(rss, nr_scan_pages);
+	return rss / nr_scan_pages;
+}
+
+/* For sanitys sake, never scan more PTEs than MAX_SCAN_WINDOW MB/sec. */
+#define MAX_SCAN_WINDOW 2560
+
+static unsigned int task_scan_min(struct task_struct *p)
+{
+	unsigned int scan, floor;
+	unsigned int windows = 1;
+
+	if (sysctl_numa_balancing_scan_size < MAX_SCAN_WINDOW)
+		windows = MAX_SCAN_WINDOW / sysctl_numa_balancing_scan_size;
+	floor = 1000 / windows;
+
+	scan = sysctl_numa_balancing_scan_period_min / task_nr_scan_windows(p);
+	return max_t(unsigned int, floor, scan);
+}
+
+static unsigned int task_scan_max(struct task_struct *p)
+{
+	unsigned int smin = task_scan_min(p);
+	unsigned int smax;
+
+	/* Watch for min being lower than max due to floor calculations */
+	smax = sysctl_numa_balancing_scan_period_max / task_nr_scan_windows(p);
+	return max(smin, smax);
+}
+
+/*
+ * Once a preferred node is selected the scheduler balancer will prefer moving
+ * a task to that node for sysctl_numa_balancing_settle_count number of PTE
+ * scans. This will give the process the chance to accumulate more faults on
+ * the preferred node but still allow the scheduler to move the task again if
+ * the nodes CPUs are overloaded.
+ */
+unsigned int sysctl_numa_balancing_settle_count __read_mostly = 4;
+
+static void account_numa_enqueue(struct rq *rq, struct task_struct *p)
+{
+	rq->nr_numa_running += (p->numa_preferred_nid != -1);
+	rq->nr_preferred_running += (p->numa_preferred_nid == task_node(p));
+}
+
+static void account_numa_dequeue(struct rq *rq, struct task_struct *p)
+{
+	rq->nr_numa_running -= (p->numa_preferred_nid != -1);
+	rq->nr_preferred_running -= (p->numa_preferred_nid == task_node(p));
+}
+
+struct numa_group {
+	atomic_t refcount;
+
+	spinlock_t lock; /* nr_tasks, tasks */
+	int nr_tasks;
+	pid_t gid;
+	struct list_head task_list;
+
+	struct rcu_head rcu;
+	unsigned long total_faults;
+	unsigned long faults[0];
+};
+
+pid_t task_numa_group_id(struct task_struct *p)
+{
+	return p->numa_group ? p->numa_group->gid : 0;
+}
+
+static inline int task_faults_idx(int nid, int priv)
+{
+	return 2 * nid + priv;
+}
+
+static inline unsigned long task_faults(struct task_struct *p, int nid)
+{
+	if (!p->numa_faults)
+		return 0;
+
+	return p->numa_faults[task_faults_idx(nid, 0)] +
+		p->numa_faults[task_faults_idx(nid, 1)];
+}
+
+static inline unsigned long group_faults(struct task_struct *p, int nid)
+{
+	if (!p->numa_group)
+		return 0;
+
+	return p->numa_group->faults[2*nid] + p->numa_group->faults[2*nid+1];
+}
+
+/*
+ * These return the fraction of accesses done by a particular task, or
+ * task group, on a particular numa node.  The group weight is given a
+ * larger multiplier, in order to group tasks together that are almost
+ * evenly spread out between numa nodes.
+ */
+static inline unsigned long task_weight(struct task_struct *p, int nid)
+{
+	unsigned long total_faults;
+
+	if (!p->numa_faults)
+		return 0;
+
+	total_faults = p->total_numa_faults;
+
+	if (!total_faults)
+		return 0;
+
+	return 1000 * task_faults(p, nid) / total_faults;
+}
+
+static inline unsigned long group_weight(struct task_struct *p, int nid)
 {
-	int seq;
+	if (!p->numa_group || !p->numa_group->total_faults)
+		return 0;
 
-	if (!p->mm)	/* for example, ksmd faulting in a user's mm */
+	return 1000 * group_faults(p, nid) / p->numa_group->total_faults;
+}
+
+static unsigned long weighted_cpuload(const int cpu);
+static unsigned long source_load(int cpu, int type);
+static unsigned long target_load(int cpu, int type);
+static unsigned long power_of(int cpu);
+static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
+
+/* Cached statistics for all CPUs within a node */
+struct numa_stats {
+	unsigned long nr_running;
+	unsigned long load;
+
+	/* Total compute capacity of CPUs on a node */
+	unsigned long power;
+
+	/* Approximate capacity in terms of runnable tasks on a node */
+	unsigned long capacity;
+	int has_capacity;
+};
+
+/*
+ * XXX borrowed from update_sg_lb_stats
+ */
+static void update_numa_stats(struct numa_stats *ns, int nid)
+{
+	int cpu;
+
+	memset(ns, 0, sizeof(*ns));
+	for_each_cpu(cpu, cpumask_of_node(nid)) {
+		struct rq *rq = cpu_rq(cpu);
+
+		ns->nr_running += rq->nr_running;
+		ns->load += weighted_cpuload(cpu);
+		ns->power += power_of(cpu);
+	}
+
+	ns->load = (ns->load * SCHED_POWER_SCALE) / ns->power;
+	ns->capacity = DIV_ROUND_CLOSEST(ns->power, SCHED_POWER_SCALE);
+	ns->has_capacity = (ns->nr_running < ns->capacity);
+}
+
+struct task_numa_env {
+	struct task_struct *p;
+
+	int src_cpu, src_nid;
+	int dst_cpu, dst_nid;
+
+	struct numa_stats src_stats, dst_stats;
+
+	int imbalance_pct, idx;
+
+	struct task_struct *best_task;
+	long best_imp;
+	int best_cpu;
+};
+
+static void task_numa_assign(struct task_numa_env *env,
+			     struct task_struct *p, long imp)
+{
+	if (env->best_task)
+		put_task_struct(env->best_task);
+	if (p)
+		get_task_struct(p);
+
+	env->best_task = p;
+	env->best_imp = imp;
+	env->best_cpu = env->dst_cpu;
+}
+
+/*
+ * This checks if the overall compute and NUMA accesses of the system would
+ * be improved if the source tasks was migrated to the target dst_cpu taking
+ * into account that it might be best if task running on the dst_cpu should
+ * be exchanged with the source task
+ */
+static void task_numa_compare(struct task_numa_env *env,
+			      long taskimp, long groupimp)
+{
+	struct rq *src_rq = cpu_rq(env->src_cpu);
+	struct rq *dst_rq = cpu_rq(env->dst_cpu);
+	struct task_struct *cur;
+	long dst_load, src_load;
+	long load;
+	long imp = (groupimp > 0) ? groupimp : taskimp;
+
+	rcu_read_lock();
+	cur = ACCESS_ONCE(dst_rq->curr);
+	if (cur->pid == 0) /* idle */
+		cur = NULL;
+
+	/*
+	 * "imp" is the fault differential for the source task between the
+	 * source and destination node. Calculate the total differential for
+	 * the source task and potential destination task. The more negative
+	 * the value is, the more rmeote accesses that would be expected to
+	 * be incurred if the tasks were swapped.
+	 */
+	if (cur) {
+		/* Skip this swap candidate if cannot move to the source cpu */
+		if (!cpumask_test_cpu(env->src_cpu, tsk_cpus_allowed(cur)))
+			goto unlock;
+
+		/*
+		 * If dst and source tasks are in the same NUMA group, or not
+		 * in any group then look only at task weights.
+		 */
+		if (cur->numa_group == env->p->numa_group) {
+			imp = taskimp + task_weight(cur, env->src_nid) -
+			      task_weight(cur, env->dst_nid);
+			/*
+			 * Add some hysteresis to prevent swapping the
+			 * tasks within a group over tiny differences.
+			 */
+			if (cur->numa_group)
+				imp -= imp/16;
+		} else {
+			/*
+			 * Compare the group weights. If a task is all by
+			 * itself (not part of a group), use the task weight
+			 * instead.
+			 */
+			if (env->p->numa_group)
+				imp = groupimp;
+			else
+				imp = taskimp;
+
+			if (cur->numa_group)
+				imp += group_weight(cur, env->src_nid) -
+				       group_weight(cur, env->dst_nid);
+			else
+				imp += task_weight(cur, env->src_nid) -
+				       task_weight(cur, env->dst_nid);
+		}
+	}
+
+	if (imp < env->best_imp)
+		goto unlock;
+
+	if (!cur) {
+		/* Is there capacity at our destination? */
+		if (env->src_stats.has_capacity &&
+		    !env->dst_stats.has_capacity)
+			goto unlock;
+
+		goto balance;
+	}
+
+	/* Balance doesn't matter much if we're running a task per cpu */
+	if (src_rq->nr_running == 1 && dst_rq->nr_running == 1)
+		goto assign;
+
+	/*
+	 * In the overloaded case, try and keep the load balanced.
+	 */
+balance:
+	dst_load = env->dst_stats.load;
+	src_load = env->src_stats.load;
+
+	/* XXX missing power terms */
+	load = task_h_load(env->p);
+	dst_load += load;
+	src_load -= load;
+
+	if (cur) {
+		load = task_h_load(cur);
+		dst_load -= load;
+		src_load += load;
+	}
+
+	/* make src_load the smaller */
+	if (dst_load < src_load)
+		swap(dst_load, src_load);
+
+	if (src_load * env->imbalance_pct < dst_load * 100)
+		goto unlock;
+
+assign:
+	task_numa_assign(env, cur, imp);
+unlock:
+	rcu_read_unlock();
+}
+
+static void task_numa_find_cpu(struct task_numa_env *env,
+				long taskimp, long groupimp)
+{
+	int cpu;
+
+	for_each_cpu(cpu, cpumask_of_node(env->dst_nid)) {
+		/* Skip this CPU if the source task cannot migrate */
+		if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(env->p)))
+			continue;
+
+		env->dst_cpu = cpu;
+		task_numa_compare(env, taskimp, groupimp);
+	}
+}
+
+static int task_numa_migrate(struct task_struct *p)
+{
+	struct task_numa_env env = {
+		.p = p,
+
+		.src_cpu = task_cpu(p),
+		.src_nid = task_node(p),
+
+		.imbalance_pct = 112,
+
+		.best_task = NULL,
+		.best_imp = 0,
+		.best_cpu = -1
+	};
+	struct sched_domain *sd;
+	unsigned long taskweight, groupweight;
+	int nid, ret;
+	long taskimp, groupimp;
+
+	/*
+	 * Pick the lowest SD_NUMA domain, as that would have the smallest
+	 * imbalance and would be the first to start moving tasks about.
+	 *
+	 * And we want to avoid any moving of tasks about, as that would create
+	 * random movement of tasks -- counter the numa conditions we're trying
+	 * to satisfy here.
+	 */
+	rcu_read_lock();
+	sd = rcu_dereference(per_cpu(sd_numa, env.src_cpu));
+	env.imbalance_pct = 100 + (sd->imbalance_pct - 100) / 2;
+	rcu_read_unlock();
+
+	taskweight = task_weight(p, env.src_nid);
+	groupweight = group_weight(p, env.src_nid);
+	update_numa_stats(&env.src_stats, env.src_nid);
+	env.dst_nid = p->numa_preferred_nid;
+	taskimp = task_weight(p, env.dst_nid) - taskweight;
+	groupimp = group_weight(p, env.dst_nid) - groupweight;
+	update_numa_stats(&env.dst_stats, env.dst_nid);
+
+	/* If the preferred nid has capacity, try to use it. */
+	if (env.dst_stats.has_capacity)
+		task_numa_find_cpu(&env, taskimp, groupimp);
+
+	/* No space available on the preferred nid. Look elsewhere. */
+	if (env.best_cpu == -1) {
+		for_each_online_node(nid) {
+			if (nid == env.src_nid || nid == p->numa_preferred_nid)
+				continue;
+
+			/* Only consider nodes where both task and groups benefit */
+			taskimp = task_weight(p, nid) - taskweight;
+			groupimp = group_weight(p, nid) - groupweight;
+			if (taskimp < 0 && groupimp < 0)
+				continue;
+
+			env.dst_nid = nid;
+			update_numa_stats(&env.dst_stats, env.dst_nid);
+			task_numa_find_cpu(&env, taskimp, groupimp);
+		}
+	}
+
+	/* No better CPU than the current one was found. */
+	if (env.best_cpu == -1)
+		return -EAGAIN;
+
+	sched_setnuma(p, env.dst_nid);
+
+	/*
+	 * Reset the scan period if the task is being rescheduled on an
+	 * alternative node to recheck if the tasks is now properly placed.
+	 */
+	p->numa_scan_period = task_scan_min(p);
+
+	if (env.best_task == NULL) {
+		int ret = migrate_task_to(p, env.best_cpu);
+		return ret;
+	}
+
+	ret = migrate_swap(p, env.best_task);
+	put_task_struct(env.best_task);
+	return ret;
+}
+
+/* Attempt to migrate a task to a CPU on the preferred node. */
+static void numa_migrate_preferred(struct task_struct *p)
+{
+	/* This task has no NUMA fault statistics yet */
+	if (unlikely(p->numa_preferred_nid == -1 || !p->numa_faults))
+		return;
+
+	/* Periodically retry migrating the task to the preferred node */
+	p->numa_migrate_retry = jiffies + HZ;
+
+	/* Success if task is already running on preferred CPU */
+	if (cpu_to_node(task_cpu(p)) == p->numa_preferred_nid)
 		return;
+
+	/* Otherwise, try migrate to a CPU on the preferred node */
+	task_numa_migrate(p);
+}
+
+/*
+ * When adapting the scan rate, the period is divided into NUMA_PERIOD_SLOTS
+ * increments. The more local the fault statistics are, the higher the scan
+ * period will be for the next scan window. If local/remote ratio is below
+ * NUMA_PERIOD_THRESHOLD (where range of ratio is 1..NUMA_PERIOD_SLOTS) the
+ * scan period will decrease
+ */
+#define NUMA_PERIOD_SLOTS 10
+#define NUMA_PERIOD_THRESHOLD 3
+
+/*
+ * Increase the scan period (slow down scanning) if the majority of
+ * our memory is already on our local node, or if the majority of
+ * the page accesses are shared with other processes.
+ * Otherwise, decrease the scan period.
+ */
+static void update_task_scan_period(struct task_struct *p,
+			unsigned long shared, unsigned long private)
+{
+	unsigned int period_slot;
+	int ratio;
+	int diff;
+
+	unsigned long remote = p->numa_faults_locality[0];
+	unsigned long local = p->numa_faults_locality[1];
+
+	/*
+	 * If there were no record hinting faults then either the task is
+	 * completely idle or all activity is areas that are not of interest
+	 * to automatic numa balancing. Scan slower
+	 */
+	if (local + shared == 0) {
+		p->numa_scan_period = min(p->numa_scan_period_max,
+			p->numa_scan_period << 1);
+
+		p->mm->numa_next_scan = jiffies +
+			msecs_to_jiffies(p->numa_scan_period);
+
+		return;
+	}
+
+	/*
+	 * Prepare to scale scan period relative to the current period.
+	 *	 == NUMA_PERIOD_THRESHOLD scan period stays the same
+	 *       <  NUMA_PERIOD_THRESHOLD scan period decreases (scan faster)
+	 *	 >= NUMA_PERIOD_THRESHOLD scan period increases (scan slower)
+	 */
+	period_slot = DIV_ROUND_UP(p->numa_scan_period, NUMA_PERIOD_SLOTS);
+	ratio = (local * NUMA_PERIOD_SLOTS) / (local + remote);
+	if (ratio >= NUMA_PERIOD_THRESHOLD) {
+		int slot = ratio - NUMA_PERIOD_THRESHOLD;
+		if (!slot)
+			slot = 1;
+		diff = slot * period_slot;
+	} else {
+		diff = -(NUMA_PERIOD_THRESHOLD - ratio) * period_slot;
+
+		/*
+		 * Scale scan rate increases based on sharing. There is an
+		 * inverse relationship between the degree of sharing and
+		 * the adjustment made to the scanning period. Broadly
+		 * speaking the intent is that there is little point
+		 * scanning faster if shared accesses dominate as it may
+		 * simply bounce migrations uselessly
+		 */
+		period_slot = DIV_ROUND_UP(diff, NUMA_PERIOD_SLOTS);
+		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared));
+		diff = (diff * ratio) / NUMA_PERIOD_SLOTS;
+	}
+
+	p->numa_scan_period = clamp(p->numa_scan_period + diff,
+			task_scan_min(p), task_scan_max(p));
+	memset(p->numa_faults_locality, 0, sizeof(p->numa_faults_locality));
+}
+
+static void task_numa_placement(struct task_struct *p)
+{
+	int seq, nid, max_nid = -1, max_group_nid = -1;
+	unsigned long max_faults = 0, max_group_faults = 0;
+	unsigned long fault_types[2] = { 0, 0 };
+	spinlock_t *group_lock = NULL;
+
 	seq = ACCESS_ONCE(p->mm->numa_scan_seq);
 	if (p->numa_scan_seq == seq)
 		return;
 	p->numa_scan_seq = seq;
+	p->numa_scan_period_max = task_scan_max(p);
+
+	/* If the task is part of a group prevent parallel updates to group stats */
+	if (p->numa_group) {
+		group_lock = &p->numa_group->lock;
+		spin_lock(group_lock);
+	}
+
+	/* Find the node with the highest number of faults */
+	for_each_online_node(nid) {
+		unsigned long faults = 0, group_faults = 0;
+		int priv, i;
+
+		for (priv = 0; priv < 2; priv++) {
+			long diff;
+
+			i = task_faults_idx(nid, priv);
+			diff = -p->numa_faults[i];
+
+			/* Decay existing window, copy faults since last scan */
+			p->numa_faults[i] >>= 1;
+			p->numa_faults[i] += p->numa_faults_buffer[i];
+			fault_types[priv] += p->numa_faults_buffer[i];
+			p->numa_faults_buffer[i] = 0;
+
+			faults += p->numa_faults[i];
+			diff += p->numa_faults[i];
+			p->total_numa_faults += diff;
+			if (p->numa_group) {
+				/* safe because we can only change our own group */
+				p->numa_group->faults[i] += diff;
+				p->numa_group->total_faults += diff;
+				group_faults += p->numa_group->faults[i];
+			}
+		}
+
+		if (faults > max_faults) {
+			max_faults = faults;
+			max_nid = nid;
+		}
+
+		if (group_faults > max_group_faults) {
+			max_group_faults = group_faults;
+			max_group_nid = nid;
+		}
+	}
+
+	update_task_scan_period(p, fault_types[0], fault_types[1]);
+
+	if (p->numa_group) {
+		/*
+		 * If the preferred task and group nids are different,
+		 * iterate over the nodes again to find the best place.
+		 */
+		if (max_nid != max_group_nid) {
+			unsigned long weight, max_weight = 0;
+
+			for_each_online_node(nid) {
+				weight = task_weight(p, nid) + group_weight(p, nid);
+				if (weight > max_weight) {
+					max_weight = weight;
+					max_nid = nid;
+				}
+			}
+		}
+
+		spin_unlock(group_lock);
+	}
+
+	/* Preferred node as the node with the most faults */
+	if (max_faults && max_nid != p->numa_preferred_nid) {
+		/* Update the preferred nid and migrate task if possible */
+		sched_setnuma(p, max_nid);
+		numa_migrate_preferred(p);
+	}
+}
+
+static inline int get_numa_group(struct numa_group *grp)
+{
+	return atomic_inc_not_zero(&grp->refcount);
+}
+
+static inline void put_numa_group(struct numa_group *grp)
+{
+	if (atomic_dec_and_test(&grp->refcount))
+		kfree_rcu(grp, rcu);
+}
+
+static void task_numa_group(struct task_struct *p, int cpupid, int flags,
+			int *priv)
+{
+	struct numa_group *grp, *my_grp;
+	struct task_struct *tsk;
+	bool join = false;
+	int cpu = cpupid_to_cpu(cpupid);
+	int i;
+
+	if (unlikely(!p->numa_group)) {
+		unsigned int size = sizeof(struct numa_group) +
+				    2*nr_node_ids*sizeof(unsigned long);
+
+		grp = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
+		if (!grp)
+			return;
+
+		atomic_set(&grp->refcount, 1);
+		spin_lock_init(&grp->lock);
+		INIT_LIST_HEAD(&grp->task_list);
+		grp->gid = p->pid;
+
+		for (i = 0; i < 2*nr_node_ids; i++)
+			grp->faults[i] = p->numa_faults[i];
+
+		grp->total_faults = p->total_numa_faults;
+
+		list_add(&p->numa_entry, &grp->task_list);
+		grp->nr_tasks++;
+		rcu_assign_pointer(p->numa_group, grp);
+	}
+
+	rcu_read_lock();
+	tsk = ACCESS_ONCE(cpu_rq(cpu)->curr);
+
+	if (!cpupid_match_pid(tsk, cpupid))
+		goto no_join;
+
+	grp = rcu_dereference(tsk->numa_group);
+	if (!grp)
+		goto no_join;
+
+	my_grp = p->numa_group;
+	if (grp == my_grp)
+		goto no_join;
+
+	/*
+	 * Only join the other group if its bigger; if we're the bigger group,
+	 * the other task will join us.
+	 */
+	if (my_grp->nr_tasks > grp->nr_tasks)
+		goto no_join;
+
+	/*
+	 * Tie-break on the grp address.
+	 */
+	if (my_grp->nr_tasks == grp->nr_tasks && my_grp > grp)
+		goto no_join;
+
+	/* Always join threads in the same process. */
+	if (tsk->mm == current->mm)
+		join = true;
+
+	/* Simple filter to avoid false positives due to PID collisions */
+	if (flags & TNF_SHARED)
+		join = true;
+
+	/* Update priv based on whether false sharing was detected */
+	*priv = !join;
+
+	if (join && !get_numa_group(grp))
+		goto no_join;
 
-	/* FIXME: Scheduling placement policy hints go here */
+	rcu_read_unlock();
+
+	if (!join)
+		return;
+
+	double_lock(&my_grp->lock, &grp->lock);
+
+	for (i = 0; i < 2*nr_node_ids; i++) {
+		my_grp->faults[i] -= p->numa_faults[i];
+		grp->faults[i] += p->numa_faults[i];
+	}
+	my_grp->total_faults -= p->total_numa_faults;
+	grp->total_faults += p->total_numa_faults;
+
+	list_move(&p->numa_entry, &grp->task_list);
+	my_grp->nr_tasks--;
+	grp->nr_tasks++;
+
+	spin_unlock(&my_grp->lock);
+	spin_unlock(&grp->lock);
+
+	rcu_assign_pointer(p->numa_group, grp);
+
+	put_numa_group(my_grp);
+	return;
+
+no_join:
+	rcu_read_unlock();
+	return;
+}
+
+void task_numa_free(struct task_struct *p)
+{
+	struct numa_group *grp = p->numa_group;
+	int i;
+	void *numa_faults = p->numa_faults;
+
+	if (grp) {
+		spin_lock(&grp->lock);
+		for (i = 0; i < 2*nr_node_ids; i++)
+			grp->faults[i] -= p->numa_faults[i];
+		grp->total_faults -= p->total_numa_faults;
+
+		list_del(&p->numa_entry);
+		grp->nr_tasks--;
+		spin_unlock(&grp->lock);
+		rcu_assign_pointer(p->numa_group, NULL);
+		put_numa_group(grp);
+	}
+
+	p->numa_faults = NULL;
+	p->numa_faults_buffer = NULL;
+	kfree(numa_faults);
 }
 
 /*
  * Got a PROT_NONE fault for a page on @node.
  */
-void task_numa_fault(int node, int pages, bool migrated)
+void task_numa_fault(int last_cpupid, int node, int pages, int flags)
 {
 	struct task_struct *p = current;
+	bool migrated = flags & TNF_MIGRATED;
+	int priv;
 
 	if (!numabalancing_enabled)
 		return;
 
-	/* FIXME: Allocate task-specific structure for placement policy here */
+	/* for example, ksmd faulting in a user's mm */
+	if (!p->mm)
+		return;
+
+	/* Do not worry about placement if exiting */
+	if (p->state == TASK_DEAD)
+		return;
+
+	/* Allocate buffer to track faults on a per-node basis */
+	if (unlikely(!p->numa_faults)) {
+		int size = sizeof(*p->numa_faults) * 2 * nr_node_ids;
+
+		/* numa_faults and numa_faults_buffer share the allocation */
+		p->numa_faults = kzalloc(size * 2, GFP_KERNEL|__GFP_NOWARN);
+		if (!p->numa_faults)
+			return;
+
+		BUG_ON(p->numa_faults_buffer);
+		p->numa_faults_buffer = p->numa_faults + (2 * nr_node_ids);
+		p->total_numa_faults = 0;
+		memset(p->numa_faults_locality, 0, sizeof(p->numa_faults_locality));
+	}
 
 	/*
-	 * If pages are properly placed (did not migrate) then scan slower.
-	 * This is reset periodically in case of phase changes
+	 * First accesses are treated as private, otherwise consider accesses
+	 * to be private if the accessing pid has not changed
 	 */
-        if (!migrated)
-		p->numa_scan_period = min(sysctl_numa_balancing_scan_period_max,
-			p->numa_scan_period + jiffies_to_msecs(10));
+	if (unlikely(last_cpupid == (-1 & LAST_CPUPID_MASK))) {
+		priv = 1;
+	} else {
+		priv = cpupid_match_pid(p, last_cpupid);
+		if (!priv && !(flags & TNF_NO_GROUP))
+			task_numa_group(p, last_cpupid, flags, &priv);
+	}
 
 	task_numa_placement(p);
+
+	/*
+	 * Retry task to preferred node migration periodically, in case it
+	 * case it previously failed, or the scheduler moved us.
+	 */
+	if (time_after(jiffies, p->numa_migrate_retry))
+		numa_migrate_preferred(p);
+
+	if (migrated)
+		p->numa_pages_migrated += pages;
+
+	p->numa_faults_buffer[task_faults_idx(node, priv)] += pages;
+	p->numa_faults_locality[!!(flags & TNF_FAULT_LOCAL)] += pages;
 }
 
 static void reset_ptenuma_scan(struct task_struct *p)
@@ -884,6 +1656,7 @@ void task_numa_work(struct callback_head *work)
 	struct mm_struct *mm = p->mm;
 	struct vm_area_struct *vma;
 	unsigned long start, end;
+	unsigned long nr_pte_updates = 0;
 	long pages;
 
 	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
@@ -900,35 +1673,9 @@ void task_numa_work(struct callback_head *work)
 	if (p->flags & PF_EXITING)
 		return;
 
-	/*
-	 * We do not care about task placement until a task runs on a node
-	 * other than the first one used by the address space. This is
-	 * largely because migrations are driven by what CPU the task
-	 * is running on. If it's never scheduled on another node, it'll
-	 * not migrate so why bother trapping the fault.
-	 */
-	if (mm->first_nid == NUMA_PTE_SCAN_INIT)
-		mm->first_nid = numa_node_id();
-	if (mm->first_nid != NUMA_PTE_SCAN_ACTIVE) {
-		/* Are we running on a new node yet? */
-		if (numa_node_id() == mm->first_nid &&
-		    !sched_feat_numa(NUMA_FORCE))
-			return;
-
-		mm->first_nid = NUMA_PTE_SCAN_ACTIVE;
-	}
-
-	/*
-	 * Reset the scan period if enough time has gone by. Objective is that
-	 * scanning will be reduced if pages are properly placed. As tasks
-	 * can enter different phases this needs to be re-examined. Lacking
-	 * proper tracking of reference behaviour, this blunt hammer is used.
-	 */
-	migrate = mm->numa_next_reset;
-	if (time_after(now, migrate)) {
-		p->numa_scan_period = sysctl_numa_balancing_scan_period_min;
-		next_scan = now + msecs_to_jiffies(sysctl_numa_balancing_scan_period_reset);
-		xchg(&mm->numa_next_reset, next_scan);
+	if (!mm->numa_next_scan) {
+		mm->numa_next_scan = now +
+			msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
 	}
 
 	/*
@@ -938,20 +1685,20 @@ void task_numa_work(struct callback_head *work)
 	if (time_before(now, migrate))
 		return;
 
-	if (p->numa_scan_period == 0)
-		p->numa_scan_period = sysctl_numa_balancing_scan_period_min;
+	if (p->numa_scan_period == 0) {
+		p->numa_scan_period_max = task_scan_max(p);
+		p->numa_scan_period = task_scan_min(p);
+	}
 
 	next_scan = now + msecs_to_jiffies(p->numa_scan_period);
 	if (cmpxchg(&mm->numa_next_scan, migrate, next_scan) != migrate)
 		return;
 
 	/*
-	 * Do not set pte_numa if the current running node is rate-limited.
-	 * This loses statistics on the fault but if we are unwilling to
-	 * migrate to this node, it is less likely we can do useful work
+	 * Delay this task enough that another task of this mm will likely win
+	 * the next time around.
 	 */
-	if (migrate_ratelimited(numa_node_id()))
-		return;
+	p->node_stamp += 2 * TICK_NSEC;
 
 	start = mm->numa_scan_offset;
 	pages = sysctl_numa_balancing_scan_size;
@@ -967,18 +1714,32 @@ void task_numa_work(struct callback_head *work)
 		vma = mm->mmap;
 	}
 	for (; vma; vma = vma->vm_next) {
-		if (!vma_migratable(vma))
+		if (!vma_migratable(vma) || !vma_policy_mof(p, vma))
 			continue;
 
-		/* Skip small VMAs. They are not likely to be of relevance */
-		if (vma->vm_end - vma->vm_start < HPAGE_SIZE)
+		/*
+		 * Shared library pages mapped by multiple processes are not
+		 * migrated as it is expected they are cache replicated. Avoid
+		 * hinting faults in read-only file-backed mappings or the vdso
+		 * as migrating the pages will be of marginal benefit.
+		 */
+		if (!vma->vm_mm ||
+		    (vma->vm_file && (vma->vm_flags & (VM_READ|VM_WRITE)) == (VM_READ)))
 			continue;
 
 		do {
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
 			end = min(end, vma->vm_end);
-			pages -= change_prot_numa(vma, start, end);
+			nr_pte_updates += change_prot_numa(vma, start, end);
+
+			/*
+			 * Scan sysctl_numa_balancing_scan_size but ensure that
+			 * at least one PTE is updated so that unused virtual
+			 * address space is quickly skipped.
+			 */
+			if (nr_pte_updates)
+				pages -= (end - start) >> PAGE_SHIFT;
 
 			start = end;
 			if (pages <= 0)
@@ -988,10 +1749,10 @@ void task_numa_work(struct callback_head *work)
 
 out:
 	/*
-	 * It is possible to reach the end of the VMA list but the last few VMAs are
-	 * not guaranteed to the vma_migratable. If they are not, we would find the
-	 * !migratable VMA on the next scan but not reset the scanner to the start
-	 * so check it now.
+	 * It is possible to reach the end of the VMA list but the last few
+	 * VMAs are not guaranteed to the vma_migratable. If they are not, we
+	 * would find the !migratable VMA on the next scan but not reset the
+	 * scanner to the start so check it now.
 	 */
 	if (vma)
 		mm->numa_scan_offset = start;
@@ -1025,8 +1786,8 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 
 	if (now - curr->node_stamp > period) {
 		if (!curr->node_stamp)
-			curr->numa_scan_period = sysctl_numa_balancing_scan_period_min;
-		curr->node_stamp = now;
+			curr->numa_scan_period = task_scan_min(curr);
+		curr->node_stamp += period;
 
 		if (!time_before(jiffies, curr->mm->numa_next_scan)) {
 			init_task_work(work, task_numa_work); /* TODO: move this into sched_fork() */
@@ -1038,6 +1799,14 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 static void task_tick_numa(struct rq *rq, struct task_struct *curr)
 {
 }
+
+static inline void account_numa_enqueue(struct rq *rq, struct task_struct *p)
+{
+}
+
+static inline void account_numa_dequeue(struct rq *rq, struct task_struct *p)
+{
+}
 #endif /* CONFIG_NUMA_BALANCING */
 
 static void
@@ -1047,8 +1816,12 @@ account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	if (!parent_entity(se))
 		update_load_add(&rq_of(cfs_rq)->load, se->load.weight);
 #ifdef CONFIG_SMP
-	if (entity_is_task(se))
-		list_add(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
+	if (entity_is_task(se)) {
+		struct rq *rq = rq_of(cfs_rq);
+
+		account_numa_enqueue(rq, task_of(se));
+		list_add(&se->group_node, &rq->cfs_tasks);
+	}
 #endif
 	cfs_rq->nr_running++;
 }
@@ -1059,8 +1832,10 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
 		update_load_sub(&rq_of(cfs_rq)->load, se->load.weight);
-	if (entity_is_task(se))
+	if (entity_is_task(se)) {
+		account_numa_dequeue(rq_of(cfs_rq), task_of(se));
 		list_del_init(&se->group_node);
+	}
 	cfs_rq->nr_running--;
 }
 
@@ -2070,13 +2845,14 @@ static inline bool cfs_bandwidth_used(void)
 	return static_key_false(&__cfs_bandwidth_used);
 }
 
-void account_cfs_bandwidth_used(int enabled, int was_enabled)
+void cfs_bandwidth_usage_inc(void)
+{
+	static_key_slow_inc(&__cfs_bandwidth_used);
+}
+
+void cfs_bandwidth_usage_dec(void)
 {
-	/* only need to count groups transitioning between enabled/!enabled */
-	if (enabled && !was_enabled)
-		static_key_slow_inc(&__cfs_bandwidth_used);
-	else if (!enabled && was_enabled)
-		static_key_slow_dec(&__cfs_bandwidth_used);
+	static_key_slow_dec(&__cfs_bandwidth_used);
 }
 #else /* HAVE_JUMP_LABEL */
 static bool cfs_bandwidth_used(void)
@@ -2084,7 +2860,8 @@ static bool cfs_bandwidth_used(void)
 	return true;
 }
 
-void account_cfs_bandwidth_used(int enabled, int was_enabled) {}
+void cfs_bandwidth_usage_inc(void) {}
+void cfs_bandwidth_usage_dec(void) {}
 #endif /* HAVE_JUMP_LABEL */
 
 /*
@@ -2335,6 +3112,8 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	cfs_rq->throttled_clock = rq_clock(rq);
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
+	if (!cfs_b->timer_active)
+		__start_cfs_bandwidth(cfs_b);
 	raw_spin_unlock(&cfs_b->lock);
 }
 
@@ -2448,6 +3227,13 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 	if (idle)
 		goto out_unlock;
 
+	/*
+	 * if we have relooped after returning idle once, we need to update our
+	 * status as actually running, so that other cpus doing
+	 * __start_cfs_bandwidth will stop trying to cancel us.
+	 */
+	cfs_b->timer_active = 1;
+
 	__refill_cfs_bandwidth_runtime(cfs_b);
 
 	if (!throttled) {
@@ -2508,7 +3294,13 @@ static const u64 min_bandwidth_expiration = 2 * NSEC_PER_MSEC;
 /* how long we wait to gather additional slack before distributing */
 static const u64 cfs_bandwidth_slack_period = 5 * NSEC_PER_MSEC;
 
-/* are we near the end of the current quota period? */
+/*
+ * Are we near the end of the current quota period?
+ *
+ * Requires cfs_b->lock for hrtimer_expires_remaining to be safe against the
+ * hrtimer base being cleared by __hrtimer_start_range_ns. In the case of
+ * migrate_hrtimers, base is never cleared, so we are fine.
+ */
 static int runtime_refresh_within(struct cfs_bandwidth *cfs_b, u64 min_expire)
 {
 	struct hrtimer *refresh_timer = &cfs_b->period_timer;
@@ -2584,10 +3376,12 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
 	u64 expires;
 
 	/* confirm we're still not at a refresh boundary */
-	if (runtime_refresh_within(cfs_b, min_bandwidth_expiration))
+	raw_spin_lock(&cfs_b->lock);
+	if (runtime_refresh_within(cfs_b, min_bandwidth_expiration)) {
+		raw_spin_unlock(&cfs_b->lock);
 		return;
+	}
 
-	raw_spin_lock(&cfs_b->lock);
 	if (cfs_b->quota != RUNTIME_INF && cfs_b->runtime > slice) {
 		runtime = cfs_b->runtime;
 		cfs_b->runtime = 0;
@@ -2708,11 +3502,11 @@ void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	 * (timer_active==0 becomes visible before the hrtimer call-back
 	 * terminates).  In either case we ensure that it's re-programmed
 	 */
-	while (unlikely(hrtimer_active(&cfs_b->period_timer))) {
+	while (unlikely(hrtimer_active(&cfs_b->period_timer)) &&
+	       hrtimer_try_to_cancel(&cfs_b->period_timer) < 0) {
+		/* bounce the lock to allow do_sched_cfs_period_timer to run */
 		raw_spin_unlock(&cfs_b->lock);
-		/* ensure cfs_b->lock is available while we wait */
-		hrtimer_cancel(&cfs_b->period_timer);
-
+		cpu_relax();
 		raw_spin_lock(&cfs_b->lock);
 		/* if someone else restarted the timer then we're done */
 		if (cfs_b->timer_active)
@@ -3113,7 +3907,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 {
 	struct sched_entity *se = tg->se[cpu];
 
-	if (!tg->parent)	/* the trivial, non-cgroup case */
+	if (!tg->parent || !wl)	/* the trivial, non-cgroup case */
 		return wl;
 
 	for_each_sched_entity(se) {
@@ -3166,8 +3960,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 }
 #else
 
-static inline unsigned long effective_load(struct task_group *tg, int cpu,
-		unsigned long wl, unsigned long wg)
+static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 {
 	return wl;
 }
@@ -3420,11 +4213,10 @@ done:
  * preempt must be disabled.
  */
 static int
-select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
+select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_flags)
 {
 	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
 	int cpu = smp_processor_id();
-	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
 	int want_affine = 0;
 	int sync = wake_flags & WF_SYNC;
@@ -3904,9 +4696,12 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
 
 static unsigned long __read_mostly max_load_balance_interval = HZ/10;
 
+enum fbq_type { regular, remote, all };
+
 #define LBF_ALL_PINNED	0x01
 #define LBF_NEED_BREAK	0x02
-#define LBF_SOME_PINNED 0x04
+#define LBF_DST_PINNED  0x04
+#define LBF_SOME_PINNED	0x08
 
 struct lb_env {
 	struct sched_domain	*sd;
@@ -3929,6 +4724,8 @@ struct lb_env {
 	unsigned int		loop;
 	unsigned int		loop_break;
 	unsigned int		loop_max;
+
+	enum fbq_type		fbq_type;
 };
 
 /*
@@ -3975,6 +4772,78 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	return delta < (s64)sysctl_sched_migration_cost;
 }
 
+#ifdef CONFIG_NUMA_BALANCING
+/* Returns true if the destination node has incurred more faults */
+static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
+{
+	int src_nid, dst_nid;
+
+	if (!sched_feat(NUMA_FAVOUR_HIGHER) || !p->numa_faults ||
+	    !(env->sd->flags & SD_NUMA)) {
+		return false;
+	}
+
+	src_nid = cpu_to_node(env->src_cpu);
+	dst_nid = cpu_to_node(env->dst_cpu);
+
+	if (src_nid == dst_nid)
+		return false;
+
+	/* Always encourage migration to the preferred node. */
+	if (dst_nid == p->numa_preferred_nid)
+		return true;
+
+	/* If both task and group weight improve, this move is a winner. */
+	if (task_weight(p, dst_nid) > task_weight(p, src_nid) &&
+	    group_weight(p, dst_nid) > group_weight(p, src_nid))
+		return true;
+
+	return false;
+}
+
+
+static bool migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
+{
+	int src_nid, dst_nid;
+
+	if (!sched_feat(NUMA) || !sched_feat(NUMA_RESIST_LOWER))
+		return false;
+
+	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
+		return false;
+
+	src_nid = cpu_to_node(env->src_cpu);
+	dst_nid = cpu_to_node(env->dst_cpu);
+
+	if (src_nid == dst_nid)
+		return false;
+
+	/* Migrating away from the preferred node is always bad. */
+	if (src_nid == p->numa_preferred_nid)
+		return true;
+
+	/* If either task or group weight get worse, don't do it. */
+	if (task_weight(p, dst_nid) < task_weight(p, src_nid) ||
+	    group_weight(p, dst_nid) < group_weight(p, src_nid))
+		return true;
+
+	return false;
+}
+
+#else
+static inline bool migrate_improves_locality(struct task_struct *p,
+					     struct lb_env *env)
+{
+	return false;
+}
+
+static inline bool migrate_degrades_locality(struct task_struct *p,
+					     struct lb_env *env)
+{
+	return false;
+}
+#endif
+
 /*
  * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
  */
@@ -3997,6 +4866,8 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 
 		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
 
+		env->flags |= LBF_SOME_PINNED;
+
 		/*
 		 * Remember if this task can be migrated to any other cpu in
 		 * our sched_group. We may want to revisit it if we couldn't
@@ -4005,13 +4876,13 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 		 * Also avoid computing new_dst_cpu if we have already computed
 		 * one in current iteration.
 		 */
-		if (!env->dst_grpmask || (env->flags & LBF_SOME_PINNED))
+		if (!env->dst_grpmask || (env->flags & LBF_DST_PINNED))
 			return 0;
 
 		/* Prevent to re-select dst_cpu via env's cpus */
 		for_each_cpu_and(cpu, env->dst_grpmask, env->cpus) {
 			if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) {
-				env->flags |= LBF_SOME_PINNED;
+				env->flags |= LBF_DST_PINNED;
 				env->new_dst_cpu = cpu;
 				break;
 			}
@@ -4030,11 +4901,24 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 
 	/*
 	 * Aggressive migration if:
-	 * 1) task is cache cold, or
-	 * 2) too many balance attempts have failed.
+	 * 1) destination numa is preferred
+	 * 2) task is cache cold, or
+	 * 3) too many balance attempts have failed.
 	 */
-
 	tsk_cache_hot = task_hot(p, rq_clock_task(env->src_rq), env->sd);
+	if (!tsk_cache_hot)
+		tsk_cache_hot = migrate_degrades_locality(p, env);
+
+	if (migrate_improves_locality(p, env)) {
+#ifdef CONFIG_SCHEDSTATS
+		if (tsk_cache_hot) {
+			schedstat_inc(env->sd, lb_hot_gained[env->idle]);
+			schedstat_inc(p, se.statistics.nr_forced_migrations);
+		}
+#endif
+		return 1;
+	}
+
 	if (!tsk_cache_hot ||
 		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
 
@@ -4077,8 +4961,6 @@ static int move_one_task(struct lb_env *env)
 	return 0;
 }
 
-static unsigned long task_h_load(struct task_struct *p);
-
 static const unsigned int sched_nr_migrate_break = 32;
 
 /*
@@ -4291,6 +5173,10 @@ struct sg_lb_stats {
 	unsigned int group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
 	int group_has_capacity; /* Is there extra capacity in the group? */
+#ifdef CONFIG_NUMA_BALANCING
+	unsigned int nr_numa_running;
+	unsigned int nr_preferred_running;
+#endif
 };
 
 /*
@@ -4330,7 +5216,7 @@ static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
 /**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
- * @idle: The Idle status of the CPU for whose sd load_icx is obtained.
+ * @idle: The idle status of the CPU for whose sd load_idx is obtained.
  *
  * Return: The load index.
  */
@@ -4447,7 +5333,7 @@ void update_group_power(struct sched_domain *sd, int cpu)
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
-	unsigned long power;
+	unsigned long power, power_orig;
 	unsigned long interval;
 
 	interval = msecs_to_jiffies(sd->balance_interval);
@@ -4459,7 +5345,7 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		return;
 	}
 
-	power = 0;
+	power_orig = power = 0;
 
 	if (child->flags & SD_OVERLAP) {
 		/*
@@ -4467,8 +5353,12 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		 * span the current group.
 		 */
 
-		for_each_cpu(cpu, sched_group_cpus(sdg))
-			power += power_of(cpu);
+		for_each_cpu(cpu, sched_group_cpus(sdg)) {
+			struct sched_group *sg = cpu_rq(cpu)->sd->groups;
+
+			power_orig += sg->sgp->power_orig;
+			power += sg->sgp->power;
+		}
 	} else  {
 		/*
 		 * !SD_OVERLAP domains can assume that child groups
@@ -4477,12 +5367,14 @@ void update_group_power(struct sched_domain *sd, int cpu)
 
 		group = child->groups;
 		do {
+			power_orig += group->sgp->power_orig;
 			power += group->sgp->power;
 			group = group->next;
 		} while (group != child->groups);
 	}
 
-	sdg->sgp->power_orig = sdg->sgp->power = power;
+	sdg->sgp->power_orig = power_orig;
+	sdg->sgp->power = power;
 }
 
 /*
@@ -4526,13 +5418,12 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  * cpu 3 and leave one of the cpus in the second group unused.
  *
  * The current solution to this issue is detecting the skew in the first group
- * by noticing it has a cpu that is overloaded while the remaining cpus are
- * idle -- or rather, there's a distinct imbalance in the cpus; see
- * sg_imbalanced().
+ * by noticing the lower domain failed to reach balance and had difficulty
+ * moving tasks due to affinity constraints.
  *
  * When this is so detected; this group becomes a candidate for busiest; see
- * update_sd_pick_busiest(). And calculcate_imbalance() and
- * find_busiest_group() avoid some of the usual balance conditional to allow it
+ * update_sd_pick_busiest(). And calculate_imbalance() and
+ * find_busiest_group() avoid some of the usual balance conditions to allow it
  * to create an effective group imbalance.
  *
  * This is a somewhat tricky proposition since the next run might not find the
@@ -4540,49 +5431,36 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  * subtle and fragile situation.
  */
 
-struct sg_imb_stats {
-	unsigned long max_nr_running, min_nr_running;
-	unsigned long max_cpu_load, min_cpu_load;
-};
-
-static inline void init_sg_imb_stats(struct sg_imb_stats *sgi)
+static inline int sg_imbalanced(struct sched_group *group)
 {
-	sgi->max_cpu_load = sgi->max_nr_running = 0UL;
-	sgi->min_cpu_load = sgi->min_nr_running = ~0UL;
+	return group->sgp->imbalance;
 }
 
-static inline void
-update_sg_imb_stats(struct sg_imb_stats *sgi,
-		    unsigned long load, unsigned long nr_running)
+/*
+ * Compute the group capacity.
+ *
+ * Avoid the issue where N*frac(smt_power) >= 1 creates 'phantom' cores by
+ * first dividing out the smt factor and computing the actual number of cores
+ * and limit power unit capacity with that.
+ */
+static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
 {
-	if (load > sgi->max_cpu_load)
-		sgi->max_cpu_load = load;
-	if (sgi->min_cpu_load > load)
-		sgi->min_cpu_load = load;
+	unsigned int capacity, smt, cpus;
+	unsigned int power, power_orig;
 
-	if (nr_running > sgi->max_nr_running)
-		sgi->max_nr_running = nr_running;
-	if (sgi->min_nr_running > nr_running)
-		sgi->min_nr_running = nr_running;
-}
+	power = group->sgp->power;
+	power_orig = group->sgp->power_orig;
+	cpus = group->group_weight;
 
-static inline int
-sg_imbalanced(struct sg_lb_stats *sgs, struct sg_imb_stats *sgi)
-{
-	/*
-	 * Consider the group unbalanced when the imbalance is larger
-	 * than the average weight of a task.
-	 *
-	 * APZ: with cgroup the avg task weight can vary wildly and
-	 *      might not be a suitable number - should we keep a
-	 *      normalized nr_running number somewhere that negates
-	 *      the hierarchy?
-	 */
-	if ((sgi->max_cpu_load - sgi->min_cpu_load) >= sgs->load_per_task &&
-	    (sgi->max_nr_running - sgi->min_nr_running) > 1)
-		return 1;
+	/* smt := ceil(cpus / power), assumes: 1 < smt_power < 2 */
+	smt = DIV_ROUND_UP(SCHED_POWER_SCALE * cpus, power_orig);
+	capacity = cpus / smt; /* cores */
 
-	return 0;
+	capacity = min_t(unsigned, capacity, DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE));
+	if (!capacity)
+		capacity = fix_small_capacity(env->sd, group);
+
+	return capacity;
 }
 
 /**
@@ -4597,12 +5475,11 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			struct sched_group *group, int load_idx,
 			int local_group, struct sg_lb_stats *sgs)
 {
-	struct sg_imb_stats sgi;
 	unsigned long nr_running;
 	unsigned long load;
 	int i;
 
-	init_sg_imb_stats(&sgi);
+	memset(sgs, 0, sizeof(*sgs));
 
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		struct rq *rq = cpu_rq(i);
@@ -4610,24 +5487,22 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		nr_running = rq->nr_running;
 
 		/* Bias balancing toward cpus of our domain */
-		if (local_group) {
+		if (local_group)
 			load = target_load(i, load_idx);
-		} else {
+		else
 			load = source_load(i, load_idx);
-			update_sg_imb_stats(&sgi, load, nr_running);
-		}
 
 		sgs->group_load += load;
 		sgs->sum_nr_running += nr_running;
+#ifdef CONFIG_NUMA_BALANCING
+		sgs->nr_numa_running += rq->nr_numa_running;
+		sgs->nr_preferred_running += rq->nr_preferred_running;
+#endif
 		sgs->sum_weighted_load += weighted_cpuload(i);
 		if (idle_cpu(i))
 			sgs->idle_cpus++;
 	}
 
-	if (local_group && (env->idle != CPU_NEWLY_IDLE ||
-			time_after_eq(jiffies, group->sgp->next_update)))
-		update_group_power(env->sd, env->dst_cpu);
-
 	/* Adjust by relative CPU power of the group */
 	sgs->group_power = group->sgp->power;
 	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / sgs->group_power;
@@ -4635,16 +5510,11 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	if (sgs->sum_nr_running)
 		sgs->load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
-	sgs->group_imb = sg_imbalanced(sgs, &sgi);
-
-	sgs->group_capacity =
-		DIV_ROUND_CLOSEST(sgs->group_power, SCHED_POWER_SCALE);
-
-	if (!sgs->group_capacity)
-		sgs->group_capacity = fix_small_capacity(env->sd, group);
-
 	sgs->group_weight = group->group_weight;
 
+	sgs->group_imb = sg_imbalanced(group);
+	sgs->group_capacity = sg_capacity(env, group);
+
 	if (sgs->group_capacity > sgs->sum_nr_running)
 		sgs->group_has_capacity = 1;
 }
@@ -4693,14 +5563,42 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	return false;
 }
 
+#ifdef CONFIG_NUMA_BALANCING
+static inline enum fbq_type fbq_classify_group(struct sg_lb_stats *sgs)
+{
+	if (sgs->sum_nr_running > sgs->nr_numa_running)
+		return regular;
+	if (sgs->sum_nr_running > sgs->nr_preferred_running)
+		return remote;
+	return all;
+}
+
+static inline enum fbq_type fbq_classify_rq(struct rq *rq)
+{
+	if (rq->nr_running > rq->nr_numa_running)
+		return regular;
+	if (rq->nr_running > rq->nr_preferred_running)
+		return remote;
+	return all;
+}
+#else
+static inline enum fbq_type fbq_classify_group(struct sg_lb_stats *sgs)
+{
+	return all;
+}
+
+static inline enum fbq_type fbq_classify_rq(struct rq *rq)
+{
+	return regular;
+}
+#endif /* CONFIG_NUMA_BALANCING */
+
 /**
  * update_sd_lb_stats - Update sched_domain's statistics for load balancing.
  * @env: The load balancing environment.
- * @balance: Should we balance.
  * @sds: variable to hold the statistics for this sched_domain.
  */
-static inline void update_sd_lb_stats(struct lb_env *env,
-					struct sd_lb_stats *sds)
+static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sds)
 {
 	struct sched_domain *child = env->sd->child;
 	struct sched_group *sg = env->sd->groups;
@@ -4720,11 +5618,17 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 		if (local_group) {
 			sds->local = sg;
 			sgs = &sds->local_stat;
+
+			if (env->idle != CPU_NEWLY_IDLE ||
+			    time_after_eq(jiffies, sg->sgp->next_update))
+				update_group_power(env->sd, env->dst_cpu);
 		}
 
-		memset(sgs, 0, sizeof(*sgs));
 		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
 
+		if (local_group)
+			goto next_group;
+
 		/*
 		 * In case the child domain prefers tasks go to siblings
 		 * first, lower the sg capacity to one so that we'll try
@@ -4735,21 +5639,25 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 		 * heaviest group when it is already under-utilized (possible
 		 * with a large weight task outweighs the tasks on the system).
 		 */
-		if (prefer_sibling && !local_group &&
-				sds->local && sds->local_stat.group_has_capacity)
+		if (prefer_sibling && sds->local &&
+		    sds->local_stat.group_has_capacity)
 			sgs->group_capacity = min(sgs->group_capacity, 1U);
 
-		/* Now, start updating sd_lb_stats */
-		sds->total_load += sgs->group_load;
-		sds->total_pwr += sgs->group_power;
-
-		if (!local_group && update_sd_pick_busiest(env, sds, sg, sgs)) {
+		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
 			sds->busiest_stat = *sgs;
 		}
 
+next_group:
+		/* Now, start updating sd_lb_stats */
+		sds->total_load += sgs->group_load;
+		sds->total_pwr += sgs->group_power;
+
 		sg = sg->next;
 	} while (sg != env->sd->groups);
+
+	if (env->sd->flags & SD_NUMA)
+		env->fbq_type = fbq_classify_group(&sds->busiest_stat);
 }
 
 /**
@@ -5053,15 +5961,39 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 	int i;
 
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
-		unsigned long power = power_of(i);
-		unsigned long capacity = DIV_ROUND_CLOSEST(power,
-							   SCHED_POWER_SCALE);
-		unsigned long wl;
+		unsigned long power, capacity, wl;
+		enum fbq_type rt;
+
+		rq = cpu_rq(i);
+		rt = fbq_classify_rq(rq);
+
+		/*
+		 * We classify groups/runqueues into three groups:
+		 *  - regular: there are !numa tasks
+		 *  - remote:  there are numa tasks that run on the 'wrong' node
+		 *  - all:     there is no distinction
+		 *
+		 * In order to avoid migrating ideally placed numa tasks,
+		 * ignore those when there's better options.
+		 *
+		 * If we ignore the actual busiest queue to migrate another
+		 * task, the next balance pass can still reduce the busiest
+		 * queue by moving tasks around inside the node.
+		 *
+		 * If we cannot move enough load due to this classification
+		 * the next pass will adjust the group classification and
+		 * allow migration of more tasks.
+		 *
+		 * Both cases only affect the total convergence complexity.
+		 */
+		if (rt > env->fbq_type)
+			continue;
 
+		power = power_of(i);
+		capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
 		if (!capacity)
 			capacity = fix_small_capacity(env->sd, group);
 
-		rq = cpu_rq(i);
 		wl = weighted_cpuload(i);
 
 		/*
@@ -5164,6 +6096,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			int *continue_balancing)
 {
 	int ld_moved, cur_ld_moved, active_balance = 0;
+	struct sched_domain *sd_parent = sd->parent;
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
@@ -5177,6 +6110,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.idle		= idle,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
+		.fbq_type	= all,
 	};
 
 	/*
@@ -5268,17 +6202,17 @@ more_balance:
 		 * moreover subsequent load balance cycles should correct the
 		 * excess load moved.
 		 */
-		if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0) {
+		if ((env.flags & LBF_DST_PINNED) && env.imbalance > 0) {
+
+			/* Prevent to re-select dst_cpu via env's cpus */
+			cpumask_clear_cpu(env.dst_cpu, env.cpus);
 
 			env.dst_rq	 = cpu_rq(env.new_dst_cpu);
 			env.dst_cpu	 = env.new_dst_cpu;
-			env.flags	&= ~LBF_SOME_PINNED;
+			env.flags	&= ~LBF_DST_PINNED;
 			env.loop	 = 0;
 			env.loop_break	 = sched_nr_migrate_break;
 
-			/* Prevent to re-select dst_cpu via env's cpus */
-			cpumask_clear_cpu(env.dst_cpu, env.cpus);
-
 			/*
 			 * Go back to "more_balance" rather than "redo" since we
 			 * need to continue with same src_cpu.
@@ -5286,6 +6220,18 @@ more_balance:
 			goto more_balance;
 		}
 
+		/*
+		 * We failed to reach balance because of affinity.
+		 */
+		if (sd_parent) {
+			int *group_imbalance = &sd_parent->groups->sgp->imbalance;
+
+			if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0) {
+				*group_imbalance = 1;
+			} else if (*group_imbalance)
+				*group_imbalance = 0;
+		}
+
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(env.flags & LBF_ALL_PINNED)) {
 			cpumask_clear_cpu(cpu_of(busiest), cpus);
@@ -5393,6 +6339,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	struct sched_domain *sd;
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
+	u64 curr_cost = 0;
 
 	this_rq->idle_stamp = rq_clock(this_rq);
 
@@ -5409,15 +6356,27 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int continue_balancing = 1;
+		u64 t0, domain_cost;
 
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
+		if (this_rq->avg_idle < curr_cost + sd->max_newidle_lb_cost)
+			break;
+
 		if (sd->flags & SD_BALANCE_NEWIDLE) {
+			t0 = sched_clock_cpu(this_cpu);
+
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance(this_cpu, this_rq,
 						   sd, CPU_NEWLY_IDLE,
 						   &continue_balancing);
+
+			domain_cost = sched_clock_cpu(this_cpu) - t0;
+			if (domain_cost > sd->max_newidle_lb_cost)
+				sd->max_newidle_lb_cost = domain_cost;
+
+			curr_cost += domain_cost;
 		}
 
 		interval = msecs_to_jiffies(sd->balance_interval);
@@ -5439,6 +6398,9 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 		 */
 		this_rq->next_balance = next_balance;
 	}
+
+	if (curr_cost > this_rq->max_idle_balance_cost)
+		this_rq->max_idle_balance_cost = curr_cost;
 }
 
 /*
@@ -5572,16 +6534,16 @@ static inline void nohz_balance_exit_idle(int cpu)
 static inline void set_cpu_sd_state_busy(void)
 {
 	struct sched_domain *sd;
+	int cpu = smp_processor_id();
 
 	rcu_read_lock();
-	sd = rcu_dereference_check_sched_domain(this_rq()->sd);
+	sd = rcu_dereference(per_cpu(sd_busy, cpu));
 
 	if (!sd || !sd->nohz_idle)
 		goto unlock;
 	sd->nohz_idle = 0;
 
-	for (; sd; sd = sd->parent)
-		atomic_inc(&sd->groups->sgp->nr_busy_cpus);
+	atomic_inc(&sd->groups->sgp->nr_busy_cpus);
 unlock:
 	rcu_read_unlock();
 }
@@ -5589,16 +6551,16 @@ unlock:
 void set_cpu_sd_state_idle(void)
 {
 	struct sched_domain *sd;
+	int cpu = smp_processor_id();
 
 	rcu_read_lock();
-	sd = rcu_dereference_check_sched_domain(this_rq()->sd);
+	sd = rcu_dereference(per_cpu(sd_busy, cpu));
 
 	if (!sd || sd->nohz_idle)
 		goto unlock;
 	sd->nohz_idle = 1;
 
-	for (; sd; sd = sd->parent)
-		atomic_dec(&sd->groups->sgp->nr_busy_cpus);
+	atomic_dec(&sd->groups->sgp->nr_busy_cpus);
 unlock:
 	rcu_read_unlock();
 }
@@ -5662,15 +6624,39 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	/* Earliest time when we have to do rebalance again */
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
-	int need_serialize;
+	int need_serialize, need_decay = 0;
+	u64 max_cost = 0;
 
 	update_blocked_averages(cpu);
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
+		/*
+		 * Decay the newidle max times here because this is a regular
+		 * visit to all the domains. Decay ~1% per second.
+		 */
+		if (time_after(jiffies, sd->next_decay_max_lb_cost)) {
+			sd->max_newidle_lb_cost =
+				(sd->max_newidle_lb_cost * 253) / 256;
+			sd->next_decay_max_lb_cost = jiffies + HZ;
+			need_decay = 1;
+		}
+		max_cost += sd->max_newidle_lb_cost;
+
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
+		/*
+		 * Stop the load balance at this level. There is another
+		 * CPU in our sched group which is doing load balancing more
+		 * actively.
+		 */
+		if (!continue_balancing) {
+			if (need_decay)
+				continue;
+			break;
+		}
+
 		interval = sd->balance_interval;
 		if (idle != CPU_IDLE)
 			interval *= sd->busy_factor;
@@ -5689,7 +6675,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
 			if (load_balance(cpu, rq, sd, idle, &continue_balancing)) {
 				/*
-				 * The LBF_SOME_PINNED logic could have changed
+				 * The LBF_DST_PINNED logic could have changed
 				 * env->dst_cpu, so we can't know our idle
 				 * state even if we migrated tasks. Update it.
 				 */
@@ -5704,14 +6690,14 @@ out:
 			next_balance = sd->last_balance + interval;
 			update_next_balance = 1;
 		}
-
+	}
+	if (need_decay) {
 		/*
-		 * Stop the load balance at this level. There is another
-		 * CPU in our sched group which is doing load balancing more
-		 * actively.
+		 * Ensure the rq-wide value also decays but keep it at a
+		 * reasonable floor to avoid funnies with rq->avg_idle.
 		 */
-		if (!continue_balancing)
-			break;
+		rq->max_idle_balance_cost =
+			max((u64)sysctl_sched_migration_cost, max_cost);
 	}
 	rcu_read_unlock();
 
@@ -5781,6 +6767,8 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 {
 	unsigned long now = jiffies;
 	struct sched_domain *sd;
+	struct sched_group_power *sgp;
+	int nr_busy;
 
 	if (unlikely(idle_cpu(cpu)))
 		return 0;
@@ -5806,22 +6794,22 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 		goto need_kick;
 
 	rcu_read_lock();
-	for_each_domain(cpu, sd) {
-		struct sched_group *sg = sd->groups;
-		struct sched_group_power *sgp = sg->sgp;
-		int nr_busy = atomic_read(&sgp->nr_busy_cpus);
+	sd = rcu_dereference(per_cpu(sd_busy, cpu));
 
-		if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
-			goto need_kick_unlock;
+	if (sd) {
+		sgp = sd->groups->sgp;
+		nr_busy = atomic_read(&sgp->nr_busy_cpus);
 
-		if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
-		    && (cpumask_first_and(nohz.idle_cpus_mask,
-					  sched_domain_span(sd)) < cpu))
+		if (nr_busy > 1)
 			goto need_kick_unlock;
-
-		if (!(sd->flags & (SD_SHARE_PKG_RESOURCES | SD_ASYM_PACKING)))
-			break;
 	}
+
+	sd = rcu_dereference(per_cpu(sd_asym, cpu));
+
+	if (sd && (cpumask_first_and(nohz.idle_cpus_mask,
+				  sched_domain_span(sd)) < cpu))
+		goto need_kick_unlock;
+
 	rcu_read_unlock();
 	return 0;
 
@@ -6214,7 +7202,8 @@ void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 		se->cfs_rq = parent->my_q;
 
 	se->my_q = cfs_rq;
-	update_load_set(&se->load, 0);
+	/* guarantee group entities always have weight */
+	update_load_set(&se->load, NICE_0_LOAD);
 	se->parent = parent;
 }
 
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 99399f8..5716929 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -63,10 +63,23 @@ SCHED_FEAT(LB_MIN, false)
 /*
  * Apply the automatic NUMA scheduling policy. Enabled automatically
  * at runtime if running on a NUMA machine. Can be controlled via
- * numa_balancing=. Allow PTE scanning to be forced on UMA machines
- * for debugging the core machinery.
+ * numa_balancing=
  */
 #ifdef CONFIG_NUMA_BALANCING
 SCHED_FEAT(NUMA,	false)
-SCHED_FEAT(NUMA_FORCE,	false)
+
+/*
+ * NUMA_FAVOUR_HIGHER will favor moving tasks towards nodes where a
+ * higher number of hinting faults are recorded during active load
+ * balancing.
+ */
+SCHED_FEAT(NUMA_FAVOUR_HIGHER, true)
+
+/*
+ * NUMA_RESIST_LOWER will resist moving tasks towards nodes where a
+ * lower number of hinting faults have been recorded. As this has
+ * the potential to prevent a task ever migrating to a new node
+ * due to CPU overload it is disabled by default.
+ */
+SCHED_FEAT(NUMA_RESIST_LOWER, false)
 #endif
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index d8da010..516c3d9 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -9,7 +9,7 @@
 
 #ifdef CONFIG_SMP
 static int
-select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
+select_task_rq_idle(struct task_struct *p, int cpu, int sd_flag, int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 01970c8..7d57275 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -246,8 +246,10 @@ static inline void rt_set_overload(struct rq *rq)
 	 * if we should look at the mask. It would be a shame
 	 * if we looked at the mask, but the mask was not
 	 * updated yet.
+	 *
+	 * Matched by the barrier in pull_rt_task().
 	 */
-	wmb();
+	smp_wmb();
 	atomic_inc(&rq->rd->rto_count);
 }
 
@@ -1169,13 +1171,10 @@ static void yield_task_rt(struct rq *rq)
 static int find_lowest_rq(struct task_struct *task);
 
 static int
-select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
+select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
 {
 	struct task_struct *curr;
 	struct rq *rq;
-	int cpu;
-
-	cpu = task_cpu(p);
 
 	if (p->nr_cpus_allowed == 1)
 		goto out;
@@ -1213,8 +1212,7 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 	 */
 	if (curr && unlikely(rt_task(curr)) &&
 	    (curr->nr_cpus_allowed < 2 ||
-	     curr->prio <= p->prio) &&
-	    (p->nr_cpus_allowed > 1)) {
+	     curr->prio <= p->prio)) {
 		int target = find_lowest_rq(p);
 
 		if (target != -1)
@@ -1630,6 +1628,12 @@ static int pull_rt_task(struct rq *this_rq)
 	if (likely(!rt_overloaded(this_rq)))
 		return 0;
 
+	/*
+	 * Match the barrier from rt_set_overloaded; this guarantees that if we
+	 * see overloaded we must also see the rto_mask bit.
+	 */
+	smp_rmb();
+
 	for_each_cpu(cpu, this_rq->rd->rto_mask) {
 		if (this_cpu == cpu)
 			continue;
@@ -1931,8 +1935,8 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 	p->rt.time_slice = sched_rr_timeslice;
 
 	/*
-	 * Requeue to the end of queue if we (and all of our ancestors) are the
-	 * only element on the queue
+	 * Requeue to the end of queue if we (and all of our ancestors) are not
+	 * the only element on the queue
 	 */
 	for_each_sched_rt_entity(rt_se) {
 		if (rt_se->run_list.prev != rt_se->run_list.next) {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b3c5653..88c85b2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -6,6 +6,7 @@
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
 #include <linux/tick.h>
+#include <linux/slab.h>
 
 #include "cpupri.h"
 #include "cpuacct.h"
@@ -408,6 +409,10 @@ struct rq {
 	 * remote CPUs use both these fields when doing load calculation.
 	 */
 	unsigned int nr_running;
+#ifdef CONFIG_NUMA_BALANCING
+	unsigned int nr_numa_running;
+	unsigned int nr_preferred_running;
+#endif
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 	unsigned long last_load_update_tick;
@@ -476,6 +481,9 @@ struct rq {
 	u64 age_stamp;
 	u64 idle_stamp;
 	u64 avg_idle;
+
+	/* This is used to determine avg_idle's max value */
+	u64 max_idle_balance_cost;
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
@@ -552,6 +560,12 @@ static inline u64 rq_clock_task(struct rq *rq)
 	return rq->clock_task;
 }
 
+#ifdef CONFIG_NUMA_BALANCING
+extern void sched_setnuma(struct task_struct *p, int node);
+extern int migrate_task_to(struct task_struct *p, int cpu);
+extern int migrate_swap(struct task_struct *, struct task_struct *);
+#endif /* CONFIG_NUMA_BALANCING */
+
 #ifdef CONFIG_SMP
 
 #define rcu_dereference_check_sched_domain(p) \
@@ -593,9 +607,24 @@ static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
 	return hsd;
 }
 
+static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
+{
+	struct sched_domain *sd;
+
+	for_each_domain(cpu, sd) {
+		if (sd->flags & flag)
+			break;
+	}
+
+	return sd;
+}
+
 DECLARE_PER_CPU(struct sched_domain *, sd_llc);
 DECLARE_PER_CPU(int, sd_llc_size);
 DECLARE_PER_CPU(int, sd_llc_id);
+DECLARE_PER_CPU(struct sched_domain *, sd_numa);
+DECLARE_PER_CPU(struct sched_domain *, sd_busy);
+DECLARE_PER_CPU(struct sched_domain *, sd_asym);
 
 struct sched_group_power {
 	atomic_t ref;
@@ -605,6 +634,7 @@ struct sched_group_power {
 	 */
 	unsigned int power, power_orig;
 	unsigned long next_update;
+	int imbalance; /* XXX unrelated to power but shared group state */
 	/*
 	 * Number of busy cpus in this group.
 	 */
@@ -719,6 +749,7 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 	 */
 	smp_wmb();
 	task_thread_info(p)->cpu = cpu;
+	p->wake_cpu = cpu;
 #endif
 }
 
@@ -974,7 +1005,7 @@ struct sched_class {
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
-	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
+	int  (*select_task_rq)(struct task_struct *p, int task_cpu, int sd_flag, int flags);
 	void (*migrate_task_rq)(struct task_struct *p, int next_cpu);
 
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
@@ -1220,6 +1251,24 @@ static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
 	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
 }
 
+static inline void double_lock(spinlock_t *l1, spinlock_t *l2)
+{
+	if (l1 > l2)
+		swap(l1, l2);
+
+	spin_lock(l1);
+	spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
+}
+
+static inline void double_raw_lock(raw_spinlock_t *l1, raw_spinlock_t *l2)
+{
+	if (l1 > l2)
+		swap(l1, l2);
+
+	raw_spin_lock(l1);
+	raw_spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
+}
+
 /*
  * double_rq_lock - safely lock two runqueues
  *
@@ -1305,7 +1354,8 @@ extern void print_rt_stats(struct seq_file *m, int cpu);
 extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
 
-extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
+extern void cfs_bandwidth_usage_inc(void);
+extern void cfs_bandwidth_usage_dec(void);
 
 #ifdef CONFIG_NO_HZ_COMMON
 enum rq_nohz_flag_bits {
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index c7edee7..4ab7043 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -59,9 +59,9 @@ static inline void sched_info_reset_dequeued(struct task_struct *t)
  * from dequeue_task() to account for possible rq->clock skew across cpus. The
  * delta taken on each cpu would annul the skew.
  */
-static inline void sched_info_dequeued(struct task_struct *t)
+static inline void sched_info_dequeued(struct rq *rq, struct task_struct *t)
 {
-	unsigned long long now = rq_clock(task_rq(t)), delta = 0;
+	unsigned long long now = rq_clock(rq), delta = 0;
 
 	if (unlikely(sched_info_on()))
 		if (t->sched_info.last_queued)
@@ -69,7 +69,7 @@ static inline void sched_info_dequeued(struct task_struct *t)
 	sched_info_reset_dequeued(t);
 	t->sched_info.run_delay += delta;
 
-	rq_sched_info_dequeued(task_rq(t), delta);
+	rq_sched_info_dequeued(rq, delta);
 }
 
 /*
@@ -77,9 +77,9 @@ static inline void sched_info_dequeued(struct task_struct *t)
  * long it was waiting to run.  We also note when it began so that we
  * can keep stats on how long its timeslice is.
  */
-static void sched_info_arrive(struct task_struct *t)
+static void sched_info_arrive(struct rq *rq, struct task_struct *t)
 {
-	unsigned long long now = rq_clock(task_rq(t)), delta = 0;
+	unsigned long long now = rq_clock(rq), delta = 0;
 
 	if (t->sched_info.last_queued)
 		delta = now - t->sched_info.last_queued;
@@ -88,7 +88,7 @@ static void sched_info_arrive(struct task_struct *t)
 	t->sched_info.last_arrival = now;
 	t->sched_info.pcount++;
 
-	rq_sched_info_arrive(task_rq(t), delta);
+	rq_sched_info_arrive(rq, delta);
 }
 
 /*
@@ -96,11 +96,11 @@ static void sched_info_arrive(struct task_struct *t)
  * the timestamp if it is already not set.  It's assumed that
  * sched_info_dequeued() will clear that stamp when appropriate.
  */
-static inline void sched_info_queued(struct task_struct *t)
+static inline void sched_info_queued(struct rq *rq, struct task_struct *t)
 {
 	if (unlikely(sched_info_on()))
 		if (!t->sched_info.last_queued)
-			t->sched_info.last_queued = rq_clock(task_rq(t));
+			t->sched_info.last_queued = rq_clock(rq);
 }
 
 /*
@@ -111,15 +111,15 @@ static inline void sched_info_queued(struct task_struct *t)
  * sched_info_queued() to mark that it has now again started waiting on
  * the runqueue.
  */
-static inline void sched_info_depart(struct task_struct *t)
+static inline void sched_info_depart(struct rq *rq, struct task_struct *t)
 {
-	unsigned long long delta = rq_clock(task_rq(t)) -
+	unsigned long long delta = rq_clock(rq) -
 					t->sched_info.last_arrival;
 
-	rq_sched_info_depart(task_rq(t), delta);
+	rq_sched_info_depart(rq, delta);
 
 	if (t->state == TASK_RUNNING)
-		sched_info_queued(t);
+		sched_info_queued(rq, t);
 }
 
 /*
@@ -128,32 +128,34 @@ static inline void sched_info_depart(struct task_struct *t)
  * the idle task.)  We are only called when prev != next.
  */
 static inline void
-__sched_info_switch(struct task_struct *prev, struct task_struct *next)
+__sched_info_switch(struct rq *rq,
+		    struct task_struct *prev, struct task_struct *next)
 {
-	struct rq *rq = task_rq(prev);
-
 	/*
 	 * prev now departs the cpu.  It's not interesting to record
 	 * stats about how efficient we were at scheduling the idle
 	 * process, however.
 	 */
 	if (prev != rq->idle)
-		sched_info_depart(prev);
+		sched_info_depart(rq, prev);
 
 	if (next != rq->idle)
-		sched_info_arrive(next);
+		sched_info_arrive(rq, next);
 }
 static inline void
-sched_info_switch(struct task_struct *prev, struct task_struct *next)
+sched_info_switch(struct rq *rq,
+		  struct task_struct *prev, struct task_struct *next)
 {
 	if (unlikely(sched_info_on()))
-		__sched_info_switch(prev, next);
+		__sched_info_switch(rq, prev, next);
 }
 #else
-#define sched_info_queued(t)			do { } while (0)
+#define sched_info_queued(rq, t)		do { } while (0)
 #define sched_info_reset_dequeued(t)	do { } while (0)
-#define sched_info_dequeued(t)			do { } while (0)
-#define sched_info_switch(t, next)		do { } while (0)
+#define sched_info_dequeued(rq, t)		do { } while (0)
+#define sched_info_depart(rq, t)		do { } while (0)
+#define sched_info_arrive(rq, next)		do { } while (0)
+#define sched_info_switch(rq, t, next)		do { } while (0)
 #endif /* CONFIG_SCHEDSTATS || CONFIG_TASK_DELAY_ACCT */
 
 /*
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index e08fbee..47197de 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -11,7 +11,7 @@
 
 #ifdef CONFIG_SMP
 static int
-select_task_rq_stop(struct task_struct *p, int sd_flag, int flags)
+select_task_rq_stop(struct task_struct *p, int cpu, int sd_flag, int flags)
 {
 	return task_cpu(p); /* stop tasks as never migrate */
 }
diff --git a/kernel/wait.c b/kernel/sched/wait.c
similarity index 74%
rename from kernel/wait.c
rename to kernel/sched/wait.c
index d550920..7d50f79 100644
--- a/kernel/wait.c
+++ b/kernel/sched/wait.c
@@ -53,6 +53,109 @@ EXPORT_SYMBOL(remove_wait_queue);
 
 
 /*
+ * The core wakeup function. Non-exclusive wakeups (nr_exclusive == 0) just
+ * wake everything up. If it's an exclusive wakeup (nr_exclusive == small +ve
+ * number) then we wake all the non-exclusive tasks and one exclusive task.
+ *
+ * There are circumstances in which we can try to wake a task which has already
+ * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
+ * zero in this (rare) case, and we handle it by continuing to scan the queue.
+ */
+static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
+			int nr_exclusive, int wake_flags, void *key)
+{
+	wait_queue_t *curr, *next;
+
+	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
+		unsigned flags = curr->flags;
+
+		if (curr->func(curr, mode, wake_flags, key) &&
+				(flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
+			break;
+	}
+}
+
+/**
+ * __wake_up - wake up threads blocked on a waitqueue.
+ * @q: the waitqueue
+ * @mode: which threads
+ * @nr_exclusive: how many wake-one or wake-many threads to wake up
+ * @key: is directly passed to the wakeup function
+ *
+ * It may be assumed that this function implies a write memory barrier before
+ * changing the task state if and only if any tasks are woken up.
+ */
+void __wake_up(wait_queue_head_t *q, unsigned int mode,
+			int nr_exclusive, void *key)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+	__wake_up_common(q, mode, nr_exclusive, 0, key);
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL(__wake_up);
+
+/*
+ * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
+ */
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr)
+{
+	__wake_up_common(q, mode, nr, 0, NULL);
+}
+EXPORT_SYMBOL_GPL(__wake_up_locked);
+
+void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
+{
+	__wake_up_common(q, mode, 1, 0, key);
+}
+EXPORT_SYMBOL_GPL(__wake_up_locked_key);
+
+/**
+ * __wake_up_sync_key - wake up threads blocked on a waitqueue.
+ * @q: the waitqueue
+ * @mode: which threads
+ * @nr_exclusive: how many wake-one or wake-many threads to wake up
+ * @key: opaque value to be passed to wakeup targets
+ *
+ * The sync wakeup differs that the waker knows that it will schedule
+ * away soon, so while the target thread will be woken up, it will not
+ * be migrated to another CPU - ie. the two threads are 'synchronized'
+ * with each other. This can prevent needless bouncing between CPUs.
+ *
+ * On UP it can prevent extra preemption.
+ *
+ * It may be assumed that this function implies a write memory barrier before
+ * changing the task state if and only if any tasks are woken up.
+ */
+void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
+			int nr_exclusive, void *key)
+{
+	unsigned long flags;
+	int wake_flags = 1; /* XXX WF_SYNC */
+
+	if (unlikely(!q))
+		return;
+
+	if (unlikely(nr_exclusive != 1))
+		wake_flags = 0;
+
+	spin_lock_irqsave(&q->lock, flags);
+	__wake_up_common(q, mode, nr_exclusive, wake_flags, key);
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL_GPL(__wake_up_sync_key);
+
+/*
+ * __wake_up_sync - see __wake_up_sync_key()
+ */
+void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
+{
+	__wake_up_sync_key(q, mode, nr_exclusive, NULL);
+}
+EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
+
+/*
  * Note: we use "set_current_state()" _after_ the wait-queue add,
  * because we need a memory barrier there on SMP, so that any
  * wake-function that tests for the wait-queue being active
@@ -92,6 +195,30 @@ prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 }
 EXPORT_SYMBOL(prepare_to_wait_exclusive);
 
+long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state)
+{
+	unsigned long flags;
+
+	if (signal_pending_state(state, current))
+		return -ERESTARTSYS;
+
+	wait->private = current;
+	wait->func = autoremove_wake_function;
+
+	spin_lock_irqsave(&q->lock, flags);
+	if (list_empty(&wait->task_list)) {
+		if (wait->flags & WQ_FLAG_EXCLUSIVE)
+			__add_wait_queue_tail(q, wait);
+		else
+			__add_wait_queue(q, wait);
+	}
+	set_current_state(state);
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(prepare_to_wait_event);
+
 /**
  * finish_wait - clean up after waiting in a queue
  * @q: waitqueue waited on
diff --git a/kernel/softirq.c b/kernel/softirq.c
index d7d498d..dcab1d3 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -100,13 +100,13 @@ static void __local_bh_disable(unsigned long ip, unsigned int cnt)
 
 	raw_local_irq_save(flags);
 	/*
-	 * The preempt tracer hooks into add_preempt_count and will break
+	 * The preempt tracer hooks into preempt_count_add and will break
 	 * lockdep because it calls back into lockdep after SOFTIRQ_OFFSET
 	 * is set and before current->softirq_enabled is cleared.
 	 * We must manually increment preempt_count here and manually
 	 * call the trace_preempt_off later.
 	 */
-	preempt_count() += cnt;
+	__preempt_count_add(cnt);
 	/*
 	 * Were softirqs turned off above:
 	 */
@@ -120,7 +120,7 @@ static void __local_bh_disable(unsigned long ip, unsigned int cnt)
 #else /* !CONFIG_TRACE_IRQFLAGS */
 static inline void __local_bh_disable(unsigned long ip, unsigned int cnt)
 {
-	add_preempt_count(cnt);
+	preempt_count_add(cnt);
 	barrier();
 }
 #endif /* CONFIG_TRACE_IRQFLAGS */
@@ -139,7 +139,7 @@ static void __local_bh_enable(unsigned int cnt)
 
 	if (softirq_count() == cnt)
 		trace_softirqs_on(_RET_IP_);
-	sub_preempt_count(cnt);
+	preempt_count_sub(cnt);
 }
 
 /*
@@ -169,12 +169,12 @@ static inline void _local_bh_enable_ip(unsigned long ip)
 	 * Keep preemption disabled until we are done with
 	 * softirq processing:
  	 */
-	sub_preempt_count(SOFTIRQ_DISABLE_OFFSET - 1);
+	preempt_count_sub(SOFTIRQ_DISABLE_OFFSET - 1);
 
 	if (unlikely(!in_interrupt() && local_softirq_pending()))
 		do_softirq();
 
-	dec_preempt_count();
+	preempt_count_dec();
 #ifdef CONFIG_TRACE_IRQFLAGS
 	local_irq_enable();
 #endif
@@ -256,7 +256,7 @@ restart:
 				       " exited with %08x?\n", vec_nr,
 				       softirq_to_name[vec_nr], h->action,
 				       prev_count, preempt_count());
-				preempt_count() = prev_count;
+				preempt_count_set(prev_count);
 			}
 
 			rcu_bh_qs(cpu);
@@ -369,7 +369,7 @@ void irq_exit(void)
 
 	account_irq_exit_time(current);
 	trace_hardirq_exit();
-	sub_preempt_count(HARDIRQ_OFFSET);
+	preempt_count_sub(HARDIRQ_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index c09f295..84571e0 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -20,6 +20,7 @@
 #include <linux/kallsyms.h>
 #include <linux/smpboot.h>
 #include <linux/atomic.h>
+#include <linux/lglock.h>
 
 /*
  * Structure to determine completion condition and record errors.  May
@@ -43,6 +44,14 @@ static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
 static DEFINE_PER_CPU(struct task_struct *, cpu_stopper_task);
 static bool stop_machine_initialized = false;
 
+/*
+ * Avoids a race between stop_two_cpus and global stop_cpus, where
+ * the stoppers could get queued up in reverse order, leading to
+ * system deadlock. Using an lglock means stop_two_cpus remains
+ * relatively cheap.
+ */
+DEFINE_STATIC_LGLOCK(stop_cpus_lock);
+
 static void cpu_stop_init_done(struct cpu_stop_done *done, unsigned int nr_todo)
 {
 	memset(done, 0, sizeof(*done));
@@ -115,6 +124,184 @@ int stop_one_cpu(unsigned int cpu, cpu_stop_fn_t fn, void *arg)
 	return done.executed ? done.ret : -ENOENT;
 }
 
+/* This controls the threads on each CPU. */
+enum multi_stop_state {
+	/* Dummy starting state for thread. */
+	MULTI_STOP_NONE,
+	/* Awaiting everyone to be scheduled. */
+	MULTI_STOP_PREPARE,
+	/* Disable interrupts. */
+	MULTI_STOP_DISABLE_IRQ,
+	/* Run the function */
+	MULTI_STOP_RUN,
+	/* Exit */
+	MULTI_STOP_EXIT,
+};
+
+struct multi_stop_data {
+	int			(*fn)(void *);
+	void			*data;
+	/* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
+	unsigned int		num_threads;
+	const struct cpumask	*active_cpus;
+
+	enum multi_stop_state	state;
+	atomic_t		thread_ack;
+};
+
+static void set_state(struct multi_stop_data *msdata,
+		      enum multi_stop_state newstate)
+{
+	/* Reset ack counter. */
+	atomic_set(&msdata->thread_ack, msdata->num_threads);
+	smp_wmb();
+	msdata->state = newstate;
+}
+
+/* Last one to ack a state moves to the next state. */
+static void ack_state(struct multi_stop_data *msdata)
+{
+	if (atomic_dec_and_test(&msdata->thread_ack))
+		set_state(msdata, msdata->state + 1);
+}
+
+/* This is the cpu_stop function which stops the CPU. */
+static int multi_cpu_stop(void *data)
+{
+	struct multi_stop_data *msdata = data;
+	enum multi_stop_state curstate = MULTI_STOP_NONE;
+	int cpu = smp_processor_id(), err = 0;
+	unsigned long flags;
+	bool is_active;
+
+	/*
+	 * When called from stop_machine_from_inactive_cpu(), irq might
+	 * already be disabled.  Save the state and restore it on exit.
+	 */
+	local_save_flags(flags);
+
+	if (!msdata->active_cpus)
+		is_active = cpu == cpumask_first(cpu_online_mask);
+	else
+		is_active = cpumask_test_cpu(cpu, msdata->active_cpus);
+
+	/* Simple state machine */
+	do {
+		/* Chill out and ensure we re-read multi_stop_state. */
+		cpu_relax();
+		if (msdata->state != curstate) {
+			curstate = msdata->state;
+			switch (curstate) {
+			case MULTI_STOP_DISABLE_IRQ:
+				local_irq_disable();
+				hard_irq_disable();
+				break;
+			case MULTI_STOP_RUN:
+				if (is_active)
+					err = msdata->fn(msdata->data);
+				break;
+			default:
+				break;
+			}
+			ack_state(msdata);
+		}
+	} while (curstate != MULTI_STOP_EXIT);
+
+	local_irq_restore(flags);
+	return err;
+}
+
+struct irq_cpu_stop_queue_work_info {
+	int cpu1;
+	int cpu2;
+	struct cpu_stop_work *work1;
+	struct cpu_stop_work *work2;
+};
+
+/*
+ * This function is always run with irqs and preemption disabled.
+ * This guarantees that both work1 and work2 get queued, before
+ * our local migrate thread gets the chance to preempt us.
+ */
+static void irq_cpu_stop_queue_work(void *arg)
+{
+	struct irq_cpu_stop_queue_work_info *info = arg;
+	cpu_stop_queue_work(info->cpu1, info->work1);
+	cpu_stop_queue_work(info->cpu2, info->work2);
+}
+
+/**
+ * stop_two_cpus - stops two cpus
+ * @cpu1: the cpu to stop
+ * @cpu2: the other cpu to stop
+ * @fn: function to execute
+ * @arg: argument to @fn
+ *
+ * Stops both the current and specified CPU and runs @fn on one of them.
+ *
+ * returns when both are completed.
+ */
+int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *arg)
+{
+	struct cpu_stop_done done;
+	struct cpu_stop_work work1, work2;
+	struct irq_cpu_stop_queue_work_info call_args;
+	struct multi_stop_data msdata;
+
+	preempt_disable();
+	msdata = (struct multi_stop_data){
+		.fn = fn,
+		.data = arg,
+		.num_threads = 2,
+		.active_cpus = cpumask_of(cpu1),
+	};
+
+	work1 = work2 = (struct cpu_stop_work){
+		.fn = multi_cpu_stop,
+		.arg = &msdata,
+		.done = &done
+	};
+
+	call_args = (struct irq_cpu_stop_queue_work_info){
+		.cpu1 = cpu1,
+		.cpu2 = cpu2,
+		.work1 = &work1,
+		.work2 = &work2,
+	};
+
+	cpu_stop_init_done(&done, 2);
+	set_state(&msdata, MULTI_STOP_PREPARE);
+
+	/*
+	 * If we observe both CPUs active we know _cpu_down() cannot yet have
+	 * queued its stop_machine works and therefore ours will get executed
+	 * first. Or its not either one of our CPUs that's getting unplugged,
+	 * in which case we don't care.
+	 *
+	 * This relies on the stopper workqueues to be FIFO.
+	 */
+	if (!cpu_active(cpu1) || !cpu_active(cpu2)) {
+		preempt_enable();
+		return -ENOENT;
+	}
+
+	lg_local_lock(&stop_cpus_lock);
+	/*
+	 * Queuing needs to be done by the lowest numbered CPU, to ensure
+	 * that works are always queued in the same order on every CPU.
+	 * This prevents deadlocks.
+	 */
+	smp_call_function_single(min(cpu1, cpu2),
+				 &irq_cpu_stop_queue_work,
+				 &call_args, 0);
+	lg_local_unlock(&stop_cpus_lock);
+	preempt_enable();
+
+	wait_for_completion(&done.completion);
+
+	return done.executed ? done.ret : -ENOENT;
+}
+
 /**
  * stop_one_cpu_nowait - stop a cpu but don't wait for completion
  * @cpu: cpu to stop
@@ -159,10 +346,10 @@ static void queue_stop_cpus_work(const struct cpumask *cpumask,
 	 * preempted by a stopper which might wait for other stoppers
 	 * to enter @fn which can lead to deadlock.
 	 */
-	preempt_disable();
+	lg_global_lock(&stop_cpus_lock);
 	for_each_cpu(cpu, cpumask)
 		cpu_stop_queue_work(cpu, &per_cpu(stop_cpus_work, cpu));
-	preempt_enable();
+	lg_global_unlock(&stop_cpus_lock);
 }
 
 static int __stop_cpus(const struct cpumask *cpumask,
@@ -359,98 +546,14 @@ early_initcall(cpu_stop_init);
 
 #ifdef CONFIG_STOP_MACHINE
 
-/* This controls the threads on each CPU. */
-enum stopmachine_state {
-	/* Dummy starting state for thread. */
-	STOPMACHINE_NONE,
-	/* Awaiting everyone to be scheduled. */
-	STOPMACHINE_PREPARE,
-	/* Disable interrupts. */
-	STOPMACHINE_DISABLE_IRQ,
-	/* Run the function */
-	STOPMACHINE_RUN,
-	/* Exit */
-	STOPMACHINE_EXIT,
-};
-
-struct stop_machine_data {
-	int			(*fn)(void *);
-	void			*data;
-	/* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
-	unsigned int		num_threads;
-	const struct cpumask	*active_cpus;
-
-	enum stopmachine_state	state;
-	atomic_t		thread_ack;
-};
-
-static void set_state(struct stop_machine_data *smdata,
-		      enum stopmachine_state newstate)
-{
-	/* Reset ack counter. */
-	atomic_set(&smdata->thread_ack, smdata->num_threads);
-	smp_wmb();
-	smdata->state = newstate;
-}
-
-/* Last one to ack a state moves to the next state. */
-static void ack_state(struct stop_machine_data *smdata)
-{
-	if (atomic_dec_and_test(&smdata->thread_ack))
-		set_state(smdata, smdata->state + 1);
-}
-
-/* This is the cpu_stop function which stops the CPU. */
-static int stop_machine_cpu_stop(void *data)
-{
-	struct stop_machine_data *smdata = data;
-	enum stopmachine_state curstate = STOPMACHINE_NONE;
-	int cpu = smp_processor_id(), err = 0;
-	unsigned long flags;
-	bool is_active;
-
-	/*
-	 * When called from stop_machine_from_inactive_cpu(), irq might
-	 * already be disabled.  Save the state and restore it on exit.
-	 */
-	local_save_flags(flags);
-
-	if (!smdata->active_cpus)
-		is_active = cpu == cpumask_first(cpu_online_mask);
-	else
-		is_active = cpumask_test_cpu(cpu, smdata->active_cpus);
-
-	/* Simple state machine */
-	do {
-		/* Chill out and ensure we re-read stopmachine_state. */
-		cpu_relax();
-		if (smdata->state != curstate) {
-			curstate = smdata->state;
-			switch (curstate) {
-			case STOPMACHINE_DISABLE_IRQ:
-				local_irq_disable();
-				hard_irq_disable();
-				break;
-			case STOPMACHINE_RUN:
-				if (is_active)
-					err = smdata->fn(smdata->data);
-				break;
-			default:
-				break;
-			}
-			ack_state(smdata);
-		}
-	} while (curstate != STOPMACHINE_EXIT);
-
-	local_irq_restore(flags);
-	return err;
-}
-
 int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 {
-	struct stop_machine_data smdata = { .fn = fn, .data = data,
-					    .num_threads = num_online_cpus(),
-					    .active_cpus = cpus };
+	struct multi_stop_data msdata = {
+		.fn = fn,
+		.data = data,
+		.num_threads = num_online_cpus(),
+		.active_cpus = cpus,
+	};
 
 	if (!stop_machine_initialized) {
 		/*
@@ -461,7 +564,7 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 		unsigned long flags;
 		int ret;
 
-		WARN_ON_ONCE(smdata.num_threads != 1);
+		WARN_ON_ONCE(msdata.num_threads != 1);
 
 		local_irq_save(flags);
 		hard_irq_disable();
@@ -472,8 +575,8 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 	}
 
 	/* Set the initial state and stop all online cpus. */
-	set_state(&smdata, STOPMACHINE_PREPARE);
-	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);
+	set_state(&msdata, MULTI_STOP_PREPARE);
+	return stop_cpus(cpu_online_mask, multi_cpu_stop, &msdata);
 }
 
 int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
@@ -513,25 +616,25 @@ EXPORT_SYMBOL_GPL(stop_machine);
 int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
 				  const struct cpumask *cpus)
 {
-	struct stop_machine_data smdata = { .fn = fn, .data = data,
+	struct multi_stop_data msdata = { .fn = fn, .data = data,
 					    .active_cpus = cpus };
 	struct cpu_stop_done done;
 	int ret;
 
 	/* Local CPU must be inactive and CPU hotplug in progress. */
 	BUG_ON(cpu_active(raw_smp_processor_id()));
-	smdata.num_threads = num_active_cpus() + 1;	/* +1 for local */
+	msdata.num_threads = num_active_cpus() + 1;	/* +1 for local */
 
 	/* No proper task established and can't sleep - busy wait for lock. */
 	while (!mutex_trylock(&stop_cpus_mutex))
 		cpu_relax();
 
 	/* Schedule work on other CPUs and execute directly for local CPU */
-	set_state(&smdata, STOPMACHINE_PREPARE);
+	set_state(&msdata, MULTI_STOP_PREPARE);
 	cpu_stop_init_done(&done, num_active_cpus());
-	queue_stop_cpus_work(cpu_active_mask, stop_machine_cpu_stop, &smdata,
+	queue_stop_cpus_work(cpu_active_mask, multi_cpu_stop, &msdata,
 			     &done);
-	ret = stop_machine_cpu_stop(&smdata);
+	ret = multi_cpu_stop(&msdata);
 
 	/* Busy wait for completion. */
 	while (!completion_done(&done.completion))
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b2f06f3..a159e1f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -371,13 +371,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
-		.procname	= "numa_balancing_scan_period_reset",
-		.data		= &sysctl_numa_balancing_scan_period_reset,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-	{
 		.procname	= "numa_balancing_scan_period_max_ms",
 		.data		= &sysctl_numa_balancing_scan_period_max,
 		.maxlen		= sizeof(unsigned int),
@@ -391,6 +384,20 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname       = "numa_balancing_settle_count",
+		.data           = &sysctl_numa_balancing_settle_count,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec,
+	},
+	{
+		.procname       = "numa_balancing_migrate_deferred",
+		.data           = &sysctl_numa_balancing_migrate_deferred,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec,
+	},
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_SCHED_DEBUG */
 	{
diff --git a/kernel/timer.c b/kernel/timer.c
index 4296d13..6582b82 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1092,7 +1092,7 @@ static int cascade(struct tvec_base *base, struct tvec *tv, int index)
 static void call_timer_fn(struct timer_list *timer, void (*fn)(unsigned long),
 			  unsigned long data)
 {
-	int preempt_count = preempt_count();
+	int count = preempt_count();
 
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -1119,16 +1119,16 @@ static void call_timer_fn(struct timer_list *timer, void (*fn)(unsigned long),
 
 	lock_map_release(&lockdep_map);
 
-	if (preempt_count != preempt_count()) {
+	if (count != preempt_count()) {
 		WARN_ONCE(1, "timer: %pF preempt leak: %08x -> %08x\n",
-			  fn, preempt_count, preempt_count());
+			  fn, count, preempt_count());
 		/*
 		 * Restore the preempt count. That gives us a decent
 		 * chance to survive and extract information. If the
 		 * callback kept a lock held, bad luck, but not worse
 		 * than the BUG() we had.
 		 */
-		preempt_count() = preempt_count;
+		preempt_count_set(count);
 	}
 }
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7974ba2..d9fea7d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1509,7 +1509,8 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 #endif
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
-		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
+		(tif_need_resched() ? TRACE_FLAG_NEED_RESCHED : 0) |
+		(test_preempt_need_resched() ? TRACE_FLAG_PREEMPT_RESCHED : 0);
 }
 EXPORT_SYMBOL_GPL(tracing_generic_entry_update);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 10c86fb..73d08aa 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -124,6 +124,7 @@ enum trace_flag_type {
 	TRACE_FLAG_NEED_RESCHED		= 0x04,
 	TRACE_FLAG_HARDIRQ		= 0x08,
 	TRACE_FLAG_SOFTIRQ		= 0x10,
+	TRACE_FLAG_PREEMPT_RESCHED	= 0x20,
 };
 
 #define TRACE_BUF_SIZE		1024
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 34e7cba..ed32284 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -618,8 +618,23 @@ int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 		(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
 		(entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ? 'X' :
 		'.';
-	need_resched =
-		(entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.';
+
+	switch (entry->flags & (TRACE_FLAG_NEED_RESCHED |
+				TRACE_FLAG_PREEMPT_RESCHED)) {
+	case TRACE_FLAG_NEED_RESCHED | TRACE_FLAG_PREEMPT_RESCHED:
+		need_resched = 'N';
+		break;
+	case TRACE_FLAG_NEED_RESCHED:
+		need_resched = 'n';
+		break;
+	case TRACE_FLAG_PREEMPT_RESCHED:
+		need_resched = 'p';
+		break;
+	default:
+		need_resched = '.';
+		break;
+	}
+
 	hardsoft_irq =
 		(hardirq && softirq) ? 'H' :
 		hardirq ? 'h' :
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 6dc09d8..872a15a 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -1002,7 +1002,7 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 	 * Some tests (e.g. double-unlock) might corrupt the preemption
 	 * count, so restore it:
 	 */
-	preempt_count() = saved_preempt_count;
+	preempt_count_set(saved_preempt_count);
 #ifdef CONFIG_TRACE_IRQFLAGS
 	if (softirq_count())
 		current->softirqs_enabled = 0;
diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 4c0d0e5..04abe53 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -9,10 +9,9 @@
 
 notrace unsigned int debug_smp_processor_id(void)
 {
-	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();
 
-	if (likely(preempt_count))
+	if (likely(preempt_count()))
 		goto out;
 
 	if (irqs_disabled())
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index cca80d9..2612f60 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1282,19 +1282,32 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct page *page;
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
 	int page_nid = -1, this_nid = numa_node_id();
-	int target_nid;
+	int target_nid, last_cpupid = -1;
 	bool page_locked;
 	bool migrated = false;
+	int flags = 0;
 
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(pmd, *pmdp)))
 		goto out_unlock;
 
 	page = pmd_page(pmd);
+	BUG_ON(is_huge_zero_page(page));
 	page_nid = page_to_nid(page);
+	last_cpupid = page_cpupid_last(page);
 	count_vm_numa_event(NUMA_HINT_FAULTS);
-	if (page_nid == this_nid)
+	if (page_nid == this_nid) {
 		count_vm_numa_event(NUMA_HINT_FAULTS_LOCAL);
+		flags |= TNF_FAULT_LOCAL;
+	}
+
+	/*
+	 * Avoid grouping on DSO/COW pages in specific and RO pages
+	 * in general, RO pages shouldn't hurt as much anyway since
+	 * they can be in shared cache state.
+	 */
+	if (!pmd_write(pmd))
+		flags |= TNF_NO_GROUP;
 
 	/*
 	 * Acquire the page lock to serialise THP migrations but avoid dropping
@@ -1325,7 +1338,7 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		lock_page(page);
 	anon_vma = page_lock_anon_vma_read(page);
 
-	/* Confirm the PTE did not while locked */
+	/* Confirm the PMD did not change while page_table_lock was released */
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(pmd, *pmdp))) {
 		unlock_page(page);
@@ -1341,8 +1354,10 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	spin_unlock(&mm->page_table_lock);
 	migrated = migrate_misplaced_transhuge_page(mm, vma,
 				pmdp, pmd, addr, page, target_nid);
-	if (migrated)
+	if (migrated) {
+		flags |= TNF_MIGRATED;
 		page_nid = target_nid;
+	}
 
 	goto out;
 clear_pmdnuma:
@@ -1360,7 +1375,7 @@ out:
 		page_unlock_anon_vma_read(anon_vma);
 
 	if (page_nid != -1)
-		task_numa_fault(page_nid, HPAGE_PMD_NR, migrated);
+		task_numa_fault(last_cpupid, page_nid, HPAGE_PMD_NR, flags);
 
 	return 0;
 }
@@ -1458,6 +1473,12 @@ out:
 	return ret;
 }
 
+/*
+ * Returns
+ *  - 0 if PMD could not be locked
+ *  - 1 if PMD was locked but protections unchange and TLB flush unnecessary
+ *  - HPAGE_PMD_NR is protections changed and TLB flush necessary
+ */
 int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, pgprot_t newprot, int prot_numa)
 {
@@ -1466,22 +1487,34 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 
 	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		pmd_t entry;
-		entry = pmdp_get_and_clear(mm, addr, pmd);
+		ret = 1;
 		if (!prot_numa) {
+			entry = pmdp_get_and_clear(mm, addr, pmd);
 			entry = pmd_modify(entry, newprot);
+			ret = HPAGE_PMD_NR;
 			BUG_ON(pmd_write(entry));
 		} else {
 			struct page *page = pmd_page(*pmd);
 
-			/* only check non-shared pages */
-			if (page_mapcount(page) == 1 &&
+			/*
+			 * Do not trap faults against the zero page. The
+			 * read-only data is likely to be read-cached on the
+			 * local CPU cache and it is less useful to know about
+			 * local vs remote hits on the zero page.
+			 */
+			if (!is_huge_zero_page(page) &&
 			    !pmd_numa(*pmd)) {
+				entry = pmdp_get_and_clear(mm, addr, pmd);
 				entry = pmd_mknuma(entry);
+				ret = HPAGE_PMD_NR;
 			}
 		}
-		set_pmd_at(mm, addr, pmd, entry);
+
+		/* Set PMD if cleared earlier */
+		if (ret == HPAGE_PMD_NR)
+			set_pmd_at(mm, addr, pmd, entry);
+
 		spin_unlock(&vma->vm_mm->page_table_lock);
-		ret = 1;
 	}
 
 	return ret;
@@ -1662,7 +1695,7 @@ static void __split_huge_page_refcount(struct page *page,
 		page_tail->mapping = page->mapping;
 
 		page_tail->index = page->index + i;
-		page_nid_xchg_last(page_tail, page_nid_last(page));
+		page_cpupid_xchg_last(page_tail, page_cpupid_last(page));
 
 		BUG_ON(!PageAnon(page_tail));
 		BUG_ON(!PageUptodate(page_tail));
diff --git a/mm/memory.c b/mm/memory.c
index d176154..1f2287e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -69,8 +69,8 @@
 
 #include "internal.h"
 
-#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
-#warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_nid.
+#ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
+#warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid.
 #endif
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -2721,6 +2721,14 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		get_page(dirty_page);
 
 reuse:
+		/*
+		 * Clear the pages cpupid information as the existing
+		 * information potentially belongs to a now completely
+		 * unrelated process.
+		 */
+		if (old_page)
+			page_cpupid_xchg_last(old_page, (1 << LAST_CPUPID_SHIFT) - 1);
+
 		flush_cache_page(vma, address, pte_pfn(orig_pte));
 		entry = pte_mkyoung(orig_pte);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
@@ -3521,13 +3529,16 @@ static int do_nonlinear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 }
 
 int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
-				unsigned long addr, int page_nid)
+				unsigned long addr, int page_nid,
+				int *flags)
 {
 	get_page(page);
 
 	count_vm_numa_event(NUMA_HINT_FAULTS);
-	if (page_nid == numa_node_id())
+	if (page_nid == numa_node_id()) {
 		count_vm_numa_event(NUMA_HINT_FAULTS_LOCAL);
+		*flags |= TNF_FAULT_LOCAL;
+	}
 
 	return mpol_misplaced(page, vma, addr);
 }
@@ -3538,8 +3549,10 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct page *page = NULL;
 	spinlock_t *ptl;
 	int page_nid = -1;
+	int last_cpupid;
 	int target_nid;
 	bool migrated = false;
+	int flags = 0;
 
 	/*
 	* The "pte" at this point cannot be used safely without
@@ -3566,9 +3579,26 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		pte_unmap_unlock(ptep, ptl);
 		return 0;
 	}
+	BUG_ON(is_zero_pfn(page_to_pfn(page)));
 
+	/*
+	 * Avoid grouping on DSO/COW pages in specific and RO pages
+	 * in general, RO pages shouldn't hurt as much anyway since
+	 * they can be in shared cache state.
+	 */
+	if (!pte_write(pte))
+		flags |= TNF_NO_GROUP;
+
+	/*
+	 * Flag if the page is shared between multiple address spaces. This
+	 * is later used when determining whether to group tasks together
+	 */
+	if (page_mapcount(page) > 1 && (vma->vm_flags & VM_SHARED))
+		flags |= TNF_SHARED;
+
+	last_cpupid = page_cpupid_last(page);
 	page_nid = page_to_nid(page);
-	target_nid = numa_migrate_prep(page, vma, addr, page_nid);
+	target_nid = numa_migrate_prep(page, vma, addr, page_nid, &flags);
 	pte_unmap_unlock(ptep, ptl);
 	if (target_nid == -1) {
 		put_page(page);
@@ -3576,102 +3606,17 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 
 	/* Migrate to the requested node */
-	migrated = migrate_misplaced_page(page, target_nid);
-	if (migrated)
+	migrated = migrate_misplaced_page(page, vma, target_nid);
+	if (migrated) {
 		page_nid = target_nid;
+		flags |= TNF_MIGRATED;
+	}
 
 out:
 	if (page_nid != -1)
-		task_numa_fault(page_nid, 1, migrated);
-	return 0;
-}
-
-/* NUMA hinting page fault entry point for regular pmds */
-#ifdef CONFIG_NUMA_BALANCING
-static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
-		     unsigned long addr, pmd_t *pmdp)
-{
-	pmd_t pmd;
-	pte_t *pte, *orig_pte;
-	unsigned long _addr = addr & PMD_MASK;
-	unsigned long offset;
-	spinlock_t *ptl;
-	bool numa = false;
-
-	spin_lock(&mm->page_table_lock);
-	pmd = *pmdp;
-	if (pmd_numa(pmd)) {
-		set_pmd_at(mm, _addr, pmdp, pmd_mknonnuma(pmd));
-		numa = true;
-	}
-	spin_unlock(&mm->page_table_lock);
-
-	if (!numa)
-		return 0;
-
-	/* we're in a page fault so some vma must be in the range */
-	BUG_ON(!vma);
-	BUG_ON(vma->vm_start >= _addr + PMD_SIZE);
-	offset = max(_addr, vma->vm_start) & ~PMD_MASK;
-	VM_BUG_ON(offset >= PMD_SIZE);
-	orig_pte = pte = pte_offset_map_lock(mm, pmdp, _addr, &ptl);
-	pte += offset >> PAGE_SHIFT;
-	for (addr = _addr + offset; addr < _addr + PMD_SIZE; pte++, addr += PAGE_SIZE) {
-		pte_t pteval = *pte;
-		struct page *page;
-		int page_nid = -1;
-		int target_nid;
-		bool migrated = false;
-
-		if (!pte_present(pteval))
-			continue;
-		if (!pte_numa(pteval))
-			continue;
-		if (addr >= vma->vm_end) {
-			vma = find_vma(mm, addr);
-			/* there's a pte present so there must be a vma */
-			BUG_ON(!vma);
-			BUG_ON(addr < vma->vm_start);
-		}
-		if (pte_numa(pteval)) {
-			pteval = pte_mknonnuma(pteval);
-			set_pte_at(mm, addr, pte, pteval);
-		}
-		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page))
-			continue;
-		/* only check non-shared pages */
-		if (unlikely(page_mapcount(page) != 1))
-			continue;
-
-		page_nid = page_to_nid(page);
-		target_nid = numa_migrate_prep(page, vma, addr, page_nid);
-		pte_unmap_unlock(pte, ptl);
-		if (target_nid != -1) {
-			migrated = migrate_misplaced_page(page, target_nid);
-			if (migrated)
-				page_nid = target_nid;
-		} else {
-			put_page(page);
-		}
-
-		if (page_nid != -1)
-			task_numa_fault(page_nid, 1, migrated);
-
-		pte = pte_offset_map_lock(mm, pmdp, addr, &ptl);
-	}
-	pte_unmap_unlock(orig_pte, ptl);
-
-	return 0;
-}
-#else
-static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
-		     unsigned long addr, pmd_t *pmdp)
-{
-	BUG();
+		task_numa_fault(last_cpupid, page_nid, 1, flags);
 	return 0;
 }
-#endif /* CONFIG_NUMA_BALANCING */
 
 /*
  * These routines also need to handle stuff like marking pages dirty
@@ -3811,8 +3756,8 @@ retry:
 		}
 	}
 
-	if (pmd_numa(*pmd))
-		return do_pmd_numa_page(mm, vma, address, pmd);
+	/* THP should already have been handled */
+	BUG_ON(pmd_numa(*pmd));
 
 	/*
 	 * Use __pte_alloc instead of pte_alloc_map, because we can't
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0472964..71cb253 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1679,6 +1679,30 @@ struct mempolicy *get_vma_policy(struct task_struct *task,
 	return pol;
 }
 
+bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma)
+{
+	struct mempolicy *pol = get_task_policy(task);
+	if (vma) {
+		if (vma->vm_ops && vma->vm_ops->get_policy) {
+			bool ret = false;
+
+			pol = vma->vm_ops->get_policy(vma, vma->vm_start);
+			if (pol && (pol->flags & MPOL_F_MOF))
+				ret = true;
+			mpol_cond_put(pol);
+
+			return ret;
+		} else if (vma->vm_policy) {
+			pol = vma->vm_policy;
+		}
+	}
+
+	if (!pol)
+		return default_policy.flags & MPOL_F_MOF;
+
+	return pol->flags & MPOL_F_MOF;
+}
+
 static int apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
 {
 	enum zone_type dynamic_policy_zone = policy_zone;
@@ -2277,6 +2301,35 @@ static void sp_free(struct sp_node *n)
 	kmem_cache_free(sn_cache, n);
 }
 
+#ifdef CONFIG_NUMA_BALANCING
+static bool numa_migrate_deferred(struct task_struct *p, int last_cpupid)
+{
+	/* Never defer a private fault */
+	if (cpupid_match_pid(p, last_cpupid))
+		return false;
+
+	if (p->numa_migrate_deferred) {
+		p->numa_migrate_deferred--;
+		return true;
+	}
+	return false;
+}
+
+static inline void defer_numa_migrate(struct task_struct *p)
+{
+	p->numa_migrate_deferred = sysctl_numa_balancing_migrate_deferred;
+}
+#else
+static inline bool numa_migrate_deferred(struct task_struct *p, int last_cpupid)
+{
+	return false;
+}
+
+static inline void defer_numa_migrate(struct task_struct *p)
+{
+}
+#endif /* CONFIG_NUMA_BALANCING */
+
 /**
  * mpol_misplaced - check whether current page node is valid in policy
  *
@@ -2300,6 +2353,8 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
 	struct zone *zone;
 	int curnid = page_to_nid(page);
 	unsigned long pgoff;
+	int thiscpu = raw_smp_processor_id();
+	int thisnid = cpu_to_node(thiscpu);
 	int polnid = -1;
 	int ret = -1;
 
@@ -2348,9 +2403,11 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
 
 	/* Migrate the page towards the node whose CPU is referencing it */
 	if (pol->flags & MPOL_F_MORON) {
-		int last_nid;
+		int last_cpupid;
+		int this_cpupid;
 
-		polnid = numa_node_id();
+		polnid = thisnid;
+		this_cpupid = cpu_pid_to_cpupid(thiscpu, current->pid);
 
 		/*
 		 * Multi-stage node selection is used in conjunction
@@ -2373,8 +2430,25 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
 		 * it less likely we act on an unlikely task<->page
 		 * relation.
 		 */
-		last_nid = page_nid_xchg_last(page, polnid);
-		if (last_nid != polnid)
+		last_cpupid = page_cpupid_xchg_last(page, this_cpupid);
+		if (!cpupid_pid_unset(last_cpupid) && cpupid_to_nid(last_cpupid) != thisnid) {
+
+			/* See sysctl_numa_balancing_migrate_deferred comment */
+			if (!cpupid_match_pid(current, last_cpupid))
+				defer_numa_migrate(current);
+
+			goto out;
+		}
+
+		/*
+		 * The quadratic filter above reduces extraneous migration
+		 * of shared pages somewhat. This code reduces it even more,
+		 * reducing the overhead of page migrations of shared pages.
+		 * This makes workloads with shared pages rely more on
+		 * "move task near its memory", and less on "move memory
+		 * towards its task", which is exactly what we want.
+		 */
+		if (numa_migrate_deferred(current, last_cpupid))
 			goto out;
 	}
 
diff --git a/mm/migrate.c b/mm/migrate.c
index c046927..dfc8300 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -445,6 +445,8 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
  */
 void migrate_page_copy(struct page *newpage, struct page *page)
 {
+	int cpupid;
+
 	if (PageHuge(page) || PageTransHuge(page))
 		copy_huge_page(newpage, page);
 	else
@@ -481,6 +483,13 @@ void migrate_page_copy(struct page *newpage, struct page *page)
 			__set_page_dirty_nobuffers(newpage);
  	}
 
+	/*
+	 * Copy NUMA information to the new page, to prevent over-eager
+	 * future migrations of this same page.
+	 */
+	cpupid = page_cpupid_xchg_last(page, -1);
+	page_cpupid_xchg_last(newpage, cpupid);
+
 	mlock_migrate_page(newpage, page);
 	ksm_migrate_page(newpage, page);
 	/*
@@ -1500,7 +1509,7 @@ static struct page *alloc_misplaced_dst_page(struct page *page,
 					  __GFP_NOWARN) &
 					 ~GFP_IOFS, 0);
 	if (newpage)
-		page_nid_xchg_last(newpage, page_nid_last(page));
+		page_cpupid_xchg_last(newpage, page_cpupid_last(page));
 
 	return newpage;
 }
@@ -1601,7 +1610,8 @@ int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
  * node. Caller is expected to have an elevated reference count on
  * the page that will be dropped by this function before returning.
  */
-int migrate_misplaced_page(struct page *page, int node)
+int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
+			   int node)
 {
 	pg_data_t *pgdat = NODE_DATA(node);
 	int isolated;
@@ -1609,10 +1619,11 @@ int migrate_misplaced_page(struct page *page, int node)
 	LIST_HEAD(migratepages);
 
 	/*
-	 * Don't migrate pages that are mapped in multiple processes.
-	 * TODO: Handle false sharing detection instead of this hammer
+	 * Don't migrate file pages that are mapped in multiple processes
+	 * with execute permissions as they are probably shared libraries.
 	 */
-	if (page_mapcount(page) != 1)
+	if (page_mapcount(page) != 1 && page_is_file_cache(page) &&
+	    (vma->vm_flags & VM_EXEC))
 		goto out;
 
 	/*
@@ -1663,13 +1674,6 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	int page_lru = page_is_file_cache(page);
 
 	/*
-	 * Don't migrate pages that are mapped in multiple processes.
-	 * TODO: Handle false sharing detection instead of this hammer
-	 */
-	if (page_mapcount(page) != 1)
-		goto out_dropref;
-
-	/*
 	 * Rate-limit the amount of data that is being migrated to a node.
 	 * Optimal placement is no good if the memory bus is saturated and
 	 * all the time is being spent migrating!
@@ -1682,7 +1686,7 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	if (!new_page)
 		goto out_fail;
 
-	page_nid_xchg_last(new_page, page_nid_last(page));
+	page_cpupid_xchg_last(new_page, page_cpupid_last(page));
 
 	isolated = numamigrate_isolate_page(pgdat, page);
 	if (!isolated) {
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 633c088..68562e9 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -71,26 +71,26 @@ void __init mminit_verify_pageflags_layout(void)
 	unsigned long or_mask, add_mask;
 
 	shift = 8 * sizeof(unsigned long);
-	width = shift - SECTIONS_WIDTH - NODES_WIDTH - ZONES_WIDTH - LAST_NID_SHIFT;
+	width = shift - SECTIONS_WIDTH - NODES_WIDTH - ZONES_WIDTH - LAST_CPUPID_SHIFT;
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_widths",
-		"Section %d Node %d Zone %d Lastnid %d Flags %d\n",
+		"Section %d Node %d Zone %d Lastcpupid %d Flags %d\n",
 		SECTIONS_WIDTH,
 		NODES_WIDTH,
 		ZONES_WIDTH,
-		LAST_NID_WIDTH,
+		LAST_CPUPID_WIDTH,
 		NR_PAGEFLAGS);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_shifts",
-		"Section %d Node %d Zone %d Lastnid %d\n",
+		"Section %d Node %d Zone %d Lastcpupid %d\n",
 		SECTIONS_SHIFT,
 		NODES_SHIFT,
 		ZONES_SHIFT,
-		LAST_NID_SHIFT);
+		LAST_CPUPID_SHIFT);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_pgshifts",
-		"Section %lu Node %lu Zone %lu Lastnid %lu\n",
+		"Section %lu Node %lu Zone %lu Lastcpupid %lu\n",
 		(unsigned long)SECTIONS_PGSHIFT,
 		(unsigned long)NODES_PGSHIFT,
 		(unsigned long)ZONES_PGSHIFT,
-		(unsigned long)LAST_NID_PGSHIFT);
+		(unsigned long)LAST_CPUPID_PGSHIFT);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_nodezoneid",
 		"Node/Zone ID: %lu -> %lu\n",
 		(unsigned long)(ZONEID_PGOFF + ZONEID_SHIFT),
@@ -102,9 +102,9 @@ void __init mminit_verify_pageflags_layout(void)
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_nodeflags",
 		"Node not in page flags");
 #endif
-#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
+#ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_nodeflags",
-		"Last nid not in page flags");
+		"Last cpupid not in page flags");
 #endif
 
 	if (SECTIONS_WIDTH) {
diff --git a/mm/mmzone.c b/mm/mmzone.c
index 2ac0afb..bf34fb8 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -97,20 +97,20 @@ void lruvec_init(struct lruvec *lruvec)
 		INIT_LIST_HEAD(&lruvec->lists[lru]);
 }
 
-#if defined(CONFIG_NUMA_BALANCING) && !defined(LAST_NID_NOT_IN_PAGE_FLAGS)
-int page_nid_xchg_last(struct page *page, int nid)
+#if defined(CONFIG_NUMA_BALANCING) && !defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS)
+int page_cpupid_xchg_last(struct page *page, int cpupid)
 {
 	unsigned long old_flags, flags;
-	int last_nid;
+	int last_cpupid;
 
 	do {
 		old_flags = flags = page->flags;
-		last_nid = page_nid_last(page);
+		last_cpupid = page_cpupid_last(page);
 
-		flags &= ~(LAST_NID_MASK << LAST_NID_PGSHIFT);
-		flags |= (nid & LAST_NID_MASK) << LAST_NID_PGSHIFT;
+		flags &= ~(LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT);
+		flags |= (cpupid & LAST_CPUPID_MASK) << LAST_CPUPID_PGSHIFT;
 	} while (unlikely(cmpxchg(&page->flags, old_flags, flags) != old_flags));
 
-	return last_nid;
+	return last_cpupid;
 }
 #endif
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 412ba2b..a597f2f 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -37,14 +37,12 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 
 static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
-		int dirty_accountable, int prot_numa, bool *ret_all_same_node)
+		int dirty_accountable, int prot_numa)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
 	unsigned long pages = 0;
-	bool all_same_node = true;
-	int last_nid = -1;
 
 	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 	arch_enter_lazy_mmu_mode();
@@ -63,15 +61,7 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 
 				page = vm_normal_page(vma, addr, oldpte);
 				if (page) {
-					int this_nid = page_to_nid(page);
-					if (last_nid == -1)
-						last_nid = this_nid;
-					if (last_nid != this_nid)
-						all_same_node = false;
-
-					/* only check non-shared pages */
-					if (!pte_numa(oldpte) &&
-					    page_mapcount(page) == 1) {
+					if (!pte_numa(oldpte)) {
 						ptent = pte_mknuma(ptent);
 						updated = true;
 					}
@@ -104,33 +94,17 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 				if (pte_swp_soft_dirty(oldpte))
 					newpte = pte_swp_mksoft_dirty(newpte);
 				set_pte_at(mm, addr, pte, newpte);
+
+				pages++;
 			}
-			pages++;
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte - 1, ptl);
 
-	*ret_all_same_node = all_same_node;
 	return pages;
 }
 
-#ifdef CONFIG_NUMA_BALANCING
-static inline void change_pmd_protnuma(struct mm_struct *mm, unsigned long addr,
-				       pmd_t *pmd)
-{
-	spin_lock(&mm->page_table_lock);
-	set_pmd_at(mm, addr & PMD_MASK, pmd, pmd_mknuma(*pmd));
-	spin_unlock(&mm->page_table_lock);
-}
-#else
-static inline void change_pmd_protnuma(struct mm_struct *mm, unsigned long addr,
-				       pmd_t *pmd)
-{
-	BUG();
-}
-#endif /* CONFIG_NUMA_BALANCING */
-
 static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 		pud_t *pud, unsigned long addr, unsigned long end,
 		pgprot_t newprot, int dirty_accountable, int prot_numa)
@@ -138,34 +112,33 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 	pmd_t *pmd;
 	unsigned long next;
 	unsigned long pages = 0;
-	bool all_same_node;
 
 	pmd = pmd_offset(pud, addr);
 	do {
+		unsigned long this_pages;
+
 		next = pmd_addr_end(addr, end);
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				split_huge_page_pmd(vma, addr, pmd);
-			else if (change_huge_pmd(vma, pmd, addr, newprot,
-						 prot_numa)) {
-				pages++;
-				continue;
+			else {
+				int nr_ptes = change_huge_pmd(vma, pmd, addr,
+						newprot, prot_numa);
+
+				if (nr_ptes) {
+					if (nr_ptes == HPAGE_PMD_NR)
+						pages++;
+
+					continue;
+				}
 			}
 			/* fall through */
 		}
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		pages += change_pte_range(vma, pmd, addr, next, newprot,
-				 dirty_accountable, prot_numa, &all_same_node);
-
-		/*
-		 * If we are changing protections for NUMA hinting faults then
-		 * set pmd_numa if the examined pages were all on the same
-		 * node. This allows a regular PMD to be handled as one fault
-		 * and effectively batches the taking of the PTL
-		 */
-		if (prot_numa && all_same_node)
-			change_pmd_protnuma(vma->vm_mm, addr, pmd);
+		this_pages = change_pte_range(vma, pmd, addr, next, newprot,
+				 dirty_accountable, prot_numa);
+		pages += this_pages;
 	} while (pmd++, addr = next, addr != end);
 
 	return pages;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dd886fa..73d812f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -626,7 +626,7 @@ static inline int free_pages_check(struct page *page)
 		bad_page(page);
 		return 1;
 	}
-	page_nid_reset_last(page);
+	page_cpupid_reset_last(page);
 	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
 		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	return 0;
@@ -4015,7 +4015,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 		mminit_verify_page_links(page, zone, nid, pfn);
 		init_page_count(page);
 		page_mapcount_reset(page);
-		page_nid_reset_last(page);
+		page_cpupid_reset_last(page);
 		SetPageReserved(page);
 		/*
 		 * Mark the block movable so that blocks are reserved for
diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index 0578d4f..0f67690 100644
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -2563,9 +2563,8 @@ bed:
 				  jiffies + msecs_to_jiffies(val));
 
 			/* Wait for IR-LMP to call us back */
-			__wait_event_interruptible(self->query_wait,
-			      (self->cachedaddr != 0 || self->errno == -ETIME),
-						   err);
+			err = __wait_event_interruptible(self->query_wait,
+			      (self->cachedaddr != 0 || self->errno == -ETIME));
 
 			/* If watchdog is still activated, kill it! */
 			del_timer(&(self->watchdog));
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index f448471..f63c238 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1637,12 +1637,9 @@ static int sync_thread_master(void *data)
 			continue;
 		}
 		while (ip_vs_send_sync_msg(tinfo->sock, sb->mesg) < 0) {
-			int ret = 0;
-
-			__wait_event_interruptible(*sk_sleep(sk),
+			int ret = __wait_event_interruptible(*sk_sleep(sk),
 						   sock_writeable(sk) ||
-						   kthread_should_stop(),
-						   ret);
+						   kthread_should_stop());
 			if (unlikely(kthread_should_stop()))
 				goto done;
 		}
