Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936896Ab3DJJXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:23:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57039 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3DJJXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:23:17 -0400
Date: Wed, 10 Apr 2013 02:22:53 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-8101376dc5f42bd93b36d4ab210b44503d0ec11f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, fche@redhat.com, hpa@zytor.com,
        mingo@kernel.org, masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20130404104230.22862.85242.stgit@mhiramat-M0-7522>
References: <20130404104230.22862.85242.stgit@mhiramat-M0-7522>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes/x86:
  Just return error for sanity check failure instead of using BUG_ON
Git-Commit-ID: 8101376dc5f42bd93b36d4ab210b44503d0ec11f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 02:22:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8101376dc5f42bd93b36d4ab210b44503d0ec11f
Gitweb:     http://git.kernel.org/tip/8101376dc5f42bd93b36d4ab210b44503d0ec11f
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 4 Apr 2013 19:42:30 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Apr 2013 17:28:34 +0200

kprobes/x86: Just return error for sanity check failure instead of using BUG_ON

Return an error from __copy_instruction() and use printk() to
give us a more productive message, since this is just an error
case which we can handle and also the BUG_ON() never tells us
why and what happened.

This is related to the following bug-report:

   https://bugzilla.redhat.com/show_bug.cgi?id=910649

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20130404104230.22862.85242.stgit@mhiramat-M0-7522
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 7bfe318..9895a9a 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -353,7 +353,11 @@ int __kprobes __copy_instruction(u8 *dest, u8 *src)
 		 * have given.
 		 */
 		newdisp = (u8 *) src + (s64) insn.displacement.value - (u8 *) dest;
-		BUG_ON((s64) (s32) newdisp != newdisp); /* Sanity check.  */
+		if ((s64) (s32) newdisp != newdisp) {
+			pr_err("Kprobes error: new displacement does not fit into s32 (%llx)\n", newdisp);
+			pr_err("\tSrc: %p, Dest: %p, old disp: %x\n", src, dest, insn.displacement.value);
+			return 0;
+		}
 		disp = (u8 *) dest + insn_offset_displacement(&insn);
 		*(s32 *) disp = (s32) newdisp;
 	}
