Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbbALTPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:15:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57342 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbbALSFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 017/216] KVM: s390: Fix ipte locking
Date: Mon, 12 Jan 2015 18:02:14 +0000
Message-Id: <1421085933-32536-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 1365039d0cb32c0cf96eb9f750f4277c9a90f87d upstream.

ipte_unlock_siif uses cmpxchg to replace the in-memory data of the ipte
lock together with ACCESS_ONCE for the intial read.

union ipte_control {
        unsigned long val;
        struct {
                unsigned long k  : 1;
                unsigned long kh : 31;
                unsigned long kg : 32;
        };
};
[...]
static void ipte_unlock_siif(struct kvm_vcpu *vcpu)
{
        union ipte_control old, new, *ic;

        ic = &vcpu->kvm->arch.sca->ipte_control;
        do {
                new = old = ACCESS_ONCE(*ic);
                new.kh--;
                if (!new.kh)
                        new.k = 0;
        } while (cmpxchg(&ic->val, old.val, new.val) != old.val);
        if (!new.kh)
                wake_up(&vcpu->kvm->arch.ipte_wq);
}

The new value, is loaded twice from memory with gcc 4.7.2 of
fedora 18, despite the ACCESS_ONCE:

--->

l       %r4,0(%r3)      <--- load first 32 bit of lock (k and kh) in r4
alfi    %r4,2147483647  <--- add -1 to r4
llgtr   %r4,%r4         <--- zero out the sign bit of r4
lg      %r1,0(%r3)      <--- load all 64 bit of lock into new
lgr     %r2,%r1         <--- load the same into old
risbg   %r1,%r4,1,31,32 <--- shift and insert r4 into the bits 1-31 of
new
llihf   %r4,2147483647
ngrk    %r4,%r1,%r4
jne     aa0 <ipte_unlock+0xf8>
nihh    %r1,32767
lgr     %r4,%r2
csg     %r4,%r1,0(%r3)
cgr     %r2,%r4
jne     a70 <ipte_unlock+0xc8>

If the memory value changes between the first load (l) and the second
load (lg) we are broken. If that happens VCPU threads will hang
(unkillable) in handle_ipte_interlock.

Andreas Krebbel analyzed this and tracked it down to a compiler bug in
that version:
"while it is not that obvious the C99 standard basically forbids
duplicating the memory access also in that case. For an argumentation of
a similiar case please see:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=22278#c43

For the implementation-defined cases regarding volatile there are some
GCC-specific clarifications which can be found here:
https://gcc.gnu.org/onlinedocs/gcc/Volatiles.html#Volatiles

I've tracked down the problem with a reduced testcase. The problem was
that during a tree level optimization (SRA - scalar replacement of
aggregates) the volatile marker is lost. And an RTL level optimizer (CSE
- common subexpression elimination) then propagated the memory read into
  its second use introducing another access to the memory location. So
indeed Christian's suspicion that the union access has something to do
with it is correct (since it triggered the SRA optimization).

This issue has been reported and fixed in the GCC 4.8 development cycle:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145"

This patch replaces the ACCESS_ONCE scheme with a barrier() based scheme
that should work for all supported compilers.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/kvm/gaccess.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 4653ac6e182b..97e7b598fed1 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -229,10 +229,12 @@ static void ipte_lock_simple(struct kvm_vcpu *vcpu)
 		goto out;
 	ic = &vcpu->kvm->arch.sca->ipte_control;
 	do {
-		old = ACCESS_ONCE(*ic);
+		old = *ic;
+		barrier();
 		while (old.k) {
 			cond_resched();
-			old = ACCESS_ONCE(*ic);
+			old = *ic;
+			barrier();
 		}
 		new = old;
 		new.k = 1;
@@ -251,7 +253,9 @@ static void ipte_unlock_simple(struct kvm_vcpu *vcpu)
 		goto out;
 	ic = &vcpu->kvm->arch.sca->ipte_control;
 	do {
-		new = old = ACCESS_ONCE(*ic);
+		old = *ic;
+		barrier();
+		new = old;
 		new.k = 0;
 	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
 	if (!ipte_lock_count)
@@ -266,10 +270,12 @@ static void ipte_lock_siif(struct kvm_vcpu *vcpu)
 
 	ic = &vcpu->kvm->arch.sca->ipte_control;
 	do {
-		old = ACCESS_ONCE(*ic);
+		old = *ic;
+		barrier();
 		while (old.kg) {
 			cond_resched();
-			old = ACCESS_ONCE(*ic);
+			old = *ic;
+			barrier();
 		}
 		new = old;
 		new.k = 1;
@@ -283,7 +289,9 @@ static void ipte_unlock_siif(struct kvm_vcpu *vcpu)
 
 	ic = &vcpu->kvm->arch.sca->ipte_control;
 	do {
-		new = old = ACCESS_ONCE(*ic);
+		old = *ic;
+		barrier();
+		new = old;
 		new.kh--;
 		if (!new.kh)
 			new.k = 0;
-- 
2.1.4

