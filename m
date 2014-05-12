Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbaELBy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:54:26 -0400
Received: from 1wt.eu ([62.212.114.60]:34709 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbaELBnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:17 -0400
Message-Id: <20140512003206.271246826@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andrew Honig <ahonig@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 134/143] KVM: Improve create VCPU parameter (CVE-2013-4587)
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Honig <ahonig@google.com>

commit 338c7dbadd2671189cec7faf64c84d01071b3f96 upstream

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 virt/kvm/kvm_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 82b6fdc..3b9443b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1846,6 +1846,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	int r;
 	struct kvm_vcpu *vcpu, *v;
 
+	if (id >= KVM_MAX_VCPUS)
+		return -EINVAL;
+
 	vcpu = kvm_arch_vcpu_create(kvm, id);
 	if (IS_ERR(vcpu))
 		return PTR_ERR(vcpu);
-- 
1.7.12.2.21.g234cd45.dirty



