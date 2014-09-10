Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaIJQyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:54:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46479 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaIJQyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:54:09 -0400
From: Chris J Arges <chris.j.arges@canonical.com>
To: kvm@vger.kernel.org
Cc: Chris J Arges <chris.j.arges@canonical.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: ioapic: add check for RTC_GSI
Date: Wed, 10 Sep 2014 11:53:31 -0500
Message-Id: <1410368033-23628-1-git-send-email-chris.j.arges@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck found the following error:
[ioapic.c:114]: (error) Array index -1 is out of bounds.

If CONFIG_X86 is not defined, RTC_GSI == -1U which means that an out of bounds
error could occur when accessing &ioapic->redirtbl[RTC_GSI].

This patch adds a check to kvm_rtc_eoi_tracking_restore_one that is similar to
how kvm_rtc_eoi_tracking_restore_all checks this condition.

Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
---
 virt/kvm/ioapic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index e8ce34c..859f5b8 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -136,6 +136,9 @@ void kvm_rtc_eoi_tracking_restore_one(struct kvm_vcpu *vcpu)
 {
 	struct kvm_ioapic *ioapic = vcpu->kvm->arch.vioapic;
 
+	if (RTC_GSI >= IOAPIC_NUM_PINS)
+		return;
+
 	spin_lock(&ioapic->lock);
 	__rtc_irq_eoi_tracking_restore_one(vcpu);
 	spin_unlock(&ioapic->lock);
-- 
1.9.1

