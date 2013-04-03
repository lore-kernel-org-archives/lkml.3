Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761008Ab3DCMrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:47:18 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:49655 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541Ab3DCMqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:46:43 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/4] nohz: Pack nohz Kconfig option in a menu of choices
Date: Wed,  3 Apr 2013 14:46:29 +0200
Message-Id: <1364993190-13784-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1364993190-13784-1-git-send-email-fweisbec@gmail.com>
References: <1364993190-13784-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the user has the choice between three implementations of
the timer tick:

* Static periodic tick
* Idle dynticks
* Full dynticks

At least for now, these are mutually exclusive choices, so
let's rely on the proper Kconfig feature to display these
to the user.

A new entry CONFIG_NO_HZ_IDLE is created and the old
CONFIG_NO_HZ maps to it for config file backward compatibility.
The old name was too general now that we have more
granular dynticks implementations.

While at it, add some explanation to help the user on
his decision between the 3 entries.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/Kconfig |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index c88fc43..27cc404 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -75,17 +75,33 @@ config NO_HZ_COMMON
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 
+# Kept around for compatibility, maps to NO_HZ_IDLE
 config NO_HZ
-	bool "Tickless System (Dynamic Ticks)"
+	bool
+
+choice
+	prompt "Timer tick handling"
+	default NO_HZ_IDLE if NO_HZ
+
+config PERIODIC_HZ
+	bool "Periodic timer ticks (constant rate, no dynticks)"
+	help
+	  This option keeps the tick running periodically at a constant
+	  rate, even when the CPU doesn't need it.
+
+config NO_HZ_IDLE
+	bool "Idle dynticks system (tickless idle)"
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select NO_HZ_COMMON
 	help
-	  This option enables a tickless system: timer interrupts will
-	  only trigger on an as-needed basis both when the system is
-	  busy and when the system is idle.
+	  This option enables a tickless idle system: timer interrupts
+	  will only trigger on an as-needed basis when the system is idle.
+	  This is usually interesting for energy saving.
+
+	  Most of the time you want to say Y here.
 
 config NO_HZ_EXTENDED
-	bool "Full dynticks system"
+	bool "Full dynticks system (tickless single task)"
 	# NO_HZ_COMMON dependency
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	# RCU_USER_QS
@@ -112,6 +128,8 @@ config NO_HZ_EXTENDED
 
 	 Say N.
 
+endchoice
+
 config HIGH_RES_TIMERS
 	bool "High Resolution Timer Support"
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
-- 
1.7.5.4

