Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab3AVHl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:41:57 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:56960 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab3AVHly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:41:54 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi.kivity@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>, Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>
Date: Tue, 22 Jan 2013 13:09:24 +0530
Message-Id: <20130122073923.24731.11675.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20130122073854.24731.9426.sendpatchset@codeblue.in.ibm.com>
References: <20130122073854.24731.9426.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH V3 RESEND RFC 2/2] kvm: Handle yield_to failure return code for potential undercommit case
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012207-8878-0000-0000-0000059D7405
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

yield_to returns -ESRCH, When source and target of yield_to
run queue length is one. When we see three successive failures of
yield_to we assume we are in potential undercommit case and abort
from PLE handler.
The assumption is backed by low probability of wrong decision
for even worst case scenarios such as average runqueue length
between 1 and 2.

More detail on rationale behind using three tries:
if p is the probability of finding rq length one on a particular cpu,
and if we do n tries, then probability of exiting ple handler is:

 p^(n+1) [ because we would have come across one source with rq length
1 and n target cpu rqs  with length 1 ]

so
num tries:         probability of aborting ple handler (1.5x overcommit)
 1                 1/4
 2                 1/8
 3                 1/16

We can increase this probability with more tries, but the problem is
the overhead.
Also, If we have tried three times that means we would have iterated
over 3 good eligible vcpus along with many non-eligible candidates. In
worst case if we iterate all the vcpus, we reduce 1x performance and
overcommit performance get hit.

note that we do not update last boosted vcpu in failure cases.
Thank Avi for raising question on aborting after first fail from yield_to.

Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
---
 Note:Updated with why number of tries to do yield is three.

 virt/kvm/kvm_main.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index be70035..053f494 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1639,6 +1639,7 @@ bool kvm_vcpu_yield_to(struct kvm_vcpu *target)
 {
 	struct pid *pid;
 	struct task_struct *task = NULL;
+	bool ret = false;
 
 	rcu_read_lock();
 	pid = rcu_dereference(target->pid);
@@ -1646,17 +1647,15 @@ bool kvm_vcpu_yield_to(struct kvm_vcpu *target)
 		task = get_pid_task(target->pid, PIDTYPE_PID);
 	rcu_read_unlock();
 	if (!task)
-		return false;
+		return ret;
 	if (task->flags & PF_VCPU) {
 		put_task_struct(task);
-		return false;
-	}
-	if (yield_to(task, 1)) {
-		put_task_struct(task);
-		return true;
+		return ret;
 	}
+	ret = yield_to(task, 1);
 	put_task_struct(task);
-	return false;
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_yield_to);
 
@@ -1697,12 +1696,14 @@ bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
 	return eligible;
 }
 #endif
+
 void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 {
 	struct kvm *kvm = me->kvm;
 	struct kvm_vcpu *vcpu;
 	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
 	int yielded = 0;
+	int try = 3;
 	int pass;
 	int i;
 
@@ -1714,7 +1715,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 	 * VCPU is holding the lock that we need and will release it.
 	 * We approximate round-robin by starting at the last boosted VCPU.
 	 */
-	for (pass = 0; pass < 2 && !yielded; pass++) {
+	for (pass = 0; pass < 2 && !yielded && try; pass++) {
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			if (!pass && i <= last_boosted_vcpu) {
 				i = last_boosted_vcpu;
@@ -1727,10 +1728,15 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 				continue;
 			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
 				continue;
-			if (kvm_vcpu_yield_to(vcpu)) {
+
+			yielded = kvm_vcpu_yield_to(vcpu);
+			if (yielded > 0) {
 				kvm->last_boosted_vcpu = i;
-				yielded = 1;
 				break;
+			} else if (yielded < 0) {
+				try--;
+				if (!try)
+					break;
 			}
 		}
 	}

