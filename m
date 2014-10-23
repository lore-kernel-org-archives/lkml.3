Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbaJWT4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:56:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932240AbaJWT4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:56:52 -0400
Date: Thu, 23 Oct 2014 21:53:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        htejun@gmail.com
Subject: Re: rcu_preempt detected stalls.
Message-ID: <20141023195337.GA7768@redhat.com>
References: <20141013173504.GA27955@redhat.com> <20141023183232.GW4977@linux.vnet.ibm.com> <20141023191319.GA5137@redhat.com> <20141023193807.GZ4977@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023193807.GZ4977@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23, Paul E. McKenney wrote:
>
> OK, so making each pass through the loop a separate RCU read-side critical
> section might be considered to be suppressing notification of an error
> condition?

I agree, this change probably makes sense anyway. Personally I'd prefer
the version below (somehow I hate multiple unlock's), but I won't insist.

Oleg.

--- x/kernel/signal.c
+++ x/kernel/signal.c
@@ -1331,21 +1331,19 @@ int kill_pid_info(int sig, struct siginf
 	int error = -ESRCH;
 	struct task_struct *p;
 
-	rcu_read_lock();
 retry:
+	rcu_read_lock();
 	p = pid_task(pid, PIDTYPE_PID);
-	if (p) {
+	if (p)
 		error = group_send_sig_info(sig, info, p);
-		if (unlikely(error == -ESRCH))
-			/*
-			 * The task was unhashed in between, try again.
-			 * If it is dead, pid_task() will return NULL,
-			 * if we race with de_thread() it will find the
-			 * new leader.
-			 */
-			goto retry;
-	}
 	rcu_read_unlock();
+	/*
+	 * The task was unhashed in between, try again. If it is dead,
+	 * pid_task() will return NULL, if we race with de_thread() it
+	 * will find the new leader.
+	 */
+	if (p && error == -ESRCH))
+		goto retry;
 
 	return error;
 }

