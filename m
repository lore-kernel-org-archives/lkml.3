Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935721AbaDJSvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:51:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54835 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935690AbaDJSvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:51:45 -0400
Date: Thu, 10 Apr 2014 16:15:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Michael L. Semon" <mlsemon35@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: 3.14.0+/x86: lockdep and mutexes not getting along
Message-ID: <20140410141559.GE13658@twins.programming.kicks-ass.net>
References: <alpine.LNX.2.11.1404060059020.8208@bpserver.ds>
 <20140409121940.GA12890@node.dhcp.inet.fi>
 <1397108579.2586.15.camel@j-VirtualBox>
 <20140410091824.GL10526@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410091824.GL10526@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 11:18:24AM +0200, Peter Zijlstra wrote:
> So I managed to reproduce, and the below makes it go away. I just don't
> understand why though. will stare more.

/me kicks himself.. bloody obvious fail there :-)

Not unlocking the lock after a lockdep trigger will make things get
stuck real fast :-)

---
 kernel/locking/mutex-debug.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index e1191c996c59..5cf6731b98e9 100644
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -71,18 +71,17 @@ void mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 
 void debug_mutex_unlock(struct mutex *lock)
 {
-	if (unlikely(!debug_locks))
-		return;
+	if (likely(debug_locks)) {
+		DEBUG_LOCKS_WARN_ON(lock->magic != lock);
 
-	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
+		if (!lock->owner)
+			DEBUG_LOCKS_WARN_ON(!lock->owner);
+		else
+			DEBUG_LOCKS_WARN_ON(lock->owner != current);
 
-	if (!lock->owner)
-		DEBUG_LOCKS_WARN_ON(!lock->owner);
-	else
-		DEBUG_LOCKS_WARN_ON(lock->owner != current);
-
-	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
-	mutex_clear_owner(lock);
+		DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
+		mutex_clear_owner(lock);
+	}
 
 	/*
 	 * __mutex_slowpath_needs_to_unlock() is explicitly 0 for debug
