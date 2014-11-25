Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbaKYMiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:38:50 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:41422 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbaKYMiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:38:46 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "linux-arch@vger.kernel.org, linux-mips@linux-mips.org, linux-x86_64@vger.kernel.org, linux-s390"@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, torvalds@linux-foundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCHv2 10/10] KVM: s390: change ipte lock from barrier to READ_ONCE
Date: Tue, 25 Nov 2014 13:38:37 +0100
Message-Id: <1416919117-50652-11-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416919117-50652-1-git-send-email-borntraeger@de.ibm.com>
References: <1416919117-50652-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112512-0013-0000-0000-000001FADD3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have the READ_ONCE solution, we can change the ipte lock
from a barrier solution to READ_ONCE. The barrier and the explanation
of the bug was introduced in commit 1365039d0cb3 ("KVM: s390: Fix
ipte locking")

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/gaccess.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 6dc0ad9..8f195fa 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -229,12 +229,10 @@ static void ipte_lock_simple(struct kvm_vcpu *vcpu)
 		goto out;
 	ic = &vcpu->kvm->arch.sca->ipte_control;
 	do {
-		old = *ic;
-		barrier();
+		old = READ_ONCE(*ic);
 		while (old.k) {
 			cond_resched();
-			old = *ic;
-			barrier();
+			old = READ_ONCE(*ic);
 		}
 		new = old;
 		new.k = 1;
@@ -253,8 +251,7 @@ static void ipte_unlock_simple(struct kvm_vcpu *vcpu)
 		goto out;
 	ic = &vcpu->kvm->arch.sca->ipte_control;
 	do {
-		old = *ic;
-		barrier();
+		old = READ_ONCE(*ic);
 		new = old;
 		new.k = 0;
 	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
@@ -269,12 +266,10 @@ static void ipte_lock_siif(struct kvm_vcpu *vcpu)
 
 	ic = &vcpu->kvm->arch.sca->ipte_control;
 	do {
-		old = *ic;
-		barrier();
+		old = READ_ONCE(*ic);
 		while (old.kg) {
 			cond_resched();
-			old = *ic;
-			barrier();
+			old = READ_ONCE(*ic);
 		}
 		new = old;
 		new.k = 1;
@@ -288,8 +283,7 @@ static void ipte_unlock_siif(struct kvm_vcpu *vcpu)
 
 	ic = &vcpu->kvm->arch.sca->ipte_control;
 	do {
-		old = *ic;
-		barrier();
+		old = READ_ONCE(*ic);
 		new = old;
 		new.kh--;
 		if (!new.kh)
-- 
1.9.3

