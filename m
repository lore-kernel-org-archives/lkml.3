Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761AbaEEMuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:50:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41032 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932308AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 21/50] KVM: ioapic: fix assignment of ioapic->rtc_status.pending_eoi (CVE-2014-0155)
Date: Mon,  5 May 2014 14:43:03 +0200
Message-Id: <95846d96fc3739c515e6c20b0fcea97ab290f09c.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 virt/kvm/ioapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 2d682977ce82..39dc5bc742e0 100644
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
1.9.2

