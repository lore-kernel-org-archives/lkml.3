Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaL3Awn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 19:52:43 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:53380 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaL3Awk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 19:52:40 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3.19 2/3] x86, mpx: Short-circuit the instruction decoder for unexpected opcodes
Date: Mon, 29 Dec 2014 16:52:26 -0800
Message-Id: <c633f0422baee0cbc79babc670d02f4639cd679f.1419900414.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1419900414.git.luto@amacapital.net>
References: <cover.1419900414.git.luto@amacapital.net>
In-Reply-To: <cover.1419900414.git.luto@amacapital.net>
References: <cover.1419900414.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reduces the degree to which we're exposing the instruction decoder
to malicious user code and very little complexity cost.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/mm/mpx.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/mpx.c b/arch/x86/mm/mpx.c
index 082ab9c4ac1c..cefa615becb3 100644
--- a/arch/x86/mm/mpx.c
+++ b/arch/x86/mm/mpx.c
@@ -230,6 +230,23 @@ static int mpx_insn_decode(struct insn *insn,
 	 */
 	if (!nr_copied)
 		return -EFAULT;
+
+	/*
+	 * We only _really_ need to decode bndcl/bndcn/bndcu
+	 * Error out on anything else.  Check this before decoding the
+	 * instruction to reduce our exposure to intentionally bad code
+	 * to some extent.  Note that this shortcut cat incorrectly return
+	 * -EINVAL instead of -EFAULT under some circumstances.  This
+	 * discrepency has no effect.
+	 */
+	if (nr_copied < 2)
+		goto bad_opcode;
+	if (insn->opcode.bytes[0] != 0x0f)
+		goto bad_opcode;
+	if ((insn->opcode.bytes[1] != 0x1a) &&
+	    (insn->opcode.bytes[1] != 0x1b))
+		goto bad_opcode;
+
 	insn_init(insn, buf, nr_copied, x86_64);
 	insn_get_length(insn);
 	/*
@@ -244,15 +261,6 @@ static int mpx_insn_decode(struct insn *insn,
 		return -EFAULT;
 
 	insn_get_opcode(insn);
-	/*
-	 * We only _really_ need to decode bndcl/bndcn/bndcu
-	 * Error out on anything else.
-	 */
-	if (insn->opcode.bytes[0] != 0x0f)
-		goto bad_opcode;
-	if ((insn->opcode.bytes[1] != 0x1a) &&
-	    (insn->opcode.bytes[1] != 0x1b))
-		goto bad_opcode;
 
 	return 0;
 bad_opcode:
-- 
2.1.0

