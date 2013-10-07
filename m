Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab3JGPkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:40:08 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44412 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab3JGPkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:40:05 -0400
Date: Mon, 7 Oct 2013 08:39:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Thoughts on this RCU idle entry/exit patch?
Message-ID: <20131007153955.GA30925@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100715-7182-0000-0000-000008A7C595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic!

The following patch seems to me to be a good idea to better handle
task nesting.  Any reason why it would be a bad thing?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Allow task-level idle entry/exit nesting

The current task-level idle entry/exit code forces an entry/exit on
each call, regardless of the nesting level.  This commit therefore
properly accounts for nesting.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 106f7f5cdd1d..f0be20886617 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -411,11 +411,12 @@ static void rcu_eqs_enter(bool user)
 	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
-	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE)
+	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE) {
 		rdtp->dynticks_nesting = 0;
-	else
+		rcu_eqs_enter_common(rdtp, oldval, user);
+	} else {
 		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
-	rcu_eqs_enter_common(rdtp, oldval, user);
+	}
 }
 
 /**
@@ -533,11 +534,12 @@ static void rcu_eqs_exit(bool user)
 	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE(oldval < 0);
-	if (oldval & DYNTICK_TASK_NEST_MASK)
+	if (oldval & DYNTICK_TASK_NEST_MASK) {
 		rdtp->dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
-	else
+	} else {
 		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
-	rcu_eqs_exit_common(rdtp, oldval, user);
+		rcu_eqs_exit_common(rdtp, oldval, user);
+	}
 }
 
 /**

