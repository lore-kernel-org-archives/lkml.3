Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002AbaEMOzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:55:54 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:50784 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933752AbaEMOzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:55:51 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jan.kiszka@siemens.com, kvm@vger.kernel.org, gleb@kernel.org,
        avi.kivity@gmail.com
Subject: [PATCH 0/5] KVM: x86: support setting the CPL independent of CS
Date: Tue, 13 May 2014 16:55:36 +0200
Message-Id: <1399992941-11600-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, KVM used to assume that CS.RPL could always be used as the CPL
value when KVM_SET_SREGS is called.  Unfortunately this is not the case.
If userspace decides to call KVM_GET_SREGS/KVM_SET_SREGS exactly after
CR0.PE has been set to 1, but before the long jump that reloads CS, the
CPL will be reset to bits 0-1 of CS (aka CS.RPL).  This can work or not,
depending on the placement of the code that transitions to protected
mode.  If CS.RPL != 0 the emulator will see CS.RPL != CS.DPL (the DPL
will always be zero) and fail to fetch the next instruction of the
transition code.

The same bug exists with SVM, where you don't have the emulator but the
guest will triple fault.  Strangely, it doesn't occur with Intel's
unrestricted guest mode.

To trigger this using QEMU, it is enough to send "info cpus" continuously
while running iPXE (which places its code for real->protected mode in
the EBDA).  iPXE does a lot of transitions, and the guest will crash
very quickly.

Avi or Gleb, this is a bit tricky.  Can you review it please?

Paolo Bonzini (5):
  KVM: x86: support KVM_ENABLE_CAP on vm file descriptors
  KVM: x86: get CPL in KVM_GET_SREGS, prepare to be able to set it
  KVM: vmx: always compute the CPL on KVM_SET_SREGS
  KVM: vmx: force CPL=0 on real->protected mode transition
  KVM: x86: add capability to get/set CPL

 arch/x86/include/asm/kvm_host.h |  4 ++-
 arch/x86/include/uapi/asm/kvm.h |  5 +++-
 arch/x86/kvm/svm.c              | 13 +++++++--
 arch/x86/kvm/vmx.c              | 62 ++++++++++++++++++++++++++---------------
 arch/x86/kvm/x86.c              | 53 +++++++++++++++++++++++++++--------
 include/uapi/linux/kvm.h        |  1 +
 6 files changed, 98 insertions(+), 40 deletions(-)

-- 
1.8.3.1

