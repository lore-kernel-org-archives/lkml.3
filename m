Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaLOOmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:42:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38816 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbaLOO2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 122/168] uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME
Date: Mon, 15 Dec 2014 14:26:16 +0000
Message-Id: <1418653622-21105-123-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit 82975bc6a6df743b9a01810fb32cb65d0ec5d60b upstream.

x86 call do_notify_resume on paranoid returns if TIF_UPROBE is set but
not on non-paranoid returns.  I suspect that this is a mistake and that
the code only works because int3 is paranoid.

Setting _TIF_NOTIFY_RESUME in the uprobe code was probably a workaround
for the x86 bug.  With that bug fixed, we can remove _TIF_NOTIFY_RESUME
from the uprobes code.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/include/asm/thread_info.h | 2 +-
 kernel/events/uprobes.c            | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 854053889d4d..547e344a6dc6 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -141,7 +141,7 @@ struct thread_info {
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
 	(_TIF_SIGPENDING | _TIF_MCE_NOTIFY | _TIF_NOTIFY_RESUME |	\
-	 _TIF_USER_RETURN_NOTIFY)
+	 _TIF_USER_RETURN_NOTIFY | _TIF_UPROBE)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 6f3254e8c137..9a4d44f93015 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1639,7 +1639,6 @@ bool uprobe_deny_signal(void)
 		if (__fatal_signal_pending(t) || arch_uprobe_xol_was_trapped(t)) {
 			utask->state = UTASK_SSTEP_TRAPPED;
 			set_tsk_thread_flag(t, TIF_UPROBE);
-			set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
 		}
 	}
 
-- 
2.1.3

