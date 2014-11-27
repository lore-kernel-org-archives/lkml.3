Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaK0TEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 14:04:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaK0TEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 14:04:13 -0500
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 4/4] KVM: x86: don't retry hopeless APIC delivery
Date: Thu, 27 Nov 2014 20:03:14 +0100
Message-Id: <1417114994-25235-5-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
References: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

False from kvm_irq_delivery_to_apic_fast() means that we don't handle it
in the fast path, but we still return false in cases that were perfectly
handled, fix that.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/lapic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f6e3369..6c2b8a5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -687,6 +687,8 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 	if (irq->dest_id == map->broadcast)
 		goto out;
 
+	ret = true;
+
 	if (irq->dest_mode == 0) { /* physical mode */
 		if (irq->dest_id >= ARRAY_SIZE(map->phys_map))
 			goto out;
@@ -725,8 +727,6 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 			*r = 0;
 		*r += kvm_apic_set_irq(dst[i]->vcpu, irq, dest_map);
 	}
-
-	ret = true;
 out:
 	rcu_read_unlock();
 	return ret;
-- 
2.1.0

