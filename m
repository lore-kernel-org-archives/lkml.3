Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbaHHUlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:41:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40025 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaHHUlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 002/259] KVM: ioapic: fix assignment of ioapic->rtc_status.pending_eoi (CVE-2014-0155)
Date: Fri,  8 Aug 2014 13:37:05 -0700
Message-Id: <1407530482-4483-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 5678de3f15010b9022ee45673f33bcfc71d47b60 upstream.

QE reported that they got the BUG_ON in ioapic_service to trigger.
I cannot reproduce it, but there are two reasons why this could happen.

The less likely but also easiest one, is when kvm_irq_delivery_to_apic
does not deliver to any APIC and returns -1.

Because irqe.shorthand == 0, the kvm_for_each_vcpu loop in that
function is never reached.  However, you can target the similar loop in
kvm_irq_delivery_to_apic_fast; just program a zero logical destination
address into the IOAPIC, or an out-of-range physical destination address.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 virt/kvm/ioapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 2d68297..39dc5bc 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -306,7 +306,7 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq, bool line_status)
 		BUG_ON(ioapic->rtc_status.pending_eoi != 0);
 		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe,
 				ioapic->rtc_status.dest_map);
-		ioapic->rtc_status.pending_eoi = ret;
+		ioapic->rtc_status.pending_eoi = (ret < 0 ? 0 : ret);
 	} else
 		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe, NULL);
 
-- 
1.9.1

