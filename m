Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbaBEUot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:44:49 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48304 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbaBEUGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:22 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andy Honig <ahonig@google.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 115/213] KVM: x86: fix for buffer overflow in handling of MSR_KVM_SYSTEM_TIME (CVE-2013-1796)
Date: Wed, 5 Feb 2014 15:01:10 -0500
Message-ID: <1391630568-49251-116-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Honig <ahonig@google.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kvm/x86.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c1e586d82c1d..65f9c0c45312 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1152,6 +1152,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
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
1.8.5.2

