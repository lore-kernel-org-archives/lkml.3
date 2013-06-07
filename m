Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161028Ab3FGXPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:15:07 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:42418
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932204Ab3FGXPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:15:05 -0400
X-Forefront-Antispam-Report: CIP:157.56.238.53;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0712HT002.namprd07.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
Message-ID: <51B26974.5000306@caviumnetworks.com>
Date: Fri, 7 Jun 2013 16:15:00 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>, <kvm@vger.kernel.org>
CC: <linux-mips@linux-mips.org>, <ralf@linux-mips.org>,
        Sanjay Lal <sanjayl@kymasys.com>, <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 00/31] KVM/MIPS: Implement hardware virtualization via
 the MIPS-VZ extensions.
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I should also add that I will shortly send patches for the kvm tool 
required to drive this VM as well as a small set of patches that create 
a para-virtualized MIPS/Linux guest kernel.

The idea is that because there is no standard SMP linux system, we 
create a standard para-virtualized system that uses a handful of 
hypercalls, but mostly just uses virtio devices.  It has no emulated 
real hardware (no 8250 UART, no emulated legacy anything...)

David Daney


On 06/07/2013 04:03 PM, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
>
> These patches take a somewhat different approach to MIPS
> virtualization via the MIPS-VZ extensions than the patches previously
> sent by Sanjay Lal.
>
> Several facts about the code:
>
> o Existing exception handlers are modified to hook in to KVM instead
>    of intercepting all exceptions via the EBase register, and then
>    chaining to real exception handlers.
>
> o Able to boot 64-bit SMP guests that use the FPU (I have booted 4-way
>    SMP 64-bit MIPS/Linux).
>
> o Additional overhead on every exception even when *no* vCPU is running.
>
> o Lower interrupt overhead, than the EBase interception method, when
>    vCPU *is* running.
>
> o This code is somewhat smaller than the existing trap/emulate
>    implementation (about 2100 lines vs. about 5300 lines)
>
> o Currently probably only usable on the OCTEON III CPU model, as some
>    MIPS-VZ implementation-defined behaviors were assumed to have the
>    OCTEON III behavior.
>
> Note: I think Ralf already has the 17/31 (MIPS: Quit exposing Kconfig
> symbols in uapi headers.) queued, but I also include it here.
>
> David Daney (31):
>    MIPS: Move allocate_kscratch to cpu-probe.c and make it public.
>    MIPS: Save and restore K0/K1 when CONFIG_KVM_MIPSVZ
>    mips/kvm: Fix 32-bitisms in kvm_locore.S
>    mips/kvm: Add casts to avoid pointer width mismatch build failures.
>    mips/kvm: Use generic cache flushing functions.
>    mips/kvm: Rename kvm_vcpu_arch.pc to  kvm_vcpu_arch.epc
>    mips/kvm: Rename VCPU_registername to KVM_VCPU_ARCH_registername
>    mips/kvm: Fix code formatting in arch/mips/kvm/kvm_locore.S
>    mips/kvm: Factor trap-and-emulate support into a pluggable
>      implementation.
>    mips/kvm: Implement ioctls to get and set FPU registers.
>    MIPS: Rearrange branch.c so it can be used by kvm code.
>    MIPS: Add instruction format information for WAIT, MTC0, MFC0, et al.
>    mips/kvm: Add accessors for MIPS VZ registers.
>    mips/kvm: Add thread_info flag to indicate operation in MIPS VZ Guest
>      Mode.
>    mips/kvm: Exception handling to leave and reenter guest mode.
>    mips/kvm: Add exception handler for MIPSVZ Guest exceptions.
>    MIPS: Quit exposing Kconfig symbols in uapi headers.
>    mips/kvm: Add pt_regs slots for BadInstr and BadInstrP
>    mips/kvm: Add host definitions for MIPS VZ based host.
>    mips/kvm: Hook into TLB fault handlers.
>    mips/kvm: Allow set_except_vector() to be used from MIPSVZ code.
>    mips/kvm: Split get_new_mmu_context into two parts.
>    mips/kvm: Hook into CP unusable exception handler.
>    mips/kvm: Add thread_struct fields used by MIPSVZ hosts.
>    mips/kvm: Add some asm-offsets constants used by MIPSVZ.
>    mips/kvm: Split up Kconfig and Makefile definitions in preperation
>      for MIPSVZ.
>    mips/kvm: Gate the use of kvm_local_flush_tlb_all() by KVM_MIPSTE
>    mips/kvm: Only use KVM_COALESCED_MMIO_PAGE_OFFSET with KVM_MIPSTE
>    mips/kvm: Add MIPSVZ support.
>    mips/kvm: Enable MIPSVZ in Kconfig/Makefile
>    mips/kvm: Allow for upto 8 KVM vcpus per vm.
>
>   arch/mips/Kconfig                   |    1 +
>   arch/mips/include/asm/branch.h      |    7 +
>   arch/mips/include/asm/kvm_host.h    |  622 +-----------
>   arch/mips/include/asm/kvm_mips_te.h |  589 +++++++++++
>   arch/mips/include/asm/kvm_mips_vz.h |   29 +
>   arch/mips/include/asm/mipsregs.h    |  264 +++++
>   arch/mips/include/asm/mmu_context.h |   12 +-
>   arch/mips/include/asm/processor.h   |    6 +
>   arch/mips/include/asm/ptrace.h      |   36 +
>   arch/mips/include/asm/stackframe.h  |  150 ++-
>   arch/mips/include/asm/thread_info.h |    2 +
>   arch/mips/include/asm/uasm.h        |    2 +-
>   arch/mips/include/uapi/asm/inst.h   |   23 +-
>   arch/mips/include/uapi/asm/ptrace.h |   17 +-
>   arch/mips/kernel/asm-offsets.c      |  124 ++-
>   arch/mips/kernel/branch.c           |   63 +-
>   arch/mips/kernel/cpu-probe.c        |   34 +
>   arch/mips/kernel/genex.S            |    8 +
>   arch/mips/kernel/scall64-64.S       |   12 +
>   arch/mips/kernel/scall64-n32.S      |   12 +
>   arch/mips/kernel/traps.c            |   15 +-
>   arch/mips/kvm/Kconfig               |   23 +-
>   arch/mips/kvm/Makefile              |   15 +-
>   arch/mips/kvm/kvm_locore.S          |  980 +++++++++---------
>   arch/mips/kvm/kvm_mips.c            |  768 ++------------
>   arch/mips/kvm/kvm_mips_comm.h       |    1 +
>   arch/mips/kvm/kvm_mips_commpage.c   |    9 +-
>   arch/mips/kvm/kvm_mips_dyntrans.c   |    4 +-
>   arch/mips/kvm/kvm_mips_emul.c       |  312 +++---
>   arch/mips/kvm/kvm_mips_int.c        |   53 +-
>   arch/mips/kvm/kvm_mips_int.h        |    2 -
>   arch/mips/kvm/kvm_mips_stats.c      |    6 +-
>   arch/mips/kvm/kvm_mipsvz.c          | 1894 +++++++++++++++++++++++++++++++++++
>   arch/mips/kvm/kvm_mipsvz_guest.S    |  234 +++++
>   arch/mips/kvm/kvm_tlb.c             |  140 +--
>   arch/mips/kvm/kvm_trap_emul.c       |  932 +++++++++++++++--
>   arch/mips/mm/fault.c                |    8 +
>   arch/mips/mm/tlbex-fault.S          |    6 +
>   arch/mips/mm/tlbex.c                |   45 +-
>   39 files changed, 5299 insertions(+), 2161 deletions(-)
>   create mode 100644 arch/mips/include/asm/kvm_mips_te.h
>   create mode 100644 arch/mips/include/asm/kvm_mips_vz.h
>   create mode 100644 arch/mips/kvm/kvm_mipsvz.c
>   create mode 100644 arch/mips/kvm/kvm_mipsvz_guest.S
>


