Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaCGLnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:43:03 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:40887 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaCGLnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:43:00 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, alex.williamson@redhat.com, mtosatti@redhat.com,
        gleb@kernel.org, jan.kiszka@siemens.com
Subject: [PATCH 0/7] KVM: x86: Let the guest write to multiple debug registers with one vmexit
Date: Fri,  7 Mar 2014 12:42:44 +0100
Message-Id: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Williamson reported that a Windows game does something weird that
makes the guest save and restore debug registers on each context switch.
This cause several hundred thousands vmexits per second, and basically
cuts performance in half when running under KVM.

However, when not running in guest-debug mode, the guest controls the
debug registers and having to take an exit for each DR access is a waste
of time.  We just need one vmexit to load any stale values of DR0-DR6,
and then we can let the guest run freely.  On the next vmexit (whatever
the reason) we will read out whatever changes the guest made to the
debug registers.

Tested with x86/debug.flat on both Intel and AMD, both direct and
nested virtualization.

Changes from RFC: changed get_dr7 callback to sync_dirty_debug_regs,
	new patches 5-7.

Paolo Bonzini (7):
  KVM: vmx: we do rely on loading DR7 on entry
  KVM: x86: change vcpu->arch.switch_db_regs to a bit mask
  KVM: x86: Allow the guest to run with dirty debug registers
  KVM: vmx: Allow the guest to run with dirty debug registers
  KVM: nVMX: Allow nested guests to run with dirty debug registers
  KVM: svm: set/clear all DR intercepts in one swoop
  KVM: svm: Allow the guest to run with dirty debug registers

 arch/x86/include/asm/kvm_host.h |  8 ++++-
 arch/x86/kvm/svm.c              | 68 ++++++++++++++++++++++++++++-------------
 arch/x86/kvm/vmx.c              | 43 ++++++++++++++++++++++++--
 arch/x86/kvm/x86.c              | 20 +++++++++++-
 4 files changed, 114 insertions(+), 25 deletions(-)

-- 
1.8.3.1

