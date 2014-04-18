Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaDRAfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:35:31 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:61087 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaDRAf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:35:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkkCABJyUFOERM5ejGdsb2JhbABZyACBIxYOAQEBJzyCJgEFJ1IQQBFXBxIbh2HGDYYUF45iB4Q4BIlcpRM6
X-IPAS-Result: AkkCABJyUFOERM5ejGdsb2JhbABZyACBIxYOAQEBJzyCJgEFJ1IQQBFXBxIbh2HGDYYUF45iB4Q4BIlcpRM6
X-IronPort-AV: E=Sophos;i="4.97,882,1389736800"; 
   d="scan'208";a="102882798"
From: Nadav Amit <namit@cs.technion.ac.il>
To: gleb@kernel.org, pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 1/5] KVM: x86: Fix wrong/stuck PMU when guest does not use PMI
Date: Fri, 18 Apr 2014 03:35:08 +0300
Message-Id: <1397781312-6885-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il>
References: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a guest enables a performance counter but does not enable PMI, the
hypervisor currently does not reprogram the performance counter once it
overflows.  As a result the host performance counter is kept with the original
sampling period which was configured according to the value of the guest's
counter when the counter was enabled.

Such behaviour can cause very bad consequences. The most distrubing one can
cause the guest not to make any progress at all, and keep exiting due to host
PMI before any guest instructions is exeucted. This situation occurs when the
performance counter holds a very high value when the guest enables the
performance counter. As a result the host's sampling period is configured to be
very short. The host then never reconfigures the sampling period and get stuck
at entry->PMI->exit loop. We encountered such a scenario in our experiments.

The solution is to reprogram the counter even if the guest does not use PMI.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
:100644 100644 5c4f631... cbecaa9... M	arch/x86/kvm/pmu.c
 arch/x86/kvm/pmu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 5c4f631..cbecaa9 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -108,7 +108,10 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 {
 	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
 	struct kvm_pmu *pmu = &pmc->vcpu->arch.pmu;
-	__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+	if (!test_and_set_bit(pmc->idx, (unsigned long *)&pmu->reprogram_pmi)) {
+		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
+	}
 }
 
 static void kvm_perf_overflow_intr(struct perf_event *perf_event,
@@ -117,7 +120,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
 	struct kvm_pmu *pmu = &pmc->vcpu->arch.pmu;
 	if (!test_and_set_bit(pmc->idx, (unsigned long *)&pmu->reprogram_pmi)) {
-		kvm_perf_overflow(perf_event, data, regs);
+		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 		/*
 		 * Inject PMI. If vcpu was in a guest mode during NMI PMI
-- 
1.7.10.4

