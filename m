Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3J2LyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:54:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35513 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab3J2LyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:54:15 -0400
Date: Tue, 29 Oct 2013 12:54:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Gleb Natapov <gleb@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre@andrep.de>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/5 -v3.1] kvm, emulator: Add initial three-byte insns support
Message-ID: <20131029115409.GF10972@pd.tnic>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
 <20131029095300.GW15657@redhat.com>
 <20131029103003.GA10977@pd.tnic>
 <20131029103524.GZ15657@redhat.com>
 <20131029112824.GD10972@pd.tnic>
 <20131029113603.GC15657@redhat.com>
 <20131029115303.GE10972@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131029115303.GE10972@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Add initial support for handling three-byte instructions in the
emulator.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kvm/emulate.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 541801527225..6c5cfe962b28 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3892,6 +3892,25 @@ static const struct opcode twobyte_table[256] = {
 	N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N
 };
 
+static const struct gprefix three_byte_0f_38_f0 = {
+	N, N, N, N
+};
+
+static const struct gprefix three_byte_0f_38_f1 = {
+	N, N, N, N
+};
+
+/*
+ * Insns below are selected by the prefix which indexed by the third opcode
+ * byte.
+ */
+static const struct opcode opcode_map_0f_38[256] = {
+	/* 0x00 - 0x7f */
+	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
+	/* 0x80 - 0xff */
+	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N)
+};
+
 #undef D
 #undef N
 #undef G
@@ -4212,6 +4231,13 @@ done_prefixes:
 		ctxt->opcode_len = 2;
 		ctxt->b = insn_fetch(u8, ctxt);
 		opcode = twobyte_table[ctxt->b];
+
+		/* 0F_38 opcode map */
+		if (ctxt->b == 0x38) {
+			ctxt->opcode_len = 3;
+			ctxt->b = insn_fetch(u8, ctxt);
+			opcode = opcode_map_0f_38[ctxt->b];
+		}
 	}
 	ctxt->d = opcode.flags;
 
@@ -4543,6 +4569,8 @@ special_insn:
 
 	if (ctxt->opcode_len == 2)
 		goto twobyte_insn;
+	else if (ctxt->opcode_len == 3)
+		goto threebyte_insn;
 
 	switch (ctxt->b) {
 	case 0x63:		/* movsxd */
@@ -4727,6 +4755,8 @@ twobyte_insn:
 		goto cannot_emulate;
 	}
 
+threebyte_insn:
+
 	if (rc != X86EMUL_CONTINUE)
 		goto done;
 
-- 
1.8.4

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
