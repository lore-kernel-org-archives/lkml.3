Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab3ENQDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:03:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43325 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab3ENQDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:03:13 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is enabled
Date: Tue, 14 May 2013 18:02:51 +0200
Message-Id: <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1368547372-21011-1-git-send-email-fweisbec@gmail.com>
References: <1368547372-21011-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Trying to test the nohz_full code, I was not able to get it to work.
Finally I enabled the tick_stop tracepoint and it showed:

 tick_stop:            success=no msg=perf events running

I talked to Frederic Weisbecker about this and he informed me that
perf is used by the lockup detector. I checked the code, and sure
enough it is.

As perf is always running when LOCKUP_DETECTOR is enabled, which
will always disable nohz_full from working, instead of confusing
users, disable LOCKUP_DETECTOR when NO_HZ_FULL is enabled.

When perf is changed such that it does not prevent nohz_full from
working, then we can and should remove this constraint.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/Kconfig.debug |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 566cf2b..1364d09 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -174,6 +174,8 @@ config DEBUG_SHIRQ
 config LOCKUP_DETECTOR
 	bool "Detect Hard and Soft Lockups"
 	depends on DEBUG_KERNEL && !S390
+	# Lockup detector currently prevents NO_HZ_FULL from working
+	depends on !NO_HZ_FULL
 	help
 	  Say Y here to enable the kernel to act as a watchdog to detect
 	  hard and soft lockups.
-- 
1.7.5.4

