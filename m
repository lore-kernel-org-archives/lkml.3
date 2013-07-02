Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3GBCHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 22:07:50 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:12502 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755449Ab3GBCHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 22:07:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At4LAA400lF5LCeA/2dsb2JhbABagwmDGbgAhSgEAX0XdIIjAQEEAScTHCgLCAMVAwklDwUlAyEBEogJBbtYFo4EHAuBJIMEYwOXR5FGgyMqgSw
Date: Tue, 2 Jul 2013 12:07:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>,
        axboe@kernel.dk
Subject: Re: block layer softlockup
Message-ID: <20130702020741.GE4072@dastard>
References: <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627143055.GA1000@redhat.com>
 <20130628011843.GD32195@dastard>
 <CA+55aFze-=6e_P1syCs=3b6-xj-itVyZKvpejqBR83gA5tV+4w@mail.gmail.com>
 <20130628035437.GB29338@dastard>
 <20130701175734.GA13641@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701175734.GA13641@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 01:57:34PM -0400, Dave Jones wrote:
> On Fri, Jun 28, 2013 at 01:54:37PM +1000, Dave Chinner wrote:
>  > On Thu, Jun 27, 2013 at 04:54:53PM -1000, Linus Torvalds wrote:
>  > > On Thu, Jun 27, 2013 at 3:18 PM, Dave Chinner <david@fromorbit.com> wrote:
>  > > >
>  > > > Right, that will be what is happening - the entire system will go
>  > > > unresponsive when a sync call happens, so it's entirely possible
>  > > > to see the soft lockups on inode_sb_list_add()/inode_sb_list_del()
>  > > > trying to get the lock because of the way ticket spinlocks work...
>  > > 
>  > > So what made it all start happening now? I don't recall us having had
>  > > these kinds of issues before..
>  > 
>  > Not sure - it's a sudden surprise for me, too. Then again, I haven't
>  > been looking at sync from a performance or lock contention point of
>  > view any time recently.  The algorithm that wait_sb_inodes() is
>  > effectively unchanged since at least 2009, so it's probably a case
>  > of it having been protected from contention by some external factor
>  > we've fixed/removed recently.  Perhaps the bdi-flusher thread
>  > replacement in -rc1 has changed the timing sufficiently that it no
>  > longer serialises concurrent sync calls as much....
> 
> This mornings new trace reminded me of this last sentence. Related ?

Was this running the last patch I posted, or a vanilla kernel?

> BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child1:7219]
....
> CPU: 0 PID: 7219 Comm: trinity-child1 Not tainted 3.10.0+ #38
.....
> RIP: 0010:[<ffffffff816ed037>]  [<ffffffff816ed037>] _raw_spin_unlock_irqrestore+0x67/0x80
.....
>  <IRQ> 
> 
>  [<ffffffff812da4c1>] blk_end_bidi_request+0x51/0x60
>  [<ffffffff812da4e0>] blk_end_request+0x10/0x20
>  [<ffffffff8149ba13>] scsi_io_completion+0xf3/0x6e0
>  [<ffffffff81491a60>] scsi_finish_command+0xb0/0x110
>  [<ffffffff8149b81f>] scsi_softirq_done+0x12f/0x160
>  [<ffffffff812e1e08>] blk_done_softirq+0x88/0xa0
>  [<ffffffff8105424f>] __do_softirq+0xff/0x440
>  [<ffffffff8105474d>] irq_exit+0xcd/0xe0
>  [<ffffffff816f760b>] smp_apic_timer_interrupt+0x6b/0x9b
>  [<ffffffff816f676f>] apic_timer_interrupt+0x6f/0x80
>  <EOI> 

That's doing IO completion processing in softirq time, and the lock
it just dropped was the q->queue_lock. But that lock is held over
end IO processing, so it is possible that the way the page writeback
transition handling of my POC patch caused this.

FWIW, I've attached a simple patch you might like to try to see if
it *minimises* the inode_sb_list_lock contention problems. All it
does is try to prevent concurrent entry in wait_sb_inodes() for a
given superblock and hence only have one walker on the contending
filesystem at a time. Replace the previous one I sent with it. If
that doesn't work, I have another simple patch that makes the
inode_sb_list_lock per-sb to take this isolation even further....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

sync: serialise per-superblock sync operations

From: Dave Chinner <dchinner@redhat.com>

When competing sync(2) calls walk the same filesystem, they need to
walk the list of inodes on the superblock to find all the inodes
that we need to wait for IO completion on. However, when multiple
wait_sb_inodes() calls do this at the same time, they contend on the
the inode_sb_list_lock and the contention causes system wide
slowdowns. In effect, concurrent sync(2) calls the take longer and
burn more CPU than if they were serialised.

Stop the worst of the contention by adding a per-sb mutex to wrap
around sync_inodes_sb() so that we only execute one sync(2)
operation at a time per superblock and hence mostly avoid
contention.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c  |    9 ++++++++-
 fs/super.c         |    1 +
 include/linux/fs.h |    2 ++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 996f91a..4d7a90c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1353,7 +1353,12 @@ EXPORT_SYMBOL(try_to_writeback_inodes_sb);
  * @sb: the superblock
  *
  * This function writes and waits on any dirty inode belonging to this
- * super_block.
+ * super_block. The @s_sync_lock is used to serialise concurrent sync operations
+ * to avoid lock contention problems with concurrent wait_sb_inodes() calls.
+ * This also allows us to optimise wait_sb_inodes() to use private dirty lists
+ * as subsequent sync calls will block waiting for @s_sync_lock and hence always
+ * wait for the inodes in the private sync lists to be completed before they do
+ * their own private wait.
  */
 void sync_inodes_sb(struct super_block *sb)
 {
@@ -1372,10 +1377,12 @@ void sync_inodes_sb(struct super_block *sb)
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
+	mutex_lock(&sb->s_sync_lock);
 	bdi_queue_work(sb->s_bdi, &work);
 	wait_for_completion(&done);
 
 	wait_sb_inodes(sb);
+	mutex_unlock(&sb->s_sync_lock);
 }
 EXPORT_SYMBOL(sync_inodes_sb);
 
diff --git a/fs/super.c b/fs/super.c
index 7465d43..887bfbe 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -181,6 +181,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 		INIT_HLIST_NODE(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
+		mutex_init(&s->s_sync_lock);
 		INIT_LIST_HEAD(&s->s_dentry_lru);
 		INIT_LIST_HEAD(&s->s_inode_lru);
 		spin_lock_init(&s->s_inode_lru_lock);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 41f0945..74ba328 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1257,6 +1257,8 @@ struct super_block {
 	const struct xattr_handler **s_xattr;
 
 	struct list_head	s_inodes;	/* all inodes */
+	struct mutex		s_sync_lock;	/* sync serialisation lock */
+
 	struct hlist_bl_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 #ifdef CONFIG_SMP
 	struct list_head __percpu *s_files;
