Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaLCWcC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:32:02 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:39632 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaLCWa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:30:29 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 8/9] s390/kvm: REPLACE ACCESS_ONCE with READ_ONCE
Date: Wed,  3 Dec 2014 23:30:20 +0100
Message-Id: <1417645821-54731-9-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417645821-54731-1-git-send-email-borntraeger@de.ibm.com>
References: <1417645821-54731-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120322-0005-0000-0000-0000025484E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)

Change the ipte lock code to replace ACCESS_ONCE with READ_ONCE.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/gaccess.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 0f961a1..8f195fa 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -229,10 +229,10 @@ static void ipte_lock_simple(struct kvm_vcpu *vcpu)
 		goto out;
 	ic = &vcpu->kvm->arch.sca->ipte_control;
 	do {
-		old = ACCESS_ONCE(*ic);
+		old = READ_ONCE(*ic);
 		while (old.k) {
 			cond_resched();
-			old = ACCESS_ONCE(*ic);
+			old = READ_ONCE(*ic);
 		}
 		new = old;
 		new.k = 1;
@@ -251,7 +251,8 @@ static void ipte_unlock_simple(struct kvm_vcpu *vcpu)
 		goto out;
 	ic = &vcpu->kvm->arch.sca->ipte_control;
 	do {
-		new = old = ACCESS_ONCE(*ic);
+		old = READ_ONCE(*ic);
+		new = old;
 		new.k = 0;
 	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
 	wake_up(&vcpu->kvm->arch.ipte_wq);
@@ -265,10 +266,10 @@ static void ipte_lock_siif(struct kvm_vcpu *vcpu)
 
 	ic = &vcpu->kvm->arch.sca->ipte_control;
 	do {
-		old = ACCESS_ONCE(*ic);
+		old = READ_ONCE(*ic);
 		while (old.kg) {
 			cond_resched();
-			old = ACCESS_ONCE(*ic);
+			old = READ_ONCE(*ic);
 		}
 		new = old;
 		new.k = 1;
@@ -282,7 +283,8 @@ static void ipte_unlock_siif(struct kvm_vcpu *vcpu)
 
 	ic = &vcpu->kvm->arch.sca->ipte_control;
 	do {
-		new = old = ACCESS_ONCE(*ic);
+		old = READ_ONCE(*ic);
+		new = old;
 		new.kh--;
 		if (!new.kh)
 			new.k = 0;
-- 
1.9.3

