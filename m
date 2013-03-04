Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab3CDSFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:05:38 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58723 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758456Ab3CDSFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:05:36 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>, Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>
Date: Mon, 04 Mar 2013 23:32:07 +0530
Message-Id: <20130304180206.31281.67229.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20130304180146.31281.33540.sendpatchset@codeblue.in.ibm.com>
References: <20130304180146.31281.33540.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC 1/2] kvm: Record the preemption status of vcpus using preempt notifiers
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030417-1618-0000-0000-00000370D1C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Note that we mark as preempted only when vcpu's task state was
Running during preemption.

Thanks Jiannan, Avi for preemption notifier ideas. Thanks Gleb, PeterZ
for their precious suggestions. Thanks Srikar for an idea on avoiding
rcu lock while checking task state that improved overcommit numbers.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |    5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cad77fe..0b31e1c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -252,6 +252,7 @@ struct kvm_vcpu {
 		bool dy_eligible;
 	} spin_loop;
 #endif
+	bool preempted;
 	struct kvm_vcpu_arch arch;
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index adc68fe..83a804c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -244,6 +244,7 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 
 	kvm_vcpu_set_in_spin_loop(vcpu, false);
 	kvm_vcpu_set_dy_eligible(vcpu, false);
+	vcpu->preempted = false;
 
 	r = kvm_arch_vcpu_init(vcpu);
 	if (r < 0)
@@ -2902,6 +2903,8 @@ struct kvm_vcpu *preempt_notifier_to_vcpu(struct preempt_notifier *pn)
 static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
+	if (vcpu->preempted)
+		vcpu->preempted = false;
 
 	kvm_arch_vcpu_load(vcpu, cpu);
 }
@@ -2911,6 +2914,8 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
+	if (current->state == TASK_RUNNING)
+		vcpu->preempted = true;
 	kvm_arch_vcpu_put(vcpu);
 }
 

