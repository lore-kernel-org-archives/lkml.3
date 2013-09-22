Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab3IVOpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 10:45:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53474 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab3IVOpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 10:45:06 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre@andrep.de>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/6] kvm, emulator: Use opcode length
Date: Sun, 22 Sep 2013 16:44:51 +0200
Message-Id: <1379861095-628-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379861095-628-1-git-send-email-bp@alien8.de>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Add a field to the current emulation context which contains the
instruction opcode length. This will streamline handling of opcodes of
different length.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/kvm_emulate.h | 8 ++++++--
 arch/x86/kvm/emulate.c             | 5 +++--
 arch/x86/kvm/x86.c                 | 4 ++--
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 15f960c06ff7..92a176ad456c 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -279,8 +279,12 @@ struct x86_emulate_ctxt {
 	bool have_exception;
 	struct x86_exception exception;
 
-	/* decode cache */
-	u8 twobyte;
+	/*
+	 * decode cache
+	 */
+
+	/* current opcode length in bytes */
+	u8 opcode_len;
 	u8 b;
 	u8 intercept;
 	u8 lock_prefix;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2bc1e81045b0..bfae4a433091 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4114,6 +4114,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 	ctxt->_eip = ctxt->eip;
 	ctxt->fetch.start = ctxt->_eip;
 	ctxt->fetch.end = ctxt->fetch.start + insn_len;
+	ctxt->opcode_len = 1;
 	if (insn_len > 0)
 		memcpy(ctxt->fetch.data, insn, insn_len);
 
@@ -4196,7 +4197,7 @@ done_prefixes:
 	opcode = opcode_table[ctxt->b];
 	/* Two-byte opcode? */
 	if (ctxt->b == 0x0f) {
-		ctxt->twobyte = 1;
+		ctxt->opcode_len = 2;
 		ctxt->b = insn_fetch(u8, ctxt);
 		opcode = twobyte_table[ctxt->b];
 	}
@@ -4528,7 +4529,7 @@ special_insn:
 		goto writeback;
 	}
 
-	if (ctxt->twobyte)
+	if (ctxt->opcode_len == 2)
 		goto twobyte_insn;
 
 	switch (ctxt->b) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8dfde7a52dab..6f2ea40b80cf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4778,8 +4778,8 @@ static void inject_emulated_exception(struct kvm_vcpu *vcpu)
 
 static void init_decode_cache(struct x86_emulate_ctxt *ctxt)
 {
-	memset(&ctxt->twobyte, 0,
-	       (void *)&ctxt->_regs - (void *)&ctxt->twobyte);
+	memset(&ctxt->opcode_len, 0,
+	       (void *)&ctxt->_regs - (void *)&ctxt->opcode_len);
 
 	ctxt->fetch.start = 0;
 	ctxt->fetch.end = 0;
-- 
1.8.4

