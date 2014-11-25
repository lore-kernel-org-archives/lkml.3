Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbaKYMlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:41:42 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:57824 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbaKYMis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:38:48 -0500
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
        Christian Borntraeger <borntraeger@de.ibm.com>, stable@vger.kernel.org,
        #@tuxmaker.boeblingen.de.ibm.com,
        v3.16+@tuxmaker.boeblingen.de.ibm.com
Subject: [PATCHv2 01/10] KVM: s390: Fix ipte locking
Date: Tue, 25 Nov 2014 13:38:28 +0100
Message-Id: <1416919117-50652-2-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416919117-50652-1-git-send-email-borntraeger@de.ibm.com>
References: <1416919117-50652-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112512-0009-0000-0000-00000221387B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@vger.kernel.org # v3.16+
---
 arch/s390/kvm/gaccess.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 0f961a1..6dc0ad9 100644
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
 	wake_up(&vcpu->kvm->arch.ipte_wq);
@@ -265,10 +269,12 @@ static void ipte_lock_siif(struct kvm_vcpu *vcpu)
 
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
@@ -282,7 +288,9 @@ static void ipte_unlock_siif(struct kvm_vcpu *vcpu)
 
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
1.9.3

