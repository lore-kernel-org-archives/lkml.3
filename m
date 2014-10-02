Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaJBQ5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:57:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:57529 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaJBQ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:57:43 -0400
Date: Thu, 2 Oct 2014 18:57:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>, oleg@redhat.com
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at kernel/sched/core.c:7156
 __might_sleep()
Message-ID: <20141002165739.GC10583@worktop.programming.kicks-ass.net>
References: <20140930080228.GD9561@wfg-t540p.sh.intel.com>
 <20141002110927.GE2849@worktop.programming.kicks-ass.net>
 <20141002123150.GC6324@worktop.programming.kicks-ass.net>
 <20141002124247.GD6324@worktop.programming.kicks-ass.net>
 <542D57D0.4030904@hurleysoftware.com>
 <20141002135250.GB10583@worktop.programming.kicks-ass.net>
 <20141002135805.GF6324@worktop.programming.kicks-ass.net>
 <542D5E3B.6000309@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542D5E3B.6000309@hurleysoftware.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 10:16:27AM -0400, Peter Hurley wrote:
> That's what I meant. And the module load patch too.

Ah, my bad. I thought you were talking about the rfcomm thing.

In any case, if we change wait_woken() like the below, then we can
simplify the loops by taking out their signal_pending checks and using
the wait_woken() return value instead.

---
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -326,8 +326,14 @@ long wait_woken(wait_queue_t *wait, unsi
 	 * woken_wake_function() such that if we observe WQ_FLAG_WOKEN we must
 	 * also observe all state before the wakeup.
 	 */
-	if (!(wait->flags & WQ_FLAG_WOKEN))
-		timeout = schedule_timeout(timeout);
+	if (!(wait->flags & WQ_FLAG_WOKEN)) {
+		if (___wait_is_interruptible(mode)) {
+		       if (signal_pending_state(mode, current))
+			       timeout = -ERESTARTSYS;
+		       else
+			       timeout = schedule_timeout(timeout);
+		}
+	}
 	__set_current_state(TASK_RUNNING);
 
 	/*
