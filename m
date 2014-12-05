Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaLEXVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:21:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaLEW4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 09/73] uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME
Date: Fri,  5 Dec 2014 14:44:15 -0800
Message-Id: <20141205224434.211794088@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/thread_info.h |    2 +-
 kernel/events/uprobes.c            |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -144,7 +144,7 @@ struct thread_info {
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
 	(_TIF_SIGPENDING | _TIF_MCE_NOTIFY | _TIF_NOTIFY_RESUME |	\
-	 _TIF_USER_RETURN_NOTIFY)
+	 _TIF_USER_RETURN_NOTIFY | _TIF_UPROBE)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1621,7 +1621,6 @@ bool uprobe_deny_signal(void)
 		if (__fatal_signal_pending(t) || arch_uprobe_xol_was_trapped(t)) {
 			utask->state = UTASK_SSTEP_TRAPPED;
 			set_tsk_thread_flag(t, TIF_UPROBE);
-			set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
 		}
 	}
 


