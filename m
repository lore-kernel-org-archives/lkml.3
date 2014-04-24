Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbaDXK6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:58:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52778 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbaDXK6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:58:21 -0400
Date: Thu, 24 Apr 2014 03:57:47 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-6a5022a56ac37da7bffece043331a101ed0040b1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jkosina@suse.cz, masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        jlebon@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        jlebon@redhat.com, tglx@linutronix.de
In-Reply-To: <20140417081651.26341.10593.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081651.26341.10593.stgit@ltc230.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/kprobes] kprobes/x86:
  Allow to handle reentered kprobe on single-stepping
Git-Commit-ID: 6a5022a56ac37da7bffece043331a101ed0040b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a5022a56ac37da7bffece043331a101ed0040b1
Gitweb:     http://git.kernel.org/tip/6a5022a56ac37da7bffece043331a101ed0040b1
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 17 Apr 2014 17:16:51 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Apr 2014 10:02:55 +0200

kprobes/x86: Allow to handle reentered kprobe on single-stepping

Since the NMI handlers(e.g. perf) can interrupt in the
single stepping (or preparing the single stepping, do_debug
etc.), we should consider a kprobe is hit in the NMI
handler. Even in that case, the kprobe is allowed to be
reentered as same as the kprobes hit in kprobe handlers
(KPROBE_HIT_ACTIVE or KPROBE_HIT_SSDONE).

The real issue will happen when a kprobe hit while another
reentered kprobe is processing (KPROBE_REENTER), because
we already consumed a saved-area for the previous kprobe.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Jonathan Lebon <jlebon@redhat.com>
Link: http://lkml.kernel.org/r/20140417081651.26341.10593.stgit@ltc230.yrl.intra.hitachi.co.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 61b17dc..da7bdaa 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -531,10 +531,11 @@ reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb
 	switch (kcb->kprobe_status) {
 	case KPROBE_HIT_SSDONE:
 	case KPROBE_HIT_ACTIVE:
+	case KPROBE_HIT_SS:
 		kprobes_inc_nmissed_count(p);
 		setup_singlestep(p, regs, kcb, 1);
 		break;
-	case KPROBE_HIT_SS:
+	case KPROBE_REENTER:
 		/* A probe has been hit in the codepath leading up to, or just
 		 * after, single-stepping of a probed instruction. This entire
 		 * codepath should strictly reside in .kprobes.text section.
