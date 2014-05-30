Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814AbaE3PN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:13:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44187 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784AbaE3PN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:13:26 -0400
Date: Fri, 30 May 2014 08:13:16 -0700
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-f41d830fa890044cb60f6bb39fc8f6493ffebb47@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1401387164-43416-14-git-send-email-fenghua.yu@intel.com>
References: <1401387164-43416-14-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86/xsaves: Save xstate to task'
 s xsave area in __save_fpu during booting time
Git-Commit-ID: f41d830fa890044cb60f6bb39fc8f6493ffebb47
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

Commit-ID:  f41d830fa890044cb60f6bb39fc8f6493ffebb47
Gitweb:     http://git.kernel.org/tip/f41d830fa890044cb60f6bb39fc8f6493ffebb47
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 May 2014 11:12:41 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 May 2014 14:33:04 -0700

x86/xsaves: Save xstate to task's xsave area in __save_fpu during booting time

__save_fpu() can be called during early booting time when cpu caps are not
enabled and alternative can not be used yet. Therefore, it calls
xsave_state_booting() during booting time to save xstate to task's xsave area.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1401387164-43416-14-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/fpu-internal.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index cea1c76..6099c0e 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -508,9 +508,12 @@ static inline void user_fpu_begin(void)
 
 static inline void __save_fpu(struct task_struct *tsk)
 {
-	if (use_xsave())
-		xsave_state(&tsk->thread.fpu.state->xsave, -1);
-	else
+	if (use_xsave()) {
+		if (unlikely(system_state == SYSTEM_BOOTING))
+			xsave_state_booting(&tsk->thread.fpu.state->xsave, -1);
+		else
+			xsave_state(&tsk->thread.fpu.state->xsave, -1);
+	} else
 		fpu_fxsave(&tsk->thread.fpu);
 }
 
