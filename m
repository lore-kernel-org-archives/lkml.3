Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161102AbaDJRPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:15:19 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:35174 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161061AbaDJRPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:15:12 -0400
Message-ID: <1397150084.3032.4.camel@j-VirtualBox>
Subject: Re: 3.14.0+/x86: lockdep and mutexes not getting along
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Michael L. Semon" <mlsemon35@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Thu, 10 Apr 2014 10:14:44 -0700
In-Reply-To: <20140410091824.GL10526@twins.programming.kicks-ass.net>
References: <alpine.LNX.2.11.1404060059020.8208@bpserver.ds>
	 <20140409121940.GA12890@node.dhcp.inet.fi>
	 <1397108579.2586.15.camel@j-VirtualBox>
	 <20140410091824.GL10526@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-10 at 11:18 +0200, Peter Zijlstra wrote:
> On Wed, Apr 09, 2014 at 10:42:59PM -0700, Jason Low wrote:
> > As a starting point, would either of you like to test the following
> > patch to see if it fixes the issue? This patch essentially generates the
> > same code as in older kernels in the debug case. This applies on top of
> > kernels with both commits 6f008e72cd11 and 1d8fe7dc8078.
> 
> 
> So I managed to reproduce, and the below makes it go away. I just don't
> understand why though. will stare more.

So one thing I noticed that is different in the current code is that in
debug_mutex_unlock(), there is is a possibility that it does not unlock
the mutex (when !debug_locks). May be interesting to try out this
patch too:

-----
diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index e1191c9..97f8df0 100644
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -72,7 +72,7 @@ void mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 void debug_mutex_unlock(struct mutex *lock)
 {
 	if (unlikely(!debug_locks))
-		return;
+		goto out;
 
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
 
@@ -84,6 +84,7 @@ void debug_mutex_unlock(struct mutex *lock)
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	mutex_clear_owner(lock);
 
+out:
 	/*
 	 * __mutex_slowpath_needs_to_unlock() is explicitly 0 for debug
 	 * mutexes so that we can do it here after we've verified state.


