Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbaJWU2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 16:28:40 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:32928 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932747AbaJWU2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 16:28:37 -0400
Date: Thu, 23 Oct 2014 13:24:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        htejun@gmail.com
Subject: Re: rcu_preempt detected stalls.
Message-ID: <20141023202443.GE4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141013173504.GA27955@redhat.com>
 <20141023183232.GW4977@linux.vnet.ibm.com>
 <20141023191319.GA5137@redhat.com>
 <20141023193807.GZ4977@linux.vnet.ibm.com>
 <20141023195337.GA7768@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023195337.GA7768@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102320-0029-0000-0000-000000DC85D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 09:53:37PM +0200, Oleg Nesterov wrote:
> On 10/23, Paul E. McKenney wrote:
> >
> > OK, so making each pass through the loop a separate RCU read-side critical
> > section might be considered to be suppressing notification of an error
> > condition?
> 
> I agree, this change probably makes sense anyway. Personally I'd prefer
> the version below (somehow I hate multiple unlock's), but I won't insist.

Your code, your rules.  ;-)

But given this structure, why not use a for() loop replace the
"goto retry" with an inverted condition and a "return error"?
Maybe something like the following patch?

							Thanx, Paul

------------------------------------------------------------------------

signal: Exit RCU read-side critical section on each pass through loop

The kill_pid_info() can potentially loop indefinitely if tasks are created
and deleted sufficiently quickly, and if this happens, this function
will remain in a single RCU read-side critical section indefinitely.
This commit therefore exits the RCU read-side critical section on each
pass through the loop.  Because a race must happen to retry the loop,
this should have no performance impact in the common case.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>

diff --git a/kernel/signal.c b/kernel/signal.c
index 8f0876f9f6dd..54820984a872 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1331,23 +1331,21 @@ int kill_pid_info(int sig, struct siginfo *info, struct pid *pid)
 	int error = -ESRCH;
 	struct task_struct *p;
 
-	rcu_read_lock();
-retry:
-	p = pid_task(pid, PIDTYPE_PID);
-	if (p) {
-		error = group_send_sig_info(sig, info, p);
-		if (unlikely(error == -ESRCH))
-			/*
-			 * The task was unhashed in between, try again.
-			 * If it is dead, pid_task() will return NULL,
-			 * if we race with de_thread() it will find the
-			 * new leader.
-			 */
-			goto retry;
-	}
-	rcu_read_unlock();
+	for (;;) {
+		rcu_read_lock();
+		p = pid_task(pid, PIDTYPE_PID);
+		if (p)
+			error = group_send_sig_info(sig, info, p);
+		rcu_read_unlock();
+		if (likely(!p || error != -ESRCH))
+			return error;
 
-	return error;
+		/*
+		 * The task was unhashed in between, try again.  If it
+		 * is dead, pid_task() will return NULL, if we race with
+		 * de_thread() it will find the new leader.
+		 */
+	}
 }
 
 int kill_proc_info(int sig, struct siginfo *info, pid_t pid)

