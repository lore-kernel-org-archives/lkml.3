Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab3H3TlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:41:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34659 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab3H3TlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 15:41:17 -0400
Date: Fri, 30 Aug 2013 20:40:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130830194059.GC13318@ZenIV.linux.org.uk>
References: <1377751465.4028.20.camel@pasglop>
 <20130829070012.GC27322@gmail.com>
 <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
 <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
 <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
 <52200DAE.2020303@hp.com>
 <CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
 <5220E56A.80603@hp.com>
 <CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com>
 <5220F090.5050908@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5220F090.5050908@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 03:20:48PM -0400, Waiman Long wrote:

> There are more contention in the lglock than I remember for the run
> in 3.10. This is an area that I need to look at. In fact, lglock is
> becoming a problem for really large machine with a lot of cores. We
> have a prototype 16-socket machine with 240 cores under development.
> The cost of doing a lg_global_lock will be very high in that type of
> machine given that it is already high in this 80-core machine. I
> have been thinking about instead of per-cpu spinlocks, we could
> change the locking to per-node level. While there will be more
> contention for lg_local_lock, the cost of doing a lg_global_lock
> will be much lower and contention within the local die should not be
> too bad. That will require either a per-node variable infrastructure
> or simulated with the existing per-cpu subsystem.

Speaking of lglock, there's a low-hanging fruit in that area: we have
no reason whatsoever to put anything but regular files with FMODE_WRITE
on the damn per-superblock list - the *only* thing it's used for is
mark_files_ro(), which will skip everything except those.  And since
read opens normally outnumber the writes quite a bit...  Could you
try the diff below and see if it changes the picture?  files_lglock
situation ought to get better...

diff --git a/fs/file_table.c b/fs/file_table.c
index b44e4c5..322cd37 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -385,6 +385,10 @@ static inline void __file_sb_list_add(struct file *file, struct super_block *sb)
  */
 void file_sb_list_add(struct file *file, struct super_block *sb)
 {
+	if (likely(!(file->f_mode & FMODE_WRITE)))
+		return;
+	if (!S_ISREG(file_inode(file)->i_mode))
+		return;
 	lg_local_lock(&files_lglock);
 	__file_sb_list_add(file, sb);
 	lg_local_unlock(&files_lglock);
@@ -450,8 +454,6 @@ void mark_files_ro(struct super_block *sb)
 
 	lg_global_lock(&files_lglock);
 	do_file_list_for_each_entry(sb, f) {
-		if (!S_ISREG(file_inode(f)->i_mode))
-		       continue;
 		if (!file_count(f))
 			continue;
 		if (!(f->f_mode & FMODE_WRITE))
