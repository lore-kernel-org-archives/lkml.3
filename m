Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbaJXPUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:20:13 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:45257 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608AbaJXPUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:20:10 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.18-rc2
Date: Fri, 24 Oct 2014 17:19:56 +0200
Message-Id: <1414163996-18802-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit c3351dfabf5c78fb5ddc79d0f7b65ebd9e441337:

  Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending (2014-10-21 13:06:38 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 571ee1b6859869a09ed718d390aac2b9414646a2:

  kvm: vfio: fix unregister kvm_device_ops of vfio (2014-10-24 13:30:47 +0200)

----------------------------------------------------------------
This is a pretty large update.  I think it is roughly as big
as what I usually had for the _whole_ rc period.

There are a few bad bugs where the guest can OOPS or crash the host.  We
have also started looking at attack models for nested virtualization;
bugs that usually result in the guest ring 0 crashing itself become
more worrisome if you have nested virtualization, because the nested
guest might bring down the non-nested guest as well.  For current
uses of nested virtualization these do not really have a security
impact, but you never know and bugs are bugs nevertheless.

A lot of these bugs are in 3.17 too, resulting in a large number of
stable@ Ccs.  I checked that all the patches apply there with no
conflicts.

----------------------------------------------------------------
Andy Honig (2):
      KVM: x86: Prevent host from panicking on shared MSR writes.
      KVM: x86: Improve thread safety in pit

Michael S. Tsirkin (1):
      kvm: x86: don't kill guest on unknown exit reason

Nadav Amit (8):
      KVM: x86: Check non-canonical addresses upon WRMSR
      KVM: x86: Fix wrong masking on relative jump/call
      KVM: x86: Emulator fixes for eip canonical checks on near branches
      KVM: x86: Handle errors when RIP is set during far jumps
      KVM: x86: Decoding guest instructions which cross page boundary may fail
      KVM: x86: Emulator does not decode clflush well
      KVM: x86: PREFETCH and HINT_NOP should have SrcMem flag
      KVM: x86: Wrong assertion on paging_tmpl.h

Paolo Bonzini (1):
      KVM: emulate: avoid accessing NULL ctxt->memopp

Petr Matousek (1):
      kvm: vmx: handle invvpid vm exit gracefully

Quentin Casasnovas (1):
      kvm: fix excessive pages un-pinning in kvm_iommu_map error path.

Wanpeng Li (1):
      kvm: vfio: fix unregister kvm_device_ops of vfio

 arch/x86/include/asm/kvm_host.h |  16 ++-
 arch/x86/include/uapi/asm/vmx.h |   2 +
 arch/x86/kvm/emulate.c          | 250 ++++++++++++++++++++++++++++++----------
 arch/x86/kvm/i8254.c            |   2 +
 arch/x86/kvm/paging_tmpl.h      |   2 +-
 arch/x86/kvm/svm.c              |   8 +-
 arch/x86/kvm/vmx.c              |  24 ++--
 arch/x86/kvm/x86.c              |  38 +++++-
 include/linux/kvm_host.h        |   1 +
 virt/kvm/iommu.c                |   8 +-
 virt/kvm/kvm_main.c             |   7 ++
 virt/kvm/vfio.c                 |   5 +
 virt/kvm/vfio.h                 |   4 +
 13 files changed, 282 insertions(+), 85 deletions(-)
