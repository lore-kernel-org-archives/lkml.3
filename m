Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547Ab3DBWuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:50:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758323Ab3DBWun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kiszka <jan.kiszka@siemens.com>, Avi Kivity <avi@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [ 18/56] KVM: Clean up error handling during VCPU creation
Date: Tue,  2 Apr 2013 15:49:45 -0700
Message-Id: <20130402224713.992108424@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jan Kiszka <jan.kiszka@siemens.com>

commit d780592b99d7d8a5ff905f6bacca519d4a342c76 upstream.

So far kvm_arch_vcpu_setup is responsible for freeing the vcpu struct if
it fails. Move this confusing resonsibility back into the hands of
kvm_vm_ioctl_create_vcpu. Only kvm_arch_vcpu_setup of x86 is affected,
all other archs cannot fail.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c  |    5 -----
 virt/kvm/kvm_main.c |   11 ++++++-----
 2 files changed, 6 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6116,12 +6116,7 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu
 	if (r == 0)
 		r = kvm_mmu_setup(vcpu);
 	vcpu_put(vcpu);
-	if (r < 0)
-		goto free_vcpu;
 
-	return 0;
-free_vcpu:
-	kvm_x86_ops->vcpu_free(vcpu);
 	return r;
 }
 
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1616,18 +1616,18 @@ static int kvm_vm_ioctl_create_vcpu(stru
 
 	r = kvm_arch_vcpu_setup(vcpu);
 	if (r)
-		return r;
+		goto vcpu_destroy;
 
 	mutex_lock(&kvm->lock);
 	if (atomic_read(&kvm->online_vcpus) == KVM_MAX_VCPUS) {
 		r = -EINVAL;
-		goto vcpu_destroy;
+		goto unlock_vcpu_destroy;
 	}
 
 	kvm_for_each_vcpu(r, v, kvm)
 		if (v->vcpu_id == id) {
 			r = -EEXIST;
-			goto vcpu_destroy;
+			goto unlock_vcpu_destroy;
 		}
 
 	BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
@@ -1637,7 +1637,7 @@ static int kvm_vm_ioctl_create_vcpu(stru
 	r = create_vcpu_fd(vcpu);
 	if (r < 0) {
 		kvm_put_kvm(kvm);
-		goto vcpu_destroy;
+		goto unlock_vcpu_destroy;
 	}
 
 	kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
@@ -1651,8 +1651,9 @@ static int kvm_vm_ioctl_create_vcpu(stru
 	mutex_unlock(&kvm->lock);
 	return r;
 
-vcpu_destroy:
+unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
+vcpu_destroy:
 	kvm_arch_vcpu_destroy(vcpu);
 	return r;
 }


