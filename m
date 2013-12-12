Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab3LLUhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:37:20 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:43785 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3LLUhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:37:13 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@redhat.com, kvm@vger.kernel.org, pmatouse@redhat.com,
        Andy Honig <ahonig@google.com>, stable@vger.kernel.org
Subject: [PATCH] KVM: Improve create VCPU parameter
Date: Thu, 12 Dec 2013 21:36:51 +0100
Message-Id: <1386880614-23300-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Honig <ahonig@google.com>

In multiple functions the vcpu_id is used as an offset into a bitfield.  Ag
malicious user could specify a vcpu_id greater than 255 in order to set or
clear bits in kernel memory.  This could be used to elevate priveges in the
kernel.  This patch verifies that the vcpu_id provided is less than 255.
The api documentation already specifies that the vcpu_id must be less than
max_vcpus, but this is currently not checked.

Reported-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a0aa84b5941a..4f588bc94186 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1898,6 +1898,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	int r;
 	struct kvm_vcpu *vcpu, *v;
 
+	if (id >= KVM_MAX_VCPUS)
+		return -EINVAL;
+
 	vcpu = kvm_arch_vcpu_create(kvm, id);
 	if (IS_ERR(vcpu))
 		return PTR_ERR(vcpu);
-- 
1.8.3.1

