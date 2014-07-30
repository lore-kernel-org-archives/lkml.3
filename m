Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaG3MUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:20:17 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36792 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753032AbaG3MPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 84/94] tracing: Fix wraparound problems in "uptime" trace clock
Date: Wed, 30 Jul 2014 14:15:13 +0200
Message-Id: <9d9959cba3c983232a6cd6edda05dc86d24c981a.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 58d4e21e50ff3cc57910a8abc20d7e14375d2f61 upstream.

The "uptime" trace clock added in:

    commit 8aacf017b065a805d27467843490c976835eb4a5
    tracing: Add "uptime" trace clock that uses jiffies

has wraparound problems when the system has been up more
than 1 hour 11 minutes and 34 seconds. It converts jiffies
to nanoseconds using:
        (u64)jiffies_to_usecs(jiffy) * 1000ULL
but since jiffies_to_usecs() only returns a 32-bit value, it
truncates at 2^32 microseconds.  An additional problem on 32-bit
systems is that the argument is "unsigned long", so fixing the
return value only helps until 2^32 jiffies (49.7 days on a HZ=1000
system).

Avoid these problems by using jiffies_64 as our basis, and
not converting to nanoseconds (we do convert to clock_t because
user facing API must not be dependent on internal kernel
HZ values).

Link: http://lkml.kernel.org/p/99d63c5bfe9b320a3b428d773825a37095bf6a51.1405708254.git.tony.luck@intel.com

Fixes: 8aacf017b065 "tracing: Add "uptime" trace clock that uses jiffies"
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/trace/trace.c       | 2 +-
 kernel/trace/trace_clock.c | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b7566fe4d607..dcdf4e682dd4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -764,7 +764,7 @@ static struct {
 	{ trace_clock_local,	"local",	1 },
 	{ trace_clock_global,	"global",	1 },
 	{ trace_clock_counter,	"counter",	0 },
-	{ trace_clock_jiffies,	"uptime",	1 },
+	{ trace_clock_jiffies,	"uptime",	0 },
 	{ trace_clock,		"perf",		1 },
 	ARCH_TRACE_CLOCKS
 };
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 26dc348332b7..57b67b1f24d1 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -59,13 +59,14 @@ u64 notrace trace_clock(void)
 
 /*
  * trace_jiffy_clock(): Simply use jiffies as a clock counter.
+ * Note that this use of jiffies_64 is not completely safe on
+ * 32-bit systems. But the window is tiny, and the effect if
+ * we are affected is that we will have an obviously bogus
+ * timestamp on a trace event - i.e. not life threatening.
  */
 u64 notrace trace_clock_jiffies(void)
 {
-	u64 jiffy = jiffies - INITIAL_JIFFIES;
-
-	/* Return nsecs */
-	return (u64)jiffies_to_usecs(jiffy) * 1000ULL;
+	return jiffies_64_to_clock_t(jiffies_64 - INITIAL_JIFFIES);
 }
 
 /*
-- 
2.0.1

