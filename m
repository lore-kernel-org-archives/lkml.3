Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab3DDKoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:44:22 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:34612 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab3DDKoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:44:21 -0400
X-AuditID: 85900ec0-d60ccb900000151e-1f-515d59818299
Subject: [PATCH -tip ] kprobes/x86: Just return error for sanity check failure
 instead of using BUG_ON
To: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, yrl.pp-manager.tt@hitachi.com
Date: Thu, 04 Apr 2013 19:42:30 +0900
Message-ID: <20130404104230.22862.85242.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return an error from __copy_instruction and use printk to
give us more productive message, since this is just an error
case which we can handle it and also the BUG_ON() never
tell us why and what happened,

This is related to the below bug-report.
https://bugzilla.redhat.com/show_bug.cgi?id=910649

Note, this patch is for help to analyze what happened.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/kprobes/core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 7bfe318..a86f83d 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -353,7 +353,11 @@ int __kprobes __copy_instruction(u8 *dest, u8 *src)
 		 * have given.
 		 */
 		newdisp = (u8 *) src + (s64) insn.displacement.value - (u8 *) dest;
-		BUG_ON((s64) (s32) newdisp != newdisp); /* Sanity check.  */
+		if ((s64) (s32) newdisp != newdisp) {
+			pr_err("Kprobes error: new displacement is not fit in s32 (%llx)\n", newdisp);
+			pr_err("\tSrc: %p, Dest: %p, old disp: %x\n", src, dest, insn.displacement.value);
+			return 0;
+		}
 		disp = (u8 *) dest + insn_offset_displacement(&insn);
 		*(s32 *) disp = (s32) newdisp;
 	}

