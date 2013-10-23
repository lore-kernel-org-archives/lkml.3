Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3JWNcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:32:17 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:45071 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3JWNaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:30:07 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 11/15] KVM: MMU: locklessly access shadow page under rcu protection
Date: Wed, 23 Oct 2013 21:29:29 +0800
Message-Id: <1382534973-13197-12-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102313-5564-0000-0000-00000A53F900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use SLAB_DESTROY_BY_RCU to prevent the shadow page to be freed from the
slab, so that it can be locklessly accessed by holding rcu lock

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1bcc8c8..5b42858 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4710,8 +4710,8 @@ int kvm_mmu_module_init(void)
 		goto nomem;
 
 	mmu_shadow_page_cache = kmem_cache_create("mmu_shadow_page_cache",
-						  PAGE_SIZE, PAGE_SIZE, 0,
-						  init_shadow_page_table);
+				   PAGE_SIZE, PAGE_SIZE, SLAB_DESTROY_BY_RCU,
+				   init_shadow_page_table);
 	if (!mmu_shadow_page_cache)
 		goto nomem;
 
-- 
1.8.1.4

