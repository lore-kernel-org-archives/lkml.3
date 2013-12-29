Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab3L2Cxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:53:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55153 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232Ab3L2CKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:07 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andy Honig" <ahonig@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.402515796@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 142/185] KVM: Improve create VCPU parameter
 (CVE-2013-4587)
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 virt/kvm/kvm_main.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1683,6 +1683,9 @@ static int kvm_vm_ioctl_create_vcpu(stru
 	int r;
 	struct kvm_vcpu *vcpu, *v;
 
+	if (id >= KVM_MAX_VCPUS)
+		return -EINVAL;
+
 	vcpu = kvm_arch_vcpu_create(kvm, id);
 	if (IS_ERR(vcpu))
 		return PTR_ERR(vcpu);

