Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964987AbaLKOGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:06:40 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:50120 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964791AbaLKOF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:05:29 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, George Spelvin <linux@horizon.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 8/8] s390/kvm: REPLACE barrier fixup with READ_ONCE
Date: Thu, 11 Dec 2014 15:05:11 +0100
Message-Id: <1418306712-17245-9-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418306712-17245-1-git-send-email-borntraeger@de.ibm.com>
References: <1418306712-17245-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121114-0021-0000-0000-0000021A74F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)

Commit 1365039d0cb3 ("KVM: s390: Fix ipte locking") replace
ACCESS_ONCE with barriers. Lets use READ_ONCE instead.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
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

