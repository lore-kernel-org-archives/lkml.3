Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977Ab3ICMKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:10:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab3ICMKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:10:49 -0400
Date: Tue, 3 Sep 2013 15:10:46 +0300
From: Gleb Natapov <gleb@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com
Subject: [GIT PULL] KVM changes for 3.12
Message-ID: <20130903121046.GE22899@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=cp1255
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git next

for you to fetch changes up to 6b9e4fa07443f5baf5bbd7ab043abd6976f8d7bc:

  Merge tag 'kvm-arm-for-3.12' of git://git.linaro.org/people/cdall/linux-kvm-arm into queue (2013-09-01 10:48:18 +0300)

The highlights of the release are nested EPT and pv-ticketlocks support
(hypervisor part, guest part, which is most of the code, goes through tip tree).
Apart of that there are many fixes for all arches.

---

This pull request adds tlb_gather_mmu() caller in S390 code, but 2b047252
in your tree added another parameter to the function, so the patch bellow
have to be applied during merge to resolve the conflicts. The patch was
used in linux-next for awhile.

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Wed, 21 Aug 2013 16:46:25 +0200
Subject: [PATCH] s390: fix tlb_gather_mmu fallout

With commit 2b047252 "Fix TLB gather virtual address range invalidation
corner cases" tlb_gather_mmu() got a new argument.
There is however a patch in the kvm/linux-next tree "KVM: s390: allow sie
enablement for multi-threaded programs" which now causes breakage in
linux-next:

arch/s390/mm/pgtable.c: In function ‘s390_enable_sie’:
arch/s390/mm/pgtable.c:1175:2: error: too few arguments to function ‘tlb_gather_mmu’

So let's fix just this.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/mm/pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index ef34519..8a123da 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -1172,7 +1172,7 @@ int s390_enable_sie(void)
 	thp_split_mm(mm);
 	/* Reallocate the page tables with pgstes */
 	mm->context.has_pgste = 1;
-	tlb_gather_mmu(&tlb, mm, 0);
+	tlb_gather_mmu(&tlb, mm, 0, TASK_SIZE);
 	page_table_realloc(&tlb, mm, 0, TASK_SIZE);
 	tlb_finish_mmu(&tlb, 0, -1);
 	up_write(&mm->mmap_sem);
-- 
1.8.2.3

----------------------------------------------------------------

Alexander Graf (3):
      Merge remote-tracking branch 'cmadma/for-v3.12-cma-dma' into kvm-ppc-next
      KVM: PPC: Book3S: Ignore DABR register
      Merge remote-tracking branch 'origin/next' into kvm-ppc-next

Alexey Kardashevskiy (1):
      KVM: PPC: reserve a capability number for multitce support

Andi Kleen (1):
      perf, kvm: Support the in_tx/in_tx_cp modifiers in KVM arch perfmon emulation v5

Andrea Arcangeli (1):
      kvm: optimize away THP checks in kvm_is_mmio_pfn()

Aneesh Kumar K.V (5):
      mm/cma: Move dma contiguous changes into a seperate config
      powerpc/kvm: Contiguous memory allocator based hash page table allocation
      powerpc/kvm: Contiguous memory allocator based RMA allocation
      powerpc/kvm: Use 256K chunk to track both RMA and hash page table allocation.
      powerpc/kvm: Copy the pvr value after memset

Arthur Chunqi Li (4):
      KVM: nVMX: Change location of 3 functions in vmx.c
      KVM: nVMX: Set success rflags when emulate VMXON/VMXOFF in nested virt
      KVM: nVMX: Set segment infomation of L1 when L2 exits
      KVM: nVMX: Advertise IA32_PAT in VM exit control

Chen Gang (1):
      arch: powerpc: kvm: add signed type cast for comparation

Christoffer Dall (6):
      ARM: KVM: Bugfix: vgic_bytemap_get_reg per cpu regs
      ARM: KVM: vgic: Bump VGIC_NR_IRQS to 256
      ARM: KVM: Fix kvm_set_pte assignment
      ARM: KVM: Simplify tracepoint text
      ARM: KVM: Work around older compiler bug
      ARM: KVM: Add newlines to panic strings

Cornelia Huck (2):
      KVM: kvm-io: support cookies
      KVM: s390: use cookies for ioeventfd

David Daney (3):
      mips/kvm: Improve code formatting in arch/mips/kvm/kvm_locore.S
      mips/kvm: Cleanup .push/.pop directives in kvm_locore.S
      mips/kvm: Make kvm_locore.S 64-bit buildable/safe.

Dominik Dingel (1):
      KVM: s390: Make KVM_HVA_ERR_BAD usable on s390

Gleb Natapov (7):
      nVMX: reset rflags register cache during nested vmentry.
      KVM: nVMX: correctly set tr base on nested vmexit emulation
      nEPT: make guest's A/D bits depends on guest's paging mode
      nEPT: Support shadow paging for guest paging without A/D bits
      nEPT: correctly check if remote tlb flush is needed for shadowed EPT tables
      Merge branch 'kvm-ppc-next' of git://github.com/agraf/linux-2.6 into queue
      Merge tag 'kvm-arm-for-3.12' of git://git.linaro.org/people/cdall/linux-kvm-arm into queue

Jan Kiszka (6):
      KVM: x86: Simplify __apic_accept_irq
      KVM: x86: Drop some unused functions from lapic
      nVMX: Keep arch.pat in sync on L1-L2 switches
      KVM: nEPT: Advertise WB type EPTP
      KVM: nVMX: Fix up VM_ENTRY_IA32E_MODE control feature reporting
      KVM: x86: Update symbolic exit codes

Marc Zyngier (2):
      ARM: KVM: vgic: simplify vgic_get_target_reg
      ARM: KVM: vgic: fix GICD_ICFGRn access

Marcelo Tosatti (2):
      remove sched notifier for cross-cpu migrations
      KVM: x86: update masterclock when kvmclock_offset is calculated (v2)

Martin Schwidefsky (2):
      KVM: s390: allow sie enablement for multi-threaded programs
      KVM: s390: fix task size check

Mathias Krause (2):
      KVM: VMX: Use proper types to access const arrays
      KVM: x86: Drop useless cast

Michael Mueller (1):
      KVM: s390: declare virtual HW facilities

Nadav Har'El (11):
      KVM: nVMX: Fix read/write to MSR_IA32_FEATURE_CONTROL
      nEPT: Support LOAD_IA32_EFER entry/exit controls for L1
      nEPT: Fix cr3 handling in nested exit and entry
      nEPT: Fix wrong test in kvm_set_cr3
      nEPT: Move common code to paging_tmpl.h
      nEPT: Add EPT tables support to paging_tmpl.h
      nEPT: MMU context for nested EPT
      nEPT: Nested INVEPT
      Advertise the support of EPT to the L1 guest, through the appropriate MSR.
      nEPT: Some additional comments
      nEPT: Miscelleneous cleanups

Paolo Bonzini (7):
      KVM: introduce __kvm_io_bus_sort_cmp
      KVM: x86: rename EMULATE_DO_MMIO
      KVM: x86: handle hardware breakpoints during emulation
      KVM: x86: handle singlestep during emulation
      KVM: rename __kvm_io_bus_sort_cmp to kvm_io_bus_cmp
      KVM: vmx: count exits to userspace during invalid guest emulation
      KVM: x86: add comments where MMIO does not return to the emulator

Paul Mackerras (7):
      KVM: PPC: Book3S HV: Correct tlbie usage
      KVM: PPC: Book3S HV: Allow negative offsets to real-mode hcall handlers
      KVM: PPC: Book3S PR: Load up SPRG3 register with guest value on guest entry
      KVM: PPC: Book3S: Fix compile error in XICS emulation
      KVM: PPC: Book3S PR: Don't corrupt guest state when kernel uses VMX
      KVM: PPC: Book3S PR: Make instruction fetch fallback work for system calls
      KVM: PPC: Book3S PR: Rework kvmppc_mmu_book3s_64_xlate()

Raghavendra K T (3):
      kvm uapi: Add KICK_CPU and PV_UNHALT definition to uapi
      kvm hypervisor: Simplify kvm_for_each_vcpu with kvm_irq_delivery_to_apic
      Documentation/kvm : Add documentation on Hypercalls and features used for PV spinlock

Scott Wood (2):
      kvm/ppc: Call trace_hardirqs_on before entry
      kvm/ppc/booke: Don't call kvm_guest_enter twice

Srivatsa Vaddagiri (1):
      kvm hypervisor : Add a hypercall to KVM hypervisor to support pv-ticketlocks

Takuya Yoshikawa (2):
      KVM: Introduce kvm_arch_memslots_updated()
      KVM: x86: Avoid zapping mmio sptes twice for generation wraparound

Thadeu Lima de Souza Cascardo (1):
      KVM: PPC: Book3S PR: return appropriate error when allocation fails

Thomas Huth (2):
      KVM: s390: Fix sparse warnings in priv.c
      KVM: s390: Add helper function for setting condition code

Xiao Guangrong (3):
      KVM: MMU: avoid fast page fault fixing mmio page fault
      KVM: MMU: fix check the reserved bits on the gpte of L2
      KVM: MMU: remove unused parameter

Yang Zhang (2):
      nEPT: Redefine EPT-specific link_shadow_page()
      nEPT: Add nEPT violation/misconfigration support

Yann Droneaud (2):
      kvm: use anon_inode_getfd() with O_CLOEXEC flag
      ppc: kvm: use anon_inode_getfd() with O_CLOEXEC flag

 Documentation/virtual/kvm/cpuid.txt      |    4 +
 Documentation/virtual/kvm/hypercalls.txt |   14 +
 arch/arm/include/asm/dma-contiguous.h    |    2 +-
 arch/arm/include/asm/kvm_mmu.h           |    2 +-
 arch/arm/kvm/arm.c                       |    4 +
 arch/arm/kvm/interrupts.S                |    8 +-
 arch/arm/kvm/reset.c                     |    2 +-
 arch/arm/kvm/trace.h                     |    7 +-
 arch/arm/mm/dma-mapping.c                |    6 +-
 arch/ia64/kvm/kvm-ia64.c                 |    4 +
 arch/mips/kvm/kvm_locore.S               |  969 +++++++++++++++---------------
 arch/mips/kvm/kvm_mips.c                 |    4 +
 arch/powerpc/include/asm/kvm_book3s.h    |   38 ++
 arch/powerpc/include/asm/kvm_book3s_64.h |    4 +-
 arch/powerpc/include/asm/kvm_host.h      |   14 +-
 arch/powerpc/include/asm/kvm_ppc.h       |   25 +-
 arch/powerpc/kernel/asm-offsets.c        |    1 +
 arch/powerpc/kernel/setup_64.c           |    4 +-
 arch/powerpc/kvm/Kconfig                 |    1 +
 arch/powerpc/kvm/Makefile                |    1 +
 arch/powerpc/kvm/book3s_64_mmu.c         |  150 +++--
 arch/powerpc/kvm/book3s_64_mmu_hv.c      |   42 +-
 arch/powerpc/kvm/book3s_64_vio.c         |    2 +-
 arch/powerpc/kvm/book3s_emulate.c        |    2 +
 arch/powerpc/kvm/book3s_hv.c             |   40 +-
 arch/powerpc/kvm/book3s_hv_builtin.c     |  246 +++-----
 arch/powerpc/kvm/book3s_hv_cma.c         |  240 ++++++++
 arch/powerpc/kvm/book3s_hv_cma.h         |   27 +
 arch/powerpc/kvm/book3s_hv_rm_mmu.c      |  139 +++--
 arch/powerpc/kvm/book3s_hv_rmhandlers.S  |    2 +-
 arch/powerpc/kvm/book3s_interrupts.S     |   14 +
 arch/powerpc/kvm/book3s_pr.c             |   40 +-
 arch/powerpc/kvm/book3s_xics.c           |    1 +
 arch/powerpc/kvm/booke.c                 |    6 +-
 arch/powerpc/kvm/powerpc.c               |    6 +-
 arch/s390/include/asm/kvm_host.h         |    8 +
 arch/s390/include/asm/mmu.h              |    2 -
 arch/s390/include/asm/mmu_context.h      |   19 +-
 arch/s390/include/asm/pgtable.h          |   11 +
 arch/s390/include/asm/processor.h        |    2 +
 arch/s390/kvm/diag.c                     |   17 +-
 arch/s390/kvm/kvm-s390.c                 |   27 +-
 arch/s390/kvm/kvm-s390.h                 |   10 +
 arch/s390/kvm/priv.c                     |   32 +-
 arch/s390/mm/pgtable.c                   |  183 ++++--
 arch/x86/include/asm/kvm_host.h          |   14 +-
 arch/x86/include/asm/pvclock.h           |    1 -
 arch/x86/include/asm/vmx.h               |    2 +
 arch/x86/include/uapi/asm/kvm_para.h     |    1 +
 arch/x86/include/uapi/asm/vmx.h          |    6 +-
 arch/x86/kernel/pvclock.c                |   44 --
 arch/x86/kvm/cpuid.c                     |    3 +-
 arch/x86/kvm/lapic.c                     |   38 +-
 arch/x86/kvm/mmu.c                       |  188 +++---
 arch/x86/kvm/mmu.h                       |    2 +
 arch/x86/kvm/paging_tmpl.h               |  178 +++++-
 arch/x86/kvm/pmu.c                       |   25 +-
 arch/x86/kvm/vmx.c                       |  441 +++++++++++---
 arch/x86/kvm/x86.c                       |  224 +++++--
 arch/x86/vdso/vclock_gettime.c           |   16 +-
 drivers/base/Kconfig                     |   20 +-
 drivers/base/Makefile                    |    2 +-
 include/kvm/arm_vgic.h                   |    2 +-
 include/linux/dma-contiguous.h           |    2 +-
 include/linux/kvm_host.h                 |   13 +
 include/linux/sched.h                    |    8 -
 include/uapi/linux/kvm.h                 |    1 +
 include/uapi/linux/kvm_para.h            |    1 +
 kernel/sched/core.c                      |   15 -
 mm/Kconfig                               |   24 +
 virt/kvm/arm/vgic.c                      |   22 +-
 virt/kvm/kvm_main.c                      |  156 +++--
 72 files changed, 2424 insertions(+), 1407 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_hv_cma.c
 create mode 100644 arch/powerpc/kvm/book3s_hv_cma.h
--
			Gleb.
