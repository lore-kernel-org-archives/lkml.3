Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761625AbaGRNS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:18:59 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17997 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030902AbaGRNSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Deng-Cheng Zhu <dengcheng.zhu@imgtec.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 051/170] MIPS: KVM: Fix memory leak on VCPU
Date: Fri, 18 Jul 2014 14:10:56 +0200
Message-Id: <e7f46b90acc0848bfc2d1906e2be285c7d81afbc.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Deng-Cheng Zhu <dengcheng.zhu@imgtec.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8c9eb041cf76038eb3b62ee259607eec9b89f48d upstream.

kvm_arch_vcpu_free() is called in 2 code paths:

1) kvm_vm_ioctl()
       kvm_vm_ioctl_create_vcpu()
           kvm_arch_vcpu_destroy()
               kvm_arch_vcpu_free()
2) kvm_put_kvm()
       kvm_destroy_vm()
           kvm_arch_destroy_vm()
               kvm_mips_free_vcpus()
                   kvm_arch_vcpu_free()

Neither of the paths handles VCPU free. We need to do it in
kvm_arch_vcpu_free() corresponding to the memory allocation in
kvm_arch_vcpu_create().

Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@imgtec.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/mips/kvm/kvm_mips.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/kvm/kvm_mips.c b/arch/mips/kvm/kvm_mips.c
index 8b900e987338..3f3e5b2b2f38 100644
--- a/arch/mips/kvm/kvm_mips.c
+++ b/arch/mips/kvm/kvm_mips.c
@@ -388,6 +388,7 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 
 	kfree(vcpu->arch.guest_ebase);
 	kfree(vcpu->arch.kseg0_commpage);
+	kfree(vcpu);
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
-- 
2.0.0

