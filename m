Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3H3CGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 22:06:24 -0400
Received: from ozlabs.org ([203.10.76.45]:47687 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab3H3CGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 22:06:22 -0400
From: Michael Neuling <mikey@neuling.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless update of refcount
In-reply-to: <CA+55aFz4rJAAWopcSEJct55jUgCHY_6ZD=GSkKFmWanvd0otuw@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com> <1375758759-29629-2-git-send-email-Waiman.Long@hp.com> <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com> <1377751465.4028.20.camel@pasglop> <20130829070012.GC27322@gmail.com> <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com> <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com> <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com> <1377822408.4028.44.camel@pasglop> <CA+55aFz4rJAAWopcSEJct55jUgCHY_6ZD=GSkKFmWanvd0otuw@mail.gmail.com>
Comments: In-reply-to Linus Torvalds <torvalds@linux-foundation.org>
   message dated "Thu, 29 Aug 2013 17:49:46 -0700."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Fri, 30 Aug 2013 12:06:20 +1000
Message-ID: <29797.1377828380@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway, I'm attaching my completely mindless test program. It has
> hacky things like "unsigned long count[MAXTHREADS][32]" which are
> purely to just spread out the counts so that they aren't in the same
> cacheline etc.
> 
> Also note that the performance numbers it spits out depend a lot on
> tings like how long the dcache hash chains etc are, so they are not
> really reliable. Running the test-program right after reboot when the
> dentries haven't been populated can result in much higher numbers -
> without that having anything to do with contention or locking at all.

Running on a POWER7 here with 32 threads (8 cores x 4 threads) I'm
getting some good improvements:

  Without patch:
    # ./t
    Total loops: 3730618

  With patch:
    # ./t
    Total loops: 16826271

The numbers move around about 10% from run to run.  I didn't change your
program at all, so it's still running with MAXTHREADS 16.

powerpc patch below. I'm using arch_spin_is_locked() to implement
arch_spin_value_unlocked().

Mikey

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 9cf59816d..4a3f86b 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -139,6 +139,7 @@ config PPC
 	select OLD_SIGSUSPEND
 	select OLD_SIGACTION if PPC32
 	select HAVE_DEBUG_STACKOVERFLOW
+	select ARCH_USE_CMPXCHG_LOCKREF
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/powerpc/include/asm/spinlock.h b/arch/powerpc/include/asm/spinlock.h
index 5b23f91..65c25272 100644
--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -156,6 +156,11 @@ extern void arch_spin_unlock_wait(arch_spinlock_t *lock);
 	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
 #endif
 
+static __always_inline int arch_spin_value_unlocked(arch_spinlock_t lock)
+{
+	return !arch_spin_is_locked(&lock);
+}
+
 /*
  * Read-write spinlocks, allowing multiple readers
  * but only one writer.
