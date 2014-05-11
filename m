Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbaEKTWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:22:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011AbaEKTWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:22:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.10 08/48] KVM: ioapic: fix assignment of ioapic->rtc_status.pending_eoi (CVE-2014-0155)
Date: Sun, 11 May 2014 21:19:42 +0200
Message-Id: <20140511191949.268912003@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191948.079900414@linuxfoundation.org>
References: <20140511191948.079900414@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/ioapic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -306,7 +306,7 @@ static int ioapic_deliver(struct kvm_ioa
 		BUG_ON(ioapic->rtc_status.pending_eoi != 0);
 		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe,
 				ioapic->rtc_status.dest_map);
-		ioapic->rtc_status.pending_eoi = ret;
+		ioapic->rtc_status.pending_eoi = (ret < 0 ? 0 : ret);
 	} else
 		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe, NULL);
 


