Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaFDPoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:44:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:16381 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752293AbaFDPoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:44:13 -0400
Date: Wed, 4 Jun 2014 11:44:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Brad Mouring <bmouring@ni.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 1/1] rtmutex: Handle when top lock owner changes
Message-ID: <20140604114411.0fe51c1d@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1406041623170.3319@nanos>
References: <1400855410-14773-1-git-send-email-brad.mouring@ni.com>
	<1400855410-14773-2-git-send-email-brad.mouring@ni.com>
	<20140603210609.62de6451@gandalf.local.home>
	<alpine.DEB.2.10.1406041623170.3319@nanos>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014 17:32:37 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> T3 releases L3
> T2 gets L3
> T2 drops L3 and L2
> T2 blocks on L4 held by T4
> T4 blocked on L5 held by T5
> 
> So we happily boost T4 and T5. Not what we really want to do.
> 
> Nasty, isn't it ?
> 

Actually, we may go up a chain, but we never do any unnecessary
boosting. That's because the boost is done with rt_mutex_adjust_prio()
which gets the prio from rt_mutex_getprio() which reads the
task->normal_prio and compares it to the task_top_pi_waiter(task)->prio,
which will always be correct as we have the necessary locks.

And we don't even need to worry about the chain we miss. That is, if
task A is blocked on a lock owned by D at the time, but as we go up the
chain, D releases the lock and B grabs it, B will still up its priority
based on the waiters of the lock (that is A), and if B blocks, it will
boost the tasks that own the lock it blocks on, where B is still
influenced by A.

The fact that we only update the prio based on the actual waiters and
don't carry a prio up the chain (which you designed, and I thought was
quite ingenious by the way), we may waste time going up a chain, but
the priority inheritance is still accurate.

-- Steve
