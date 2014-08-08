Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbaHHWT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:19:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40514 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959AbaHHUrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:47:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Deng-Cheng Zhu <dengcheng.zhu@imgtec.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 037/259] MIPS: KVM: Fix memory leak on VCPU
Date: Fri,  8 Aug 2014 13:37:40 -0700
Message-Id: <1407530482-4483-38-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deng-Cheng Zhu <dengcheng.zhu@imgtec.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/mips/kvm/kvm_mips.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/kvm/kvm_mips.c b/arch/mips/kvm/kvm_mips.c
index 3dfbe82..7a8b440 100644
--- a/arch/mips/kvm/kvm_mips.c
+++ b/arch/mips/kvm/kvm_mips.c
@@ -395,6 +395,7 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.kseg0_commpage)
 		kfree(vcpu->arch.kseg0_commpage);
 
+	kfree(vcpu);
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
-- 
1.9.1

