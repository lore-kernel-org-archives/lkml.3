Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108AbaK0TEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 14:04:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbaK0TEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 14:04:06 -0500
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 2/4] KVM: x86: fix APIC physical destination wrapping
Date: Thu, 27 Nov 2014 20:03:12 +0100
Message-Id: <1417114994-25235-3-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
References: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x2apic allows destinations > 0xff and we don't want them delivered to
lower APICs.  They are correctly handled by doing nothing.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/lapic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e8ad09d..049d30f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -691,7 +691,10 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		goto out;
 
 	if (irq->dest_mode == 0) { /* physical mode */
-		dst = &map->phys_map[irq->dest_id & 0xff];
+		if (irq->dest_id >= ARRAY_SIZE(map->phys_map))
+			goto out;
+
+		dst = &map->phys_map[irq->dest_id];
 	} else {
 		u32 mda = irq->dest_id << (32 - map->ldr_bits);
 
-- 
2.1.0

