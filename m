Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934454Ab3FSJKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:10:12 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:41535 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934408Ab3FSJJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:09:50 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 7/7] KVM: MMU: document fast invalidate all mmio sptes
Date: Wed, 19 Jun 2013 17:09:25 +0800
Message-Id: <1371632965-20077-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061909-2000-0000-0000-00000C8DB657
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document it to Documentation/virtual/kvm/mmu.txt

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 Documentation/virtual/kvm/mmu.txt | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
index f5c4de9..9b7cfb3 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -396,6 +396,31 @@ ensures the old pages are not used any more. The invalid-gen pages
 (sp->mmu_valid_gen != kvm->arch.mmu_valid_gen) are zapped by using lock-break
 technique.
 
+Fast invalidate all mmio sptes
+===========
+As mentioned in "Reaction to events" above, kvm will cache the mmio information
+to the last sptes so that we should zap all mmio sptes when the guest mmio info
+is changed. This will happen when a new memslot is added or the existing
+memslot is moved.
+
+Zapping mmio spte is also a scalability issue for the large memory and large
+vcpus guests since it needs to hold hot mmu-lock and walk all shadow pages to
+find all the mmio spte out.
+
+We fix this issue by using the similar way of "Fast invalidate all pages".
+The global mmio valid generation-number is stored in kvm->memslots.generation
+and every mmio spte stores the current global generation-number into his
+available bits when it is created
+
+The global mmio valid generation-number is increased whenever the gust memory
+info is changed. When guests do mmio access, kvm intercepts a MMIO #PF then it
+walks the shadow page table and get the mmio spte. If the generation-number on
+the spte does not equal the global generation-number, it will go to the normal
+#PF handler to update the mmio spte.
+
+Since 19 bits are used to store generation-number on mmio spte, we zap all pages
+when the number is round.
+
 Further reading
 ===============
 
-- 
1.8.1.4

