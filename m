Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab3DWV4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:56:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab3DWV4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:56:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Honig <ahonig@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 07/23] KVM: x86: fix for buffer overflow in handling of MSR_KVM_SYSTEM_TIME (CVE-2013-1796)
Date: Tue, 23 Apr 2013 14:56:14 -0700
Message-Id: <20130423215457.061810094@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215456.307216898@linuxfoundation.org>
References: <20130423215456.307216898@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1539,6 +1539,11 @@ int kvm_set_msr_common(struct kvm_vcpu *
 		/* ...but clean it before doing the actual write */
 		vcpu->arch.time_offset = data & ~(PAGE_MASK | 1);
 
+		/* Check that the address is 32-byte aligned. */
+		if (vcpu->arch.time_offset &
+				(sizeof(struct pvclock_vcpu_time_info) - 1))
+			break;
+
 		vcpu->arch.time_page =
 				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
 


