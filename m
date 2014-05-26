Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaEZRAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:00:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:20669 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbaEZQ56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:57:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545122346"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 12/15] x86/xsaves: Save xstate to task's xsave area in __save_fpu during booting time
Date: Mon, 26 May 2014 10:01:19 -0700
Message-Id: <1401123682-5384-13-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

__save_fpu() can be called during early booting time when cpu caps are not
enabled and alternative can not be used yet. Therefore, it calls
xsave_state_booting() to save xstate to task's xsave area.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
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
 
-- 
1.8.1.2

