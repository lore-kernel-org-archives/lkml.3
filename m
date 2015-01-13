Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbbAMCL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 21:11:27 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:45245 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbbAMCLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 21:11:24 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3.19 v3 2/2] x86: Enforce MAX_INSN_SIZE in the instruction decoder
Date: Mon, 12 Jan 2015 18:11:10 -0800
Message-Id: <9f3481d663e19b47d172f6bfa19581a2bc5bb012.1421115006.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1421115006.git.luto@amacapital.net>
References: <cover.1421115006.git.luto@amacapital.net>
In-Reply-To: <cover.1421115006.git.luto@amacapital.net>
References: <cover.1421115006.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The instruction decoder used to assume that the input buffer was
exactly MAX_INSN_SIZE bytes long.  Now that the input buffer has
variable length, even if the input buffer is longer than
MAX_INSN_SIZE, we should still reject instructions longer than
MAX_INSN_SIZE, since a real CPU will reject them even if they're
otherwise valid.

Other than potentially confusing some of the decoder sanity checks,
I'm not aware of any actual problems that omitting this check would
cause.

It's worth noting that MAX_INSN_SIZE is incorrectly set to 16.  This
patch doesn't change that.  I'll submit a fix for that later.

Fixes: 6ba48ff46f76 x86: Remove arbitrary instruction size limit in instruction decoder
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/lib/insn.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 2480978b31cc..4dc8252b6454 100644
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
+	if (buf_len > MAX_INSN_SIZE)
+		buf_len = MAX_INSN_SIZE;
+
 	memset(insn, 0, sizeof(*insn));
 	insn->kaddr = kaddr;
 	insn->end_kaddr = kaddr + buf_len;
-- 
2.1.0

