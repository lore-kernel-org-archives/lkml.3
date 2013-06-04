Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab3FDXUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:20:06 -0400
Received: from 1wt.eu ([62.212.114.60]:35312 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab3FDWls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:48 -0400
Message-Id: <20130604172132.588801299@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andrew Honig <ahonig@google.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 055/184] KVM: x86: fix for buffer overflow in handling of
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 MSR_KVM_SYSTEM_TIME (CVE-2013-1796)

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
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kvm/x86.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 271fddf..e24e9ce 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -925,6 +925,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
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
1.7.12.2.21.g234cd45.dirty



