Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbaFIM7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 08:59:22 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:39449 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaFIM7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:59:20 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, gleb@kernel.org
Subject: [PATCH 00/25] KVM: x86: Speed up emulation of invalid state
Date: Mon,  9 Jun 2014 14:58:48 +0200
Message-Id: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series, done in collaboration with Bandan Das, speeds up
emulation of invalid state by approximately a factor of 4
(as measured by realmode.flat).  It brings together patches sent
as RFC in the past 3 months, and adds a few more on top.

The total speedup achieved is around 3x.  Some changes shave a constant
number of cycles from all instructions; others only affect more complex
instructions that take more clock cycles to run.  Together, these two
different effects make the speedup nicely homogeneous across various kinds
of instructions.  Here are rough numbers (expressed in clock cycles on a
Sandy Bridge Xeon machine, with unrestricted_guest=0) at various points
of the series:

    jump  move  arith load  store RMW
    2300  2600  2500  2800  2800  3200
    1650  1950  1900  2150  2150  2600   KVM: vmx: speed up emulation of invalid guest state
    900   1250  1050  1350  1300  1700   KVM: x86: avoid useless set of KVM_REQ_EVENT after emulation
    900   1050  1050  1350  1300  1700   KVM: emulate: speed up emulated moves
    900   1050  1050  1300  1250  1400   KVM: emulate: extend memory access optimization to stores
    825   1000  1000  1250  1200  1350   KVM: emulate: do not initialize memopp
    750   950   950   1150  1050  1200   KVM: emulate: avoid per-byte copying in instruction fetches
    720   850   850   1075  1000  1100   KVM: x86: use kvm_read_guest_page for emulator accesses

The above only lists the patches where the improvement on kvm-unit-tests
became consistently identifiable and reproducible.  Take these with a
grain of salt, since all the rounding here was done by hand, no stddev
is provided, etc.

I tried to be quite strict and limited this series to patches that obey
the following criteria:

* either the patch is by itself a measurable improvement
(example: patch 6)

* or the patch is a really really obvious improvement (example:
patch 17), the compiler must really screw up for this not to be the
case

* or the patch is just preparatory for a subsequent measurable
improvement.

Quite a few functions disappear from the profile, and others have their
cost cut by a pretty large factor:

   61643         [kvm_intel]       vmx_segment_access_rights
   47504         [kvm]             vcpu_enter_guest
   34610         [kvm_intel]       rmode_segment_valid
   30312  7119   [kvm_intel]       vmx_get_segment
   27371 23363   [kvm]             x86_decode_insn
   20924 21185   [kernel.kallsyms] copy_user_generic_string
   18775  3614   [kvm_intel]       vmx_read_guest_seg_selector
   18040  9580   [kvm]             emulator_get_segment
   16061  5791   [kvm]             do_insn_fetch (__do_insn_fetch_bytes after patches)
   15834  5530   [kvm]             kvm_read_guest (kvm_fetch_guest_virt after patches)
   15721         [kernel.kallsyms] __srcu_read_lock
   15439  4115   [kvm]             init_emulate_ctxt
   14421 11692   [kvm]             x86_emulate_instruction
   12498         [kernel.kallsyms] __srcu_read_unlock
   12385 11779   [kvm]             __linearize
   12385 13194   [kvm]             decode_operand
    7408  5574   [kvm]             x86_emulate_insn
    6447         [kvm]             kvm_lapic_find_highest_irr
    6390         [kvm_intel]       vmx_handle_exit
    5598  3418   [kvm_intel]       vmx_interrupt_allowed

Honorable mentions among things that I tried and didn't have the effect
I hoped for: using __get_user/__put_user to read memory operands, and
simplifying linearize.


Patches 1-6 are various low-hanging fruit, which alone provide a
2-2.5x speedup (higher on simpler instructions).

Patches 7-12 make the emulator cache the host virtual address of memory
operands, thus avoid walking the page table twice.

Patch 13-18 avoid wasting time unnecessarily in the memset call of
x86_emulate_ctxt.

Patches 19-22 speed up operand fetching.

Patches 23-25 are the loose ends.

Bandan Das (6):
  KVM: emulate: move init_decode_cache to emulate.c
  KVM: emulate: Remove ctxt->intercept and ctxt->check_perm checks
  KVM: emulate: cleanup decode_modrm
  KVM: emulate: clean up initializations in init_decode_cache
  KVM: emulate: rework seg_override
  KVM: emulate: do not initialize memopp

Paolo Bonzini (19):
  KVM: vmx: speed up emulation of invalid guest state
  KVM: x86: return all bits from get_interrupt_shadow
  KVM: x86: avoid useless set of KVM_REQ_EVENT after emulation
  KVM: emulate: move around some checks
  KVM: emulate: protect checks on ctxt->d by a common "if (unlikely())"
  KVM: emulate: speed up emulated moves
  KVM: emulate: simplify writeback
  KVM: emulate: abstract handling of memory operands
  KVM: export mark_page_dirty_in_slot
  KVM: emulate: introduce memory_prepare callback to speed up memory access
  KVM: emulate: activate memory access optimization
  KVM: emulate: extend memory access optimization to stores
  KVM: emulate: speed up do_insn_fetch
  KVM: emulate: avoid repeated calls to do_insn_fetch_bytes
  KVM: emulate: avoid per-byte copying in instruction fetches
  KVM: emulate: put pointers in the fetch_cache
  KVM: x86: use kvm_read_guest_page for emulator accesses
  KVM: emulate: simplify BitOp handling
  KVM: emulate: fix harmless typo in MMX decoding

 arch/x86/include/asm/kvm_emulate.h |  59 ++++-
 arch/x86/include/asm/kvm_host.h    |   2 +-
 arch/x86/kvm/emulate.c             | 481 ++++++++++++++++++++++---------------
 arch/x86/kvm/svm.c                 |   6 +-
 arch/x86/kvm/trace.h               |   6 +-
 arch/x86/kvm/vmx.c                 |   9 +-
 arch/x86/kvm/x86.c                 | 147 +++++++++---
 include/linux/kvm_host.h           |   6 +
 virt/kvm/kvm_main.c                |  17 +-
 9 files changed, 473 insertions(+), 260 deletions(-)

-- 
1.8.3.1

