Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaAOWAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:00:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41383 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbaAOWAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:00:07 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Honig <ahonig@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 051/166] KVM: Improve create VCPU parameter (CVE-2013-4587)
Date: Wed, 15 Jan 2014 13:51:05 -0800
Message-Id: <1389822780-4729-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Honig <ahonig@google.com>

commit 338c7dbadd2671189cec7faf64c84d01071b3f96 upstream.

In multiple functions the vcpu_id is used as an offset into a bitfield.  Ag
malicious user could specify a vcpu_id greater than 255 in order to set or
clear bits in kernel memory.  This could be used to elevate priveges in the
kernel.  This patch verifies that the vcpu_id provided is less than 255.
The api documentation already specifies that the vcpu_id must be less than
max_vcpus, but this is currently not checked.

Reported-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 virt/kvm/kvm_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4dc41654..4884600 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1839,6 +1839,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	int r;
 	struct kvm_vcpu *vcpu, *v;
 
+	if (id >= KVM_MAX_VCPUS)
+		return -EINVAL;
+
 	vcpu = kvm_arch_vcpu_create(kvm, id);
 	if (IS_ERR(vcpu))
 		return PTR_ERR(vcpu);
-- 
1.8.3.2

