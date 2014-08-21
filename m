Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaHUQK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:10:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaHUQKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:10:24 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: [PATCH v3 0/7] Dynamic Pause Loop Exiting window.
Date: Thu, 21 Aug 2014 18:08:04 +0200
Message-Id: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 -> v3:
 * copy&paste frenzy [v3 4/7] (split modify_ple_window)
 * commented update_ple_window_actual_max [v3 4/7]
 * renamed shrinker to modifier [v3 4/7]
 * removed an extraneous max(new, ple_window) [v3 4/7] (should have been in v2)
 * changed tracepoint argument type, printing and macro abstractions [v3 5/7]
 * renamed ple_t to ple_int [v3 6/7] (visible in modinfo)
 * intelligent updates of ple_window [v3 7/7]

---
v1 -> v2:
 * squashed [v1 4/9] and [v1 5/9] (clamping)
 * dropped [v1 7/9] (CPP abstractions)
 * merged core of [v1 9/9] into [v1 4/9] (automatic maximum)
 * reworked kernel_param_ops: closer to pure int [v2 6/6]
 * introduced ple_window_actual_max & reworked clamping [v2 4/6]
 * added seqlock for parameter modifications [v2 6/6]

---
PLE does not scale in its current form.  When increasing VCPU count
above 150, one can hit soft lockups because of runqueue lock contention.
(Which says a lot about performance.)

The main reason is that kvm_ple_loop cycles through all VCPUs.
Replacing it with a scalable solution would be ideal, but it has already
been well optimized for various workloads, so this series tries to
alleviate one different major problem while minimizing a chance of
regressions: we have too many useless PLE exits.

Just increasing PLE window would help some cases, but it still spirals
out of control.  By increasing the window after every PLE exit, we can
limit the amount of useless ones, so we don't reach the state where CPUs
spend 99% of the time waiting for a lock.

HP confirmed that this series prevents soft lockups and TSC sync errors
on large guests.


Radim Krčmář (7):
  KVM: add kvm_arch_sched_in
  KVM: x86: introduce sched_in to kvm_x86_ops
  KVM: VMX: make PLE window per-VCPU
  KVM: VMX: dynamise PLE window
  KVM: trace kvm_ple_window grow/shrink
  KVM: VMX: runtime knobs for dynamic PLE window
  KVM: VMX: optimize ple_window updates to VMCS

 arch/arm/kvm/arm.c              |   4 ++
 arch/mips/kvm/mips.c            |   4 ++
 arch/powerpc/kvm/powerpc.c      |   4 ++
 arch/s390/kvm/kvm-s390.c        |   4 ++
 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/svm.c              |   6 ++
 arch/x86/kvm/trace.h            |  30 ++++++++
 arch/x86/kvm/vmx.c              | 147 ++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c              |   6 ++
 include/linux/kvm_host.h        |   2 +
 virt/kvm/kvm_main.c             |   2 +
 11 files changed, 207 insertions(+), 4 deletions(-)

-- 
2.1.0

