Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933802AbaH0KRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:17:05 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:13793 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933664AbaH0KRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:17:02 -0400
X-IronPort-AV: E=Sophos;i="5.04,409,1406563200"; 
   d="scan'208";a="35139151"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v4 6/6] kvm, mem-hotplug: Do not pin apic access page in memory.
Date: Wed, 27 Aug 2014 18:17:41 +0800
Message-ID: <1409134661-27916-7-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409134661-27916-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1409134661-27916-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gfn_to_page() will finally call hva_to_pfn() to get the pfn, and pin the page
in memory by calling GUP functions. This function unpins the page.

After this patch, acpi access page is able to be migrated.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/kvm/vmx.c       |  2 +-
 arch/x86/kvm/x86.c       |  4 +---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 17 ++++++++++++++++-
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 9035fd1..e0043a5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4022,7 +4022,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	if (r)
 		goto out;
 
-	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
+	page = gfn_to_page_no_pin(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 	if (is_error_page(page)) {
 		r = -EFAULT;
 		goto out;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 131b6e8..2edbeb9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5996,7 +5996,7 @@ static void vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 	 * GUP will wait till the migrate entry is replaced with the new pte
 	 * entry pointing to the new page.
 	 */
-	vcpu->kvm->arch.apic_access_page = gfn_to_page(vcpu->kvm,
+	vcpu->kvm->arch.apic_access_page = gfn_to_page_no_pin(vcpu->kvm,
 				APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 	kvm_x86_ops->set_apic_access_page_addr(vcpu->kvm,
 				page_to_phys(vcpu->kvm->arch.apic_access_page));
@@ -7255,8 +7255,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kfree(kvm->arch.vpic);
 	kfree(kvm->arch.vioapic);
 	kvm_free_vcpus(kvm);
-	if (kvm->arch.apic_access_page)
-		put_page(kvm->arch.apic_access_page);
 	kfree(rcu_dereference_check(kvm->arch.apic_map, 1));
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8be076a..02cbcb1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -526,6 +526,7 @@ int gfn_to_page_many_atomic(struct kvm *kvm, gfn_t gfn, struct page **pages,
 			    int nr_pages);
 
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
+struct page *gfn_to_page_no_pin(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva_prot(struct kvm *kvm, gfn_t gfn, bool *writable);
 unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 784127e..19d90d2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1386,9 +1386,24 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 
 	return kvm_pfn_to_page(pfn);
 }
-
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
+struct page *gfn_to_page_no_pin(struct kvm *kvm, gfn_t gfn)
+{
+	struct page *page = gfn_to_page(kvm, gfn);
+
+	/*
+	 * gfn_to_page() will finally call hva_to_pfn() to get the pfn, and pin
+	 * the page in memory by calling GUP functions. This function unpins
+	 * the page.
+	 */
+	if (!is_error_page(page))
+		put_page(page);
+
+	return page;
+}
+EXPORT_SYMBOL_GPL(gfn_to_page_no_pin);
+
 void kvm_release_page_clean(struct page *page)
 {
 	WARN_ON(is_error_page(page));
-- 
1.8.3.1

