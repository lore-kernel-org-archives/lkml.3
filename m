Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbaGWHmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:42:35 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:48515 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752519AbaGWHmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:42:33 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33671753"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v3 0/6] kvm, mem-hotplug: Do not pin ept identity pagetable and apic access page.
Date: Wed, 23 Jul 2014 15:42:04 -0400
Message-ID: <1406144530-23002-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ept identity pagetable and apic access page in kvm are pinned in memory.
As a result, they cannot be migrated/hot-removed.

But actually they don't need to be pinned in memory.

[For ept identity page]
Just do not pin it. When it is migrated, guest will be able to find the
new page in the next ept violation.

[For apic access page]
The hpa of apic access page is stored in VMCS APIC_ACCESS_ADDR pointer.
When apic access page is migrated, we update VMCS APIC_ACCESS_ADDR pointer
for each vcpu in addition.

NOTE: Patch 1~5 are tested with -cpu xxx,-x2apic option, and they work well.
      Patch 6 is not tested yet, not sure if it is right.

Change log v2 -> v3:
1. Remove original [PATCH 3/6] since ept_identity_pagetable has been removed
   in new [PATCH 3/6].
2. In [PATCH 3/6], fix the problem that kvm->slots_lock does not protect 
   kvm->arch.ept_identity_pagetable_done checking.
3. In [PATCH 3/6], drop gfn_to_page() since ept_identity_pagetable has been 
   removed.
4. Add new [PATCH 4/6], remove redundant variable in init_rmode_identity_map(), 
   and make it return 0 on success.
5. In [PATCH 5/6], drop put_page(kvm->arch.apic_access_page) from x86.c .
6. In [PATCH 5/6], update kvm->arch.apic_access_page in vcpu_reload_apic_access_page().
7. Add new [PATCH 6/6], reload apic access page in L2->L1 exit.

Change log v1 -> v2:
1. Add [PATCH 4/5] to remove unnecessary kvm_arch->ept_identity_pagetable.
2. In [PATCH 5/5], only introduce KVM_REQ_APIC_PAGE_RELOAD request.
3. In [PATCH 5/5], add set_apic_access_page_addr() for svm.


Tang Chen (6):
  kvm: Add gfn_to_page_no_pin() to translate gfn to page without
    pinning.
  kvm: Use APIC_DEFAULT_PHYS_BASE macro as the apic access page address.
  kvm: Remove ept_identity_pagetable from struct kvm_arch.
  kvm: Make init_rmode_identity_map() return 0 on success.
  kvm, mem-hotplug: Do not pin apic access page in memory.
  kvm, mem-hotplug: Reload L1's apic access page if it is migrated when
    L2 is running.

 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/svm.c              |  15 +++++-
 arch/x86/kvm/vmx.c              | 108 +++++++++++++++++++++++++++-------------
 arch/x86/kvm/x86.c              |  22 ++++++--
 include/linux/kvm_host.h        |   3 ++
 virt/kvm/kvm_main.c             |  29 ++++++++++-
 6 files changed, 139 insertions(+), 41 deletions(-)

-- 
1.8.3.1

