Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967203Ab3DRJ37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:29:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40155 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412Ab3DRJRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Honig <ahonig@google.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 34/72] KVM: x86: fix for buffer overflow in handling of MSR_KVM_SYSTEM_TIME (CVE-2013-1796)
Date: Thu, 18 Apr 2013 10:16:19 +0100
Message-Id: <1366276617-3553-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Honig <ahonig@google.com>

commit c300aa64ddf57d9c5d9c898a64b36877345dd4a9 upstream.

If the guest sets the GPA of the time_page so that the request to update the
time straddles a page then KVM will write onto an incorrect page.  The
write is done byusing kmap atomic to get a pointer to the page for the time
structure and then performing a memcpy to that page starting at an offset
that the guest controls.  Well behaved guests always provide a 32-byte aligned
address, however a malicious guest could use this to corrupt host kernel
memory.

Tested: Tested against kvmclock unit test.

Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/x86.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8b6fbee..ad5cf4b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1618,6 +1618,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		/* ...but clean it before doing the actual write */
 		vcpu->arch.time_offset = data & ~(PAGE_MASK | 1);
 
+		/* Check that the address is 32-byte aligned. */
+		if (vcpu->arch.time_offset &
+				(sizeof(struct pvclock_vcpu_time_info) - 1))
+			break;
+
 		vcpu->arch.time_page =
 				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
 
-- 
1.8.1.2

