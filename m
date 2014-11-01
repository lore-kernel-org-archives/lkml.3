Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaKAW4k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:56:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60119 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523AbaKAWj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marcelo Tosatti" <mtosatti@redhat.com>,
        "Takuya Yoshikawa" <yoshikawa.takuya@oss.ntt.co.jp>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.178402423@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 089/102] KVM: x86 emulator: Use opcode::execute for CALL
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

commit d4ddafcdf2201326ec9717172767cfad0ede1472 upstream.

CALL: E8

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/emulate.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2536,6 +2536,15 @@ static int em_das(struct x86_emulate_ctx
 	return X86EMUL_CONTINUE;
 }
 
+static int em_call(struct x86_emulate_ctxt *ctxt)
+{
+	long rel = ctxt->src.val;
+
+	ctxt->src.val = (unsigned long)ctxt->_eip;
+	jmp_rel(ctxt, rel);
+	return em_push(ctxt);
+}
+
 static int em_call_far(struct x86_emulate_ctxt *ctxt)
 {
 	u16 sel, old_cs;
@@ -3271,7 +3280,7 @@ static struct opcode opcode_table[256] =
 	D2bvIP(SrcImmUByte | DstAcc, in,  check_perm_in),
 	D2bvIP(SrcAcc | DstImmUByte, out, check_perm_out),
 	/* 0xE8 - 0xEF */
-	D(SrcImm | Stack), D(SrcImm | ImplicitOps),
+	I(SrcImm | Stack, em_call), D(SrcImm | ImplicitOps),
 	I(SrcImmFAddr | No64, em_jmp_far), D(SrcImmByte | ImplicitOps),
 	D2bvIP(SrcDX | DstAcc, in,  check_perm_in),
 	D2bvIP(SrcAcc | DstDX, out, check_perm_out),
@@ -3966,13 +3975,6 @@ special_insn:
 	case 0xe6: /* outb */
 	case 0xe7: /* out */
 		goto do_io_out;
-	case 0xe8: /* call (near) */ {
-		long int rel = ctxt->src.val;
-		ctxt->src.val = (unsigned long) ctxt->_eip;
-		jmp_rel(ctxt, rel);
-		rc = em_push(ctxt);
-		break;
-	}
 	case 0xe9: /* jmp rel */
 	case 0xeb: /* jmp rel short */
 		jmp_rel(ctxt, ctxt->src.val);

