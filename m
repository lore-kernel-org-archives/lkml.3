Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaLOASe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 19:18:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38772 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaLOASa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 19:18:30 -0500
Date: Mon, 15 Dec 2014 00:18:13 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141215001813.GS22149@ZenIV.linux.org.uk>
References: <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
 <CA+55aFydeGFQs+HZkqC1ecyh=MxOow-hw817e1q4DUrAX7uqWw@mail.gmail.com>
 <CA+55aFzuRCJDWQcBBET6x1OHThLrtJmnn=hS40tE7hNXfmfm6g@mail.gmail.com>
 <20141213233508.GN22149@ZenIV.linux.org.uk>
 <CA+55aFw5pb7g+k1EOGj6t2xqibGGUBmZMuA_YAgtyejiv76omg@mail.gmail.com>
 <20141213234730.GP22149@ZenIV.linux.org.uk>
 <CA+55aFxZWPP+wCDbwB-n=z5z_8isqdJ_4Ka6+P+KaBAY4ihw1Q@mail.gmail.com>
 <20141214003332.GQ22149@ZenIV.linux.org.uk>
 <CA+55aFxdsYMuUzdEhGThdtDJA+f1jeKn-rEH+Zrxk5=-KnsSRw@mail.gmail.com>
 <20141214031429.GR22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141214031429.GR22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 03:14:29AM +0000, Al Viro wrote:
> On Sat, Dec 13, 2014 at 05:35:17PM -0800, Linus Torvalds wrote:
> > On Sat, Dec 13, 2014 at 4:33 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > So does SMP - this_cpu_dec() relies on preemption being disabled.
> > 
> > No. really. It very much does not. Not on x86, not elsewhere. It's
> > part of the whole point of "this_cpu_p()". They are preemption and
> > interrupt safe.
> > 
> > It's the "__this_cpu_op()" ones that need external protection.
> 
> Right you are - I really need to get some coffee...  Sorry...
> 
> FWIW, do we need to disable interrupts there?  After all, mnt_want_write()
> and mnt_drop_write() shouldn't be done from interrupt context - they can
> happen via schedule_delayed_work(), but that's it...

OK, having looked through the tree - we really don't need to bother with
disabling interrupts (fortunately - or UP case would be broken).  So how
about turning those into __this_cpu_{inc,dec} and yes, moving preempt
disabling into mnt_{inc,dec}_writers()?  Like this:

diff --git a/fs/namespace.c b/fs/namespace.c
index 5b66b2b..48cb162 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -274,20 +274,32 @@ EXPORT_SYMBOL_GPL(__mnt_is_readonly);
 
 static inline void mnt_inc_writers(struct mount *mnt)
 {
+	preempt_disable();
 #ifdef CONFIG_SMP
-	this_cpu_inc(mnt->mnt_pcp->mnt_writers);
+	__this_cpu_inc(mnt->mnt_pcp->mnt_writers);
 #else
 	mnt->mnt_writers++;
 #endif
+	preempt_enable();
 }
 
-static inline void mnt_dec_writers(struct mount *mnt)
+/**
+ * __mnt_drop_write - give up write access to a mount
+ * @mnt: the mount on which to give up write access
+ *
+ * Tells the low-level filesystem that we are done
+ * performing writes to it.  Must be matched with
+ * __mnt_want_write() call above.
+ */
+void __mnt_drop_write(struct vfsmount *m)
 {
+	preempt_disable();
 #ifdef CONFIG_SMP
-	this_cpu_dec(mnt->mnt_pcp->mnt_writers);
+	__this_cpu_dec(real_mount(m)->mnt_pcp->mnt_writers);
 #else
-	mnt->mnt_writers--;
+	real_mount(m)->mnt_writers--;
 #endif
+	preempt_enable();
 }
 
 static unsigned int mnt_get_writers(struct mount *mnt)
@@ -336,7 +348,6 @@ int __mnt_want_write(struct vfsmount *m)
 	struct mount *mnt = real_mount(m);
 	int ret = 0;
 
-	preempt_disable();
 	mnt_inc_writers(mnt);
 	/*
 	 * The store to mnt_inc_writers must be visible before we pass
@@ -353,10 +364,9 @@ int __mnt_want_write(struct vfsmount *m)
 	 */
 	smp_rmb();
 	if (mnt_is_readonly(m)) {
-		mnt_dec_writers(mnt);
+		__mnt_drop_write(m);
 		ret = -EROFS;
 	}
-	preempt_enable();
 
 	return ret;
 }
@@ -399,9 +409,7 @@ int mnt_clone_write(struct vfsmount *mnt)
 	/* superblock may be r/o */
 	if (__mnt_is_readonly(mnt))
 		return -EROFS;
-	preempt_disable();
 	mnt_inc_writers(real_mount(mnt));
-	preempt_enable();
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mnt_clone_write);
@@ -441,21 +449,6 @@ int mnt_want_write_file(struct file *file)
 EXPORT_SYMBOL_GPL(mnt_want_write_file);
 
 /**
- * __mnt_drop_write - give up write access to a mount
- * @mnt: the mount on which to give up write access
- *
- * Tells the low-level filesystem that we are done
- * performing writes to it.  Must be matched with
- * __mnt_want_write() call above.
- */
-void __mnt_drop_write(struct vfsmount *mnt)
-{
-	preempt_disable();
-	mnt_dec_writers(real_mount(mnt));
-	preempt_enable();
-}
-
-/**
  * mnt_drop_write - give up write access to a mount
  * @mnt: the mount on which to give up write access
  *
