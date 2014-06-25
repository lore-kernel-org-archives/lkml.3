Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbaFYPYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:24:47 -0400
Received: from kanga.kvack.org ([205.233.56.17]:44546 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203AbaFYPYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:24:46 -0400
Date: Wed, 25 Jun 2014 11:24:45 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Kent Overstreet <kmo@daterainc.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, RT <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH V2] rt/aio: fix rcu garbage collection might_sleep() splat
Message-ID: <20140625152445.GS23137@kvack.org>
References: <1402216538.31630.7.camel@marge.simpson.net> <5395172E.4010007@cn.fujitsu.com> <1402372048.5124.20.camel@marge.simpson.net> <20140610175001.GF27015@kvack.org> <20140612202602.GI10871@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612202602.GI10871@kmo-pixel>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 01:26:02PM -0700, Kent Overstreet wrote:
> On Tue, Jun 10, 2014 at 01:50:01PM -0400, Benjamin LaHaise wrote:
> > On Tue, Jun 10, 2014 at 05:47:28AM +0200, Mike Galbraith wrote:
> > > On Mon, 2014-06-09 at 10:08 +0800, Lai Jiangshan wrote: 
> > > > Hi, rt-people
> > > > 
> > > > I don't think it is the correct direction.
> > > > Softirq (including local_bh_disable()) in RT kernel should be preemptible.
> > > 
> > > How about the below then?
> > > 
> > > I was sorely tempted to post a tiny variant that dropped taking ctx_lock
> > > in free_ioctx_users() entirely, as someone diddling with no reference
> > > didn't make sense.  Cc Ben, he would know.
> > 
> > That should be okay...  Let's ask Kent to chime in on whether this looks 
> > safe to him on the percpu ref front as well, since he's the one who wrote 
> > this code.
> 
> Ok, finally got around to reading the whole thread - honestly, I would just punt
> to workqueue to do the free_ioctx_users(). AFAICT that should be perfectly safe
> and even aside from rt it would be good change so we're not cancelling an
> arbitrary number of kiocbs from rcu callback context.

I finally have some time to look at this patch in detail.  I'd rather do the 
below variant that does what Kent suggested.  Mike, can you confirm that 
this fixes the issue you reported?  It's on top of my current aio-next tree 
at git://git.kvack.org/~bcrl/aio-next.git .  If that's okay, I'll queue it 
up.  Does this bug fix need to end up in -stable kernels as well or would it 
end up in the -rt tree?

> Kind of a related change, it should be possible to just grab the entire list of
> kiocbs with ctx_lock held (remove them all at once from ctx->active_reqs), then
> cancel them without ctx_lock held.

No, that is not safe.  Cancellation has to be done under ctx_lock.

		-ben
-- 
"Thought is the essence of where you are now."


diff --git a/fs/aio.c b/fs/aio.c
index c1d8c48..0b038f2 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -526,9 +526,9 @@ static void free_ioctx_reqs(struct percpu_ref *ref)
  * and ctx->users has dropped to 0, so we know no more kiocbs can be submitted -
  * now it's safe to cancel any that need to be.
  */
-static void free_ioctx_users(struct percpu_ref *ref)
+static void free_ioctx_users_work(struct work_struct *work)
 {
-	struct kioctx *ctx = container_of(ref, struct kioctx, users);
+	struct kioctx *ctx = container_of(work, struct kioctx, free_work);
 	struct kiocb *req;
 
 	spin_lock_irq(&ctx->ctx_lock);
@@ -547,6 +547,18 @@ static void free_ioctx_users(struct percpu_ref *ref)
 	percpu_ref_put(&ctx->reqs);
 }
 
+static void free_ioctx_users(struct percpu_ref *ref)
+{
+	struct kioctx *ctx = container_of(ref, struct kioctx, users);
+#ifdef CONFIG_PREEMPT_RT_BAS
+	INIT_WORK(&ctx->free_work, free_ioctx_users_work);
+	schedule_work(&ctx->free_work);
+#else
+	free_ioctx_users_work(&ctx->free_work);
+#endif
+}
+
+
 static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 {
 	unsigned i, new_nr;
