Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaGHNAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:00:48 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:29969 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754254AbaGHNAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:00:45 -0400
X-IronPort-AV: E=Sophos;i="5.00,856,1396972800"; 
   d="scan'208";a="32994964"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v2 3/5] kvm, mem-hotplug: Do not pin ept identity pagetable in memory.
Date: Tue, 8 Jul 2014 21:01:30 +0800
Message-ID: <1404824492-30095-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ept identity page is pinned in memory. As a result, it cannot be migrated/hot-removed.

Actually, this page is not necessary to be pinned. When it is migrated,
mmu_notifier_invalidate_page() in try_to_unmap_one() will invalidate the ept
entry so that the guest won't be able to access the page. And in the next ept
violation, the new page will be found by ept violation handler.

This patch just unpin the ept identity page because it is not necessary.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/kvm/vmx.c | 3 ++-
 arch/x86/kvm/x86.c | 2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 0e1117c..0918635e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4018,7 +4018,8 @@ static int alloc_identity_pagetable(struct kvm *kvm)
 	if (r)
 		goto out;
 
-	page = gfn_to_page(kvm, kvm->arch.ept_identity_map_addr >> PAGE_SHIFT);
+	page = gfn_to_page_no_pin(kvm,
+				kvm->arch.ept_identity_map_addr >> PAGE_SHIFT);
 	if (is_error_page(page)) {
 		r = -EFAULT;
 		goto out;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f32a025..ffbe557 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7177,8 +7177,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_free_vcpus(kvm);
 	if (kvm->arch.apic_access_page)
 		put_page(kvm->arch.apic_access_page);
-	if (kvm->arch.ept_identity_pagetable)
-		put_page(kvm->arch.ept_identity_pagetable);
 	kfree(rcu_dereference_check(kvm->arch.apic_map, 1));
 }
 
-- 
1.8.3.1

