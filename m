Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab3DAJ5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:57:01 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:43358 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300Ab3DAJ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:56:59 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 0/6] KVM: MMU: fast invalid all mmio sptes
Date: Mon,  1 Apr 2013 17:56:43 +0800
Message-Id: <1364810209-25954-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040109-9264-0000-0000-0000036FFA8B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog in v2:
  - rename kvm_mmu_invalid_mmio_spte to kvm_mmu_invalid_mmio_sptes
  - use kvm->memslots->generation as kvm global generation-number
  - fix comment and codestyle
  - init kvm generation close to mmio wrap-around value
  - keep kvm_mmu_zap_mmio_sptes

The current way is holding hot mmu-lock and walking all shadow pages, this
is not scale. This patchset tries to introduce a very simple and scale way
to fast invalid all mmio sptes - it need not walk any shadow pages and hold
any locks.

The idea is simple:
KVM maintains a global mmio invalid generation-number which is stored in
kvm->memslots.generation and every mmio spte stores the current global
generation-number into his available bits when it is created

When KVM need zap all mmio sptes, it just simply increase the global
generation-number. When guests do mmio access, KVM intercepts a MMIO #PF
then it walks the shadow page table and get the mmio spte. If the
generation-number on the spte does not equal the global generation-number,
it will go to the normal #PF handler to update the mmio spte

Since 19 bits are used to store generation-number on mmio spte, we zap all
mmio sptes when the number is round

Xiao Guangrong (6):
  KVM: MMU: retain more available bits on mmio spte
  KVM: MMU: store generation-number into mmio spte
  KVM: MMU: make return value of mmio page fault handler more readable
  KVM: MMU: fast invalid all mmio sptes
  KVM: MMU: add tracepoint for check_mmio_spte
  KVM: MMU: init kvm generation close to mmio wrap-around value

 arch/x86/include/asm/kvm_host.h |    3 +-
 arch/x86/kvm/mmu.c              |  134 +++++++++++++++++++++++++++++++--------
 arch/x86/kvm/mmu.h              |   17 +++++
 arch/x86/kvm/mmutrace.h         |   34 +++++++++-
 arch/x86/kvm/paging_tmpl.h      |   10 ++-
 arch/x86/kvm/vmx.c              |   12 +++-
 arch/x86/kvm/x86.c              |   11 +++-
 virt/kvm/kvm_main.c             |    6 ++
 8 files changed, 186 insertions(+), 41 deletions(-)

-- 
1.7.7.6

