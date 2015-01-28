Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbbA1AGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:06:10 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34896 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbbA1AGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:06:08 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86: Fix and enforce max instruction size in the insn decoder
Date: Tue, 27 Jan 2015 16:06:02 -0800
Message-Id: <f8f0bc9b8c58cfd6830f7d88400bf1396cbdcd0f.1422403511.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 instructions cannot exceed 15 bytes, and the instruction decoder
should enforce that.  Prior to 6ba48ff46f76, the instruction length
limit was implicitly set to 16, which was an approximation of 15,
but there is currently no limit at all.

Fix MAX_INSN_SIZE (it should be 15, not 16), and fix the decoder to
reject instructions that exceed MAX_INSN_SIZE.

Other than potentially confusing some of the decoder sanity checks,
I'm not aware of any actual problems that omitting this check would
cause, nor am I aware of any practical problems caused by the
MAX_INSN_SIZE error.

Fixes: 6ba48ff46f76 x86: Remove arbitrary instruction size limit in instruction decoder
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Changes from old versions: folded

arch/x86/include/asm/insn.h | 2 +-
 arch/x86/lib/insn.c         | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 47f29b1d1846..e7814b74caf8 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -69,7 +69,7 @@ struct insn {
 	const insn_byte_t *next_byte;
 };
 
-#define MAX_INSN_SIZE	16
+#define MAX_INSN_SIZE	15
 
 #define X86_MODRM_MOD(modrm) (((modrm) & 0xc0) >> 6)
 #define X86_MODRM_REG(modrm) (((modrm) & 0x38) >> 3)
diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 2480978b31cc..bf1f227cf706 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -52,6 +52,13 @@
  */
 void insn_init(struct insn *insn, const void *kaddr, int buf_len, int x86_64)
 {
+	/*
+	 * Instructions longer than MAX_INSN_SIZE (15 bytes) are invalid
+	 * even if the input buffer is long enough to hold them.
+	 */
+	if (buf_len > MAX_INSN_SIZE)
+		buf_len = MAX_INSN_SIZE;
+
 	memset(insn, 0, sizeof(*insn));
 	insn->kaddr = kaddr;
 	insn->end_kaddr = kaddr + buf_len;
-- 
2.1.0

