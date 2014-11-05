Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaKEW3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:29:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:39687 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaKEW3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:29:37 -0500
Date: Wed, 5 Nov 2014 23:29:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Juerg Haefliger <juergh@gmail.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>
Subject: Re: [ANNOUNCE] 3.14.23-rt20
In-Reply-To: <alpine.DEB.2.11.1411051703440.4245@nanos>
Message-ID: <alpine.DEB.2.11.1411052314150.24960@nanos>
References: <20141031170326.1491a63f@gandalf.local.home> <1414913427.5380.110.camel@marge.simpson.net> <CADLDEKvFvw7Aa98tVtM3z5JV8oocKqAdV4PqOMoZH2mXZ6x2jg@mail.gmail.com> <20141105092707.7c9bb1ae@gandalf.local.home>
 <alpine.DEB.2.11.1411051703440.4245@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014, Thomas Gleixner wrote:
> On Wed, 5 Nov 2014, Steven Rostedt wrote:
> > On Wed, 5 Nov 2014 14:50:41 +0100
> > Juerg Haefliger <juergh@gmail.com> wrote:
> > 
> > > On Sun, Nov 2, 2014 at 8:30 AM, Mike Galbraith <umgwanakikbuti@gmail.com>
> > > wrote:
> > > >
> > > > On Fri, 2014-10-31 at 17:03 -0400, Steven Rostedt wrote:
> > > > > Dear RT Folks,
> > > > >
> > > > > I'm pleased to announce the 3.14.23-rt20 stable release.
> > > > >
> > > > > This is the first 3.14-rt release in the stable-rt series. Normally I
> > > > > wait till the next development release is out before I pull in a new
> > > > > one. That is, I would pull in 3.14-rt when 3.16-rt or later was
> > > > > released. But because development is now moving at a "hobbyist rate"
> > > > > (read http://lwn.net/Articles/617140/ for details)
> > > > > and 3.14-rt is no longer being developed against, I figured it was
> > > > time
> > > > > to put it under the "stable-rt" umbrella.
> > > >
> > > > I piddled about with it yesterday, found that you can't change cpufreq
> > > > governor IFF the tree is configured as rt, but works fine as voluntary
> > > > preempt.
> > > 
> > > The problem seems to be this patch: https://lkml.org/lkml/2014/4/8/584
> > > 
> > > The cpufreq code does nested down_read_trylocks and only the first one
> > > succeeds:
> > > 
> > > drivers/cpufreq/cpufreq.c:
> > > store
> > >   down_read_trylock(cpufreq_rwsem)  <- succeeds
> > >   store_scaling_governor
> > >     cpufreq_get_policy
> > >       cpufreq_cpu_get
> > >         down_read_trylock(cpufreq_rwsem)  <-- fails
> > > 
> > > Reverting the above patch 'fixes' the problem. I don't understand Steven's
> > > commit comment that readers of rwsem are not allowed to nest in mainline
> > > since this works just fine in mainline.
> > 
> > When we allow multiple readers, this will be allowed. But even in
> > mainline, if a writer were to come in and block between those two
> > down_read_trylocks(), the second trylock would fail.
> > 
> > PREEMPT_RT just has that fail all the time as we only allow an rwsem to
> > be held by a single reader.
> 
> Errm. The reader holds the sem already. So that's a recursive read
> lock which should always succeed. And rt_read_trylock() has that
> implemented.

Bah. That's the rwlock path. Untested patch below should fix the issue.

Thanks,

	tglx

------------------------>

diff --git a/include/linux/rwsem_rt.h b/include/linux/rwsem_rt.h
index 0065b08fbb7a..924c2d274ab5 100644
--- a/include/linux/rwsem_rt.h
+++ b/include/linux/rwsem_rt.h
@@ -20,6 +20,7 @@
 
 struct rw_semaphore {
 	struct rt_mutex		lock;
+	int			read_depth;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
diff --git a/kernel/locking/rt.c b/kernel/locking/rt.c
index 90b8ba03e2a4..a48bff77e2a8 100644
--- a/kernel/locking/rt.c
+++ b/kernel/locking/rt.c
@@ -321,8 +321,11 @@ EXPORT_SYMBOL(rt_up_write);
 
 void  rt_up_read(struct rw_semaphore *rwsem)
 {
-	rwsem_release(&rwsem->dep_map, 1, _RET_IP_);
-	rt_mutex_unlock(&rwsem->lock);
+	/* Release the lock only when read_depth is down to 0 */
+	if (--rwsem->read_depth == 0) {
+		rwsem_release(&rwsem->dep_map, 1, _RET_IP_);
+		rt_mutex_unlock(&rwsem->lock);
+	}
 }
 EXPORT_SYMBOL(rt_up_read);
 
@@ -332,7 +335,9 @@ EXPORT_SYMBOL(rt_up_read);
  */
 void  rt_downgrade_write(struct rw_semaphore *rwsem)
 {
-	BUG_ON(rt_mutex_owner(&rwsem->lock) != current);
+	BUG_ON(rt_mutex_owner(&rwsem->lock) != current ||
+	       rwsem->read_depth != 0);
+	rwsem->read_depth++;
 }
 EXPORT_SYMBOL(rt_downgrade_write);
 
@@ -370,11 +375,21 @@ EXPORT_SYMBOL(rt_down_write_nested_lock);
 
 int  rt_down_read_trylock(struct rw_semaphore *rwsem)
 {
-	int ret;
+	int ret = 1;
+
+	/*
+	 * recursive read locks succeed when current owns the lock
+	 */
+	if (rt_mutex_owner(&rwsem->lock) != current) {
+		ret = rt_mutex_trylock(&rwsem->lock);
+		if (ret)
+			rwsem_acquire(&rwsem->dep_map, 0, 1, _RET_IP_);
+	} else if (!rwsem->read_depth) {
+		ret = 0;
+	}
 
-	ret = rt_mutex_trylock(&rwsem->lock);
 	if (ret)
-		rwsem_acquire(&rwsem->dep_map, 0, 1, _RET_IP_);
+		rwsem->read_depth++;
 
 	return ret;
 }
@@ -382,8 +397,14 @@ EXPORT_SYMBOL(rt_down_read_trylock);
 
 static void __rt_down_read(struct rw_semaphore *rwsem, int subclass)
 {
-	rwsem_acquire(&rwsem->dep_map, subclass, 0, _RET_IP_);
-	rt_mutex_lock(&rwsem->lock);
+	/*
+	 * recursive read locks succeed when current owns the lock
+	 */
+	if (rt_mutex_owner(&rwsem->lock) != current) {
+		rwsem_acquire(&rwsem->dep_map, subclass, 0, _RET_IP_);
+		rt_mutex_lock(&rwsem->lock);
+	}
+	rwsem->read_depth++;
 }
 
 void  rt_down_read(struct rw_semaphore *rwsem)
@@ -408,6 +429,7 @@ void  __rt_rwsem_init(struct rw_semaphore *rwsem, const char *name,
 	debug_check_no_locks_freed((void *)rwsem, sizeof(*rwsem));
 	lockdep_init_map(&rwsem->dep_map, name, key, 0);
 #endif
+	rwsem->read_depth = 0;
 	rwsem->lock.save_state = 0;
 }
 EXPORT_SYMBOL(__rt_rwsem_init);


