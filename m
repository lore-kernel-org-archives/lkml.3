Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbaJZC40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 22:56:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41794 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaJZC4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 22:56:25 -0400
Date: Sun, 26 Oct 2014 02:56:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: fs: lockup on rename_mutex in fs/dcache.c:1035
Message-ID: <20141026025604.GL7996@ZenIV.linux.org.uk>
References: <544C50CB.4090408@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544C50CB.4090408@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 09:39:23PM -0400, Sasha Levin wrote:
> [ 6172.870045] trinity-c55/12752 is trying to acquire lock:
> [ 6172.870045] (rename_lock){+.+...}, at: d_walk (include/linux/spinlock.h:309 fs/dcache.c:1035)
> [ 6172.870045]
> [ 6172.870045] but task is already holding lock:
> [ 6172.870045] (rename_lock){+.+...}, at: d_walk (include/linux/spinlock.h:309 fs/dcache.c:1035)

Umm...  So we either have left d_walk() without dropping rename_lock, or
we have called d_walk() from something called from d_walk()?  And the
trace would seem to point towards the former...

Ouch.  For that to happen, we would need to
	* get to rename_retry with retry being true
	* after that get D_WALK_NORETRY from enter()
	* somehow get to rename_retry *again*

Moreover, we couldn't get there via
        if (need_seqretry(&rename_lock, seq)) {
                spin_unlock(&this_parent->d_lock);
                goto rename_retry;
- seq is 1 by that point, and need_seqretry() returns 0 in that case.  IOW,
it must have been this:
                /*
                 * might go back up the wrong parent if we have had a rename
                 * or deletion
                 */
                if (this_parent != child->d_parent ||
                         (child->d_flags & DCACHE_DENTRY_KILLED) ||
                         need_seqretry(&rename_lock, seq)) {
                        spin_unlock(&this_parent->d_lock);
                        rcu_read_unlock();
                        goto rename_retry;
                }
And we had been holding rename_lock in that walk, so d_move() should've
been excluded...  Which leaves us with
                         (child->d_flags & DCACHE_DENTRY_KILLED)
being true...  Hrm.  AFAICS, it *is* possible to hit that one - just have
the last reference to child dropped between
                spin_unlock(&child->d_lock);
and
                spin_lock(&this_parent->d_lock);
a few lines above.  And yes, if that happens we are in shit - rename_retry
will see retry being false and return, without noticing that on this pass
we had been holding rename_lock.  Easily fixed, fortunately - delta below
ought to take care of that...

Comments?  AFAICS, it's -stable fodder, the bug going all way back to
at least 3.7...

diff --git a/fs/dcache.c b/fs/dcache.c
index 3ffef7f..65f4aff 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1114,12 +1114,13 @@ resume:
 
 out_unlock:
 	spin_unlock(&this_parent->d_lock);
+out:
 	done_seqretry(&rename_lock, seq);
 	return;
 
 rename_retry:
 	if (!retry)
-		return;
+		goto out;
 	seq = 1;
 	goto again;
 }
