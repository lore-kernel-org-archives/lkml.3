Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaLFPZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:25:42 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47677 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752018AbaLFPIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:01 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 18/66] uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME
Date: Sat,  6 Dec 2014 16:07:10 +0100
Message-Id: <c50db3a5b930ef107cf6df611e729032e69de350.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/include/asm/thread_info.h | 2 +-
 kernel/events/uprobes.c            | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 27811190cbd7..bbbac9207419 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -145,7 +145,7 @@ struct thread_info {
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
 	(_TIF_SIGPENDING | _TIF_MCE_NOTIFY | _TIF_NOTIFY_RESUME |	\
-	 _TIF_USER_RETURN_NOTIFY)
+	 _TIF_USER_RETURN_NOTIFY | _TIF_UPROBE)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index ad8e1bdca70e..8176caf6efd9 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1511,7 +1511,6 @@ bool uprobe_deny_signal(void)
 		if (__fatal_signal_pending(t) || arch_uprobe_xol_was_trapped(t)) {
 			utask->state = UTASK_SSTEP_TRAPPED;
 			set_tsk_thread_flag(t, TIF_UPROBE);
-			set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
 		}
 	}
 
-- 
2.1.3

