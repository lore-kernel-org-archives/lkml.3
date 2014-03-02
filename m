Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaCBX7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:59:43 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62413 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbaCBX7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:59:41 -0500
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, viro@zeniv.linux.org.uk, vgupta@synopsys.com,
        catalin.marinas@arm.com, will.deacon@arm.com, hskinnemoen@gmail.com,
        egtvedt@samfundet.no, vapier@gentoo.org, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com, jesper.nilsson@axis.com,
        dhowells@redhat.com, rkuo@codeaurora.org, tony.luck@intel.com,
        fenghua.yu@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu,
        yasutake.koichi@jp.panasonic.com, ralf@linux-mips.org,
        jonas@southpole.se, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, liqin.linux@gmail.com, lennox.wu@gmail.com,
        cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        linux-xtensa@linux-xtensa.org, akpm@linux-foundation.org,
        oleg@redhat.com, tj@kernel.org, hch@infradead.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 28/44] Add translate_signal() helper
Date: Mon,  3 Mar 2014 00:59:11 +0100
Message-Id: <1393804758-7916-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804758-7916-1-git-send-email-richard@nod.at>
References: <1393804758-7916-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Translating signals is common task. Currently many arch have this
open coded. This provides a common helper for all archs.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/linux/signal.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index ef8fcfd..5dfe4c8 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -2,6 +2,8 @@
 #define _LINUX_SIGNAL_H
 
 #include <linux/list.h>
+#include <linux/personality.h>
+#include <linux/thread_info.h>
 #include <uapi/linux/signal.h>
 
 struct task_struct;
@@ -285,6 +287,16 @@ struct ksignal {
 	int sig;
 };
 
+static inline int translate_signal(int sig)
+{
+	struct thread_info *info = current_thread_info();
+
+	if (info->exec_domain && info->exec_domain->signal_invmap && sig < 32)
+		return info->exec_domain->signal_invmap[sig];
+
+	return sig;
+}
+
 extern int get_signal(struct ksignal *ksig);
 extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping);
 extern void exit_signals(struct task_struct *tsk);
-- 
1.8.4.2

