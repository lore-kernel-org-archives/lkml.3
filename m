Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3FDWlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:41:20 -0400
Received: from 1wt.eu ([62.212.114.60]:35168 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab3FDWku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:40:50 -0400
Message-Id: <20130604172132.630488257@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 056/184] KVM: x86: relax MSR_KVM_SYSTEM_TIME alignment check
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

RHEL5 i386 guests register non 32-byte aligned addresses:

kvm-clock: cpu 1, msr 0:3018aa5, secondary cpu clock
kvm-clock: cpu 2, msr 0:301f8e9, secondary cpu clock
kvm-clock: cpu 3, msr 0:302672d, secondary cpu clock

Check for an address+len that would cross page boundary
instead.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kvm/x86.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e24e9ce..79905f2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -925,9 +925,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		/* ...but clean it before doing the actual write */
 		vcpu->arch.time_offset = data & ~(PAGE_MASK | 1);
 
-		/* Check that the address is 32-byte aligned. */
-		if (vcpu->arch.time_offset &
-				(sizeof(struct pvclock_vcpu_time_info) - 1))
+		/* Check that address+len does not cross page boundary */
+		if ((vcpu->arch.time_offset + 
+			sizeof(struct pvclock_vcpu_time_info) - 1)
+			& PAGE_MASK)
 			break;
 
 		vcpu->arch.time_page =
-- 
1.7.12.2.21.g234cd45.dirty



