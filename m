Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaGWHmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:42:39 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:48515 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753919AbaGWHmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:42:35 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33671756"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v3 1/6] kvm: Add gfn_to_page_no_pin() to translate gfn to page without pinning.
Date: Wed, 23 Jul 2014 15:42:05 -0400
Message-ID: <1406144530-23002-2-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406144530-23002-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1406144530-23002-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gfn_to_page() will finally call hva_to_pfn() to get the pfn, and pin the page
in memory by calling GUP functions. This function unpins the page.

Will be used by the followed patches.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ec4e3bd..7c58d9d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -541,6 +541,7 @@ int gfn_to_page_many_atomic(struct kvm *kvm, gfn_t gfn, struct page **pages,
 			    int nr_pages);
 
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
+struct page *gfn_to_page_no_pin(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva_prot(struct kvm *kvm, gfn_t gfn, bool *writable);
 unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4b6c01b..6091849 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1371,9 +1371,24 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 
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

