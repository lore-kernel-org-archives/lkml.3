Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab3JBOG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:06:26 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:45800 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab3JBOGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:06:24 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gleb@redhat.com
Subject: [PATCH v3 0/3] KVM: prepare for future XSAVE extensions
Date: Wed,  2 Oct 2013 16:06:13 +0200
Message-Id: <1380722776-12358-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As soon as the kernel will support the XSAVE extensions in Skylake
processors, we will want both userspace and the hypervisor to run
guests without showing any trace of the new features (because
support for them in the hypervisor will come later).

This series does exactly this.  Patches 1 and 3 ensures that userspace
does not get access to features not supported in the hypervisor.
Patch 2 does the same for the guest.

The effect of these patches is already visible together with
the corresponding QEMU patches and a command line such as "-cpu
SandyBridge,-avx".  Previously, the guest could still enable AVX via
xsetbv, and state would be sent by QEMU during migration.  These patches
make sure that disabling AVX will really prevent the guest from using it,
which helps if you have to deal with migration from newer versions of
QEMU and the kernel to older versions.  The QEMU patches set up the
guest's 0xd CPUID leaf, which also ensures that the kernel has the
necessary information.

Paolo

v2->v3:
	rename supported_xcr0 field to guest_supported_xcr0
	rename xstate_size field to guest_xstate_size
	do not hardcode XSTATE_FPSSE in guest_supported_xcr0
	handle missing 0xd leaf

Paolo Bonzini (3):
  KVM: x86: mask unsupported XSAVE entries from leaf 0Dh index 0
  KVM: x86: prevent setting unsupported XSAVE states
  KVM: x86: only copy XSAVE state for the supported features

 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/cpuid.c            | 36 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              | 29 ++++++++++++++++++++++-------
 arch/x86/kvm/x86.h              |  1 +
 4 files changed, 60 insertions(+), 8 deletions(-)

-- 
1.8.3.1

