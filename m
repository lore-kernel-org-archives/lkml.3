Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaBBVBa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:01:30 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:30436 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaBBVB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:01:29 -0500
Message-ID: <1391374883.3164.8.camel@j-VirtualBox>
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, chegu_vinod@hp.com
Date: Sun, 02 Feb 2014 13:01:23 -0800
In-Reply-To: <20140131200825.GS5002@laptop.programming.kicks-ass.net>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
	 <1390936396-3962-6-git-send-email-jason.low2@hp.com>
	 <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
	 <1390949495.2807.52.camel@j-VirtualBox>
	 <20140129115142.GE9636@twins.programming.kicks-ass.net>
	 <1391138977.6284.82.camel@j-VirtualBox>
	 <20140131140941.GF4941@twins.programming.kicks-ass.net>
	 <CAGQ1y=72+N4=yjVpjsTKjr-8xSQRS2xw4gcOGOipLgwPwgnA7A@mail.gmail.com>
	 <20140131200825.GS5002@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-31 at 21:08 +0100, Peter Zijlstra wrote:
> On Fri, Jan 31, 2014 at 12:01:37PM -0800, Jason Low wrote:
> > Currently still getting soft lockups with the updated version.
> 
> Bugger.. ok clearly I need to think harder still. I'm fairly sure this
> cancelation can work though, just seems tricky to get right :-)

Ok, I believe I have found a race condition between m_spin_lock() and
m_spin_unlock().

In m_spin_unlock(), we do "next = ACCESS_ONCE(node->next)". Then, if
next is not NULL, we proceed to set next->locked to 1.

A thread in m_spin_lock() in the unqueue path could execute
"next = cmpxchg(&prev->next, node, NULL)" after the thread in
m_spin_unlock() accesses its node->next and finds that it is not NULL.
Then, the thread in m_spin_lock() could check !node->locked before
the thread in m_spin_unlock() sets next->locked to 1.

The following addition change was able to solve the initial lockups that were
occurring when running fserver on a 2 socket box.

---
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 9eb4dbe..e71a84a 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -513,8 +513,13 @@ static void m_spin_unlock(struct m_spinlock **lock)
 			return;
 
 		next = ACCESS_ONCE(node->next);
-		if (unlikely(next))
-			break;
+
+		if (unlikely(next)) {
+			next = cmpxchg(&node->next, next, NULL);
+
+			if (next)
+				break;
+		}
 
 		arch_mutex_cpu_relax();
 	}


