Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaIKFgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 01:36:46 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:58644 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750899AbaIKFgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 01:36:45 -0400
X-IronPort-AV: E=Sophos;i="5.04,504,1406563200"; 
   d="scan'208";a="35792862"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v5 0/7] kvm, mem-hotplug: Do not pin ept identity pagetable and apic access page.
Date: Thu, 11 Sep 2014 13:37:59 +0800
Message-ID: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com>
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

NOTE: Tested with -cpu xxx,-x2apic option.
      But since nested vm pins some other pages in memory, if user uses nested
      vm, memory hot-remove will not work.

Change log v4 -> v5:
1. Patch 5/7: Call kvm_reload_apic_access_page() unconditionally in nested_vmx_vmexit().
   (From Gleb Natapov <gleb@kernel.org>)
2. Patch 6/7: Remove kvm_arch->apic_access_page. (From Gleb Natapov <gleb@kernel.org>)
3. Patch 7/7: Remove nested_vmx->apic_access_page.

Tang Chen (7):
  kvm: Use APIC_DEFAULT_PHYS_BASE macro as the apic access page address.
  kvm: Remove ept_identity_pagetable from struct kvm_arch.
  kvm: Make init_rmode_identity_map() return 0 on success.
  kvm, mem-hotplug: Reload L1' apic access page on migration in
    vcpu_enter_guest().
  kvm, mem-hotplug: Reload L1's apic access page on migration when L2 is
    running.
  kvm, mem-hotplug: Unpin and remove kvm_arch->apic_access_page.
  kvm, mem-hotplug: Unpin and remove nested_vmx->apic_access_page.

 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/svm.c              |   9 ++-
 arch/x86/kvm/vmx.c              | 139 ++++++++++++++++++++++------------------
 arch/x86/kvm/x86.c              |  24 +++++--
 include/linux/kvm_host.h        |   2 +
 virt/kvm/kvm_main.c             |  13 ++++
 6 files changed, 122 insertions(+), 69 deletions(-)

-- 
1.8.3.1

