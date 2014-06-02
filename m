Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaFBPei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:34:38 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:7149 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaFBPed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:34:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReOUgcWhCoEih+mSQ
X-IPAS-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReOUgcWhCoEih+mSQ
X-IronPort-AV: E=Sophos;i="4.98,957,1392156000"; 
   d="scan'208";a="109853133"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 1/9] KVM: x86: Mark VEX-prefix instructions emulation as unimplemented
Date: Mon,  2 Jun 2014 18:34:03 +0300
Message-Id: <1401723251-8034-2-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
References: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the emulator does not recognize vex-prefix instructions.  However, it
may incorrectly decode lgdt/lidt instructions and try to execute them. This
patch returns unhandlable error on their emulation.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e4e833d..8ec4a3e 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4314,6 +4314,13 @@ done_prefixes:
 	if (ctxt->d & ModRM)
 		ctxt->modrm = insn_fetch(u8, ctxt);
 
+	/* vex-prefix instructions are not implemented */
+	if (ctxt->opcode_len == 1 && (ctxt->b == 0xc5 || ctxt->b == 0xc4) &&
+	    (mode == X86EMUL_MODE_PROT64 ||
+	    (mode >= X86EMUL_MODE_PROT16 && (ctxt->modrm & 0x80)))) {
+		ctxt->d = NotImpl;
+	}
+
 	while (ctxt->d & GroupMask) {
 		switch (ctxt->d & GroupMask) {
 		case Group:
-- 
1.9.1

