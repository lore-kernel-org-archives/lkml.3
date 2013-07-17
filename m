Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab3GQPKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:10:47 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:53075 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab3GQPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:10:44 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: PPC: Book3S PR: return appropriate error when allocation fails
Date: Wed, 17 Jul 2013 12:10:29 -0300
Message-Id: <1374073829-28246-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071715-2194-0000-0000-000005FF6252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

err was overwritten by a previous function call, and checked to be 0. If
the following page allocation fails, 0 is going to be returned instead
of -ENOMEM.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 arch/powerpc/kvm/book3s_pr.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 19498a5..c6e13d9 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1047,11 +1047,12 @@ struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm, unsigned int id)
 	if (err)
 		goto free_shadow_vcpu;
 
+	err = -ENOMEM;
 	p = __get_free_page(GFP_KERNEL|__GFP_ZERO);
-	/* the real shared page fills the last 4k of our page */
-	vcpu->arch.shared = (void*)(p + PAGE_SIZE - 4096);
 	if (!p)
 		goto uninit_vcpu;
+	/* the real shared page fills the last 4k of our page */
+	vcpu->arch.shared = (void *)(p + PAGE_SIZE - 4096);
 
 #ifdef CONFIG_PPC_BOOK3S_64
 	/* default to book3s_64 (970fx) */
-- 
1.7.1

