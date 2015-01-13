Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbbAMVtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:49:33 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64998 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbbAMVtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:49:31 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3.19 v4 2/2] x86: Enforce maximum instruction size in the instruction decoder
Date: Tue, 13 Jan 2015 13:49:20 -0800
Message-Id: <6ceb805aba0291431f19f72d7f2e765f3a0a9fcf.1421183147.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1421183147.git.luto@amacapital.net>
References: <cover.1421183147.git.luto@amacapital.net>
In-Reply-To: <cover.1421183147.git.luto@amacapital.net>
References: <cover.1421183147.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 instructions cannot exceed 15 bytes, and the instruction decoder
should enforce that.  Prior to 6ba48ff46f76, the instruction length
limit was implicitly set to 16, which was an approximation of 15,
but there is currently no limit at all.

Fix the decoder to reject instructions that exceed 15 bytes.
A subsequent patch (targetted for 3.20) will fix MAX_INSN_SIZE.

Other than potentially confusing some of the decoder sanity checks,
I'm not aware of any actual problems that omitting this check would
cause.

Fixes: 6ba48ff46f76 x86: Remove arbitrary instruction size limit in instruction decoder
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/lib/insn.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 2480978b31cc..7b80745d2c5a 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -52,6 +52,13 @@
  */
 void insn_init(struct insn *insn, const void *kaddr, int buf_len, int x86_64)
 {
+	/*
+	 * Instructions longer than 15 bytes are invalid even if the
+	 * input buffer is long enough to hold them.
+	 */
+	if (buf_len > 15)
+		buf_len = 15;
+
 	memset(insn, 0, sizeof(*insn));
 	insn->kaddr = kaddr;
 	insn->end_kaddr = kaddr + buf_len;
-- 
2.1.0

