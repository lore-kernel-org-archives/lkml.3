Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaGBI7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:59:48 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:28751 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752556AbaGBI7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:59:46 -0400
X-IronPort-AV: E=Sophos;i="5.00,818,1396972800"; 
   d="scan'208";a="32730449"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH 0/4] kvm, mem-hotplug: Do not pin ept identity pagetable and apic access page.
Date: Wed, 2 Jul 2014 17:00:33 +0800
Message-ID: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb, Marcelo,

Please help to review this patch-set.

NOTE: This patch-set doesn't work properly.


ept identity pagetable and apic access page in kvm are pinned in memory.
As a result, they cannot be migrated/hot-removed.

But actually they don't need to be pinned in memory.

This patch-set introduces two new vcpu requests: KVM_REQ_MIGRATE_EPT and KVM_REQ_MIGRATE_APIC.
These two requests are made when the two pages are migrated by the mmu_notifier
to reset the related variable to unusable value. And will also be made when
ept violation happens to reset new pages.


[Known problem]
After this patch-set applied, the two pages can be migrated/hot-removed.
But after migrating apic access page, the guest died.

The host physical address of apic access page is stored in VMCS. I reset
it to 0 to stop guest from accessing it when it is unmapped by
kvm_mmu_notifier_invalidate_page(). And reset it to new page's host physical
address in tdp_page_fault(). But it seems that guest will access apic page
directly by the host physical address.


Tang Chen (4):
  kvm: Add gfn_to_page_no_pin()
  kvm: Add macro VMX_APIC_ACCESS_PAGE_ADDR
  kvm, memory-hotplug: Update ept identity pagetable when it is
    migrated.
  kvm, mem-hotplug: Update apic access page when it is migrated.

 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/include/asm/vmx.h      |  2 +-
 arch/x86/kvm/mmu.c              | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/svm.c              |  3 ++-
 arch/x86/kvm/vmx.c              | 17 +++++++++++++----
 arch/x86/kvm/x86.c              | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h        |  3 +++
 virt/kvm/kvm_main.c             | 38 +++++++++++++++++++++++++++++++++++++-
 8 files changed, 121 insertions(+), 7 deletions(-)

-- 
1.8.3.1

