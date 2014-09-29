Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaI2BHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 21:07:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51656 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaI2BG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 21:06:59 -0400
Date: Mon, 29 Sep 2014 02:06:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mikhail Efremov <sem@altlinux.org>
Subject: [PATCH] missing data dependency barrier in prepend_name()
Message-ID: <20140929010656.GD7996@ZenIV.linux.org.uk>
References: <20140924201813.GI7996@ZenIV.linux.org.uk>
 <20140925044601.GL7996@ZenIV.linux.org.uk>
 <20140926164442.GA26897@ZenIV.linux.org.uk>
 <20140927044555.GS7996@ZenIV.linux.org.uk>
 <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
 <20140927183139.GT7996@ZenIV.linux.org.uk>
 <20140927191657.GU7996@ZenIV.linux.org.uk>
 <20140928074747.GZ7996@ZenIV.linux.org.uk>
 <20140928180556.GA7996@ZenIV.linux.org.uk>
 <20140928215138.GB7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928215138.GB7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 10:51:38PM +0100, Al Viro wrote:
> Hmm...  OK, dentry_cmp() is doing something similar to open-coded
> rcu_dereference().  prepend_name() does not, and I really wonder if
> that's correct...
> 
> I'm afraid that the answer is "should've been more careful when switching
> d_path() to RCU", but maybe there's something subtle I'm missing there...
> 
> I really hate memory ordering rules on alpha ;-/

AFAICS, prepend_name() is broken on SMP alpha.  Disclaimer: I don't have
SMP alpha boxen to reproduce it on.  However, it really looks like the race
is real.

CPU1: d_path() on /mnt/ramfs/<255-character>/foo
CPU2: mv /mnt/ramfs/<255-character> /mnt/ramfs/<63-character>

CPU2 does d_alloc(), which allocates an external name, stores the name there
including terminating NUL, does smp_wmb() and stores its address in
dentry->d_name.name.  It proceeds to d_add(dentry, NULL) and d_move()
old dentry over to that.  ->d_name.name value ends up in that dentry.

In the meanwhile, CPU1 gets to prepend_name() for that dentry.  It fetches
->d_name.name and ->d_name.len; the former ends up pointing to new name
(64-byte kmalloc'ed array), the latter - 255 (length of the old name).
Nothing to force the ordering there, and normally that would be OK, since we'd
run into the terminating NUL and stop.  Except that it's alpha, and we'd need
a data dependency barrier to guarantee that we see that store of NUL
__d_alloc() has done.  In a similar situation dentry_cmp() would survive; it
does explicit smp_read_barrier_depends() after fetching ->d_name.name.
prepend_name() doesn't and it risks walking past the end of kmalloc'ed object
and possibly oops due to taking a page fault in kernel mode.

Cc: stable@vger.kernel.org # 3.12+
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/dcache.c b/fs/dcache.c
index cb25a1a..e7484f9 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2810,6 +2810,9 @@ static int prepend(char **buffer, int *buflen, const char *str, int namelen)
  * the beginning of the name. The sequence number check at the caller will
  * retry it again when a d_move() does happen. So any garbage in the buffer
  * due to mismatched pointer and length will be discarded.
+ *
+ * Data dependency barrier is needed to make sure that we see that terminating
+ * NUL.  Alpha strikes again, film at 11...
  */
 static int prepend_name(char **buffer, int *buflen, struct qstr *name)
 {
@@ -2817,6 +2820,8 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
 	u32 dlen = ACCESS_ONCE(name->len);
 	char *p;
 
+	smp_read_barrier_depends();
+
 	*buflen -= dlen + 1;
 	if (*buflen < 0)
 		return -ENAMETOOLONG;
