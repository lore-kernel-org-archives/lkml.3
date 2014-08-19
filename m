Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaHSUh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:37:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbaHSUhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:37:24 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: [PATCH 0/9] Dynamic Pause Loop Exiting window.
Date: Tue, 19 Aug 2014 22:35:27 +0200
Message-Id: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

HP confirmed that this series avoids soft lockups and TSC sync errors on
large guests.

---
Design notes and questions:

Alternative to first two patches could be a new notifier.

All values are made changeable because defaults weren't selected after
weeks of benchmarking -- we can get improved performance by hardcoding
if someone is willing to do it.
(Or by presuming that noone is ever going to.)

Then, we can quite safely drop overflow checks: they are impossible to
hit with small increases and I don't think that anyone wants large ones.

Also, I'd argue against the last patch: it should be done in userspace,
but I'm not sure about Linux's policy.


Radim Krčmář (9):
  KVM: add kvm_arch_sched_in
  KVM: x86: introduce sched_in to kvm_x86_ops
  KVM: VMX: make PLE window per-vcpu
  KVM: VMX: dynamise PLE window
  KVM: VMX: clamp PLE window
  KVM: trace kvm_ple_window grow/shrink
  KVM: VMX: abstract ple_window modifiers
  KVM: VMX: runtime knobs for dynamic PLE window
  KVM: VMX: automatic PLE window maximum

 arch/arm/kvm/arm.c              |  4 ++
 arch/mips/kvm/mips.c            |  4 ++
 arch/powerpc/kvm/powerpc.c      |  4 ++
 arch/s390/kvm/kvm-s390.c        |  4 ++
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/svm.c              |  6 +++
 arch/x86/kvm/trace.h            | 29 +++++++++++++
 arch/x86/kvm/vmx.c              | 93 +++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c              |  6 +++
 include/linux/kvm_host.h        |  2 +
 virt/kvm/kvm_main.c             |  2 +
 11 files changed, 153 insertions(+), 3 deletions(-)

-- 
2.0.4

