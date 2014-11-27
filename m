Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaK0TFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 14:05:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbaK0TEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 14:04:02 -0500
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 1/4] KVM: x86: deliver phys lowest-prio
Date: Thu, 27 Nov 2014 20:03:11 +0100
Message-Id: <1417114994-25235-2-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
References: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Physical mode can't address more than one APIC, but lowest-prio is
allowed, so we just reuse our paths.

SDM 10.6.2.1 Physical Destination:
  Also, for any non-broadcast IPI or I/O subsystem initiated interrupt
  with lowest priority delivery mode, software must ensure that APICs
  defined in the interrupt address are present and enabled to receive
  interrupts.

We could warn on top of that.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/lapic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e0e5642..e8ad09d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -691,8 +691,6 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		goto out;
 
 	if (irq->dest_mode == 0) { /* physical mode */
-		if (irq->delivery_mode == APIC_DM_LOWEST)
-			goto out;
 		dst = &map->phys_map[irq->dest_id & 0xff];
 	} else {
 		u32 mda = irq->dest_id << (32 - map->ldr_bits);
-- 
2.1.0

