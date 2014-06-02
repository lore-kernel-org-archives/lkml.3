Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbaFBPhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:37:45 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:37075 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbaFBPee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:34:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReNe1cHFoQqBIofpkmBaw
X-IPAS-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReNe1cHFoQqBIofpkmBaw
X-IronPort-AV: E=Sophos;i="4.98,957,1392156000"; 
   d="scan'208";a="109853150"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 3/9] KVM: x86: Loading segments on 64-bit mode may be wrong
Date: Mon,  2 Jun 2014 18:34:05 +0300
Message-Id: <1401723251-8034-4-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
References: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current emulator implementation ignores the high 32 bits of the base in
long-mode.  During segment load from the LDT, the base of the LDT is calculated
incorrectly and may cause the wrong segment to be loaded.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 136088f..7e4a45c 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1358,17 +1358,19 @@ static void get_descriptor_table_ptr(struct x86_emulate_ctxt *ctxt,
 				     u16 selector, struct desc_ptr *dt)
 {
 	const struct x86_emulate_ops *ops = ctxt->ops;
+	u32 base3 = 0;
 
 	if (selector & 1 << 2) {
 		struct desc_struct desc;
 		u16 sel;
 
 		memset (dt, 0, sizeof *dt);
-		if (!ops->get_segment(ctxt, &sel, &desc, NULL, VCPU_SREG_LDTR))
+		if (!ops->get_segment(ctxt, &sel, &desc, &base3,
+				      VCPU_SREG_LDTR))
 			return;
 
 		dt->size = desc_limit_scaled(&desc); /* what if limit > 65535? */
-		dt->address = get_desc_base(&desc);
+		dt->address = get_desc_base(&desc) | ((u64)base3 << 32);
 	} else
 		ops->get_gdt(ctxt, dt);
 }
-- 
1.9.1

