Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030348Ab3HIOQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:16:03 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50454 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030274Ab3HIOQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:16:00 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <mingo@redhat.com>, <hpa@zytor.com>, <x86@kernel.org>, <jeremy@goop.org>,
        <konrad.wilk@oracle.com>, <gleb@redhat.com>, <pbonzini@redhat.com>
Cc: <gregkh@suse.de>, <peterz@infradead.org>, <tglx@linutronix.de>,
        <agraf@suse.de>, <riel@redhat.com>, <avi.kivity@gmail.com>,
        <habanero@linux.vnet.ibm.com>, <chegu_vinod@hp.com>,
        <ouyang@cs.pitt.edu>, <drjones@redhat.com>, <attilio.rao@citrix.com>,
        linux-doc@vger.kernel.org, <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <andi@firstfloor.org>, <xen-devel@lists.xensource.com>,
        <virtualization@lists.linux-foundation.org>,
        <stefano.stabellini@eu.citrix.com>, <mtosatti@redhat.com>,
        <srivatsa.vaddagiri@gmail.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [PATCH V13 00/14] Paravirtualized ticket spinlocks 
Date: Fri,  9 Aug 2013 19:51:48 +0530
Message-Id: <1376058122-8248-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <y>
References: <y>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080914-7182-0000-0000-0000080893EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series replaces the existing paravirtualized spinlock mechanism
with a paravirtualized ticketlock mechanism. The series provides
implementation for both Xen and KVM.

The current set of patches are for Xen/x86 spinlock/KVM guest side, to be included
against -tip.

A separate patchset for KVM host based on kvm tree is already sent.

Results:
=======
setup: 32 core machine with 32 vcpu KVM guest (HT off)  with 8GB RAM
base = 3.11-rc
patched = base + V12 series

+-----------------+----------------+--------+
 dbench (Throughput in MB/sec. Higher is better)
+-----------------+----------------+--------+
|   base (stdev %)|patched(stdev%) | %gain  |
+-----------------+----------------+--------+
| 15035.3   (0.3) |15150.0   (0.6) |   0.8  |
|  1470.0   (2.2) | 1713.7   (1.9) |  16.6  |
|   848.6   (4.3) |  967.8   (4.3) |  14.0  |
|   652.9   (3.5) |  685.3   (3.7) |   5.0  |
+-----------------+----------------+--------+

pvspinlock shows benefits for overcommit ratio > 1 for PLE enabled cases,
and undercommits results are flat.

non PLE results are much better for smaller VMs. 
http://lkml.indiana.edu/hypermail/linux/kernel/1306.3/01095.html

I would thanks all the experts here for their time in reviewing and
commenting on the patch series (including perhaps who have been not
listed). 

Finally special thanks to KVM maintainers (Avi, Marcelo, Gleb) for
their comments and Andrew Theurer, Chegu Vinod for their valuable
testing and feedback.

The older series[4] was tested by Attilio for Xen implementation.

Note that Konrad needs to revert below two patches to enable xen on hvm 
  70dd4998, f10cd522c

Changes in V13
 - fixed arch_spinlock_t redefinition issue.
 - fixed forward declaration of atomic_read issue in jump_label

Changes in V12
 - spiltted uapi header patch.
 - dropped patch 18.
 - bailout of lock spinning in case of NMI (Gleb)
 - drop out patch 18 whose benefits are inconclusive (Gleb, Ingo)

Changes in V11:
 - use safe_halt in lock_spinning path to avoid potential problem 
  in case of irq_handlers taking lock in slowpath (Gleb)
 - add a0 flag for the kick hypercall for future extension  (Gleb)
 - add stubs for missing architecture for kvm_vcpu_schedule() (Gleb)
 - Change hypercall documentation.
 - Rebased to 3.11-rc1

Changes in V10:
Addressed Konrad's review comments:
- Added break in patch 5 since now we know exact cpu to wakeup
- Dropped patch 12 and Konrad needs to revert two patches to enable xen on hvm 
  70dd4998, f10cd522c
- Remove TIMEOUT and corrected spacing in patch 15
- Kicked spelling and correct spacing in patches 17, 18 

Changes in V9:
- Changed spin_threshold to 32k to avoid excess halt exits that are
   causing undercommit degradation (after PLE handler improvement).
- Added  kvm_irq_delivery_to_apic (suggested by Gleb)
- Optimized halt exit path to use PLE handler

V8 of PVspinlock was posted last year. After Avi's suggestions to look
at PLE handler's improvements, various optimizations in PLE handling
have been tried.

With this series we see that we could get little more improvements on top
of that.

Changes before V8:
Ticketlock change history:
Changes in V7:
 - Reabsed patches to 3.4-rc3
 - Added jumplabel split patch (originally from Andrew Jones rebased to
    3.4-rc3
 - jumplabel changes from Ingo and Jason taken and now using static_key_*
    instead of static_branch.
 - using UNINLINE_SPIN_UNLOCK (which was splitted as per suggestion from Linus)
 - This patch series is rebased on debugfs patch (that sould be already in
    Xen/linux-next https://lkml.org/lkml/2012/3/23/51)

Changes in V6 posting: (Raghavendra K T)
 - Rebased to linux-3.3-rc6.
 - used function+enum in place of macro (better type checking) 
 - use cmpxchg while resetting zero status for possible race
	[suggested by Dave Hansen for KVM patches ]

KVM patch Change history:
Changes in V6:
- Rebased to 3.4-rc3
- Removed debugfs changes patch which should now be in Xen/linux-next.
  (https://lkml.org/lkml/2012/3/30/687)
- Removed PV_UNHALT_MSR since currently we don't need guest communication,
  and made pv_unhalt folded to GET_MP_STATE (Marcello, Avi[long back])
- Take jumplabel changes from Ingo/Jason into use (static_key_slow_inc usage)
- Added inline to spinlock_init in non PARAVIRT case
- Move arch specific code to arch/x86 and add stubs to other archs (Marcello)
- Added more comments on pv_unhalt usage etc (Marcello)

Changes in V5:
- rebased to 3.3-rc6
- added PV_UNHALT_MSR that would help in live migration (Avi)
- removed PV_LOCK_KICK vcpu request and pv_unhalt flag (re)added.
- Changed hypercall documentaion (Alex).
- mode_t changed to umode_t in debugfs.
- MSR related documentation added.
- rename PV_LOCK_KICK to PV_UNHALT. 
- host and guest patches not mixed. (Marcelo, Alex)
- kvm_kick_cpu now takes cpu so it can be used by flush_tlb_ipi_other 
   paravirtualization (Nikunj)
- coding style changes in variable declarion etc (Srikar)

Changes in V4:
- reabsed to 3.2.0 pre.
- use APIC ID for kicking the vcpu and use kvm_apic_match_dest for matching (Avi)
- fold vcpu->kicked flag into vcpu->requests (KVM_REQ_PVLOCK_KICK) and related 
  changes for UNHALT path to make pv ticket spinlock migration friendly(Avi, Marcello)
- Added Documentation for CPUID, Hypercall (KVM_HC_KICK_CPU)
  and capabilty (KVM_CAP_PVLOCK_KICK) (Avi)
- Remove unneeded kvm_arch_vcpu_ioctl_set_mpstate call. (Marcello)
- cumulative variable type changed (int ==> u32) in add_stat (Konrad)
- remove unneeded kvm_guest_init for !CONFIG_KVM_GUEST case

Changes in V3:
- rebased to 3.2-rc1
- use halt() instead of wait for kick hypercall.
- modify kick hyper call to do wakeup halted vcpu.
- hook kvm_spinlock_init to smp_prepare_cpus call (moved the call out of head##.c).
- fix the potential race when zero_stat is read.
- export debugfs_create_32 and add documentation to API.
- use static inline and enum instead of ADDSTAT macro. 
- add  barrier() in after setting kick_vcpu.
- empty static inline function for kvm_spinlock_init.
- combine the patches one and two readuce overhead.
- make KVM_DEBUGFS depends on DEBUGFS.
- include debugfs header unconditionally.

Changes in V2:
- rebased patchesto -rc9
- synchronization related changes based on Jeremy's changes 
 (Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>) pointed by 
 Stephan Diestelhorst <stephan.diestelhorst@amd.com>
- enabling 32 bit guests
- splitted patches into two more chunks

Description:
Ticket locks have an inherent problem in a virtualized case, because
the vCPUs are scheduled rather than running concurrently (ignoring
gang scheduled vCPUs).  This can result in catastrophic performance
collapses when the vCPU scheduler doesn't schedule the correct "next"
vCPU, and ends up scheduling a vCPU which burns its entire timeslice
spinning.  (Note that this is not the same problem as lock-holder
preemption, which this series also addresses; that's also a problem,
but not catastrophic).

(See Thomas Friebel's talk "Prevent Guests from Spinning Around"
http://www.xen.org/files/xensummitboston08/LHP.pdf for more details.)

Currently we deal with this by having PV spinlocks, which adds a layer
of indirection in front of all the spinlock functions, and defining a
completely new implementation for Xen (and for other pvops users, but
there are none at present).

PV ticketlocks keeps the existing ticketlock implemenentation
(fastpath) as-is, but adds a couple of pvops for the slow paths:

- If a CPU has been waiting for a spinlock for SPIN_THRESHOLD
  iterations, then call out to the __ticket_lock_spinning() pvop,
  which allows a backend to block the vCPU rather than spinning.  This
  pvop can set the lock into "slowpath state".

- When releasing a lock, if it is in "slowpath state", the call
  __ticket_unlock_kick() to kick the next vCPU in line awake.  If the
  lock is no longer in contention, it also clears the slowpath flag.

The "slowpath state" is stored in the LSB of the within the lock tail
ticket.  This has the effect of reducing the max number of CPUs by
half (so, a "small ticket" can deal with 128 CPUs, and "large ticket"
32768).

For KVM, one hypercall is introduced in hypervisor,that allows a vcpu to kick
another vcpu out of halt state.
The blocking of vcpu is done using halt() in (lock_spinning) slowpath.

Overall, it results in a large reduction in code, it makes the native
and virtualized cases closer, and it removes a layer of indirection
around all the spinlock functions.

The fast path (taking an uncontended lock which isn't in "slowpath"
state) is optimal, identical to the non-paravirtualized case.

The inner part of ticket lock code becomes:
	inc = xadd(&lock->tickets, inc);
	inc.tail &= ~TICKET_SLOWPATH_FLAG;

	if (likely(inc.head == inc.tail))
		goto out;
	for (;;) {
		unsigned count = SPIN_THRESHOLD;
		do {
			if (ACCESS_ONCE(lock->tickets.head) == inc.tail)
				goto out;
			cpu_relax();
		} while (--count);
		__ticket_lock_spinning(lock, inc.tail);
	}
out:	barrier();
which results in:
	push   %rbp
	mov    %rsp,%rbp

	mov    $0x200,%eax
	lock xadd %ax,(%rdi)
	movzbl %ah,%edx
	cmp    %al,%dl
	jne    1f	# Slowpath if lock in contention

	pop    %rbp
	retq   

	### SLOWPATH START
1:	and    $-2,%edx
	movzbl %dl,%esi

2:	mov    $0x800,%eax
	jmp    4f

3:	pause  
	sub    $0x1,%eax
	je     5f

4:	movzbl (%rdi),%ecx
	cmp    %cl,%dl
	jne    3b

	pop    %rbp
	retq   

5:	callq  *__ticket_lock_spinning
	jmp    2b
	### SLOWPATH END

with CONFIG_PARAVIRT_SPINLOCKS=n, the code has changed slightly, where
the fastpath case is straight through (taking the lock without
contention), and the spin loop is out of line:

	push   %rbp
	mov    %rsp,%rbp

	mov    $0x100,%eax
	lock xadd %ax,(%rdi)
	movzbl %ah,%edx
	cmp    %al,%dl
	jne    1f

	pop    %rbp
	retq   

	### SLOWPATH START
1:	pause  
	movzbl (%rdi),%eax
	cmp    %dl,%al
	jne    1b

	pop    %rbp
	retq   
	### SLOWPATH END

The unlock code is complicated by the need to both add to the lock's
"head" and fetch the slowpath flag from "tail".  This version of the
patch uses a locked add to do this, followed by a test to see if the
slowflag is set.  The lock prefix acts as a full memory barrier, so we
can be sure that other CPUs will have seen the unlock before we read
the flag (without the barrier the read could be fetched from the
store queue before it hits memory, which could result in a deadlock).

This is is all unnecessary complication if you're not using PV ticket
locks, it also uses the jump-label machinery to use the standard
"add"-based unlock in the non-PV case.

	if (TICKET_SLOWPATH_FLAG &&
	     static_key_false(&paravirt_ticketlocks_enabled))) {
		arch_spinlock_t prev;
		prev = *lock;
		add_smp(&lock->tickets.head, TICKET_LOCK_INC);

		/* add_smp() is a full mb() */
		if (unlikely(lock->tickets.tail & TICKET_SLOWPATH_FLAG))
			__ticket_unlock_slowpath(lock, prev);
	} else
		__add(&lock->tickets.head, TICKET_LOCK_INC, UNLOCK_LOCK_PREFIX);
which generates:
	push   %rbp
	mov    %rsp,%rbp

	nop5	# replaced by 5-byte jmp 2f when PV enabled

	# non-PV unlock
	addb   $0x2,(%rdi)

1:	pop    %rbp
	retq   

### PV unlock ###
2:	movzwl (%rdi),%esi	# Fetch prev

	lock addb $0x2,(%rdi)	# Do unlock

	testb  $0x1,0x1(%rdi)	# Test flag
	je     1b		# Finished if not set

### Slow path ###
	add    $2,%sil		# Add "head" in old lock state
	mov    %esi,%edx
	and    $0xfe,%dh	# clear slowflag for comparison
	movzbl %dh,%eax
	cmp    %dl,%al		# If head == tail (uncontended)
	je     4f		# clear slowpath flag

	# Kick next CPU waiting for lock
3:	movzbl %sil,%esi
	callq  *pv_lock_ops.kick

	pop    %rbp
	retq   

	# Lock no longer contended - clear slowflag
4:	mov    %esi,%eax
	lock cmpxchg %dx,(%rdi)	# cmpxchg to clear flag
	cmp    %si,%ax
	jne    3b		# If clear failed, then kick

	pop    %rbp
	retq   

So when not using PV ticketlocks, the unlock sequence just has a
5-byte nop added to it, and the PV case is reasonable straightforward
aside from requiring a "lock add".

Andrew Jones (1):
  jump_label: Split jumplabel ratelimit

Jeremy Fitzhardinge (9):
  x86/spinlock: Replace pv spinlocks with pv ticketlocks
  x86/ticketlock: Collapse a layer of functions
  xen: Defer spinlock setup until boot CPU setup
  xen/pvticketlock: Xen implementation for PV ticket locks
  xen/pvticketlocks: Add xen_nopvspin parameter to disable xen pv
    ticketlocks
  x86/pvticketlock: Use callee-save for lock_spinning
  x86/pvticketlock: When paravirtualizing ticket locks, increment by 2
  x86/ticketlock: Add slowpath logic
  xen/pvticketlock: Allow interrupts to be enabled while blocking

Raghavendra K T (2):
  x86/ticketlock: Don't inline _spin_unlock when using paravirt
    spinlocks
  kvm uapi: Add KICK_CPU and PV_UNHALT definition to uapi

Srivatsa Vaddagiri (2):
  kvm guest : Add configuration support to enable debug information for
    KVM Guests
  kvm : Paravirtual ticketlocks support for linux guests running on KVM
    hypervisor

 arch/x86/Kconfig                      |  10 +
 arch/x86/include/asm/kvm_para.h       |  14 +-
 arch/x86/include/asm/paravirt.h       |  32 +--
 arch/x86/include/asm/paravirt_types.h |  14 +-
 arch/x86/include/asm/spinlock.h       | 128 +++++++----
 arch/x86/include/asm/spinlock_types.h |  16 +-
 arch/x86/include/uapi/asm/kvm_para.h  |   1 +
 arch/x86/kernel/kvm.c                 | 262 +++++++++++++++++++++++
 arch/x86/kernel/paravirt-spinlocks.c  |  18 +-
 arch/x86/xen/smp.c                    |   2 +-
 arch/x86/xen/spinlock.c               | 387 +++++++++++-----------------------
 include/linux/jump_label.h            |  28 +--
 include/linux/jump_label_ratelimit.h  |  34 +++
 include/linux/perf_event.h            |   1 +
 include/uapi/linux/kvm_para.h         |   1 +
 kernel/jump_label.c                   |   1 +
 16 files changed, 569 insertions(+), 380 deletions(-)
 create mode 100644 include/linux/jump_label_ratelimit.h

---
[1]. V11 PV Ticketspinlock for Xen/KVM link: https://lkml.org/lkml/2013/7/22/29
[2]. V10 PV Ticketspinlock for Xen/KVM link: https://lkml.org/lkml/2013/6/24/252
[3]. V9 PV Ticketspinlock for Xen/KVM link:  https://lkml.org/lkml/2013/6/1/168
[4]. V8 PV Ticketspinlock for Xen/KVM link:  https://lkml.org/lkml/2012/5/2/119

-- 
1.7.11.7

