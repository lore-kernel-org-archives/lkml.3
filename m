Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab3I3Log (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:44:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39357 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab3I3Loe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:44:34 -0400
Date: Mon, 30 Sep 2013 13:44:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH, v2] anon_vmas: Convert the rwsem to an rwlock_t
Message-ID: <20130930114406.GZ3081@twins.programming.kicks-ass.net>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
 <20130928074144.GA17773@gmail.com>
 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
 <20130928192123.GA8228@gmail.com>
 <20130928193739.GA8642@gmail.com>
 <CA+55aFyMXxH-PGewqxse=VJzMdHWkyN4iKMh-VgQ1X2yJFnAgw@mail.gmail.com>
 <20130928195207.GA31245@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928195207.GA31245@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 09:52:07PM +0200, Ingo Molnar wrote:
> Index: tip/mm/mmap.c
> ===================================================================
> --- tip.orig/mm/mmap.c
> +++ tip/mm/mmap.c
> @@ -2955,15 +2955,15 @@ static void vm_lock_anon_vma(struct mm_s
>  		 * The LSB of head.next can't change from under us
>  		 * because we hold the mm_all_locks_mutex.
>  		 */
> -		down_write_nest_lock(&anon_vma->root->rwsem, &mm->mmap_sem);
> +		write_lock(&anon_vma->root->rwlock);

Tssk, you should know better...

But yes; this is the most horrid site; however I think it was mostly
file based VMAs that caused the immense amount of locks taken since this
is only done 'very' early on in the life of KVM.

I can't remember how early; I hope almost instantly and certainly before
spawning all the various vcpu threads as that would create all the
thread stacks which are anon and would indeed blow up the non-preempt
time here.

So if we keep i_mmap_mutex -- and I hope we do; that unmap_mutex horror
wasn't pretty at all -- see commit 97a894136 . The below shouldn't be
too bad I think/hope.


---
--- a/include/linux/rwlock.h
+++ b/include/linux/rwlock.h
@@ -64,6 +64,19 @@ do {								\
 #define write_lock(lock)	_raw_write_lock(lock)
 #define read_lock(lock)		_raw_read_lock(lock)
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# define write_lock_nest_lock(lock, nest_lock)				\
+do {									\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);		\
+	preempt_disable();						\
+	lock_acquire_exclusive(&lock->dep_map, 0, 0, 			\
+			       &(nest_lock)->dep_map, _RET_IP_);	\
+	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);	\
+} while (0)
+#else
+# define write_lock_nest_lock(lock, nest_lock)	write_lock(lock)
+#endif
+
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 
 #define read_lock_irqsave(lock, flags)			\
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2955,7 +2955,7 @@ static void vm_lock_anon_vma(struct mm_s
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		write_lock(&anon_vma->root->rwlock);
+		write_lock_nest_lock(&anon_vma->root->rwlock);
 		/*
 		 * We can safely modify head.next after taking the
 		 * anon_vma->root->rwlock. If some other vma in this mm shares
