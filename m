Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbaGXKal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:30:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54538 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaGXJqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:46:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Deng-Cheng Zhu <dengcheng.zhu@imgtec.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 003/128] MIPS: KVM: Fix memory leak on VCPU
Date: Thu, 24 Jul 2014 10:44:12 +0100
Message-Id: <1406195177-8656-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/kvm/kvm_mips.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/kvm/kvm_mips.c b/arch/mips/kvm/kvm_mips.c
index 7e78af0e57de..2c7b3ade8ec0 100644
--- a/arch/mips/kvm/kvm_mips.c
+++ b/arch/mips/kvm/kvm_mips.c
@@ -384,6 +384,7 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 
 	kfree(vcpu->arch.guest_ebase);
 	kfree(vcpu->arch.kseg0_commpage);
+	kfree(vcpu);
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
-- 
1.9.1

