Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbbALXEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:04:25 -0500
Received: from mail-yk0-f180.google.com ([209.85.160.180]:65455 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbbALXEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:04:23 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3.19 v2 2/3] x86, mpx: Short-circuit the instruction decoder for unexpected opcodes
Date: Mon, 12 Jan 2015 15:04:10 -0800
Message-Id: <6cb492e6037780a61b973cc9e40050d43452ed63.1421103159.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1421103159.git.luto@amacapital.net>
References: <cover.1421103159.git.luto@amacapital.net>
In-Reply-To: <cover.1421103159.git.luto@amacapital.net>
References: <cover.1421103159.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reduces the degree to which we're exposing the instruction decoder
to malicious user code at very little complexity cost.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/mm/mpx.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/mpx.c b/arch/x86/mm/mpx.c
index 67ebf5751222..3c3692149e43 100644
--- a/arch/x86/mm/mpx.c
+++ b/arch/x86/mm/mpx.c
@@ -230,6 +230,22 @@ static int mpx_insn_decode(struct insn *insn,
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
+	if (buf[0] != 0x0f)
+		goto bad_opcode;
+	if (buf[1] != 0x1a && buf[1] != 0x1b)
+		goto bad_opcode;
+
 	insn_init(insn, buf, nr_copied, x86_64);
 	insn_get_length(insn);
 	/*
@@ -244,15 +260,6 @@ static int mpx_insn_decode(struct insn *insn,
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

