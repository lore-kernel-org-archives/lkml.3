Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab3FGXDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:03:48 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:43315 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab3FGXDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:46 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 00/31] KVM/MIPS: Implement hardware virtualization via the MIPS-VZ extensions.
Date: Fri,  7 Jun 2013 16:03:04 -0700
Message-Id: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

These patches take a somewhat different approach to MIPS
virtualization via the MIPS-VZ extensions than the patches previously
sent by Sanjay Lal.

Several facts about the code:

o Existing exception handlers are modified to hook in to KVM instead
  of intercepting all exceptions via the EBase register, and then
  chaining to real exception handlers.

o Able to boot 64-bit SMP guests that use the FPU (I have booted 4-way
  SMP 64-bit MIPS/Linux).

o Additional overhead on every exception even when *no* vCPU is running.

o Lower interrupt overhead, than the EBase interception method, when
  vCPU *is* running.

o This code is somewhat smaller than the existing trap/emulate
  implementation (about 2100 lines vs. about 5300 lines)

o Currently probably only usable on the OCTEON III CPU model, as some
  MIPS-VZ implementation-defined behaviors were assumed to have the
  OCTEON III behavior.

Note: I think Ralf already has the 17/31 (MIPS: Quit exposing Kconfig
symbols in uapi headers.) queued, but I also include it here.

David Daney (31):
  MIPS: Move allocate_kscratch to cpu-probe.c and make it public.
  MIPS: Save and restore K0/K1 when CONFIG_KVM_MIPSVZ
  mips/kvm: Fix 32-bitisms in kvm_locore.S
  mips/kvm: Add casts to avoid pointer width mismatch build failures.
  mips/kvm: Use generic cache flushing functions.
  mips/kvm: Rename kvm_vcpu_arch.pc to  kvm_vcpu_arch.epc
  mips/kvm: Rename VCPU_registername to KVM_VCPU_ARCH_registername
  mips/kvm: Fix code formatting in arch/mips/kvm/kvm_locore.S
  mips/kvm: Factor trap-and-emulate support into a pluggable
    implementation.
  mips/kvm: Implement ioctls to get and set FPU registers.
  MIPS: Rearrange branch.c so it can be used by kvm code.
  MIPS: Add instruction format information for WAIT, MTC0, MFC0, et al.
  mips/kvm: Add accessors for MIPS VZ registers.
  mips/kvm: Add thread_info flag to indicate operation in MIPS VZ Guest
    Mode.
  mips/kvm: Exception handling to leave and reenter guest mode.
  mips/kvm: Add exception handler for MIPSVZ Guest exceptions.
  MIPS: Quit exposing Kconfig symbols in uapi headers.
  mips/kvm: Add pt_regs slots for BadInstr and BadInstrP
  mips/kvm: Add host definitions for MIPS VZ based host.
  mips/kvm: Hook into TLB fault handlers.
  mips/kvm: Allow set_except_vector() to be used from MIPSVZ code.
  mips/kvm: Split get_new_mmu_context into two parts.
  mips/kvm: Hook into CP unusable exception handler.
  mips/kvm: Add thread_struct fields used by MIPSVZ hosts.
  mips/kvm: Add some asm-offsets constants used by MIPSVZ.
  mips/kvm: Split up Kconfig and Makefile definitions in preperation
    for MIPSVZ.
  mips/kvm: Gate the use of kvm_local_flush_tlb_all() by KVM_MIPSTE
  mips/kvm: Only use KVM_COALESCED_MMIO_PAGE_OFFSET with KVM_MIPSTE
  mips/kvm: Add MIPSVZ support.
  mips/kvm: Enable MIPSVZ in Kconfig/Makefile
  mips/kvm: Allow for upto 8 KVM vcpus per vm.

 arch/mips/Kconfig                   |    1 +
 arch/mips/include/asm/branch.h      |    7 +
 arch/mips/include/asm/kvm_host.h    |  622 +-----------
 arch/mips/include/asm/kvm_mips_te.h |  589 +++++++++++
 arch/mips/include/asm/kvm_mips_vz.h |   29 +
 arch/mips/include/asm/mipsregs.h    |  264 +++++
 arch/mips/include/asm/mmu_context.h |   12 +-
 arch/mips/include/asm/processor.h   |    6 +
 arch/mips/include/asm/ptrace.h      |   36 +
 arch/mips/include/asm/stackframe.h  |  150 ++-
 arch/mips/include/asm/thread_info.h |    2 +
 arch/mips/include/asm/uasm.h        |    2 +-
 arch/mips/include/uapi/asm/inst.h   |   23 +-
 arch/mips/include/uapi/asm/ptrace.h |   17 +-
 arch/mips/kernel/asm-offsets.c      |  124 ++-
 arch/mips/kernel/branch.c           |   63 +-
 arch/mips/kernel/cpu-probe.c        |   34 +
 arch/mips/kernel/genex.S            |    8 +
 arch/mips/kernel/scall64-64.S       |   12 +
 arch/mips/kernel/scall64-n32.S      |   12 +
 arch/mips/kernel/traps.c            |   15 +-
 arch/mips/kvm/Kconfig               |   23 +-
 arch/mips/kvm/Makefile              |   15 +-
 arch/mips/kvm/kvm_locore.S          |  980 +++++++++---------
 arch/mips/kvm/kvm_mips.c            |  768 ++------------
 arch/mips/kvm/kvm_mips_comm.h       |    1 +
 arch/mips/kvm/kvm_mips_commpage.c   |    9 +-
 arch/mips/kvm/kvm_mips_dyntrans.c   |    4 +-
 arch/mips/kvm/kvm_mips_emul.c       |  312 +++---
 arch/mips/kvm/kvm_mips_int.c        |   53 +-
 arch/mips/kvm/kvm_mips_int.h        |    2 -
 arch/mips/kvm/kvm_mips_stats.c      |    6 +-
 arch/mips/kvm/kvm_mipsvz.c          | 1894 +++++++++++++++++++++++++++++++++++
 arch/mips/kvm/kvm_mipsvz_guest.S    |  234 +++++
 arch/mips/kvm/kvm_tlb.c             |  140 +--
 arch/mips/kvm/kvm_trap_emul.c       |  932 +++++++++++++++--
 arch/mips/mm/fault.c                |    8 +
 arch/mips/mm/tlbex-fault.S          |    6 +
 arch/mips/mm/tlbex.c                |   45 +-
 39 files changed, 5299 insertions(+), 2161 deletions(-)
 create mode 100644 arch/mips/include/asm/kvm_mips_te.h
 create mode 100644 arch/mips/include/asm/kvm_mips_vz.h
 create mode 100644 arch/mips/kvm/kvm_mipsvz.c
 create mode 100644 arch/mips/kvm/kvm_mipsvz_guest.S

-- 
1.7.11.7

