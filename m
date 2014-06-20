Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351AbaFTPk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:40:26 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34160 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbaFTPkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:40:21 -0400
Date: Fri, 20 Jun 2014 08:40:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@gentwo.org>, Sasha Levin <sasha.levin@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: slub/debugobjects: lockup when freeing memory
Message-ID: <20140620154014.GC4904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <53A2F406.4010109@oracle.com>
 <alpine.DEB.2.11.1406191001090.2785@gentwo.org>
 <20140619165247.GA4904@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1406192127100.5170@nanos>
 <20140619202928.GG4904@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1406192230390.5170@nanos>
 <20140619205307.GL4904@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1406192331250.5170@nanos>
 <20140619220449.GT4904@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1406201015440.5170@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406201015440.5170@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062015-6688-0000-0000-000002B3E1AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:17:32AM +0200, Thomas Gleixner wrote:
> On Thu, 19 Jun 2014, Paul E. McKenney wrote:
> > On Thu, Jun 19, 2014 at 11:32:41PM +0200, Thomas Gleixner wrote:
> > > 
> > > 
> > > On Thu, 19 Jun 2014, Paul E. McKenney wrote:
> > > 
> > > > On Thu, Jun 19, 2014 at 10:37:17PM +0200, Thomas Gleixner wrote:
> > > > > On Thu, 19 Jun 2014, Paul E. McKenney wrote:
> > > > > > On Thu, Jun 19, 2014 at 09:29:08PM +0200, Thomas Gleixner wrote:
> > > > > > > On Thu, 19 Jun 2014, Paul E. McKenney wrote:
> > > > > > > Well, no. Look at the callchain:
> > > > > > > 
> > > > > > > __call_rcu
> > > > > > >     debug_object_activate
> > > > > > >        rcuhead_fixup_activate
> > > > > > >           debug_object_init
> > > > > > >               kmem_cache_alloc
> > > > > > > 
> > > > > > > So call rcu activates the object, but the object has no reference in
> > > > > > > the debug objects code so the fixup code is called which inits the
> > > > > > > object and allocates a reference ....
> > > > > > 
> > > > > > OK, got it.  And you are right, call_rcu() has done this for a very
> > > > > > long time, so not sure what changed.  But it seems like the right
> > > > > > approach is to provide a debug-object-free call_rcu_alloc() for use
> > > > > > by the memory allocators.
> > > > > > 
> > > > > > Seem reasonable?  If so, please see the following patch.
> > > > > 
> > > > > Not really, you're torpedoing the whole purpose of debugobjects :)
> > > > > 
> > > > > So, why can't we just init the rcu head when the stuff is created?
> > > > 
> > > > That would allow me to keep my code unchanged, so I am in favor.  ;-)
> > > 
> > > Almost unchanged. You need to provide a function to do so, i.e. make
> > > use of
> > > 
> > >     debug_init_rcu_head()
> > 
> > You mean like this?
> 
> I'd rather name it init_rcu_head() and free_rcu_head() w/o the debug_
> prefix, so it's consistent with init_rcu_head_on_stack /
> destroy_rcu_head_on_stack. But either way works for me.
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

So just drop the _on_stack() from the other names, then.  Please see
below.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Export debug_init_rcu_head() and and debug_init_rcu_head()

Currently, call_rcu() relies on implicit allocation and initialization
for the debug-objects handling of RCU callbacks.  If you hammer the
kernel hard enough with Sasha's modified version of trinity, you can end
up with the sl*b allocators recursing into themselves via this implicit
call_rcu() allocation.

This commit therefore exports the debug_init_rcu_head() and
debug_rcu_head_free() functions, which permits the allocators to allocated
and pre-initialize the debug-objects information, so that there no longer
any need for call_rcu() to do that initialization, which in turn prevents
the recursion into the memory allocators.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 063a6bf1a2b6..37c92cfef9ec 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -358,9 +358,19 @@ void wait_rcu_gp(call_rcu_func_t crf);
  * initialization.
  */
 #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+void init_rcu_head(struct rcu_head *head);
+void destroy_rcu_head(struct rcu_head *head);
 void init_rcu_head_on_stack(struct rcu_head *head);
 void destroy_rcu_head_on_stack(struct rcu_head *head);
 #else /* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+static inline void init_rcu_head(struct rcu_head *head)
+{
+}
+
+static inline void destroy_rcu_head(struct rcu_head *head)
+{
+}
+
 static inline void init_rcu_head_on_stack(struct rcu_head *head)
 {
 }
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index a2aeb4df0f60..0fb691e63ce6 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -200,12 +200,12 @@ void wait_rcu_gp(call_rcu_func_t crf)
 EXPORT_SYMBOL_GPL(wait_rcu_gp);
 
 #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
-static inline void debug_init_rcu_head(struct rcu_head *head)
+void init_rcu_head(struct rcu_head *head)
 {
 	debug_object_init(head, &rcuhead_debug_descr);
 }
 
-static inline void debug_rcu_head_free(struct rcu_head *head)
+void destroy_rcu_head(struct rcu_head *head)
 {
 	debug_object_free(head, &rcuhead_debug_descr);
 }

