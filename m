Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3FAISC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 04:18:02 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:60752 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3FAIRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 04:17:49 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <gleb@redhat.com>, <mingo@redhat.com>, <jeremy@goop.org>, <x86@kernel.org>,
        <konrad.wilk@oracle.com>, <hpa@zytor.com>, <pbonzini@redhat.com>
Cc: linux-doc@vger.kernel.org, <habanero@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        <xen-devel@lists.xensource.com>, <peterz@infradead.org>,
        <mtosatti@redhat.com>, <stefano.stabellini@eu.citrix.com>,
        <andi@firstfloor.org>, <attilio.rao@citrix.com>, <ouyang@cs.pitt.edu>,
        <gregkh@suse.de>, <agraf@suse.de>, <chegu_vinod@hp.com>,
        <torvalds@linux-foundation.org>, <avi.kivity@gmail.com>,
        <tglx@linutronix.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stephan.diestelhorst@amd.com>,
        <riel@redhat.com>, <drjones@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <srivatsa.vaddagiri@gmail.com>
Date: Sat, 01 Jun 2013 13:51:51 +0530
Message-Id: <20130601082145.22955.33596.sendpatchset@codeblue>
Subject: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060108-2000-0000-0000-00000C542BD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series replaces the existing paravirtualized spinlock mechanism
with a paravirtualized ticketlock mechanism. The series provides
implementation for both Xen and KVM.

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


Results:
=======
base = 3.10-rc2 kernel
patched = base + this series

The test was on 32 core (model: Intel(R) Xeon(R) CPU X7560) HT disabled
with 32 KVM guest vcpu 8GB RAM.

+-----------+-----------+-----------+------------+-----------+
               ebizzy (records/sec) higher is better
+-----------+-----------+-----------+------------+-----------+
    base        stdev        patched    stdev        %improvement
+-----------+-----------+-----------+------------+-----------+
1x  5574.9000   237.4997    5618.0000    94.0366     0.77311
2x  2741.5000   561.3090    3332.0000   102.4738    21.53930
3x  2146.2500   216.7718    2302.3333    76.3870     7.27237
4x  1663.0000   141.9235    1753.7500    83.5220     5.45701
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
              dbench  (Throughput) higher is better
+-----------+-----------+-----------+------------+-----------+
    base        stdev        patched    stdev        %improvement
+-----------+-----------+-----------+------------+-----------+
1x 14111.5600   754.4525   14645.9900   114.3087     3.78718
2x  2481.6270    71.2665    2667.1280    73.8193     7.47498
3x  1510.2483    31.8634    1503.8792    36.0777    -0.42173
4x  1029.4875    16.9166    1039.7069    43.8840     0.99267
+-----------+-----------+-----------+------------+-----------+

Your suggestions and comments are welcome.

github link: https://github.com/ktraghavendra/linux/tree/pvspinlock_v9


Please note that we set SPIN_THRESHOLD = 32k with this series,
that would eatup little bit of overcommit performance of PLE machines
and overall performance of non-PLE machines. 

The older series was tested by Attilio for Xen implementation [1].

Jeremy Fitzhardinge (9):
 x86/spinlock: Replace pv spinlocks with pv ticketlocks
 x86/ticketlock: Collapse a layer of functions
 xen: Defer spinlock setup until boot CPU setup
 xen/pvticketlock: Xen implementation for PV ticket locks
 xen/pvticketlocks: Add xen_nopvspin parameter to disable xen pv ticketlocks
 x86/pvticketlock: Use callee-save for lock_spinning
 x86/pvticketlock: When paravirtualizing ticket locks, increment by 2
 x86/ticketlock: Add slowpath logic
 xen/pvticketlock: Allow interrupts to be enabled while blocking

Andrew Jones (1):
 Split jumplabel ratelimit

Stefano Stabellini (1):
 xen: Enable PV ticketlocks on HVM Xen

Srivatsa Vaddagiri (3):
 kvm hypervisor : Add a hypercall to KVM hypervisor to support pv-ticketlocks
 kvm guest : Add configuration support to enable debug information for KVM Guests
 kvm : Paravirtual ticketlocks support for linux guests running on KVM hypervisor

Raghavendra K T (5):
 x86/ticketlock: Don't inline _spin_unlock when using paravirt spinlocks
 kvm : Fold pv_unhalt flag into GET_MP_STATE ioctl to aid migration
 Simplify kvm_for_each_vcpu with kvm_irq_delivery_to_apic
 Documentation/kvm : Add documentation on Hypercalls and features used for PV spinlock
 Add directed yield in vcpu block path

---
Link in V8 has links to previous patch series and also whole history.

V8 PV Ticketspinlock for Xen/KVM link:
[1] https://lkml.org/lkml/2012/5/2/119

 Documentation/virtual/kvm/cpuid.txt      |   4 +
 Documentation/virtual/kvm/hypercalls.txt |  13 ++
 arch/ia64/include/asm/kvm_host.h         |   5 +
 arch/powerpc/include/asm/kvm_host.h      |   5 +
 arch/s390/include/asm/kvm_host.h         |   5 +
 arch/x86/Kconfig                         |  10 +
 arch/x86/include/asm/kvm_host.h          |   7 +-
 arch/x86/include/asm/kvm_para.h          |  14 +-
 arch/x86/include/asm/paravirt.h          |  32 +--
 arch/x86/include/asm/paravirt_types.h    |  10 +-
 arch/x86/include/asm/spinlock.h          | 128 +++++++----
 arch/x86/include/asm/spinlock_types.h    |  16 +-
 arch/x86/include/uapi/asm/kvm_para.h     |   1 +
 arch/x86/kernel/kvm.c                    | 256 +++++++++++++++++++++
 arch/x86/kernel/paravirt-spinlocks.c     |  18 +-
 arch/x86/kvm/cpuid.c                     |   3 +-
 arch/x86/kvm/lapic.c                     |   5 +-
 arch/x86/kvm/x86.c                       |  39 +++-
 arch/x86/xen/smp.c                       |   3 +-
 arch/x86/xen/spinlock.c                  | 384 ++++++++++---------------------
 include/linux/jump_label.h               |  26 +--
 include/linux/jump_label_ratelimit.h     |  34 +++
 include/linux/kvm_host.h                 |   2 +-
 include/linux/perf_event.h               |   1 +
 include/uapi/linux/kvm_para.h            |   1 +
 kernel/jump_label.c                      |   1 +
 virt/kvm/kvm_main.c                      |   6 +-
 27 files changed, 645 insertions(+), 384 deletions(-)

