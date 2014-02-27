Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaB0Hkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 02:40:45 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51110 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaB0HdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 02:33:24 -0500
Subject: [PATCH -tip v7 02/26] kprobes/x86: Allow to handle reentered kprobe
 on singlestepping
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Feb 2014 16:33:21 +0900
Message-ID: <20140227073321.20992.55436.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140227073315.20992.6174.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140227073315.20992.6174.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/kprobes/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index b482e96..a9a42fa 100644
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


