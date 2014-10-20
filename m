Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaJTKti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:49:38 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45869 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaJTKth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:49:37 -0400
Date: Mon, 20 Oct 2014 11:49:26 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matteo Franchin <Matteo.Franchin@arm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH] futex: Ensure get_futex_key_refs() always implies a
 barrier
Message-ID: <20141020104926.GD23751@e104818-lin.cambridge.arm.com>
References: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>
 <1413617580.29249.9.camel@linux-t7sj.site>
 <1413662314.17869.11.camel@linux-t7sj.site>
 <CA+55aFzmsF4F-SOO4OzZDbreaQ4X4RUCQksv_ONu59BbyZ8Ocg@mail.gmail.com>
 <1413684978.17869.18.camel@linux-t7sj.site>
 <alpine.DEB.2.11.1410201106260.4121@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410201106260.4121@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:11:40AM +0100, Thomas Gleixner wrote:
> On Sat, 18 Oct 2014, Davidlohr Bueso wrote:
> > On Sat, 2014-10-18 at 13:50 -0700, Linus Torvalds wrote:
> > > On Sat, Oct 18, 2014 at 12:58 PM, Davidlohr Bueso <dave@stgolabs.net> wrote:
> > > >
> > > > And [get/put]_futex_keys() shouldn't even be called for private futexes.
> > > > The following patch had some very minor testing on a 60 core box last
> > > > night, but passes both Darren's and perf's tests. So I *think* this is
> > > > right, but lack of sleep and I overall just don't trust them futexes!
> > > 
> > > Hmm. I don't see the advantage of making the code more complex in
> > > order to avoid the functions that are no-ops for the !fshared case?
> > > 
> > > IOW, as far as I can tell, this patch doesn't actually really *change*
> > > anything. Am I missing something?
> > 
> > Right, all we do is avoid a NOP, but I don't see how this patch makes
> > the code more complex. In fact, the whole idea is to make it easier to
> > read and makes the key referencing differences between shared and
> > private futexes crystal clear, hoping to mitigate future bugs. 
> 
> I tend to disagree. The current code is symetric versus get/drop and
> you make it unsymetric by avoiding the drop call with a pointless
> extra conditional in all call sites.

Since you mention symmetry, something like below makes the barriers more
explicit. However, it removes the implied barrier for get_futex_key_refs
and the other calling places need to be verified (requeue_futex and
requeue_pi_futex; if barrier is not required here, the result may be
slightly more optimal, not sure you would see the difference though).


diff --git a/kernel/futex.c b/kernel/futex.c
index f3a3a071283c..5b9d857d0816 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -143,9 +143,7 @@
  *
  * Where (A) orders the waiters increment and the futex value read through
  * atomic operations (see hb_waiters_inc) and where (B) orders the write
- * to futex and the waiters read -- this is done by the barriers in
- * get_futex_key_refs(), through either ihold or atomic_inc, depending on the
- * futex type.
+ * to futex and the waiters read (see hb_waiters_pending).
  *
  * This yields the following case (where X:=waiters, Y:=futex):
  *
@@ -262,12 +260,6 @@ static struct futex_hash_bucket *futex_queues;
 static inline void futex_get_mm(union futex_key *key)
 {
 	atomic_inc(&key->private.mm->mm_count);
-	/*
-	 * Ensure futex_get_mm() implies a full barrier such that
-	 * get_futex_key() implies a full barrier. This is relied upon
-	 * as full barrier (B), see the ordering comment above.
-	 */
-	smp_mb__after_atomic();
 }
 
 /*
@@ -297,6 +289,10 @@ static inline void hb_waiters_dec(struct futex_hash_bucket *hb)
 
 static inline int hb_waiters_pending(struct futex_hash_bucket *hb)
 {
+	/*
+	 * Full barrier (B), see the ordering comment above.
+	 */
+	smp_mb__before_atomic();
 #ifdef CONFIG_SMP
 	return atomic_read(&hb->waiters);
 #else
@@ -338,13 +334,11 @@ static void get_futex_key_refs(union futex_key *key)
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
-		ihold(key->shared.inode); /* implies MB (B) */
+		__iget(key->shared.inode);
 		break;
 	case FUT_OFF_MMSHARED:
-		futex_get_mm(key); /* implies MB (B) */
+		futex_get_mm(key);
 		break;
-	default:
-		smp_mb(); /* explicit MB (B) */
 	}
 }
 
@@ -417,7 +411,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 	if (!fshared) {
 		key->private.mm = mm;
 		key->private.address = address;
-		get_futex_key_refs(key);  /* implies MB (B) */
+		get_futex_key_refs(key);
 		return 0;
 	}
 
@@ -524,7 +518,7 @@ again:
 		key->shared.pgoff = basepage_index(page);
 	}
 
-	get_futex_key_refs(key); /* implies MB (B) */
+	get_futex_key_refs(key);
 
 out:
 	unlock_page(page_head);
