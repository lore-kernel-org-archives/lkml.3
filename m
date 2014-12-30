Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaL3TxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 14:53:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaL3TxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 14:53:02 -0500
Date: Tue, 30 Dec 2014 17:52:28 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <clark.williams@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -rt] timer: upper bound on loops of __run_timers processing
Message-ID: <20141230195228.GA3057@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit "timers: do not raise softirq unconditionally", allows for timer
wheel processing (__run_timers) to be delayed for long periods of time.

The effect is that 

loops = jiffies - base->timer_jiffies

Can grow to very large values resulting in __run_timers taking hundreds
of milliseconds to execute.

Fix by creating an upper bound on the number of loops to be processed.
This allows a nohz=off kernel to achieve desired latencies.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/kernel/timer.c b/kernel/timer.c
index f59e18c..c128416 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1488,6 +1488,12 @@ void run_local_timers(void)
 	}
 #endif
 
+	if (time_after_eq(jiffies, base->timer_jiffies)) {
+		unsigned long jiffies_delta = jiffies - base->timer_jiffies;
+		if (jiffies_delta > TVR_SIZE)
+			raise_softirq(TIMER_SOFTIRQ);
+	}
+
 	if (!base->active_timers)
 		goto out;
 
