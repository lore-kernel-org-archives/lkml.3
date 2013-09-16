Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3IPOGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 10:06:24 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:32785 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab3IPOGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 10:06:22 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, kvm@vger.kernel.org,
        gleb@redhat.com, jan.kiszka@siemens.com
Subject: [PATCH 0/3] KVM: Make kvm_lock non-raw
Date: Mon, 16 Sep 2013 16:06:10 +0200
Message-Id: <1379340373-5135-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker reported a BUG on preempt-rt kernels, due to taking the
mmu_lock within the raw kvm_lock in mmu_shrink_scan.  He provided a
patch that shrunk the kvm_lock critical section so that the mmu_lock
critical section does not nest with it, but in the end there is no reason
for the vm_list to be protected by a raw spinlock.  Only manipulations
of kvm_usage_count and the consequent hardware_enable/disable operations
are not preemptable.

This small series thus splits the kvm_lock in the "raw" part and the
"non-raw" part.

Paul, could you please provide your Tested-by?

Thanks,

Paolo

Paolo Bonzini (3):
  KVM: cleanup (physical) CPU hotplug
  KVM: protect kvm_usage_count with its own spinlock
  KVM: Convert kvm_lock back to non-raw spinlock

 Documentation/virtual/kvm/locking.txt |  8 ++++--
 arch/x86/kvm/mmu.c                    |  4 +--
 arch/x86/kvm/x86.c                    |  8 +++---
 include/linux/kvm_host.h              |  2 +-
 virt/kvm/kvm_main.c                   | 51 ++++++++++++++++++-----------------
 5 files changed, 40 insertions(+), 33 deletions(-)

-- 
1.8.3.1

