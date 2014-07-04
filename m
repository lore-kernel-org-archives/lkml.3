Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031580AbaGDW2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:28:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760778AbaGDWWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:22:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Deng-Cheng Zhu <dengcheng.zhu@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.10 36/46] MIPS: KVM: Fix memory leak on VCPU
Date: Fri,  4 Jul 2014 15:19:40 -0700
Message-Id: <20140704221603.929389138@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221602.280733370@linuxfoundation.org>
References: <20140704221602.280733370@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kvm/kvm_mips.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/kvm/kvm_mips.c
+++ b/arch/mips/kvm/kvm_mips.c
@@ -384,6 +384,7 @@ void kvm_arch_vcpu_free(struct kvm_vcpu
 
 	kfree(vcpu->arch.guest_ebase);
 	kfree(vcpu->arch.kseg0_commpage);
+	kfree(vcpu);
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)


