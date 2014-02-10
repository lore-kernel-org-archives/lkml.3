Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaBJN3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:29:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33093 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbaBJN3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:29:25 -0500
Date: Mon, 10 Feb 2014 05:28:43 -0800
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-569d6557ab957d6ae7e97a46ae669174be4189e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, rostedt@goodmis.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140204141315.2a968a72@gandalf.local.home>
References: <20140204141315.2a968a72@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Use preempt_disable_notrace()
  in cycles_2_ns()
Git-Commit-ID: 569d6557ab957d6ae7e97a46ae669174be4189e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:28:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  569d6557ab957d6ae7e97a46ae669174be4189e6
Gitweb:     http://git.kernel.org/tip/569d6557ab957d6ae7e97a46ae669174be4189e6
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Tue, 4 Feb 2014 14:13:15 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 13:09:08 +0100

x86: Use preempt_disable_notrace() in cycles_2_ns()

When debug preempt is enabled, preempt_disable() can be traced by
function and function graph tracing.

There's a place in the function graph tracer that calls trace_clock()
which eventually calls cycles_2_ns() outside of the recursion
protection. When cycles_2_ns() calls preempt_disable() it gets traced
and the graph tracer will go into a recursive loop causing a crash or
worse, a triple fault.

Simple fix is to use preempt_disable_notrace() in cycles_2_ns, which
makes sense because the preempt_disable() tracing may use that code
too, and it tracing it, even with recursion protection is rather
pointless.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140204141315.2a968a72@gandalf.local.home
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/tsc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 19e5adb..acb3b60 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -209,7 +209,7 @@ static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 	 * dance when its actually needed.
 	 */
 
-	preempt_disable();
+	preempt_disable_notrace();
 	data = this_cpu_read(cyc2ns.head);
 	tail = this_cpu_read(cyc2ns.tail);
 
@@ -229,7 +229,7 @@ static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 		if (!--data->__count)
 			this_cpu_write(cyc2ns.tail, data);
 	}
-	preempt_enable();
+	preempt_enable_notrace();
 
 	return ns;
 }
