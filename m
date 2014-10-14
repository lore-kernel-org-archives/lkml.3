Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbaJNNH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:07:59 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58083 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbaJNNH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:07:57 -0400
Date: Tue, 14 Oct 2014 09:07:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [GIT PULL] percpu consistent-ops changes for v3.18-rc1
Message-ID: <20141014130752.GA14897@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Way back, before the current percpu allocator was implemented, static
and dynamic percpu memory areas were allocated and handled separately
and had their own accessors.  The distinction has been gone for many
years now; however, the now duplicate two sets of accessors remained
with the pointer based ones - this_cpu_*() - evolving various other
operations over time.  During the process, we also accumulated other
inconsistent operations.

This pull request contains Christoph's patches to clean up the
duplicate accessor situation.  __get_cpu_var() uses are replaced with
with this_cpu_ptr() and __this_cpu_ptr() with raw_cpu_ptr().
Unfortunately, the former sometimes is tricky thanks to C being a bit
messy with the distinction between lvalues and pointers, which led to
a rather ugly solution for cpumask_var_t involving the introduction of
this_cpu_cpumask_var_ptr().

This converts most of the uses but not all.  Christoph will follow up
with the remaining conversions in this merge window and hopefully
remove the obsolete accessors.

This creates five conflicts when pulled into the current master
2d65a9f48fc ("Merge branch 'drm-next' of
git://people.freedesktop.org/~airlied/linux").  One is on
kernel/irq_work.c and four are from s390 updating how it uses percpu
variables.  Just in case, the following branch contains a test merge
for comparison.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git test-merge-for-3.18-consistent-ops

The list of conflicts and their resolutions is at the end of this
mail.


The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.18-consistent-ops

for you to fetch changes up to 513d1a2884a49654f368b5fa25ef186e976bdada:

  irqchip: Properly fetch the per cpu offset (2014-09-18 23:48:08 -0400)

----------------------------------------------------------------
Christoph Lameter (36):
      kernel misc: Replace __get_cpu_var uses
      time: Replace __get_cpu_var uses
      time: Convert a bunch of &__get_cpu_var introduced in the 3.16 merge period
      scheduler: Replace __get_cpu_var with this_cpu_ptr
      block: Replace __this_cpu_ptr with raw_cpu_ptr
      drivers/char/random: Replace __get_cpu_var uses
      drivers/cpuidle: Replace __get_cpu_var uses for address calculation
      drivers/oprofile: Replace __get_cpu_var uses for address calculation
      drivers/clocksource: Replace __get_cpu_var used for address calculation
      drivers/net/ethernet/tile: Replace __get_cpu_var uses for address calculation
      watchdog: Replace __raw_get_cpu_var uses
      net: Replace get_cpu_var through this_cpu_ptr
      md: Replace __this_cpu_ptr with raw_cpu_ptr
      metag: Replace __get_cpu_var uses for address calculation
      drivers/net/ethernet/tile: __get_cpu_var call introduced in 3.14
      irqchips: Replace __this_cpu_ptr uses
      x86: Replace __get_cpu_var uses
      uv: Replace __get_cpu_var
      arm: Replace __this_cpu_ptr with raw_cpu_ptr
      MIPS: Replace __get_cpu_var uses in FPU emulator.
      mips: Replace __get_cpu_var uses
      s390: Replace __get_cpu_var uses
      s390: cio driver &__get_cpu_var replacements
      ia64: Replace __get_cpu_var uses
      alpha: Replace __get_cpu_var
      powerpc: Replace __get_cpu_var uses
      tile: Replace __get_cpu_var uses
      tile: Use this_cpu_ptr() for hardware counters
      blackfin: Replace __get_cpu_var uses
      avr32: Replace __get_cpu_var with __this_cpu_write
      sparc: Replace __get_cpu_var uses
      clocksource: Replace __this_cpu_ptr with raw_cpu_ptr
      percpu: Remove __this_cpu_ptr
      percpu: Resolve ambiguities in __get_cpu_var/cpumask_var_t
      ia64: sn_nodepda cannot be assigned to after this_cpu conversion. Use __this_cpu_write.
      irqchip: Properly fetch the per cpu offset

Mel Gorman (1):
      percpu: Resolve ambiguities in __get_cpu_var/cpumask_var_t -fix

Tejun Heo (1):
      Revert "powerpc: Replace __get_cpu_var uses"

 arch/alpha/kernel/perf_event.c              | 16 +++++-----
 arch/alpha/kernel/time.c                    |  6 ++--
 arch/arm/kernel/smp_twd.c                   | 12 ++++----
 arch/avr32/kernel/kprobes.c                 |  2 +-
 arch/blackfin/include/asm/ipipe.h           |  2 +-
 arch/blackfin/kernel/perf_event.c           | 10 +++----
 arch/blackfin/mach-common/ints-priority.c   |  8 ++---
 arch/blackfin/mach-common/smp.c             |  2 +-
 arch/ia64/include/asm/hw_irq.h              |  2 +-
 arch/ia64/include/asm/sn/arch.h             |  4 +--
 arch/ia64/include/asm/sn/nodepda.h          |  2 +-
 arch/ia64/include/asm/switch_to.h           |  2 +-
 arch/ia64/include/asm/uv/uv_hub.h           |  2 +-
 arch/ia64/kernel/irq.c                      |  2 +-
 arch/ia64/kernel/irq_ia64.c                 |  4 +--
 arch/ia64/kernel/kprobes.c                  |  6 ++--
 arch/ia64/kernel/mca.c                      | 16 +++++-----
 arch/ia64/kernel/process.c                  |  6 ++--
 arch/ia64/kernel/traps.c                    |  2 +-
 arch/ia64/sn/kernel/setup.c                 |  2 +-
 arch/ia64/sn/kernel/sn2/sn2_smp.c           | 28 +++++++++---------
 arch/metag/kernel/perf/perf_event.c         | 14 ++++-----
 arch/mips/cavium-octeon/octeon-irq.c        | 30 +++++++++----------
 arch/mips/include/asm/fpu_emulator.h        | 24 +++++++--------
 arch/mips/kernel/kprobes.c                  |  6 ++--
 arch/mips/kernel/perf_event_mipsxx.c        | 14 ++++-----
 arch/mips/kernel/smp-bmips.c                |  2 +-
 arch/mips/loongson/loongson-3/smp.c         |  6 ++--
 arch/powerpc/include/asm/cputime.h          |  6 ++--
 arch/s390/include/asm/cputime.h             |  2 +-
 arch/s390/include/asm/irq.h                 |  2 +-
 arch/s390/include/asm/percpu.h              | 16 +++++-----
 arch/s390/kernel/irq.c                      |  2 +-
 arch/s390/kernel/kprobes.c                  |  8 ++---
 arch/s390/kernel/nmi.c                      | 10 +++++--
 arch/s390/kernel/perf_cpum_cf.c             | 22 +++++++-------
 arch/s390/kernel/perf_cpum_sf.c             | 16 +++++-----
 arch/s390/kernel/processor.c                |  4 +--
 arch/s390/kernel/time.c                     |  6 ++--
 arch/s390/kernel/vtime.c                    |  2 +-
 arch/s390/oprofile/hwsampler.c              |  2 +-
 arch/sparc/include/asm/cpudata_32.h         |  2 +-
 arch/sparc/include/asm/cpudata_64.h         |  2 +-
 arch/sparc/kernel/kprobes.c                 |  6 ++--
 arch/sparc/kernel/leon_smp.c                |  2 +-
 arch/sparc/kernel/nmi.c                     | 16 +++++-----
 arch/sparc/kernel/pci_sun4v.c               |  8 ++---
 arch/sparc/kernel/perf_event.c              | 26 ++++++++--------
 arch/sparc/kernel/sun4d_smp.c               |  2 +-
 arch/sparc/kernel/time_64.c                 |  2 +-
 arch/sparc/mm/tlb.c                         |  4 +--
 arch/tile/include/asm/irqflags.h            |  4 +--
 arch/tile/include/asm/mmu_context.h         |  6 ++--
 arch/tile/kernel/irq.c                      | 14 ++++-----
 arch/tile/kernel/messaging.c                |  4 +--
 arch/tile/kernel/perf_event.c               | 12 ++++----
 arch/tile/kernel/process.c                  |  2 +-
 arch/tile/kernel/setup.c                    |  3 +-
 arch/tile/kernel/single_step.c              |  4 +--
 arch/tile/kernel/smp.c                      |  2 +-
 arch/tile/kernel/smpboot.c                  |  6 ++--
 arch/tile/kernel/time.c                     |  8 ++---
 arch/tile/mm/highmem.c                      |  2 +-
 arch/tile/mm/init.c                         |  4 +--
 arch/x86/include/asm/debugreg.h             |  4 +--
 arch/x86/include/asm/perf_event_p4.h        |  2 +-
 arch/x86/include/asm/uv/uv_hub.h            | 12 ++++----
 arch/x86/kernel/apb_timer.c                 |  4 +--
 arch/x86/kernel/apic/apic.c                 |  4 +--
 arch/x86/kernel/apic/x2apic_cluster.c       |  2 +-
 arch/x86/kernel/cpu/common.c                |  6 ++--
 arch/x86/kernel/cpu/mcheck/mce-inject.c     |  6 ++--
 arch/x86/kernel/cpu/mcheck/mce.c            | 46 ++++++++++++++---------------
 arch/x86/kernel/cpu/mcheck/mce_amd.c        |  2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel.c      | 22 +++++++-------
 arch/x86/kernel/cpu/perf_event.c            | 22 +++++++-------
 arch/x86/kernel/cpu/perf_event_amd.c        |  4 +--
 arch/x86/kernel/cpu/perf_event_intel.c      | 18 +++++------
 arch/x86/kernel/cpu/perf_event_intel_ds.c   | 20 ++++++-------
 arch/x86/kernel/cpu/perf_event_intel_lbr.c  | 12 ++++----
 arch/x86/kernel/cpu/perf_event_intel_rapl.c | 12 ++++----
 arch/x86/kernel/cpu/perf_event_knc.c        |  2 +-
 arch/x86/kernel/cpu/perf_event_p4.c         |  6 ++--
 arch/x86/kernel/hw_breakpoint.c             |  8 ++---
 arch/x86/kernel/irq_64.c                    |  6 ++--
 arch/x86/kernel/kvm.c                       | 22 +++++++-------
 arch/x86/kvm/svm.c                          |  6 ++--
 arch/x86/kvm/vmx.c                          | 10 +++----
 arch/x86/kvm/x86.c                          |  2 +-
 arch/x86/mm/kmemcheck/kmemcheck.c           | 14 ++++-----
 arch/x86/oprofile/nmi_int.c                 |  8 ++---
 arch/x86/oprofile/op_model_p4.c             |  2 +-
 arch/x86/platform/uv/uv_nmi.c               | 40 ++++++++++++-------------
 arch/x86/platform/uv/uv_time.c              |  2 +-
 arch/x86/xen/enlighten.c                    |  4 +--
 arch/x86/xen/multicalls.c                   |  8 ++---
 arch/x86/xen/spinlock.c                     |  2 +-
 arch/x86/xen/time.c                         | 10 +++----
 drivers/char/random.c                       |  2 +-
 drivers/clocksource/dummy_timer.c           |  2 +-
 drivers/clocksource/metag_generic.c         |  2 +-
 drivers/clocksource/qcom-timer.c            |  2 +-
 drivers/cpuidle/governors/ladder.c          |  4 +--
 drivers/cpuidle/governors/menu.c            |  6 ++--
 drivers/irqchip/irq-gic.c                   | 10 +++----
 drivers/md/dm-stats.c                       |  2 +-
 drivers/net/ethernet/tile/tilegx.c          | 22 +++++++-------
 drivers/net/ethernet/tile/tilepro.c         |  8 ++---
 drivers/oprofile/cpu_buffer.c               | 10 +++----
 drivers/oprofile/timer_int.c                |  2 +-
 drivers/s390/cio/ccwreq.c                   |  2 +-
 drivers/s390/cio/chsc_sch.c                 |  2 +-
 drivers/s390/cio/cio.c                      |  6 ++--
 drivers/s390/cio/device_fsm.c               |  4 +--
 drivers/s390/cio/eadm_sch.c                 |  2 +-
 fs/ext4/mballoc.c                           |  2 +-
 include/linux/cpumask.h                     | 11 +++++++
 include/linux/kernel_stat.h                 |  4 +--
 include/linux/percpu-defs.h                 |  3 --
 include/net/netfilter/nf_conntrack.h        |  2 +-
 include/net/snmp.h                          |  6 ++--
 kernel/events/callchain.c                   |  4 +--
 kernel/events/core.c                        | 24 +++++++--------
 kernel/irq/chip.c                           |  2 +-
 kernel/irq_work.c                           | 12 ++++----
 kernel/printk/printk.c                      |  4 +--
 kernel/sched/clock.c                        |  2 +-
 kernel/sched/deadline.c                     |  2 +-
 kernel/sched/fair.c                         |  2 +-
 kernel/sched/rt.c                           |  2 +-
 kernel/sched/sched.h                        |  4 +--
 kernel/smp.c                                |  6 ++--
 kernel/softirq.c                            |  4 +--
 kernel/taskstats.c                          |  2 +-
 kernel/time/hrtimer.c                       | 22 +++++++-------
 kernel/time/tick-broadcast.c                |  2 +-
 kernel/time/tick-common.c                   |  6 ++--
 kernel/time/tick-oneshot.c                  |  2 +-
 kernel/time/tick-sched.c                    | 24 +++++++--------
 kernel/time/timer.c                         |  2 +-
 kernel/user-return-notifier.c               |  4 +--
 kernel/watchdog.c                           | 12 ++++----
 net/core/dev.c                              | 14 ++++-----
 net/core/drop_monitor.c                     |  2 +-
 net/core/skbuff.c                           |  2 +-
 net/ipv4/route.c                            |  4 +--
 net/ipv4/syncookies.c                       |  2 +-
 net/ipv4/tcp.c                              |  2 +-
 net/ipv4/tcp_output.c                       |  2 +-
 net/ipv6/syncookies.c                       |  2 +-
 net/rds/ib_rdma.c                           |  2 +-
 151 files changed, 563 insertions(+), 550 deletions(-)

----------------------------------------------------------------
Conflicts and their resolutions

1. kernel/irq_work.c

76a33061b932 ("irq_work: Force raised irq work to run on irq work
interrupt") modified if conditional which is adjacent to percpu
accessor updates.

  bool irq_work_needs_cpu(void)
  {
	  struct llist_head *raised, *lazy;

  <<<<<<< HEAD
	  raised = &__get_cpu_var(raised_list);
	  lazy = &__get_cpu_var(lazy_list);

	  if (llist_empty(raised) || arch_irq_work_has_interrupt())
		  if (llist_empty(lazy))
			  return false;
  =======
	  raised = this_cpu_ptr(&raised_list);
	  lazy = this_cpu_ptr(&lazy_list);
	  if (llist_empty(raised) && llist_empty(lazy))
		  return false;
  >>>>>>> 513d1a2884a49654f368b5fa25ef186e976bdada

	  /* All work should have been flushed before going offline */
	  WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));

	  return true;
  }

It can be resolved by combining the conditional update with the percpu
accessor updates.

  bool irq_work_needs_cpu(void)
  {
	  struct llist_head *raised, *lazy;

	  raised = this_cpu_ptr(&raised_list);
	  lazy = this_cpu_ptr(&lazy_list);

	  if (llist_empty(raised) || arch_irq_work_has_interrupt())
		  if (llist_empty(lazy))
			  return false;

	  /* All work should have been flushed before going offline */
	  WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));

	  return true;
  }


2. arch/s390/kernel/vtime.c

b5f87f15e200 ("s390/idle: consolidate idle functions and definitions")
removes two functions which contained percpu accesses.

  <<<<<<< HEAD
  =======
  void __kprobes vtime_stop_cpu(void)
  {
	  struct s390_idle_data *idle = this_cpu_ptr(&s390_idle);
	  unsigned long long idle_time;
	  unsigned long psw_mask;

	  trace_hardirqs_on();

	  /* Wait for external, I/O or machine check interrupt. */
	  psw_mask = PSW_KERNEL_BITS | PSW_MASK_WAIT | PSW_MASK_DAT |
		  PSW_MASK_IO | PSW_MASK_EXT | PSW_MASK_MCHECK;
	  idle->nohz_delay = 0;

	  /* Call the assembler magic in entry.S */
	  psw_idle(idle, psw_mask);

	  /* Account time spent with enabled wait psw loaded as idle time. */
	  idle->sequence++;
	  smp_wmb();
	  idle_time = idle->clock_idle_exit - idle->clock_idle_enter;
	  idle->clock_idle_enter = idle->clock_idle_exit = 0ULL;
	  idle->idle_time += idle_time;
	  idle->idle_count++;
	  account_idle_time(idle_time);
	  smp_wmb();
	  idle->sequence++;
  }

  cputime64_t s390_get_idle_time(int cpu)
  {
	  struct s390_idle_data *idle = &per_cpu(s390_idle, cpu);
	  unsigned long long now, idle_enter, idle_exit;
	  unsigned int sequence;

	  do {
		  now = get_tod_clock();
		  sequence = ACCESS_ONCE(idle->sequence);
		  idle_enter = ACCESS_ONCE(idle->clock_idle_enter);
		  idle_exit = ACCESS_ONCE(idle->clock_idle_exit);
	  } while ((sequence & 1) || (ACCESS_ONCE(idle->sequence) != sequence));
	  return idle_enter ? ((idle_exit ?: now) - idle_enter) : 0;
  }

  >>>>>>> 513d1a2884a49654f368b5fa25ef186e976bdada

The conflicting code can be removed.


3. arch/s390/kernel/processor.c

a9b1649917f0 ("s390/vtime: do not reset idle data on CPU hotplug")
removed one of the two updated percpu accesses.

  void cpu_init(void)
  {
  <<<<<<< HEAD
	  struct cpuid *id = &__get_cpu_var(cpu_id);
  =======
	  struct s390_idle_data *idle = this_cpu_ptr(&s390_idle);
	  struct cpuid *id = this_cpu_ptr(&cpu_id);
  >>>>>>> 513d1a2884a49654f368b5fa25ef186e976bdada

	  get_cpu_id(id);
	  atomic_inc(&init_mm.mm_count);
	  current->active_mm = &init_mm;
	  BUG_ON(current->mm);
	  enter_lazy_tlb(&init_mm, current);
  }

This can be resolved by removing one of the updated accesses.

  void cpu_init(void)
  {
	  struct cpuid *id = this_cpu_ptr(&cpu_id);

	  get_cpu_id(id);
	  atomic_inc(&init_mm.mm_count);
	  current->active_mm = &init_mm;
	  BUG_ON(current->mm);
	  enter_lazy_tlb(&init_mm, current);
  }


4. arch/s390/kernel/irq.c

fe0f49768d80 ("s390/nohz: use a per-cpu flag for arch_needs_cpu")
removed the updated percpu access.

  static irqreturn_t do_ext_interrupt(int irq, void *dummy)
  {
	  struct pt_regs *regs = get_irq_regs();
	  struct ext_code ext_code;
	  struct ext_int_info *p;
	  int index;

	  ext_code = *(struct ext_code *) &regs->int_code;
	  if (ext_code.code != EXT_IRQ_CLK_COMP)
  <<<<<<< HEAD
		  set_cpu_flag(CIF_NOHZ_DELAY);
  =======
		  __this_cpu_write(s390_idle.nohz_delay, 1);
  >>>>>>> 513d1a2884a49654f368b5fa25ef186e976bdada

	  index = ext_hash(ext_code.code);
	  rcu_read_lock();
	  hlist_for_each_entry_rcu(p, &ext_int_hash[index], entry) {
		  if (unlikely(p->code != ext_code.code))
			  continue;
		  p->handler(ext_code, regs->int_parm, regs->int_parm_long);
	  }
	  rcu_read_unlock();
	  return IRQ_HANDLED;
  }

Can be resolved by keeping the code from s390 branch.

  static irqreturn_t do_ext_interrupt(int irq, void *dummy)
  {
	  struct pt_regs *regs = get_irq_regs();
	  struct ext_code ext_code;
	  struct ext_int_info *p;
	  int index;

	  ext_code = *(struct ext_code *) &regs->int_code;
	  if (ext_code.code != EXT_IRQ_CLK_COMP)
		  set_cpu_flag(CIF_NOHZ_DELAY);

	  index = ext_hash(ext_code.code);
	  rcu_read_lock();
	  hlist_for_each_entry_rcu(p, &ext_int_hash[index], entry) {
		  if (unlikely(p->code != ext_code.code))
			  continue;
		  p->handler(ext_code, regs->int_parm, regs->int_parm_long);
	  }
	  rcu_read_unlock();
	  return IRQ_HANDLED;
  }


5. arch/s390/include/asm/cputime.h

b5f87f15e200 ("s390/idle: consolidate idle functions and definitions")
and fe0f49768d80 ("s390/nohz: use a per-cpu flag for arch_needs_cpu")
removed (adjacent) code updated by this pull request.

  <<<<<<< HEAD
  cputime64_t arch_cpu_idle_time(int cpu);
  =======
  struct s390_idle_data {
	  int nohz_delay;
	  unsigned int sequence;
	  unsigned long long idle_count;
	  unsigned long long idle_time;
	  unsigned long long clock_idle_enter;
	  unsigned long long clock_idle_exit;
	  unsigned long long timer_idle_enter;
	  unsigned long long timer_idle_exit;
  };

  DECLARE_PER_CPU(struct s390_idle_data, s390_idle);

  cputime64_t s390_get_idle_time(int cpu);

  #define arch_idle_time(cpu) s390_get_idle_time(cpu)

  static inline int s390_nohz_delay(int cpu)
  {
	  return __this_cpu_read(s390_idle.nohz_delay) != 0;
  }
  >>>>>>> 513d1a2884a49654f368b5fa25ef186e976bdada

Can be resolved by taking code from s390 branch.

  cputime64_t arch_cpu_idle_time(int cpu);

-- 
tejun
