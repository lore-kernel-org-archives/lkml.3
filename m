Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934674AbaKMWbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:31:40 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53872 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964780AbaKMWbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:31:31 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Borislav Petkov <bp@alien8.de>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH v2 2/2] uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME
Date: Thu, 13 Nov 2014 14:31:21 -0800
Message-Id: <2beb5abca257e5b5f37420f5d85361e5e197824b.1415917623.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1415917623.git.luto@amacapital.net>
References: <cover.1415917623.git.luto@amacapital.net>
In-Reply-To: <cover.1415917623.git.luto@amacapital.net>
References: <cover.1415917623.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 call do_notify_resume on paranoid returns if TIF_UPROBE is set
but not on non-paranoid returns.  I suspect that this is a mistake
and that the code only works because int3 is paranoid.

Setting _TIF_NOTIFY_RESUME in the uprobe code was probably a
workaround for the x86 bug.  With that bug fixed, we can remove
_TIF_NOTIFY_RESUME from the uprobes code.

Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
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
index 1d0af8a2c646..ed8f2cde34c5 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1640,7 +1640,6 @@ bool uprobe_deny_signal(void)
 		if (__fatal_signal_pending(t) || arch_uprobe_xol_was_trapped(t)) {
 			utask->state = UTASK_SSTEP_TRAPPED;
 			set_tsk_thread_flag(t, TIF_UPROBE);
-			set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
 		}
 	}
 
-- 
1.9.3

